--BUILDING AN EMPLOYEE_DEMOGRAPHIC TABLE WITHIN MY Personal DB
CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar (50),
Age int,
Gender varchar(50) )
;

--BUILDING AN EMPLOYEE_SALARY TABLE WITHIN MY Personal DB
CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int)
;

--INSERTING DATA INTO TABLES CREATED ABOVE
INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Jeff', 'Rice', 32, 'Male'),
(1003, 'Cyril', 'Amankesi', 29, 'Male'),
(1004, 'Bella', 'Caprion', 31, 'Female'),
(1005, 'Akoboat', 'Halley', 40, 'Female'),
(1006, 'Stanley', 'Hudson', 38, 'Male'),
(1007, 'Michael', 'Scott', 35, 'Male'),
(1008, 'Kevin', 'Malone', 30, 'Male'),
(1009, 'Meredith', 'Palmer', 30, 'Female')
;

INSERT INTO EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Senior Accountant', 42000)
;

--INSERTING NEW ROWS INTO THE EMPLOYEE_DEMOGRAPHICS TABLE
INSERT INTO EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 25, 'Male'),
('', 'Holly', 'Flax', '', ''),
(1013, 'Darryl', 'Phillips', '', 'Male')
;

--UPDATE STATEMENT: ALTERING A SPECIFIC ROW
UPDATE EmployeeDemographics 
SET Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax'
;

--DELETE STATEMENT: DELETING ROWS IN A TABLE
DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1005
;

--DIFFERENCE BETWEEN PARTITION BY AND GROUP BY TO FIND THE # OF MALES AND FEMALES
SELECT FirstName, LastName, Gender, Salary, 
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM EmployeeDemographics ED
INNER JOIN EmployeeSalary SAL ON ED.EmployeeID = SAL.EmployeeID
;

SELECT Gender, COUNT(Gender) 
FROM EmployeeDemographics ED
INNER JOIN EmployeeSalary SAL ON ED.EmployeeID = SAL.EmployeeID
GROUP BY  Gender
;

--EXPLORING CTEs: Common Table Expressions
With CTE_Employee AS
(SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
SELECT *
FROM CTE_Employee
;

--CREATING TEMP TABLE
CREATE TABLE #temp_Employee
(EmployeeID int,
JobTitle varchar(100),
Salary int )
;

-- EXPLORING DIFFERENT WAYS TO INSERT DATA INTO A TEMP TABLE
INSERT INTO #temp_Employee VALUES
('1001', 'HR', '45000')
;

--INSERTING ALL DATA FROM Employee_Salary TABLE INTO THE TEMP TABLE
INSERT INTO #temp_Employee
SELECT *
FROM EmployeeSalary

SELECT *
FROM #temp_Employee
;

--EXPLORING ALTERNATIVES TO CREATING A TEMP TABLE AND POPULATING IT WITH A QUERY
DROP TABLE IF EXISTS #TempEmployee2 -- CREATE TABLE BELOW SEVERAL TIMES WITHOUT ERROR
CREATE TABLE #TempEmployee2
( JobTitle char(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #TempEmployee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM  #TempEmployee2
;

-- EXPLORING SUBSTRINGS AND TRIMS
CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

INSERT INTO EmployeeErrors VALUES
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

SELECT *
FROM EmployeeErrors
;

-- USING TRIM, LTRIM, RTRIM
SELECT EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

SELECT EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

SELECT EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 
;

-- USING REPLACE TO FIX ERRORS IN A FIELD
SELECT LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors
;

-- USING SUBSTRING FOR FUZZY MATCHING
SELECT SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3), SUBSTRING(err.LastName,1,3), SUBSTRING(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)
	AND SUBSTRING(err.LastName,1,3) = SUBSTRING(dem.LastName,1,3)
;

-- STORED PROCEDURES: A GROUP OF SQL STATEMENTS CREATED AND STORED IN A DATABASE
CREATE PROCEDURE TEST
AS 
SELECT *
FROM EmployeeDemographics

EXEC TEST
;

--ANOTHER WAY OF CREATING STORED PROCEDURES
CREATE PROCEDURE Temp_Employee2
AS
DROP TABLE IF EXISTS #TempEmployee2 -- CREATE TABLE BELOW SEVERAL TIMES WITHOUT ERROR
CREATE TABLE #TempEmployee2
( JobTitle char(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #TempEmployee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #TempEmployee2

EXEC Temp_Employee2 
;

--MODIFYING A STORED PROCEDURES
USE [Personal DB]
GO
/****** Object:  StoredProcedure [dbo].[Temp_Employee2]    Script Date: 4/23/2024 9:54:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Temp_Employee2]
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #TempEmployee2 -- CREATE TABLE BELOW SEVERAL TIMES WITHOUT ERROR
CREATE TABLE #TempEmployee2
( JobTitle char(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #TempEmployee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal ON emp.EmployeeID = sal.EmployeeID
WHERE JobTitle = @JobTitle
GROUP BY JobTitle

EXEC Temp_Employee2 @JobTitle = 'Salesman'

