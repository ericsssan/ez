const fs = require('fs');
const {createLinter} = require('../js/api.js');
const rules = JSON.parse(process.argv[2]);
const file  = process.argv[3] || 'bench/fixtures/lodash.js';
const src = fs.readFileSync(require('path').resolve(file), 'utf8');
const t0 = performance.now();
(async () => {
  const L = await createLinter({rules});
  const d = await L(src, file);
  const ms = (performance.now() - t0).toFixed(0);
  process.stdout.write(ms + 'ms d=' + d.length + '\n');
})();
