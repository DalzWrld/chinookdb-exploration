SELECT 
customers.CustomerId,
customers.FirstName,
invoices.InvoiceId,
tracks.Name AS TrackTitle,
invoice_items.InvoiceId,
invoice_items.TrackId,
invoice_items.InvoiceDate
FROM customers
JOIN invoices
ON customers.CustomerId = invoices.CustomerId
JOIN invoice_items
ON invoices.InvoiceId = invoice_items.InvoiceId
JOIN tracks
WHERE customer.CustomerId = 1
LIMIT 20;