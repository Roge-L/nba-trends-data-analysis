-- Hyperconsumers

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
    year TEXT NOT NULL,
    name TEXT NOT NULL,
    email TEXT,
    items INTEGER NOT NULL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS CustomerPurchases CASCADE;
DROP VIEW IF EXISTS TopFive CASCADE;
DROP VIEW IF EXISTS Question5Answer CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW CustomerPurchases AS
    SELECT EXTRACT(YEAR FROM Purchase.d) as Year, Customer.CID, SUM(quantity) AS TotalUnitsPurchased, DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM Purchase.d) ORDER BY SUM(quantity) DESC) AS DenseRank
    FROM Customer
        JOIN Purchase ON Customer.CID = Purchase.CID
        JOIN LineItem ON Purchase.PID = LineItem.PID
    -- WHERE DenseRank >= 5
    GROUP BY Customer.CID, Purchase.d;

CREATE VIEW TopFive AS
    SELECT *
    FROM CustomerPurchases
    WHERE DenseRank <= 5;

CREATE VIEW Question5Answer AS
    SELECT year, Customer.firstname AS name, email, TotalUnitsPurchased AS items
    FROM TopFive JOIN Customer ON TopFive.CID = Customer.CID;

-- Your query that answers the question goes below the "insert into" line:
insert into q5 (SELECT * FROM Question5Answer);