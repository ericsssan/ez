#!/usr/bin/env node
/**
 * Fix native Zig rule messages to match ESLint's exact message templates.
 * Only fixes static messages (no {{interpolation}}).
 * Run: node scripts/fix-native-messages.js [--dry-run]
 */
const fs = require('fs');
const path = require('path');

const msgs = require('./eslint-message-templates.json');
const dryRun = process.argv.includes('--dry-run');

let fixed = 0, skipped = 0, files = 0;

for (const [rule, messages] of Object.entries(msgs)) {
  const zigName = rule.replace(/-/g, '_');
  let zigPath = null;
  for (const dir of ['correctness', 'suspicious', 'style']) {
    const p = path.join('src/linter/native', dir, zigName + '.zig');
    if (fs.existsSync(p)) { zigPath = p; break; }
  }
  if (!zigPath) continue;

  let zigSrc = fs.readFileSync(zigPath, 'utf8');
  let modified = false;

  // For each ESLint message, find corresponding ctx.report calls
  for (const [msgId, template] of Object.entries(messages)) {
    // Skip templates with interpolation — need manual handling
    if (template.includes('{{')) continue;

    // Escape the template for Zig string literal
    const zigStr = template.replace(/\\/g, '\\\\').replace(/"/g, '\\"');

    // Find ctx.report(..., "current message", ...) calls and check if message differs
    const reportRegex = /ctx\.report(?:Span)?\([^)]*,\s*meta\.name,\s*"([^"]+)"/g;
    let match;
    while ((match = reportRegex.exec(zigSrc)) !== null) {
      const currentMsg = match[1];
      if (currentMsg === zigStr) continue; // already matches

      // Check if this is a plausible match (same rule, similar topic)
      // For rules with only ONE message, replace all occurrences
      const staticMsgs = Object.entries(messages).filter(([, t]) => !t.includes('{{'));
      if (staticMsgs.length === 1) {
        // Single static message — replace all
        const oldStr = `"${currentMsg}"`;
        const newStr = `"${zigStr}"`;
        if (zigSrc.includes(oldStr)) {
          zigSrc = zigSrc.split(oldStr).join(newStr);
          modified = true;
          fixed++;
        }
      }
    }
  }

  if (modified) {
    files++;
    if (dryRun) {
      console.log(`[dry-run] Would fix: ${zigPath}`);
    } else {
      fs.writeFileSync(zigPath, zigSrc);
      console.log(`Fixed: ${zigPath}`);
    }
  }
}

console.log(`\n${dryRun ? '[DRY RUN] ' : ''}Fixed ${fixed} messages in ${files} files, skipped ${skipped}`);
