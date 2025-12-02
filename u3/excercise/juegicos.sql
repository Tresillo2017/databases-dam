/* 01. Muestra el número total de juegos registrados en la tabla juego. */
SELECT COUNT(*) AS TOTAL_JUEGOS
FROM juego;

/* 02. Calcula el precio medio de todos los juegos. */
SELECT AVG(precio) AS PRECIO_MEDIO
FROM juego;

/* 03. Obtén la puntuación máxima y mínima de los juegos. */
SELECT MAX(puntuacion) AS PUNTUACION_MAXIMA, MIN(puntuacion) AS PUNTUACION_MINIMA
FROM juego;

/* 04. Cuenta cuántos juegos tienen un precio mayor o igual que 60. */
SELECT COUNT(*) AS JUEGOS_PRECIO_ALTO
FROM juego
WHERE precio >= 60;

/* 05. Calcula el precio medio de los juegos cuya clasificación por edad sea '+18'. */
SELECT AVG(precio) AS PRECIO_MEDIO_18
FROM juego
WHERE clasificacion_edad = '+18';

/* 06. Cuenta cuántos juegos pertenecen al género principal 'Acción' */
SELECT COUNT(*) AS JUEGOS_ACCION
FROM juego j
JOIN genero g ON j.id_genero1 = g.id_genero
WHERE g.nombre_genero = 'Acción';

/* 07. Muestra por cada clasificación de edad cuántos juegos hay. */
SELECT clasificacion_edad, COUNT(*) AS NUM_JUEGOS
FROM juego
GROUP BY clasificacion_edad;

/* 08. Muestra por cada género principal cuántos juegos hay. */
SELECT g.nombre_genero, COUNT(*) AS NUM_JUEGOS
FROM genero g
JOIN juego j ON g.id_genero = j.id_genero1
GROUP BY g.nombre_genero;

/* 09. Muestra por cada país cuántos usuarios hay registrados en la tabla usuario. */
SELECT pais, COUNT(*) AS NUM_USUARIOS
FROM usuario
GROUP BY pais;

/* 10. Muestra por cada método de pago cuántas compras se han realizado. */
SELECT metodo_pago, COUNT(*) AS NUM_COMPRAS
FROM compra
GROUP BY metodo_pago;

/* 11. Muestra por cada usuario el número de juegos que ha comprado. */
SELECT id_usuario, COUNT(*) AS NUM_JUEGOS_COMPRADOS
FROM compra
GROUP BY id_usuario;

/* 12. Muestra por cada usuario el número de reseñas que ha escrito. */
SELECT id_usuario, COUNT(*) AS NUM_RESEÑAS
FROM reseña
GROUP BY id_usuario;

/* 13. Muestra por cada juego el número total de reseñas que ha recibido. */
SELECT id_juego, COUNT(*) AS NUM_RESEÑAS
FROM reseña
GROUP BY id_juego;

/* 14. Muestra por cada juego la puntuación media de sus reseñas. */
SELECT id_juego, AVG(puntuacion) AS PUNTUACION_MEDIA
FROM reseña
GROUP BY id_juego;

/* 15. Muestra por cada juego la puntuación media de sus reseñas, pero solo de aquellos juegos con más de 5 reseñas. */
SELECT id_juego, AVG(puntuacion) AS PUNTUACION_MEDIA
FROM reseña
GROUP BY id_juego
HAVING COUNT(*) > 5;

/* 16. Muestra por cada juego la puntuación media de sus reseñas, pero solo de aquellos juegos con media superior o igual a 90. */
SELECT id_juego, AVG(puntuacion) AS PUNTUACION_MEDIA
FROM reseña
GROUP BY id_juego
HAVING AVG(puntuacion) >= 90;

/* 17. Muestra por cada país de los usuarios la puntuación media de las reseñas que escriben. */
SELECT u.pais, AVG(r.puntuacion) AS PUNTUACION_MEDIA
FROM usuario u
JOIN reseña r ON u.id_usuario = r.id_usuario
GROUP BY u.pais;

/* 18. Muestra por cada año de lanzamiento de los juegos cuántos juegos se lanzaron ese año. */
SELECT EXTRACT(YEAR FROM fecha_lanzamiento) AS ANIO_LANZAMIENTO, COUNT(*) AS NUM_JUEGOS
FROM juego
GROUP BY ANIO_LANZAMIENTO;

/* 19. Muestra por cada año de compra  el número de compras realizadas. */
SELECT EXTRACT(YEAR FROM fecha_compra) AS ANIO_COMPRA, COUNT(*) AS NUM_COMPRAS
FROM compra
GROUP BY ANIO_COMPRA;

/* 20. Muestra por cada plataforma el número de juegos distintos disponibles en ella. */
SELECT p.nombre_plataforma, COUNT(DISTINCT jp.id_juego) AS NUM_JUEGOS
FROM plataforma p
JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
GROUP BY p.nombre_plataforma;

/* 21. Muestra por cada juego el número de plataformas en las que está disponible. */
SELECT j.titulo, COUNT(jp.id_plataforma) AS NUM_PLATAFORMAS
FROM juego j
JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
GROUP BY j.titulo;

/* 22. Muestra por cada desarrollador cuántos juegos diferentes ha desarrollado. */
SELECT d.nombre AS NOMBRE_DESARROLLADOR, COUNT(DISTINCT jd.id_juego) AS NUM_JUEGOS
FROM desarrollador d
JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
GROUP BY d.nombre;

/* 23. Muestra por cada continente cuántos desarrolladores hay. */
SELECT d.continente, COUNT(*) AS NUM_DESARROLLADORES
FROM desarrollador d
GROUP BY d.continente;

/* 24. Muestra por cada continente el número total de juegos desarrollados por estudios de ese continente. */
SELECT d.continente, COUNT(jd.id_juego) AS NUM_JUEGOS
FROM desarrollador d
JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
GROUP BY d.continente;

/* 25. Muestra por cada género cuántos juegos lo tienen como género principal o secundario. */
SELECT g.nombre_genero, COUNT(*) AS NUM_JUEGOS
FROM genero g
LEFT JOIN juego j1 ON g.id_genero = j1.id_genero1
LEFT JOIN juego j2 ON g.id_genero = j2.id_genero2
WHERE j1.id_juego IS NOT NULL OR j2.id_juego IS NOT NULL
GROUP BY g.nombre_genero;

/* 26. Muestra por cada usuario cuántos amigos tiene. */
SELECT u.nombre_usuario, COUNT(a.id_amigo2) AS NUM_AMIGOS
FROM usuario u
LEFT JOIN amistad a ON u.id_usuario = a.id_amigo1
GROUP BY u.nombre_usuario;

/* 27. Muestra por cada usuario el número de juegos que tiene en su wishlist. */
SELECT u.nombre_usuario, COUNT(w.id_juego) AS NUM_JUEGOS_WISHLIST
FROM usuario u
LEFT JOIN wishlist w ON u.id_usuario = w.id_usuario
GROUP BY u.nombre_usuario;

/* 28. Muestra por cada juego cuántos usuarios lo han añadido a su wishlist. */
SELECT j.titulo, COUNT(w.id_usuario) AS NUM_USUARIOS_WISHLIST
FROM juego j
LEFT JOIN wishlist w ON j.id_juego = w.id_juego
GROUP BY j.titulo;

/* 29. Muestra por cada juego el número total de compras y el número total de reseñas que tiene. */
SELECT j.titulo,
       COUNT(DISTINCT c.id_compra) AS NUM_COMPRAS,
       COUNT(DISTINCT r.id_resena) AS NUM_RESEÑAS
FROM juego j
LEFT JOIN compra c ON j.id_juego = c.id_juego
LEFT JOIN resena r ON j.id_juego = r.id_juego
GROUP BY j.titulo;

/* 30. Muestra por cada juego el gasto total generado en compras (precio total del juego a partir de la tabla compra + juego). */
SELECT j.titulo, SUM(c.precio) AS GASTO_TOTAL
FROM juego j
JOIN compra c ON j.id_juego = c.id_juego
GROUP BY j.titulo;

/* 31. Muestra por cada usuario cuánto dinero se ha gastado en juegos (precio total de los juegos que ha comprado). */
SELECT u.nombre_usuario, SUM(c.precio) AS GASTO_TOTAL
FROM usuario u
JOIN compra c ON u.id_usuario = c.id_usuario
GROUP BY u.nombre_usuario;

/* 32. Muestra por cada usuario el número de juegos comprados y el número de juegos en la wishlist en una misma consulta. */
SELECT u.nombre_usuario,
       COUNT(DISTINCT c.id_juego) AS NUM_JUEGOS_COMPRADOS,
       COUNT(DISTINCT w.id_juego) AS NUM_JUEGOS_WISHLIST
FROM usuario u
LEFT JOIN compra c ON u.id_usuario = c.id_usuario
LEFT JOIN wishlist w ON u.id_usuario = w.id_usuario
GROUP BY u.nombre_usuario;

/* 33. Muestra por cada juego el número de reseñas positivas (puntuacion >= 80) y negativas (puntuacion < 80). */
SELECT j.titulo,
       SUM(CASE WHEN r.puntuacion >= 80 THEN 1 ELSE 0 END) AS NUM_RESEÑAS_POSITIVAS,
       SUM(CASE WHEN r.puntuacion < 80 THEN 1 ELSE 0 END) AS NUM_RESEÑAS_NEGATIVAS
FROM juego j
LEFT JOIN reseña r ON j.id_juego = r.id_juego
GROUP BY j.titulo;

/* 34. Muestra los juegos cuya media de puntuaciones de reseña sea mayor o igual que 90 Y además tengan al menos 3 reseñas. */
SELECT r.id_juego, AVG(r.puntuacion) AS PUNTUACION_MEDIA, COUNT(*) AS NUM_RESEÑAS
FROM reseña r
GROUP BY r.id_juego
HAVING AVG(r.puntuacion) >= 90 AND COUNT(*) >= 3;

/* 35. Muestra los juegos cuya media de puntuaciones de reseña sea inferior a 60 O que tengan menos de 2 reseñas en total. */
SELECT r.id_juego, AVG(r.puntuacion) AS PUNTUACION_MEDIA, COUNT(*) AS NUM_RESEÑAS
FROM reseña r
GROUP BY r.id_juego
HAVING AVG(r.puntuacion) < 60 OR COUNT(*) < 2;

/* 36. Muestra por cada país de usuario, la media de puntuación de sus reseñas, pero solo de países que hayan escrito al menos 20 reseñas. */
SELECT u.pais, AVG(r.puntuacion) AS PUNTUACION_MEDIA, COUNT(*) AS NUM_RESEÑAS
FROM usuario u
JOIN reseña r ON u.id_usuario = r.id_usuario
GROUP BY u.pais
HAVING COUNT(*) >= 20;

/* 37. Muestra por cada método de pago el gasto total realizado, pero solo aquellos métodos cuyo gasto supere los 500. */
SELECT metodo_pago, SUM(precio) AS GASTO_TOTAL
FROM compra
GROUP BY metodo_pago
HAVING SUM(precio) > 500;

/* 38. Muestra por cada año de lanzamiento de los juegos el número de juegos lanzados y el precio medio, pero solo los años con más de 5 juegos. */
SELECT EXTRACT(YEAR FROM fecha_lanzamiento) AS ANIO_LANZAMIENTO,
       COUNT(*) AS NUM_JUEGOS,
       AVG(precio) AS PRECIO_MEDIO
FROM juego
GROUP BY ANIO_LANZAMIENTO
HAVING COUNT(*) > 5;

/* 39. Muestra por cada género principal el número de juegos con puntuación >= 90. */
SELECT g.nombre_genero, COUNT(*) AS NUM_JUEGOS_ALTA_PUNTUACION
FROM genero g
JOIN juego j ON g.id_genero = j.id_genero1
WHERE j.puntuacion >= 90
GROUP BY g.nombre_genero;

/* 40. Muestra por cada género principal la puntuación media de los juegos de ese género, pero solo los géneros con media >= 85. */
SELECT g.nombre_genero, AVG(j.puntuacion) AS PUNTUACION_MEDIA
FROM genero g

/* 41. Muestra todos los juegos y, si existen, la media de puntuación de sus reseñas. */
JOIN juego j ON g.id_genero = j.id_genero1
GROUP BY g.nombre_genero
HAVING AVG(j.puntuacion) >= 85;
SELECT j.titulo, AVG(r.puntuacion) AS PUNTUACION_MEDIA
FROM juego j
LEFT JOIN reseña r ON j.id_juego = r.id_juego
GROUP BY j.titulo;

/* 42. Muestra todos los usuarios y, si existen, el número de compras que han realizado. */
SELECT u.nombre_usuario, COUNT(c.id_compra) AS NUM_COMPRAS
FROM usuario u

/* 43. Muestra todas las plataformas y el número de juegos asociados, incluyendo plataformas sin juegos. */
LEFT JOIN compra c ON u.id_usuario = c.id_usuario
GROUP BY u.nombre_usuario;
SELECT p.nombre_plataforma, COUNT(jp.id_juego) AS NUM_JUEGOS
FROM plataforma p

/* 44. Muestra todos los desarrolladores y cuántos juegos tienen, incluyendo aquellos que todavía no tienen juegos asociados. */
LEFT JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
GROUP BY p.nombre_plataforma;
SELECT d.nombre AS NOMBRE_DESARROLLADOR, COUNT(jd.id_juego) AS

/* 45. Muestra todos los juegos y cuántos usuarios los han añadido a la wishlist, incluyendo juegos que nadie ha añadido. */
NUM_JUEGOS
FROM desarrollador d
LEFT JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
GROUP BY d.nombre;
SELECT j.titulo, COUNT(w.id_usuario) AS NUM_USUARIOS_WISHLIST
FROM juego j
LEFT JOIN wishlist w ON j.id_juego = w.id_juego
GROUP BY j.titulo;

/* 46. Muestra todos los usuarios y cuántos amigos tienen, mostrando también aquellos sin ninguna amistad. */
SELECT u.nombre_usuario, COUNT(a.id_amigo2) AS NUM_AMIGOS
FROM usuario u
LEFT JOIN amistad a ON u.id_usuario = a.id_amigo1
GROUP BY u.nombre_usuario;

/* 47. Muestra por cada combinación (plataforma, género principal) cuántos juegos hay que cumplan ambas condiciones. */
SELECT p.nombre_plataforma, g.nombre_genero, COUNT(jp.id_juego) AS NUM_JUEGOS
FROM plataforma p
JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
JOIN juego j ON jp.id_juego = j.id_juego
JOIN genero g ON j.id_genero1 = g.id_genero
GROUP BY p.nombre_plataforma, g.nombre_genero;

/* 48. Muestra por cada usuario el número de compras que ha hecho en 2024, pero solo aquellos que hayan comprado en 2024 y tengan al menos 3 compras ese año. */
SELECT u.nombre_usuario, COUNT(c.id_compra) AS NUM_COMPRAS_2024
FROM usuario u
JOIN compra c ON u.id_usuario = c.id_usuario
WHERE EXTRACT(YEAR FROM c.fecha_compra) = 2024
GROUP BY u.nombre_usuario
HAVING COUNT(c.id_compra) >= 3;

/* 49. Muestra por cada juego el número de reseñas escritas en 2024 y la media de puntuación en 2024, pero solo los juegos con al menos 5 reseñas ese año. */
SELECT r.id_juego,
       COUNT(*) AS NUM_RESEÑAS_2024,
       AVG(r.puntuacion) AS PUNTUACION_MEDIA_2024
FROM reseña r
WHERE EXTRACT(YEAR FROM r.fecha_resena) = 2024
GROUP BY r.id_juego
HAVING COUNT(*) >= 5;

/* 50. Muestra por cada desarrollador el número total de reseñas recibidas por los juegos que ha desarrollado y la media de puntuación de esas reseñas. */
SELECT d.nombre AS NOMBRE_DESARROLLADOR,
       COUNT(r.id_resena) AS NUM_RESEÑAS,
       AVG(r.puntuacion) AS PUNTUACION_MEDIA
FROM desarrollador d
JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
JOIN juego j ON jd.id_juego = j.id_juego
JOIN reseña r ON j.id_juego = r.id_juego
GROUP BY d.nombre;