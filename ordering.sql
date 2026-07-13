
-- Order by LastName ascending
SELECT FirstName, LastName, Country 
FROM Customers 
WHERE Country = 'USA'
ORDER BY LastName ASC;


-- Order by FirstName descending
SELECT FirstName, LastName, Country 
FROM Customers 
WHERE Country = 'USA'
ORDER BY FirstName DESC;