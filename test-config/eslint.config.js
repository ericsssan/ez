const react = require("eslint-plugin-react");
const reactHooks = require("eslint-plugin-react-hooks");
const unicorn = require("eslint-plugin-unicorn");
const promise = require("eslint-plugin-promise");
const jsdoc = require("eslint-plugin-jsdoc");

module.exports = [
  {
    plugins: {
      react,
      "react-hooks": reactHooks,
      unicorn,
      promise,
      jsdoc,
    },
    rules: {
      // Core ESLint rules
      "no-var": "warn",
      "no-debugger": "error",
      "eqeqeq": "warn",
      "no-unused-vars": "warn",

      // React
      "react/jsx-no-undef": "error",
      "react/no-deprecated": "warn",

      // React Hooks
      "react-hooks/rules-of-hooks": "error",

      // Unicorn
      "unicorn/no-null": "warn",
      "unicorn/prefer-number-properties": "warn",

      // Promise
      "promise/no-return-wrap": "error",
      "promise/param-names": "error",

      // JSDoc
      "jsdoc/require-jsdoc": "warn",
    },
  },
];
