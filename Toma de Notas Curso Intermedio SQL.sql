
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

-- INNER, RIGHT, LEFT, OUTER JOINS: Sirven para unir varias tablas.
-- Se unen a través de uno o varios campos donde se tengan coincidencia.

-- INNER JOIN: Trae los registros que SOLO están en AMBAS tablas.
-- Lo que se traslapa. Que aparece en ambas tablas. 
SELECT *
FROM Company.employee_demographics 
INNER JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- OUTER JOIN: Trae todos los registros que aparecen en ambas tablas.
-- Sin importar si tiene coincidencia o no.
SELECT *
FROM Company.employee_demographics 
INNER JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- LEFT JOIN: Trae todos los registros de la primera tabla,
-- Y de la segunda tabla se trae solo los registros con los que tienen coincidencia.
-- La tabla de la izquierda es la primera que escribí.
SELECT *
FROM Company.employee_demographics 
LEFT JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- RIGHT JOIN: Trae todos los registros de la SEGUNDA tabla,
-- Y de la PRIMERA tabla se trae solo los registros con los que tienen coincidencia.
-- La tabla de la DERECHA es la SEGUNDA que se escribí.
SELECT *
FROM Company.employee_demographics 
RIGHT JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- Puedo especificar los campos que quiero. Si tienen mismo nombre, debo especificar la tabla.
SELECT employee_demographics.employee_id, first_name, last_name, jobtitle, salary
FROM Company.employee_demographics 
INNER JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;

-- Con filtros
SELECT employee_demographics.employee_id, first_name, last_name, salary
FROM Company.employee_demographics 
INNER JOIN Company.employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;
WHERE first_name <> 'Michal' -- Nombre diferente a Michael
ORDER BY salary DESC; -- Del salario más bajo al más alto


-- UNIONS: Sirven para concatenar tablas que tienen los mismos campos. 
-- Se hace una consulta a dos tablas y se tiene un solo resultado.

-- Tienen que tener la misma cantidad de columnas y que sean del mismo tipo.
-- Trae todos los registros sin omitir duplicados.
SELECT *
FROM Company.employee_demographics
UNION
SELECT *
FROM Company.employee_demographics_supplier;

-- Tienen que tener la misma cantidad de columnas y que sean del mismo tipo.
-- Trae todos los registros sin omitir duplicados.
SELECT *
FROM Company.employee_demographics
UNION ALL
SELECT *
FROM Company.employee_demographics_supplier;

-- Permite hacer la unión porque son la misma cantidad de columnas y mismo tipos de datos.
SELECT employee_id, first_name, age
FROM Company.employee_demographics
UNION 
SELECT employee_id, jobtitle, salary 
FROM Company.employee_salary;



-- CASE STATEMENT: Permite especificar condiciones y especificar que dato quieres que se muestre en caso 
-- de cumplir dicha condición

SELECT first_name, last_name, age
CASE
    WHEN age > 30 THEN 'Old'
    WHEN age BETWEEN 27 AND 30 THEN 'Young'
    ELSE 'Baby'
END
FROM employee_demographics
WHERE age IS NOT NULL
ORDER BY age;


-- Case con un JOIN
SELECT first_name, last_name, jobtitle, salary
CASE
    WHEN jobtitle = 'Salesman' THEN salary + (salary * 0.10)
    WHEN jobtitle = 'Accountant' THEN salary + (salary * 0.05)
    WHEN jobtitle = 'HR' THEN salary + (salary * 0.01)
    ELSE salary + (salary * 0.03)
END AS salary_after_raise
FROM employee_demographics
INNER JOIN employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id;


-- HAVING: 
SELECT jobtitle, COUNT(jobtitle)
FROM employee_demographics
INNER JOIN employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id
GROUP BY jobtitle;
HAVING COUNT(jobtitle) > 1; -- El Having debe estar después del GROUP BY siempre. 
-- Solo se hace el filtro de la función agregada una vez ya esta agrupada.

SELECT jobtitle, AVG(salary)
FROM employee_demographics
INNER JOIN employee_salary
    ON employee_demographics.employee_id = employee_salary.employee_id
GROUP BY jobtitle
HAVING AVG(salary) > 45000
ORDER BY AVG(salary);

-- UPDATE: Modificar una fila existente dentro de la tabla.
UPDATE employee_demographics
SET employee_id = 1012 -- Campo a actualizar
WHERE first_name = 'Holly'
    AND last_name = 'Flax';

UPDATE employee_demographics
SET age = 31, gender = 'Female' -- Cuando voy a actualizar la información de varios campos.
WHERE first_name = 'Holly'
    AND last_name = 'Flax';

-- DELETE: Eliminar una fila existente dentro de la tabla. Una vez borrada la información no hay manera
-- de recuperarla o deshacer el cambio.

DELETE FROM employee_demographics
WHERE employee_id = 1005; -- Se esta borrando toda la(s) fila(s) que tengan el id relacionado.

-- Aliasing (AS):
SELECT first_name + ' ' + last_name AS full_name -- Me traigo solo una columna con el nombre completo
FROM employee_demographics;

SELECT CONCAT(first_name,' ',last_name) AS full_name -- Concateno el nombre y apellido en una misma columna
FROM employee_demographics;


SELECT jobtitle, AVG(salary) AS avg_salary
FROM employee_demographics AS t1
INNER JOIN employee_salary AS t2
    ON t1.employee_id = t2.employee_id
GROUP BY jobtitle
HAVING avg_salary > 45000
ORDER BY avg_salary;

-- LPAD y RPAD:
--Lpad: rellena por la izquierda. P.e. lpad('437',5,'0') tendría como resultado 00437.
--RPad: rellena por la derecha. P.e. rpad('437',5,'0') tendría como resultado 43700.

-- Serviría para agregar caracteres a la derecha y a la izquierda de los campos que se encuentren en una
-- columna.


-- GENERATE_SERIES: Permite generar series. El primer valor corresponde al inicio, el segundo valor al fin (incluído),
-- ahí va el rango y el último al delta con el cual se va a recorrer ese rango.

SELECT * 
FROM GENERATE_SERIES(0,5,1); -- Saca una columna con los números del 0 al 5

SELECT * 
FROM GENERATE_SERIES(1.1, 4, 1.3); -- Saca el 1.1, 2.4, 3.7.

-- Se puede con fechas:
SELECT * 
FROM GENERATE_SERIES('2020-09-01 00:00:00'::timestamp,
                    '2020-09-04 12:00:00',
                    '10 hours'); -- Los registros de fecha que hay desde la primera a la segunda, con espacios
                                -- de 10 horas.















