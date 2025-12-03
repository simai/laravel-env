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
  if [[ "${SIMAI_ADMIN_MENU:-0}" == "1" ]]; then
    info "Reloading admin menu after update"
    exec "${SCRIPT_DIR}/simai-admin.sh" menu
  fi
}

register_cmd "self" "update" "Update simai-env/admin scripts" "self_update_handler" "" ""
