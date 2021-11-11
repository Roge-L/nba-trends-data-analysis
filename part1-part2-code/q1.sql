-- Unrated products.

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF exists q1 CASCADE;

CREATE TABLE q1(
    CID INTEGER,
    firstName TEXT NOT NULL,
	lastName TEXT NOT NULL,
    email TEXT	
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS NoReviews CASCADE;
DROP VIEW IF EXISTS Sales CASCADE;
DROP VIEW IF EXISTS AtLeastThree CASCADE;
DROP VIEW IF EXISTS EligibleItems CASCADE;
DROP VIEW IF EXISTS Answer CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW NoReviews AS
    SELECT IID
    FROM Item
    EXCEPT
    SELECT DISTINCT IID
    FROM Review;

CREATE VIEW Sales AS
    SELECT LineItem.PID, IID, quantity, Customer.CID, d, email, lastName, firstName
    FROM LineItem 
        JOIN Purchase ON LineItem.PID = Purchase.PID 
        JOIN Customer ON Customer.CID = Purchase.CID;

CREATE VIEW AtLeastThree AS
    SELECT s1.IID
    FROM Sales s1
        JOIN Sales s2 ON s1.PID = s2.PID
        JOIN Sales s3 ON s2.PID = s3.PID
    WHERE s1.IID < s2.IID AND s2.IID < s3.IID;

CREATE VIEW EligibleItems AS
    SELECT AtLeastThree.IID
    FROM NoReviews JOIN AtLeastThree ON NoReviews.IID = AtLeastThree.IID;

CREATE VIEW Question1Answer AS
    SELECT CID, firstName, lastName, email
    FROM Sales JOIN EligibleItems ON Sales.IID = EligibleItems.IID;

-- Your query that answers the question goes below the "insert into" line:
insert into q1 (SELECT * FROM Question1Answer);