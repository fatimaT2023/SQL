CREATE DATABASE TechWorldHRDB;

CREATE TABLE TemporaryStaff (
StaffID INT PRIMARY KEY ,
StaffName VARCHAR(50),
HireDate DATE 
);

SELECT * FROM TemporaryStaff;

CREATE TABLE Departments (
DepartmentID INT PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Employees (
EmployeeID INT PRIMARY KEY ,
FullName VARCHAR(100) NOT NULL ,
Email VARCHAR(100) UNIQUE,
Salary DECIMAL(10,2),
DepartmentID INT
);

ALTER TABLE Employees 
ADD PhoneNumber  VARCHAR(20);


DROP TABLE TemporaryStaff ;
--SELECT * FROM TemporaryStaff ;

INSERT INTO Departments  
VALUES (1,'IT');

INSERT INTO Departments  
VALUES (2,'HR');

INSERT INTO Departments  
VALUES (3,'Finance');

SELECT * FROM Departments;

INSERT INTO Employees 
VALUES(1,'Ahmad Ali' ,'ahmad@techworld.com' ,1200.00 ,1,'0791111111');

INSERT INTO Employees 
VALUES(2,'Sara Hassan'  ,'sara@techworld.com'  ,950.00  ,2,'0792222222');


INSERT INTO Employees 
VALUES(3,'Zaid Omar','zaid@techworld.com'  ,1500.00,1,'0793333333');

INSERT INTO Employees 
VALUES(4,'Mona Khaled' ,'mona@techworld.com',800.00 ,3,'0794444444');



UPDATE Employees
SET Salary =1350.00
WHERE EmployeeID=1;

DELETE FROM Employees
WHERE EmployeeID = 4 ;

SELECT * FROM Employees;

SELECT FullName ,Salary
FROM Employees;

SELECT SUM(Salary) AS TotalSalaries
FROM Employees;

SELECT AVG(Salary) AS AverageSalary
FROM Employees;


SELECT 
MAX(Salary) AS HighestSalary,
MIN (Salary )AS LowestSalary
FROM Employees;

SELECT COUNT(EmployeeID)AS TotalEmployees FROM Employees;

--access card 1:1
CREATE TABLE AccessCards (
CardID int primary key ,
CardNumber varchar(50) not null unique ,
EmployeeID int unique 
foreign key (EmployeeID)
References  Employees(EmployeeID)
);
--m:n
create table Projects (
projectid int primary key ,
projectname varchar(100) not null 
);
--junvation table
create table EmployeeProjects (
projectid int  ,
EmployeeID int  ,
AssignedDate  date,
foreign key (projectid)
References  Projects(projectid),
foreign key (EmployeeID)
References  Employees(EmployeeID),
primary key (EmployeeID,ProjectID)
);


INSERT INTO AccessCards (CardID, CardNumber, EmployeeID)
VALUES(1, 'CARD1', 1),(2, 'CARD2', 2),(3, 'CARD3', 3);


INSERT INTO Projects (ProjectID, ProjectName)
VALUES(1, 'AI & Security Training'),(2, 'Cloud Migration');



INSERT INTO EmployeeProjects (EmployeeID, ProjectID, AssignedDate)
VALUES (1, 1, '2026-10-29'),(1, 2, '2026-10-29'),(2, 1, '2026-10-29'),(3, 2, '2026-10-29');

--pahses6
--name +salary+dep
select 
FullName ,Salary,DepartmentName 
from Employees 
inner join Departments 
ON Employees.DepartmentID = Departments.DepartmentID;

--dep is a left table
SELECT *
FROM Departments
LEFT JOIN Employees
ON Departments.DepartmentID = Employees.DepartmentID;

select FullName ,CardNumber
from Employees
INNER JOIN AccessCards
ON Employees.EmployeeID = AccessCards.EmployeeID;

--multi table join
SELECT
    Employees.FullName,
    Projects.ProjectName,
    EmployeeProjects.AssignedDate
FROM Employees
INNER JOIN EmployeeProjects
ON Employees.EmployeeID = EmployeeProjects.EmployeeID

INNER JOIN Projects
ON EmployeeProjects.ProjectID = Projects.ProjectID;

--phase7

SELECT
    DepartmentID,
    SUM(Salary) AS TotalSalary,
    COUNT(EmployeeID) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;


SELECT
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;



SELECT *
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);

Go
CREATE VIEW vw_EmployeeDetails AS
SELECT
    Employees.EmployeeID,
    Employees.FullName,
    Employees.Email,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;


SELECT *
FROM vw_EmployeeDetails;

go
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE DepartmentID = @DeptID;
END;

EXEC sp_GetEmployeesByDepartment @DeptID = 1;


CREATE TABLE EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);

go
CREATE TRIGGER trg_AfterEmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (
        EmployeeID,
        Action,
        ActionDate
    )
    SELECT
        EmployeeID,
        'DELETE',
        GETDATE()
    FROM deleted;
END;

DELETE FROM Employees
WHERE EmployeeID = 3;

SELECT *
FROM EmployeeAudit;