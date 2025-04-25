
-- CREAR UNA BASE DE DATOS:
DROP DATABASE IF EXISTS 'Company';
CREATE DATABASE 'Company';
USE 'Company';

CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  PRIMARY KEY (employee_id) -- Se define cuál es el campo clave como llave primaria. 
);

CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  jobtitle VARCHAR(50) NOT NULL,
  salary INT,
);

CREATE TABLE employee_demographics_supplier (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  PRIMARY KEY (employee_id) -- Se define cuál es el campo clave como llave primaria. 
);


INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender)
VALUES
(1001,'Leslie', 'Knope', 44, 'Female'),
(1003,'Tom', 'Haverford', 36, 'Male'),
(1004, 'April', 'Ludgate', 29, 'Female'),
(1005, 'Jerry', 'Gergich', 61, 'Male'),
(1006, 'Donna', 'Meagle', 46, 'Female'),
(1007, 'Ann', 'Perkins', 35, 'Female'),
(1008, 'Chris', 'Traeger', 43, 'Male'),
(1009, 'Ben', 'Wyatt', 38, 'Male'),
(1011, 'Mark', 'Brendanawicz', 40, 'Male'),
(NULL, 'Craig', 'Middlebrooks', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male');

-- Insertar información a las tablas
INSERT INTO employee_salary (employee_id, jobtitle, salary)
VALUES
(1001, 'Salesman', 75000),
(1002, 'Receptionist', 70000),
(1003, 'Salesman', 50000),
(1004, 'Accountant', 25000),
(1005, 'HR', 50000),
(1006, 'Regional', 60000),
(1007, 'Supplier', 55000),
(1008, 'Salesman', 90000),
(1009, 'Accountant', 70000),
(1010,  NULL, 20000),
(NULL, 'Salesman', 57000);

INSERT INTO employee_demographics_supplier (employee_id, first_name, last_name, age, gender)
VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Felipe', 'Alvarez', 25, 'Male'),
(1051, 'Antonio', 'Jaramillo', NULL, 'Male'),
(1052, 'Daniela', 'Cuartas', NULL, 'Female');


-- OVER PARTITION BY (Funciones de ventana en español)
-- Debes ensayarlo más. Es como un Gruop By que permite hacer funciones de agregación
-- sobre algunas categorias. Sin embargo, permitiendome tener los campos particulares, es decir, 
-- ver el id, nombre, etc, de cada registro. 

-- Para el caso de este query, me permite ver el salario de cada empleado y compararlo con el total 
-- de personas de su genero y el salario de las personas de su mismo genero.
SELECT first_name, last_name, gender, salary, COUNT(gender) OVER (PARTITION BY gender) AS TotalGender,
    AVG(salary) OVER (PARTITION BY gender) AS avg_salary
FROM Company.employee_demographics emp 
INNER JOIN Company.employee_salary sal 
    ON emp.employee_id = sal.employee_id;


-- CAST: 






-- CTE (Common Table Expression): Its a temporary result set which is used to manipulate subquerys data.
-- Son tablas temporales que se crean dentro de un query para manipular información más compleja.
-- Solo existen dentro de la consulta, no se esta creando ninguna tabla en la base de datos
-- Usualmente se utilizan cuando se hacen muchos GROUP BY u operaciones entre columnas.

WITH cte_employee AS (
    SELECT first_name, last_name, gender, salary, 
    COUNT(gender) OVER (PARTITION BY gender) AS TotalGender,
    AVG(salary) OVER (PARTITION BY gender) AS avg_salary
    FROM Company.employee_demographics emp 
    INNER JOIN Company.employee_salary sal 
        ON emp.employee_id = sal.employee_id

) SELECT first_name, salary, avg_salary
FROM cte_employee -- Se consulta la tabla que se acabo de crear.
WHERE salary > 45000;


-- TEMP TABLES: Se diferencias con las tablas normales, puesto que se les pone un # al frente del nombre.
-- Se utilizan para almacenar querys, con el fin de ahorrar tiempo en la ejecución de los mismos.

CREATE TABLE #temp_employee (
    employee_id INT,
    jobtitle VARCHAR(100),
    salary INT
)

-- Se les puede insertar datos como a una tabla normal.
INSERT INTO #temp_employee VALUES (
    '1001', 'HR', 45000
)

-- Sin embargo, la manera más común, es a través de Querys.
INSERT INTO #temp_employee 
SELECT * 
FROM Company.employee_salary
LIMIT 100;

-- Veamos un caso más práctico. 
DROP TABLE IF EXISTS #temp_employee2
CREATE TABLE #temp_employee2 (
    jobtitle VARCHAR(50),
    employees_per_job INT,
    avg_age INT,
    avg_salary INT
)

INSERT INTO #temp_employee2
SELECT jobtitle, COUNT(jobtitle), AVG(age), AVG(salary)
FROM Company.employee_demographics emp 
INNER JOIN Company.employee_salary sal 
    ON emp.employee_id = sal.employee_id
GROUP BY jobtitle;

-- Luego de haber guardado la data en una tabla, la puedo consultar varias veces sin necesidad de correr
-- todo el query anterior.
-- Validar alamcenamiento y velocidad de procesamiento.
SELECT * 
FROM #temp_employee2;


-- STRING FUNCTIONS: Funciones con caracteres. A continuación se muestran las principales.
DROP TABLE IF EXISTS EmployeeErrors;

CREATE TABLE EmployeeErrors (
    EmployeeID VARCHAR(50), 
    first_name VARCHAR(50), 
    last_name VARCHAR(50)
)

-- Se tienen datos en la tabla con errores
INSERT INTO EmployeeErrors VALUES 
    ('1001  ', 'Jimbo', 'Halbert'), 
    ('  1002', 'Pamela', 'Beasely'), 
    ('1005', 'TOby', 'Flenderson - Fired');

-- Using TRIM, LTRIM, RTRIM: Se quitan los espacios.
SELECT EmployeeID, TRIM(employeeID) AS IDTRIM --espacios a la derecha e izquierda
FROM EmployeeErrors; 

SELECT EmployeeID, RTRIM(employeeID) AS IDRTRIM -- espacios a la derecha, al final de la palabra
FROM EmployeeErrors;

SELECT EmployeeID, LTRIM(employeeID) AS IDLTRIM -- espacios a la izquierda, al principio de la palabra
FROM EmployeeErrors;

-- Using REPLACE: Permite reemplazar patrones errados dentro de una columna.
SELECT LastName, REPLACE(LastName, '- Fired', '') AS LastNameFixed -- Se reemplaza con nada
FROM EmployeeErrors; 

-- Using SUBSTRING: (campo, caracter de inicio, cantidad de caracteres a extraer).
SELECT SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3), SUBSTRING(err.LastName,1,3), 
    SUBSTRING(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	AND Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- Using UPPER and lower:
SELECT first_name, LOWER(first_name) -- Pasar a minusculas todas las letras del campo.
FROM EmployeeErrors;

Select first_name, UPPER(first_name) -- Pasar a mayusculas todas las letras del campo.
FROM EmployeeErrors;


-- STORED PROCEDURES: Sirven para guardar procedimientos (varios querys) dentro de una ejecución o comando.
-- No se ponen ejemplos ya que se deben practicar en una base de datos para entender.


-- SUBQUERIES: Son queries que se utilizan al interior de un Query que sirven para filtar o como FROM.




