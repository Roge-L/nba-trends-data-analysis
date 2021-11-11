-- Small sample dataset for Assignment 2.

-- Item(IID, category, description, price)
INSERT INTO Item VALUES 
(1, 'Book', 'Cloud Atlas', 20.21),
(2, 'Book', 'A Thousand Splendid Suns', 20.21),
(3, 'Book', 'Homegoing', 20.21);

-- Customer(CID, email, lastName, firstName, title)
INSERT INTO Customer VALUES
(1, 'g@g.com', 'Granger', 'Cousin', 'Ms'),
(2, 'p@p.com', 'Potter', 'Another', 'Mr'),
(3, 'w@w.com', 'Weasley', 'C.', 'Master');

-- Review(CID, IID, rating, comment)
INSERT INTO Review VALUES
(1, 1, 5, 'Fantastic read!'),
(2, 1, 5, 'Ron said it was fantastic and he was right!!!'),
(2, 2, 5, 'uhuh!!!'),
(2, 3, 5, 'fantastic and he was right!!!');

-- Helpfulness(reviewer, IID, observer, helpfulness)
INSERT INTO Helpfulness VALUES
(1, 1, 3, True),
(2, 1, 3, False),
(2, 2, 3, True),
(2, 3, 3, True);