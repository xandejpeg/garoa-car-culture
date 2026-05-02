import { mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { randomUUID } from 'node:crypto';
import { DatabaseSync } from 'node:sqlite';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('.', import.meta.url));
const dbPath = process.env.ASSET_LAB_DB || join(root, 'data', 'asset-lab.sqlite');

mkdirSync(dirname(dbPath), { recursive: true });

const db = new DatabaseSync(dbPath);
db.exec('PRAGMA journal_mode = WAL');
db.exec('PRAGMA foreign_keys = ON');

db.exec(`
CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS models (
  id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL,
  name TEXT NOT NULL,
  format TEXT,
  source_kind TEXT,
  source_task_id TEXT,
  size_bytes INTEGER,
  meshes INTEGER,
  triangles INTEGER,
  materials INTEGER,
  dimensions_json TEXT,
  roles_json TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(id)
);

CREATE TABLE IF NOT EXISTS chat_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL,
  model_id TEXT,
  user_text TEXT NOT NULL,
  assistant_text TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(id),
  FOREIGN KEY (model_id) REFERENCES models(id)
);

CREATE TABLE IF NOT EXISTS modifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL,
  model_id TEXT,
  command_text TEXT NOT NULL,
  action TEXT,
  target_roles_json TEXT,
  color_hex TEXT,
  result_text TEXT,
  snapshot_json TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(id),
  FOREIGN KEY (model_id) REFERENCES models(id)
);

CREATE TABLE IF NOT EXISTS meshy_tasks (
  task_id TEXT PRIMARY KEY,
  session_id TEXT,
  model_id TEXT,
  prompt TEXT,
  status TEXT,
  progress INTEGER,
  consumed_credits INTEGER,
  request_json TEXT,
  response_json TEXT,
  model_urls_json TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES sessions(id),
  FOREIGN KEY (model_id) REFERENCES models(id)
);

CREATE TABLE IF NOT EXISTS meshy_outputs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT NOT NULL,
  format TEXT NOT NULL,
  remote_url TEXT,
  local_path TEXT,
  file_size INTEGER,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(task_id, format),
  FOREIGN KEY (task_id) REFERENCES meshy_tasks(task_id)
);
`);

export function databaseInfo() {
  return { path: dbPath };
}

export function ensureSession(id = randomUUID()) {
  const sessionId = String(id || randomUUID()).slice(0, 80);
  db.prepare(`
    INSERT INTO sessions (id) VALUES (?)
    ON CONFLICT(id) DO UPDATE SET last_seen_at = CURRENT_TIMESTAMP
  `).run(sessionId);
  return sessionId;
}

export function insertModel(input) {
  const id = randomUUID();
  const sessionId = ensureSession(input.sessionId);
  db.prepare(`
    INSERT INTO models (
      id, session_id, name, format, source_kind, source_task_id, size_bytes,
      meshes, triangles, materials, dimensions_json, roles_json
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    id,
    sessionId,
    input.name || 'unnamed-model',
    input.format || null,
    input.sourceKind || null,
    input.sourceTaskId || null,
    integerOrNull(input.sizeBytes),
    integerOrNull(input.meshes),
    integerOrNull(input.triangles),
    integerOrNull(input.materials),
    stringify(input.dimensions),
    stringify(input.roles),
  );
  return { id, sessionId };
}

export function insertChat(input) {
  const sessionId = ensureSession(input.sessionId);
  const result = db.prepare(`
    INSERT INTO chat_messages (session_id, model_id, user_text, assistant_text)
    VALUES (?, ?, ?, ?)
  `).run(sessionId, input.modelId || null, input.userText || '', input.assistantText || '');
  return { id: result.lastInsertRowid, sessionId };
}

export function insertModification(input) {
  const sessionId = ensureSession(input.sessionId);
  const result = db.prepare(`
    INSERT INTO modifications (
      session_id, model_id, command_text, action, target_roles_json,
      color_hex, result_text, snapshot_json
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    sessionId,
    input.modelId || null,
    input.commandText || '',
    input.action || null,
    stringify(input.targetRoles),
    input.colorHex || null,
    input.resultText || null,
    stringify(input.snapshot),
  );
  return { id: result.lastInsertRowid, sessionId };
}

export function upsertMeshyTask(input) {
  if (!input.taskId) return null;
  const sessionId = input.sessionId ? ensureSession(input.sessionId) : null;
  db.prepare(`
    INSERT INTO meshy_tasks (
      task_id, session_id, model_id, prompt, status, progress, consumed_credits,
      request_json, response_json, model_urls_json
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(task_id) DO UPDATE SET
      session_id = COALESCE(excluded.session_id, meshy_tasks.session_id),
      model_id = COALESCE(excluded.model_id, meshy_tasks.model_id),
      prompt = COALESCE(excluded.prompt, meshy_tasks.prompt),
      status = COALESCE(excluded.status, meshy_tasks.status),
      progress = COALESCE(excluded.progress, meshy_tasks.progress),
      consumed_credits = COALESCE(excluded.consumed_credits, meshy_tasks.consumed_credits),
      request_json = COALESCE(excluded.request_json, meshy_tasks.request_json),
      response_json = COALESCE(excluded.response_json, meshy_tasks.response_json),
      model_urls_json = COALESCE(excluded.model_urls_json, meshy_tasks.model_urls_json),
      updated_at = CURRENT_TIMESTAMP
  `).run(
    input.taskId,
    sessionId,
    input.modelId || null,
    input.prompt || null,
    input.status || null,
    integerOrNull(input.progress),
    integerOrNull(input.consumedCredits),
    stringify(input.request),
    stringify(input.response),
    stringify(input.modelUrls),
  );
  return { taskId: input.taskId, sessionId };
}

export function upsertMeshyOutput(input) {
  if (!input.taskId || !input.format) return null;
  const result = db.prepare(`
    INSERT INTO meshy_outputs (task_id, format, remote_url, local_path, file_size)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(task_id, format) DO UPDATE SET
      remote_url = COALESCE(excluded.remote_url, meshy_outputs.remote_url),
      local_path = COALESCE(excluded.local_path, meshy_outputs.local_path),
      file_size = COALESCE(excluded.file_size, meshy_outputs.file_size)
  `).run(
    input.taskId,
    input.format,
    input.remoteUrl || null,
    input.localPath || null,
    integerOrNull(input.fileSize),
  );
  return { id: result.lastInsertRowid, taskId: input.taskId, format: input.format };
}

export function historySummary(limit = 80) {
  return {
    database: dbPath,
    sessions: db.prepare('SELECT * FROM sessions ORDER BY last_seen_at DESC LIMIT ?').all(limit),
    models: db.prepare('SELECT * FROM models ORDER BY created_at DESC LIMIT ?').all(limit),
    chat: db.prepare('SELECT * FROM chat_messages ORDER BY id DESC LIMIT ?').all(limit),
    modifications: db.prepare('SELECT * FROM modifications ORDER BY id DESC LIMIT ?').all(limit),
    meshyTasks: db.prepare('SELECT * FROM meshy_tasks ORDER BY updated_at DESC LIMIT ?').all(limit),
    meshyOutputs: db.prepare('SELECT * FROM meshy_outputs ORDER BY id DESC LIMIT ?').all(limit),
  };
}

function stringify(value) {
  if (value === undefined || value === null) return null;
  return JSON.stringify(value);
}

function integerOrNull(value) {
  const number = Number(value);
  return Number.isFinite(number) ? Math.round(number) : null;
}