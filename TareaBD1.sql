
USE AdventureWorks2019
GO

----------------------- Ejercicio 1 -------------------------------------------------------

CREATE OR ALTER VIEW ProductionProduct_DiscontinuedDate
AS
	SELECT * FROM Production.Product 
	WHERE DiscontinuedDate IS NOT NULL
GO

SELECT * FROM ProductionProduct_DiscontinuedDate
GO

----------------------- Ejercicio 2 -------------------------------------------------------------

CREATE OR ALTER VIEW ActiveProducts
AS
	SELECT ProductID,[Name], ProductSubcategoryID, ProductModelID
	FROM Production.Product
	WHERE DiscontinuedDate IS NULL
GO

SELECT * FROM ActiveProducts
GO

------------------------ Ejercicio 3 ------------------------------------------------------------------

CREATE OR ALTER VIEW DocumentControl
AS
SELECT hd.Name Departamento, pp.FirstName, pp.LastName, hr.NationalIDNumber,
	hr.LoginID, hr.ModifiedDate
FROM HumanResources.Department As hd
INNER JOIN HumanResources.EmployeeDepartmentHistory AS hdh
ON hd.DepartmentID = hdh.DepartmentID
INNER JOIN HumanResources.Employee AS hr
ON hdh.BusinessEntityID = hr.BusinessEntityID
INNER JOIN Person.Person AS pp 
ON pp.BusinessEntityID = hr.BusinessEntityID
GO

SELECT * FROM DocumentControl
GO

SELECT * FROM HumanResources.EmployeeDepartmentHistory
GO

-------------------------- Ejercicio 4 ---------------------------------------------------------------------

CREATE OR ALTER PROC GeneralEmployee(
	@DepartamentID SMALLINT 
)
AS
BEGIN
	SELECT hd.Name Departamento, pp.FirstName, pp.LastName, hr.NationalIDNumber,
	hr.LoginID, hr.ModifiedDate
	FROM HumanResources.Department As hd
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS hdh
	ON hd.DepartmentID = hdh.DepartmentID
	INNER JOIN HumanResources.Employee AS hr
	ON hdh.BusinessEntityID = hr.BusinessEntityID
	INNER JOIN Person.Person AS pp 
	ON pp.BusinessEntityID = hr.BusinessEntityID
	WHERE hd.DepartmentID = @DepartamentID
END
GO

EXEC GeneralEmployee 2
GO

-------------------------- Ejercicio 5 ---------------------------------------------------------------- 

CREATE OR ALTER PROC Birthday(
	@DepartamentID INT NULL
)
AS
BEGIN

	DECLARE @Temp TABLE (
		DepartmentID INT,
		Departament NVARCHAR(40),
		FirstName NVARCHAR(40),
		LastName NVARCHAR(40),
		BirthDate DATE
	);

	INSERT INTO @Temp(DepartmentID, Departament,FirstName,LastName,BirthDate)
	SELECT hd.DepartmentID, hd.Name Departamento, pp.FirstName, pp.LastName, hr.BirthDate
	FROM HumanResources.Department As hd
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS hdh
	ON hd.DepartmentID = hdh.DepartmentID
	INNER JOIN HumanResources.Employee AS hr
	ON hdh.BusinessEntityID = hr.BusinessEntityID
	INNER JOIN Person.Person AS pp 
	ON pp.BusinessEntityID = hr.BusinessEntityID
	ORDER BY pp.LastName, hd.Name 

	IF(@DepartamentID IS NOT NULL)
	SELECT * FROM @Temp AS t
	WHERE t.DepartmentID = @DepartamentID AND MONTH(t.BirthDate) = MONTH(GETDATE())
 	ELSE 
	SELECT * FROM @Temp AS t
	WHERE MONTH(T.BirthDate) = MONTH(GETDATE())

END
GO

EXEC Birthday NULL
GO

-------------------------------------------- Ejercicio 6

CREATE OR ALTER PROC Us_Ejercicio6(
	@DepartamentID INT NULL
)
AS
BEGIN

DECLARE @Temp TABLE (
		DepartmentID INT,
		Departamento NVARCHAR(40),
		NumberEmpleados INT
	);

	INSERT INTO @Temp (DepartmentID, Departamento, NumberEmpleados)
	SELECT hd.DepartmentID, hd.Name Departamento, COUNT(hr.BusinessEntityID) NumberEmpleados
	FROM HumanResources.Department As hd
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS hdh
	ON hd.DepartmentID = hdh.DepartmentID
	INNER JOIN HumanResources.Employee AS hr
	ON hdh.BusinessEntityID = hr.BusinessEntityID
	INNER JOIN Person.Person AS pp 
	ON pp.BusinessEntityID = hr.BusinessEntityID
	GROUP BY hd.DepartmentID, hd.Name
	ORDER BY hd.Name

	IF(@DepartamentID IS NOT NULL)
	SELECT * FROM @Temp AS t
	WHERE t.DepartmentID = @DepartamentID
 	ELSE 
	SELECT * FROM @Temp AS t
END
GO

EXEC Us_Ejercicio6 null
GO