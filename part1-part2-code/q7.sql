-- Fraud Prevention

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS Last24Hours CASCADE;
DROP VIEW IF EXISTS FishyPurchases CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW Last24Hours AS
    SELECT *, DENSE_RANK() OVER (PARTITION BY CID ORDER BY d) AS purchaseOrder
    FROM Purchase
    WHERE d >= NOW() - '1 day'::INTERVAL;

CREATE VIEW FishyPurchases AS
    (SELECT * FROM Last24Hours)
    EXCEPT
    (SELECT * FROM Last24Hours WHERE purchaseOrder <= 5);

-- Your SQL code that performs the necessary deletions goes here:

DELETE FROM Purchase 
WHERE PID IN (SELECT PID FROM FishyPurchases);