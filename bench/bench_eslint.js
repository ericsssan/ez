const path = require("path");
const root = path.resolve(__dirname, "..");
const { ESLint } = require(path.join(root, "js/node_modules/eslint"));
const js = require(path.join(root, "js/node_modules/@eslint/js"));

async function main() {
  const corpus = process.argv[2] || path.join(root, "tests/conformance/test262-parser-tests/pass/");
  const linter = new ESLint({
    cwd: path.resolve(corpus),
    overrideConfigFile: true,
    overrideConfig: [{ files: ["**/*.js", "**/*.ts"], ...js.configs.all }],
    ignore: false,
  });
  const results = await linter.lintFiles(".");
  let total = 0;
  for (const r of results) total += r.messages.length;
  process.stderr.write(`${results.length} files, ${total} problems\n`);
  process.exit(total > 0 ? 1 : 0);
}
main().catch(e => { console.error(e.message); process.exit(1); });
