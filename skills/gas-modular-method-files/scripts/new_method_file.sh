#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  new_method_file.sh <function_name> [--dir <directory>] [--overwrite]

Examples:
  new_method_file.sh doGet
  new_method_file.sh createReport --dir src/methods
  new_method_file.sh onOpen --dir src/methods --overwrite
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

function_name="$1"
shift

target_dir="src/methods"
overwrite="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      if [[ $# -lt 2 ]]; then
        echo "Error: --dir requires a value." >&2
        exit 1
      fi
      target_dir="$2"
      shift 2
      ;;
    --overwrite)
      overwrite="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$1'." >&2
      usage
      exit 1
      ;;
  esac
done

if ! [[ "$function_name" =~ ^[A-Za-z_$][A-Za-z0-9_$]*$ ]]; then
  echo "Error: '$function_name' is not a valid JavaScript function name." >&2
  exit 1
fi

file_stem="$(printf '%s' "$function_name" \
  | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g; s/_+/-/g' \
  | tr '[:upper:]' '[:lower:]')"

mkdir -p "$target_dir"
target_path="${target_dir}/${file_stem}.gs"

if [[ -e "$target_path" && "$overwrite" != "true" ]]; then
  echo "Error: '$target_path' already exists. Use --overwrite to replace it." >&2
  exit 1
fi

cat > "$target_path" <<EOF
/**
 * TODO: Describe ${function_name}.
 */
function ${function_name}(e) {
  // TODO: Implement.
}
EOF

echo "Created ${target_path}"
