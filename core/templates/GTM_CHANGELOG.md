---
client: "{client}"
last_updated: "YYYY-MM-DD"
---

# {Client Name} — GTM / SGTM Changelog

> Single source of truth for all container changes. Log every publish here.
> Newest entries at top. Never delete entries.

---

## Container Registry

| Container ID | Name | Type | Latest Export | Latest Live Version | Notes |
|-------------|------|------|---------------|--------------------:|-------|
| `GTM-EXAMPLE-001` | {Country} Web | Web | workspace{N} | v{N} | |
| `GTM-EXAMPLE-001` | {Country} SGTM | SGTM | workspace{N} | v{N} | |

---

## Changelog

### YYYY-MM-DD — {Brief title}

| Field | Value |
|-------|-------|
| **Container** | `GTM-EXAMPLE-001` ({name}) |
| **Version** | workspace{N} → v{N} (published) / workspace{N} (draft) |
| **RECs** | REC-XXX, REC-XXX |
| **Artifact** | [`REC-XXX_{slug}.md`](artifacts/REC-XXX_{slug}.md) or N/A |
| **Changed by** | {who} |

**What changed:**
- Tag: `{tag name}` — {what changed}
- Variable: `{variable name}` — {what changed}
- Trigger: `{trigger name}` — {what changed}

**GTM version note:**
```
REC-XXX: {one-liner for GTM publish notes}
```

**Verification:**
- [ ] Preview mode tested
- [ ] Published
- [ ] Post-publish spot-check

---

<!-- Copy the block above for each new entry -->

## Export Log

> Track which container exports are stored locally.

| Date | Container | Export File | Notes |
|------|-----------|------------|-------|
| YYYY-MM-DD | `GTM-EXAMPLE-001` | `GTM-EXAMPLE-001_workspace{N}.json` | {reason for export} |

---

**Template version:** 1.0
**Last updated:** YYYY-MM-DD
