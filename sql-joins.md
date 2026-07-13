# SQL JOINs

## What is a JOIN?

A **JOIN** combines rows from two or more tables based on a related column
(usually a foreign key referencing a primary key). Joins are how relational
databases avoid data duplication: facts live in one table and are *linked* to
others instead of being copied.

The Chinook schema is a perfect playground: `albums` links to `artists`,
`invoices` links to `customers`, and `invoice_items` links back to both
`invoices` and `tracks`.

## Types of JOINs

### 1. INNER JOIN
Returns only rows that have a **matching** key in **both** tables. Unmatched
rows are dropped. This is the most common join.

```sql
SELECT al.AlbumId, al.Title, ar.Name AS Artist
FROM albums al
INNER JOIN artists ar ON ar.ArtistId = al.ArtistId
ORDER BY ar.Name, al.Title
LIMIT 10;
```
Every album is paired with its artist. (In Chinook every album has an artist, so
this looks identical to a LEFT JOIN here.)

### 2. LEFT (OUTER) JOIN
Returns **all** rows from the *left* table, plus matching rows from the right
table. Where there is no match, the right-table columns are filled with `NULL`.
Use it when you must keep every row of the left table regardless of a match.

```sql
SELECT c.CustomerId,
       c.FirstName || ' ' || c.LastName AS Customer,
       e.FirstName || ' ' || e.LastName AS SupportRep
FROM customers c
LEFT JOIN employees e ON e.EmployeeId = c.SupportRepId
ORDER BY c.CustomerId
LIMIT 10;
```
Keeps every customer even if `SupportRepId` were `NULL`.

### 3. RIGHT (OUTER) JOIN
The mirror of LEFT JOIN: keeps **all** rows of the *right* table.

> **SQLite does not support `RIGHT JOIN` or `FULL OUTER JOIN`.** You emulate a
> RIGHT JOIN simply by swapping the table order and using `LEFT JOIN`. For
> example, "all artists and their albums" is written as a `LEFT JOIN` from
> `artists` to `albums`.

```sql
SELECT ar.Name AS Artist, al.Title AS Album
FROM artists ar
LEFT JOIN albums al ON al.ArtistId = ar.ArtistId
ORDER BY ar.Name
LIMIT 10;
```

### 4. FULL OUTER JOIN
Returns matched rows **plus** unmatched rows from *both* sides (left and right
NULL-filled). Not supported by SQLite; it is emulated with a `UNION` of a
`LEFT JOIN` and a `RIGHT JOIN` (or a `LEFT JOIN` plus an anti-join).

### 5. CROSS JOIN
Returns the **cartesian product**: every row of table A combined with every row
of table B (`rowsA × rowsB`). There is no `ON` condition. Use it deliberately
(e.g. generating combinations) and almost always with a `LIMIT` or a later
filter.

```sql
SELECT g.Name AS Genre, m.Name AS MediaType
FROM genres g
CROSS JOIN media_types m
LIMIT 10;
```
Chinook has 25 genres × 5 media types = **125** combinations.

### 6. SELF JOIN
Joining a table to **itself** by giving it two aliases. Used for hierarchical or
same-entity relationships.

```sql
SELECT emp.EmployeeId,
       emp.FirstName || ' ' || emp.LastName AS Employee,
       mgr.FirstName  || ' ' || mgr.LastName AS Manager
FROM employees emp
LEFT JOIN employees mgr ON mgr.EmployeeId = emp.ReportsTo
ORDER BY mgr.EmployeeId;
```
`employees.ReportsTo` is a self-referencing foreign key. Sample output:

| Employee | Manager |
|----------|---------|
| Andrew Adams | (none – top of hierarchy) |
| Nancy Edwards | Andrew Adams |
| Michael Mitchell | Andrew Adams |
| Jane Peacock | Nancy Edwards |
| Margaret Park | Nancy Edwards |
| Steve Johnson | Nancy Edwards |
| Robert King | Michael Mitchell |
| Laura Callahan | Michael Mitchell |

## Multi-table JOIN
Joins chain naturally. Link `invoice_items → invoices → customers`:

```sql
SELECT c.CustomerId,
       c.FirstName || ' ' || c.LastName AS Customer,
       i.InvoiceId,
       ii.TrackId,
       ii.UnitPrice,
       ii.Quantity
FROM invoice_items ii
INNER JOIN invoices i  ON i.InvoiceId  = ii.InvoiceId
INNER JOIN customers c ON c.CustomerId = i.CustomerId
ORDER BY i.InvoiceId
LIMIT 10;
```

## Visual summary of JOIN results
```
        INNER JOIN        LEFT JOIN            FULL OUTER
   +--------+--------+  +--------+--------+  +--------+--------+
   |   A●   |   ●B   |  |   A●   |   ●B   |  |   A●   |   ●B   |
   |  match |  match |  |  match |  match |  |  match |  match |
   |        |        |  |   A●   |  NULL  |  |   A●   |  NULL  |
   |        |        |  |        |        |  |  NULL  |   ●B   |
   +--------+--------+  +--------+--------+  +--------+--------+
   only matches      all A rows        all A + all B rows
```

## Key takeaways
- `INNER JOIN` keeps only matches; `LEFT JOIN` keeps all left rows.
- SQLite supports `INNER`, `LEFT`, `CROSS`, and `SELF` joins natively.
- `RIGHT` and `FULL OUTER` are **not** in SQLite — emulate with `LEFT JOIN` swaps / `UNION`.
- Always join on the foreign-key → primary-key relationship.
- Chain multiple `JOIN`s to walk across the relationship graph.

## References
- SQLite JOIN syntax: https://www.sqlite.org/lang_select.html#fromclause
- SQLite SELECT / FROM clause: https://www.sqlite.org/lang_select.html
- SQLTutorial JOIN guide: https://www.sqlitetutorial.net/sqlite-join/
- Visual JOIN explanation (Coding Horror): https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/
