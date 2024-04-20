-- TRIGGERS
-- Link : https://docs.google.com/presentation/d/e/2PACX-1vQpQSNAPVD2IaMqn_mEFfgZs3VQviS9_SgmMTYsJj0A2Sj9gWTn7QKo7nwhCWtBxg/pub?start=false&loop=false&delayms=3000

/*
Triggers

## Triggers en MySQL

**Casos de uso:**

* **Auditoria:** Registrar cambios en la base de datos, como quién modificó un registro o cuándo se eliminó.
* **Validación de datos:** Asegurar que los datos ingresados sean correctos antes de almacenarlos.
* **Implementación de reglas de negocio:** Automatizar tareas como enviar notificaciones o calcular valores derivados.
* **Replicación de datos:** Mantener sincronizadas dos o más bases de datos.

**Sintaxis:**

```sql
CREATE TRIGGER nombre_trigger
BEFORE/AFTER INSERT/UPDATE/DELETE ON nombre_tabla
FOR EACH ROW
BEGIN
  -- Sentencias SQL que se ejecutarán
END;
```

**Triggers de auditoría:**

```sql
CREATE TRIGGER auditoria_modificacion
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO auditoria (usuario, fecha, accion, tabla, columna, valor_anterior, valor_nuevo)
  VALUES (CURRENT_USER, NOW(), 'UPDATE', 'usuarios', OLD.columna, NEW.columna);
END;
```

**Tipos de triggers:**

* **BEFORE:** Se ejecuta antes de la operación que lo activa.
* **AFTER:** Se ejecuta después de la operación que lo activa.
* **INSTEAD OF:** Reemplaza la operación que lo activa.

**FOR EACH ROW:**

Indica que el trigger se ejecutará para cada fila afectada por la operación.

**Integración con funciones:**

Los triggers pueden llamar a funciones para realizar tareas complejas.

**Ejemplos en MySQL:**

* **Validar que el email sea único:**

```sql
CREATE TRIGGER validar_email
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT * FROM usuarios WHERE email = NEW.email) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE 'El email ya está registrado';
  END IF;
END;
```

* **Enviar una notificación cuando se crea un nuevo usuario:**

```sql
CREATE TRIGGER notificacion_nuevo_usuario
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
  -- almacenamiento de una tabla temporal
END;
```

**Recursos adicionales:**

* Documentación oficial de MySQL sobre triggers: [https://dev.mysql.com/doc/refman/8.0/en/triggers.html](https://dev.mysql.com/doc/refman/8.0/en/triggers.html)

Es importante tener en cuenta que los triggers pueden afectar el rendimiento de la base de datos. Se recomienda usarlos con moderación y solo cuando sean realmente necesarios.


*/