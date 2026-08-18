# Repository Guidelines

This repository stores personal dotfiles and related tooling.

## Project Structure & Module Organization

- config/: configuration of software
  - agents/: coding agent harnesses (Claude Code and Codex)
  - nvim/: Neovim
  - zsh/: Zsh
  - ... and others
- check.sh: script to test software availability
- link.sh: script to create symlink to configuration files/directories
- util: utility scripts

## Coding Style & Naming Conventions

- Follow `.editorconfig` and basic naming conventions for each languages.
- `link.sh` must be idempotent: it should yield the same result no matter how many times it is run.

## Git

- Use Conventional Commit with a scope in English. See `git log --oneline`.
- Split commits so that each one is independent and contains a single change.

## Security & Configuration Tips

- Do not commit machine-local secrets.
- Review `link.sh` target paths carefully when adding new links because it can replace user-facing configuration through symlinks.
- DO NEVER run `link.sh`. It is responsible for users.
