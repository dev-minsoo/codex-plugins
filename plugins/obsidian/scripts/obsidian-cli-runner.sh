#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  obsidian-cli-runner.sh check [--vault <vault>]
  obsidian-cli-runner.sh capture-create --name <name> --content <content> [--vault <vault>] [--open]
  obsidian-cli-runner.sh capture-append --path <path> --content <content> [--vault <vault>] [--inline]
  obsidian-cli-runner.sh capture-prepend --path <path> --content <content> [--vault <vault>] [--inline]
  obsidian-cli-runner.sh capture-daily --content <content> [--vault <vault>] [--inline] [--open]
  obsidian-cli-runner.sh property-set --path <path> --name <property> --value <value> [--type <type>] [--vault <vault>]
  obsidian-cli-runner.sh research-search --query <query> [--vault <vault>]
  obsidian-cli-runner.sh research-read (--path <path> | --file <note>) [--vault <vault>]
  obsidian-cli-runner.sh backlinks (--path <path> | --file <note>) [--vault <vault>] [--format <format>] [--counts]
  obsidian-cli-runner.sh links (--path <path> | --file <note>) [--vault <vault>]
  obsidian-cli-runner.sh orphans [--vault <vault>]
  obsidian-cli-runner.sh unresolved [--vault <vault>] [--format <format>] [--verbose]
EOF
}

fail() {
  echo "error: $*" >&2
  exit 1
}

ensure_obsidian_ready() {
  if command -v obsidian >/dev/null 2>&1; then
    if obsidian version >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
    if obsidian version >/dev/null 2>&1; then
      return 0
    fi
    fail "Obsidian CLI was found, but the app did not become ready. Open Obsidian and verify CLI registration."
  fi
  fail "Obsidian CLI is not installed or not registered."
}

build_base_args() {
  BASE_ARGS=()
  if [[ -n "${VAULT:-}" ]]; then
    BASE_ARGS+=("vault=${VAULT}")
  fi
}

run_obsidian() {
  build_base_args
  if [[ ${#BASE_ARGS[@]} -gt 0 ]]; then
    obsidian "${BASE_ARGS[@]}" "$@"
  else
    obsidian "$@"
  fi
}

parse_common_arg() {
  case "$1" in
    --vault)
      [[ $# -ge 2 ]] || fail "--vault requires a value"
      VAULT="$2"
      return 2
      ;;
    *)
      return 1
      ;;
  esac
}

COMMAND="${1:-}"
[[ -n "$COMMAND" ]] || {
  usage
  exit 1
}
shift

VAULT=""
ensure_obsidian_ready

case "$COMMAND" in
  check)
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      fail "Unknown argument for check: $1"
    done
    run_obsidian version
    ;;

  capture-create)
    NAME=""
    CONTENT=""
    OPEN=false
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --name) NAME="$2"; shift 2 ;;
        --content) CONTENT="$2"; shift 2 ;;
        --open) OPEN=true; shift ;;
        *) fail "Unknown argument for capture-create: $1" ;;
      esac
    done
    [[ -n "$NAME" ]] || fail "--name is required"
    [[ -n "$CONTENT" ]] || fail "--content is required"
    ARGS=("create" "name=${NAME}" "content=${CONTENT}")
    $OPEN && ARGS+=("open")
    run_obsidian "${ARGS[@]}"
    ;;

  capture-append|capture-prepend)
    PATH_ARG=""
    CONTENT=""
    INLINE=false
    ACTION="${COMMAND#capture-}"
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --path) PATH_ARG="$2"; shift 2 ;;
        --content) CONTENT="$2"; shift 2 ;;
        --inline) INLINE=true; shift ;;
        *) fail "Unknown argument for ${COMMAND}: $1" ;;
      esac
    done
    [[ -n "$PATH_ARG" ]] || fail "--path is required"
    [[ -n "$CONTENT" ]] || fail "--content is required"
    ARGS=("${ACTION}" "path=${PATH_ARG}" "content=${CONTENT}")
    $INLINE && ARGS+=("inline")
    run_obsidian "${ARGS[@]}"
    ;;

  capture-daily)
    CONTENT=""
    INLINE=false
    OPEN=false
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --content) CONTENT="$2"; shift 2 ;;
        --inline) INLINE=true; shift ;;
        --open) OPEN=true; shift ;;
        *) fail "Unknown argument for capture-daily: $1" ;;
      esac
    done
    [[ -n "$CONTENT" ]] || fail "--content is required"
    ARGS=("daily:append" "content=${CONTENT}")
    $INLINE && ARGS+=("inline")
    $OPEN && ARGS+=("open")
    run_obsidian "${ARGS[@]}"
    ;;

  property-set)
    PATH_ARG=""
    NAME=""
    VALUE=""
    TYPE="text"
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --path) PATH_ARG="$2"; shift 2 ;;
        --name) NAME="$2"; shift 2 ;;
        --value) VALUE="$2"; shift 2 ;;
        --type) TYPE="$2"; shift 2 ;;
        *) fail "Unknown argument for property-set: $1" ;;
      esac
    done
    [[ -n "$PATH_ARG" ]] || fail "--path is required"
    [[ -n "$NAME" ]] || fail "--name is required"
    [[ -n "$VALUE" ]] || fail "--value is required"
    run_obsidian "property:set" "path=${PATH_ARG}" "name=${NAME}" "value=${VALUE}" "type=${TYPE}"
    ;;

  research-search)
    QUERY=""
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --query) QUERY="$2"; shift 2 ;;
        *) fail "Unknown argument for research-search: $1" ;;
      esac
    done
    [[ -n "$QUERY" ]] || fail "--query is required"
    run_obsidian "search" "query=${QUERY}"
    ;;

  research-read)
    PATH_ARG=""
    FILE_ARG=""
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --path) PATH_ARG="$2"; shift 2 ;;
        --file) FILE_ARG="$2"; shift 2 ;;
        *) fail "Unknown argument for research-read: $1" ;;
      esac
    done
    if [[ -n "$PATH_ARG" && -n "$FILE_ARG" ]]; then
      fail "Use either --path or --file, not both"
    fi
    if [[ -n "$PATH_ARG" ]]; then
      run_obsidian "read" "path=${PATH_ARG}"
    elif [[ -n "$FILE_ARG" ]]; then
      run_obsidian "read" "file=${FILE_ARG}"
    else
      fail "--path or --file is required"
    fi
    ;;

  backlinks)
    PATH_ARG=""
    FILE_ARG=""
    FORMAT="json"
    COUNTS=false
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --path) PATH_ARG="$2"; shift 2 ;;
        --file) FILE_ARG="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --counts) COUNTS=true; shift ;;
        *) fail "Unknown argument for backlinks: $1" ;;
      esac
    done
    if [[ -n "$PATH_ARG" && -n "$FILE_ARG" ]]; then
      fail "Use either --path or --file, not both"
    fi
    ARGS=("backlinks" "format=${FORMAT}")
    if [[ -n "$PATH_ARG" ]]; then
      ARGS+=("path=${PATH_ARG}")
    elif [[ -n "$FILE_ARG" ]]; then
      ARGS+=("file=${FILE_ARG}")
    else
      fail "--path or --file is required"
    fi
    $COUNTS && ARGS+=("counts")
    run_obsidian "${ARGS[@]}"
    ;;

  links)
    PATH_ARG=""
    FILE_ARG=""
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --path) PATH_ARG="$2"; shift 2 ;;
        --file) FILE_ARG="$2"; shift 2 ;;
        *) fail "Unknown argument for links: $1" ;;
      esac
    done
    if [[ -n "$PATH_ARG" && -n "$FILE_ARG" ]]; then
      fail "Use either --path or --file, not both"
    fi
    if [[ -n "$PATH_ARG" ]]; then
      run_obsidian "links" "path=${PATH_ARG}"
    elif [[ -n "$FILE_ARG" ]]; then
      run_obsidian "links" "file=${FILE_ARG}"
    else
      fail "--path or --file is required"
    fi
    ;;

  orphans)
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      fail "Unknown argument for orphans: $1"
    done
    run_obsidian "orphans"
    ;;

  unresolved)
    FORMAT="json"
    VERBOSE=false
    while [[ $# -gt 0 ]]; do
      parse_common_arg "$@" && shift $? && continue
      case "$1" in
        --format) FORMAT="$2"; shift 2 ;;
        --verbose) VERBOSE=true; shift ;;
        *) fail "Unknown argument for unresolved: $1" ;;
      esac
    done
    ARGS=("unresolved" "format=${FORMAT}")
    $VERBOSE && ARGS+=("verbose")
    run_obsidian "${ARGS[@]}"
    ;;

  *)
    usage
    fail "Unknown command: ${COMMAND}"
    ;;
esac
