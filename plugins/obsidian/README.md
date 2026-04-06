# Obsidian Plugin

This plugin bundles Obsidian-focused Codex workflows under `plugins/obsidian`.

## Included Workflows

- `obsidian-note-capture`
- `obsidian-vault-research`
- `obsidian-backlink-curator`

## Agent Surfaces

- `openai`: knowledge gardener for the vault
- `graph-analyzer`: connectivity and orphan-note analysis
- `markdown-styler`: Obsidian Markdown cleanup and structure
- `note-refiner`: note-focused rewriting and splitting

## What It Covers

- capturing conversations, meeting notes, and drafts into Obsidian-friendly Markdown
- researching a vault using note titles, links, tags, and metadata
- suggesting backlinks, related notes, and follow-up structure improvements
- executing note workflows through the official Obsidian CLI

## Plugin Structure

- `.codex-plugin/plugin.json`
- `hooks.json`
- `agents/`
- `docs/`
- `skills/`
- `assets/`

## Notes

This is a starter bundle. It keeps the main value in prompts, skills, and policy documents instead of a custom execution wrapper.

## CLI Requirement

- this plugin is designed around the official Obsidian CLI
- in this environment, raw CLI commands succeeded when Obsidian was already running
- after a full app quit, `obsidian version` and `obsidian create` both failed until the app was opened again
- workflows should check CLI availability and provide a clear fallback when launch fails

Official docs:
- https://obsidian.md/help/cli

## Readiness Recovery Playbook

When preflight (`obsidian version`) fails, use this quick triage before running any workflow:

1. classify the failure as one of:
   - `app_not_running`
   - `vault_resolution_failed`
   - `cli_registration_missing`
2. provide the matching recovery guidance:
   - `app_not_running`: ask the user to open Obsidian and wait for vault load/indexing
   - `vault_resolution_failed`: require explicit `vault=<name>` or `vault=<id>`
   - `cli_registration_missing`: ask the user to re-enable/register CLI in Obsidian settings and verify shell path
3. run one guided retry only
4. if the retry fails, stop automation and request explicit user direction

## Verified CLI Examples

These commands were executed successfully against the current vault during plugin validation unless noted otherwise.

```bash
obsidian version
obsidian daily:path
obsidian create path="Codex Plugin Tests/CLI Direct Test Target.md" content="# CLI Direct Test Target\n\n- target note for backlink testing" overwrite
obsidian create path="Codex Plugin Tests/CLI Direct Test Source.md" content="# CLI Direct Test Source\n\nThis note links to [[CLI Direct Test Target]].\n\n- created for direct CLI validation" overwrite
obsidian read path="Codex Plugin Tests/CLI Direct Test Target.md"
obsidian append path="Codex Plugin Tests/CLI Direct Test Target.md" content="\n- appended line from direct CLI test"
obsidian search query="CLI Direct Test"
obsidian backlinks path="Codex Plugin Tests/CLI Direct Test Target.md" counts format=json
obsidian links path="Codex Plugin Tests/CLI Direct Test Source.md"
obsidian property:set path="Codex Plugin Tests/CLI Direct Test Target.md" name=status value=verified type=text
obsidian property:read path="Codex Plugin Tests/CLI Direct Test Target.md" name=status
obsidian daily:append content="- [ ] direct CLI validation" inline
obsidian unresolved total
obsidian orphans total
```

Observed full-quit behavior:

```bash
osascript -e 'tell application "Obsidian" to quit'
obsidian version
# -> The CLI is unable to find Obsidian. Please make sure Obsidian is running and try again.
```

## Usage Examples

- "Capture this conversation as a new Obsidian note named `Plugin Example Note`."
- "Append a follow-up checklist to `Plugin Example Note.md`."
- "Research `zettelkasten` across my vault and summarize the most relevant notes."
- "Show me the backlinks for `Plugin Example Note`."

## Implementation Docs

- `docs/cli-mapping.md`: workflow-to-command mapping for the official Obsidian CLI

## Hook Policy

- `hooks.json` defines the starter execution guardrails for CLI readiness, safe writes, post-write verification, and destructive-command protection

## Execution Model

- use the official `obsidian` CLI directly instead of a plugin-specific shell runner
- keep command selection logic in skills, agents, and docs so the plugin can evolve with upstream CLI changes
- end users should still interact through natural-language requests, but the underlying execution surface is the raw CLI

## Assets

- `assets/` now contains simple custom purple gem-style SVG assets for the manifest icon and logo
- replace them with more polished visuals later if you want a stronger published presentation
