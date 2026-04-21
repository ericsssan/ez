"use strict";

/**
 * Tight loop around a single parser for profiling under samply.
 * Which parser and which fixture are picked via env or args.
 *
 * Usage:
 *   BENCH_PARSER=ez  bun bench/bench_parser_loop.js typescript.js 100
 *   BENCH_PARSER=oxc bun bench/bench_parser_loop.js typescript.js 100
 */

const fs = require("fs");
const path = require("path");

const which = process.env.BENCH_PARSER || "ez";
const fixture = process.argv[2] || "three.js";
const iters = parseInt(process.argv[3] || "200", 10);

const src = fs.readFileSync(path.join(__dirname, "fixtures", fixture), "utf-8");

if (which === "ez") {
  const { parseSource: ezParse, reset } = require("../js/index");
  for (let i = 0; i < iters; i++) {
    ezParse(src, { filename: fixture });
    reset();
  }
} else if (which === "oxc") {
  const { parseSync } = require("oxc-parser");
  for (let i = 0; i < iters; i++) {
    parseSync(fixture, src);
  }
} else {
  throw new Error(`Unknown BENCH_PARSER=${which}`);
}
