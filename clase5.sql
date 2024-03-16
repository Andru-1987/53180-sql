-- LINK : https://docs.google.com/presentation/d/e/2PACX-1vRM7eJSu1SeIUob8SlT42r-9OQYrUIv7wM7ZJtSZOezVil62OdzpmZYtIhxt_oaZg/pub?start=false&loop=false&delayms=3000
-- UNA VISTA EN SQL ALMACENA UNA QUERY

-- UNA VISTA ALMACENADA ALMACENA UNA QUERY JUNTO A LA DATA

-- LINK https://sqlearning.com/es/elementos-avanzados/view/

-- LINK VIEW https://dev.mysql.com/doc/refman/8.0/en/create-view.html


-- TEORIA ADICIONAL
-- Las vistas en MySQL son consultas almacenadas que se comportan como tablas virtuales. Esto significa que puedes crear una vista que represente una consulta compleja o comúnmente utilizada, y luego consultarla como si fuera una tabla real en tu base de datos. Las vistas proporcionan una capa de abstracción sobre los datos subyacentes, lo que facilita el acceso y la manipulación de los datos.

-- Aquí tienes un ejemplo de cómo crear y utilizar una vista en MySQL:

-- Supongamos que tenemos una base de datos que almacena información sobre empleados, con una tabla llamada `empleados` que tiene las siguientes columnas: `id`, `nombre`, `apellido`, `puesto` y `salario`.

-- Primero, crearemos una vista que muestre los nombres y apellidos de los empleados junto con sus puestos:

-- ```sql
-- CREATE VIEW vista_empleados AS
-- SELECT nombre, apellido, puesto
-- FROM empleados;
-- ```

-- Ahora que hemos creado la vista, podemos consultarla como si fuera una tabla:

-- ```sql
-- SELECT * FROM vista_empleados;
-- ```

-- Esta consulta devolverá los nombres, apellidos y puestos de todos los empleados en la base de datos, pero detrás de escena, MySQL estará ejecutando la consulta definida en la vista.

-- Las vistas son especialmente útiles cuando necesitas acceder a datos complejos o realizar operaciones repetitivas en tu base de datos. Además, proporcionan una capa de seguridad adicional al limitar el acceso directo a las tablas subyacentes y permitir un control más fino sobre quién puede ver qué datos.



-- Ejemplos
--     Creacion de vista
--     Actualizacion de una vista
--     Eliminacion de una vista



-- Un poco de ptractica

    -- Muestre first_name y last_name de los usuarios que tengan mail 'webnode.com'
    SELECT 
            first_name
        ,   last_name
--      ,   email
        FROM coderhouse_gamers.SYSTEM_USER
    WHERE email LIKE '%webnode.com' ; 

    -- Muestre todos los datos de los juegos que han finalizado, los usuarios con email de 'myspace'.


    SELECT 
       G.*
    FROM coderhouse_gamers.PLAY AS P
    RIGHT JOIN coderhouse_gamers.SYSTEM_USER AS SU
        ON P.id_system_user = SU.id_system_user
    RIGHT JOIN coderhouse_gamers.GAME AS G
        ON G.id_game = P.id_game
    WHERE TRUE
    AND P.completed = 1
    AND SU.email LIKE '%@myspace.com';


    -- Muestre los distintos juegos que tuvieron una votación mayor a 9.


    SELECT  
        name
    FROM coderhouse_gamers.GAME
    WHERE id_game IN
        (
            SELECT 
            DISTINCT id_game
            FROM coderhouse_gamers.VOTE
            WHERE
                value > 9
        )
    ;


    -- Muestre nombre, apellido y mail de los usuarios que juegan al juego FIFA 22.

        -- <JOINS VERSION> -- 
            SELECT 
                SU.first_name AS nombre,
                SU.last_name AS apellido,
                SU.email AS mail
            FROM coderhouse_gamers.SYSTEM_USER AS SU
            JOIN coderhouse_gamers.PLAY AS P 
                ON SU.id_system_user = P.id_system_user
            JOIN coderhouse_gamers.GAME AS G 
                ON P.id_game = G.id_game
            WHERE G.name LIKE '%FIFA 22%';

        -- <SUBQUERY VERSION> -- 
            SELECT 
                SU.first_name   AS  nombre
            ,   SU.last_name    AS  apellido
            ,   SU.email        AS  mail
            FROM coderhouse_gamers.SYSTEM_USER AS SU
            WHERE id_system_user IN
                (
                SELECT 
                    id_system_user
                FROM coderhouse_gamers.PLAY AS P
                WHERE EXISTS
                    (SELECT 
                        id_game
                    FROM coderhouse_gamers.GAME AS G
                    WHERE G.id_game = P.id_game
                    AND G.name like '%FIFA 22%'));


-- PARA  VERIFICAR LA PERFORMANCIA

    -- SET profiling = 1;
    -- SHOW PROFILES;
    -- SHOW PROFILE FOR QUERY <Query_ID>;




 -- LENGUAJE SQL 
/*
    SELECT 
        -- COLUMNAS QUE QUERRAMOS QUE NOS TRAIGA LA CONSULTA DE 
        -- LAS TABLAS COMPUESTA POR ESTE FROM
        -- < COLS | * | EXCLUDE() > --
    FROM <SCHEMA.TABLE>
    -- FILTROS SOBRE ESTE RESULTADO
    WHERE
     ... <CONDICIONES>
    -- OPCIONES | CONTEXTO
    ORDER BY COLS...
    LIMIT N_RECORDS
*/
    
-- NO OPTIMIZADO
SELECT 
    *
FROM coderhouse_gamers.COMMENT 
WHERE
    YEAR(first_date) >  2014 
ORDER BY first_date   DESC 
;

-- OPTIMIAZDO

SELECT 
    *
FROM coderhouse_gamers.COMMENT 
WHERE
    first_date  >  '2014-01-01' 
ORDER BY first_date   DESC 
;



-- Repaso de JOINS
-- subqueries
-- -- Bibliografia adicional 
-- https://www.linkedin.com/pulse/sargable-vs-non-query-md-mehedi-hasan/





/*
SARGABLE QUERIES
SARGABLE = SEARCH ARGUMENT ABLE
- Avoid using functions or calculations on indexed columns in the WHERE clause.
- Use direct comparisons when possible, instead of wrapping the column in a function.
- If we need to use a function on a column, consider creating a computed column or a function-based index, if the database system supports it.
*/


-- JOINS

SELECT 
    *
FROM coderhouse_gamers.VOTE --  TABLA DE HECHOS ?
ORDER BY id_game
LIMIT 10 ;



SELECT
    *
FROM coderhouse_gamers.GAME
ORDER BY  name
LIMIT 10; 


-- AREA MARKETING
-- LOS JUEGOS CON SUS VOTACIONES EN EL RANGO A 6-9

SELECT 
    
    G.name AS nombre_juego
,   V.value AS valor_votacion
-- ,   V.id_system_user
,   US.email AS usuario_votante
,   CONCAT(     "Hola usuario: "
            ,   US.first_name
            ,   "ya hemos hecho cambios, podrias probarlo nuevamente y cambiarias tu votacion de "
            ,   V.value
            ,   " a otro mejor?") AS mensaje_a_enviar

FROM    coderhouse_gamers.VOTE  AS V    -- LEFT
JOIN    coderhouse_gamers.GAME  AS G    -- RIGHT
    ON      V.id_game = G.id_game
LEFT JOIN   coderhouse_gamers.SYSTEM_USER AS US 
    ON      V.id_system_user = US.id_system_user
WHERE
    V.value BETWEEN 6 AND 9 -- NUMBER  | BOOLEANOS
ORDER BY    V.value;



/*
### Problema:
Nuestro equipo de desarrollo está trabajando en un sistema de gestión de reservas para restaurantes,
y nos enfrentamos a la necesidad de diseñar una base de datos eficiente que pueda manejar todas las operaciones 
relacionadas con las reservas de manera óptima.
### Descripción del Problema:
1. **Gestión de Clientes y Empleados**: 
Necesitamos una base de datos que nos permita registrar la información de los clientes que realizan reservas,
así como de los empleados involucrados en el proceso de reserva, como los camareros o encargados de atención al cliente.
2. **Gestión de Tipos de Reserva**: 
Es importante poder clasificar las reservas según su tipo, ya sea una reserva estándar,
una reserva para eventos especiales o reservas de grupos grandes.
Esto nos ayudará a organizar mejor el flujo de trabajo y adaptar nuestros servicios según las necesidades del cliente.
3. **Gestión de Mesas y Disponibilidad**: 
La base de datos debe permitirnos registrar la disponibilidad de mesas en cada restaurante,
así como gestionar su capacidad y estado (ocupado o disponible).
 Esto es fundamental para garantizar una asignación eficiente de mesas y evitar conflictos de reservas.
4. **Registro de Reservas**: 
Necesitamos un sistema que pueda registrar de manera detallada cada reserva realizada, 
incluyendo la fecha y hora de la reserva, el cliente que la realizó, la mesa reservada,
el empleado que atendió la reserva y el tipo de reserva.
### Objetivo:
Diseñar e implementar una base de datos relacional que satisfaga todas las necesidades de gestión de reservas 
para nuestro sistema de gestión de restaurantes. 
Esta base de datos deberá ser eficiente, escalable y fácil de mantener,
permitiendo una gestión ágil y precisa de todas las operaciones relacionadas con las reservas.
*/




/*
## Descripción de la Base de Datos - Gestión de Reservas en Restaurantes
### ENTIDADES | ACTORES QUE INTERVIENEN EN ESTA BASE DE DATOS:
1. **CLIENTE**:
   - Almacena información sobre los clientes que realizan reservas.
   - Atributos: 
            IDCLIENTE   INT NOT NULL PK AI
        ,   NOMBRE      VARCHAR(100)    DEFAULT 'DESCONOCIDO'
        ,   TELEFONO    VARCHAR(20)     DEFAULT '000-000-000'
        ,   CORREO      VARCHAR(50)
2. **EMPLEADO**:
   - Contiene información sobre los empleados involucrados en el proceso de reservas.
   - Atributos: IDEMPLEADO, NOMBRE, TELEFONO, CORREO, IDRESTAURANTE.
3. **DUEÑO**:
   - Guarda datos sobre los dueños de los restaurantes (no se utiliza explícitamente en el proceso de reservas).
4. **TIPORESERVA**:
   - Define diferentes tipos de reserva para clasificarlas según su propósito o requisitos específicos.
   - Atributos: IDTIPORESERVA, TIPO.
5. **RESTAURANTE**:
   - Almacena información sobre los restaurantes disponibles.
   - Atributos: IDRESTAURANTE, NOMBRE, DIRECCION, TELEFONO.
6. **MESA**:
   - Contiene información sobre las mesas disponibles en cada restaurante.
   - Atributos: IDMESA, IDRESTAURANTE, CAPACIDAD, DISPONIBLE.
7. **RESERVA**:
   - Registra las reservas realizadas por los clientes.
   - Atributos: IDRESERVA, IDCLIENTE, IDMESA, IDEMPLEADO, IDTIPORESERVA, FECHA.
*/


--  DER SIMPLIFICADO

/*
+------------------+        +-----------------------+        +------------------+
|      CLIENTE     |        |       RESERVA         |        |     RESTAURANTE  |
+------------------+   1-*  +-----------------------+   *-1  +------------------+
| idCliente (PK)   |<>-----o| idReserva (PK)        |o-------| idRestaurante(PK)|
| nombre           |        | idCliente (FK)        |        | nombre           |
| telefono         |        | idMesa (FK)           |        | direccion        |
| correo           |        | idEmpleado (FK)       |        | telefono         |
+------------------+        | idTipoReserva (FK)    |        +------------------+
                            | fecha                 |
                            | cancelcion            |                  |
                            +-----------------------+                  |
                                    |                                  |
                                    |   1-* | 1-1                      |
                                    v                                  v
+------------------+        +------------------+             +-------------------+
|     Empleado     |        |      Mesa        |             |     Dueño         |
+------------------+        +------------------+             +-------------------+
| idEmpleado (PK)  |        | idMesa (PK)      |             | idDueño (PK)      |
| nombre           |        | idRestaurante(FK)|             | nombre            |
| telefono         |        | capacidad        |             | correo            |
| correo           |        | disponible       |             | telefono          |
| idRestaurante(FK)|        +------------------+             +-------------------+
+------------------+                  |
                             +-------------------+
                             |   TipoReserva     |
                             +-------------------+
                             | idTipoReserva(PK) |
                             | tipo              |
                             +-------------------+
*/



-- GENERAR EL DDL
