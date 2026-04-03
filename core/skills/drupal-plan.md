# /drupal-plan - Drupal Task Planning Assistant

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Guide users through planning Drupal development tasks by:
1. Determining if requirements can be met with **standard Drupal tools** (site building, configuration, contributed modules)
2. Identifying when a **custom module is required**
3. Providing specific implementation guidance based on the chosen approach

The goal is to exhaust no-code/low-code solutions before recommending custom development.

---

## THE GOLDEN RULE

> **"Always leverage Drupal core's out-of-the-box features before performing custom development or installing other projects. Drupal core itself is feature-rich, and it is the most established aspect of Drupal."**
> — Drupal 10 Masterclass

**Decision Hierarchy:**
1. Can Drupal Core do this? (configuration only)
2. Can a contributed module do this? (install + configure)
3. Do I need a custom module? (write code)

---

## PHASE 1: REQUIREMENT GATHERING

Ask the user these questions to understand the task:

### Core Questions
1. **"What is the task you need to accomplish?"**
   - Get a clear description of the desired outcome

2. **"What type of task is this?"**
   - Content structure (fields, content types, entities)
   - Content display (views, layouts, theming)
   - User management (roles, permissions, authentication)
   - Forms and user input
   - Integration with external systems
   - Workflow/process automation
   - API/data exchange
   - Performance optimization
   - Migration from another system

3. **"Is this for content editors (backend) or site visitors (frontend)?"**

4. **"Does this need to work with existing Drupal entities (nodes, users, taxonomy) or completely custom data?"**

5. **"Does this require integration with any external systems or APIs?"**

---

## PHASE 2: STANDARD DRUPAL CAPABILITIES CHECK

### Content Structure (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| Create content types | Structure > Content types | Blog, Article, Product, Event, etc. |
| Add fields to content | Manage fields | Text, images, dates, references, links |
| Organize content | Taxonomy | Categories, tags, hierarchies |
| Custom blocks | Structure > Block types | Reusable content snippets |
| Media management | Media module | Images, videos, documents |
| Comments | Comment module | User feedback on content |
| Multilingual content | Language modules | Content translation |

**Field Types Available in Core:**
- Text (plain, formatted, long)
- Number (integer, decimal, float)
- Boolean
- Link
- Email
- Telephone
- Date/time
- Entity reference (to nodes, users, taxonomy, etc.)
- File/Image
- List (select, checkboxes, radios)

**Decision Point:** If you need a field type not listed above, consider:
1. Check contributed modules for custom field types
2. Build a custom field (requires custom module)

---

### Content Display (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| List content | Views | Blog listings, product catalogs, user directories |
| Filter content | Views (exposed filters) | Search within listings |
| Sort content | Views (sort criteria) | Date, title, custom fields |
| Different displays | Display modes | Teaser, full, card views |
| Page layouts | Layout Builder | Landing pages, flexible content |
| Place content in regions | Block system | Sidebars, headers, footers |
| RSS feeds | Views (feed display) | Content syndication |

**Views Capabilities:**
- Multiple display types (page, block, feed, attachment)
- Contextual filters (filter by URL parameters)
- Relationships (join related data)
- Aggregation (GROUP BY queries)
- Pagers
- AJAX refresh
- Exposed filters and sorts

**Decision Point:** If Views cannot produce the query you need:
1. Check for contributed Views plugins
2. Build a custom Views field/filter/argument plugin (custom module)
3. Build a completely custom controller (custom module)

---

### User Management (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| Create roles | People > Roles | Editor, Manager, Subscriber |
| Set permissions | People > Permissions | Control access to features |
| User registration | Account settings | Self-registration, admin-only |
| User fields | User entity fields | Profile information |
| Login/logout | User module | Authentication |
| Password policies | Contributed module | Complexity requirements |

**Decision Point:** If you need:
- SSO/OAuth/SAML → Use contributed modules (SimpleSAML, OAuth)
- Custom permission logic → Custom access handler (custom module)
- Custom authentication → Custom auth provider (custom module)

---

### Forms (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| Contact forms | Contact module | Simple user inquiries |
| Webforms | Webform module (contrib) | Complex multi-step forms |
| Content submission | Node add forms | User-generated content |

**Webform Module Capabilities (No Custom Code):**
- Multi-step forms with progress bar
- Conditional fields (show/hide based on input)
- File uploads with validation
- Email notifications
- Submission storage and export
- CAPTCHA integration
- Payment integration (with add-ons)

**Decision Point:** If you need:
- Complex validation logic → Custom form alter or custom form (custom module)
- Integration with external API on submit → Custom submit handler (custom module)
- Completely custom form workflow → Custom Form API implementation (custom module)

**Form API Capabilities (Custom Module):**
- `#states` - JavaScript-driven conditional visibility
- `#ajax` - AJAX form updates without page reload
- `validateForm()` - Custom validation logic
- `submitForm()` - Custom submission handlers
- `ConfigFormBase` - Simplified configuration forms
- Form alters - Modify any existing form

---

### Workflows (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| Content moderation | Workflows module | Draft → Review → Published |
| Workspace staging | Workspaces module | Content staging areas |
| Scheduled publishing | Scheduler module (contrib) | Time-based publish/unpublish |

**Decision Point:** If you need:
- Custom state transitions with business logic → Custom event subscriber (custom module)
- Integration with external approval systems → Custom module

---

### Search (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| Basic search | Search module | Simple keyword search |
| Advanced search | Search API (contrib) | Faceted search, better relevance |
| External search | Solr/Elasticsearch (contrib) | High-performance search |

---

### APIs (No Code Required)

**What Drupal Core Can Do:**
| Capability | Tool | When to Use |
|------------|------|-------------|
| RESTful API | JSON:API module | Expose content as JSON |
| GraphQL | GraphQL module (contrib) | Flexible queries |
| Content sync | REST module | CRUD operations |

**Decision Point:** If you need:
- Custom API endpoints → Custom routes and controllers (custom module)
- Complex data transformation → Custom normalizers (custom module)
- Webhook receivers → Custom controllers (custom module)

---

### Data Storage Options (When NOT Using Entities)

**What Drupal Core Provides:**
| Storage Type | Purpose | When to Use |
|--------------|---------|-------------|
| State API | Key/value for system state | Cron timestamps, flags, environment-specific data |
| Configuration | Exportable settings | Module settings, site configuration |
| TempStore (Private) | Session-like data per user | Multi-step form data, wizard progress |
| TempStore (Shared) | Shared temporary data | Locking mechanisms, collaborative editing |
| UserData | User-specific non-content data | User preferences, flags per user |
| Cache | Performance optimization | Expensive computations, API responses |

**Decision Point:**
- Need to export/sync between environments? → Configuration API
- System-specific, not for humans? → State API
- Per-user, session-like? → TempStore
- User preferences/flags? → UserData
- Performance storage? → Cache API

---

## PHASE 3: CUSTOM MODULE INDICATORS

### You NEED a Custom Module When:

**1. Custom Business Logic**
- Complex calculations or transformations
- Business rules that don't fit standard workflows
- Custom validation beyond field constraints

**2. External System Integration**
- Connecting to third-party APIs
- Sending data to external services
- Receiving webhooks
- Custom authentication providers

**3. Custom Data Models**
- Data that doesn't fit content entities
- Need for custom entity types
- Complex relationships not possible with entity references

**4. Custom User Interfaces**
- Pages that aren't content or Views
- Complex interactive forms
- Custom admin interfaces

**5. Custom Access Control**
- Permission logic beyond role-based
- Field-level access control
- Complex content access rules

**6. Altering Core/Contrib Behavior**
- Modifying how existing features work
- Adding to existing forms
- Changing existing routes

**7. Background Processing**
- Scheduled tasks (cron jobs)
- Queue processing
- Batch operations

**8. Custom Theming Hooks**
- New theme hooks for custom data
- Preprocess functions for complex logic

---

## PHASE 4: CUSTOM MODULE COMPONENTS

When a custom module is required, identify which components are needed:

### Module Building Blocks

| Component | File | Purpose |
|-----------|------|---------|
| Module definition | `*.info.yml` | Declare module to Drupal |
| Routes | `*.routing.yml` | Define URL paths |
| Controllers | `src/Controller/*.php` | Handle page requests |
| Forms | `src/Form/*.php` | Build and process forms |
| Services | `*.services.yml` + `src/Service/*.php` | Reusable business logic |
| Plugins | `src/Plugin/**/*.php` | Blocks, fields, Views, etc. |
| Event Subscribers | `src/EventSubscriber/*.php` | React to system events |
| Hooks | `*.module` | Alter existing behavior |
| Configuration | `config/install/*.yml` | Default settings |
| Schema | `config/schema/*.yml` | Configuration structure |
| Templates | `templates/*.html.twig` | Custom output |
| Drush commands | `src/Commands/*.php` | CLI tools |

### Common Custom Module Patterns

**Pattern 1: Custom Page**
```
Need: routes + controller
Files: *.routing.yml, src/Controller/MyController.php
```

**Pattern 2: Custom Form**
```
Need: routes + form
Files: *.routing.yml, src/Form/MyForm.php
```

**Pattern 3: Custom Block**
```
Need: block plugin
Files: src/Plugin/Block/MyBlock.php
```

**Pattern 4: Custom Entity**
```
Need: entity type + handlers + forms
Files: src/Entity/*.php, src/Form/*.php, *.routing.yml
```

**Pattern 5: Hook into Existing Behavior**
```
Need: hook implementation
Files: *.module
```

**Pattern 6: React to Events**
```
Need: event subscriber + service registration
Files: *.services.yml, src/EventSubscriber/*.php
```

**Pattern 7: Extend Views**
```
Need: Views plugin
Files: src/Plugin/views/**/*.php, *.views.inc
```

**Pattern 8: Custom Field Type**
```
Need: field type + widget + formatter plugins
Files: src/Plugin/Field/FieldType/*.php, FieldWidget/*.php, FieldFormatter/*.php
```

**Pattern 9: Custom Menu Links**
```
Need: menu link definitions
Files: *.links.menu.yml (main menu)
       *.links.task.yml (local tasks/tabs)
       *.links.action.yml (local actions)
       *.links.contextual.yml (contextual links)
```

**Pattern 10: Configuration Form**
```
Need: ConfigFormBase + route + schema
Files: src/Form/SettingsForm.php (extends ConfigFormBase)
       *.routing.yml
       config/schema/*.schema.yml
       config/install/*.yml (defaults)
```

**Pattern 11: Custom Mail**
```
Need: hook_mail + mail sending
Files: *.module (hook_mail implementation)
       Or: src/Plugin/Mail/*.php (custom mail plugin)
```

**Pattern 12: Entity Operations**
```
Need: hooks for entity lifecycle
Hooks: hook_ENTITY_TYPE_presave, hook_entity_presave
       hook_ENTITY_TYPE_insert, hook_entity_insert
       hook_ENTITY_TYPE_update, hook_entity_update
       hook_ENTITY_TYPE_delete, hook_entity_delete
```

---

### Hooks vs Event Subscribers

**Use Hooks When:**
- Altering forms (`hook_form_alter`, `hook_form_FORM_ID_alter`)
- Altering entities (`hook_entity_presave`, `hook_node_insert`)
- Altering theme (`hook_preprocess_*`, `hook_theme`)
- Altering menus (`hook_menu_links_discovered_alter`)
- Quick one-off alterations

**Use Event Subscribers When:**
- Responding to kernel events (request, response, exception)
- Responding to configuration events
- Custom events from contrib modules
- When you need priority control
- When you need dependency injection

---

## PHASE 5: DECISION TREE

Use this flowchart to guide the user:

```
START: What do you need?
    │
    ├── Display/list existing content?
    │   └── YES → Use Views (no code)
    │
    ├── Create new content structure?
    │   └── YES → Create content type + fields (no code)
    │
    ├── Custom page layout?
    │   └── YES → Use Layout Builder (no code)
    │
    ├── User permissions?
    │   ├── Role-based? → Configure roles/permissions (no code)
    │   └── Complex logic? → Custom access handler (custom module)
    │
    ├── Forms?
    │   ├── Simple contact? → Contact module (no code)
    │   ├── Complex multi-step? → Webform module (no code)
    │   └── Custom logic/integration? → Custom Form API (custom module)
    │
    ├── External API integration?
    │   └── YES → Custom module required
    │
    ├── Custom data model?
    │   ├── Fits content entity? → Content type (no code)
    │   └── Unique requirements? → Custom entity type (custom module)
    │
    ├── Modify existing behavior?
    │   └── YES → Hook or event subscriber (custom module)
    │
    └── Background processing?
        └── YES → Custom cron/queue (custom module)
```

---

## PHASE 6: OUTPUT FORMAT

For each planning session, provide:

### 1. Requirement Summary
Brief description of what the user needs

### 2. Recommended Approach
- **Standard Drupal** OR **Custom Module Required**

### 3. If Standard Drupal:
- Specific modules to enable
- Configuration steps
- Contributed modules to install (if any)
- Step-by-step implementation guide

### 4. If Custom Module Required:
- Why standard Drupal can't meet the requirement
- Module components needed
- File structure
- Key code patterns to implement
- Estimated complexity (Simple/Medium/Complex)

### 5. Alternative Approaches
- Other ways to solve the problem
- Trade-offs of each approach

---

## QUICK REFERENCE: STANDARD DRUPAL CAPABILITIES

### Core Modules to Know
| Module | Purpose |
|--------|---------|
| Node | Content management |
| Field | Field system |
| Views | Content listings |
| Block | Block system |
| Layout Builder | Page layouts |
| User | User management |
| Taxonomy | Content categorization |
| Media | Media management |
| Contact | Contact forms |
| Search | Search functionality |
| Workflows | Content moderation |
| JSON:API | RESTful API |
| Language/Locale | Multilingual |
| Menu | Navigation |

### Essential Contributed Modules
| Module | Purpose |
|--------|---------|
| Pathauto | Automatic URL aliases |
| Token | Token system |
| Metatag | SEO meta tags |
| Admin Toolbar | Better admin UX |
| Webform | Advanced forms |
| Search API | Advanced search |
| Paragraphs | Flexible content components |
| Entity Reference Revisions | Paragraph support |
| Redirect | URL redirects |
| Simple OAuth | OAuth provider |
| Devel | Development tools |
| Scheduler | Scheduled publishing |
| Rules | Automated actions (no-code workflows) |
| Flag | User flagging system |
| Field Group | Organize form fields |
| Inline Entity Form | Edit referenced entities inline |
| Views Bulk Operations | Bulk actions on Views |
| Entity Browser | Better entity selection |
| Migrate Plus/Tools | Enhanced migration |

---

## CONFIGURATION MANAGEMENT

### Key Commands (Drush)
```bash
drush config-export    # Export active config to sync directory
drush config-import    # Import from sync directory to database
drush config-get       # View a config item
drush config-set       # Set a config value
```

### Configuration Workflow
1. Make changes in UI on development
2. Export: `drush config-export`
3. Commit YAML files to Git
4. Deploy code to next environment
5. Import: `drush config-import`

### Configuration in Custom Modules
- `config/install/*.yml` - Installed with module
- `config/optional/*.yml` - Installed only if dependencies met
- `config/schema/*.yml` - Schema definitions (required for entities)

---

## ENTITY QUERY PATTERNS

### Basic Query
```php
$query = \Drupal::entityQuery('node')
  ->accessCheck(TRUE)
  ->condition('type', 'article')
  ->condition('status', TRUE)
  ->sort('created', 'DESC')
  ->range(0, 10);
$nids = $query->execute();
$nodes = \Drupal::entityTypeManager()->getStorage('node')->loadMultiple($nids);
```

### When to Use Entity Queries
- Filtering content for Views alternatives
- Custom controllers needing specific data
- Batch operations on entities
- Custom search/filter implementations

### When Entity Queries Aren't Enough
- Complex JOINs across non-entity tables → Database API
- Performance-critical queries → Database API with caching
- Aggregations beyond basic counts → Database API

---

## EXAMPLE SESSIONS

### Example 1: Blog with Categories
**User:** "I need a blog with categories and a listing page"

**Analysis:**
- Content display: Blog listing → Views (no code)
- Content structure: Blog post → Content type (no code)
- Categorization: Categories → Taxonomy (no code)

**Recommendation:** Standard Drupal (no custom code)

**Steps:**
1. Create "Blog" content type with title, body, image fields
2. Create "Categories" taxonomy vocabulary
3. Add taxonomy reference field to Blog content type
4. Create View for blog listing page
5. Add exposed filter for categories

---

### Example 2: CRM Integration
**User:** "When a contact form is submitted, I need to create a lead in Salesforce"

**Analysis:**
- Form submission: Contact module works
- External API call: Salesforce integration → Not available in core

**Recommendation:** Custom module required

**Why:** Drupal cannot make external API calls without custom code

**Components Needed:**
- Hook implementation: `hook_mail_alter()` or form alter
- Service: Salesforce API client
- Configuration: API credentials storage

---

### Example 3: Custom Dashboard
**User:** "I need an admin dashboard showing content statistics"

**Analysis:**
- If statistics are counts/aggregates → Views with aggregation (no code)
- If complex calculations → Custom module

**Questions to Ask:**
1. What specific statistics do you need?
2. Can they be derived from existing content counts?

**If simple counts:** Use Views with aggregation
**If complex:** Custom controller with custom queries

---

### Example 4: Event Registration System
**User:** "I need an event registration system where users can sign up for events"

**Analysis:**
- Event content: Content type with date field → No code
- Registration form: Could be Webform or custom
- User tracking: Entity reference from registration to user
- Capacity limits: Needs validation logic

**Questions to Ask:**
1. Do you need payment processing?
2. Do you need waitlists?
3. Do you need automatic capacity enforcement?

**If simple (no payment, basic tracking):**
- Create "Event" content type with date, location, capacity fields
- Use Webform for registration
- Store submissions in Webform
- **Standard Drupal (no custom code)**

**If complex (payment, waitlists, automatic enforcement):**
- Custom entity for registrations
- Custom validation for capacity
- Integration with payment gateway
- **Custom module required**

---

### Example 5: Content Approval Workflow
**User:** "Content needs to be reviewed by editor before publishing"

**Analysis:**
- This is exactly what Workflows module does

**Recommendation:** Standard Drupal (no custom code)

**Steps:**
1. Enable Content Moderation module (core)
2. Create workflow: Draft → Review → Published
3. Configure permissions: Authors can create drafts, Editors can publish
4. Apply workflow to content types

**If additional needs:**
- Email notifications on state change → Rules module (contrib) OR custom event subscriber
- External approval system → Custom module required

---

## INTEGRATION WITH OTHER SKILLS

This skill connects with:
- `/validate-idea` - Validate the business need before building
- `` - If building a Drupal-based product/service

---

## SOURCES

This skill is based on:
- **Drupal 10 Masterclass** by Adam Bergstein (Packt, 2023)
- **Drupal 10 Module Development** by Daniel Sipos (Packt, 2023)
- **Drupal 10 Development Cookbook** by Matt Glaman & Kevin Quillen (Packt, 2023)
