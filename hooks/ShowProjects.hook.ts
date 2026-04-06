/**
 * SessionStart Hook: Display Active Projects
 *
 * Shows a compact project summary as a systemMessage the user sees it
 * in the terminal at session start.
 */

import { readdirSync, readFileSync, existsSync, statSync } from "fs";
import { join, resolve } from "path";
import { getDevDir, getMemoryDir } from "./lib/paths";

const devDir = getDevDir();
const memoryDir = getMemoryDir();
const projectsDir = join(memoryDir, "projects");
const cwd = resolve(process.cwd());

function detectWorkspace(): string {
  if (cwd.startsWith(devDir)) {
    const relative = cwd.slice(devDir.length + 1);
    const firstSegment = relative.split("/")[0];
    if (firstSegment) return firstSegment;
  }
  return "dev";
}

interface Project {
  name: string;
  status: string;
  nextItems: string[];
}

function parseFrontmatter(content: string): {
  workspace: string;
  status: string;
  body: string;
} {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { workspace: "dev", status: "active", body: content };
  const fm = match[1];
  const body = match[2].trim();
  const workspace = (fm.match(/^workspace:\s*(.+)$/m)?.[1] ?? "dev").trim();
  const status = (fm.match(/^status:\s*(.+)$/m)?.[1] ?? "active").trim();
  return { workspace, status, body };
}

function shouldLoad(
  workspace: string,
  status: string,
  currentWorkspace: string,
): boolean {
  if (status !== "active") return false;
  if (workspace === "all") return true;
  if (workspace === "dev") return true;
  if (currentWorkspace === "dev") return true;
  return workspace === currentWorkspace;
}

function extractNextItems(body: string): string[] {
  const nextMatch = body.match(/^## Next\n([\s\S]*?)(?=\n## |\n---|\Z)/m);
  if (!nextMatch) return [];
  const lines = nextMatch[1]
    .split("\n")
    .filter((l) => l.match(/^- \[ \]/))
    .map((l) => l.replace(/^- \[ \]\s*/, "").trim())
    .slice(0, 3);
  return lines;
}

function extractTitle(body: string): string {
  const m = body.match(/^# (?:Project:\s*)?(.+)$/m);
  return m ? m[1].trim() : "";
}

function loadProjects(): Project[] {
  if (!existsSync(projectsDir)) return [];
  const currentWorkspace = detectWorkspace();
  const files = readdirSync(projectsDir)
    .filter((f) => f.endsWith(".md") && !f.endsWith("-notes.md"))
    .filter((f) => statSync(join(projectsDir, f)).isFile())
    .sort();

  const projects: Project[] = [];
  for (const file of files) {
    const raw = readFileSync(join(projectsDir, file), "utf-8").trim();
    const { workspace, status, body } = parseFrontmatter(raw);
    if (!shouldLoad(workspace, status, currentWorkspace)) continue;
    const name = extractTitle(body) || file.replace(/\.md$/, "");
    const nextItems = extractNextItems(body);
    projects.push({ name, status, nextItems });
  }
  return projects;
}

const projects = loadProjects();
if (projects.length > 0) {
  const lines = [`Active Projects (${projects.length}):`];
  for (const p of projects) {
    lines.push(`  ${p.name}`);
    for (const item of p.nextItems) {
      lines.push(`    - ${item.slice(0, 70)}`);
    }
  }
  const output = JSON.stringify({ systemMessage: lines.join("\n") });
  process.stdout.write(output);
}
