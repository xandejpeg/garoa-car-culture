import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';
import { createReadStream, existsSync } from 'node:fs';
import { extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('.', import.meta.url));
const port = Number(process.env.ASSET_LAB_PORT || 5177);
const meshyApiKey = process.env.MESHY_API_KEY || '';
const maxBodyBytes = 35 * 1024 * 1024;

const contentTypes = new Map([
  ['.html', 'text/html; charset=utf-8'],
  ['.js', 'text/javascript; charset=utf-8'],
  ['.mjs', 'text/javascript; charset=utf-8'],
  ['.css', 'text/css; charset=utf-8'],
  ['.json', 'application/json; charset=utf-8'],
  ['.glb', 'model/gltf-binary'],
  ['.gltf', 'model/gltf+json'],
  ['.fbx', 'application/octet-stream'],
]);

const server = createServer(async (request, response) => {
  try {
    const url = new URL(request.url || '/', `http://${request.headers.host || 'localhost'}`);

    if (url.pathname === '/api/health') {
      return json(response, 200, { ok: true, meshyApiKeyConfigured: Boolean(meshyApiKey) });
    }

    if (url.pathname === '/api/meshy/retexture' && request.method === 'POST') {
      return createRetextureTask(request, response);
    }

    if (url.pathname.startsWith('/api/meshy/retexture/') && request.method === 'GET') {
      const taskId = decodeURIComponent(url.pathname.split('/').pop() || '');
      return getRetextureTask(response, taskId);
    }

    if (url.pathname === '/api/model-proxy' && request.method === 'GET') {
      return proxyModel(response, url.searchParams.get('url'));
    }

    return serveStatic(url.pathname, response);
  } catch (error) {
    console.error(error);
    return json(response, 500, { error: error.message || String(error) });
  }
});

server.listen(port, () => {
  console.log(`Garoa Asset Lab running at http://localhost:${port}/`);
  console.log(`Meshy API key: ${meshyApiKey ? 'configured' : 'missing'}`);
});

async function createRetextureTask(request, response) {
  if (!meshyApiKey) {
    return json(response, 401, { error: 'MESHY_API_KEY is not configured on the local server.' });
  }

  const input = await readJsonBody(request);
  const modelUrl = String(input.modelUrl || '');
  const inputTaskId = String(input.inputTaskId || '');
  const prompt = String(input.prompt || '').trim();

  if (!modelUrl && !inputTaskId) {
    return json(response, 400, { error: 'Provide a loaded model file or a Meshy input task id.' });
  }

  if (!prompt) {
    return json(response, 400, { error: 'Prompt is required.' });
  }

  const targetFormats = Array.isArray(input.targetFormats) && input.targetFormats.length
    ? input.targetFormats.filter((format) => ['glb', 'fbx', 'obj', 'stl', 'usdz', '3mf'].includes(format))
    : ['glb', 'fbx'];

  const body = {
    text_style_prompt: prompt.slice(0, 600),
    ai_model: input.aiModel || 'latest',
    enable_original_uv: Boolean(input.enableOriginalUv ?? true),
    enable_pbr: Boolean(input.enablePbr),
    hd_texture: Boolean(input.hdTexture),
    remove_lighting: true,
    target_formats: targetFormats,
  };

  if (inputTaskId) {
    body.input_task_id = inputTaskId;
  } else {
    body.model_url = modelUrl;
  }

  const result = await meshyFetch('/openapi/v1/retexture', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(body),
  });

  return json(response, 200, result);
}

async function getRetextureTask(response, taskId) {
  if (!meshyApiKey) {
    return json(response, 401, { error: 'MESHY_API_KEY is not configured on the local server.' });
  }

  if (!/^[a-zA-Z0-9_-]+$/.test(taskId)) {
    return json(response, 400, { error: 'Invalid task id.' });
  }

  const result = await meshyFetch(`/openapi/v1/retexture/${encodeURIComponent(taskId)}`);
  return json(response, 200, result);
}

async function meshyFetch(path, options = {}) {
  const apiResponse = await fetch(`https://api.meshy.ai${path}`, {
    ...options,
    headers: {
      authorization: `Bearer ${meshyApiKey}`,
      ...(options.headers || {}),
    },
  });

  const text = await apiResponse.text();
  let payload;
  try {
    payload = text ? JSON.parse(text) : {};
  } catch {
    payload = { raw: text };
  }

  if (!apiResponse.ok) {
    const message = payload?.message || payload?.error || payload?.task_error?.message || `Meshy API error ${apiResponse.status}`;
    const error = new Error(message);
    error.statusCode = apiResponse.status;
    error.payload = payload;
    throw error;
  }

  return payload;
}

async function proxyModel(response, rawUrl) {
  if (!rawUrl || !/^https:\/\//i.test(rawUrl)) {
    return json(response, 400, { error: 'A public https model URL is required.' });
  }

  const upstream = await fetch(rawUrl);
  if (!upstream.ok) {
    return json(response, upstream.status, { error: `Could not download model URL: ${upstream.status}` });
  }

  const contentType = upstream.headers.get('content-type') || 'application/octet-stream';
  response.writeHead(200, { 'content-type': contentType, 'cache-control': 'no-store' });
  const reader = upstream.body.getReader();
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    response.write(value);
  }
  response.end();
}

async function serveStatic(pathname, response) {
  const requestPath = pathname === '/' ? '/index.html' : pathname;
  const filePath = normalize(join(root, decodeURIComponent(requestPath)));

  if (!filePath.startsWith(root) || !existsSync(filePath)) {
    response.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' });
    response.end('Not found');
    return;
  }

  response.writeHead(200, { 'content-type': contentTypes.get(extname(filePath).toLowerCase()) || 'application/octet-stream' });
  createReadStream(filePath).pipe(response);
}

async function readJsonBody(request) {
  let size = 0;
  const chunks = [];

  for await (const chunk of request) {
    size += chunk.length;
    if (size > maxBodyBytes) {
      throw new Error('Request body too large. Use a smaller GLB/FBX or a public model URL.');
    }
    chunks.push(chunk);
  }

  return JSON.parse(Buffer.concat(chunks).toString('utf8') || '{}');
}

function json(response, statusCode, data) {
  response.writeHead(statusCode, { 'content-type': 'application/json; charset=utf-8' });
  response.end(JSON.stringify(data));
}