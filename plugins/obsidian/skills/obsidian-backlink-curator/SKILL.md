---
name: obsidian-backlink-curator
description: Improve vault connectivity by suggesting backlinks, related notes, and note-splitting opportunities inside Obsidian workflows.
---

# Obsidian Backlink Curator

Use this skill when improving how notes connect to each other.

## Agent Routing

- primary: `graph-analyzer`
- supporting: `openai`
- optional: `note-refiner`

## Goals

- identify likely backlinks and related notes
- suggest where links are missing
- recommend when a large note should be split or indexed

## Expected Output

- backlink suggestions
- related-note suggestions
- note structure recommendations when a page is too broad

## Default Behavior

- prefer high-confidence link suggestions over exhaustive link spam
- recommend index or hub notes when a topic spans many pages
- call out ambiguous link targets instead of guessing
