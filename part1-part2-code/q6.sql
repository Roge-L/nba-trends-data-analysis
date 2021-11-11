--Year-over-year sales

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q6 CASCADE;

CREATE TABLE q6 (
    IID INT NOT NULL,
    Year1 INT NOT NULL,
    Year1Average FLOAT NOT NULL,
    Year2 INT NOT NULL,
    Year2Average FLOAT NOT NULL,
    YearOverYearChange FLOAT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS YearlySummary CASCADE;
DROP VIEW IF EXISTS YearOverYear CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW YearlySummary AS
    SELECT IID, EXTRACT(YEAR FROM d) AS Year, SUM(quantity) AS UnitsSold, CAST(SUM(quantity) AS DECIMAL) / 12.0 AS AvgMonthlySales
    FROM LineItem JOIN Purchase ON LineItem.PID = Purchase.PID
    GROUP BY EXTRACT(YEAR FROM d), IID;

CREATE VIEW YearOverYear AS
    SELECT ys1.IID,
        ys1.year AS year1, 
        ys1.AvgMonthlySales AS Year1Average, 
        ys2.year AS year2, ys2.AvgMonthlySales AS Year2Average, 
        (CAST(ys2.UnitsSold AS DECIMAL) - CAST(ys1.UnitsSold AS DECIMAL)) / CAST(ys1.UnitsSold AS DECIMAL) AS YearOverYear
    FROM YearlySummary ys1, YearlySummary ys2
    WHERE ys2.year = ys1.year + 1;

-- Your query that answers the question goes below the "insert into" line:
insert into q6 (SELECT * FROM YearOverYear);