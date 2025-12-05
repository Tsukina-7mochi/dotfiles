# Genetic Instruction for Claude

## Rules of Subagents

- When you completed a change with more than 3 files or 100 lines, you must always launch code-reviewer subagent.
  - When you updated multiple files, launch the subagents concurrently.
- When you updated security-related (auth*, security*, credential*) files, you must always launch security-auditor agent.
