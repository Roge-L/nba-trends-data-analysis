-- SALE!SALE!SALE!

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS HotItems CASCADE;
DROP VIEW IF EXISTS DiscountsApplied CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW HotItems AS
    SELECT IID, SUM(quantity)
    FROM LineItem
    GROUP BY IID HAVING SUM(quantity) >= 10;

CREATE VIEW DiscountsApplied AS
    SELECT Item.IID, price,
    CASE
        WHEN price >= 10 AND price <= 50 THEN price - (price * .2)
        WHEN price > 50 AND price < 100 THEN price - (price * .3)
        WHEN price >= 100 THEN price - (price * .5)
    END AS DiscountedPrice
    FROM HotItems JOIN Item ON HotItems.IID = Item.IID;
-- Your SQL code that performs the necessary updates goes here:

UPDATE Item
SET price = DiscountsApplied.DiscountedPrice
FROM DiscountsApplied
WHERE Item.IID = DiscountsApplied.IID;