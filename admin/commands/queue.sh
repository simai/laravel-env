#!/usr/bin/env bash
set -euo pipefail

queue_restart_handler() {
  parse_kv_args "$@"
  require_args "project-name"

  local project="${PARSED_ARGS[project-name]}"
  local user="${PARSED_ARGS[user]:-simai}"

  info "Queue restart (stub): project=${project}, user=${user}"
  info "TODO: restart queue worker systemd unit."
}

queue_status_handler() {
  parse_kv_args "$@"
  require_args "project-name"

  local project="${PARSED_ARGS[project-name]}"
  info "Queue status (stub): project=${project}"
  info "TODO: show systemd status for queue worker."
}

register_cmd "queue" "restart" "Restart queue worker" "queue_restart_handler" "project-name" "user=simai"
register_cmd "queue" "status" "Show queue worker status" "queue_status_handler" "project-name" ""
