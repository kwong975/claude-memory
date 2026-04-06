/**
 * Stop Hook: StopGate
 *
 * Warn mode: runs fast verification (lint, then tests if lint passes) when Claude stops.
 * Detects repo type from cwd, scopes to touched repo.
 *
 * Always exits 0 (warn, never block). Injects results as additionalContext.
 * Times out at 30s. Fails open on any error.
 *
 * Note: Uses execSync intentionally — commands are predefined strings,
 * not user input. Shell injection is not a risk.
 */

import { existsSync, readFileSync } from "fs";
import { execSync } from "child_process";
import { resolve, join, dirname } from "path";
import { logEvent } from "./lib/log";

const cwd = resolve(process.cwd());
const TIMEOUT = 30000;
const OUTPUT_LIMIT = 30;

interface RepoInfo {
  type: "python" | "ts" | "mixed" | "none";
  dir: string;
  hasPytest: boolean;
  hasJsTest: boolean;
}

function detectRepo(): RepoInfo {
  let dir = cwd;
  let hasPyproject = false;
  let hasPackageJson = false;
  let hasPytest = false;
  let hasJsTest = false;
  let repoDir = cwd;

  while (dir.length > 1) {
    if (existsSync(join(dir, "pyproject.toml"))) {
      hasPyproject = true;
      repoDir = dir;
      try {
        const content = readFileSync(join(dir, "pyproject.toml"), "utf-8");
        hasPytest = content.includes("pytest");
      } catch {}
    }
    if (existsSync(join(dir, "package.json"))) {
      hasPackageJson = true;
      repoDir = dir;
      try {
        const content = readFileSync(join(dir, "package.json"), "utf-8");
        hasJsTest =
          content.includes("vitest") ||
          content.includes("jest") ||
          content.includes('"test"');
      } catch {}
    }
    if (hasPyproject || hasPackageJson) break;
    const parent = dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }

  if (hasPyproject && hasPackageJson)
    return { type: "mixed", dir: repoDir, hasPytest, hasJsTest };
  if (hasPyproject)
    return { type: "python", dir: repoDir, hasPytest, hasJsTest: false };
  if (hasPackageJson)
    return { type: "ts", dir: repoDir, hasPytest: false, hasJsTest };
  return { type: "none", dir: cwd, hasPytest: false, hasJsTest: false };
}

function run(
  cmd: string,
  runCwd: string,
  timeout: number,
): { ok: boolean; output: string } {
  try {
    const out = execSync(cmd, {
      cwd: runCwd,
      timeout,
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"],
    });
    const lines = (out || "")
      .trim()
      .split("\n")
      .slice(-OUTPUT_LIMIT)
      .join("\n");
    return { ok: true, output: lines };
  } catch (err: any) {
    const output = (err.stdout || err.stderr || err.message || "unknown error")
      .toString()
      .trim()
      .split("\n")
      .slice(-OUTPUT_LIMIT)
      .join("\n");
    return { ok: false, output };
  }
}

// Main
const repo = detectRepo();

if (repo.type === "none") process.exit(0);

const results: string[] = [];
let lintPassed = true;
let remainingTimeout = TIMEOUT;

// Python lint
if (repo.type === "python" || repo.type === "mixed") {
  const start = Date.now();
  const lint = run(
    "uvx ruff check . 2>&1 | head -20",
    repo.dir,
    Math.min(10000, remainingTimeout),
  );
  remainingTimeout -= Date.now() - start;
  if (!lint.ok) {
    lintPassed = false;
    results.push(`Python lint (ruff): FAILED\n${lint.output}`);
  }
}

// TS/JS lint
if (repo.type === "ts" || repo.type === "mixed") {
  const start = Date.now();
  const lint = run(
    "npx prettier --check src/ 2>&1 | tail -10",
    repo.dir,
    Math.min(10000, remainingTimeout),
  );
  remainingTimeout -= Date.now() - start;
  if (!lint.ok) {
    lintPassed = false;
    results.push(`TS format check (prettier): FAILED\n${lint.output}`);
  }
}

// Tests: only if lint passed and time remaining
if (lintPassed && remainingTimeout > 5000) {
  if ((repo.type === "python" || repo.type === "mixed") && repo.hasPytest) {
    const start = Date.now();
    const test = run(
      "uv run pytest -x -q --tb=short 2>&1 | head -30",
      repo.dir,
      Math.min(remainingTimeout - 2000, 25000),
    );
    remainingTimeout -= Date.now() - start;
    if (!test.ok) {
      results.push(`Python tests (pytest): FAILED\n${test.output}`);
    }
  }
  if ((repo.type === "ts" || repo.type === "mixed") && repo.hasJsTest) {
    const test = run(
      "bun test --bail 2>&1 | head -30",
      repo.dir,
      Math.min(remainingTimeout - 1000, 25000),
    );
    if (!test.ok) {
      results.push(`JS/TS tests: FAILED\n${test.output}`);
    }
  }
}

if (results.length === 0) process.exit(0);

const message = `⚠️ StopGate verification issues:\n\n${results.join("\n\n")}`;
logEvent("StopGate", "warn", `${results.length} issue(s) in ${repo.dir}`, {
  repoType: repo.type,
});

const output = JSON.stringify({
  hookSpecificOutput: {
    hookEventName: "Stop",
    additionalContext: message,
  },
});
process.stdout.write(output);
