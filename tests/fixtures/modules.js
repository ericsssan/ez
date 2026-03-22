// Named imports
import { foo, bar } from './module.js';
import { default as main } from './module.js';
import { foo as f } from './module.js';

// Default import
import React from 'react';

// Namespace import
import * as utils from './utils.js';

// Side-effect import
import './polyfill.js';

// Mixed
import DefaultExport, { named1, named2 } from './mixed.js';

// Dynamic import
const module = await import('./dynamic.js');

// import.meta
const url = import.meta.url;

// Named exports
export { foo, bar };
export { foo as default };
export { foo as renamedFoo };

// Declaration exports
export const PI = 3.14;
export function helper() {}
export class MyClass {}

// Default exports
export default function() {}
export default class {}
export default 42;

// Re-exports
export * from './other.js';
export { foo } from './other.js';
export { foo as bar } from './other.js';
