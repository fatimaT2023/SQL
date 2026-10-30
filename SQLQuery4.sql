use CourseHubDB;
Go 
--STAGE2
CREATE TABLE Departments(
DepartmentID INT PRIMARY KEY ,
DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
StudentID  INT PRIMARY KEY,
FullName  VARCHAR(100) NOT NULL,
Email  VARCHAR(100) UNIQUE ,
GPA DECIMAL(3,2),
DepartmentID  INT,
FOREIGN KEY (DepartmentID ) REFERENCES Departments(DepartmentID)
);

CREATE TABLE StudentProfiles (
ProfileID  INT PRIMARY KEY ,
StudentID INT UNIQUE ,
FOREIGN KEY ( StudentID) REFERENCES Students(StudentID),
Address  VARCHAR(MAX),
EmergencyPhone VARCHAR(20)
);


CREATE TABLE Courses  (
CourseID  INT PRIMARY KEY ,
CourseName VARCHAR(100)NOT NULL,
Credits INT, 
DepartmentID  INT,
FOREIGN KEY (DepartmentID ) REFERENCES Departments(DepartmentID)
);
--M:NJUNCTION TABLE 
CREATE TABLE StudentCourses (
StudentID INT,
FOREIGN KEY (StudentID ) REFERENCES Students(StudentID),
CourseID  INT,
FOREIGN KEY (CourseID ) REFERENCES Courses(CourseID),
EnrollmentDate  DATE DEFAULT GETDATE(),
PRIMARY KEY (StudentID, CourseID)
);

SELECT *
FROM sys.tables;

ALTER TABLE Students 
ADD Age INT;

SELECT *
FROM Students;

DROP TABLE TempInstructors ;

--STAGE3
INSERT INTO Departments
VALUES(1, 'Computer Science'), (2, 'Software Engineering'), (3, 'Business Administration');

SELECT * FROM Departments;

INSERT INTO Students
VALUES(101,'Ali Smadi','ali@coursehub.com' ,3.80 ,1 ,22),
(102 ,'Omar Ahmad','omar@coursehub.com' ,2.90  ,1 ,21),
(103 ,'Laila Hassan' ,'laila@coursehub.com'  ,3.50  ,2 ,23),
(104 ,'Tariq Zaid','tariq@coursehub.com'   ,2.10  ,3 ,20);

SELECT * FROM Students;

INSERT INTO StudentProfiles
VALUES(1, 101, 'Amman, Jordan', '0791111111'), (2, 102, 'Irbid, Jordan', '0792222222'), (3, 103, 'Zarqa, Jordan', '0793333333')

SELECT * FROM StudentProfiles;

INSERT INTO Courses
VALUES(201, 'Database Systems', 3, 1), (202, 'Web Development', 3, 1), (203, 'Software Architecture', 3, 2)

SELECT * FROM Courses;

SELECT * FROM StudentCourses;

INSERT INTO StudentCourses(StudentID, CourseID)
VALUES(101,201),(101,202),(102,201),(103,203);

UPDATE  Students
SET GPA=2.50
WHERE StudentID = 104;

DELETE FROM Students
WHERE StudentID = 104;

--STAGE 4

SELECT 
Students.FullName,
Students.GPA,
Departments.DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID=Departments.DepartmentID;

SELECT 
Departments.DepartmentName,
Students.FullName
FROM Students
LEFT JOIN Departments
ON Departments.DepartmentID=Students.DepartmentID;


SELECT 
Students.FullName,
StudentProfiles.Address,
StudentProfiles.EmergencyPhone
FROM Students
INNER JOIN StudentProfiles
ON StudentProfiles.StudentID=Students.StudentID;


SELECT 
Students.FullName,
Courses.CourseName,
StudentCourses.EnrollmentDate
FROM StudentCourses
INNER JOIN Courses
ON Courses.CourseID=StudentCourses.CourseID
INNER JOIN Students
ON Students.StudentID=	StudentCourses.StudentID;

--stage 5

SELECT 
COUNT(*) AS TotalStudents ,
AVG(GPA) AS AverageGPA ,
MAX(GPA) AS HighestGPA ,
MIN (GPA) AS LowestGPA  
FROM Students;

SELECT 
DepartmentID,
AVG(GPA) AS AverageGPA,
COUNT(*) AS TotalStudents 
FROM Students
GROUP BY DepartmentID;

SELECT
DepartmentID,
AVG(GPA) AS AverageGPA
FROM Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;

SELECT 
DepartmentID,
COUNT(*) AS TotalStudents
FROM Students
WHERE GPA >=2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;


--STAGE 6

EXEC sp_helpindex 'Students';

CREATE NONCLUSTERED INDEX IX_Students_Email
on Students (Email);


--stage 7

SELECT 
*
FROM Students
WHERE GPA > (SELECT AVG(GPA) FROM Students);


GO 
CREATE VIEW vw_StudentAcademicDetails AS
SELECT 
StudentID,
Students.FullName,
Students.GPA,
Departments.DepartmentName
FROM Students
INNER JOIN Departments
ON Students.DepartmentID=Departments.DepartmentID;

SELECT * FROM vw_StudentAcademicDetails;
GO
CREATE PROCEDURE sp_GetStudentsByDepartment
@DepID INT 
AS 
BEGIN 
SELECT *
FROM Students
WHERE DepartmentID=@DepID
END;



EXEC sp_GetStudentsByDepartment
@DepID=1;