
/*

- Potenciar el proyecto que creamos durante los Workshop I y II.
- Definir tres usuarios a través de DCL.
- Establecer permisos de lectura sobre determinadas tablas (usuario 1).
- Establecer permisos de lectura/escritura sobre todas las tablas (usuario 2).
- Establecer permiso de lectura/eliminación sobre todas las tablas (usuario 3).
- Probar los permisos otorgados, mediante operaciones DML.
- Eliminar (usuario 3) y configurar los permisos de éste a (usuario 2).
- Integrar el uso de (TCL) al momento de realizar las operaciones DML anteriormente mencionadas.

*/


-- Crear usuarios
CREATE USER "usuario1"@"%" IDENTIFIED BY "password1";
CREATE USER "usuario2"@"%" IDENTIFIED BY "password2";
CREATE USER "usuario3"@"%" IDENTIFIED BY "password3";

-- Otorgar permisos a usuario1 (lectura sobre determinadas tablas)
GRANT SELECT ON mozo_atr.CLIENTE TO "usuario1"@"%";
GRANT SELECT ON mozo_atr.DUENO TO "usuario1"@"%";
-- Agrega más tablas según sea necesario

-- Otorgar permisos a usuario2 (lectura/escritura sobre todas las tablas)
GRANT SELECT, INSERT, UPDATE, DELETE ON mozo_atr.* TO "usuario2"@"%";

-- Otorgar permisos a usuario3 (lectura/eliminación sobre todas las tablas)
GRANT SELECT, DELETE ON mozo_atr.* TO "usuario3"@"%";

-- VERIFICAR TODOS ESTOS PERMISOS




-- Iniciar una transacción
START TRANSACTION;

-- Operaciones de usuario1 (lectura)
SELECT * FROM mozo_atr.CLIENTE;
SELECT * FROM mozo_atr.DUENO;

-- Operaciones de usuario2 (lectura/escritura)
INSERT INTO mozo_atr.CLIENTE (NOMBRE, TELEFONO, CORREO) VALUES ("Nuevo Cliente", "123456789", "nuevo@cliente.com");
UPDATE mozo_atr.CLIENTE SET TELEFONO = "987654321" WHERE IDCLIENTE = 1;

-- Operaciones de usuario3 (lectura/eliminación)
DELETE FROM mozo_atr.CLIENTE WHERE IDCLIENTE = 2;

-- Confirmar la transacción
COMMIT;



-- Eliminar usuario3
DROP USER "usuario3"@"%";

-- Otorgar permisos de usuario3 a usuario2
GRANT SELECT, DELETE ON mozo_atr.* TO "usuario2"@"%";



-- DATA EXTRA :  https://dev.mysql.com/doc/refman/8.3/en/declare-handler.html


DROP PROCEDURE IF EXISTS sp_insertar_cliente;

DELIMITER //

CREATE PROCEDURE sp_insertar_cliente(
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT ">> error_message: Cliente no insertado correctamente se hace un Rollback" AS Message;
    END;

    START TRANSACTION;


    INSERT INTO mozo_atr.CLIENTE 
        (NOMBRE, TELEFONO, CORREO) 
    VALUES 
        (p_nombre, p_telefono, p_correo);
    

    COMMIT;
    SELECT "Cliente insertado exitosamente." AS Message;
    SELECT * FROM CLIENTE WHERE CORREO LIKE p_correo ;

END //

DELIMITER ;


CALL sp_insertar_cliente("Nombre Cliente", "123456789", "correo@cliente.com");
CALL sp_insertar_cliente("anderson", "1234567", "andru@mail.com");

-- EXTRA: REALIZAR UN BACKUP DE ESTE PROYECTO





