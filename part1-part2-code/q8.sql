-- SALE!SALE!SALE!

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS HotItems CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW HotItems AS
    SELECT IID, SUM(quantity)
    FROM LineItem
    GROUP BY IID HAVING SUM(quantity) >= 10;

-- Your SQL code that performs the necessary updates goes here:

UPDATE Item
SET price = price - (price * .2)
WHERE price >= 10 AND price <= 50;

UPDATE Item
SET price = price - (price * .3)
WHERE price > 50 AND price < 100;

UPDATE Item
SET price = price - (price * .5)
WHERE price >= 100;