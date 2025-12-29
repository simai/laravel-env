#!/usr/bin/env bash
set -euo pipefail

json_escape() {
  local s="$1"
  s=${s//\\/\\\\}
  s=${s//\"/\\\"}
  echo "$s"
}

backup_export_handler() {
  parse_kv_args "$@"
  local ts output include_nginx domains_filter dry_run
  ts=$(date +%Y%m%d%H%M%S)
  output="${PARSED_ARGS[output]:-/root/simai-backup-${ts}.tar.gz}"
  include_nginx="${PARSED_ARGS[include-nginx]:-no}"
  domains_filter="${PARSED_ARGS[domains]:-}"
  dry_run="${PARSED_ARGS[dry-run]:-no}"

  local out_dir
  out_dir=$(dirname "$output")
  if [[ ! -d "$out_dir" || ! -w "$out_dir" ]]; then
    error "Output directory is not writable: ${out_dir}"
    return 1
  fi
  [[ "${include_nginx,,}" != "yes" ]] && include_nginx="no"
  [[ "${dry_run,,}" != "yes" ]] && dry_run="no"

  local filter_map=()
  IFS=',' read -r -a filter_map <<<"${domains_filter}"

  local domains=()
  mapfile -t domains < <(list_sites)
  local selected=() skipped=()
  for d in "${domains[@]}"; do
    if [[ -n "$domains_filter" ]]; then
      local matched=0
      for f in "${filter_map[@]}"; do
        [[ "$d" == "$f" ]] && matched=1
      done
      [[ $matched -eq 0 ]] && continue
    fi
    if ! has_simai_metadata "$d"; then
      warn "Skipping ${d}: missing simai metadata in nginx config"
      skipped+=("$d")
      continue
    fi
    selected+=("$d")
  done

  if [[ ${#selected[@]} -eq 0 ]]; then
    error "No sites matched for export"
    return 1
  fi

  local simai_version host_os host_name
  simai_version=$(cat "${SCRIPT_DIR}/VERSION" 2>/dev/null || echo "unknown")
  if command -v lsb_release >/dev/null 2>&1; then
    host_os=$(lsb_release -ds 2>/dev/null || echo "unknown")
  else
    host_os=$( (source /etc/os-release && echo "${PRETTY_NAME:-unknown}") 2>/dev/null || echo "unknown")
  fi
  host_name=$(hostname 2>/dev/null || echo "unknown")

  local tmpdir
  tmpdir=$(mktemp -d)
  mkdir -p "$tmpdir"
  local sites_json=()
  local summary_file="${tmpdir}/summary.txt"
  local manifest_file="${tmpdir}/manifest.json"

  local summary_sep="+------------------------------+----------+------+------------------------------------------+-----------+"
  {
    printf "%s\n" "$summary_sep"
    printf "| %-28s | %-8s | %-4s | %-40s | %-9s |\n" "Domain" "Profile" "PHP" "Root/Target" "SSL"
    printf "%s\n" "$summary_sep"
  } >"$summary_file"

  for d in "${selected[@]}"; do
    read_site_metadata "$d"
    local profile="${SITE_META[profile]:-generic}"
    local project="${SITE_META[project]}"
    local root="${SITE_META[root]}"
    local php="${SITE_META[php]}"
    local socket_project="${SITE_META[php_socket_project]:-$project}"
    local target="${SITE_META[target]:-}"
    local ssl_state ssl_type
    read ssl_state ssl_type < <(site_ssl_info "$d")
    local type_display="$ssl_type"
    [[ "$ssl_state" == "false" ]] && type_display="off"

    local entry
    entry=$(cat <<EOF
    {
      "domain": "$(json_escape "$d")",
      "profile": "$(json_escape "$profile")",
      "project": "$(json_escape "$project")",
      "root": "$(json_escape "$root")",
      "php": "$(json_escape "$php")",
      "php_socket_project": "$(json_escape "$socket_project")",
      "target": "$(json_escape "$target")",
      "ssl": {
        "enabled": $ssl_state,
        "type": "$(json_escape "$ssl_type")"
      }
    }
EOF
)
    sites_json+=("$entry")

    local summary_target="$root"
    [[ "$profile" == "alias" && -n "$target" ]] && summary_target="alias -> ${target}"
    printf "| %-28s | %-8s | %-4s | %-40s | %-9s |\n" "$d" "$profile" "$php" "$summary_target" "$type_display" >>"$summary_file"

    if [[ "$include_nginx" == "yes" ]]; then
      local dst_dir="${tmpdir}/nginx/sites-available"
      mkdir -p "$dst_dir"
      cp "/etc/nginx/sites-available/${d}.conf" "$dst_dir/" 2>/dev/null || warn "Failed to copy nginx config for ${d}"
    fi
  done
  printf "%s\n" "$summary_sep" >>"$summary_file"

  cat >"$manifest_file" <<EOF
{
  "schema_version": 1,
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "simai_env_version": "$(json_escape "$simai_version")",
  "host": {
    "os": "$(json_escape "$host_os")",
    "hostname": "$(json_escape "$host_name")",
    "notes": "config-only export; no secrets"
  },
  "sites": [
$(for i in "${!sites_json[@]}"; do
  echo "${sites_json[$i]}"
  if [[ $i -lt $((${#sites_json[@]}-1)) ]]; then
    echo "    ,"
  fi
done)
  ]
}
EOF

  if [[ "$dry_run" == "yes" ]]; then
    echo "Dry-run: would export ${#selected[@]} site(s) to ${output}"
    echo "Include nginx: ${include_nginx}"
    echo "Manifest preview: ${manifest_file}"
    rm -rf "$tmpdir"
    return 0
  fi

  (cd "$tmpdir" && tar -czf "$output" .)
  chmod 600 "$output" 2>/dev/null || true
  rm -rf "$tmpdir"

  echo "Backup export created: ${output}"
  echo "Sites exported: ${#selected[@]}"
  echo "This is config-only; no DB/files/certs included."
  return 0
}

register_cmd "backup" "export" "Export config-only migration bundle" "backup_export_handler" "" "output= include-nginx= domains= dry-run="
