#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# agents-skills installer
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC_DIR="$SCRIPT_DIR/skills"
AGENTS_SRC_DIR="$SCRIPT_DIR/agents"

# Resolve a directory to its real path (follows symlinks, macOS compatible)
resolve_dir() {
  local d="$1"
  if [ -d "$d" ]; then
    (cd "$d" && pwd -P)
  elif [ -L "$d" ]; then
    local parent
    parent="$(cd "$(dirname "$d")" && pwd -P)"
    local target
    target="$(readlink "$d")"
    if [[ "$target" = /* ]]; then
      resolve_dir "$target"
    else
      resolve_dir "$parent/$target"
    fi
  else
    echo "$d"
  fi
}

# Target directories (order matters for display, deduplicated by real path)
CANDIDATE_DIRS=()
if [ -d "$HOME/.agents/skills" ]; then
  CANDIDATE_DIRS+=("$HOME/.agents/skills")
fi
CANDIDATE_DIRS+=("$HOME/.claude/skills" "$HOME/.codex/skills")

# Deduplicate targets by real path
_build_target_dirs() {
  local real seen=() candidate
  for candidate in "${CANDIDATE_DIRS[@]}"; do
    real="$(resolve_dir "$candidate")"
    local is_dup=false
    for s in "${seen[@]+"${seen[@]}"}"; do
      if [ "$s" = "$real" ]; then
        is_dup=true
        break
      fi
    done
    if [ "$is_dup" = false ]; then
      TARGET_DIRS+=("$candidate")
      seen+=("$real")
    fi
  done
}
TARGET_DIRS=()
_build_target_dirs

# Modes
MODE="symlink"  # symlink or copy
FORCE=false
SCOPE=""  # project, global, or "" (ask interactively)

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  RED='' GREEN='' YELLOW='' CYAN='' BOLD='' RESET=''
fi

info()  { printf "${GREEN}✓${RESET} %s\n" "$1"; }
warn()  { printf "${YELLOW}!${RESET} %s\n" "$1"; }
error() { printf "${RED}✗${RESET} %s\n" "$1" >&2; }

# ============================================================
# Resolve absolute path (macOS compatible, no readlink -f)
# ============================================================
resolve_path() {
  local target="$1"
  if [ -d "$target" ]; then
    (cd "$target" && pwd)
  elif [ -f "$target" ]; then
    local dir
    dir="$(cd "$(dirname "$target")" && pwd)"
    echo "$dir/$(basename "$target")"
  else
    echo "$target"
  fi
}

# ============================================================
# Parse SKILL.md frontmatter — extract a field value
# ============================================================
parse_frontmatter() {
  local file="$1" field="$2"
  local in_front=false value=""
  while IFS= read -r line; do
    if [ "$in_front" = false ]; then
      if [ "$line" = "---" ]; then
        in_front=true
      fi
      continue
    fi
    if [ "$line" = "---" ]; then
      break
    fi
    case "$line" in
      "${field}:"*)
        value="${line#*: }"
        ;;
    esac
  done < "$file"
  echo "$value"
}

# ============================================================
# List available skills from source
# ============================================================
list_source_skills() {
  local skills=()
  for dir in "$SKILLS_SRC_DIR"/*/; do
    [ -d "$dir" ] || continue
    local name
    name="$(basename "$dir")"
    skills+=("$name")
  done
  printf '%s\n' "${skills[@]}" | sort
}

# ============================================================
# Check if a skill is installed in a target dir
# ============================================================
check_installed() {
  local skill="$1" target="$2"
  local dest="$target/$skill"
  if [ -L "$dest" ]; then
    # Check if symlink is valid
    if [ -e "$dest" ]; then
      echo "symlink"
    else
      echo "broken-symlink"
    fi
  elif [ -d "$dest" ]; then
    echo "copy"
  else
    echo "none"
  fi
}

# ============================================================
# cmd_list — show available skills and install status
# ============================================================
cmd_list() {
  printf "${BOLD}Available skills:${RESET}\n\n"
  local skills
  skills="$(list_source_skills)"
  while IFS= read -r skill; do
    local skill_md="$SKILLS_SRC_DIR/$skill/SKILL.md"
    local desc=""
    if [ -f "$skill_md" ]; then
      desc="$(parse_frontmatter "$skill_md" "description")"
    fi

    # Check install status across all targets
    local statuses=()
    for target in "${TARGET_DIRS[@]}"; do
      local st
      st="$(check_installed "$skill" "$target")"
      local short_target
      short_target="$(basename "$(dirname "$target")")"
      case "$st" in
        symlink)       statuses+=("${GREEN}${short_target}:linked${RESET}") ;;
        copy)          statuses+=("${CYAN}${short_target}:copied${RESET}") ;;
        broken-symlink) statuses+=("${RED}${short_target}:broken${RESET}") ;;
        none)          statuses+=("${YELLOW}${short_target}:--${RESET}") ;;
      esac
    done

    local status_str
    status_str="$(IFS=', '; echo "${statuses[*]}")"
    printf "  ${BOLD}%-35s${RESET} [%b]\n" "$skill" "$status_str"
    if [ -n "$desc" ]; then
      # Truncate long descriptions
      if [ "${#desc}" -gt 80 ]; then
        desc="${desc:0:77}..."
      fi
      printf "    %s\n" "$desc"
    fi
  done <<< "$skills"
  echo
}

# ============================================================
# install_skill — install a single skill to a single target
# ============================================================
install_skill() {
  local skill="$1" target="$2"
  local src="$SKILLS_SRC_DIR/$skill"
  local dest="$target/$skill"

  # Validate source exists
  if [ ! -d "$src" ]; then
    error "Skill not found: $skill"
    return 1
  fi

  # Protect .system
  if [[ "$skill" == *".system"* ]]; then
    error "Cannot install skill with '.system' in name: $skill"
    return 1
  fi

  # Ensure target directory exists
  mkdir -p "$target"

  # Handle existing installation
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$FORCE" = true ]; then
      rm -rf "$dest"
    else
      local existing
      existing="$(check_installed "$skill" "$target")"
      warn "Already installed in $target ($existing). Use --force to overwrite."
      return 0
    fi
  fi

  local abs_src
  abs_src="$(resolve_path "$src")"

  if [ "$MODE" = "symlink" ]; then
    ln -s "$abs_src" "$dest"
  else
    cp -RP "$abs_src" "$dest"
  fi
}

# ============================================================
# ask_scope — interactively ask project or global
# ============================================================
ask_scope() {
  if [ ! -t 0 ]; then
    # Non-interactive: default to global
    SCOPE="global"
    return
  fi
  printf "\n${BOLD}Where do you want to install?${RESET}\n"
  printf "  ${CYAN}1)${RESET} Project  — ./.claude/skills/ (current project only)\n"
  printf "  ${CYAN}2)${RESET} Global   — ~/.agents/skills/, ~/.claude/skills/, ~/.codex/skills/\n"
  printf "\n"
  while true; do
    printf "Select [1/2]: "
    read -r choice
    case "$choice" in
      1|project|p)  SCOPE="project"; break ;;
      2|global|g)   SCOPE="global"; break ;;
      *)            warn "Please enter 1 or 2" ;;
    esac
  done
}

# ============================================================
# resolve_install_targets — set targets based on scope
# ============================================================
resolve_install_targets() {
  local targets=()
  if [ "$SCOPE" = "project" ]; then
    targets+=("./.claude/skills")
  else
    targets=("${TARGET_DIRS[@]}")
  fi
  INSTALL_TARGETS=("${targets[@]}")
}

# ============================================================
# cmd_install — install skills to selected target directories
# ============================================================
cmd_install() {
  local skills=("$@")

  # Ask scope if not specified via flag
  if [ -z "$SCOPE" ]; then
    ask_scope
  fi
  resolve_install_targets

  local scope_label="global"
  if [ "$SCOPE" = "project" ]; then
    scope_label="project (./.claude/skills/)"
  fi
  printf "\n${BOLD}Scope:${RESET} %s\n\n" "$scope_label"

  # If no skills specified, install all
  if [ ${#skills[@]} -eq 0 ]; then
    while IFS= read -r s; do
      skills+=("$s")
    done <<< "$(list_source_skills)"
  fi

  local total=0 installed=0

  for skill in "${skills[@]}"; do
    if [ ! -d "$SKILLS_SRC_DIR/$skill" ]; then
      error "Unknown skill: $skill"
      continue
    fi
    for target in "${INSTALL_TARGETS[@]}"; do
      total=$((total + 1))
      if install_skill "$skill" "$target"; then
        installed=$((installed + 1))
      fi
    done
    info "Installed: $skill ($MODE) → ${#INSTALL_TARGETS[@]} target(s)"
  done

  echo
  info "Done. $installed/$total installation(s) completed."
}

# ============================================================
# uninstall_skill — remove a single skill from a single target
# ============================================================
uninstall_skill() {
  local skill="$1" target="$2"
  local dest="$target/$skill"

  # Protect .system
  if [[ "$skill" == *".system"* ]] || [ "$skill" = ".system" ]; then
    error "Refusing to touch .system: $skill"
    return 1
  fi

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -d "$dest" ]; then
    rm -rf "$dest"
  else
    return 0  # Not installed, nothing to do
  fi
}

# ============================================================
# cmd_uninstall — remove skills from all target directories
# ============================================================
cmd_uninstall() {
  local skills=("$@")

  # If no skills specified, uninstall all repo skills
  if [ ${#skills[@]} -eq 0 ]; then
    while IFS= read -r s; do
      skills+=("$s")
    done <<< "$(list_source_skills)"
  fi

  for skill in "${skills[@]}"; do
    for target in "${TARGET_DIRS[@]}"; do
      uninstall_skill "$skill" "$target"
    done
    info "Uninstalled: $skill"
  done
  echo
}

# ============================================================
# cmd_status — show detailed status of installed skills
# ============================================================
cmd_status() {
  printf "${BOLD}Installation status:${RESET}\n\n"
  for target in "${TARGET_DIRS[@]}"; do
    printf "  ${CYAN}%s${RESET}\n" "$target"
    if [ ! -d "$target" ]; then
      printf "    (directory does not exist)\n\n"
      continue
    fi
    local found=false
    for entry in "$target"/*; do
      [ -d "$entry" ] || [ -L "$entry" ] || continue
      local name
      name="$(basename "$entry")"
      # Skip .system
      [[ "$name" == .system* ]] && continue
      found=true

      if [ -L "$entry" ]; then
        local link_target
        link_target="$(readlink "$entry")"
        if [ -e "$entry" ]; then
          printf "    ${GREEN}%-30s${RESET} symlink → %s\n" "$name" "$link_target"
        else
          printf "    ${RED}%-30s${RESET} broken symlink → %s\n" "$name" "$link_target"
        fi
      elif [ -d "$entry" ]; then
        printf "    ${CYAN}%-30s${RESET} copy\n" "$name"
      fi
    done
    if [ "$found" = false ]; then
      printf "    (no skills installed)\n"
    fi
    echo
  done
}

# ============================================================
# Agent functions
# ============================================================

AGENT_GLOBAL_DIR="$HOME/.claude/agents"

list_source_agents() {
  local agents=()
  for file in "$AGENTS_SRC_DIR"/*.md; do
    [ -f "$file" ] || continue
    agents+=("$(basename "$file" .md)")
  done
  printf '%s\n' "${agents[@]}" | sort
}

check_agent_installed() {
  local agent="$1" target="$2"
  local dest="$target/${agent}.md"
  if [ -L "$dest" ]; then
    if [ -e "$dest" ]; then echo "symlink"; else echo "broken-symlink"; fi
  elif [ -f "$dest" ]; then
    echo "copy"
  else
    echo "none"
  fi
}

install_agent() {
  local agent="$1" target="$2"
  local src="$AGENTS_SRC_DIR/${agent}.md"
  local dest="$target/${agent}.md"

  if [ ! -f "$src" ]; then
    error "Agent not found: $agent"
    return 1
  fi

  mkdir -p "$target"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$FORCE" = true ]; then
      rm -f "$dest"
    else
      local existing
      existing="$(check_agent_installed "$agent" "$target")"
      warn "Agent already installed in $target ($existing). Use --force to overwrite."
      return 0
    fi
  fi

  local abs_src
  abs_src="$(resolve_path "$src")"

  if [ "$MODE" = "symlink" ]; then
    ln -s "$abs_src" "$dest"
  else
    cp -P "$abs_src" "$dest"
  fi
}

uninstall_agent() {
  local agent="$1" target="$2"
  local dest="$target/${agent}.md"

  if [ -L "$dest" ] || [ -f "$dest" ]; then
    rm -f "$dest"
  fi
}

cmd_list_agents() {
  printf "${BOLD}Available agents:${RESET}\n\n"
  local agents
  agents="$(list_source_agents)"
  while IFS= read -r agent; do
    local agent_md="$AGENTS_SRC_DIR/${agent}.md"
    local model=""
    model="$(parse_frontmatter "$agent_md" "model")"

    # Check install status
    local global_st project_st
    global_st="$(check_agent_installed "$agent" "$AGENT_GLOBAL_DIR")"
    project_st="$(check_agent_installed "$agent" "./.claude/agents")"

    local statuses=()
    case "$global_st" in
      symlink)       statuses+=("${GREEN}global:linked${RESET}") ;;
      copy)          statuses+=("${CYAN}global:copied${RESET}") ;;
      broken-symlink) statuses+=("${RED}global:broken${RESET}") ;;
      none)          statuses+=("${YELLOW}global:--${RESET}") ;;
    esac
    case "$project_st" in
      symlink)       statuses+=("${GREEN}project:linked${RESET}") ;;
      copy)          statuses+=("${CYAN}project:copied${RESET}") ;;
      broken-symlink) statuses+=("${RED}project:broken${RESET}") ;;
      none)          statuses+=("${YELLOW}project:--${RESET}") ;;
    esac

    local status_str
    status_str="$(IFS=', '; echo "${statuses[*]}")"
    printf "  ${BOLD}%-35s${RESET} [%b] model=%s\n" "$agent" "$status_str" "${model:-unknown}"
  done <<< "$agents"
  echo
}

cmd_install_agents() {
  local agents=("$@")

  if [ -z "$SCOPE" ]; then
    ask_scope
  fi

  local target
  if [ "$SCOPE" = "project" ]; then
    target="./.claude/agents"
  else
    target="$AGENT_GLOBAL_DIR"
  fi

  local scope_label="global (~/.claude/agents/)"
  if [ "$SCOPE" = "project" ]; then
    scope_label="project (./.claude/agents/)"
  fi
  printf "\n${BOLD}Scope:${RESET} %s\n\n" "$scope_label"

  # If no agents specified, install all
  if [ ${#agents[@]} -eq 0 ]; then
    while IFS= read -r a; do
      agents+=("$a")
    done <<< "$(list_source_agents)"
  fi

  local total=0 installed=0

  for agent in "${agents[@]}"; do
    if [ ! -f "$AGENTS_SRC_DIR/${agent}.md" ]; then
      error "Unknown agent: $agent"
      continue
    fi
    total=$((total + 1))
    if install_agent "$agent" "$target"; then
      installed=$((installed + 1))
    fi
    info "Installed agent: $agent ($MODE) → $target"
  done

  echo
  info "Done. $installed/$total agent installation(s) completed."
}

cmd_uninstall_agents() {
  local agents=("$@")

  if [ ${#agents[@]} -eq 0 ]; then
    while IFS= read -r a; do
      agents+=("$a")
    done <<< "$(list_source_agents)"
  fi

  for agent in "${agents[@]}"; do
    uninstall_agent "$agent" "$AGENT_GLOBAL_DIR"
    uninstall_agent "$agent" "./.claude/agents"
    info "Uninstalled agent: $agent"
  done
  echo
}

cmd_status_agents() {
  printf "${BOLD}Agent installation status:${RESET}\n\n"
  for target in "$AGENT_GLOBAL_DIR" "./.claude/agents"; do
    printf "  ${CYAN}%s${RESET}\n" "$target"
    if [ ! -d "$target" ]; then
      printf "    (directory does not exist)\n\n"
      continue
    fi
    local found=false
    for entry in "$target"/*.md; do
      [ -f "$entry" ] || [ -L "$entry" ] || continue
      local name
      name="$(basename "$entry" .md)"
      found=true

      if [ -L "$entry" ]; then
        local link_target
        link_target="$(readlink "$entry")"
        if [ -e "$entry" ]; then
          printf "    ${GREEN}%-30s${RESET} symlink → %s\n" "$name" "$link_target"
        else
          printf "    ${RED}%-30s${RESET} broken symlink → %s\n" "$name" "$link_target"
        fi
      elif [ -f "$entry" ]; then
        printf "    ${CYAN}%-30s${RESET} copy\n" "$name"
      fi
    done
    if [ "$found" = false ]; then
      printf "    (no agents installed)\n"
    fi
    echo
  done
}

# ============================================================
# Help
# ============================================================
cmd_help() {
  cat <<'HELP'
Usage: ./install.sh <command> [options] [name ...]

Skill commands:
  list              Show available skills and installation status
  install           Install skills (all if no name specified)
  uninstall         Uninstall skills (all if no name specified)
  status            Show detailed status of installed skills

Agent commands:
  list-agents       Show available agents and installation status
  install-agents    Install agents (all if no name specified)
  uninstall-agents  Uninstall agents (all if no name specified)
  status-agents     Show detailed status of installed agents

Options:
  --project   Install to ./.claude/{skills,agents}/ (current project only)
  --global    Install to global directories (~/.agents/skills/, ~/.claude/agents/, etc.)
  --copy      Copy files instead of creating symlinks (default: symlink)
  --force     Overwrite existing installations
  --help      Show this help message

If neither --project nor --global is specified, you will be prompted interactively.

Examples:
  ./install.sh list
  ./install.sh install find-skills
  ./install.sh install --project flow-plan
  ./install.sh install --global --force
  ./install.sh list-agents
  ./install.sh install-agents marp-slide-creator
  ./install.sh install-agents --project
  ./install.sh status-agents
HELP
}

# ============================================================
# Argument parser + main
# ============================================================
main() {
  local command=""
  local skill_args=()

  # Parse arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      --copy)    MODE="copy" ;;
      --force)   FORCE=true ;;
      --project) SCOPE="project" ;;
      --global)  SCOPE="global" ;;
      --help|-h) cmd_help; exit 0 ;;
      list|install|uninstall|status|list-agents|install-agents|uninstall-agents|status-agents)
        if [ -z "$command" ]; then
          command="$1"
        else
          skill_args+=("$1")
        fi
        ;;
      -*)
        error "Unknown option: $1"
        cmd_help
        exit 1
        ;;
      *)
        skill_args+=("$1")
        ;;
    esac
    shift
  done

  if [ -z "$command" ]; then
    cmd_help
    exit 1
  fi

  case "$command" in
    list)              cmd_list ;;
    install)           cmd_install "${skill_args[@]+"${skill_args[@]}"}" ;;
    uninstall)         cmd_uninstall "${skill_args[@]+"${skill_args[@]}"}" ;;
    status)            cmd_status ;;
    list-agents)       cmd_list_agents ;;
    install-agents)    cmd_install_agents "${skill_args[@]+"${skill_args[@]}"}" ;;
    uninstall-agents)  cmd_uninstall_agents "${skill_args[@]+"${skill_args[@]}"}" ;;
    status-agents)     cmd_status_agents ;;
    *)                 cmd_help; exit 1 ;;
  esac
}

main "$@"
