# Guidance for Coding Agents

This file provides guidance to coding agents when working with code.

## Core Philosophy

1. **Agent-First**: Delegate to specialized agents for complex work
2. **Parallel Execution**: Run independent agents and tool calls in parallel when possible
3. **Plan Before Execute**: Make an explicit plan for complex operations
4. **Test-Driven**: Write tests before implementation
5. **Security-First**: Never compromise on security

## Subagents

Use subagents only when it is desirable to use a new context:

- When a new context is required
  - When an objective perspective is needed, such as for reviews or proofreading
  - When observing the behavior of a blank-slate agent that knows nothing, such as in benchmarking
- When it is necessary to read a large amount of irrelevant data
  - Exploring including irrelevant files in a large-scale code investigation, and then investigating only the relevant files in detail based on those results

- When you completed a change with more than 3 files or 100 lines, use code-reviewer subagent.
- When you updated security-related (auth*, security*, credential*) files, use security-auditor agent.

## Personal Preferences

- Ask the user questions repeatedly until all uncertainties are resolved.
- When user asks to add git worktree, make them in the harness directory.
  - Claude Code: `.claude/worktrees`
  - Codex: `.codex/worktrees`
  - Other: `.agents/worktrees`
- Do not perform refactoring out of the scope of order.

### Privacy

- Always redact logs; never paste secrets (API keys/tokens/passwords/JWTs)
- Review output before sharing - remove any sensitive data

### Output Style (including codes)

- No emojis and Non-ASCII signs in code, comments, or documentation.
- Explain through structure, layout, and naming; avoid unnecessary explanations and secondary labels.
- Prefer nested list over tables

### Code Style

- Prefer immutability - make effort not to mutate objects or arrays
- Prefer symmetricity - the more similar the logic, the more similar the text should be
- Prioritize consistency and semantics
- Many small files over few large files
- 200-400 lines max per file
