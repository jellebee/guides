-- === Creating Tables ===

-- Employees Table: Stores employee details including address and department affiliation.
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY, -- Automatically generates a unique employee ID.
    FirstName VARCHAR(50) NOT NULL, -- Holds the first name of the employee.
    LastName VARCHAR(50) NOT NULL, -- Holds the last name of the employee.
    DepartmentID INT, -- Links to the department the employee is assigned to.
    HireDate DATE, -- Employment start date.
    Address VARCHAR(255), -- Full street address of the employee.
    City VARCHAR(100), -- City where the employee lives.
    PostalCode VARCHAR(20), -- Postal code of employee's residence.
    Country VARCHAR(50) -- Country of residence for the employee.
);

-- Departments Table: Contains information regarding available departments.
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY, -- Automatically generates a unique department ID.
    DepartmentName VARCHAR(50) NOT NULL, -- Name of the department.
    Location VARCHAR(100), -- Physical location of the department office.
    Country VARCHAR(50) -- Country where the department office is located.
);

-- Projects Table: Table for managing project names and their respective budgets.
CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY, -- Automatically generates a unique project ID.
    ProjectName VARCHAR(100) NOT NULL, -- Name of the project.
    Budget DECIMAL(12, 2) -- Financial budget allocated to the project.
);

-- EmployeeProjects Table: Maps employees to projects they are working on.
CREATE TABLE EmployeeProjects (
    EmployeeID INT, -- Links to an employee record.
    ProjectID INT, -- Links to a project record.
    Role VARCHAR(50), -- Specifies the employee's role within the project.
    PRIMARY KEY (EmployeeID, ProjectID), -- Uniquely identifies an employee-project pair.
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID), -- Ensures valid foreign keys with Employees.
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) -- Ensures valid foreign keys with Projects.
);

-- === Inserting Data into Tables ===
-- Insert various departments alongside their locations and countries into Departments.
INSERT INTO Departments (DepartmentName, Location, Country) VALUES 
  ('HR', 'Building A', 'Netherlands'), 
  ('IT', 'Building B', 'Germany'), 
  ('Finance', 'Building C', 'France');

-- Populate Employees with full records, including address information and department links.
INSERT INTO Employees (FirstName, LastName, DepartmentID, HireDate, Address, City, PostalCode, Country) VALUES 
  ('John', 'Doe', 1, '2020-01-15', '1234 Elm St', 'Amsterdam', '1000AA', 'Netherlands'), 
  ('Jane', 'Smith', 2, '2019-03-21', '5678 Oak St', 'Berlin', '10115', 'Germany'), 
  ('Emily', 'Jones', 3, '2021-07-08', '9101 Pine St', 'Paris', '75000', 'France');

-- Insert active projects with name and budget information into Projects table.
INSERT INTO Projects (ProjectName, Budget) VALUES 
  ('Project Alpha', 100000.00), 
  ('Project Beta', 200000.00), 
  ('Project Gamma', 150000.00);

-- Describe the employees' roles in various projects within EmployeeProjects table.
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, Role) VALUES 
  (1, 1, 'Manager'), 
  (2, 2, 'Developer'), 
  (1, 2, 'Consultant'), 
  (3, 3, 'Analyst');

-- === Performing Joins ===

-- Inner Join: Retrieve employee-project data for those actively assigned, detailing roles.
SELECT e.FirstName, e.LastName, p.ProjectName, ep.Role
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID;

-- Left Join: Retrieve all employee information, including possible nulls where no project is assigned.
SELECT e.FirstName, e.LastName, p.ProjectName, ep.Role
FROM Employees e
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p ON ep.ProjectID = p.ProjectID;

-- Right Join: Retrieve all projects, showing employee details if assigned (nulls for unassigned).
SELECT p.ProjectName, e.FirstName, e.LastName, ep.Role
FROM Employees e
RIGHT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
RIGHT JOIN Projects p ON ep.ProjectID = p.ProjectID;

-- Cross Join: Generates the Cartesian product of employees and projects.
SELECT e.FirstName, e.LastName, p.ProjectName
FROM Employees e
CROSS JOIN Projects p;

-- === Adding an Index ===
-- Creating an index on DepartmentID in the Employees table to speed up related queries.
CREATE INDEX idx_department_employee ON Employees (DepartmentID);

-- === Cleaning up ===
-- Removes all tables and their data, enabling a database reset.
DROP TABLE IF EXISTS EmployeeProjects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Departments;