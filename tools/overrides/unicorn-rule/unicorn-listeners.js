// === ez build-time substitute for eslint-plugin-unicorn/rules/rule/unicorn-listeners.js ===
//
// The upstream version dispatches each selector through a generator
// pipeline: an outer `function* (...args) { for (const l of listeners)
// yield l(...args); }` wraps the rule's own (often-generator) listener,
// then `iterateFixOrProblems` recursively unwraps the result via
// `yield*`. Profile of typescript.js attributes ~25% of unicorn rule
// cost to that pipeline:
//
//   anonymous wrapper at unicorn-listeners.js:55  ~5.7% self
//   anonymous closure  at unicorn-listeners.js:53  ~4.3% self
//   isIterable                                    ~10.3% self
//   iterateFixOrProblems                          ~3% self
//   copyDataProperties + generatorResume          ~10% (engine, generator state)
//
// The pipeline is purely a fan-out + drain — no state, no async, no
// laziness benefit (consumers always drain to completion immediately).
// We replace it with direct iteration:
//
//   eslintListeners[selector] = (...args) => {
//     for (const listener of listeners) drainAndReport(context, listener(...args));
//   };
//
// `drainAndReport` is a non-generator equivalent of `iterateFixOrProblems
// + toEslintListener`'s body. Same observable behavior:
//   - `undefined`/`null` → no-op
//   - array → recurse over elements
//   - iterable (e.g. rule's own `function* check()`) → drain via for-of
//   - plain problem object → context.report(toEslintProblem(p))
//
// `toEslintProblem` is inlined to avoid one more import hop. Fixes go
// through the upstream `to-eslint-rule-fixer` (still imported) so that
// fixer behavior (which itself uses `iterateFixOrProblems` for nested
// fix sequences) stays identical.

import toEslintFixer from './to-eslint-rule-fixer.js';

class UnicornListeners {
	#context;
	#listeners = new Map();

	constructor(context) {
		this.#context = context;
	}

	#addEventListener(selectors, listener) {
		const listeners = this.#listeners;
		for (const selector of selectors) {
			if (listeners.has(selector)) {
				listeners.get(selector).push(listener);
			} else {
				listeners.set(selector, [listener]);
			}
		}
	}

	on(selectorOrSelectors, listener) {
		const selectors = Array.isArray(selectorOrSelectors) ? selectorOrSelectors : [selectorOrSelectors];
		this.#addEventListener(selectors, listener);
	}

	onExit(selectorOrSelectors, listener) {
		const selectors = Array.isArray(selectorOrSelectors) ? selectorOrSelectors : [selectorOrSelectors];
		this.#addEventListener(selectors.map(selector => `${selector}:exit`), listener);
	}

	toEslintListeners() {
		const eslintListeners = {};
		const context = this.#context;
		for (const [selector, listeners] of this.#listeners) {
			eslintListeners[selector] = (...listenerArguments) => {
				for (let i = 0, n = listeners.length; i < n; i++) {
					_drainAndReport(context, listeners[i](...listenerArguments));
				}
			};
		}
		return eslintListeners;
	}
}

function _drainAndReport(context, value) {
	if (value === undefined || value === null) return;
	if (Array.isArray(value)) {
		for (let i = 0, n = value.length; i < n; i++) _drainAndReport(context, value[i]);
		return;
	}
	if (typeof value === 'object' && typeof value[Symbol.iterator] === 'function') {
		for (const item of value) _drainAndReport(context, item);
		return;
	}
	if (typeof value === 'object') {
		context.report(_toEslintProblem(value));
	}
}

function _toEslintProblem(unicornProblem) {
	const eslintProblem = {...unicornProblem};
	if (unicornProblem.fix) {
		eslintProblem.fix = toEslintFixer(unicornProblem.fix);
	}
	if (Array.isArray(unicornProblem.suggest)) {
		eslintProblem.suggest = unicornProblem.suggest.map(unicornSuggest => ({
			...unicornSuggest,
			fix: toEslintFixer(unicornSuggest.fix),
			data: {
				...unicornProblem.data,
				...unicornSuggest.data,
			},
		}));
	}
	return eslintProblem;
}

export default UnicornListeners;
