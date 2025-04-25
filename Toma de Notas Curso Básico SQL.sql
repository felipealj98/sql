
-- La idea siempre es practicar instalando un administrador de base de datos MySQL or Posgrade,
-- el cual permita practicar.
-- Para la toma de notas en los cursos, no voy a instalar ninguna base de datos, solo será para toma de notas.

-- INFORMACIÓN GENERAL:
-- Con esta sintaxis puedo hacer comentarios en SQL.
-- Las consultas se separan con ; 
-- SQL no distingue entre mayúsculas y minúsculas.
-- No se pueden poner espacios en los nombres de las columnas.

-- Lo primero que se debe hacer en crear una base de datos.
-- Una base de datos es un conjunto de tables que se relacionan entre sí.

-- CREAR UNA BASE DE DATOS:
-- Se borra en caso de que exista
DROP DATABASE IF EXISTS 'Parks_and_Recreation';
-- Se procede a crear
CREATE DATABASE 'Parks_and_Recreation';
-- La consulta para utilizar la base de datos.
USE 'Parks_and_Recreation';


-- Crear tablas, especificando los campos y los tipos de datos que contienen.
CREATE TABLE employee_demographics (
  employee_id INT NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  birth_date DATE,
  PRIMARY KEY (employee_id)
);

-- Crear tablas, especificando los campos y los tipos de datos que contienen.
CREATE TABLE employee_salary (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT
);

-- Insertar los registros (datos) a las tablas
INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1,'Leslie', 'Knope', 44, 'Female','1979-09-25'),
(3,'Tom', 'Haverford', 36, 'Male', '1987-03-04'),
(4, 'April', 'Ludgate', 29, 'Female', '1994-03-27'),
(5, 'Jerry', 'Gergich', 61, 'Male', '1962-08-28'),
(6, 'Donna', 'Meagle', 46, 'Female', '1977-07-30'),
(7, 'Ann', 'Perkins', 35, 'Female', '1988-12-01'),
(8, 'Chris', 'Traeger', 43, 'Male', '1980-11-11'),
(9, 'Ben', 'Wyatt', 38, 'Male', '1985-07-26'),
(10, 'Andy', 'Dwyer', 34, 'Male', '1989-03-25'),
(11, 'Mark', 'Brendanawicz', 40, 'Male', '1983-06-14'),
(12, 'Craig', 'Middlebrooks', 37, 'Male', '1986-07-27');

-- Insertar los registros (datos) a las tablas
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000,1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000,1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000,1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000,1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000,1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000,1),
(7, 'Ann', 'Perkins', 'Nurse', 55000,4),
(8, 'Chris', 'Traeger', 'City Manager', 90000,3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000,6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner and Musician', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3),
(12, 'Craig', 'Middlebrooks', 'Parks Director', 65000,1);



CREATE TABLE parks_departments (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name varchar(50) NOT NULL,
  PRIMARY KEY (department_id)
);

INSERT INTO parks_departments (department_name)
VALUES
('Parks and Recreation'),
('Animal Control'),
('Public Works'),
('Healthcare'),
('Library'),
('Finance');

-- SELECT: Sirve para especificar lo que quiero traer o ver en la consulta.
-- Ver todos los datos de la tabla
SELECT *
FROM Parks_and_Recreation.employee_demographics;

-- Traer solamente unos campos.
SELECT first_name, last_name
FROM Parks_and_Recreation.employee_demographics;

-- Se pueden hacer operaciones con las columnas.
SELECT first_name, last_name, birth_date, age, (age + 10) * 10 AS new_age
FROM Parks_and_Recreation.employee_demographics;

-- Traer los campos únicos de un campo en especifico. 
SELECT DISTINCT gender
FROM Parks_and_Recreation.employee_demographics;

--WHERE: Sirve para filtrar
-- Traer todos los campos de los registros que cumplan una condición especifica.
SELECT *
FROM Parks_and_Recreation.employee_salary
WHERE first_name = 'Leslie';

-- Se pueden hacer comparaciones de valores
SELECT *
FROM Parks_and_Recreation.employee_salary
WHERE salary > 50000; -- Mayor

SELECT *
FROM Parks_and_Recreation.employee_salary
WHERE salary >= 50000; -- Mayor o igual

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE gender != 'Female'; -- Los valores diferentes

-- Operaciones con fechas. Formato 'YYYY-MM-DD'. 
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date > '1985-01-13'; -- Feachas mayores a la relacionada. Nacieron después.

-- Operadores lógicos. ANR, OR, NOT.

-- Trae los registros que cumplan las dos condiciones.
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date > '1985-01-13'
    AND gender = 'Male';

-- Trae los registros que cumplan solo UNA de las dos condiciones.
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date > '1985-01-13'
    OR gender = 'Male';

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date > '1985-01-13'
    OR NOT gender = 'Male'; -- Con el NOT se esta negando. Osea los que son diferentes a male.

-- Se traen los registros que cumplen con lo del parentesis, o con lo que esta afuera del parentesis.
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE (first_name = 'Leslie';
    AND age = 44)
    OR age > 55;

-- LIKE: Me sirve para buscar en cadenas de texto.
-- %: Significa cualquier cosa. Uno o muchos caracteres.
-- _: Significa que hay un caracter.
SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE first_name LIKE 'Jer%'; -- Todos los nombres que empiecen con Jer.

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE first_name LIKE 'A%'; -- Todos los nombres que empiecen con A.

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE first_name LIKE 'A__'; -- Todos los nombres que empiezan con A y tiene dos caracteres después.

SELECT *
FROM Parks_and_Recreation.employee_demographics
WHERE birth_date LIKE '1989%'; -- Las fechas que empiezan con 1989.


-- GROUP BY: Sirve para agrugar columnas y realizar funciones de agregación.
-- Funciones de agregación en SQL. COUNT, AVG, MIN, MAX

SELECT gender, AVG(age) -- El promedio por cada género.
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender; -- Tienen que coincidir los campos relacionados en el SELECT y GROUP BY, excepto para operaciones
                    
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age) -- Todas las funciones de agregación.
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender;

-- El salario promedio por cargo.
SELECT occupation, AVG(salary)
FROM Parks_and_Recreation.employee_salary
GROUP BY occupation;

-- ORDER BY: Sirve para organizar los resultados de mi consulta.
-- Por default siempre esta en modo ascendente. De la A a la Z. Para números de menor a mayor.
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY first_name, last_name;

SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY first_name DESC; -- Se especifica que se quiere descendente.

SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY gender, age; -- Se organiza primero por genero y luego por age.

-- Se puede ordenar por posiciones de los campos en la consulta. También sirve para el GROUP BY.
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY 1, 2, 3; -- Ordenando por los campos 1, 2 y 3 de la consulta.

-- HAVING: Sirve para filtar los valores de las funciones de agregación.
-- Traer los generos que su promedio de edad sea mayor a 30.
SELECT gender, AVG(age) AS promedio_edad
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender
HAVING promedio_edad > 30;

-- Traer los cargos de manager que tienen un salario promedio mayor a 75000
SELECT occupation, AVG(salary) AS salario_promedio
FROM Parks_and_Recreation.employee_salary
WHERE occupation LIKE '%manager%' -- Cargos con la palabra manager
GROUP BY occupation -- Tiene que coincidir con los campos del SELECT
HAVING salario_promedio > 75000 -- Filtro en el HAVING;


-- LIMIT: Sirve para limitar los campos de las columnas.
SELECT *
FROM Parks_and_Recreation.employee_demographics
LIMIT 3; -- Traer los primeros registros de la tabla.

-- Traer los 3 empleados más viejos.
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY age DESC
LIMIT 3;

-- Traerme los 3 registros que estén después del registro 3.
SELECT *
FROM Parks_and_Recreation.employee_demographics
ORDER BY age DESC
LIMIT 3, 3; -- Primer número, empezar en la posición x y traerme la cantidad y de registros.

-- ALIASING (AS): Sirve para cambiar los nombres de columnas y las funciones de agregación.
-- Ejemplos arriba.

































































