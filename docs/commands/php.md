# php commands

Run with `sudo /root/simai-env/simai-admin.sh php <command> [options]` or via menu.

## list
List installed PHP versions (found under `/etc/php/*`) with a bordered table showing version, FPM status, and non-default pool count.

## reload
Reload/restart PHP-FPM for a specific version.

Options:
- `--php` (e.g., `8.1`, `8.2`, `8.3`); if omitted in menu, choose from installed versions.
