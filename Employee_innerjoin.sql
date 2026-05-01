-- Step 1: Create Database
CREATE DATABASE company_db;

-- Step 2: Use the Database
USE company_db;

-- Step 3: Create Departments Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Step 4: Create Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Step 5: Insert Sample Departments (Indian context)
INSERT INTO departments (department_id, department_name)
VALUES
(1, 'Human Resources'),
(2, 'Finance'),
(3, 'Information Technology'),
(4, 'Marketing'),
(5, 'Operations');

-- Step 6: Insert Sample Employees (Indian names)
INSERT INTO employees (employee_id, employee_name, department_id)
VALUES
(101, 'Arjun', 1),
(102, 'Priya', 2),
(103, 'Ravi', 3),
(104, 'Meera', 4),
(105, 'Kiran', 2),
(106, 'Ananya', 3),
(107, 'Suresh', 5),
(108, 'Lakshmi', 1),
(109, 'Vikram', 3),
(110, 'Sneha', 4),
(111, 'Manoj', 2),
(112, 'Divya', 5),
(113, 'Rahul', 1),
(114, 'Neha', 3),
(115, 'Santosh', 4),
(116, 'Pooja', 2),
(117, 'Ajay', 5),
(118, 'Shreya', 1);

-- Step 7: INNER JOIN Query to Combine Employees and Departments
SELECT 
    e.employee_name, 
    d.department_name
FROM 
    employees e
INNER JOIN 
    departments d
ON 
    e.department_id = d.department_id;
