# Obsidian Scripts

This directory contains local helper scripts for running bundled Obsidian workflows through the official Obsidian CLI.

## Available Scripts

- `obsidian-cli-runner.sh`: thin wrapper around common capture, research, and backlink commands

## Notes

- the runner assumes `obsidian` CLI is installed and registered
- it performs a readiness check before dispatching commands
- it is intentionally small and only covers the bundled workflow surface
- `research-read`, `backlinks`, and `links` support either exact `--path` or wikilink-style `--file` targeting
