# Obsidian CLI Mapping

This document maps bundled Obsidian workflows to the official Obsidian CLI.

Reference:
- https://obsidian.md/help/cli

## Execution Policy

- prefer the official `obsidian` CLI as the only execution backend
- do not introduce a plugin-specific shell runner unless the upstream CLI leaves a proven gap
- treat a running Obsidian app as a prerequisite in this environment
- detect CLI availability before workflow execution
- fail with a clear user-facing message when the CLI is missing, launch fails, or the target vault cannot be resolved

## Readiness Check

Run a lightweight command before workflow execution:

```bash
obsidian version
```

If that fails:

1. classify the failure reason
2. present reason-specific recovery guidance
3. perform one guided retry
4. stop and ask for explicit user direction if the retry fails

### Readiness Failure Triage

| failure reason | signal | guided recovery |
| --- | --- | --- |
| `app_not_running` | `obsidian version` cannot find app instance | open Obsidian manually, wait for vault to appear, retry once |
| `vault_resolution_failed` | command requires vault but cwd is not a vault root | pass `vault=<name>` or `vault=<id>` explicitly, retry once |
| `cli_registration_missing` | binary missing or CLI registration disabled | re-enable/register Obsidian CLI in app settings, verify shell path, retry once |

### Guided Retry Policy

- keep retries deterministic and limited to one guided retry per failed preflight
- include the detected failure reason in the user-facing message
- if the guided retry fails, stop autonomous execution and request explicit user input

## Vault Targeting

- if the current working directory is an Obsidian vault, use it by default
- otherwise pass `vault=<name>` or `vault=<id>` explicitly as the first parameter
- prefer `path=<path>` when the exact note path is known
- prefer `file=<name>` only when wikilink-style resolution is intended
- for graph commands, keep in mind that Obsidian indexing may lag briefly after a write

## Workflow Mapping

### `obsidian-note-capture`

Purpose:
- create or update notes from conversations, rough ideas, and meeting inputs

Primary commands:

```bash
obsidian create name="<note name>" content="<markdown body>" open
obsidian append path="<path>.md" content="<markdown block>"
obsidian prepend path="<path>.md" content="<markdown block>"
obsidian daily:append content="<markdown block>"
obsidian property:set path="<path>.md" name="status" value="draft" type=text
obsidian property:set path="<path>.md" name="tags" value="meeting,project" type=list
```

Recommended flow:

1. generate the Markdown body from the capture template
2. choose `create` for a new note or `append`/`prepend` for an existing note
3. set structured properties with `property:set` when metadata should be explicit
4. use `daily:append` when the target is the current daily note rather than a standalone note

Fallbacks:

- if a named template is available in the vault, use `create ... template=<name>`
- if property writes fail, include frontmatter directly in the initial note content

### `obsidian-vault-research`

Purpose:
- search the vault, read relevant notes, and synthesize note relationships

Primary commands:

```bash
obsidian search query="<query>"
obsidian read path="<path>.md"
obsidian files ext=md
obsidian tags counts
obsidian properties format=json
obsidian backlinks path="<path>.md" format=json
obsidian links path="<path>.md"
```

Recommended flow:

1. run `search` for the topic, phrase, or tag
2. read the highest-signal notes with `read`
3. gather note graph context with `backlinks` and `links`
4. use `tags` and `properties` when the workflow needs cross-note metadata patterns

Fallbacks:

- if `search` is too broad, narrow with an exact phrase or tag token
- if note identity is ambiguous, resolve to an exact `path` before reading and graph analysis
- if a note is referenced by wikilink title rather than exact path, `file=<name>` can be the better addressing mode

### `obsidian-backlink-curator`

Purpose:
- improve vault connectivity and detect weak spots in the note graph

Primary commands:

```bash
obsidian backlinks path="<path>.md" counts format=json
obsidian links path="<path>.md"
obsidian orphans
obsidian deadends
obsidian unresolved verbose format=json
```

Recommended flow:

1. inspect outgoing and incoming links for the current note
2. identify missing links, unresolved targets, and possible hub notes
3. scan `orphans` and `deadends` to find structural cleanup candidates
4. produce high-confidence backlink suggestions only

Fallbacks:

- if the note target is unclear, start with `orphans` and `unresolved`
- if unresolved links are numerous, prioritize repeated targets first
- if a backlink query returns no results immediately after a write, retry after a short delay

## Supporting Commands

Useful helpers for future workflow expansion:

```bash
obsidian daily
obsidian daily:read
obsidian tasks daily
obsidian commands
obsidian command id="<command-id>"
obsidian plugins filter=community
obsidian plugin:reload id="<plugin-id>"
obsidian diff path="<path>.md" from=1
```

## Failure Modes

- CLI not installed or not registered
  - instruct the user to enable and register Obsidian CLI from Obsidian settings
- app launch failed
  - ask the user to open Obsidian manually and retry after the app is visibly running
- vault resolution failed
  - require `vault=<name>` or `vault=<id>` explicitly
- note resolution ambiguous
  - switch from `file=<name>` to exact `path=<path>`
- property update failed
  - fall back to frontmatter embedded in note content
