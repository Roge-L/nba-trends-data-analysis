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
DROP VIEW IF EXISTS Question1Answer CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW NoReviews AS
    (SELECT Item.IID
    FROM Item JOIN LineItem ON Item.IID = LineItem.IID)
    EXCEPT
    (SELECT DISTINCT IID
    FROM Review);

CREATE VIEW Sales AS
    SELECT LineItem.PID, IID, quantity, Customer.CID, d, email, lastName, firstName
    FROM LineItem 
        JOIN Purchase ON LineItem.PID = Purchase.PID 
        JOIN Customer ON Customer.CID = Purchase.CID;

CREATE VIEW AtLeastThree AS
    SELECT s1.CID
    FROM Sales s1
        JOIN Sales s2 ON s1.CID = s2.CID
        JOIN Sales s3 ON s2.CID = s3.CID
    WHERE s1.IID < s2.IID 
        AND s2.IID < s3.IID 
        AND s1.IID IN (SELECT * FROM NoReviews)
        AND s2.IID IN (SELECT * FROM NoReviews)
        AND s3.IID IN (SELECT * FROM NoReviews);

CREATE VIEW Question1Answer AS
    SELECT Sales.CID, firstName, lastName, email
    FROM Sales JOIN AtLeastThree ON Sales.CID = AtLeastThree.CID;

-- Your query that answers the question goes below the "insert into" line:
insert into q1 (SELECT * FROM Question1Answer);