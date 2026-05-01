-- Droping DB if exists
DROP DATABASE IF EXISTS ELearning;
-- Creating DB ELearning 
CREATE DATABASE ELearning;
USE ELearning;
-- Learners table
CREATE TABLE learners (
    learner_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- Courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Purchases table
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    learner_id INT NOT NULL,
    course_id INT NOT NULL,
    quantity INT NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- inserting learners accross countries
INSERT INTO learners (full_name, country) VALUES
('Alice Johnson', 'USA'),
('Ravi Kumar', 'India'),
('Maria Gonzalez', 'Spain'),
('Chen Wei', 'China'),
('James Smith', 'UK');


-- Iinserting courses
INSERT INTO courses (course_name, category, unit_price) VALUES
('Python for Beginners', 'Programming', 50.00),
('Advanced Excel Analytics', 'Data Analysis', 40.00),
('Digital Marketing Basics', 'Marketing', 30.00),
('Machine Learning Essentials', 'Programming', 80.00),
('Project Management Fundamentals', 'Business', 60.00);
 
 -- Inserting into Purchases
 INSERT INTO purchases (learner_id, course_id, quantity, purchase_date) VALUES
(1, 1, 1, '2026-03-01'),  -- Alice buys Python
(2, 2, 2, '2026-03-05'),  -- Ravi buys Excel (2 licenses)
(3, 3, 1, '2026-03-07'),  -- Maria buys Marketing
(4, 4, 1, '2026-03-10'),  -- Chen buys ML
(5, 5, 1, '2026-03-12'),  -- James buys Project Mgmt
(1, 4, 1, '2026-03-15'),  -- Alice also buys ML
(2, 1, 1, '2026-03-18'),  -- Ravi buys Python
(3, 2, 1, '2026-03-20');  -- Maria buys Excel

-- Total Revenue 
SELECT FORMAT(SUM(c.unit_price * p.quantity), 2) AS total_revenue
FROM purchases p
JOIN courses c ON p.course_id = c.course_id;

-- Learner’s Total Spending (sorted highest first)
SELECT 
    l.full_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- country wise revenue
SELECT l.country, FORMAT(SUM(c.unit_price * p.quantity), 2) AS revenue
FROM purchases p
JOIN learners l ON p.learner_id = l.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.country
ORDER BY revenue DESC;

-- Learners Spend
SELECT l.full_name, 
       FORMAT(SUM(c.unit_price * p.quantity), 2) AS total_spent,
       FORMAT(AVG(c.unit_price * p.quantity), 2) AS avg_spent_per_purchase
FROM purchases p
JOIN learners l ON p.learner_id = l.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name
ORDER BY total_spent DESC;

-- INNER JOIN (only learners who made purchases)
SELECT 
    l.full_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(c.unit_price * p.quantity, 2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
ORDER BY l.full_name, p.purchase_date;

-- Left Join (all learners, even if no purchases) 
SELECT 
    l.full_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(c.unit_price * p.quantity, 2) AS total_amount,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
ORDER BY l.full_name, p.purchase_date;

-- RIGHT JOIN (all courses, even if not purchased)
SELECT 
    l.full_name,
    l.country,
    c.course_name,
    c.category,
    p.quantity,
    FORMAT(c.unit_price * p.quantity, 2) AS total_amount,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c ON p.course_id = c.course_id
RIGHT JOIN learners l ON p.learner_id = l.learner_id
ORDER BY c.course_name, p.purchase_date;

-- Each learners total spending with country
SELECT 
    l.full_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spending
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
ORDER BY total_spending DESC;

-- Top 3 most purchased courses (by quantity sold) sql
SELECT 
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM purchases p
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Each course category’s total revenue and unique learners
SELECT 
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM purchases p
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- Learners who purchased from more than one category
SELECT 
    l.full_name,
    l.country,
    COUNT(DISTINCT c.category) AS categories_purchased
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
HAVING COUNT(DISTINCT c.category) > 1
ORDER BY categories_purchased DESC;

-- Courses that have not been purchased at all
SELECT 
    c.course_name,
    c.category,
    FORMAT(c.unit_price, 2) AS price
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.course_id IS NULL;


