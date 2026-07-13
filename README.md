# chinookdb-exploration

A learning repository for exploring the **Chinook** sample database with SQLite.
It contains short concept notes and runnable SQL examples covering the core of
SQL querying.

## Database

`chinook.db` is the SQLite sample database (artists, albums, customers,
employees, invoices, tracks, playlists, genres, media types). It was obtained
from the SQLiteTutorial sample database page:
https://www.sqlitetutorial.net/sqlite-sample-database/

The relationship map:

- `artists` 1—N `albums` 1—N `tracks` N—1 `genres` / `media_types`
- `tracks` N—N `playlists` via the junction table `playlist_track`
- `customers` 1—N `invoices` 1—N `invoice_items` N—1 `tracks`
- `employees` 1—N `customers` (support rep) and a self hierarchy via `ReportsTo`

## Contents

| File | Topic |
|------|-------|
| `filtering.md` / `filtering.sql` | Filtering rows with `WHERE` |
| `ordering.md` / `ordering.sql` | Sorting with `ORDER BY` |
| `limiting.md` / `limiting.sql` | Restricting rows with `LIMIT`/`OFFSET` |
| `grouping.md` / `grouping.sql` | Aggregating with `GROUP BY`/`HAVING` |
| `database-keys.md` | Types of database keys + keys found in Chinook |
| `sql-joins.md` / `joins.sql` | JOIN types and demonstrations |

## How to run the SQL

```bash
sqlite3 chinook.db < filtering.sql
sqlite3 chinook.db < ordering.sql
sqlite3 chinook.db < limiting.sql
sqlite3 chinook.db < grouping.sql
sqlite3 chinook.db < joins.sql
# or read them interactively:
sqlite3 chinook.db
sqlite> .read joins.sql
```
