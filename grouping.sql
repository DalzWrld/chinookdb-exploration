-- ONE SINGLE QUERY demonstrating WHERE, GROUP BY, HAVING, ORDER BY, LIMIT
SELECT Country, 
COUNT(*) AS CustomerCount
FROM customers
WHERE Country != 'USA'           
GROUP BY Country                  
HAVING COUNT(*) > 2               
ORDER BY CustomerCount DESC       
