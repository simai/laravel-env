# backup commands

Run with `sudo /root/simai-env/simai-admin.sh backup <command> [options]` or via menu under **Backup / Migrate**.

## export
Create a config-only bundle for migration (no databases, project files, or certificates).

Options:
- `--output <path>` (default `/root/simai-backup-<timestamp>.tar.gz`)
- `--include-nginx yes|no` (default `no`; copies nginx vhost configs as reference)
- `--domains <d1,d2>` (optional filter; defaults to all sites with simai metadata)
- `--dry-run yes|no` (default `no`; show what would be exported without writing the archive)

Contents:
- `manifest.json` (schema_version=1) with host info and site metadata (domain, profile, root, php, ssl type/state) derived from simai nginx metadata.
- `summary.txt` table.
- Optional copies of `/etc/nginx/sites-available/<domain>.conf` when `--include-nginx yes`.

Security:
- No DB credentials, `.env`, project files, certificates, or private keys are included.
- SSL presence/type is noted via metadata/paths only.

Example:
`simai-admin.sh backup export --include-nginx yes`

Next steps:
- Transfer the archive to the target server after installing simai-env. (Import is planned for a future release.)
