CREATE DATABASE HumanResourcesManagementSystem;
USE HumanResourcesManagementSystem;

-- Employee Tbale
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INT,
    position_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    manager_id INT
);

-- Department Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

--Position Table
CREATE TABLE Positions (
    position_id INT PRIMARY KEY,
    position_name VARCHAR(50),
    base_salary DECIMAL(10, 2)
);

--Payroll table
CREATE TABLE Payroll (
    payroll_id INT PRIMARY KEY,
    employee_id INT,
    pay_date DATE,
    base_salary DECIMAL(10, 2),
    bonus DECIMAL(10, 2),
    deductions DECIMAL(10, 2),
    net_pay DECIMAL(10, 2),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

--Performance Tbale
CREATE TABLE Performance (
    performance_id INT PRIMARY KEY,
    employee_id INT,
    review_date DATE,
    performance_score DECIMAL(3, 1),
    comments VARCHAR(255),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

--Attendance Table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    employee_id INT,
    attendance_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


INSERT INTO Departments (department_id, department_name)
VALUES 
    (1, 'IT'),
    (2, 'Marketing'),
    (3, 'Human Resources');

SELECT *
FROM Departments


INSERT INTO Positions (position_id, position_name, base_salary)
VALUES 
    (1, 'Software Engineer', 50000),
    (2, 'Marketing Analyst', 40000),
    (3, 'IT Manager', 70000),
    (4, 'HR Specialist', 55000),
    (5, 'HR Manager', 60000);


SELECT *
FROM Positions


INSERT INTO Employees (employee_id, first_name, last_name, department_id, position_id, hire_date, salary, manager_id)
VALUES 
    (1, 'John', 'Doe', 1, 1, '2021-01-15', 50000, 3),
    (2, 'Alice', 'Smith', 2, 2, '2022-05-22', 40000, 3),
    (3, 'Robert', 'Brown', 1, 3, '2019-09-05', 70000, NULL),
    (4, 'Mary', 'Johnson', 3, 4, '2020-03-10', 55000, 5),
    (5, 'Michael', 'Davis', 3, 5, '2018-11-01', 60000, NULL);

SELECT *
FROM Employees


INSERT INTO Payroll (payroll_id, employee_id, pay_date, base_salary, bonus, deductions, net_pay)
VALUES 
    (1, 1, '2024-09-30', 50000, 2500, 500, 52000),
    (2, 2, '2024-09-30', 40000, 1500, 300, 41200),
    (3, 3, '2024-09-30', 70000, 3000, 700, 72300),
    (4, 4, '2024-09-30', 55000, 2000, 400, 56600),
    (5, 5, '2024-09-30', 60000, 2800, 600, 62200);


SELECT *
FROM Payroll


INSERT INTO Performance (performance_id, employee_id, review_date, performance_score, comments)
VALUES 
    (1, 1, '2024-01-01', 4.5, 'Excellent problem solver'),
    (2, 2, '2024-01-01', 4.0, 'Great team player'),
    (3, 3, '2024-01-01', 5.0, 'Outstanding leader'),
    (4, 4, '2024-01-01', 3.8, 'Reliable and consistent'),
    (5, 5, '2024-01-01', 4.2, 'Highly organized');


SELECT *
FROM Performance


INSERT INTO Attendance (attendance_id, employee_id, attendance_date, status)
VALUES 
    (1, 1, '2024-10-01', 'Present'),
    (2, 1, '2024-10-02', 'Absent'),
    (3, 2, '2024-10-01', 'Present'),
    (4, 2, '2024-10-02', 'Present'),
    (5, 3, '2024-10-01', 'Present'),
    (6, 3, '2024-10-02', 'Present'),
    (7, 4, '2024-10-01', 'Absent'),
    (8, 4, '2024-10-02', 'Present'),
    (9, 5, '2024-10-01', 'Present'),
    (10, 5, '2024-10-02', 'Present');

SELECT *
FROM Attendance


--Find the full name, department name, and position title of all employees.
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    Departments.department_name,
    Positions.position_name
FROM Employees
JOIN Departments ON Employees.department_id = Departments.department_id
JOIN Positions ON Employees.position_id = Positions.position_id;


-- List the employee name, manager's name, and department of all employees who have a manager.
SELECT 
    e1.first_name AS employee_name,
    e2.first_name AS manager_name,
    Departments.department_name
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
JOIN Departments ON e1.department_id = Departments.department_id;

--Find employees who received a performance score of 4.5 or higher in any review.
SELECT 
    Employees.first_name,
    Employees.last_name,
    Performance.performance_score,
    Performance.review_date
FROM Performance
JOIN Employees ON Performance.employee_id = Employees.employee_id
WHERE Performance.performance_score >= 4.5;


--Calculate the total payroll (sum of net pay) for the latest pay date.
SELECT 
    pay_date,
    SUM(net_pay) AS total_payroll
FROM Payroll
GROUP BY pay_date
ORDER BY pay_date DESC


--Count the total number of days each employee was marked "Present."
SELECT 
    e.first_name,
    e.last_name,
    COUNT(a.status) AS days_present
FROM Attendance AS a
JOIN Employees AS e ON a.employee_id = e.employee_id
WHERE a.status = 'Present'
GROUP BY e.employee_id, e.first_name, e.last_name;

--Get the attendance records for all employees between '2024-10-01' and '2024-10-05.'
SELECT 
    Employees.first_name,
    Employees.last_name,
    Attendance.attendance_date,
    Attendance.status
FROM Attendance
JOIN Employees ON Attendance.employee_id = Employees.employee_id
WHERE Attendance.attendance_date BETWEEN '2024-10-01' AND '2024-10-05';


--Find the employee with the highest overall performance score
SELECT 
    Employees.first_name,
    Employees.last_name,
    MAX(Performance.performance_score) AS highest_performance_score
FROM Performance
JOIN Employees ON Performance.employee_id = Employees.employee_id
GROUP BY Employees.first_name, Employees.last_name;

