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
SELECT DISTINCT j.titulo
FROM juego j
JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma LIKE 'PlayStation%';

-- Ejercicio 7: Contar el número de juegos por plataforma.
SELECT p.nombre_plataforma, COUNT(jp.id_juego) AS numero_juegos
FROM plataforma p
LEFT JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
GROUP BY p.nombre_plataforma;

-- Ejercicio 8. Cuenta el número diferente de desarrolladores japoneses que hay.
SELECT COUNT(DISTINCT d.id_desarrollador) AS numero_desarrolladores_japoneses
FROM desarrollador d
WHERE d.continente = 'Asia' AND d.pais_origen = 'Japón';

-- Ejercicio 9: Muestra el continente con menos juegos desarrollados.
SELECT d.continente, COUNT(jd.id_juego) AS numero_juegos
FROM desarrollador d
JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
GROUP BY d.continente
ORDER BY numero_juegos ASC
LIMIT 1;

-- Ejercicio 10: Mostrar cuántos juegos han sido comprados por usuarios españoles.
SELECT COUNT(DISTINCT c.id_juego) AS numero_juegos_comprados
FROM compra c
JOIN usuario u ON c.id_usuario = u.id_usuario
WHERE u.pais = 'España';

-- Ejercicio 11. Muestra los juegos desarrollados por Hideo Kojima.
SELECT j.titulo
FROM juego j
JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
WHERE d.nombre = 'Hideo Kojima';

-- Ejercicio 12. Muestra el precio promedio de juegos lanzados en la plataforma Nintendo Switch.
SELECT AVG(j.precio) AS precio_promedio
FROM juego j
JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma = 'Nintendo Switch';
-- Ejercicio 13. Muestra todos los datos de los juegos lanzados exclusivamente para Nintendo Switch o PlayStation 5, ordenados por fecha de lanzamiento.
SELECT j.*
FROM juego j
JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma IN ('Nintendo Switch', 'PlayStation 5')
ORDER BY j.fecha_lanzamiento;

-- Ejercicio 14. Muestra el nombre de los desarrolladores junto con el título de los juegos que han desarrollado. Incluye a los desarrolladores que no tienen juegos asociados.
SELECT d.nombre AS nombre_desarrollador, j.titulo AS titulo_juego
FROM desarrollador d
LEFT JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
LEFT JOIN juego j ON jd.id_juego = j.id_juego;

-- Ejercicio 15. Muestra los tres juegos más deseados por todos los usuarios de la plataforma.
SELECT j.titulo, COUNT(w.id_usuario) AS numero_deseos
FROM juego j
JOIN wishlist w ON j.id_juego = w.id_juego
GROUP BY j.id_juego
ORDER BY numero_deseos DESC
LIMIT 3;

-- Ejercicio 16. Muestra todos los datos de los juegos lanzados exclusivamente para Nintendo Switch o PlayStation 5, ordenados por fecha de lanzamiento.
SELECT DISTINCT j.*
FROM juego j
JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma IN ('Nintendo Switch', 'PlayStation 5')
ORDER BY j.fecha_lanzamiento;

-- Ejercicio 17: Mostrar el género principal y el promedio de puntuaciones de los juegos de cada género principal que tengan al menos 5 juegos.
SELECT g.nombre_genero, AVG(j.puntuacion) AS promedio_puntuaciones
FROM genero g
JOIN juego j ON g.id_genero = j.id_genero1
GROUP BY g.nombre_genero
HAVING COUNT(j.id_juego) >= 5;

-- Ejercicio 18: Mostrar la cantidad de juegos por plataforma y el precio promedio de esos juegos para plataformas que tienen más de 5 juegos lanzados.
SELECT p.nombre_plataforma, COUNT(jp.id_juego) AS cantidad_juegos, AVG(j.precio) AS precio_promedio
FROM plataforma p
JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
JOIN juego j ON jp.id_juego = j.id_juego
GROUP BY p.nombre_plataforma
HAVING COUNT(jp.id_juego) > 5;


-- Ejercicio 19. Muestra el nombre de todos los videojuegos, con el nombre de su género principal, y si tiene, o no, el nombre de su género secundario.
SELECT j.titulo AS nombre_juego,
       g1.nombre_genero AS genero_principal,
       g2.nombre_genero AS genero_secundario
FROM juego j
JOIN genero g1 ON j.id_genero1 = g1.id_genero
LEFT JOIN genero g2 ON j.id_genero2 = g2.id_genero;

-- Ejercicio 20. Muestra el nombre de todos los géneros que no tienen asociado ningún juego.
SELECT g.nombre_genero
FROM genero g
LEFT JOIN juego j ON g.id_genero = j.id_genero1 OR g.id_genero = j.id_genero2
WHERE j.id_juego IS NULL;

-- Ejercicio 21. Muestra el nombre y la fecha de lanzamiento de todos los juegos que tienen una secuela y de sus secuelas y ordénalos de fecha más antigua a más reciente.
SELECT j1.titulo AS juego_original, j1.fecha_lanzamiento AS fecha_original,
       j2.titulo AS secuela, j2.fecha_lanzamiento AS fecha_secuela
FROM juego j1
JOIN juego j2 ON j1.id_juego = j2.id_secuela
ORDER BY j1.fecha_lanzamiento ASC, j2.fecha_lanzamiento ASC;

-- Ejercicio 22. Muestra el nombre, género y estudio de desarrollo de los juegos que no han sido comprados.
SELECT j.titulo AS nombre_juego, g.nombre_genero AS genero, d.nombre AS estudio_desarrollo
FROM juego j
JOIN genero g ON j.id_genero1 = g.id_genero
JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
LEFT JOIN compra c ON j.id_juego = c.id_juego
WHERE c.id_juego IS NULL;

-- Ejercicio 23. Muestra el nombre de los usuarios que han dejado una reseña muy positiva (más de 85 puntos) sobre un juego y el número de amigos que tiene, ordenado por el número de amigos de forma descendente y por el nombre de usuario.
SELECT u.nombre_usuario, COUNT(a.id_amigo2) AS numero_amigos
FROM usuario u
JOIN resena r ON u.id_usuario = r.id_usuario
LEFT JOIN amistad a ON u.id_usuario = a.id_amigo1
WHERE r.puntuacion > 85
GROUP BY u.id_usuario, u.nombre_usuario
ORDER BY numero_amigos DESC, u.nombre_usuario;

-- Ejercicio 24: Mostrar el nombre de los desarrolladores y el número de juegos que han desarrollado cuya puntuación sea mayor a 75. Mostrar solo los desarrolladores que tienen al menos 3 juegos con esa puntuación.
SELECT d.nombre AS nombre_desarrollador, COUNT(j.id_juego) AS numero_juegos
FROM desarrollador d
JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
JOIN juego j ON jd.id_juego = j.id_juego
WHERE j.puntuacion > 75
GROUP BY d.id_desarrollador, d.nombre
HAVING COUNT(j.id_juego) >= 3;

-- Ejercicio 25. Muestra el título de los juegos que estén duplicados en la base de datos.
SELECT j.titulo, COUNT(*) AS cantidad_duplicados
FROM juego j
GROUP BY j.titulo
HAVING COUNT(*) > 1;
