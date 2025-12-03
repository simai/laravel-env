#!/usr/bin/env bash
set -euo pipefail

cron_add_handler() {
  parse_kv_args "$@"
  require_args "project-path php"

  local project_path="${PARSED_ARGS[project-path]}"
  local php_bin="${PARSED_ARGS[php]}"
  local user="${PARSED_ARGS[user]:-simai}"

  info "Cron add (stub): project_path=${project_path}, php=${php_bin}, user=${user}"
  info "TODO: add cron entry for artisan schedule:run."
}

cron_remove_handler() {
  parse_kv_args "$@"
  require_args "project-path"

  local project_path="${PARSED_ARGS[project-path]}"
  local user="${PARSED_ARGS[user]:-simai}"

  info "Cron remove (stub): project_path=${project_path}, user=${user}"
  info "TODO: remove cron entry for artisan schedule:run."
}

register_cmd "cron" "add" "Add schedule:run cron entry" "cron_add_handler" "project-path php" "user=simai"
register_cmd "cron" "remove" "Remove schedule:run cron entry" "cron_remove_handler" "project-path" "user=simai"
