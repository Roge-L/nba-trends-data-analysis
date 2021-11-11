-- Helpfulness

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q2 CASCADE;

create table q2(
    CID INTEGER,
    firstName TEXT NOT NULL,
    helpfulness_category TEXT	
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS Helpful CASCADE;
DROP VIEW IF EXISTS TotalReviews CASCADE;
DROP VIEW IF EXISTS Scores CASCADE;
DROP VIEW IF EXISTS VeryHelpful CASCADE;
DROP VIEW IF EXISTS SomewhatHelpful CASCADE;
DROP VIEW IF EXISTS NotHelpful CASCADE;
DROP VIEW IF EXISTS Question2Answer CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW Helpful AS
    SELECT reviewer, count(reviewer) AS num_helpful
    FROM Helpfulness
    WHERE helpfulness = 't'
    GROUP BY reviewer;

CREATE VIEW TotalReviews AS
    SELECT reviewer, count(reviewer) AS num_reviews
    FROM Helpfulness
    GROUP BY reviewer;

CREATE VIEW Scores AS
    SELECT Helpful.reviewer, num_helpful, num_reviews, CAST(num_helpful AS DECIMAL) / num_reviews AS helpfulness_score
    FROM Helpful JOIN TotalReviews ON Helpful.reviewer = TotalReviews.reviewer;

CREATE VIEW VeryHelpful AS
    SELECT *, 'Very Helpful' AS helpfulness_category
    FROM Scores
    WHERE helpfulness_score >= 0.8;

CREATE VIEW SomewhatHelpful AS
    SELECT *, 'Somewhat Helpful' AS helpfulness_category
    FROM Scores
    WHERE helpfulness_score < 0.8 AND helpfulness_score >= 0.5;

CREATE VIEW NotHelpful AS
    SELECT *, 'Not Helpful' AS helpfulness_category
    FROM Scores
    WHERE helpfulness_score < 0.5;

CREATE VIEW Categorized AS
    (SELECT * FROM VeryHelpful)
    UNION
    (SELECT * FROM SomewhatHelpful)
    UNION
    (SELECT * FROM NotHelpful);

CREATE VIEW Question2Answer AS
    SELECT CID, firstName, helpfulness_category
    FROM Categorized JOIN Customer ON Categorized.reviewer = Customer.CID;

-- Your query that answers the question goes below the "insert into" line:
insert into q2 (SELECT * FROM Question2Answer);