# Admin CLI Overview

`simai-admin.sh` provides maintenance commands with two modes:
- Direct CLI: `sudo /root/simai-env/simai-admin.sh <section> <command> [options]`
- Interactive menu: `sudo /root/simai-env/simai-admin.sh menu` (numeric choices, stays in section; self-update reloads menu)

Supported OS: Ubuntu 20.04/22.04/24.04. Run as root.

## Profiles
- `laravel`: nginx root `<project>/public`, requires `artisan`.
- `generic`: nginx root `<project>/public`, creates placeholder page and healthcheck; can create `.env` for DB.

## Common behaviors
- Domain -> project slug auto-derived if not provided.
- PHP version selection from installed `/etc/php/*` when not passed.
- Healthcheck copied to `public/healthcheck.php`.
- Site removal cleans nginx and PHP-FPM pools; optional files/DB/user removal via prompts.
- Logs: `/var/log/simai-admin.log`.

Commands detail: see `docs/commands/*`.
