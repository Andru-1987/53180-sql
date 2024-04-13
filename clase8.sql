-- LINK : https://docs.google.com/presentation/d/e/2PACX-1vSqJou9pufylVEqqweMdDvjeOQ0wVhIzlPKUL8wmrWvxhI30ywHz-T_Nh9TECAfbA/pub?start=false&loop=false&delayms=3000
-- < SQL theory> --

## Funciones Personalizadas en SQL

**¿Qué es una función personalizada?**

Una función personalizada, también llamada función definida por el usuario (UDF), es un bloque de código SQL que se puede reutilizar en diferentes consultas. Es similar a una función predefinida de SQL, pero está definida por el usuario para realizar tareas específicas.

**¿Dónde se guarda una función personalizada?**

La ubicación de las funciones personalizadas depende del sistema de gestión de bases de datos (SGBD) que se utilice:

* **MySQL:** Se guardan en el diccionario de datos de la base de datos actual.
* **SQL Server:** Se pueden almacenar en la base de datos actual o en una base de datos maestra.
* **PostgreSQL:** Se guardan en el esquema actual.

**Ventajas de las funciones personalizadas:**

* **Reutilización de código:** Permiten evitar la duplicación de código en diferentes consultas.
* **Modularidad:** Dividen el código en bloques más pequeños y fáciles de manejar.
* **Encapsulamiento:** Ocultan la complejidad de la lógica de la consulta.
* **Mejora del rendimiento:** Pueden mejorar el rendimiento al evitar la ejecución repetida de cálculos complejos.

**Sintaxis para crear y mantener funciones:**

**Creación:**

```sql
CREATE FUNCTION nombre_funcion (parametro1 tipo, parametro2 tipo, ...)
RETURNS tipo_retorno
BEGIN
    -- Cuerpo de la función
    -- Instrucciones SQL
    RETURN valor_retorno;
END;

```


nombre_funcion: Es el nombre que le das a la función.
parametro1, parametro2, ...: Son los parámetros que la función puede aceptar.
tipo: Es el tipo de datos de los parámetros y del valor de retorno.
tipo_retorno: Es el tipo de datos que devuelve la función.
valor_retorno: Es el valor que devuelve la función.

**Mantenimiento:**

* **ALTER FUNCTION:** Modifica la definición de una función existente.
* **DROP FUNCTION:** Elimina una función.

**Estructura de una función personalizada en MySQL:**

```sql
DELIMITER //

CREATE FUNCTION nombre_funcion (parámetros) RETURNS tipo_de_dato
BEGIN
    -- Declaración de variables
    -- Código de la función
    RETURN valor;
END;

//

DELIMITER ;
```

**Implementación de una función personalizada:**

```sql
DELIMITER //

CREATE FUNCTION obtener_edad (fecha_nacimiento DATE) RETURNS INT
BEGIN
    DECLARE edad INT;

    SET edad = YEAR(CURDATE()) - YEAR(fecha_nacimiento);

    RETURN edad;
END;

//

DELIMITER ;

SELECT obtener_edad('1980-01-01'); -- Devuelve 43
```

**Implementación de una función con un warning:**

```sql
DELIMITER //

CREATE FUNCTION obtener_saldo (cuenta_id INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE saldo DECIMAL(10,2);

    SELECT saldo INTO saldo
    FROM cuentas
    WHERE cuenta_id = cuenta_id;

    IF saldo IS NULL THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT 'Cuenta no encontrada';
    END IF;

    RETURN saldo;
END;

//

DELIMITER ;

SELECT obtener_saldo(123); -- Devuelve el saldo o muestra un error si la cuenta no existe
```

**Recursos adicionales:**

* MySQL Functions: [https://dev.mysql.com/doc/refman/8.0/en/functions.html](https://dev.mysql.com/doc/refman/8.0/en/functions.html)
-- <  OPCIONES  DE LAS FUNCIONES > --

## Opciones de las funciones SQL: DETERMINISTIC, NO DETERMINISTIC y READS SQL DATA

**DETERMINISTIC:**

* Indica que la función siempre devuelve el mismo resultado para los mismos valores de entrada.
* Es útil para funciones que realizan cálculos matemáticos o de comparación.
* **Ejemplo:**

```sql
CREATE FUNCTION obtener_area_cuadrado (lado INT) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN lado * lado;
END;
```

**NO DETERMINISTIC:**

* Indica que la función puede devolver diferentes resultados para los mismos valores de entrada.
* Es útil para funciones que dependen de valores externos o aleatorios.
* **Ejemplo:**

```sql
CREATE FUNCTION obtener_fecha_aleatoria () RETURNS DATE
NO DETERMINISTIC
BEGIN
    RETURN CURRENT_DATE() + INTERVAL RAND() DAY;
END;
```

**READS SQL DATA:**

* Indica que la función lee datos de la base de datos.
* Es útil para funciones que necesitan información de las tablas.
* **Ejemplo:**

```sql
CREATE FUNCTION obtener_nombre_cliente (cliente_id INT) RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE nombre VARCHAR(255);

    SELECT nombre INTO nombre
    FROM clientes
    WHERE cliente_id = cliente_id;

    RETURN nombre;
END;
```

**Consideraciones:**

* **DETERMINISTIC vs NO DETERMINISTIC:**

    * Las funciones deterministas son más eficientes y se pueden usar en expresiones WHERE y GROUP BY.
    * Las funciones no deterministas no se pueden usar en expresiones WHERE y GROUP BY.

* **READS SQL DATA:**

    * Las funciones que no leen datos de la base de datos se pueden ejecutar más rápido.
    * Las funciones que leen datos de la base de datos pueden verse afectadas por el estado de la base de datos.

**Resumen:**

* **DETERMINISTIC:** asegura el mismo resultado para los mismos valores de entrada.
* **NO DETERMINISTIC:** permite diferentes resultados para los mismos valores de entrada.
* **READS SQL DATA:** indica que la función lee datos de la base de datos.

**Elejir la opción correcta:**

* La elección de la opción adecuada depende de la lógica de la función y de cómo se va a usar.
* Se recomienda usar DETERMINISTIC siempre que sea posible.
* Se recomienda usar NO DETERMINISTIC solo cuando sea necesario.
* Se recomienda usar READS SQL DATA solo cuando la función necesite leer datos de la base de datos.



-- CLASE 15

USE clase_integridad ;

-- CREATE a FUNCTION DETERMINISTIC SIMPLE

DROP FUNCTION IF EXISTS area_circulo;

DELIMITER //
CREATE FUNCTION area_circulo (radio DECIMAL(12,2))
	RETURNS DECIMAL(16,2)
    
    COMMENT 'Esta funcion esta destinada para el area de un circulo'
    DETERMINISTIC
    BEGIN
		DECLARE VALOR_PI DECIMAL(12,2);
        SET VALOR_PI = 3.14 ;
        RETURN VALOR_PI * radio * radio;
    END//
    
DELIMITER ;



SELECT 
	area_circulo( 10 ) AS area_circular
FROM DUAL; 


SELECT 
    *
FROM
    information_schema.routines
WHERE
    routine_type = 'FUNCTION'
        AND routine_schema = 'clase_integridad';

SET GLOBAL log_bin_trust_function_creators = 1;

-- FUNCTION NOT DETERMINISTIC 
DELIMITER //
CREATE FUNCTION dame_una_fecha() RETURNS DATE
    NOT DETERMINISTIC
    BEGIN
		RETURN CURRENT_DATE() + INTERVAL RAND() DAY ;
    END//
DELIMITER ;
    
    
SELECT 
CURRENT_DATE() + INTERVAL RAND() DAY 
FROM DUAL
;



-- NO SQL Y VARIABLE
SELECT *
FROM clase_integridad.venta;


DROP FUNCTION IVA ;
-- FUNCTION NOT DETERMINISTIC  Y NO SQL
DELIMITER //
CREATE FUNCTION IVA(monto DECIMAL(12,4)) RETURNS DECIMAL(12,4)
	COMMENT 'FUNCION PARA OTORGAR EL IVA DE ACUERDO AL VALOR DEL PRODUCTO'
    NO SQL
    BEGIN
		
        DECLARE IVA_COMUN 	DECIMAL(3,2);
        DECLARE IVA_1_15	DECIMAL(3,2);
		
        SET IVA_COMUN 	= 	1.21;
        SET IVA_1_15	= 	1.15;
    
    
		IF monto BETWEEN 0 AND 46 THEN 
			RETURN monto * IVA_COMUN; 
		ELSEIF monto BETWEEN 47 AND 59 THEN
			RETURN monto * IVA_1_15 ;
		ELSE
			SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT  = 'SUPERA EL VALOR MAXIMO', MYSQL_ERRNO = 1000;
            RETURN NULL;
		END IF;
   
    END//
DELIMITER ;


SELECT 
	v.*
,	IVA(v.monto_total) AS IVA
FROM clase_integridad.venta AS v ;






DROP FUNCTION IF EXISTS ponderacion_total ;
-- FUNCTION READS SQL DATA

DELIMITER //
CREATE FUNCTION ponderacion_total(monto_parcial DECIMAL(12,4)) RETURNS VARCHAR(50)
	COMMENT 'FUNCTION QUE ME OTORGA EL PORCENTAJE PONDERADO DE CADA VENTA'
    READS SQL DATA
    BEGIN
		
        DECLARE TOTAL_VENTA 	DECIMAL(12,2);
        DECLARE monto_ponderado DECIMAL(12,2);
        
		SELECT 
			SUM(monto_total) INTO TOTAL_VENTA
        FROM clase_integridad.venta;
        
        
		SET monto_ponderado = (monto_parcial * 100 ) / TOTAL_VENTA ;
        
		RETURN CONCAT( monto_ponderado ," %");
   
    END//
DELIMITER ;



SELECT 
	v.*
,	IVA(v.monto_total) AS IVA
,	ponderacion_total(v.monto_total) AS  `ponderacion del total`
FROM clase_integridad.venta AS v ;


-- CREAR UNA FUNCION QUE AL PASAR EL ID NOS RETORNE EL NOMBRE DEL JUEGO

USE coderhouse_gamers ;


DROP FUNCTION IF EXISTS get_game; 

DELIMITER //
CREATE FUNCTION get_name (id INT) RETURNS VARCHAR(100)
	COMMENT 'Funcion dedicada a retornar el nombre del juego'
	READS SQL DATA
BEGIN
	DECLARE name_return VARCHAR(100) ;

	SELECT name INTO name_return
    FROM coderhouse_gamers.GAME
	WHERE id_game = id 
    LIMIT 1
    ;
	
    RETURN name_return ;

END//
DELIMITER ;


SELECT get_name(id_game) AS nombre_juego
FROM GAME;


-- STORED PROCEDURES

## Procedimientos Almacenados: Conceptos Generales

**¿Qué son?**

Los procedimientos almacenados (SP) son programas compilados y almacenados en la base de datos. Permiten ejecutar una secuencia de instrucciones SQL como una sola unidad.

**Beneficios:**

* **Modularidad:** Agrupan lógica compleja en unidades reutilizables.
* **Rendimiento:** Se ejecutan en el servidor, evitando el envío de código SQL desde el cliente.
* **Seguridad:** Se pueden controlar los permisos de acceso al código.
* **Mantenimiento:** Facilitan la gestión y actualización del código.

**Sintaxis:**

```sql
CREATE PROCEDURE nombre_sp
(
    parámetros_de_entrada,
    parámetros_de_salida
)
AS
BEGIN
    -- Instrucciones SQL
END;
```

**Ejecución:**

* `EXEC nombre_sp` (sin parámetros)
* `EXEC nombre_sp @parámetro1, @parámetro2` (con parámetros)

## Implementación

**Preparación de Statements:**

```sql
CREATE PROCEDURE generar_prepare_statement
AS
BEGIN
    DECLARE @sql nvarchar(max);
    DECLARE @stmt int;

    -- Construye la consulta SQL
    SET @sql = 'SELECT * FROM tabla WHERE columna = @valor';

    -- Prepara la consulta
    EXEC sp_prepare @stmt, @sql, @params;

    -- Ejecuta la consulta
    EXEC @stmt;

    -- Libera la memoria
    EXEC sp_unprepare @stmt;
END;
```

## Ejemplos de Procedimientos Almacenados

**Básico:**

```sql
CREATE PROCEDURE obtener_fecha_actual
AS
BEGIN
    SELECT GETDATE();
END;
```

**Con Parámetro de Entrada:**

```sql
CREATE PROCEDURE obtener_cliente
(
    @id_cliente int
)
AS
BEGIN
    SELECT * FROM clientes WHERE id_cliente = @id_cliente;
END;
```

**Con Parámetro de Salida:**

```sql
CREATE PROCEDURE calcular_impuesto
(
    @precio float,
    @impuesto float OUT
)
AS
BEGIN
    SET @impuesto = @precio * 0.21;
END;
```

**Con Parámetros de Entrada y Salida:**

```sql
CREATE PROCEDURE actualizar_cliente
(
    @id_cliente int,
    @nombre nvarchar(50),
    @telefono nvarchar(15)
)
AS
BEGIN
    UPDATE clientes
    SET nombre = @nombre,
        telefono = @telefono
    WHERE id_cliente = @id_cliente;

    SELECT @nombre AS nombre_actualizado;
END;
```

CREATE DATABASE IF NOT EXISTS store_procedure ;
USE store_procedure ;

CREATE TABLE producto(
    id_producto INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,   nombre      VARCHAR(50)
);


DROP PROCEDURE IF EXISTS insertar_producto;

DELIMITER //

CREATE PROCEDURE insertar_producto (
  IN nombre_producto VARCHAR(50)
)
BEGIN
  DECLARE resultado INT DEFAULT 0;

  IF nombre_producto = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: no se pudo crear el producto indicado';
  ELSE
    INSERT INTO producto (nombre) VALUES (nombre_producto);
    SET resultado = ROW_COUNT();
  END IF;

  IF resultado = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: no se insertó ningún producto';
  END IF;

  SELECT * FROM producto ORDER BY id_producto DESC LIMIT 1;

END; //

DELIMITER ;


CALL insertar_producto('Producto 1');
CALL insertar_producto(''); -- ERROR: no se pudo crear el producto indicado



-- <CONTENIDO DE CLASE> -- 

USE coderhouse_gamers;


CREATE TABLE PAY (
	id		INT NOT NULL PRIMARY KEY ,
    monto	DECIMAL(12,2) ,
    fecha	DATE ,
    id_game INT
) ;




SELECT 
	*
FROM PAY;

-- QUE ME MUESTRE EL VALOR CON IVA DEL MONTO PAGADO
-- 21%  --> parametro monto IN

DROP FUNCTION IF EXISTS fn_IVA;

DELIMITER //
CREATE FUNCTION fn_IVA( precio DECIMAL(12,2) ) 
	RETURNS DECIMAL(12,4)
    DETERMINISTIC
    COMMENT "ESTA FUNCION ME RETORNA EL PRECIO CON EL IVA"
BEGIN
	RETURN precio * 1.21 ;
END//

DELIMITER ;



-- FUNCTION NOT DETERMINISTIC 
DELIMITER //
CREATE FUNCTION 
		dame_una_fecha() 
    RETURNS DATE
    NOT DETERMINISTIC
    NO SQL
BEGIN
		RETURN CURRENT_DATE() + INTERVAL RAND() DAY ;
END//

DELIMITER ;



SELECT dame_una_fecha() FROM DUAL;



SELECT fn_IVA(100) AS VALOR_CON_IVA FROM DUAL;

SELECT 
	id
,	monto
,	fn_IVA(monto) AS monto_con_iva
,	fecha
FROM PAY ;



-- 


DROP FUNCTION IF EXISTS fn_IVA_FULL;

DELIMITER //
CREATE FUNCTION fn_IVA_FULL( precio DECIMAL(12,2) , id_game INT ) 
	RETURNS DECIMAL(12,4)
    DETERMINISTIC
    COMMENT "ESTA FUNCION ME RETORNA EL PRECIO CON EL IVA"
BEGIN
	IF id_game > 2 THEN
		RETURN precio * 1.105 ;
    ELSE
		RETURN precio * 1.21 ;
	END IF;
    
END//

DELIMITER //
CREATE FUNCTION condicion_IVA( id_game INT ) 
	RETURNS VARCHAR(50)
    DETERMINISTIC
    COMMENT "ESTA FUNCION ME RETORNA LA CONDICION DEL IVA"
BEGIN
	IF id_game > 2 THEN
		RETURN "IVA DEL 10.5%";
    ELSE
		RETURN "IVA DEL 21%" ;
	END IF;
    
END//
DELIMITER ;



CREATE TABLE coderhouse_gamers.IVA_ARG 
	AS
			SELECT 10.5 AS VALOR_IVA , "TECH" AS TIPO FROM DUAL
UNION ALL 	SELECT 21 AS VALOR_IVA   , "COMUN" AS TIPO FROM DUAL;


SELECT * FROM
coderhouse_gamers.IVA_ARG ;





SELECT 
	id
,	monto
,	id_game
,	fn_IVA_FULL(monto,id_game) AS monto_con_iva
,	condicion_IVA(id_game) AS condicion_iva
,	fecha
FROM PAY ;





DROP FUNCTION IF EXISTS fn_IVA_FULL_ARG;

DELIMITER //
CREATE FUNCTION fn_IVA_FULL_ARG( precio DECIMAL(12,2) , id_game INT ) 
	RETURNS DECIMAL(12,4)
    DETERMINISTIC
    READS SQL DATA
    COMMENT "ESTA FUNCION ME RETORNA EL PRECIO CON EL IVA"
BEGIN
	DECLARE iva DECIMAL(12,2) ;

	IF id_game > 2 THEN
		-- Busco el valor del iva en una tabla SQL
		SELECT 
			VALOR_IVA INTO iva
		FROM IVA_ARG
        WHERE TIPO LIKE "TECH";
    ELSE		
		SELECT 
			VALOR_IVA INTO iva
		FROM IVA_ARG
        WHERE TIPO LIKE "COMUN";
	
	END IF;

	RETURN precio *  (1 + iva/100);
END//
DELIMITER ;



SELECT 
	id
,	monto
,	id_game
,	fn_IVA_FULL_ARG(monto,id_game) AS monto_con_iva
,	condicion_IVA(id_game) AS condicion_iva
,	fecha
FROM PAY ;


CREATE TABLE coderhouse_gamers.IVA_PERU 
	AS
			SELECT 17 AS VALOR_IVA , "TECH" AS TIPO FROM DUAL
UNION ALL 	SELECT 35 AS VALOR_IVA   , "COMUN" AS TIPO FROM DUAL;


SELECT *  FROM IVA_PERU;



DROP FUNCTION IF EXISTS fn_IVA_FULL_PERU;
DELIMITER //
CREATE FUNCTION fn_IVA_FULL_PERU( precio DECIMAL(12,2) , id_game INT , tipo_iva VARCHAR(50) ) 
	RETURNS DECIMAL(12,4)
    DETERMINISTIC
    READS SQL DATA
    COMMENT "ESTA FUNCION ME RETORNA EL PRECIO CON EL IVA"
BEGIN
	DECLARE iva DECIMAL(12,2) ;
	
    IF tipo_iva != "" THEN
		CASE WHEN id_game > 2 THEN
			SELECT 
				VALOR_IVA INTO iva
			FROM IVA_PERU
			WHERE TIPO LIKE tipo_iva
			LIMIT 1;
		
			WHEN id_game < 2 THEN
			SELECT 
				VALOR_IVA INTO iva
			FROM IVA_PERU
			WHERE TIPO LIKE tipo_iva
			LIMIT 1;
		ELSE
			SET iva = 50;
		END CASE;
		
		RETURN precio *  (1 + iva/100);
        
	ELSE
		SIGNAL SQLSTATE '45000' -- '01000'
        SET MESSAGE_TEXT  = '>>> No me pasaste el tipo de iva', MYSQL_ERRNO = 1000;
    END IF;
    
    RETURN NULL ;
END//
DELIMITER ;

SELECT 
	id
,	monto
,	id_game
,	fn_IVA_FULL_PERU(monto,id_game, "") AS monto_con_iva
,	fecha
FROM PAY ;


-- <sql> 
-- params :  id_game INT
-- output: name VARCHAR
-- fn_name:  fn_get_name

DROP FUNCTION  IF EXISTS fn_get_name;

DELIMITER //
CREATE FUNCTION fn_get_name( id_game_in INT)
	RETURNS VARCHAR(100)
    READS SQL DATA
BEGIN
	DECLARE nombre_de_juego VARCHAR(100);

	IF id_game_in IS NULL THEN
		SIGNAL SQLSTATE '45000' -- '01000'
        SET MESSAGE_TEXT  = '>>> No me pasaste valor alguno', MYSQL_ERRNO = 1000;
        RETURN NULL;
    ELSEIF id_game_in = 0 THEN
    	SIGNAL SQLSTATE '45000' -- '01000'
        SET MESSAGE_TEXT  = '>>> Me pasaste un valor inexistente', MYSQL_ERRNO = 1000;
		RETURN NULL;
    ELSE
		SELECT 
			name INTO nombre_de_juego
		FROM coderhouse_gamers.GAME
		WHERE 
			id_game = id_game_in 
		LIMIT 1;
        
		RETURN nombre_de_juego ;
	END IF;
END //

DELIMITER ; 


SELECT 
	fn_get_name(id_game)  AS nombre_de_juego
,	monto
,	fecha
FROM PAY ;


-- PROCEDURES
-- paramas : usuario_id
-- out_procedure_steps : 
	-- buscar usuario 	
    -- SI -> Traeme la data
    -- NO -> SALIR SP
    -- Traer cantidad de registros de comments
    -- Traer los comentarios de ese usuario
    
DROP PROCEDURE IF EXISTS sp_datos_system_user ;

DELIMITER //
CREATE PROCEDURE sp_datos_system_user( IN id_user INT)
BEGIN

	DECLARE exists_user INT DEFAULT 0;

	SELECT COUNT(1) INTO exists_user
    FROM SYSTEM_USER
    WHERE id_system_user = id_user; 

    IF exists_user = 0 THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT  = '>>> No existe este usuario', MYSQL_ERRNO = 1000;
	ELSE
		-- SI TIENE MAS DE 2 COMENTARIOS ME TRAIGA LOS COMENTARIOS SI NO -> UN TEXTO QUE DIGA NO TIENE 
        -- MAS DE 2 COMENTARIOS
		SET @cantidad_comentarios = 0 ;
		
		SELECT 
			COUNT(1) AS cantidad_comentarios INTO @cantidad_comentarios
        FROM COMMENTARY
        WHERE id_system_user = id_user
        GROUP BY id_system_user
        ;
        
        IF @cantidad_comentarios > 2 THEN
			SELECT 
				id_system_user
			,	commentary
			FROM COMMENTARY
			WHERE id_system_user = id_user;
        ELSE
			SELECT "No tiene mas de 2 comentarios hechos" AS  MSG;
		END IF;
    END IF;
    
END//
DELIMITER ; 

-- T-SQL | PLSQL


CALL sp_datos_system_user(175) ;


DROP PROCEDURE IF EXISTS sp_order_by;
DELIMITER //
CREATE PROCEDURE sp_order_by ( IN column_order VARCHAR(100))
BEGIN
	SET @query_stmt = "SELECT * FROM GAME";
    IF column_order = "" THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT  = '>>> No puedo ordenarlo de acuerdo a lo pedido', MYSQL_ERRNO = 1000;
    ELSE
		SET @query_stmt = CONCAT(@query_stmt , " ORDER BY ",column_order , " DESC" ) ;
		SELECT @query_stmt FROM DUAL;
        
        PREPARE runSQL FROM @query_stmt ;
        EXECUTE runSQL ;
        DEALLOCATE PREPARE runSQL ;
	END IF;
END//
DELIMITER ; 


CALL sp_order_by("id_class");
