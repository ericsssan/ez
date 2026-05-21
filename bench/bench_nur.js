"use strict";
if (typeof Bun === "undefined") { process.stderr.write("requires Bun\n"); process.exit(1); }
const path = require('path');
const ROOT = path.resolve(__dirname, '..');
const { lintSource } = require(path.join(ROOT, 'js/api.js'));
const src = require('fs').readFileSync(path.join(ROOT, 'bench/fixtures/typescript.js'), 'utf8');
const config = [{ rules: { 'no-useless-return': 'error' } }];
(async () => {
  for (let i = 0; i < 3; i++) await lintSource(src, { config, filename: 'typescript.js' });
  const t0 = performance.now();
  for (let i = 0; i < 10; i++) await lintSource(src, { config, filename: 'typescript.js' });
  const ms = performance.now() - t0;
  process.stdout.write(`10 runs: ${ms.toFixed(0)}ms  avg: ${(ms/10).toFixed(1)}ms/call\n`);
})();
