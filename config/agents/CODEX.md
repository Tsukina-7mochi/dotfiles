# Guidance for Codex

This file provides guidance to Codex when working with code.

## Core Philosophy

1. **Agent-First**: Delegate to specialized agents for complex work
2. **Parallel Execution**: Run independent tool calls in parallel when possible
3. **Plan Before Execute**: Keep an explicit plan for complex operations
4. **Test-Driven**: Write tests before implementation
5. **Security-First**: Never compromise on security

## Subagents

Actively use subagents.

- When you searching codebase, use subagent.
- When you completed a change with more than 3 files or 100 lines, use code-reviewer subagent.
- When you updated security-related (auth*, security*, credential*) files, use security-auditor agent.

## Personal Preferences

- Ask the user questions repeatedly until all uncertainties are resolved.
- When user asks to add git worktree, make them in `.codex/worktrees`.

### Privacy

- Always redact logs; never paste secrets (API keys/tokens/passwords/JWTs)
- Review output before sharing - remove any sensitive data

### Code Style

- No emojis and Non-ASCII signs in code, comments, or documentation.
- Prefer immutability - make effort not to mutate objects or arrays.
- Many small files over few large files.
- 200-400 lines max per file.
- Prioritize consistency and semantics.
- Prefer nested list over tables in documentation.

### Code Comments & Documentations

- They must be snapshot. DO NOT write changelogs.
- Write more is worse than write nothing. Only write when you require investigation to understand your work.
