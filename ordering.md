# Ordering Data with SQL

## What is ordering?

The **`ORDER BY`** clause sorts the result set by one or more columns. It runs
**after** filtering and grouping, so it sorts the final output. Without it, SQL
makes no guarantee about row order.

```sql
SELECT <columns>
FROM <table>
ORDER BY <column1> [ASC|DESC], <column2> [ASC|DESC];
```

- `ASC` (default) — ascending, smallest → largest / A → Z.
- `DESC` — descending, largest → smallest / Z → A.

## Rules & notes
- You can sort by a column that is **not** in the `SELECT` list.
- Multiple columns are sorted left-to-right (tie-breakers).
- `NULL`s sort first in ascending order in SQLite.
- `ORDER BY` is typically paired with `LIMIT` to get "top N" results.

## Example queries (Chinook)

> Also saved in `ordering.sql`.

### 1. Single column ascending
```sql
SELECT FirstName, LastName, Country
FROM Customers
WHERE Country = 'USA'
ORDER BY LastName ASC;
```

### 2. Single column descending
```sql
SELECT FirstName, LastName, Country
FROM Customers
WHERE Country = 'USA'
ORDER BY FirstName DESC;
```

### 3. Multiple columns (tie-breaker)
```sql
SELECT Country, LastName, FirstName
FROM customers
ORDER BY Country ASC, LastName ASC;
```
Sorts by country first, then by last name within each country.

### 4. Numeric descending + LIMIT ("top N")
```sql
SELECT Name, Milliseconds
FROM tracks
ORDER BY Milliseconds DESC
LIMIT 10;
```
The 10 longest tracks in the catalog.

### 5. Ordering by an aggregate (needs GROUP BY)
```sql
SELECT BillingCountry, SUM(Total) AS Revenue
FROM invoices
GROUP BY BillingCountry
ORDER BY Revenue DESC;
```
Countries ranked by total sales.

## Key takeaways
- `ORDER BY` sorts the **final** result (after WHERE/GROUP BY).
- Default direction is `ASC`; specify `DESC` explicitly when needed.
- Combine multiple columns for stable, meaningful sorting.
- Pair with `LIMIT` for leaderboards / top-N reports.

## References
- SQLite ORDER BY: https://www.sqlite.org/lang_select.html#orderby
- SQLTutorial ordering guide: https://www.sqlitetutorial.net/sqlite-order-by/
