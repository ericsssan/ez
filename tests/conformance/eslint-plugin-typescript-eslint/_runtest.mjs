import { Linter } from 'eslint';
import tseslint from '@typescript-eslint/eslint-plugin';
import * as parser from '@typescript-eslint/parser';
const linter = new Linter({ configType: 'flat' });
const src = `enum Enum { A = 'A', B = 'A' }\n\ntype Intersection = \`\${Enum1.A & string}\`;`;
const cfg = [
  { files: ['**/*.ts'], languageOptions: { parser, parserOptions: { projectService: { allowDefaultProject: ['*.ts'] } } } },
  { files: ['**/*.ts'], plugins: { '@typescript-eslint': tseslint }, rules: { '@typescript-eslint/no-unnecessary-template-expression': 'error' } },
];
const res = linter.verify(src, cfg, 'test.ts');
console.log('case 52:', JSON.stringify(res));

const src2 = "`${String(Symbol.for('test'))}`;";
const res2 = linter.verify(src2, cfg, 'test.ts');
console.log('case 73:', JSON.stringify(res2));
