# Guidance for Claude

This file provides guidance to Claude Code (claude.ai/code) when working with code.

## Ask User Question

- Use Plan Mode for complex operations.
- Use the AskUserQuestion tool to repeatedly ask questions until all uncertainties are resolved.

## Subagents

When you completed a change with more than 3 files or 100 lines, you must always launch code-reviewer subagent.
  - When you updated multiple files, launch the subagents concurrently.
- When you updated security-related (auth*, security*, credential*) files, you must always launch security-auditor agent.

## Personal Preferences

### Code Style

- No emojis in code, comments, or documentation
- Prefer immutability - make effort not to mutate objects or arrays
- Many small files over few large files
- 200-400 lines typical, 800 max per file
