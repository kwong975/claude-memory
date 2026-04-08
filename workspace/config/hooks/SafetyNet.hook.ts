/**
 * PreToolUse Hook: SafetyNet
 *
 * Intercepts Bash commands before execution.
 * - Hard BLOCK (exit 2): destructive patterns (rm -rf broad, force push, push main)
 * - WARN (exit 0 + context): preference violations (pip, npm, yarn)
 * - Fails open: parse errors or unknown patterns → allow.
 */

import { readFileSync } from "fs";
import { logEvent } from "./lib/log";

interface HookInput {
  tool_input?: {
    command?: string;
  };
}

function parseInput(): HookInput {
  try {
    const raw = readFileSync("/dev/stdin", "utf-8").trim();
    return JSON.parse(raw);
  } catch {
    return {};
  }
}

interface BlockRule {
  pattern: RegExp;
  message: string;
}

interface WarnRule {
  pattern: RegExp;
  message: string;
}

// Hard block: destructive, irreversible actions
const BLOCK_RULES: BlockRule[] = [
  // rm -rf with broad/dangerous targets
  // Block: rm -rf /, rm -rf ~, rm -rf ., rm -rf .. , rm -rf (no path), rm -rf $VAR
  // Allow: rm -rf ./specific-dir/, rm -rf /Users/.../build/
  {
    pattern:
      /\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f|(-[a-zA-Z]*f[a-zA-Z]*r))\s+(\/\s|\/\s*$|~|\.\.?\/?\s|\.\.?\s*$|\$)/,
    message:
      "Blocked: broad `rm -rf` on dangerous target. Use a specific path: `rm -rf ./build/`",
  },
  // rm -rf with no path argument at all
  {
    pattern: /\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f|(-[a-zA-Z]*f[a-zA-Z]*r))\s*$/,
    message:
      "Blocked: `rm -rf` with no target path. Specify the exact directory.",
  },
  // git push to main/master (direct push, not via PR)
  {
    pattern: /\bgit\s+push\b.*\b(main|master)\b/,
    message:
      "Blocked: direct push to main/master. Push to a feature branch and open a PR.",
  },
  // git push --force (any target)
  {
    pattern: /\bgit\s+push\s+(-[a-zA-Z]*f|--force)(?!-with-lease)\b/,
    message:
      "Blocked: force push. Use `--force-with-lease` if you need to overwrite remote.",
  },
  // git reset --hard
  {
    pattern: /\bgit\s+reset\s+--hard\b/,
    message:
      "Blocked: `git reset --hard` discards changes. Use `git stash` or create a backup branch.",
  },
  // git checkout . or git restore . (discard all changes)
  {
    pattern: /\bgit\s+(checkout|restore)\s+\.\s*$/,
    message:
      "Blocked: discarding all changes. Restore specific files: `git restore <file>`",
  },
  // git clean -f (remove untracked files)
  {
    pattern: /\bgit\s+clean\s+-[a-zA-Z]*f/,
    message:
      "Blocked: `git clean -f` removes untracked files. Be specific about what to remove.",
  },
];

// Warn: preference violations — wrong package manager
const WARN_RULES: WarnRule[] = [
  {
    pattern: /\bpip\s+install\b/,
    message: "⚠️ Prefer `uv add` or `uv pip install` over `pip install`.",
  },
  {
    pattern: /\bnpm\s+(install|i|add)\b/,
    message: "⚠️ Prefer `bun add` over `npm install`.",
  },
  {
    pattern: /\bnpm\s+run\b/,
    message: "⚠️ Prefer `bun run` over `npm run`.",
  },
  {
    pattern: /\byarn\s+(add|install|run)\b/,
    message: "⚠️ Prefer `bun` over `yarn`.",
  },
];

// Main
const input = parseInput();
const command = input.tool_input?.command?.trim();

if (!command) process.exit(0);

// Strip tokens, keys, passwords from commands before logging
function sanitizeForLog(cmd: string): string {
  return cmd
    .replace(
      /\b(token|key|password|secret|credential)s?\s*[=:]\s*\S+/gi,
      "$1=***",
    )
    .replace(/\b(Bearer|Basic)\s+\S+/gi, "$1 ***")
    .replace(/\b[A-Za-z0-9_-]{20,}\b/g, (match) =>
      /^(node_modules|force-with-lease|pyproject|package)/.test(match)
        ? match
        : "***",
    );
}

// Check hard block rules first
for (const rule of BLOCK_RULES) {
  if (rule.pattern.test(command)) {
    logEvent("SafetyNet", "block", rule.message, {
      command: sanitizeForLog(command),
    });
    process.stderr.write(rule.message);
    process.exit(2);
  }
}

// Check warn rules
for (const rule of WARN_RULES) {
  if (rule.pattern.test(command)) {
    logEvent("SafetyNet", "warn", rule.message, {
      command: sanitizeForLog(command),
    });
    const result = JSON.stringify({
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        additionalContext: rule.message,
      },
    });
    process.stdout.write(result);
    process.exit(0);
  }
}

// No match — allow silently
process.exit(0);
