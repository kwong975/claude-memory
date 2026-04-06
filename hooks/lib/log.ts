import { appendFileSync } from "fs";
import { homedir } from "os";
import { join } from "path";

const LOG_FILE = join(homedir(), ".claude", "hook-calibration.jsonl");

interface LogEntry {
  timestamp: string;
  hook: string;
  event: "warn" | "block";
  detail: string;
  [key: string]: unknown;
}

export function logEvent(hook: string, event: "warn" | "block", detail: string, extra?: Record<string, unknown>): void {
  try {
    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      hook,
      event,
      detail,
      ...extra,
    };
    appendFileSync(LOG_FILE, JSON.stringify(entry) + "\n");
  } catch {
    // Fail silently — logging must never break hooks
  }
}
