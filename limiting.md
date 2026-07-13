# Limiting Results with SQL

## What is LIMIT?

The **`LIMIT`** clause restricts the number of rows returned by a query. It is
especially useful for previews, pagination, and "top N" reports when combined
with `ORDER BY`. In SQLite the syntax is:

```sql
SELECT <columns>
FROM <table>
[ORDER BY ...]
LIMIT <count> [OFFSET <start>];
```

- `LIMIT n` → return at most `n` rows.
- `LIMIT n OFFSET m` → skip the first `m` rows, then return `n`.
  - Shorthand: `LIMIT m, n` (offset first, then count) — but the `OFFSET` form is clearer.

> Note: SQL Server uses `TOP`, and some dialects use `FETCH FIRST n ROWS ONLY`.
> `LIMIT` is the SQLite / MySQL / PostgreSQL standard.

## Why it matters
- **Pagination:** show 20 results per page (`LIMIT 20 OFFSET 40` = page 3).
- **Top-N:** sort then take the first N rows.
- **Performance:** returning fewer rows is faster and lighter on the client.

## Example queries (Chinook)

> Also saved in `limiting.sql`.

### 1. Basic LIMIT
```sql
SELECT FirstName, LastName, Country
FROM Customers
WHERE Country = 'USA'
LIMIT 5;
```
Returns at most 5 USA customers.

### 2. Pagination with OFFSET
```sql
SELECT CustomerId, FirstName, LastName
FROM customers
ORDER BY CustomerId
LIMIT 10 OFFSET 20;   -- rows 21-30
```

### 3. Top-N with ORDER BY
```sql
SELECT Name, UnitPrice
FROM tracks
ORDER BY UnitPrice DESC
LIMIT 5;
```
The 5 most expensive tracks.

### 4. LIMIT applied after grouping
```sql
SELECT BillingCountry, SUM(Total) AS Revenue
FROM invoices
GROUP BY BillingCountry
ORDER BY Revenue DESC
LIMIT 3;
```
The top 3 revenue-generating countries.

## Key takeaways
- `LIMIT` caps the number of returned rows.
- Always pair `LIMIT` with `ORDER BY` when you want the "top/bottom N".
- Use `OFFSET` for pagination; remember OFFSET counts skipped rows.

## References
- SQLite LIMIT/OFFSET: https://www.sqlite.org/lang_select.html#limitoffset
- SQLTutorial LIMIT guide: https://www.sqlitetutorial.net/sqlite-limit/
