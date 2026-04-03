# ArcOS System Context

You are connected to **ArcOS (Arcanian OS)** — a Company OS that manages knowledge, meetings, clients, projects, skills, content publishing, and workflows. All data lives in Drupal (headless CMS), accessed via MCP tools or Drupal REST/JSON:API. AI capabilities use Claude/OpenAI via a Python agent layer.

## Architecture

```
Claude Code ──MCP──> Python Agents (FastAPI) ──JSON:API──> Drupal (CMS)
                                              ──REST──>    + PostgreSQL (pgvector)
                                                           + Redis (cache)
```

- **Embeddings**: OpenAI `text-embedding-3-small` (1536 dims) via Drupal AI Search
- **Vector DB**: PostgreSQL pgvector (collection: `arcos_content`)
- **Search indexes**: `arcos_semantic` (vector) + `arcos_fulltext` (database)

---

## MCP Tools Reference (52 tools)

### Memory — Knowledge Base (4 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_memories` | Search knowledge base | — | `subtype` (resource, psychology_client, psychology_team, snippet, decision_pattern), `client_id`, `project_id`, `access_level` (public, client, project, private), `limit` (1-100, default 20) |
| `get_memory` | Get full memory by UUID | `uuid` | — |
| `create_memory` | Create a knowledge memory | `title`, `subtype` | `body`, `url`, `source`, `code`, `code_language`, `access_level`, `client_id`, `project_id` |
| `update_memory` | Update a memory (partial) | `uuid` | `title`, `body`, `source`, `url`, `code`, `access_level` |

**Memory subtypes**: `resource` (docs, references), `psychology_client` (client psychology), `psychology_team` (team dynamics), `snippet` (code/config), `decision_pattern` (recurring patterns)

### Skills — Reusable Instructions (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_skills` | Search skills by category | — | `category` (consulting, technical, creative, leadership, methodology, communication), `limit` (default 20) |
| `get_skill` | Get skill (body truncated at 2000 chars) | `uuid` | — |
| `load_skill` | Load full skill into AI context | `uuid` | — |

**`load_skill` returns**: `skill_name`, `version`, `category`, `effectiveness`, `trigger_phrases[]`, `instructions` (full body), `anti_patterns` — use this when you need to _apply_ a skill, not just read about it.

### Procedures — SOPs & Runbooks (4 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_procedures` | Search procedures | — | `category` (onboarding, delivery, internal, sales, support, quality), `client_id`, `project_id`, `limit` (default 20) |
| `get_procedure` | Get full procedure | `uuid` | — |
| `create_procedure` | Create a procedure | `title`, `steps` | `body`, `estimated_time`, `category`, `anti_patterns`, `skill_chain` (UUID[]), `chain_context`, `client_id`, `project_id`, `access_level` |
| `update_procedure` | Update a procedure | `uuid` | `title`, `body`, `steps`, `estimated_time`, `category`, `anti_patterns`, `skill_chain`, `chain_context`, `access_level` |

### Captain's Log — Journal (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `captain_log` | Create a log entry | `title`, `log_type` (decision, event, feedback, insight, note) | `body`, `mood` (positive, neutral, negative, mixed), `access_level`, `project_id`, `client_id` |

### Context Bundling (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `get_context` | Bundle project/client context | — | `project_id`, `client_id`, `include_logs` (true), `include_meetings` (true), `include_skills` (true), `include_memories` (true) |

Returns: project details + recent logs (10) + meetings (5) + skills (10) + memories (20). **Use this first** when you need background on a client or project.

### Fireflies — Transcript Import (2 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `list_fireflies` | List available Fireflies.ai transcripts | — | `limit` (default 20) |
| `sync_fireflies` | Import a transcript into ArcOS | `transcript_id` | `meeting_type` (client, internal, standup, retrospective, planning, workshop), `client_id`, `project_id` |

### Meetings — Search (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_meetings` | Search meetings by date/client/type | — | `date_from`, `date_to` (YYYY-MM-DD), `meeting_type`, `client_id`, `project_id`, `limit` (default 20, max 50) |

### Semantic Search (2 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `semantic_search` | Natural language search across all content | `query` | `content_type` (memory, skill, procedure, log_entry, meeting, engagement, arcos_project, linkedin_comment, post), `client_id`, `project_id`, `limit` (default 10, max 50) |
| `find_similar` | Find content similar to a given item | `uuid` | `content_type`, `limit` (default 5) |

`semantic_search` calls Drupal's `/api/search` which runs both fulltext + vector search and returns merged, deduplicated results ranked by score.

### Ontology — Data Model & Lifecycle (4 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `ontology_describe` | Describe an object type | `type_name` | — |
| `ontology_graph` | Full ontology graph (nodes + edges) | — | — |
| `ontology_transitions` | Valid lifecycle transitions from a state | `type_name`, `current_state` | `role` (member, manager, admin) |
| `ontology_execute_action` | Execute an ontology action | `action_name`, `target_id` | `inputs` (object) |

### Person / Contact (2 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_persons` | Search contacts by role/client | — | `role` (client_contact, team_member, partner, vendor, lead, other), `client_id`, `limit` (default 20) |
| `create_person` | Create a contact | `title` (full name) | `email`, `phone`, `company`, `role`, `notes`, `client_id` |

### Audit Trail (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `audit_trail` | Query CRUD operations and system actions | — | `action` (create, update, delete, sync, enrich), `entity_type`, `entity_id`, `limit` (default 20) |

### Markdown Export (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `export_markdown` | Export content to Markdown with YAML frontmatter | `content_type`, `uuid` | — |

### Asana Integration (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `asana_search` | Search Asana tasks | — | `query`, `project_gid`, `assignee` ("me" or GID), `completed` (bool), `limit` (default 25) |
| `asana_create_task` | Create an Asana task | `name` | `project_gid`, `assignee`, `due_on`, `notes` |
| `asana_complete_task` | Mark task complete | `task_gid` | — |

### Queue & Scheduler (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `queue_status` | Background queue lengths | — | — |
| `scheduler_status` | Scheduled task statuses | — | — |
| `scheduler_run_task` | Manually trigger a task | `task_id` (fireflies_check, fireflies_full_sync, embedding_refresh, enrichment_refresh) | — |

### Meeting Intelligence — AI (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `meeting_query` | Ask questions about meetings | `question` | `client_id` |
| `meeting_extract_tasks` | Extract tasks from a meeting | `meeting_uuid` | `target` (asana, drupal), `project_id` |
| `meeting_summarize` | Structured AI summary | `meeting_uuid` | — |

### Brand Voice & Documents (2 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `generate_document` | Generate a branded document | `doc_type` (meeting_summary, proposal, status_report, follow_up_email, client_brief) | `meeting_uuid`, `project_uuid`, `client_id`, `recipient_uuid`, `audience` (client_executive, client_technical, internal_team, partner), `custom_instructions` |
| `apply_brand_voice` | Rewrite text in brand voice | `text` | `audience` (client_executive, client_technical, internal_team, partner) |

### Person Intelligence — AI (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `person_profile` | AI communication profile | `person_uuid` | — |
| `person_brief` | Quick pre-meeting brief | `person_uuid` | `context` (e.g. "meeting about website redesign") |
| `relationship_map` | Map people connected to a client | `client_id` | — |

### LinkedIn Comments — A.E.L.Q. Framework (4 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_linkedin_comments` | Search comments | — | `language` (hu, en, bilingual), `publish_status` (draft, ready, posted, published), `client_id`, `limit` (default 20) |
| `get_linkedin_comment` | Get full comment | `uuid` | — |
| `create_linkedin_comment` | Create a comment | `title` | `body`, `content_number`, `post_topic`, `post_author`, `post_url`, `language`, `publish_status`, `comment_text`, `original_post_summary`, `framework_breakdown`, `strategic_note`, `posted_date`, `client_id`, `access_level` |
| `update_linkedin_comment` | Update + outcome tracking | `uuid` | `title`, `body`, `publish_status`, `comment_text`, `framework_breakdown`, `strategic_note`, `posted_date`, `engagement_likes`, `engagement_comments`, `engagement_score`, `replies_count`, `outcome_notes` |

### Posts — Multi-Platform Publishing (4 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `search_posts` | Search across platforms | — | `platform` (substack, linkedin_post, linkedin_newsletter, linkedin_reply, x_post), `post_type` (teaser, standalone, bilingual, pattern_drop, quality_bomb, tactical, article, newsletter, reply), `series` (educational, commentary, concept, story, pattern_drop, case_study), `language`, `publish_status`, `client_id`, `limit` |
| `get_post` | Get full post | `uuid` | — |
| `create_post` | Create a post | `title`, `platform` | `body`, `content_number`, `post_type`, `series`, `language`, `publish_status`, `posted_date`, `platform_url`, `substack_url`, `client_id`, `access_level` |
| `update_post` | Update + outcome tracking | `uuid` | `title`, `body`, `platform`, `post_type`, `series`, `publish_status`, `posted_date`, `platform_url`, `substack_url`, `engagement_likes`, `engagement_comments`, `engagement_score`, `views`, `outcome_notes` |

### Skill Pipelines (3 tools)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `list_pipelines` | List all skill pipelines | — | — |
| `describe_pipeline` | Describe a pipeline without running | `start_uuid` | — |
| `run_pipeline` | Execute a skill pipeline | `start_uuid` | `context` (object — initial context) |

Pipelines are procedures with `skill_chain` references. They chain multiple skills/procedures into multi-step workflows.

### Health (1 tool)

| Tool | Description | Required Params | Optional Params |
|------|-------------|-----------------|-----------------|
| `check_health` | System health (API, Drupal, pgvector, embeddings) | — | — |

---

## Drupal REST API Endpoints

These endpoints are available directly on Drupal (port 8080 locally, or the Lagoon URL). Auth: `basic_auth` or `cookie`.

### Search
| Method | Endpoint | Params | Purpose |
|--------|----------|--------|---------|
| POST | `/api/search` | `q`, `type`, `limit`, `offset`, `enrich` | Combined fulltext + semantic search |
| POST | `/api/search/fulltext` | `q`, `type`, `limit`, `offset` | Fulltext only |
| POST | `/api/search/semantic` | `q`, `type`, `limit`, `offset` | Vector/semantic only |

### Skills
| Method | Endpoint | Params | Purpose |
|--------|----------|--------|---------|
| GET | `/api/skills/{nid}/versions` | — | All revisions of a skill |
| POST | `/api/skills/{nid}/bump` | `version` (optional) | Bump skill version |
| POST | `/api/skills/{nid}/track-usage` | `amount` (default 1) | Increment effectiveness |
| GET | `/api/skills/match/{phrase}` | — | Match trigger phrases |

### Audit
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/audit/events` | All audit events |
| GET | `/api/audit/events/recent` | Recent events |
| GET | `/api/audit/history/{entity_type}/{entity_id}` | Entity change history |
| GET | `/api/audit/stats` | Aggregate statistics |

### Export/Import
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/export/{content_type}/{uuid}` | Export single node as Markdown |
| GET | `/api/export/{content_type}` | Bulk export all nodes of type |
| POST | `/api/import` | Import Markdown content |

### Pipelines
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/pipelines` | List all pipelines |
| GET | `/api/pipelines/{nid}/describe` | Describe a pipeline |
| POST | `/api/pipelines/{nid}/run` | Execute a pipeline |

### Fireflies
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/fireflies/webhook` | Webhook receiver |
| GET | `/api/fireflies/transcripts` | List synced transcripts |
| POST | `/api/fireflies/sync-all` | Full re-sync |
| POST | `/api/fireflies/sync/{transcript_id}` | Sync single transcript |

### Gmail
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/gmail/status` | Sync status |
| POST | `/api/gmail/sync` | Trigger sync for all users |
| POST | `/api/gmail/sync/{user_id}` | Sync for specific user |
| GET | `/api/gmail/threads/{thread_id}` | Get a Gmail thread |

### Chat (SSE)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/chat/sse/{conversation_uuid}/invoke` | Stream chat response |
| POST | `/chat/sse/invoke` | Standalone chat invocation |
| GET | `/chat/api/conversations` | List conversations |
| GET | `/chat/api/conversations/{uuid}/messages` | List messages |

### KeyStore
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/keystore` | List all keys |
| GET | `/api/keystore/{key_name}` | Get a key value |
| POST | `/api/keystore/{key_name}` | Set a key value |

---

## Content Types in Drupal

| Node Type | Description | Key Fields |
|-----------|-------------|------------|
| `memory` | Knowledge base item | `field_memory_subtype`, `body`, `field_source`, `field_arcos_tags`, `field_arcos_data_source` |
| `skill` | Reusable AI instruction | `field_skill_category`, `body`, `field_trigger_phrases`, `field_anti_patterns`, `field_version`, `field_effectiveness` |
| `procedure` | Step-by-step SOP | `field_steps`, `field_skill_chain` (entity ref), `field_procedure_category`, `field_estimated_time` |
| `log_entry` | Captain's log entry | `field_log_type`, `body`, `field_arcos_tags` |
| `meeting` | Meeting record | `field_meeting_date`, `field_meeting_type`, `field_attendees`, `field_transcript`, `field_summary` |
| `engagement` | Client engagement | `field_engagement_status`, `field_engagement_type`, `field_contract_value` |
| `arcos_project` | Project | `field_project_status`, `field_priority` |
| `person` | Contact/person | `field_email`, `field_phone`, `field_company`, `field_person_role` |
| `brand_voice` | Voice profile | `field_voice_tone`, `field_voice_identity`, `field_voice_dos`, `field_voice_donts`, `field_voice_preferred_terms`, `field_voice_style_rules`, `field_voice_audience_adaptations` |
| `linkedin_comment` | LinkedIn comment | `field_comment_text`, `field_framework_breakdown`, `field_strategic_note`, `field_post_topic`, `field_post_author`, `field_language`, `field_publish_status`, `field_content_number` |
| `post` | Multi-platform post | `field_platform` (substack, linkedin_post, linkedin_newsletter, linkedin_reply, x_post), `field_post_type`, `field_series`, `field_language`, `field_publish_status`, `field_content_number` |
| `email` | Gmail message | `field_email_message_id`, `field_email_from`, `field_email_subject`, `field_email_date`, `field_gmail_thread_id` |

---

## Workflows

### 1. Meeting Import Pipeline
```
list_fireflies → sync_fireflies(transcript_id) → meeting_summarize(meeting_uuid) → meeting_extract_tasks(meeting_uuid, target="asana")
```
"Sync latest Fireflies recordings, summarize, and extract action items into Asana."

### 2. Meeting History Lookup
```
search_meetings(date_from, date_to) → meeting_summarize(meeting_uuid)
```
"What meetings did I have yesterday? Summarize the client meeting."

### 3. Client Deep Dive
```
get_context(client_id) → search_meetings(client_id) → relationship_map(client_id) → semantic_search("client insights")
```
"Give me everything we know about ClientName — meetings, people, context."

### 4. Pre-Meeting Prep
```
person_brief(person_uuid, context) → get_context(client_id) → search_linkedin_comments(client_id) → search_meetings(client_id)
```
"Brief me for my call with John from ExampleBuildBuilding about their website project."

### 5. LinkedIn Comment Workflow (A.E.L.Q.)
```
load_skill("linkedin-comment skill uuid") → search_linkedin_comments(language="hu", limit=5) → create_linkedin_comment(...)  → update_linkedin_comment(uuid, publish_status="posted", posted_date="...")
```
Or use the `/comment` skill which orchestrates this full workflow automatically.

### 6. Content Publishing (Post)
```
load_skill("7layer skill uuid") → search_posts(platform, limit=5) → create_post(title, platform, body) → update_post(uuid, publish_status="posted")
```

### 7. Skill Pipeline Execution
```
list_pipelines → describe_pipeline(start_uuid) → run_pipeline(start_uuid, context={...})
```
"Run the LinkedIn commenting pipeline with this post URL as context."

### 8. Document Generation
```
get_context(client_id) → meeting_summarize(meeting_uuid) → generate_document(doc_type="follow_up_email", meeting_uuid, client_id, audience="client_executive")
```
"Write a follow-up email from yesterday's meeting with the client."

### 9. Proposal Generation
```
get_context(client_id) → search_meetings(client_id) → person_profile(person_uuid) → generate_document(doc_type="proposal", client_id, recipient_uuid)
```
Or use the `/proposal` skill which orchestrates this full workflow.

### 10. Knowledge Capture
```
create_memory(title, subtype, body) → semantic_search(query) → find_similar(uuid)
```
"Save this Docker networking tip as a snippet, then find related knowledge."

### 11. Outcome Tracking
```
search_linkedin_comments(publish_status="posted") → update_linkedin_comment(uuid, engagement_score=85, outcome_notes="...")
search_posts(publish_status="posted") → update_post(uuid, views=1200, engagement_score=90)
```
Or use the `/outcome` skill for interactive tracking.

### 12. System Health Check
```
check_health → queue_status → scheduler_status
```
"Is everything running? Any queued items stuck?"

---

## Tips

- **Start with `get_context`** when you need background on a client or project — it bundles logs, meetings, skills, and memories in one call.
- **`search_meetings`** for date-based queries ("yesterday", "last week"). **`meeting_query`** for natural language questions ("what did we discuss about pricing?").
- **`list_fireflies`** is only for discovering _unsynced_ transcripts. For meeting history, use `search_meetings`.
- **`semantic_search`** for broad natural language search. **`search_memories`/`search_skills`** for filtered, structured searches.
- **`load_skill`** (not `get_skill`) when you need to _apply_ a skill's instructions. `get_skill` truncates at 2000 chars.
- **`find_similar`** takes a UUID and finds related content by searching the item's title.
- All UUIDs come from Drupal — get them from search/list results first.
- All create/update tools return compact summaries. Use `get_*` tools for full details.
- **Outcome tracking**: Use `update_linkedin_comment` or `update_post` with engagement fields to track content performance.
- **Pipelines**: Chain skills via procedures with `skill_chain`. Use `list_pipelines` to discover, `describe_pipeline` to preview, `run_pipeline` to execute.
- API keys are in Drupal's encrypted key store (`/admin/arcos/keystore`), not in `.env` files.
