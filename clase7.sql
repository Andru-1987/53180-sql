-- LINK: https://docs.google.com/presentation/d/e/2PACX-1vRbF8AHCxcEPjMykmDyz1PxpDQIm82Ri4JmxRJTMA51FutH_-YN85OISAdnvGSx_Q/pub?start=false&loop=false&delayms=3000

-- CLASE 13
-- INSERCION CON IMPORTACION


## Bases de Datos en MySQL: Importación de Archivos CSV y JSON

-- LINK OFICIAL : https://dev.mysql.com/doc/refman/8.0/en/load-data.html

### Importación de Archivos CSV y JSON en MySQL

MySQL ofrece varias opciones para importar datos desde archivos CSV y JSON. Esto es útil cuando necesitas cargar grandes cantidades de datos desde archivos externos a tu base de datos.

#### Importación de CSV

Una forma común de importar datos desde un archivo CSV a una tabla MySQL es utilizando el comando `LOAD DATA INFILE`. Este comando carga datos desde un archivo en el servidor MySQL directamente a una tabla.

Ejemplo de comando `LOAD DATA INFILE` para importar un archivo CSV:

```sql
LOAD DATA LOCAL INFILE '/ruta/al/archivo.csv' 
INTO TABLE nombre_tabla 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;
```

- `/ruta/al/archivo.csv`: Ruta al archivo CSV que quieres importar.
- `nombre_tabla`: Nombre de la tabla en la que quieres importar los datos.
- `FIELDS TERMINATED BY ','`: Especifica el delimitador de campo en el archivo CSV.
- `ENCLOSED BY '"'`: Especifica el carácter de encerrado en caso de que los campos estén entre comillas dobles.
- `LINES TERMINATED BY '\n'`: Especifica el delimitador de línea en el archivo CSV.
- `IGNORE 1 ROWS`: Opcional, ignora la primera fila si contiene encabezados.

#### Importación de JSON

Para importar datos desde un archivo JSON a una tabla MySQL, puedes utilizar la sentencia `INSERT INTO`. Sin embargo, necesitas transformar el archivo JSON en un formato compatible con la sentencia `INSERT INTO`.

Ejemplo de inserción de datos JSON en MySQL:

```sql
INSERT INTO nombre_tabla (columna1, columna2, columna3) 
VALUES (valor1, valor2, valor3), (valor4, valor5, valor6), ...;
```

Donde `nombre_tabla` es el nombre de la tabla en la que deseas insertar los datos, y `(columna1, columna2, columna3)` son los nombres de las columnas en la tabla. `valor1`, `valor2`, `valor3`, etc., son los valores que deseas insertar en las respectivas columnas.

### Optimización de Importación en MySQL

Para optimizar la importación de datos en MySQL, especialmente al trabajar con grandes conjuntos de datos, considera las siguientes prácticas:

1. **Índices**: Si es posible, deshabilita los índices antes de la importación y vuelve a habilitarlos después. Esto puede acelerar significativamente la importación.

2. **Commit por Lotes**: En lugar de realizar un solo gran commit al final de la importación, considera realizar commits por lotes más pequeños. Esto puede mejorar la eficiencia y la tolerancia a fallos.

3. **Partitioning**: Si estás importando datos en una tabla particionada, asegúrate de que los datos estén distribuidos equitativamente entre las particiones para evitar cuellos de botella.

4. **Uso de LOAD DATA INFILE**: Utiliza la función `LOAD DATA INFILE` de MySQL en lugar de inserciones individuales cuando sea posible. Esta función es mucho más rápida para importar grandes volúmenes de datos.

### Uso de `LOAD DATA LOCAL INFILE`

La opción `LOCAL` de `LOAD DATA INFILE` permite cargar archivos desde el cliente MySQL en lugar del servidor. Esto puede ser útil cuando el servidor MySQL no tiene acceso directo al archivo que deseas importar.

Es importante tener en cuenta que el uso de `LOAD DATA LOCAL INFILE` puede plantear problemas de seguridad si no se configura adecuadamente. Asegúrate de que solo los usuarios autorizados tengan permiso para cargar archivos locales y que el servidor MySQL esté configurado para permitir esta operación de forma segura.

---

>> Creacion de tablas
>> STEPS 
- creacion de la base de datos y su estructura
- creacion de datasets
- modificacion de manera grafica tales como google sheets (con datos de duenos)


--  recormendaciones : siempre empezar con las tablas dimensionales que no tienen dependencias de FK's
--  ultimo levantar las tablas de hechos
--  The error message you encountered, ERROR 3948 (42000): Loading local data is disabled; this must be enabled on both the client and server sides, indicates that the MySQL server has disabled the ability to load data from local files. This security feature is enabled by default to prevent unauthorized access and potential security risks.

-- Enable local_infile on the Client Side (Your Machine):

-- When running the mysql command to connect to the MySQL server, you need to include the --local-infile=1 option to enable local file loading:


mysql -u username -p --local-infile=1

SET GLOBAL local_infile = true;
-- verificar que este activado desde server y client side
SHOW GLOBAL VARIABLES LIKE 'local_infile';



LOAD    DATA LOCAL INFILE './clientes.json'
        INTO TABLE CLIENTE 
            -- FIELDS TERMINATED   BY ',' 
            -- LINES TERMINATED    BY '\n' 
            (@json)   
            SET 
            IDCLIENTE = JSON_EXTRACT(@json, '$.IDCLIENTE'),
            NOMBRE = JSON_EXTRACT(@json, '$.NOMBRE'),
            TELEFONO = JSON_EXTRACT(@json, '$.TELEFONO'),
            CORREO = JSON_EXTRACT(@json, '$.CORREO');


LOAD    DATA LOCAL INFILE './clientes.csv'
        INTO TABLE CLIENTE 
            FIELDS TERMINATED   BY ',' 
            LINES TERMINATED    BY '\n' 
            IGNORE 1 ROWS


**Título de la Clase: Fundamentos de Bases de Datos y MySQL**

**Introducción:**
En el mundo de las bases de datos, MySQL es una de las opciones más populares y poderosas para gestionar grandes conjuntos de datos. Uno de los aspectos fundamentales de cualquier base de datos es mantener la integridad de los datos almacenados. En esta clase, exploraremos cómo MySQL aborda este desafío, centrándonos en la integridad referencial, las restricciones y las acciones en cascada.

**1. Integridad Referencial en MySQL:**

   - **Concepto de Integridad Referencial:** La integridad referencial es la garantía de que las relaciones entre las tablas de una base de datos se mantengan consistentes.
   
   - **Implementación en MySQL:** MySQL ofrece soporte completo para la integridad referencial mediante el uso de claves foráneas y restricciones.

**2. Tipos de Integridad:**

   - **Integridad Débil:** Se refiere a la garantía de que no habrá valores nulos en una relación entre tablas.
   
   - **Integridad Parcial y Completada:** La integridad parcial se refiere a garantizar la consistencia de datos en una parte específica de la base de datos, mientras que la completada asegura la consistencia en toda la base de datos.

**3. Restricciones en MySQL:**

   - **Restricción de Unicidad:** Garantiza que no haya valores duplicados en una columna específica.
   
   - **Restricción de Valor No Nulo:** Obliga a que una columna no pueda tener valores nulos.
   
   - **Restricción de Clave Primaria:** Define una columna o conjunto de columnas como clave primaria, asegurando unicidad e integridad referencial.
   
   - **Restricción de Integridad Referencial:** Define relaciones entre tablas para mantener la integridad de los datos.

**4. Acciones en Cascada:**

   - **CASCADE:** Cuando se realiza una acción (eliminar o actualizar) en una fila de una tabla, las acciones en cascada propagan esa acción a las filas relacionadas en otras tablas.
   
   - **SET NULL:** Establece los valores de las columnas relacionadas en NULL cuando se realiza una acción en cascada.
   
   - **NO ACTION y RESTRICT:** Impiden la eliminación o actualización de filas en una tabla si existen restricciones de integridad referencial que podrían violarse.

**Conclusión:**
MySQL proporciona una variedad de herramientas para garantizar la integridad de los datos almacenados en una base de datos. Comprender cómo se implementan las restricciones y las acciones en cascada es fundamental para diseñar bases de datos eficientes y fiables. En esta clase, hemos explorado los fundamentos de la integridad referencial, los tipos de integridad, las restricciones y las acciones en cascada en MySQL, sentando las bases para un diseño robusto de bases de datos relacionales.





DROP DATABASE IF EXISTS clase_integridad;
CREATE DATABASE clase_integridad;
USE clase_integridad;


CREATE TABLE producto (
	id_producto INT	NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100)
);


CREATE TABLE categoria (
	categoria INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE cliente (
	id_cliente INT	NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    categoria INT
);

ALTER TABLE cliente
	ADD CONSTRAINT __fk_cliente_categoria
	FOREIGN KEY (categoria) REFERENCES categoria(categoria)
		ON DELETE CASCADE
    ;
    
ALTER TABLE cliente
	DROP FOREIGN KEY __fk_cliente_categoria
    ;

ALTER TABLE cliente
	ADD CONSTRAINT __fk_cliente_categoria
	FOREIGN KEY (categoria) REFERENCES categoria(categoria)
		ON DELETE NO ACTION
    ;


CREATE TABLE venta(
	id_venta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT ,
    id_producto INT ,
    monto_total DECIMAL(12,2) DEFAULT 10.00,
    
    FOREIGN KEY (id_cliente) REFERENCES  cliente(id_cliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
        
	FOREIGN KEY (id_producto) REFERENCES  producto(id_producto)
		ON UPDATE SET NULL
        ON DELETE SET NULL
);



-- Inserting records into the 'producto' table
INSERT INTO producto (nombre_producto) VALUES 
('Producto A'),
('Producto B'),
('Producto C'),
('Producto D');

-- Inserting records into the 'categoria' table
INSERT INTO categoria (nombre) VALUES 
('Categoria 1'),
('Categoria 2'),
('Categoria 3'),
('Categoria 4');

-- Inserting records into the 'cliente' table
INSERT INTO cliente (nombre_cliente, categoria) VALUES 
('Cliente 1', 1),
('Cliente 2', 1),
('Cliente 3', 2),
('Cliente 4', 2);

-- Inserting records into the 'venta' table
INSERT INTO venta 
	(id_cliente, id_producto, monto_total) 
VALUES 
	(1, 1, 50.00),
	(1, 2, 30.00),
	(1, 3, 45.00),
	(4, 4, 60.00);

-- <SQL para validar> --

SELECT 
*
FROM venta;

SELECT 
* 
FROM producto ;


SELECT
*
FROM cliente;

UPDATE producto
	SET id_producto = 10
    WHERE id_producto = 3;

DELETE FROM producto
	WHERE id_producto = 4;


UPDATE cliente
	SET id_cliente = 10
    WHERE id_cliente = 3;

DELETE FROM cliente
	WHERE id_cliente = 1;


DELETE FROM categoria
	WHERE categoria = 1; 
    
    
    
    
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME
       FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
       WHERE TRUE
       AND TABLE_SCHEMA LIKE 'clase_integridad'
       AND REFERENCED_TABLE_SCHEMA IS NOT NULL;


-- <SQL PRACTICA> --

DROP DATABASE IF EXISTS sample_clase_14;
CREATE DATABASE sample_clase_14;
USE sample_clase_14;


-- Creamos la tabla "pais"
CREATE TABLE pais (
    id INT PRIMARY KEY ,
    nombre VARCHAR(100)
);


-- Insertamos algunos países de ejemplo
INSERT INTO pais (id, nombre) VALUES
(1, 'Estados Unidos'),
(2, 'Canadá'),
(3, 'México');

-- Creamos la tabla "ciudad" que referencia a la tabla "pais"
CREATE TABLE ciudad (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    pais_id INT DEFAULT 100,
    CONSTRAINT __fk_ciudad_pais FOREIGN KEY (pais_id) REFERENCES pais(id)
        ON DELETE SET NULL
        ON UPDATE SET NULL
) AUTO_INCREMENT = 100;


-- Insertamos algunas ciudades de ejemplo
INSERT INTO ciudad ( nombre, pais_id) VALUES
( 'Nueva York', 1),
( 'Toronto', 2),
( 'Ciudad de México', 3);

-- Creamos la tabla "ciudadanos" que referencia a la tabla "ciudad"
CREATE TABLE ciudadanos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    ciudad_id INT DEFAULT 100,
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(id)
         ON DELETE CASCADE
        -- ON UPDATE SET DEFAULT
         ON UPDATE SET NULL
);

-- Insertamos algunos ciudadanos de ejemplo
INSERT INTO ciudadanos (id, nombre, ciudad_id) VALUES
(1, 'John Smith', 100),
(2, 'Alice Johnson', 101),
(4, 'Luis Rey',102),
(6, 'Marcelle Tolvards',101),
(3, 'Juan García', 102);



SELECT * 
FROM ciudadanos ;

SELECT * 
FROM ciudad ;

SELECT * 
FROM pais ;


DELETE FROM pais
	WHERE id = 1;

DELETE FROM ciudad
	WHERE id = 102;
