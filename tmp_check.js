"use strict";
const path = require('path');
const TESTS_DIR = path.resolve(__dirname, 'tests/conformance/eslint/tests/lib/rules');

let captured = null;
const { plugin } = require('bun');
plugin({ name: 'x', setup(build) {
  build.module('eslint', () => ({ loader: 'js', contents: `
export class RuleTester {
  constructor(c){ this._c = c||{}; }
  run(n,r,c){ if(global.__C__) global.__C__(n,r,c,this._c); }
  static get describe(){ return null; }
  static get it(){ return null; }
}
export const Linter = class {};
export default { RuleTester, Linter };
` }));
}});

global.__C__ = (n,r,c,d) => { captured = { all: [...(c.valid||[]),...(c.invalid||[])], d }; };
try { require(TESTS_DIR+'/no-implicit-globals.js'); } catch(e) { console.log('err:', e.message); }
if (captured) {
  console.log('N='+captured.all.length);
  for (let i=38;i<50;i++) {
    const tc=captured.all[i];
    const code=typeof tc==='string'?tc:tc.code;
    const lo=typeof tc==='string'?{}:(tc.languageOptions||{});
    const g = lo.globals ? Object.keys(lo.globals).slice(0,3).join(',') : null;
    console.log((i+1)+': '+JSON.stringify(code).slice(0,55)+' [globals='+g+']');
  }
}
