-- Customer Apreciation Week

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS YesterdayCustomers CASCADE;
DROP VIEW IF EXISTS YesterdayOrders CASCADE;
DROP VIEW IF EXISTS YesterdayFirstOrders CASCADE;
DROP VIEW IF EXISTS FreeItem CASCADE;
DROP VIEW IF EXISTS FreeItems CASCADE;
-- Define views for your intermediate steps here:


-- Your SQL code that performs the necessary insertions goes here:
CREATE VIEW FreeItem AS
    SELECT MAX(IID) AS IID, 'Housewares' AS category, 'Company logo mug' AS description, 0 AS price
    FROM Item;

CREATE VIEW YesterdayCustomers AS
    SELECT Customer.CID
    FROM Customer JOIN Purchase ON Customer.CID = Purchase.CID
    WHERE d >= TIMESTAMP 'yesterday' and d < TIMESTAMP 'today';

CREATE VIEW YesterdayOrders AS
    SELECT Purchase.PID, CID, d, DENSE_RANK() OVER (PARTITION BY CID ORDER BY d) AS ordering, LineItem.IID
    FROM Purchase JOIN LineItem ON Purchase.PID = LineItem.PID
    WHERE d >= TIMESTAMP 'yesterday' AND d < TIMESTAMP 'today';

CREATE VIEW YesterdayFirstOrders AS
    SELECT *
    FROM YesterdayOrders
    WHERE ordering = 1;

CREATE VIEW FreeItems AS
    SELECT PID, FreeItem.IID, 1 AS quantity
    FROM FreeItem, YesterdayFirstOrders;

INSERT INTO Item VALUES ((
    SELECT MAX(IID) + 1 AS MAX
    FROM Item
), 'Housewares', 'Company logo mug', 0);

INSERT INTO LineItem (SELECT * FROM FreeItems);