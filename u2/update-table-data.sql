-- OPERACIONES SOBRE LA BBDD

-- ACTUALIZAR DATOS DE LAS TABLAS
UPDATE producto
SET precio = 455.99, stock = 66, nombre = 'pokemon'
WHERE id_producto = 2; -- Escribimos una condición para no actualziar todo

-- Aumentar el precio de Nintendo Switch un 25%
UPDATE producto
SET precio = precio * 1.25
WHERE nombre = 'nintendo switch';

-- BORRAR DATOS DE LAS TABLAS
DELETE FROM empleado; -- No te olvides de poner el WHERE en el DELETE FROM ;)

DELETE FROM empleado
WHERE edad <= 20;

-- Añadir nuevos campos a una tabla
ALTER TABLE producto
    ADD descripcion TEXT,
    ADD caducidad DATE NOT NULL;

-- Borrar un campo de una tabla
ALTER TABLE producto
    DROP descripcion;

-- Modificar un campo de una tabla
ALTER TABLE producto
    CHANGE nombre nombre VARCHAR(150) NOT NULL;
-- CHANGE campo a modificar nombre_modificado (puede mantenerse) TIPO_DATO (puede mantenerse)

-- Todo a la vez
ALTER TABLE empleado
    ADD salario DECIMAL(7,2) NOT NULL,
    DROP estado_civil,
    CHANGE email correo TEXT;

-- TRANSACCIONES
START TRANSACTION;

UPDATE empleado
SET nombre = 'Pikachu'
WHERE id_empleado = 1;

COMMIT; -- Confirmamos los cambios para el resto de usuarios

START TRANSACTION;

DELETE FROM producto;

ROLLBACK; -- Deshago todos los cambios producidos durante la transacción
