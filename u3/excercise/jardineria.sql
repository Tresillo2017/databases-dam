-- CONSULTAS SOBRE UNA TABLA

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codigo_oficina, ciudad FROM oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, telefono FROM oficina WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT nombre, apellido1, email FROM empleado WHERE codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT puesto, nombre, apellido1, email FROM empleado WHERE codigo_jefe IS NULL;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre, apellido1, puesto FROM empleado WHERE puesto != 'Representante ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente FROM cliente WHERE pais = 'España';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT estado FROM pedido;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
    -- • Utilizando la función YEAR de MySQL.
    SELECT DISTINCT codigo_cliente FROM pago WHERE YEAR(fecha_pago) = 2008;
    -- • Utilizando la función DATE_FORMAT de MySQL.
    SELECT DISTINCT codigo_cliente FROM pago WHERE DATE_FORMAT(fecha_pago, '%Y') = '2008';

    --  Sin utilizar ninguna de las funciones anteriores.
    SELECT DISTINCT codigo_cliente FROM pago WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31';

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
    -- • Utilizando la función ADDDATE de MySQL.
    SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
    FROM pedido
    WHERE fecha_entrega <= ADDDATE(fecha_esperada, INTERVAL -2 DAY);
    -- Utilizando la función DATEDIFF de MySQL.
    SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
    FROM pedido
    WHERE fecha_entrega <= fecha_esperada - INTERVAL 2 DAY;
    -- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
    SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
    FROM pedido
    WHERE fecha_entrega <= fecha_esperada - 2;
-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT codigo_pedido, codigo_cliente, estado, fecha_pedido
FROM pedido
WHERE estado = 'Rechazado' AND YEAR(fecha_pedido) = 2009;
-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
SELECT codigo_pedido, codigo_cliente, estado, fecha_pedido
FROM pedido
WHERE MONTH(fecha_entrega) = 1;
-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT id_transaccion, codigo_cliente, forma_pago, fecha_pago, total
FROM pago
WHERE forma_pago = 'Paypal' AND YEAR(fecha_pago) = 2008
ORDER BY total DESC;
-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT forma_pago FROM pago;
-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
SELECT codigo_producto, nombre, gama, cantidad_en_stock, precio_venta
FROM producto
WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;
-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
SELECT nombre_cliente, ciudad, codigo_empleado_rep_ventas
FROM cliente
WHERE ciudad = 'Madrid' AND (codigo_empleado_rep_ventas = 11 OR codigo_empleado_rep_ventas = 30);

-- CONSULTAS MULTITABLA (COMPOSICIÓN INTERNA)

-- 1. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, p.id_transaccion, e.nombre AS REPRESENTANTE_VENTAS
FROM cliente c
         JOIN pago p ON c.codigo_cliente = p.codigo_cliente
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 2. Muestra el nombre de los clientes que no hayan realizado pagos
--  junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, p.id_transaccion, e.nombre AS REPRESENTANTE_VENTAS
FROM cliente c
         LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE p.id_transaccion IS NULL;


-- 3. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, p.id_transaccion, e.nombre AS REPRESENTANTE_VENTAS, o.ciudad
FROM cliente c
         JOIN pago p ON c.codigo_cliente = p.codigo_cliente
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
         JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 4. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, p.id_transaccion, e.nombre AS REPRESENTANTE_VENTAS, o.ciudad
FROM cliente c
         LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
         JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE p.id_transaccion IS NULL;

-- 5. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT DISTINCT o.linea_direccion1 AS DIRECCION, c.ciudad AS CIUDAD_CLIENTE
FROM oficina o
         JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
         JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'fuenlabrada';

-- 6. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre AS REPRESENTANTE_VENTAS, o.ciudad AS CIUDAD_OFICINA
FROM cliente c
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
         JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 7. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT j.nombre AS JEFE, e.nombre AS EMPLEADO
FROM empleado e
         JOIN empleado j ON e.codigo_jefe = j.codigo_empleado;

-- 8. Devuelve un listado que muestre el nombre de cada empleado,
-- el nombre de su jefe y el nombre del jefe de su jefe.
SELECT sj.nombre AS SUPER_JEFE, j.nombre AS JEFE, e.nombre AS EMPLEADO
FROM empleado e
         JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
         JOIN empleado sj ON j.codigo_jefe = sj.codigo_empleado;

-- 9. Devuelve el nombre de los clientes a los que no se les
-- ha entregado a tiempo un pedido.
SELECT c.nombre_cliente, pe.fecha_esperada, pe.fecha_entrega
FROM cliente c
         JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
WHERE pe.fecha_entrega > pe.fecha_esperada;

-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado
-- cada cliente.
SELECT DISTINCT c.nombre_cliente, g.gama
FROM cliente c
         JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
         JOIN detalle_pedido dp ON pe.codigo_pedido = dp.codigo_pedido
         JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
         JOIN gama_producto g ON pr.gama = g.gama;

-- CONSULTAS MULTITABLA (COMPOSICIÓN EXTERNA)

-- 1. Devuelve un listado que muestre solamente los clientes
-- que no han realizado ningún pedido.
SELECT c.nombre_cliente, p.codigo_pedido
FROM cliente c
         LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_pedido IS NULL;

-- 2. Devuelve un listado que muestre los clientes que no han
-- realizado ningún pago y los que no han realizado ningún pedido.
SELECT c.nombre_cliente, p.codigo_pedido, pa.id_transaccion
FROM cliente c
         LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
         LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE p.codigo_pedido IS NULL
  AND pa.id_transaccion IS NULL;

-- 3. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT e.nombre, o.codigo_oficina
FROM empleado e
         LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina IS NULL;
-- 4. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.nombre, c.codigo_cliente
FROM empleado e
         LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;
-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.
SELECT e.nombre AS EMPLEADO, c.codigo_cliente AS CLIENTE, o.codigo_oficina AS OFICINA
FROM empleado e
         LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
         JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;
-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
SELECT e.nombre AS EMPLEADO, o.codigo_oficina AS OFICINA, c.codigo_cliente AS CLIENTE
FROM empleado e
         LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
         LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE o.codigo_oficina IS NULL
   OR c.codigo_cliente IS NULL;
-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT pr.nombre, dp.codigo_producto
FROM producto pr
         LEFT JOIN detalle_pedido dp ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;
-- 8. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.
SELECT pr.nombre, pr.descripcion, pr.imagen, dp.codigo_producto
FROM producto pr
         LEFT JOIN detalle_pedido dp ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;
-- 9. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT o.codigo_oficina, e.codigo_empleado, g.gama
FROM oficina o
         LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
         JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
         JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
         JOIN detalle_pedido dp ON pe.codigo_pedido = dp.codigo_pedido
         JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
         JOIN gama_producto g ON pr.gama = g.gama
WHERE g.gama = 'Frutales' AND e.codigo_empleado IS NULL;

-- 10. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
SELECT c.nombre_cliente AS MOROSO, pe.codigo_pedido, pa.id_transaccion
FROM cliente c
         JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
         LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pa.id_transaccion IS NULL;

-- 11. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT e.nombre AS EMPLEADO, c.codigo_empleado_rep_ventas, j.nombre AS JEFE
FROM empleado e
         LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
         JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_cliente IS NULL;

-- CONSULTAS RESUMEN (FUNCIONES DE AGREGADO)

-- 1. ¿Cuántos empleados hay en la compañía?
SELECT COUNT(*) AS NUMERO_EMPLEADOS FROM empleado;
-- 2. ¿Cuántos clientes tiene cada país?
SELECT COUNT(*) AS NUMERO_CLIENTES, pais FROM cliente GROUP BY pais;
-- 3. ¿Cuál fue el pago medio en 2009?
SELECT AVG(total) AS PAGO_MEDIO_2009 FROM pago WHERE YEAR(fecha_pago) = 2009;
-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
SELECT COUNT(*) AS NUMERO_PEDIDOS, estado FROM pedido GROUP BY estado ORDER BY NUMERO_PEDIDOS DESC;
-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT MAX(precio_venta) AS PRECIO_MAS_CARO, MIN(precio_venta) AS PRECIO_MAS_BARATO FROM producto;
-- 6. Calcula el número de clientes que tiene la empresa.
SELECT COUNT(*) AS NUMERO_CLIENTES FROM cliente;
-- 7. ¿Cuantos clientes existen con domicilio en la ciudad de Madrid?
SELECT COUNT(*) AS NUMERO_CLIENTES_MADRID FROM cliente WHERE ciudad = 'Madrid';
-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT COUNT(*) AS NUMERO_CLIENTES, ciudad FROM cliente WHERE ciudad LIKE 'M%' GROUP BY ciudad;
-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.
SELECT e.nombre AS REPRESENTANTE_VENTAS, COUNT(c.codigo_cliente) AS NUMERO_CLIENTES
FROM empleado e
         JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
GROUP BY e.nombre;
-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT COUNT(*) AS NUMERO_CLIENTES_SIN_REPRESENTANTE
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;
-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.
SELECT c.nombre_cliente, MIN(pa.fecha_pago) AS PRIMER_PAGO, MAX(pa.fecha_pago) AS ULTIMO_PAGO
FROM cliente c
         JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
GROUP BY c.nombre_cliente;
-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT pe.codigo_pedido, COUNT(DISTINCT dp.codigo_producto) AS NUMERO_PRODUCTOS
FROM pedido pe
         JOIN detalle_pedido dp ON pe.codigo_pedido = dp.codigo_pedido
GROUP BY pe.codigo_pedido;
-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.
SELECT pe.codigo_pedido, SUM(dp.cantidad) AS CANTIDAD_TOTAL_PRODUCTOS
FROM pedido pe
         JOIN detalle_pedido dp ON pe.codigo_pedido = dp.codigo_pedido
GROUP BY pe.codigo_pedido;
-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.

-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado.

-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.

-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.

-- 18. Lista las ventas totales de los productos que hayan facturado
-- más de 250 euros. Se mostrará el nombre, unidades vendidas,
-- total facturado y total facturado con impuestos (21% IVA).
SELECT pr.nombre, COUNT(dp.codigo_producto) AS UNIDADES_VENDIDAS,
       SUM(pr.precio_venta) AS VENTAS_TOTALES, SUM(pr.precio_venta) * 1.21 AS VENTA_IVA
FROM producto pr
         JOIN detalle_pedido dp ON pr.codigo_producto = dp.codigo_producto
GROUP BY pr.nombre
HAVING VENTAS_TOTALES > 250;

-- 19. Muestre la suma total de todos los pagos que se realizaron
-- para cada uno de los años que aparecen en la tabla pagos.

-- SUBCONSULTAS

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.

-- 3. Devuelve el nombre del producto del que se han vendido más unidades.

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que hayan realizado. (Sin utilizar INNER JOIN).

-- 5. Devuelve el producto que más unidades tiene en stock.

-- 6. Devuelve el producto que menos unidades tiene en stock.

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

-- 8. Devuelve el nombre del cliente con mayor límite de crédito.

-- 9. Devuelve el nombre del producto que tenga el precio de venta más caro.

-- 10. Devuelve el producto que menos unidades tiene en stock.

-- 11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

-- 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

-- 13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

-- 14. Devuelve un listado de los productos que nunca han aparecido en un pedido.

-- 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representantes de ventas de ningún cliente.

-- 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

-- 17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

-- 18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

-- 19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

-- 20. Devuelve un listado de los productos que nunca han aparecido en un pedido.

-- 21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

-- CONSULTAS VARIADAS

-- 1. Devuelve el listado de clientes indicando el nombre del cliente
-- y cuántos pedidos ha realizado.

-- 2. Devuelve un listado con los nombres de los clientes
-- y el total pagado por cada uno de ellos.

-- 3. Devuelve el nombre de los clientes que hayan hecho pedidos
-- en 2008 ordenados alfabéticamente de menor a mayor.
SELECT c.nombre_cliente, pe.codigo_pedido, YEAR(pe.fecha_pedido) AS AÑO_PEDIDO
FROM cliente c
         JOIN pedido pe ON pe.codigo_cliente = c.codigo_cliente
WHERE YEAR(pe.fecha_pedido) = 2008
ORDER BY c.nombre_cliente ASC;

-- 4. Devuelve el nombre del cliente, el nombre y primer apellido
-- de su representante de ventas y el número de teléfono
-- de la oficina del representante de ventas,
-- de aquellos clientes que no hayan realizado ningún pago.
SELECT c.nombre_cliente, CONCAT(e.nombre, ' ', e.apellido1) AS REPRESENTANTE_VENTAS,
       o.telefono AS TELEFONO_REPRESENTANTE
FROM cliente c
         JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
         JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
         LEFT JOIN pago pa ON pa.codigo_cliente = c.codigo_cliente
WHERE pa.id_transaccion IS NULL;

-- 5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.

-- 6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representantes de ventas de ningún cliente.

-- 7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.

