-- Curators

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
    CID INT NOT NULL,
    categoryName TEXT NOT NULL,
    PRIMARY KEY(CID, categoryName)
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS Categories CASCADE;
DROP VIEW IF EXISTS GoodCustomersDetailed CASCADE;
DROP VIEW IF EXISTS GoodCustomers CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW Categories AS
    SELECT DISTINCT category
    FROM Item;
    
CREATE VIEW GoodCustomersDetailed AS
    SELECT Customer.CID, Purchase.PID, Item.IID, d, Review.rating, category, comment
    FROM Customer
        JOIN Purchase ON Customer.CID = Purchase.CID
        JOIN Review ON Customer.CID = Review.CID
        JOIN Item ON Review.IID = Item.IID
    WHERE comment IS NOT NULL;

CREATE VIEW GoodCustomers AS
    SELECT DISTINCT CID
    FROM GoodCustomersDetailed;


    
-- Your query that answers the question goes below the "insert into" line:
-- insert into q3