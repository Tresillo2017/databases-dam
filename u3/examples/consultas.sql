-- CONSULTAS

/* SELECT [OPCIONES] campo1, campo2, campo3...
FROM nombre_tabla
WHERE condiciones; */

-- Mostrar el titulo, descripcion y precio de los juegos que cuesten más de 50€
SELECT titulo, descripcion, precio
FROM juego
WHERE precio > 50;

-- NULL: Campos vacíos (no hay nada)
-- Mostrar los juegos que no se han lanzado todavía
SELECT titulo, fecha_lanzamiento
FROM juego
WHERE fecha_lanzamiento IS NULL; -- IS: Para comprobar si un campo es NULL o no

-- Mostrar los juegos que sí se han lanzado
SELECT titulo, fecha_lanzamiento
FROM juego
WHERE fecha_lanzamiento IS NOT NULL;

-- ORDER BY: Ordena los resultados de una consulta por uno o varios campos
-- Se escribe siempre al final de la consulta

/* SELECT campo1, campo2, campo3...
FROM nombre_tabla
WHERE condiciones
ORDER BY campo1 [ASC | DESC]; */

-- ASC: Ordena de menor a mayor (no es necesario porque ORDER BY por defecto ordena
-- de forma ascendente)
-- DESC: Ordena de mayor a menor

-- Mostrar todos los juegos ordenados por su puntuación de menor a mayor
SELECT titulo, puntuacion
FROM juego
WHERE puntuacion IS NOT NULL
ORDER BY puntuacion ASC; -- No hace falta ASC porque por defecto lo ordena de menor a mayor

-- Mostrar todos los juegos cuya puntuación sea mayor que 90, ordenados por puntuación
-- de forma descendente. Y luego ordénalos por título (alfabéticamente)
SELECT titulo, puntuacion
FROM juego
WHERE puntuacion > 90
ORDER BY puntuacion DESC, titulo;

-- DISTINCT: Oculta los resultados duplicados

/* SELECT DISTINCT campo1, campo2, campo3...
FROM nombre_tabla
WHERE condiciones */

-- Mostrar únicamente los diferentes precios y puntuaciones de todos los juegos
SELECT DISTINCT puntuacion, precio
FROM juego
ORDER BY precio DESC, puntuacion DESC;

-- Operadores dentro de un SELECT
-- Mostrar los juegos, su precio y un descuento del 75% de los juegos, ordenado por el precio descontado
SELECT titulo, precio, precio * 0.25 AS PRECIO_DESCUENTO
FROM juego -- AS: Pone un alias a un campo dentro del SELECT
ORDER BY PRECIO_DESCUENTO DESC;

-- OPERADORES LÓGICOS
-- OR: Devuelve TRUE (muestra resultados) si al menos una condición se cumple

-- Mostrar todos los juegos cuya puntuación sea igual o superior a 90 o que
-- su clasificacion_edad sea '+12'
SELECT titulo, puntuacion, clasificacion_edad
FROM juego
WHERE puntuacion >= 90
   OR clasificacion_edad = '+12';

-- AND: Devuelve TRUE (muestra resultados) si se cumplen todas las condiciones
-- Mostrar todos los juegos cuya puntuación sea igual o superior a 90 y que
-- su clasificacion_edad sea '+12'
SELECT titulo, puntuacion, clasificacion_edad
FROM juego
WHERE puntuacion >= 90
  AND clasificacion_edad = '+12';

-- Mostrar los juegos cuya puntuación sea superior a 90 y que el precio sea mayor a 50
-- o su clasificacion_edad sea '+18'
SELECT titulo, puntuacion, precio, clasificacion_edad
FROM juego
WHERE puntuacion > 90 AND (precio > 50 OR clasificacion_edad = '+18');

-- IN (dato1, dato2...): Es un operador como '=' pero permite comparar con más de un valor al mismo tiempo.
-- Funciona igual que concatenar varios OR

-- Mostrar todos los desarrolladores de Asia y Europa
SELECT nombre AS DESARROLLADOR, continente
FROM desarrollador
WHERE continente IN ('Asia', 'Europa')
ORDER BY continente;

-- NOT IN

-- Mostrar todos los desarrolladores que no son de Asia ni de América
SELECT nombre AS DESARROLLADOR, continente
FROM desarrollador
WHERE continente NOT IN ('Asia', 'América')
ORDER BY continente;

-- PATRONES DE BÚSQUEDA

-- LIKE: Operador similar a '=', se utiliza EXCLUSIVAMENTE para buscar coincidencias
-- '_': Define cualquier carácter de tamaño 1
-- '%': Define cualquier carácter de tamaño indefinido

-- Muestra el título de todos los juegos cuya segunda letra sea la 'e':
SELECT titulo
FROM juego
WHERE titulo LIKE '_e%';

-- Muestra el título y la puntuación de todos los juegos de la saga 'Mario'
SELECT titulo, puntuacion
FROM juego
WHERE titulo LIKE '%mario%';

-- FUNCIONES DE AGREGADO: Cogen una columna de la tabla (la que nosotros le indiquemos),
-- hace sus cálculos y de vuelve un único resultado. Ignorando los valores NULL

-- AVG(): Devuelve la media de todos los valores de la columna especificada
-- Muestra la puntuación promedio de todos los juegos cuya clasificación de edad sea
-- '+12'
SELECT AVG(puntuacion) AS PUNTUACION_PROMEDIO
FROM juego
WHERE clasificacion_edad = '+12';

-- MAX() y MIN(): Devuelven el valor máximo y mínimo respectivamente de la columna especificada
-- Muestra la puntuación máxima y mínima de todos los juegos cuya clasificación de edad sea
-- '+12'
SELECT MAX(puntuacion) AS MAX_PUNTUACION, MIN(puntuacion) AS MIN_PUNTUACION
FROM juego
WHERE clasificacion_edad = '+12';

-- SUM(): Devuelve la suma total de todos los valores de la columna especificada
-- Muestra el precio total de todos los juegos cuya clasificación de edad sea
-- '+12'
SELECT SUM(precio) AS PRECIO_TOTAL
FROM juego
WHERE clasificacion_edad = '+12';

-- COUNT(): Devuelve la cuenta de todos los registros de la columna especificada
-- Muestra cuántos juegos tienen una clasificación de edad '+12'
SELECT COUNT(*) AS NUM_JUEGOS -- Siempre que la columna no tenga valores nulos, podemos
-- especificar cualrquier columna, para simplificar, se escribe '*'
FROM juego
WHERE clasificacion_edad = '+12';

-- Muestra cuántos juegos tiene secuela
SELECT COUNT(id_secuela) AS JUEGOS_SECUELA -- Especifico una columna con valores NULL
FROM juego;

-- GROUP BY nombre_columna: Agrupa toda la información 'revuelta' por las funciones de
-- agregado mediante una columna especificada

-- Muestra cuántos juegos hay por cada clasificación de edad
SELECT clasificacion_edad, COUNT(*) AS NUM_JUEGOS
FROM juego
GROUP BY clasificacion_edad;

-- Muestra cuántos juegos hay por cada clasificación de edad cuya puntuación sea superior
-- a 85, ordenados por la cantidad de juegos de cada edad
SELECT clasificacion_edad, COUNT(*) AS NUM_JUEGOS
FROM juego
WHERE puntuacion > 85 -- Utilizamos WHERE cuando la condición es sobre un campo de la tabla.
-- Siempre va antes del GROUP BY
GROUP BY clasificacion_edad
ORDER BY NUM_JUEGOS;

-- HAVING: Es lo mismo que WHERE pero se utiliza exclusivamente para condicones que implquen
-- una función de agregado. Siempre va después del GROUP BY

-- Muestra cuántos juegos hay por cada clasificación de edad cuya puntuación sea superior
-- a 85, ordenados por la cantidad de juegos de cada edad. De aquellas edades que tengan
-- más de 10 juegos
SELECT clasificacion_edad, COUNT(*) AS NUM_JUEGOS
FROM juego
WHERE puntuacion > 85
GROUP BY clasificacion_edad
HAVING NUM_JUEGOS > 10 -- Utilizamos HAVING cuando la condición no es un campo de la tabla, sino
-- un dato devuelto por una función de agregado
ORDER BY NUM_JUEGOS;

-- CONSULTAS SOBRE VARIAS TABLAS

-- JOIN: Permite unir dos tablas para consultarlas a través de las claves foráneas/primarias

/* SELECT campo1 (tabla1), campo2 (tabla2)
FROM nombre_tabla1
JOIN nombre_tabla2 ON pk_tabla1 = fk_tabla2 (o al revés)
WHERE condiciones; */

-- Mostrar cuántos juegos que tienen como género principal 'Acción'
SELECT COUNT(*) AS NUM_JUEGOS, g.nombre_genero AS GENERO
FROM juego j
         JOIN genero g ON j.id_genero1 = g.id_genero
WHERE g.nombre_genero = 'accion';

select titulo
from juego
         join juego_plataforma On id_juego = id_juego;
-- Si me sale el error 'ambiguous' posiblemente no haya especificado a qué tabla
-- pertenece un campo

-- SOLUCIÓN: Añadir etiquetas a las tablas para diferenciarlos
select j.titulo
from juego j
         join juego_plataforma jp on jp.id_juego = j.id_juego;

-- Mostrar el titulo de cada juego y el nombre de la plataforma a la que pertenece
SELECT j.titulo, p.nombre_plataforma
FROM juego j
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma;

-- Mostrar el titulo de cada juego, el nombre de la plataforma a la que pertenece
-- y el nombre del desarrollador de cada juego
SELECT j.titulo, p.nombre_plataforma, d.nombre AS Desarrollador
FROM juego j
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
         JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
         JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador;

-- Mostrar cuántos juegos tiene la plataforma 'Nintendo Switch'
SELECT COUNT(*) AS NUM_JUEGOS, p.nombre_plataforma
FROM juego j
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma = 'Nintendo Switch';

-- Mostrar cuántos juegos que tienen el género 'Acción' ya sea como principal
-- o como secundario
SELECT COUNT(*) AS NUM_JUEGOS, g1.nombre_genero
FROM juego j
         JOIN genero g1 ON j.id_genero1 = g1.id_genero
         JOIN genero g2 ON j.id_genero2 = g2.id_genero
WHERE g1.nombre_genero = 'Acción'
   OR g2.nombre_genero = 'Acción';

-- Alternativa easy:
SELECT COUNT(*) AS NUM_JUEGOS, g.nombre_genero
FROM juego j
         JOIN genero g ON j.id_genero1 = g.id_genero OR j.id_genero2 = g.id_genero
WHERE g.nombre_genero = 'Acción';

-- Mostrar el título de todos los juegos y de sus secuelas
SELECT j1.titulo AS PRINCIPAL, j2.titulo AS SECUELA
FROM juego j1
         JOIN juego j2 ON j2.id_juego = j1.id_secuela;

-- OUTER JOIN (LEFT/RIGHT): Coger los todos los valores y además los NULL de una tabla.

-- Mostrar los usuarios que han comprado juegos
SELECT u.nombre_usuario, c.id_compra
FROM usuario u
         JOIN compra c ON u.id_usuario = c.id_usuario
         JOIN juego j ON c.id_juego = j.id_juego;

-- Mostrar los usuarios que NO han comprado juegos
SELECT u.nombre_usuario, c.id_compra
FROM usuario u
         LEFT JOIN compra c ON u.id_usuario = c.id_usuario
         JOIN juego j ON c.id_juego = j.id_juego
WHERE c.id_compra IS NULL;

-- LEFT SIEMPRE APUNTA A LA TABLA DEL FROM
-- RIGHT SIEMPRE APUNTA A LA DERECHA DEL JOIN

-- FUNCIONES/CLÁUSULAS ADICIONALES

-- YEAR(campo_fecha): Extrae el año (numérico) de un campo que almacene una fecha
-- MONTH(campo_fecha): Extrae el mes (numérico) de un campo que almacene una fecha
-- DAY(campo_fecha): Extrae el día (numérico) de un campo que almacene una fecha

-- Ejercicio 1: Muestra el título de los juegos que fueron lanzados en el año 2020
-- y cuya puntuación sea mayor a 85

SELECT titulo, YEAR(fecha_lanzamiento) AS AÑO_LANZAMIENTO, puntuacion
FROM juego
WHERE YEAR(fecha_lanzamiento) = 2020
  AND puntuacion > 85;

-- LIMIT n: Limita el número de resultados de una consulta al establecido por 'n'.
-- SIEMPRE VA AL FINAL DE LA CONSULTA (DESPUÉS INCLUSO DEL ORDER BY)

-- EJERCICIO EXTRA: Muestra el nombre del máximo goleador, así como el número
-- de goles que ha marcado.

SELECT nombre, goles
FROM jugador
ORDER BY goles DESC
LIMIT 1;
