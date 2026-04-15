"use strict";
// Load eslint-plugin-sonarjs from the central js/ package.
// The plugin is declared as a dependency in js/package.json — no separate install needed.
const path = require("path");
module.exports = require(path.resolve(__dirname, "../../../js/node_modules/eslint-plugin-sonarjs"));
