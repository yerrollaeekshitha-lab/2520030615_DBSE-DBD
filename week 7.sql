-- TOPIC: JOINS AND SET OPERATIONS
-- PART 1: CROSS JOIN

CREATE TABLE class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE class_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO class VALUES
(1,'abhi'),
(2,'adam'),
(4,'alex');

INSERT INTO class_info VALUES
(1,'DELHI'),
(2,'MUMBAI'),
(3,'CHENNAI');

SELECT *
FROM class
CROSS JOIN class_info;

SELECT *
FROM class
INNER JOIN class_info
ON class.id = class_info.id;

SELECT class.name,
       class_info.address
FROM class
INNER JOIN class_info
ON class.id=class_info.id;

-- Natuaral join
SELECT *
FROM class
NATURAL JOIN class_info;

-- LEFT OUTER JOIN

INSERT INTO class VALUES
(5,'ashish');

INSERT INTO class_info VALUES
(7,'NOIDA'),
(8,'PANIPAT');

SELECT *
FROM class
LEFT OUTER JOIN class_info
ON class.id=class_info.id;

SELECT *
FROM class
LEFT JOIN class_info
ON class.id=class_info.id
WHERE class_info.id IS NULL;

SELECT *
FROM class
RIGHT OUTER JOIN class_info
ON class.id=class_info.id;

SELECT *
FROM class
RIGHT JOIN class_info
ON class.id=class_info.id
WHERE class.id IS NULL;


SELECT *
FROM class
FULL OUTER JOIN class_info
ON class.id=class_info.id;
-- is valid SQL in databases that support FULL OUTER JOIN, 
-- but MySQL does not support FULL OUTER JOIN directly.
-- this command (below)
SELECT *
FROM class
LEFT JOIN class_info
ON class.id = class_info.id

UNION

SELECT *
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id;


-- Full outer join
SELECT *
FROM class
FULL OUTER JOIN class_info
ON class.id=class_info.id
WHERE class.id IS NULL
OR class_info.id IS NULL;

-- ❌ Why do you get an error?
-- The problem is this part:
-- FULL OUTER JOIN
-- MySQL does not support FULL OUTER JOIN directly.
-- The WHERE condition itself is correct:
-- WHERE class.id IS NULL
  -- OR class_info.id IS NULL;
-- It means:
-- Show only the unmatched records from either table.
-- Your notes use exactly this FULL OUTER JOIN + WHERE 
-- idea to find unmatched records.
-- ✅ MySQL equivalent
-- Use:

SELECT *
FROM class
LEFT JOIN class_info
ON class.id = class_info.id
WHERE class_info.id IS NULL

UNION

SELECT *
FROM class
RIGHT JOIN class_info
ON class.id = class_info.id
WHERE class.id IS NULL;

-- union
CREATE TABLE first_table(
id INT,
name VARCHAR(30)
);

CREATE TABLE second_table(
id INT,
name VARCHAR(30)
);

INSERT INTO first_table VALUES
(1,'abhi'),
(2,'adam');

INSERT INTO second_table VALUES
(2,'adam'),
(3,'chester');

-- UNION
SELECT * FROM first_table
UNION
SELECT * FROM second_table;

-- UNION ALL

SELECT * FROM first_table
UNION ALL
SELECT * FROM second_table;

SELECT COUNT(*)
FROM
(
SELECT * FROM first_table
UNION ALL
SELECT * FROM second_table
) A;

-- INTERSECT
SELECT * FROM first_table
INTERSECT
SELECT * FROM second_table;


SELECT name FROM first_table
INTERSECT
SELECT name FROM second_table;

-- MINUS
SELECT * FROM first_table
MINUS
SELECT * FROM second_table;

-- ❌ The problem is MINUS[above]
-- Your screenshot shows Error Code: 1064, and the error 
-- occurs at MINUS.
-- Your notes use MINUS as the set operation for:
-- Find students present only in the first branch.
-- However, MySQL does not support MINUS directly.

-- So this:
-- SELECT * FROM first_table
-- MINUS
-- SELECT * FROM second_table;

-- ❌ will not work in MySQL.
-- ✅ MySQL equivalent of MINUS

-- Use NOT EXISTS:

SELECT *
FROM first_table f
WHERE NOT EXISTS (
    SELECT 1
    FROM second_table s
    WHERE s.id = f.id
      AND s.name = f.name
);

-- MINUS
SELECT name FROM first_table
MINUS
SELECT name FROM second_table;

-- In MySQL, write:

SELECT name
FROM first_table
WHERE name NOT IN (
    SELECT name
    FROM second_table
);

-- adv
SELECT c.id,c.name,ci.address
FROM class c
INNER JOIN class_info ci
ON c.id=ci.id;


--

SELECT c.id,
       c.name,
       CASE
           WHEN ci.address IS NULL
           THEN 'Address Missing'
           ELSE 'Address Available'
       END AS Status
FROM class c
LEFT JOIN class_info ci
ON c.id=ci.id;






