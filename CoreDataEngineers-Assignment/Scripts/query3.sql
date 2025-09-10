--Question 3 
--Find all the company names that start with a 'C' or 'W', and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. 

-- Company names starting with C/W, primary contact has 'ana' or 'Ana', not 'eana'
SELECT name, primary_poc
FROM accounts
WHERE (name LIKE 'A%' OR name LIKE 'C%')
  AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
  AND primary_poc NOT LIKE '%eana%';
