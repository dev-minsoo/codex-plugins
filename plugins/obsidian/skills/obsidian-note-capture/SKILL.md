---
name: obsidian-note-capture
description: Capture conversations, rough notes, and meeting outcomes into clean Obsidian Markdown notes with frontmatter and link suggestions.
---

# Obsidian Note Capture

Use this skill when turning raw text into a durable Obsidian note.

## Agent Routing

- primary: `note-refiner`
- supporting: `markdown-styler`
- optional: `openai`

## Goals

- produce Markdown that is easy to keep in an Obsidian vault
- preserve important decisions, tasks, and follow-up items
- suggest note titles, tags, and internal links when context supports them

## Expected Output

- a note title
- optional frontmatter when metadata is available
- clean Markdown sections
- candidate backlinks or linked-note references

## Capture Template

Use this default shape unless the user already provided a stronger template:

```md
---
title: "<note title>"
aliases: []
tags: [<tag-1>, <tag-2>]
source: "<conversation|meeting|idea|article>"
created: "<YYYY-MM-DD>"
status: "<seed|draft|evergreen>"
---

# <note title>

## Summary

<2-4 sentence summary>

## Key Points

- point one
- point two

## Open Questions

- question or uncertainty

## Related Notes

- [[Existing Note A]]
- [[Existing Note B]]
```

## Capture Rules

- prefer one focused idea per note when the input supports it
- use frontmatter only for metadata that is actually known
- suggest `[[wikilinks]]` only when the target is known or strongly implied
- keep action items as Markdown tasks such as `- [ ] follow up`
- if the input mixes several topics, split them into a primary note plus follow-up note suggestions
- when execution is available, emit output that can be written through the raw Obsidian CLI without extra cleanup

## Execution Guidance

- prefer `obsidian create path="<path>.md" content="<markdown body>"` when the destination folder or exact note path is known
- prefer `obsidian create name="<note name>" content="<markdown body>"` only for simple standalone notes without an exact folder target
- use `obsidian append path="<path>.md" content="<markdown block>"` or `obsidian prepend ...` for additive updates
- use `obsidian daily:append content="<markdown block>"` for journal-style capture
- use `obsidian property:set` only when structured metadata is clearer than frontmatter

## Default Behavior

- prefer concise Markdown over verbose prose
- use Obsidian-friendly headings and bullet lists
- keep unresolved details as explicit TODO markers instead of inventing facts
