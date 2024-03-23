-- Clase SQL


-- LINK  : https://www.prisma.io/dataguide/mysql/inserting-and-modifying-data/inserting-and-deleting-data
-- INFORMACION OFICIAL : 
-- INSERT >> https://dev.mysql.com/doc/refman/8.0/en/insert.html
-- UPDATE >> https://dev.mysql.com/doc/refman/8.0/en/update.html
-- DELETE >> https://dev.mysql.com/doc/refman/8.0/en/delete.html


1. **SELECT**: 
Si bien esta dentro de la definicion de DML >> es considerado mas como parte del DQL (Data query language)

   ```sql
   SELECT * FROM empleados WHERE departamento = 'Ventas';
   ```

2. **INSERT**:
   ```sql
   INSERT INTO clientes (nombre, correo) VALUES ('Juan Pérez', 'juan@example.com');
   ```

3. **UPDATE**:
   ```sql
   UPDATE productos SET precio = 25.99 WHERE id = 123;
   ```

4. **DELETE**:
   ```sql
   DELETE FROM pedidos WHERE estado = 'cancelado';
   ```

5. **MERGE**:  
--  Tambien es parte del sublenguaje, sin embargo no es de uso comun en MySQL 
--  UPSERT es algo comunmente usado en PosgreSQL 
--  ON UPDATE >> https://www.mysqltutorial.org/mysql-basics/mysql-insert-or-update-on-duplicate-key-update/
   MySQL no tiene un comando MERGE incorporado, pero se puede lograr utilizando combinaciones de INSERT y UPDATE.

   Ejemplo de combinación de INSERT y UPDATE para MySQL:
   ```sql
   INSERT INTO ventas (producto_id, cantidad)
   SELECT source.producto_id, source.cantidad
   FROM nuevos_datos AS source
   LEFT JOIN ventas AS target 
    ON source.producto_id = target.producto_id
    ON DUPLICATE KEY UPDATE cantidad = source.cantidad;
   ```
   En este ejemplo, los nuevos datos se insertan en la tabla "ventas", y si hay una clave duplicada (en este caso, "producto_id"), se actualiza la cantidad en lugar de insertar un nuevo registro.

Estos son los mismos ejemplos adaptados para MySQL, que es una implementación común de SQL en entornos de bases de datos.


-- IE 

CREATE DATABASE CLASE11;
USE CLASE11;


CREATE TABLE empleado (
    id_empleado INT NOT NULL AUTO_INCREMENT ,
    nombre VARCHAR(60) DEFAULT 'EMPLEADO SIN NOMBRE',
    status_empleado BOOLEAN DEFAULT TRUE,
    salario DECIMAL(10,2) DEFAULT 6500000.00,
    fecha_alta DATE DEFAULT (CURRENT_DATE),
    observacion TEXT ,

    -- PRIMARY KEY

    PRIMARY KEY(id_empleado)
);


SELECT
    *
FROM CLASE11.empleado;

-- INSERT RECORDS
    -- INSERCION FULL COLUMNAS
INSERT  INTO
        CLASE11.empleado
        VALUES
        (1,'MANUEL',TRUE,185000.10,'2024-02-27','me falto darlo de alta');
        
INSERT  INTO
        CLASE11.empleado (id_empleado, nombre,status_empleado,salario,fecha_alta)
        VALUES
        (2,'LUCIANO',NULL,DEFAULT,'2024-02-27');

INSERT  INTO
        CLASE11.empleado (id_empleado, nombre,status_empleado,fecha_alta,salario)
        VALUES
        (NULL,'LUCIANO',DEFAULT,'2024-02-27',DEFAULT);
        
-- INSERCION PARCIAL

INSERT  INTO
        CLASE11.empleado (observacion)
        VALUES
        ('todos los campos tienen valor por default');


INSERT INTO 
    CLASE11.empleado 
    (nombre, status_empleado, salario, observacion) 
    VALUES 
('Bayard', true, 442305.49, 'KT1MXGz2GPDNqULx7tBSQQ1X81yMnoxaWYyH'),
('Tracy', false, 175175.56, 'KT1HhhbaUU8ZVthBJJGEVSMqEDpApqFbevuT'),
('Iseabal', true, 754585.25, 'KT1KGGNQxgV3yzJMY2VUPa4CimZXpVSriCK7'),
('Son', false, 592234.15, 'KT1AxkQGDGY9e4BCKjCZ9PmSebhZdSTee3MR'),
('Drucill', false, 256500.1, 'KT1SbfZVs3M1M8TCxnPrEBPKLff9avyBd9tY'),
('Samantha', false, 917732.22,  'KT1D2xaP5cD2aeoFcmCqyUskddSdqQWMiBMT'),
('Zorine', true, 876629.21,  'KT1RXjKGhnfjUh5ZQ8766RxdJFu6pgEd2JQM'),
('Dominique', false, 530584.93, 'KT1DroXCRqZPyd2TqVJP8SkdmcF8Ccet1MPJ'),
('Danita', false, 108934.04,  'KT1X3FANyjsM2ArDq8TqMB88tvBbQgrb58vo'),
('Nealy', false, 444861.13,  'KT1TS45vAQDq9vJkJfZPZJMPK5FC6DxJYZ1o'),
('Hazel', null, 854803.29,  'KT1JPdBT7wrnebvgQrPzEaTU6KYtWYjeo9b3');

-- UPDATE RECORDS

SET SQL_SAFE_UPDATES = 0; -- PERMITIR QUE SE PUEDA HACER ESTAS UPDATES DE MANERA MASIVA SIN TENER EL SAFE DE MYSQL

UPDATE CLASE11.empleado
    SET status_empleado = FALSE;

    -- ACTUALIZADO UNICO
    -- ACTUALIZADO MASIVO

UPDATE CLASE11.empleado
    SET 
        status_empleado =   1
    ,   fecha_alta      =   '1987-10-10'
WHERE 
    nombre LIKE 'D%';


-- ejemplo de la filmina : 
-- Si deseamos actualizar los niveles de las clases de juegos,
-- pasar a nivel 8 todas las clases que están entre la 1 y la 20 inclusive  
-- y cuyos niveles actuales están por debajo del 13

SELECT
 *
FROM coderhouse_gamers.GAME
WHERE TRUE
    AND id_class BETWEEN 1  AND 20
    AND id_level < 13
;


-- ¿Cuántos registros se actualizarían y Cuál sería la cláusula UPDATE?

SELECT * 
FROM coderhouse_gamers.GAME
WHERE id_game IN (55,57,8,93,23);

-- EN UN PRINCIPIO NO SE PODRIA POR UN TEMA DE INTEGRIDAD 
-- REFERENCIAL

UPDATE coderhouse_gamers.GAME
    SET id_level = 8
WHERE   TRUE
        AND id_class BETWEEN 1 AND 20
        AND id_level < 13 ; 

-- DESABILITANDO LA OPCION DE INTEGRIDAD

SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;

-- AL CORRER NUEVAMENTE LA QUERY SE ACTUALIZARA UNA CANTIDAD DETERMINADA

-- DELETE | LOGICAL DELETE
DELETE FROM coderhouse_gamers.GAME;
SELECT  * FROM   coderhouse_gamers.GAME;


DELETE FROM CLASE11.empleado
    WHERE   TRUE
            AND status_empleado = FALSE;
        
SELECT 
    *  
FROM CLASE11.empleado;



-- Bibliografia adicional 
-- https://www.linkedin.com/pulse/sargable-vs-non-query-md-mehedi-hasan/

SARGABLE QUERIES

- Avoid using functions or calculations on indexed columns in the WHERE clause.
- Use direct comparisons when possible, instead of wrapping the column in a function.
- If we need to use a function on a column, consider creating a computed column or a function-based index, if the database system supports it.



-- SEGUNDO BLOQUE
-- SUBLENGUAJE DML2

-- Creacion de tablas en coderhouse_gamers

USE coderhouse_gamers;


CREATE 	TABLE coderhouse_gamers.COMMENT_STAGING
		LIKE coderhouse_gamers.COMMENT;

ALTER 	TABLE coderhouse_gamers.COMMENT_STAGING 
		ADD COLUMN DEVICE VARCHAR(50) DEFAULT "MOBILE";

INSERT 	INTO coderhouse_gamers.COMMENT_STAGING
		VALUES
		(24,1001, '2020-10-10', '2024-10-10' , DEFAULT ),
		(21,2000, '2021-10-05', '2024-02-02' , "DESKTOP"),
		(20,49, '2020-01-01', '2024-04-04' , NULL );

	
SELECT 
	* 
FROM coderhouse_gamers.COMMENT_STAGING;
	
-- <CUSTOMER SERVICE: INDGESTA A LA TABLA COMMENT SOLAMENTE LOS REGISTRO DE MOBILE> -- 


INSERT INTO COMMENT 
	(
	
	SELECT 
		id_game 
	,	id_system_user 
	,	first_date 
	,	last_date 
	FROM coderhouse_gamers.COMMENT_STAGING AS CS
	
	WHERE EXISTS (
	
		SELECT 
			DISTINCT 
			id_system_user
		FROM coderhouse_gamers.SYSTEM_USER AS SU
		WHERE CS.id_system_user =  SU.id_system_user
		
		) 

	AND CS.DEVICE LIKE "MOBILE"
	)
	;
			


-- UPDATE WITH SUBQUERY

UPDATE 	COMMENT_STAGING AS CS
		SET id_system_user = 10

WHERE NOT EXISTS (
	SELECT 
		DISTINCT 
		id_system_user
	FROM coderhouse_gamers.SYSTEM_USER AS SU
	WHERE CS.id_system_user =  SU.id_system_user
);


DELETE FROM COMMENT_STAGING AS CS
WHERE EXISTS 
(	SELECT 
		id_game 
	,	id_system_user 
	FROM coderhouse_gamers.COMMENT AS C

	WHERE (CS.id_game = C.id_game AND CS.id_system_user = C.id_system_user)	
);


-- <DESDE LAS FILMINAS> --
	
SELECT 
	* 
FROM coderhouse_gamers.CLASS
ORDER BY id_class DESC
LIMIT 10;

-- -- 

SELECT 
	*
FROM coderhouse_gamers.LEVEL_GAME
ORDER BY id_level DESC
LIMIT 10 ;

-- <CREAR NEW_CLASS_TABLE STRUCTURE> --

CREATE 	TABLE coderhouse_gamers.CLASS_NEW 
		LIKE coderhouse_gamers.CLASS;  

	
CREATE 	TABLE coderhouse_gamers.LEVEL_GAME_NEW 
		LIKE coderhouse_gamers.LEVEL_GAME;  
	

ALTER TABLE coderhouse_gamers.CLASS_NEW 
		MODIFY COLUMN description VARCHAR(100) ;

SELECT 
*
FROM coderhouse_gamers.CLASS_NEW ;


-- INSERTION OF RECORDS

INSERT INTO coderhouse_gamers.CLASS_NEW 
	VALUES
	(17,10,'ADVENTURE TIME'),
	(15,1, NULL),
	(17,20,'LOCALLY TIME DATA'),
	(17,30,'DATA STORY TIME'),
	(14,1,NULL),
	(18,1,'NO DATA');



-- COALSCE

SELECT 
	id_level
,	id_class
,	COALESCE(description,"NOP DESCRIPTION") AS description
FROM coderhouse_gamers.CLASS_NEW;


INSERT 	INTO coderhouse_gamers.LEVEL_GAME_NEW
	(
		SELECT
			DISTINCT 
				id_level
			,	'new level element'
		FROM coderhouse_gamers.CLASS_NEW AS CN
		WHERE NOT EXISTS 
			(
				SELECT id_level
				FROM coderhouse_gamers.LEVEL_GAME LG
				WHERE CN.id_level = LG.id_level
			)
		);

-- <VERIFICAMOS LA CREACION DE DADOS REGISTROS>--
SELECT 	*
FROM coderhouse_gamers.LEVEL_GAME_NEW;


-- <CREACION DE TABLAS CON EL COMANDO CREATE TABLE> --

CREATE TABLE coderhouse_gamers.USERS_COMPANY_SPOTIFY
(
	SELECT
		first_name 	AS nombre
	,	last_name	AS apellido
	,	email		AS correo_electronico
	,	COALESCE(password ,'NOT PASSWORD') AS clave
	,	TRUE 		AS status
	FROM coderhouse_gamers.SYSTEM_USER
	WHERE email LIKE '%spotify%'
);


SELECT 
	'pepe'  AS nombre
,	COALESCE(NULL,0) AS hijos
FROM DUAL;






/*

CREAMOS UNA NUEVA TABLA DE JUEGO DENOMINADA ADVERGAME
DONDE AGREGAREMOS JUEGOS DE PROPAGANDA DE EMPRESA

CREAREMOS 5 JUEGOS NUEVOS EN LA TABLA ADVERGAME

INSERTAREMOS REGITROS CORRESPONDIENTES EN LA TABLA ADVERCLASS 
OBTENIENDO MEDIANTE 
UNA SUBCONSULTA LOS ID DE LAS CLASE Y NIVELES NUEVO INSERTADOS
*/

DROP TABLE ADVERGAME; 


CREATE TABLE ADVERGAME
	AS
		SELECT
			*
		FROM 
		coderhouse_gamers.GAME
		LIMIT 5;



INSERT INTO  ADVERGAME 
	(
	SELECT 
		*	
	FROM coderhouse_gamers.GAME 
	LIMIT 5
	) ;
	

SELECT 
*
FROM coderhouse_gamers.ADVERGAME;

RENAME TABLE CLASS_NEW TO ADVERCLASS;


INSERT INTO ADVERCLASS
	(SELECT
		id_level 
	,	id_class 
	,	'NEW DESCRIPTION'
	FROM coderhouse_gamers.ADVERGAME
	);



SELECT 
	*
FROM coderhouse_gamers.ADVERCLASS;




