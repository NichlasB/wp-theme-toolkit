# LocalWP Database Access Workflow

Use this workflow when an AI chat needs direct database access for a LocalWP site on Windows.

The goal is to avoid the common failure mode where a fresh chat tries `wp-load.php` or a generic PHP CLI first, then hits a missing MySQL extension or mismatched PHP runtime.

## Core Rule

- Do not start database work with `wp-load.php`, WordPress bootstrap, or generic PHP MySQL access.
- Resolve the LocalWP site metadata first.
- Use LocalWP's bundled `mysql.exe` client directly for initial inspection, reconciliation, and cleanup.
- Treat the LocalWP database as distinct from production unless the user explicitly says otherwise.

For a full GridPane-to-LocalWP content refresh, use `d4-prompts/ds5-deploy/LOCALWP_REVERSE_REFRESH_PROMPT.md`. This file remains the LocalWP SQL access reference that workflow should follow for local backup, import, and validation steps.

## Why This Exists

On Windows, the default CLI PHP runtime in a fresh AI chat is often not the same PHP runtime LocalWP uses for the site, or it does not have MySQL access enabled.

Direct SQL through LocalWP's bundled MySQL client avoids that entire class of problems.

## Required Inputs

Resolve these values before running SQL:

- LocalWP site name
- LocalWP domain
- database host
- database port
- database name
- database user
- database password
- path to LocalWP `mysql.exe`

## Resolve LocalWP Site Metadata First

Read this file first when the current LocalWP site details are not already known:

```text
C:\Users\Captain\AppData\Roaming\Local\sites.json
```

Use it to identify:

- the Local site record
- the site ID
- the site domain
- the MySQL port
- the web root if needed for related checks

## Canonical Access Pattern

Use `MYSQL_PWD` and LocalWP's bundled MySQL client.

```powershell
$env:MYSQL_PWD = 'root'
& 'C:\Users\Captain\AppData\Roaming\Local\lightning-services\mysql-8.0.35+4\bin\win64\bin\mysql.exe' `
  -h 127.0.0.1 `
  -P 10022 `
  -u root `
  -D local `
  --table `
  -e "SELECT COUNT(*) AS total_posts FROM wp_posts;"
```

Notes:

- prefer `127.0.0.1` over `localhost`
- set the password via `MYSQL_PWD` instead of embedding it in every command
- use `--table` for readable output during guided reconciliation
- use `-N -B -r` only when machine-readable output is needed

## Current DrMorses.TV LocalWP Example

If the current project is the Local replacement site for DrMorses.TV, the working values are:

- host: `127.0.0.1`
- port: `10022`
- database: `local`
- user: `root`
- password: `root` via `MYSQL_PWD`
- MySQL client:
  `C:\Users\Captain\AppData\Roaming\Local\lightning-services\mysql-8.0.35+4\bin\win64\bin\mysql.exe`

Do not assume these values for other LocalWP sites. Re-check `sites.json` when the target site is different.

## Safe Workflow

1. Confirm the target is the LocalWP site, not production.
2. Read `sites.json` if the LocalWP metadata is not already known.
3. Connect with LocalWP's bundled `mysql.exe`.
4. Run non-destructive baseline queries first.
5. If destructive SQL is needed, preview the scope with `SELECT` counts before deleting or updating.
6. Re-run reconciliation queries immediately after the change.

## Baseline Query Pattern

Before destructive changes, prefer checks like:

```sql
SELECT COUNT(*) AS total_videos
FROM wp_posts
WHERE post_type = 'video'
  AND post_status NOT IN ('trash', 'auto-draft');
```

```sql
SELECT COUNT(*) AS duplicate_slug_groups
FROM (
  SELECT post_name
  FROM wp_posts
  WHERE post_type = 'video'
    AND post_status NOT IN ('trash', 'auto-draft')
  GROUP BY post_name
  HAVING COUNT(*) > 1
) dup;
```

## When PHP Is Acceptable

PHP can still be useful for:

- transforming serialized option blobs
- quick text processing
- WordPress-adjacent helper logic that does not require DB access

But do not use PHP as the first path for connecting to MySQL in a fresh LocalWP chat.

## Paste-Ready Prompt For New Chats

Use this at the top of a fresh chat:

```text
For database work on this project, do not use wp-load.php or generic PHP to access MySQL first.
Use the LocalWP MySQL client directly.

Before running SQL:
- confirm we are working against the LocalWP site, not production
- if needed, read C:\Users\Captain\AppData\Roaming\Local\sites.json to resolve the site metadata and DB port

Use this access pattern:
- Host: 127.0.0.1
- Port: [resolve from LocalWP metadata]
- Database: local
- User: root
- Password: root via MYSQL_PWD env var
- MySQL client: C:\Users\Captain\AppData\Roaming\Local\lightning-services\mysql-8.0.35+4\bin\win64\bin\mysql.exe

Rules:
- prefer direct SQL via mysql.exe for inspection, reconciliation, and cleanup
- do not start with wp-load.php for DB access
- run baseline SELECT counts before destructive changes
- run post-change reconciliation queries immediately after any delete or update
```

## Recommended Terminology

When reporting results, say one of these explicitly:

- `LocalWP site`
- `LocalWP database`
- `Local replacement site`

Avoid saying `live site` unless you explicitly mean production.
