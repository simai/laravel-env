#!/usr/bin/env bash
set -euo pipefail

logs_tail_handler() {
  parse_kv_args "$@"
  require_args "file"
  local file="${PARSED_ARGS[file]}"
  local lines="${PARSED_ARGS[lines]:-50}"

  info "Logs tail (stub): file=${file}, lines=${lines}"
  info "TODO: stream logs from target file."
}

health_check_handler() {
  parse_kv_args "$@"
  require_args "url"
  local url="${PARSED_ARGS[url]}"
  info "Health check (stub): url=${url}"
  info "TODO: perform curl check and report status."
}

register_cmd "logs" "tail" "Tail log file" "logs_tail_handler" "file" "lines=50"
register_cmd "logs" "health-check" "HTTP health check" "health_check_handler" "url" ""
