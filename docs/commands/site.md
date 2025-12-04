# site commands

Run with `sudo /root/simai-env/simai-admin.sh site <command> [options]` or via menu.

## add
Create nginx vhost and PHP-FPM pool for an existing project path.

Options:
- `--domain` (required)
- `--project-name` (optional; derived from domain if missing)
- `--path` (optional; default `/home/simai/www/<project>`)
- `--profile` (`laravel`|`generic`, default `laravel`)
- `--php` (optional; choose from installed if omitted)
- DB (optional): `--create-db=yes|no`, `--db-name`, `--db-user`, `--db-pass` (defaults from project; password generated)

Behavior:
- Laravel profile requires `artisan`; generic uses placeholder and `public` root.
- Creates PHP-FPM pool and nginx vhost; installs `public/healthcheck.php`.
- If `create-db=yes`, creates DB/user, writes `.env` for generic profile, prints summary with credentials (not logged).

## remove
Remove site resources.

Prompts (when not provided): select domain, yes/no for removing files, dropping DB/user.

Options:
- `--domain`
- `--project-name`
- `--path`
- `--remove-files` (`yes|no`)
- `--drop-db` (`yes|no`, default DB name from project)
- `--drop-db-user` (`yes|no`, default user from project)
- `--db-name`, `--db-user`

Removes nginx config and PHP-FPM pools. Files/DB/user are removed only when confirmed/flagged.

## list
List domains from nginx sites-available.

## set-php
Stub: choose site and target PHP version; handler to be implemented (update pool/nginx).
