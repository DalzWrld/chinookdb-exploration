# Grouping Data with SQL

## What is grouping?

The **`GROUP BY`** clause collapses rows that share the same value(s) into a
single summary row, and **aggregate functions** compute a value for each group.
It runs **after** `WHERE` and **before** `HAVING`/`ORDER BY`/`LIMIT`.

```sql
SELECT <group_column>, <aggregate>(<column>)
FROM <table>
WHERE <row_filter>          -- filters raw rows BEFORE grouping
GROUP BY <group_column>
HAVING <group_filter>       -- filters groups AFTER grouping
ORDER BY <column> [ASC|DESC]
LIMIT <n>;
```

## Aggregate functions
- `COUNT(*)` — number of rows in the group.
- `SUM(col)` — total of a numeric column.
- `AVG(col)` — average value.
- `MIN(col)` / `MAX(col)` — smallest / largest value.

## WHERE vs HAVING
| Clause | Filters | Stage |
|--------|---------|-------|
| `WHERE` | individual rows | before grouping |
| `HAVING` | whole groups | after grouping (can use aggregates) |

You **cannot** use aggregates in `WHERE`; that is exactly what `HAVING` is for.

## Example queries (Chinook)

> Also saved in `grouping.sql`.

### 1. Count customers per country (with HAVING + ORDER + LIMIT)
```sql
SELECT Country,
       COUNT(*) AS CustomerCount
FROM customers
WHERE Country != 'USA'
GROUP BY Country
HAVING COUNT(*) > 2
ORDER BY CustomerCount DESC;
```
Counts customers per country (excluding the USA), keeps only countries with more
than 2 customers, sorted from most to least.

### 2. Total sales per country
```sql
SELECT BillingCountry,
       SUM(Total) AS Revenue,
       COUNT(*)   AS InvoiceCount
FROM invoices
GROUP BY BillingCountry
ORDER BY Revenue DESC;
```

### 3. Average track length per genre (multi-table via join shown later)
```sql
SELECT g.Name AS Genre,
       AVG(t.Milliseconds) AS AvgLengthMs,
       COUNT(*)            AS TrackCount
FROM tracks t
JOIN genres g ON g.GenreId = t.GenreId
GROUP BY g.GenreId
ORDER BY AvgLengthMs DESC;
```

### 4. HAVING with an aggregate
```sql
SELECT CustomerId, SUM(Total) AS Spent
FROM invoices
GROUP BY CustomerId
HAVING SUM(Total) > 40
ORDER BY Spent DESC;
```
Customers who spent more than $40 in total.

## Key takeaways
- `GROUP BY` summarizes many rows into one row per group value.
- Every non-aggregated column in `SELECT` must appear in `GROUP BY`.
- Filter rows with `WHERE`, filter groups with `HAVING`.
- Chain `GROUP BY → HAVING → ORDER BY → LIMIT` for ranked reports.

## References
- SQLite aggregate functions: https://www.sqlite.org/lang_aggfunc.html
- SQLite GROUP BY: https://www.sqlite.org/lang_select.html#resultset
- SQLTutorial GROUP BY guide: https://www.sqlitetutorial.net/sqlite-group-by/
