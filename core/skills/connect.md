---
scope: shared
argument-hint: diagnostic connection check
---

# ArcOS Connection Diagnostic

Check whether Claude Code is properly connected to the ArcOS (Arcanian OS) stack. Runs all checks via Bash (not MCP) so it works even when MCP is broken.

Works in two scenarios:
- **Local (same machine as ArcOS)**: uses `docker exec` directly
- **Remote (different machine)**: connects over HTTP to the MCP endpoint

## Arguments: $ARGUMENTS

Supported modes:
- *(no argument)* — Full diagnostic (all checks)
- `tools` — List all 36 MCP tools by category
- `health` — API health checks only
- `docker` — Docker and container status only (local mode)
- `setup` — Create `.mcp.json` for local connection
- `setup http://host:8001` — Create `.mcp.json` for remote HTTP connection
- `install` — Copy this skill to `~/.claude/commands/` so it works globally

## Instructions

### Parse the argument

Set `MODE` based on `$ARGUMENTS`:
- If empty or missing → `full`
- If `tools` → `tools`
- If `health` → `health`
- If `docker` → `docker`
- If starts with `setup` → `setup` (capture the rest as `REMOTE_URL`, may be empty)
- If `install` → `install`
- Otherwise → show usage and stop

### Detect connection mode

Before running checks, determine whether ArcOS is local or remote by reading `.mcp.json` (if it exists):

Use Bash: `python3 -c "
import json
try:
    c = json.load(open('.mcp.json'))
    srv = c.get('mcpServers', {}).get('arcos-agents', {})
    if srv.get('type') == 'http':
        print('remote:' + srv.get('url', ''))
    else:
        print('local')
except:
    print('unknown')
" 2>&1`

Set:
- `CONNECTION = local` if output is `local` or `unknown`
- `CONNECTION = remote` and `MCP_URL = <url>` if output starts with `remote:`
- Extract `REMOTE_HOST` from `MCP_URL` (the hostname/IP portion, e.g. from `http://192.168.1.50:8001/mcp` extract `192.168.1.50`)

---

### If MODE is `install`

Use Bash to copy this skill to the global commands directory:

```bash
mkdir -p ~/.claude/commands && cp .claude/commands/connect.md ~/.claude/commands/connect.md
```

- Success → "Installed `/connect` globally at `~/.claude/commands/connect.md`. It will now work in every Claude Code session on this machine."
- Failure → Show the error and suggest copying the file manually.

Stop after install.

---

### If MODE is `setup`

**If `REMOTE_URL` is provided** (e.g. `/connect setup http://192.168.1.50:8001`):

Normalize the URL: if it doesn't end with `/mcp`, append `/mcp`. If it doesn't start with `http`, prepend `http://`.

First verify the endpoint is reachable:
```bash
curl -sf REMOTE_URL -o /dev/null -w "%{http_code}" 2>/dev/null
```
- If reachable (any response) → continue
- If not → `[WARN] Cannot reach REMOTE_URL — make sure ArcOS is running with MCP_TRANSPORT=http`

Then check `.mcp.json`:
- If it exists and already has `arcos-agents` with type `http` → "Already configured. Run `/connect` to verify."
- If it doesn't exist → create it with:

```json
{
  "mcpServers": {
    "arcos-agents": {
      "type": "http",
      "url": "REMOTE_URL"
    }
  }
}
```

If `.mcp.json` exists with other servers but no `arcos-agents`, show how to add the entry to the existing file.

**If `REMOTE_URL` is NOT provided** (local setup):

- If `.mcp.json` exists and already has `arcos-agents` → "Already configured for ArcOS. Run `/connect` to verify."
- If it doesn't exist → create it with:

```json
{
  "mcpServers": {
    "arcos-agents": {
      "command": "docker",
      "args": [
        "exec",
        "-i",
        "arcosv3-python-api-1",
        "python",
        "mcp_server.py"
      ],
      "env": {}
    }
  }
}
```

After creating, tell the user:
- "Created `.mcp.json` in current directory."
- If remote: "Configured for remote connection to `REMOTE_URL`."
- "Restart Claude Code (`/exit` then `claude`) to pick up the new MCP config."
- "Then run `/connect` to verify everything works."

Stop after setup.

---

### If MODE is `tools`

Display all 36 tools organized by category. Use this exact listing:

```
ARCOS MCP TOOLS — 36 tools across 16 categories

MEMORY (4)
  search_memories    Search knowledge base by subtype/client/project
  get_memory         Get a single memory by UUID
  create_memory      Create a new memory
  update_memory      Update an existing memory

SKILLS (3)
  search_skills      Search skills by category
  get_skill          Get a skill by UUID
  load_skill         Load skill instructions into AI context

CAPTAIN'S LOG (1)
  captain_log        Create a journal entry

CONTEXT BUNDLING (1)
  get_context        Bundle project/client context

FIREFLIES (2)
  sync_fireflies     Sync a Fireflies transcript into ArcOS
  list_fireflies     List available transcripts

SEMANTIC SEARCH (2)
  semantic_search    Natural language search across all content
  find_similar       Find similar content by UUID

ONTOLOGY (4)
  ontology_describe       Describe an object type
  ontology_graph          Full ontology graph
  ontology_transitions    Valid lifecycle transitions
  ontology_execute_action Execute an ontology action

PERSON / CONTACT (2)
  search_persons     Search contacts by role/client
  create_person      Create a new person/contact

AUDIT TRAIL (1)
  audit_trail        Query CRUD operations and system actions

MARKDOWN EXPORT (1)
  export_markdown    Export content to Markdown with frontmatter

ASANA (3)
  asana_search         Search Asana tasks
  asana_create_task    Create an Asana task
  asana_complete_task  Complete an Asana task

QUEUE & SCHEDULER (3)
  queue_status         Background queue lengths
  scheduler_status     Scheduled task status
  scheduler_run_task   Manually trigger a task

MEETING INTELLIGENCE (3)
  meeting_query          Ask questions about meetings
  meeting_extract_tasks  Extract tasks from a meeting
  meeting_summarize      Summarize a meeting

BRAND VOICE & DOCUMENTS (2)
  generate_document    Generate a branded document
  apply_brand_voice    Rewrite text in brand voice

PERSON INTELLIGENCE (3)
  person_profile       Communication profile for a person
  person_brief         Pre-meeting communication brief
  relationship_map     Map persons connected to a client

HEALTH (1)
  check_health         System health check
```

Stop after displaying the tool list — do not run diagnostics.

---

### If MODE is `full`, `health`, or `docker`

Run the applicable checks below. Track pass/fail counts and display results as you go.

First, show the connection mode:
```
Connection: local (docker exec)
```
or:
```
Connection: remote (http://host:8001/mcp)
```

**Display format for each check:**
```
[PASS] Check description
[FAIL] Check description — error details
[WARN] Check description — warning details
[SKIP] Check description — reason
```

---

### Check 1: Docker / MCP endpoint reachable (MODE: full, docker)

**If local:**
- Run: `docker info > /dev/null 2>&1`
- Exit 0 → `[PASS] Docker is running`
- Non-zero → `[FAIL] Docker is not running — start Docker Desktop first` and stop.

**If remote:**
- Run: `curl -sf MCP_URL -o /dev/null -w "%{http_code}" 2>/dev/null`
- Any response → `[PASS] MCP endpoint reachable at MCP_URL`
- No response → `[FAIL] MCP endpoint not reachable at MCP_URL — is ArcOS running with MCP_TRANSPORT=http?` and stop.

### Check 2: Python-api container running (MODE: full, docker — local only)

**If local:**
- Run: `docker inspect --format '{{.State.Status}}' arcosv3-python-api-1 2>/dev/null`
- Output is `running` → `[PASS] python-api container is running`
- Otherwise → `[FAIL] python-api container not running`

**If remote:** Skip — `[SKIP] Container check (remote mode — checking HTTP endpoint instead)`

### Check 3: All containers (MODE: full, docker — local only)

**If local:**
- Run: `docker ps --filter "name=arcosv3-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null`
- Display the output as a formatted table
- Count running containers
- Expected: 6 core (nginx, drupal, db, python-api, redis, node) + 2 optional (qdrant, ollama)
- All 6 core running → `[PASS] All 6 core containers running`
- Any core missing → `[FAIL] Missing containers: <list>`

**If remote:** Skip — `[SKIP] Container listing (remote mode)`

### Check 4: .mcp.json in current project (MODE: full)

Check if `.mcp.json` exists in the current working directory.

- If exists and valid JSON → `[PASS] .mcp.json exists and is valid JSON`
- If exists but invalid → `[FAIL] .mcp.json exists but is not valid JSON`
- If missing → `[WARN] No .mcp.json in current directory — run /connect setup to create one`

Also check it references arcos-agents:
- Has `arcos-agents` → `[PASS] .mcp.json has arcos-agents server configured`
- Missing → `[WARN] .mcp.json exists but no arcos-agents entry`

If CONNECTION is remote, verify config uses HTTP:
- `type` is `http` → `[PASS] Configured for remote HTTP connection`
- `type` is not `http` → `[WARN] .mcp.json uses stdio — for remote use /connect setup http://host:8001`

### Check 5: MCP server imports (MODE: full — local only)

**If local:**
- Run: `docker exec arcosv3-python-api-1 python -c "from mcp_server import server; print('OK')" 2>&1`
- Output contains "OK" → `[PASS] MCP server module imports successfully`
- Error → `[FAIL] MCP server import failed` — show the error

**If remote:** Skip — `[SKIP] Import check (remote mode)`

### Check 6: Drupal JSON:API responding (MODE: full, health)

**If local:**
- Run: `curl -sf http://localhost:8080/jsonapi -o /dev/null -w "%{http_code}" 2>/dev/null`

**If remote:**
- Run: `curl -sf http://REMOTE_HOST:8080/jsonapi -o /dev/null -w "%{http_code}" 2>/dev/null`
- (Try the remote host's port 8080 — if Drupal is exposed. If not reachable, that's expected.)

- HTTP 200 → `[PASS] Drupal JSON:API responding`
- Other (local) → `[FAIL] Drupal not responding`
- Other (remote) → `[WARN] Drupal not reachable on port 8080 — may not be exposed externally (MCP tools still work via internal Docker network)`

### Check 7: Python API responding (MODE: full, health)

**If local:**
- Run: `curl -sf http://localhost:8000/health -o /dev/null -w "%{http_code}" 2>/dev/null`

**If remote:**
- Run: `curl -sf http://REMOTE_HOST:8000/health -o /dev/null -w "%{http_code}" 2>/dev/null`

- HTTP 200 → `[PASS] Python API responding`
- Other (local) → `[FAIL] Python API not responding`
- Other (remote) → `[WARN] Python API not reachable on port 8000 — may not be exposed externally`

### Check 8: MCP tool count (MODE: full)

**If local:**
- Run: `docker exec arcosv3-python-api-1 python -c "
from mcp_server import list_tools
import asyncio
tools = asyncio.run(list_tools())
print(len(tools))
" 2>&1`

**If remote:**
- Run: `curl -sf MCP_URL -X POST -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -d '{"jsonrpc":"2.0","method":"tools/list","params":{},"id":1}' 2>&1`
- Parse the response to count tools, or just check that the endpoint responds with valid JSON.

- Number matches 36 → `[PASS] MCP server exposes 36 tools across 16 categories`
- Different number → `[WARN] MCP server exposes N tools (expected 36)`
- Error → `[FAIL] Could not count tools` — show error

---

### Summary

After all checks, display a summary block:

```
────────────────────────────────────
ARCOS CONNECTION STATUS: CONNECTED
  Mode: local | remote (MCP_URL)
  Checks passed: 8/8
  Tools: 36 across 16 categories
────────────────────────────────────
```

If any check failed:

```
────────────────────────────────────
ARCOS CONNECTION STATUS: ISSUES FOUND
  Mode: local | remote (MCP_URL)
  Checks passed: 5/8  |  Failed: 3
  See failures above for details.
  Guide: docs/claude-code-setup.md
────────────────────────────────────
```

## Guardrails
- All checks use Bash — never MCP tools (since MCP might be what's broken)
- Local checks use `docker exec` / `docker ps` (NOT `docker compose`) so they work from any directory
- Remote checks use `curl` to the MCP HTTP endpoint and exposed ports
- For remote mode, Drupal/API ports may not be exposed externally — that's OK, MCP tools work via Docker's internal network
- The only writes: `/connect setup` creates `.mcp.json`, `/connect install` copies this skill
- Never modify any other files
- If Docker / MCP endpoint is not reachable, skip subsequent checks
- Container name is `arcosv3-python-api-1` (from docker compose project `arcosv3`)
