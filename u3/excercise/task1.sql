-- Ejercicio 1: Muestra el título de los juegos que fueron lanzados en el año 2020 y cuya puntuación sea mayor a 85.
SELECT titulo
FROM juego
WHERE YEAR(fecha_lanzamiento) = 2020 AND puntuacion > 85;

-- Ejercicio 2: Muestra el título de los juegos que fueron lanzados en los meses de enero o diciembre, y que tengan una clasificación de edad distinta a "+18".
SELECT titulo, MONTH(fecha_lanzamiento) AS MES_LANZAMIENTO, clasificacion_edad
FROM juego
WHERE (MONTH(fecha_lanzamiento) = 1 OR MONTH(fecha_lanzamiento) = 12)
  AND clasificacion_edad <> '+18';

-- Ejercicio 3: Muestra el título de los juegos cuya puntuación es menor a 50 o mayor a 90, y que no hayan sido lanzados en el mes de junio.
SELECT titulo
FROM juego
WHERE (puntuacion < 50 OR puntuacion > 90)
  AND MONTH(fecha_lanzamiento) <> 6;

-- Ejercicio 4: Muestra el título y el año de lanzamiento de los juegos lanzados en los últimos 3 años y cuyo precio sea mayor a 50.
SELECT titulo, YEAR(fecha_lanzamiento) AS anio_lanzamiento
FROM juego
WHERE fecha_lanzamiento >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
  AND precio > 50;

-- Ejercicio 5: Muestra el título de los juegos donde la puntuación menos el precio sea mayor a 50, y que hayan sido lanzados en el mes de septiembre.
SELECT titulo
FROM juego
WHERE (puntuacion - precio) > 50
  AND MONTH(fecha_lanzamiento) = 9;

-- Ejercicio 6: Mostrar todos los juegos lanzados en plataformas de PlayStation, utilizar patrones de búsqueda.
SELECT j.titulo
FROM juego j
JOIN plataforma p ON j.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma LIKE 'PlayStation%';

-- Ejercicio 7. Muestra cuántos juegos hay por cada plataforma, incluyendo aquellas plataformas que no tienen juegos almacenados.
SELECT p.nombre_plataforma, COUNT(j.id_juego) AS numero_juegos
FROM plataforma p
LEFT JOIN juego j ON p.id_plataforma = j.id_plataforma
GROUP BY p.nombre_plataforma;

-- Ejercicio 8. Cuenta el número diferente de desarrolladores japoneses que hay.
SELECT COUNT(DISTINCT d.id_desarrollador) AS numero_desarrolladores_japoneses
FROM desarrollador d
WHERE d.continente = 'Asia' AND d.pais = 'Japón';

-- Ejercicio 9. Muestra el continente con menor número de videojuegos desarrollados.
SELECT d.continente, COUNT(j.id_juego) AS numero_juegos
FROM desarrollador d
JOIN juego j ON d.id_desarrollador = j.id_desarrollador
GROUP BY d.continente
ORDER BY numero_juegos ASC

-- Ejercicio 10: Mostrar cuántos juegos han sido comprados por usuarios españoles.
SELECT COUNT(DISTINCT c.id_juego) AS numero_juegos_comprados
FROM compra c
JOIN usuario u ON c.id_usuario = u.id_usuario
WHERE u.pais = 'España';

-- Ejercicio 11. Muestra los juegos desarrollados por Hideo Kojima.
SELECT j.titulo
FROM juego j
JOIN desarrollador d ON j.id_desarrollador = d.id_desarrollador
WHERE d.nombre = 'Hideo Kojima';

-- Ejercicio 12. Muestra el promedio del precio de todos los juegos lanzados para Nintendo Switch.
SELECT AVG(j.precio) AS precio_promedio
FROM juego j
JOIN plataforma p ON j.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma = 'Nintendo Switch';

-- Ejercicio 13. Muestra todos los datos de los juegos lanzados exclusivamente para Nintendo Switch o PlayStation 5, ordenados por fecha de lanzamiento.


-- Ejercicio 14. Muestra el nombre de los desarrolladores junto con el título de los juegos que han desarrollado. Incluye a los desarrolladores que no tienen juegos asociados.


-- Ejercicio 15. Muestra los tres juegos más deseados por todos los usuarios de la plataforma.


-- Ejercicio 16. Muestra todos los datos de los juegos lanzados exclusivamente para Nintendo Switch o PlayStation 5, ordenados por fecha de lanzamiento.


-- Ejercicio 17: Mostrar el género principal y el promedio de puntuaciones de los juegos de cada género principal que tengan al menos 5 juegos.


-- Ejercicio 18: Mostrar la cantidad de juegos por plataforma y el precio promedio de esos juegos para plataformas que tienen más de 5 juegos lanzados.


-- Ejercicio 19. Muestra el nombre de todos los videojuegos, con el nombre de su género principal, y si tiene, o no, el nombre de su género secundario.


-- Ejercicio 20. Muestra el nombre de todos los géneros que no tienen asociado ningún juego.


-- Ejercicio 21. Muestra el nombre y la fecha de lanzamiento de todos los juegos que tienen una secuela y de sus secuelas y ordénalos de fecha más antigua a más reciente.


-- Ejercicio 22. Muestra el título, el género y el nombre del estudio de desarrollo de los juegos que aún no han sido comprados por ningún usuario.


-- Ejercicio 23. Muestra el nombre de los usuarios que han dejado una reseña muy positiva (más de 85 puntos) sobre un juego y el número de amigos que tiene, ordenado por el número de amigos de forma descendente y por el nombre de usuario.


-- Ejercicio 24: Mostrar el nombre de los desarrolladores y el número de juegos que han desarrollado cuya puntuación sea mayor a 75. Mostrar solo los desarrolladores que tienen al menos 3 juegos con esa puntuación.


-- Ejercicio 25. Muestra el título de los juegos que estén duplicados en la base de datos.
