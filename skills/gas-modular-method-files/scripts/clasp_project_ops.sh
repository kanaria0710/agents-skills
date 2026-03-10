#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  clasp_project_ops.sh <subcommand> [options]

Subcommands:
  check-version          Check installed clasp version against npm latest
  install-clasp          Install clasp globally from npm
  create-new-sheets      Create a new Spreadsheet-bound GAS project
  create-existing-sheets  Create a GAS project bound to an existing Spreadsheet
  clone                   Clone an existing Apps Script project
  pull                    Pull remote changes
  push                    Push local changes
  logs                    Show recent logs
  status                  Show push target file status
  list                    List script projects

Global options:
  --print-only            Print the resolved clasp command without executing it

Examples:
  clasp_project_ops.sh check-version
  clasp_project_ops.sh check-version --install-if-missing
  clasp_project_ops.sh install-clasp
  clasp_project_ops.sh create-new-sheets --title "Sales Tool" --root-dir src
  clasp_project_ops.sh create-existing-sheets --title "Sales Tool" --parent-id "<spreadsheet-id>" --root-dir src
  clasp_project_ops.sh clone --script-id "<script-id>" --root-dir src
  clasp_project_ops.sh pull
  clasp_project_ops.sh push --force
  clasp_project_ops.sh logs --watch --simplified
EOF
}

run_cmd() {
  if [[ "${print_only}" == "true" ]]; then
    printf 'Resolved command:'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi

  if [[ "${1:-}" == "clasp" ]] && ! command -v clasp >/dev/null 2>&1; then
    echo "Error: clasp is not installed or not found in PATH." >&2
    echo "Install with: $0 install-clasp" >&2
    exit 1
  fi

  "$@"
}

require_non_empty() {
  local name="$1"
  local value="$2"
  if [[ -z "${value}" ]]; then
    echo "Error: ${name} is required." >&2
    exit 1
  fi
}

install_clasp() {
  run_cmd npm i -g @google/clasp@latest
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

subcommand="$1"
shift

print_only="false"

case "${subcommand}" in
  check-version)
    strict="false"
    install_if_missing="false"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --strict)
          strict="true"
          shift
          ;;
        --install-if-missing)
          install_if_missing="true"
          shift
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    if [[ "${print_only}" == "true" ]]; then
      if [[ "${install_if_missing}" == "true" ]]; then
        echo "Resolved command: npm i -g @google/clasp@latest"
      fi
      echo "Resolved command: npm view @google/clasp version --fetch-retries=1 --fetch-timeout=8000"
      exit 0
    fi

    local_version="$( (clasp --version 2>/dev/null || true) | awk 'NF {print $1; exit}')"
    if [[ -z "${local_version}" ]]; then
      if [[ "${install_if_missing}" == "true" ]]; then
        echo "clasp is not installed. Installing..."
        install_clasp
        local_version="$( (clasp --version 2>/dev/null || true) | awk 'NF {print $1; exit}')"
      fi
    fi

    if [[ -z "${local_version}" ]]; then
      echo "Error: clasp is not installed or not found in PATH." >&2
      echo "Install command: npm i -g @google/clasp@latest" >&2
      exit 1
    fi

    latest_version="$(npm view @google/clasp version --fetch-retries=1 --fetch-timeout=8000 2>/dev/null || true)"
    latest_version="$(printf '%s' "${latest_version}" | awk 'NF {print $1; exit}')"

    echo "Installed clasp: ${local_version}"

    if [[ -z "${latest_version}" ]]; then
      echo "Warning: Could not fetch latest clasp version from npm registry."
      echo "Hint: Check network/proxy settings and run again."
      if [[ "${strict}" == "true" ]]; then
        exit 2
      fi
      exit 0
    fi

    echo "Latest clasp:    ${latest_version}"
    if [[ "${local_version}" == "${latest_version}" ]]; then
      echo "Status: up-to-date"
      exit 0
    fi

    echo "Status: update available"
    echo "Update command: npm i -g @google/clasp@latest"
    if [[ "${strict}" == "true" ]]; then
      exit 3
    fi
    exit 0
    ;;

  install-clasp)
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    install_clasp
    if [[ "${print_only}" != "true" ]]; then
      echo "Installed clasp: $(clasp --version | awk 'NF {print $1; exit}')"
    fi
    ;;

  create-new-sheets)
    title=""
    root_dir="src"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --title)
          require_non_empty "--title value" "${2:-}"
          title="$2"
          shift 2
          ;;
        --root-dir)
          require_non_empty "--root-dir value" "${2:-}"
          root_dir="$2"
          shift 2
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    require_non_empty "--title" "${title}"
    run_cmd clasp create --type sheets --title "${title}" --rootDir "${root_dir}"
    ;;

  create-existing-sheets)
    title=""
    parent_id=""
    root_dir="src"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --title)
          require_non_empty "--title value" "${2:-}"
          title="$2"
          shift 2
          ;;
        --parent-id)
          require_non_empty "--parent-id value" "${2:-}"
          parent_id="$2"
          shift 2
          ;;
        --root-dir)
          require_non_empty "--root-dir value" "${2:-}"
          root_dir="$2"
          shift 2
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    require_non_empty "--title" "${title}"
    require_non_empty "--parent-id" "${parent_id}"
    run_cmd clasp create --type sheets --title "${title}" --parentId "${parent_id}" --rootDir "${root_dir}"
    ;;

  clone)
    script_id=""
    version_number=""
    root_dir=""

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --script-id)
          require_non_empty "--script-id value" "${2:-}"
          script_id="$2"
          shift 2
          ;;
        --version)
          require_non_empty "--version value" "${2:-}"
          version_number="$2"
          shift 2
          ;;
        --root-dir)
          require_non_empty "--root-dir value" "${2:-}"
          root_dir="$2"
          shift 2
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    require_non_empty "--script-id" "${script_id}"

    cmd=(clasp clone "${script_id}")
    if [[ -n "${version_number}" ]]; then
      cmd+=("${version_number}")
    fi
    if [[ -n "${root_dir}" ]]; then
      cmd+=(--rootDir "${root_dir}")
    fi

    run_cmd "${cmd[@]}"
    ;;

  pull)
    version_number=""

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --version)
          require_non_empty "--version value" "${2:-}"
          version_number="$2"
          shift 2
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    cmd=(clasp pull)
    if [[ -n "${version_number}" ]]; then
      cmd+=(--versionNumber "${version_number}")
    fi

    run_cmd "${cmd[@]}"
    ;;

  push)
    force="false"
    watch="false"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --force)
          force="true"
          shift
          ;;
        --watch)
          watch="true"
          shift
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    cmd=(clasp push)
    if [[ "${force}" == "true" ]]; then
      cmd+=(--force)
    fi
    if [[ "${watch}" == "true" ]]; then
      cmd+=(--watch)
    fi

    run_cmd "${cmd[@]}"
    ;;

  logs)
    watch="false"
    json="false"
    simplified="false"

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --watch)
          watch="true"
          shift
          ;;
        --json)
          json="true"
          shift
          ;;
        --simplified)
          simplified="true"
          shift
          ;;
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done

    cmd=(clasp logs)
    if [[ "${watch}" == "true" ]]; then
      cmd+=(--watch)
    fi
    if [[ "${json}" == "true" ]]; then
      cmd+=(--json)
    fi
    if [[ "${simplified}" == "true" ]]; then
      cmd+=(--simplified)
    fi

    run_cmd "${cmd[@]}"
    ;;

  status)
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done
    run_cmd clasp status
    ;;

  list)
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --print-only)
          print_only="true"
          shift
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          echo "Error: Unknown option '$1' for ${subcommand}." >&2
          exit 1
          ;;
      esac
    done
    run_cmd clasp list
    ;;

  -h|--help|help)
    usage
    ;;

  *)
    echo "Error: Unknown subcommand '${subcommand}'." >&2
    usage
    exit 1
    ;;
esac
