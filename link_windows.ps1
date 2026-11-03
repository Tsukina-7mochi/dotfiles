# Windows counterpart of link.sh (vim, git and agents only).
# Creating symbolic links requires Developer Mode or an elevated shell.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# creates symbolic link from ./config/$Source to $Target
# replaces $Target if it is already a symbolic link or a file
function Link-Config([string]$Source, [string]$Target) {
  $src = Join-Path $PSScriptRoot "config/$Source"
  New-Item -ItemType Directory -Force (Split-Path -Parent $Target) | Out-Null

  $existing = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
  if ($existing -and $existing.LinkType) {
    # Remove the link itself, not the target it points to
    $existing.Delete()
  } elseif ($existing -and $existing.PSIsContainer) {
    Write-Warning "skipped: '$Target' is a real directory; move or remove it and run again"
    return
  }

  New-Item -ItemType SymbolicLink -Force -Path $Target -Target $src | Out-Null
  Write-Output "'$Target' -> '$src'"
}

$XdgConfigHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME '.config' }

# Vim on Windows does not read $XDG_CONFIG_HOME/vim/vimrc; use ~/vimfiles/vimrc instead
Link-Config .vimrc "$HOME/vimfiles/vimrc"
Link-Config .vimrc "$HOME/.ideavimrc"
Link-Config .gitconfig "$XdgConfigHome/git/config"
Link-Config .gitignore_global "$XdgConfigHome/git/.gitignore"

Link-Config agents/AGENTS.md "$HOME/.claude/CLAUDE.md"
Link-Config agents/claude-agents "$HOME/.claude/agents"
Link-Config agents/rules "$HOME/.claude/rules"
Link-Config agents/skills "$HOME/.claude/skills"
Link-Config agents/settings.claude.json "$HOME/.claude/settings.json"
Link-Config agents/notify.sh "$HOME/.claude/notify.sh"

Link-Config agents/AGENTS.md "$HOME/.agents/instructions.md"
Link-Config agents/codex-agents "$HOME/.agents/agents"
Link-Config agents/rules "$HOME/.agents/rules"
Link-Config agents/skills "$HOME/.agents/skills"
Link-Config agents/hooks.codex.json "$HOME/.codex/hooks.json"
