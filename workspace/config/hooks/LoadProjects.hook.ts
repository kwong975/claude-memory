/**
 * SessionStart Hook: Load Context Summary
 *
 * Injects a lean startup payload:
 * - Corrections & calibrations from MEMORIES.md (specific sections only)
 * - Active project summaries (name + next 3 items)
 * - Reference pointers
 *
 * Budget: <5KB total. Logs byte count to stderr for monitoring.
 */

import { readdirSync, readFileSync, existsSync, statSync } from "fs";
import { join, resolve } from "path";
import { getDevDir, getMemoryDir } from "./lib/paths";
import {
  parseFrontmatter,
  shouldLoad,
  extractTitle,
  extractNextItems,
  detectWorkspace,
} from "./lib/projects";

const devDir = getDevDir();
const memoryDir = getMemoryDir();
const projectsDir = join(memoryDir, "projects");
const memoriesFile = join(memoryDir, "MEMORIES.md");
const cwd = resolve(process.cwd());

// Safety net: skip any project body over this threshold even if frontmatter says active
const MAX_PROJECT_BODY_BYTES = 5120; // 5KB

function loadProjectSummaries(): string {
  if (!existsSync(projectsDir)) return "";

  const currentWorkspace = detectWorkspace(cwd, devDir);

  const files = readdirSync(projectsDir)
    .filter((f) => f.endsWith(".md") && !f.endsWith("-notes.md"))
    .filter((f) => statSync(join(projectsDir, f)).isFile())
    .sort();

  const summaries: string[] = [];

  for (const file of files) {
    const filePath = join(projectsDir, file);
    const raw = readFileSync(filePath, "utf-8").trim();
    const { workspace, status, body } = parseFrontmatter(raw);

    if (!shouldLoad(workspace, status, currentWorkspace)) continue;

    const bodyBytes = Buffer.byteLength(body, "utf-8");
    if (bodyBytes > MAX_PROJECT_BODY_BYTES) {
      console.error(
        `[LoadProjects] WARN ${file} — body ${bodyBytes} bytes (extracting summary only)`,
      );
    }

    const name = extractTitle(body) || file.replace(/\.md$/, "");
    const nextItems = extractNextItems(body);

    let summary = `- ${name}`;
    for (const item of nextItems) {
      summary += `\n  → ${item.slice(0, 80)}`;
    }
    summary += `\n  📎 ${memoryDir}/projects/${file}`;

    summaries.push(summary);
  }

  if (summaries.length === 0) return "";

  return `ACTIVE PROJECTS (${summaries.length}):\n\n${summaries.join("\n\n")}`;
}

function loadCorrections(): string {
  if (!existsSync(memoriesFile)) return "";
  const content = readFileSync(memoriesFile, "utf-8");

  const sections: string[] = [];

  // Extract specific sections: Calibrations, Preferences, Corrections
  const sectionPatterns = [
    /^## Explicit Calibrations\n([\s\S]*?)(?=\n## |\Z)/m,
    /^## Stated Preferences\n([\s\S]*?)(?=\n## |\Z)/m,
    /^## Behavioral Corrections\n([\s\S]*?)(?=\n## |\Z)/m,
  ];

  for (const pattern of sectionPatterns) {
    const match = content.match(pattern);
    if (match) {
      const body = match[1]
        .split("\n")
        .filter((l) => l.trimStart().startsWith("- "))
        .join("\n");
      if (body.trim()) sections.push(body);
    }
  }

  if (sections.length === 0) return "";

  return `CORRECTIONS & CALIBRATIONS:\n\n${sections.join("\n")}`;
}

// Build payload
const corrections = loadCorrections();
const projects = loadProjectSummaries();

const references = [
  `📎 Full memories: ${memoryDir}/MEMORIES.md`,
  `📎 Known issues: ${memoryDir}/known-issues/`,
].join("\n");

const parts = [corrections, projects, references].filter(Boolean);
const payload = parts.join("\n\n=====\n\n");

// Log byte count for budget monitoring
const byteCount = Buffer.byteLength(payload, "utf-8");
const kb = (byteCount / 1024).toFixed(1);
console.error(`[LoadProjects] payload: ${byteCount} bytes (${kb}KB)`);
if (byteCount > 5120) {
  console.error(`[LoadProjects] WARNING: payload exceeds 5KB budget (${kb}KB)`);
}

if (payload.trim()) process.stdout.write(payload);
