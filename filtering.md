# Filtering Data with SQL

## What is filtering?

Filtering restricts the rows returned by a query using a **`WHERE`** clause. The
database only returns rows for which the condition evaluates to *true*. Filtering
happens **before** grouping/aggregation, so it trims the raw data first.

```sql
SELECT <columns>
FROM <table>
WHERE <condition>;
```

The `WHERE` clause supports a rich set of operators.

## Common operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` `!=` `<>` | equal / not equal | `Country = 'Germany'` |
| `>` `<` `>=` `<=` | comparison | `Total > 5` |
| `BETWEEN a AND b` | range (inclusive) | `Milliseconds BETWEEN 100000 AND 200000` |
| `IN (...)` | match any value in a set | `Country IN ('USA','Canada','Brazil')` |
| `LIKE` | pattern match (`%` = any, `_` = one char) | `Name LIKE 'A%'` |
| `IS NULL` / `IS NOT NULL` | test for missing values | `Company IS NOT NULL` |
| `AND` `OR` `NOT` | logical combinators | `Country='USA' AND State='CA'` |

**Operator precedence:** `NOT` > `AND` > `OR`. Use parentheses to make intent clear.

## Example queries (Chinook)

> These are also saved in `filtering.sql`.

### 1. Equality filter
```sql
SELECT FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';
```
Returns only customers located in Germany.

### 2. Combine conditions with AND / OR
```sql
SELECT InvoiceId, CustomerId, Total
FROM invoices
WHERE BillingCountry = 'USA'
  AND Total > 10;
```
Customers in the USA with invoices over $10.

### 3. Pattern matching with LIKE
```sql
SELECT ArtistId, Name
FROM artists
WHERE Name LIKE 'A%';   -- names starting with 'A'
```

### 4. Membership with IN
```sql
SELECT InvoiceId, BillingCountry, Total
FROM invoices
WHERE BillingCountry IN ('USA','Canada','Brazil');
```

### 5. Range with BETWEEN
```sql
SELECT TrackId, Name, Milliseconds
FROM tracks
WHERE Milliseconds BETWEEN 200000 AND 300000;
```

### 6. NULL handling
```sql
SELECT CustomerId, FirstName, Company
FROM customers
WHERE Company IS NOT NULL;
```
(Note: `= NULL` does **not** work; always use `IS NULL` / `IS NOT NULL`.)

## Key takeaways
- `WHERE` filters **rows**.
- It runs before `GROUP BY` and aggregate functions.
- Use `IN`, `BETWEEN`, and `LIKE` to avoid long `OR`/`AND` chains.
- `NULL` is special: test it with `IS NULL`, never with `=`.

## References
- SQLite WHERE / expressions: https://www.sqlite.org/lang_expr.html
- SQLite SELECT: https://www.sqlite.org/lang_select.html
- SQLTutorial filter guide: https://www.sqlitetutorial.net/sqlite-where/
