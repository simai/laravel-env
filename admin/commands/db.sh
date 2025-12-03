#!/usr/bin/env bash
set -euo pipefail

db_create_handler() {
  parse_kv_args "$@"
  require_args "name user pass"

  local name="${PARSED_ARGS[name]}"
  local user="${PARSED_ARGS[user]}"
  local pass="${PARSED_ARGS[pass]}"

  info "DB create (stub): db=${name}, user=${user}"
  info "TODO: create database/user and grant privileges."
}

db_drop_handler() {
  parse_kv_args "$@"
  require_args "name"

  local name="${PARSED_ARGS[name]}"
  local drop_user="${PARSED_ARGS[drop-user]:-0}"
  local user="${PARSED_ARGS[user]:-}"

  info "DB drop (stub): db=${name}, drop_user=${drop_user}, user=${user}"
  info "TODO: drop database and optionally the user."
}

db_pass_handler() {
  parse_kv_args "$@"
  require_args "user pass"

  local user="${PARSED_ARGS[user]}"
  local pass="${PARSED_ARGS[pass]}"

  info "DB user password change (stub): user=${user}"
  info "TODO: update password for DB user."
}

register_cmd "db" "create" "Create database and user" "db_create_handler" "name user pass" ""
register_cmd "db" "drop" "Drop database" "db_drop_handler" "name" "drop-user=0 user="
register_cmd "db" "set-pass" "Change DB user password" "db_pass_handler" "user pass" ""
