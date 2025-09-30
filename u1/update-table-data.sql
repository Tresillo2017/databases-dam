-- Actualizar datos de las tablas
UPDATE producto
SET precio = 499.99, stock = 66, nombre = 'prokemon'
WHERE id_producto = 2;

-- Borar datos de las tablas
DELETE FROM empleado; -- No te olvides de poner el WHERE si no quieres borrar todo

DELETE FROM empleado -- Me cargo todos los empleados menores de 20 años
WHERE edad < 20;

