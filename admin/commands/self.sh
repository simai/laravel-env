#!/usr/bin/env bash
set -euo pipefail

self_update_handler() {
  local updater="${SCRIPT_DIR}/update.sh"
  if [[ ! -x "$updater" ]]; then
    error "Updater not found or not executable at ${updater}"
    exit 1
  fi
  info "Running updater ${updater}"
  "$updater"
}

register_cmd "self" "update" "Update simai-env/admin scripts" "self_update_handler" "" ""
