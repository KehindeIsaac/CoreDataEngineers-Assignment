-- Company names starting with C/W, primary contact has 'ana' or 'Ana', not 'eana'
SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
  AND (primary_poc ILIKE '%ana%')
  AND (primary_poc NOT ILIKE '%eana%');
