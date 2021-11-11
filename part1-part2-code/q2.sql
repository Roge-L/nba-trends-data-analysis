-- Helpfulness

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Recommender;
DROP TABLE IF EXISTS q2 CASCADE;

create table q2(
    CID INTEGER,
    firstName TEXT NOT NULL,
    helpfulness_category TEXT	
);

-- -- Do this for each of the views that define your intermediate steps.  
-- -- (But give them better names!) The IF EXISTS avoids generating an error 
-- -- the first time this file is imported.
DROP VIEW IF EXISTS Helpful CASCADE;
DROP VIEW IF EXISTS ObserverRatings CASCADE;
DROP VIEW IF EXISTS ReviewHelpfulness CASCADE;
DROP VIEW IF EXISTS NumHelpful CASCADE;
DROP VIEW IF EXISTS NumReviews CASCADE;
DROP VIEW IF EXISTS VeryHelpful CASCADE;
DROP VIEW IF EXISTS SomewhatHelpful CASCADE;
DROP VIEW IF EXISTS VeryAndSomewhatHelpful CASCADE;
DROP VIEW IF EXISTS NotHelpfulIds CASCADE;
DROP VIEW IF EXISTS NotHelpful CASCADE;
DROP VIEW IF EXISTS Question2Answer CASCADE;


-- -- Define views for your intermediate steps here:
CREATE VIEW Helpful AS
    SELECT reviewer, IID, count(reviewer) AS num_helpful
    FROM Helpfulness
    WHERE helpfulness = 't'
    GROUP BY reviewer, IID;

CREATE VIEW ObserverRatings AS
    SELECT reviewer, IID, count(reviewer) AS num_reviews
    FROM Helpfulness
    GROUP BY reviewer, IID;

CREATE VIEW ReviewHelpfulness AS
    SELECT Helpful.reviewer, Helpful.IID, num_helpful, num_reviews, CAST(num_helpful AS DECIMAL) / num_reviews AS helpfulness_score
    FROM Helpful JOIN ObserverRatings ON Helpful.reviewer = ObserverRatings.reviewer;

CREATE VIEW NumHelpful AS
    SELECT reviewer, count(reviewer) AS NumHelpful
    FROM ReviewHelpfulness
    WHERE helpfulness_score > 0.5
    GROUP BY reviewer;

CREATE VIEW NumReviews AS
    SELECT reviewer, count(reviewer) AS NumReviews
    FROM ReviewHelpfulness
    GROUP BY reviewer;

CREATE VIEW ReviewerScores AS
    SELECT NumHelpful.reviewer, CAST(NumHelpful AS DECIMAL) / CAST(NumReviews AS DECIMAL) AS helpfulness_score
    FROM NumHelpful JOIN NumReviews ON NumHelpful.reviewer = NumReviews.reviewer;

CREATE VIEW VeryHelpful AS
    SELECT *, 'Very Helpful' AS helpfulness_category
    FROM ReviewerScores
    WHERE helpfulness_score >= 0.8;

CREATE VIEW SomewhatHelpful AS
    SELECT *, 'Somewhat Helpful' AS helpfulness_category
    FROM ReviewerScores
    WHERE helpfulness_score < 0.8 AND helpfulness_score >= 0.5;

CREATE VIEW VeryAndSomewhatHelpful AS
    (SELECT * FROM VeryHelpful)
    UNION
    (SELECT * FROM SomewhatHelpful);

CREATE VIEW NotHelpfulIds AS
    (SELECT CID as reviewer FROM Customer)
    EXCEPT
    (SELECT reviewer FROM VeryAndSomewhatHelpful);

CREATE VIEW NotHelpful AS
    SELECT reviewer, 0 AS helpfulness_score, 'Not Helpful' as helpfulness_category
    FROM NotHelpfulIds;

CREATE VIEW Categorized AS
    (SELECT * FROM VeryHelpful)
    UNION
    (SELECT * FROM SomewhatHelpful)
    UNION
    (SELECT * FROM NotHelpful);

CREATE VIEW Question2Answer AS
    SELECT CID, firstName, helpfulness_category
    FROM Categorized JOIN Customer ON Categorized.reviewer = Customer.CID
    ORDER BY CID;

-- Your query that answers the question goes below the "insert into" line:
insert into q2 (SELECT * FROM Question2Answer);