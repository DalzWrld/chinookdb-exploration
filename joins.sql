------------------------------------------------------------
-- sql-joins.sql
-- Demonstrations of the most common SQL JOIN types on Chinook
------------------------------------------------------------

-- ============================================================
-- 1. INNER JOIN
-- Returns only rows with a matching key in BOTH tables.
-- Show each album with its artist name.
-- ============================================================
SELECT al.AlbumId, al.Title, ar.Name AS Artist
FROM albums al
INNER JOIN artists ar ON ar.ArtistId = al.ArtistId
ORDER BY ar.Name, al.Title
LIMIT 10;


-- ============================================================
-- 2. LEFT (OUTER) JOIN
-- Returns ALL rows from the left table, plus matches from the
-- right table. Non-matching right columns are NULL.
-- Every customer and their support rep (reps always exist here,
-- but LEFT JOIN is safe if some SupportRepId were NULL).
-- ============================================================
SELECT c.CustomerId, c.FirstName || ' ' || c.LastName AS Customer,
       e.FirstName || ' ' || e.LastName AS SupportRep
FROM customers c
LEFT JOIN employees e ON e.EmployeeId = c.SupportRepId
ORDER BY c.CustomerId
LIMIT 10;


-- ============================================================
-- 3. Multi-table JOIN
-- Link invoice line items -> invoices -> customers to show who
-- bought which tracks and how much they paid.
-- ============================================================
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


-- ============================================================
-- 4. SELF JOIN
-- Join a table to itself. employees.ReportsTo points to another
-- employee (the manager).
-- ============================================================
SELECT emp.EmployeeId,
       emp.FirstName || ' ' || emp.LastName AS Employee,
       mgr.FirstName  || ' ' || mgr.LastName AS Manager
FROM employees emp
LEFT JOIN employees mgr ON mgr.EmployeeId = emp.ReportsTo
ORDER BY mgr.EmployeeId;


-- ============================================================
-- 5. RIGHT JOIN note (SQLite does NOT support RIGHT JOIN)
-- Emulate a RIGHT JOIN by swapping tables and using LEFT JOIN.
-- "All artists, and their albums if any" (same as LEFT JOIN
-- artists->albums, or INNER since every album has an artist).
-- ============================================================
SELECT ar.Name AS Artist, al.Title AS Album
FROM artists ar
LEFT JOIN albums al ON al.ArtistId = ar.ArtistId
ORDER BY ar.Name
LIMIT 10;


-- ============================================================
-- 6. CROSS JOIN (cartesian product) -- use sparingly / with LIMIT
-- Every genre paired with every media type.
-- ============================================================
SELECT g.Name AS Genre, m.Name AS MediaType
FROM genres g
CROSS JOIN media_types m
LIMIT 10;
