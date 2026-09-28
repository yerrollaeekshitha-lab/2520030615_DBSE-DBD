-- BANK DATABASE – ACID PROPERTIES & ISOLATION

CREATE DATABASE Bank_ACID_DB;
USE Bank_ACID_DB;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    City VARCHAR(50)
);

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12,2),
    Branch VARCHAR(50),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customer(Customer_ID)
);

CREATE TABLE Bank_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Account_No)
    REFERENCES Account(Account_No)
);



INSERT INTO Customer
(Customer_ID, Customer_Name, Phone, City)
VALUES
(101, 'Ravi Kumar', '9876543210', 'Hyderabad'),

(102, 'Priya Sharma', '9876543211', 'Vijayawada'),

(103, 'Arjun Reddy', '9876543212', 'Bangalore'),

(104, 'Sneha Rao', '9876543213', 'Chennai'),

(105, 'Kiran Kumar', '9876543214', 'Hyderabad');



INSERT INTO Account
(Account_No, Customer_ID, Account_Type, Balance, Branch)
VALUES
(10001, 101, 'Savings', 50000, 'Hyderabad'),

(10002, 102, 'Savings', 75000, 'Vijayawada'),

(10003, 103, 'Current', 120000, 'Bangalore'),

(10004, 104, 'Savings', 45000, 'Chennai'),

(10005, 105, 'Current', 90000, 'Hyderabad');


INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 10000),

(10002, 'DEPOSIT', 15000),

(10003, 'WITHDRAW', 20000),

(10004, 'DEPOSIT', 5000),

(10005, 'WITHDRAW', 10000);

SELECT * FROM Customer;
SELECT * FROM Account;


SELECT * FROM Bank_Transaction;

-- Part A - Transactions

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


SELECT *
FROM Account
WHERE Account_No = 10001;


COMMIT;


SELECT *
FROM Account
WHERE Account_No = 10001;

-- Part B - ROLLBACK

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

SELECT *
FROM Account
WHERE Account_No = 10001;

ROLLBACK;


SELECT *
FROM Account
WHERE Account_No = 10001;

-- Part C - SAVEPOINT

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;


SAVEPOINT Deposit1;

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;

SAVEPOINT Withdrawal1;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10003;


ROLLBACK TO SAVEPOINT Withdrawal1;

COMMIT;


SELECT *
FROM Account;

-- PartD - BANK TRANSFER

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;


UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;


SELECT *
FROM Account
WHERE Account_No IN (10001,10002);

COMMIT;

SELECT
    Account_No,
    Balance
FROM Account
WHERE Account_No IN (10001,10002);

-- Part E - Transfer using RollBack

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 20000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10002;

ROLLBACK;


SELECT *
FROM Account
WHERE Account_No IN (10001,10002);

-- Part F - ACID

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

ROLLBACK;

-- 40. CONSISTENCY

-- Check balances before transfer
SELECT Account_No, Balance
FROM Account
WHERE Account_No IN (10001, 10002);

-- Transfer Rs. 10000
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

-- Check balances after transfer
SELECT Account_No, Balance
FROM Account
WHERE Account_No IN (10001, 10002);

-- Transaction T1
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 5000
WHERE Account_No = 10001;

-- Transaction T2 can read according to the isolation level
SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;

-- Part G - Transaction Isolation Levels 

-- 43. CHECK CURRENT ISOLATION LEVEL

SELECT @@SESSION.transaction_isolation;

-- OR

SELECT @@GLOBAL.transaction_isolation;

-- 44. READ UNCOMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


-- 45. READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL
READ COMMITTED;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL
REPEATABLE READ;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


SET SESSION TRANSACTION ISOLATION LEVEL
SERIALIZABLE;

START TRANSACTION;

SELECT *
FROM Account
WHERE Account_No = 10001;

COMMIT;


START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;


START TRANSACTION;

UPDATE Account
SET Balance = Balance - 5000
WHERE Account_No = 10001;

COMMIT;


START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

ROLLBACK;


START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

SAVEPOINT AfterDebit;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

-- Q1
START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;

-- Q2
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;

COMMIT;

-- Q3
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

ROLLBACK;

-- Q4
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 15000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 15000
WHERE Account_No = 10002;

COMMIT;

-- Q5
START TRANSACTION;

UPDATE Account
SET Balance = Balance - 20000
WHERE Account_No = 10001;

SAVEPOINT AfterDebit;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10003;

COMMIT;


-- Q6
START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

SAVEPOINT Update1;

UPDATE Account
SET Balance = Balance - 3000
WHERE Account_No = 10002;

SAVEPOINT Update2;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10003;

ROLLBACK TO SAVEPOINT Update2;

COMMIT;

-- Q7

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

-- If an error occurs before COMMIT:
-- ROLLBACK;

-- Q8
-- Check total before transfer
SELECT SUM(Balance) AS Total_Before
FROM Account;

START TRANSACTION;

UPDATE Account
SET Balance = Balance - 10000
WHERE Account_No = 10001;

UPDATE Account
SET Balance = Balance + 10000
WHERE Account_No = 10002;

COMMIT;

-- Check total after transfer
SELECT SUM(Balance) AS Total_After
FROM Account;

-- Q9
START TRANSACTION;

UPDATE Account
SET Balance = Balance + 5000
WHERE Account_No = 10001;

COMMIT;

-- Check the committed data
SELECT *
FROM Account
WHERE Account_No = 10001;

-- Q10
-- S1
SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;

UPDATE Account
SET Balance = Balance + 20000
WHERE Account_No = 10001;

-- Do not COMMIT yet

-- S2
SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE Account_No = 10001;


-- S1
ROLLBACK;

-- S2
SELECT Balance
FROM Account
WHERE Account_No = 10001;

COMMIT;






