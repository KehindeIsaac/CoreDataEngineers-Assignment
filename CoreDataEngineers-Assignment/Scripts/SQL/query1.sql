-- Find order IDs where gloss_qty or poster_qty > 4000
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;


