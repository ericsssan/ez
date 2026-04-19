// Profile just the startup phase.  Loads ez + all 10 plugins, then exits
// so `bun --cpu-prof` captures only boot cost (no lint work).

const fs   = require("fs");
const path = require("path");

const tsInitRoot = path.resolve("bench/fixtures/extracted");
try { require("../js/ts-services").init(tsInitRoot); } catch {}

require("../js/api.js");
require("../js/load-plugin.js").loadCoreRules({});

const entries = [
  { prefix: "@typescript-eslint", pkg: "@typescript-eslint/eslint-plugin" },
  { prefix: "unicorn",            pkg: "eslint-plugin-unicorn"            },
  { prefix: "react",              pkg: "eslint-plugin-react"              },
  { prefix: "react-hooks",        pkg: "eslint-plugin-react-hooks"        },
  { prefix: "jsdoc",              pkg: "eslint-plugin-jsdoc"              },
  { prefix: "promise",            pkg: "eslint-plugin-promise"            },
  { prefix: "sonarjs",            pkg: "eslint-plugin-sonarjs"            },
  { prefix: "import",             pkg: "eslint-plugin-import"             },
  { prefix: "n",                  pkg: "eslint-plugin-n"                  },
  { prefix: "es-x",               pkg: "eslint-plugin-es-x"               },
];
for (const { pkg } of entries) {
  try {
    require(require.resolve(pkg, {
      paths: [path.resolve(__dirname, "../js"), process.cwd()],
    }));
  } catch {}
}
console.log("startup done");
