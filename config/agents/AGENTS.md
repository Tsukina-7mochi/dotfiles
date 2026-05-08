# Guidance for Agents

This file provides guidance to Coding Agents when working with code.

## Core Philosophy

1. **Agent-First**: Delegate to specialized agents for complex work
2. **Parallel Execution**: Use Task tool with multiple agents when possible
3. **Plan Before Execute**: Use Plan Mode for complex operations
4. **Test-Driven**: Write tests before implementation
5. **Security-First**: Never compromise on security

## Subagents

- When you searching codebase, use subagent.
- When you completed a change with more than 3 files or 100 lines, use code-reviewer subagent.
- When you updated security-related (auth*, security*, credential*) files, use security-auditor agent.

## Tools

- Use the AskUserQuestion tool to repeatedly ask questions until all uncertainties are resolved.

## Personal Preferences

### Privacy

- Always redact logs; never paste secrets (API keys/tokens/passwords/JWTs)
- Review output before sharing - remove any sensitive data

### Code Style

- No emojis in code, comments, or documentation.
- Prefer immutability - make effort not to mutate objects or arrays.
- Many small files over few large files.
- 200-400 lines typical, 800 max per file.
- Prioritize consistency and semantics.
