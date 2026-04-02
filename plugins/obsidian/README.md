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
- `scripts/`
- `skills/`
- `assets/`

## Notes

This is a starter bundle. It defines the plugin surface and bundled skill layout first, then leaves concrete CLI execution wiring to the next implementation step.

## CLI Requirement

- this plugin is designed around the official Obsidian CLI
- if Obsidian is not already open, the first CLI command is expected to launch it
- follow-up implementation should detect CLI availability and provide a clear fallback when launch fails

## Usage Examples

- "Capture this conversation as a new Obsidian note named `Plugin Example Note`."
- "Append a follow-up checklist to `Plugin Example Note.md`."
- "Research `zettelkasten` across my vault and summarize the most relevant notes."
- "Show me the backlinks for `Plugin Example Note`."

## Implementation Docs

- `docs/cli-mapping.md`: workflow-to-command mapping for the official Obsidian CLI

## Hook Policy

- `hooks.json` defines the starter execution guardrails for CLI readiness, safe writes, post-write verification, and destructive-command protection

## Local Runner

- `scripts/obsidian-cli-runner.sh` provides a small execution wrapper for the bundled CLI workflows
- direct CLI and runner commands are implementation details; end users should interact through natural-language requests

## Assets

- `assets/` now contains simple custom purple gem-style SVG assets for the manifest icon and logo
- replace them with more polished visuals later if you want a stronger published presentation
