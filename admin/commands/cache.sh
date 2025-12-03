#!/usr/bin/env bash
set -euo pipefail

cache_artisan_handler() {
  parse_kv_args "$@"
  require_args "project-path action"
  local project_path="${PARSED_ARGS[project-path]}"
  local action="${PARSED_ARGS[action]}"
  local php_bin="${PARSED_ARGS[php]:-php}"

  info "Cache action (stub): action=${action}, project_path=${project_path}, php=${php_bin}"
  info "TODO: run artisan ${action}."
}

register_cmd "cache" "run" "Run artisan cache actions (config/route/view clear/cache)" "cache_artisan_handler" "project-path action" "php=php"
