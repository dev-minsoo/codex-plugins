---
name: obsidian-vault-research
description: Research topics across an Obsidian vault by synthesizing evidence from note names, links, tags, and note metadata.
---

# Obsidian Vault Research

Use this skill when the task is to investigate a topic using existing Obsidian notes.

## Agent Routing

- primary: `graph-analyzer`
- supporting: `openai`

## Goals

- gather relevant context from multiple notes
- surface relationships between notes, tags, and recurring concepts
- produce a concise synthesis with traceable note references

## Expected Output

- a short research summary
- supporting notes or note candidates
- missing-context gaps that should be filled with new notes

## Default Behavior

- favor note-to-note relationships over isolated excerpts
- treat note titles, tags, and links as first-class signals
- separate confirmed findings from inferred connections
