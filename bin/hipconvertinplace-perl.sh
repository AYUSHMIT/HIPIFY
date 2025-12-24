#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIPIFY_PERL="${SCRIPT_DIR}/hipify-perl"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] <path>
Options:
  -h, --help          Show this help
  --headers-only      Process only header files (*.h, *.hpp, *.hh, *.cuh)
  --inplace           Modify files in place (default behavior)
Examples:
  $(basename "$0") --headers-only ./my_project
EOF
}

HEADERS_ONLY=0
INPLACE=1

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --headers-only) HEADERS_ONLY=1; shift ;;
    --inplace) INPLACE=1; shift ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1"; usage; exit 1 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  echo "Error: path required"
  usage
  exit 1
fi

TARGET_PATH="${ARGS[-1]}"
if [[ ! -d "$TARGET_PATH" ]]; then
  echo "Error: '$TARGET_PATH' is not a directory"
  exit 1
fi

# Build file list
if [[ "$HEADERS_ONLY" -eq 1 ]]; then
  mapfile -t FILES < <(find "$TARGET_PATH" -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.hh' -o -name '*.cuh' \))
else
  mapfile -t FILES < <(find "$TARGET_PATH" -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cu' -o -name '*.cuh' -o -name '*.h' -o -name '*.hpp' -o -name '*.hh' \))
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No matching files found under '$TARGET_PATH'"
  exit 0
fi

echo "Processing ${#FILES[@]} files..."
for f in "${FILES[@]}"; do
  if [[ "$INPLACE" -eq 1 ]]; then
    perl "${HIPIFY_PERL}" "${f}" --inplace
  else
    perl "${HIPIFY_PERL}" "${f}"
  fi
done

echo "Done."
