-- Ejercicio 1
-- Muestra los juegos cuyo precio sea superior al precio medio
-- de todos los juegos de la base de datos.
SELECT j.titulo, j.precio
FROM juego j
WHERE j.precio > (
    SELECT AVG(precio)
    FROM juego
);


-- ---------------------------------------------------------
-- Ejercicio 2
-- Muestra los juegos que pertenezcan a géneros que tengan
-- más de 20 juegos registrados.
SELECT j.titulo
FROM juego j
WHERE j.id_genero1 IN (
    SELECT id_genero1
    FROM juego
    GROUP BY id_genero1
    HAVING COUNT(*) > 20
);


-- ---------------------------------------------------------
-- Ejercicio 3
-- Muestra los juegos cuyo precio sea superior al precio
-- de algún juego del género 'Acción'.
SELECT j.titulo, j.precio
FROM juego j
WHERE j.precio > ANY (
    SELECT j2.precio
    FROM juego j2
             JOIN genero g ON g.id_genero = j2.id_genero1
    WHERE g.nombre_genero = 'Acción'
);


-- ---------------------------------------------------------
-- Ejercicio 4
-- Muestra los juegos cuya puntuación sea inferior a la puntuación
-- media de algún género existente.
SELECT j.titulo, j.puntuacion
FROM juego j
WHERE j.puntuacion < ANY (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
    GROUP BY j2.id_genero1
);


-- ---------------------------------------------------------
-- Ejercicio 5
-- Muestra los juegos cuya puntuación sea superior a la puntuación
-- media de los juegos del mismo género.
SELECT j.titulo, j.puntuacion
FROM juego j
WHERE j.puntuacion > (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
    WHERE j2.id_genero1 = j.id_genero1
);


-- ---------------------------------------------------------
-- Ejercicio 6
-- Muestra los desarrolladores que tengan más juegos desarrollados
-- que el desarrollador 'Capcom'.
SELECT d.nombre, COUNT(*) AS num_juegos
FROM desarrollador d
         JOIN juego_desarrollador jd ON jd.id_desarrollador = d.id_desarrollador
GROUP BY d.id_desarrollador, d.nombre
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM desarrollador d2
             JOIN juego_desarrollador jd2 ON jd2.id_desarrollador = d2.id_desarrollador
    WHERE d2.nombre = 'Capcom'
);


-- ---------------------------------------------------------
-- Ejercicio 7
-- Muestra los juegos que pertenezcan a plataformas que tengan
-- más juegos registrados que la plataforma 'Xbox One'.
SELECT DISTINCT j.titulo
FROM juego j
         JOIN juego_plataforma jp ON jp.id_juego = j.id_juego
WHERE jp.id_plataforma IN (
    SELECT jp2.id_plataforma
    FROM juego_plataforma jp2
    GROUP BY jp2.id_plataforma
    HAVING COUNT(*) > (
        SELECT COUNT(*)
        FROM juego_plataforma jp3
                 JOIN plataforma p ON p.id_plataforma = jp3.id_plataforma
        WHERE p.nombre_plataforma = 'Xbox One'
    )
);


-- ---------------------------------------------------------
-- Ejercicio 8
-- Muestra los juegos cuya puntuación sea superior a la puntuación media
-- de todos los juegos del desarrollador 'Nintendo'.
SELECT j.titulo, j.puntuacion
FROM juego j
WHERE j.puntuacion > (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
             JOIN juego_desarrollador jd ON jd.id_juego = j2.id_juego
             JOIN desarrollador d ON d.id_desarrollador = jd.id_desarrollador
    WHERE d.nombre = 'Nintendo'
);


-- ---------------------------------------------------------
-- Ejercicio 9
-- Muestra los fabricantes que tengan
-- más juegos registrados que el fabricante 'Sony'.
SELECT p.fabricante, COUNT(*) AS num_juegos
FROM plataforma p
         JOIN juego_plataforma jp ON jp.id_plataforma = p.id_plataforma
GROUP BY p.fabricante
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM plataforma p2
             JOIN juego_plataforma jp2 ON jp2.id_plataforma = p2.id_plataforma
    WHERE p2.fabricante = 'Sony'
);


-- ---------------------------------------------------------
-- Ejercicio 10
-- Muestra los juegos cuyo precio sea superior al precio medio
-- de los juegos que han sido añadidos a alguna wishlist.
SELECT j.titulo, j.precio
FROM juego j
WHERE j.precio > (
    SELECT AVG(j2.precio)
    FROM juego j2
             JOIN wishlist w ON w.id_juego = j2.id_juego
);


-- ---------------------------------------------------------
-- Ejercicio 11
-- Muestra los usuarios que hayan comprado algún juego
-- cuyo precio sea superior al precio medio de todos los juegos.
SELECT DISTINCT u.nombre_usuario
FROM usuario u
         JOIN compra c ON c.id_usuario = u.id_usuario
         JOIN juego j ON j.id_juego = c.id_juego
WHERE j.precio > (
    SELECT AVG(precio)
    FROM juego
);


-- ---------------------------------------------------------
-- Ejercicio 12
-- Muestra los juegos que estén disponibles en plataformas
-- lanzadas después del año 2018.
SELECT DISTINCT j.titulo
FROM juego j
         JOIN juego_plataforma jp ON jp.id_juego = j.id_juego
         JOIN plataforma p ON p.id_plataforma = jp.id_plataforma
WHERE YEAR(p.fecha_lanzamiento) > 2018;


-- ---------------------------------------------------------
-- Ejercicio 13
-- Muestra los juegos que hayan sido desarrollados por
-- desarrolladores cuyo número de trabajadores sea superior
-- al número medio de trabajadores de todos los desarrolladores.
SELECT j.titulo
FROM juego j
         JOIN juego_desarrollador jd ON jd.id_juego = j.id_juego
         JOIN desarrollador d ON d.id_desarrollador = jd.id_desarrollador
WHERE d.numero_trabajadores > (
    SELECT AVG(numero_trabajadores)
    FROM desarrollador
);


-- ---------------------------------------------------------
-- Ejercicio 14
-- Muestra los juegos cuya puntuación sea superior a la puntuación
-- media de los juegos que tienen al menos una reseña.
SELECT j.titulo, j.puntuacion
FROM juego j
WHERE j.puntuacion > (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
             JOIN resena r ON r.id_juego = j2.id_juego
);


-- ---------------------------------------------------------
-- Ejercicio 15
-- Muestra los juegos cuya puntuación sea inferior a la puntuación
-- media de los juegos comprados por usuarios del mismo país.
SELECT j.titulo, j.puntuacion
FROM juego j
         JOIN compra c ON c.id_juego = j.id_juego
         JOIN usuario u ON u.id_usuario = c.id_usuario
WHERE j.puntuacion < (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
             JOIN compra c2 ON c2.id_juego = j2.id_juego
             JOIN usuario u2 ON u2.id_usuario = c2.id_usuario
    WHERE u2.pais = u.pais
);


-- ---------------------------------------------------------
-- Ejercicio 16
-- Muestra los juegos que sean los más caros
-- dentro de cada plataforma en la que estén disponibles.
SELECT j.titulo, p.nombre_plataforma, j.precio
FROM juego j
         JOIN juego_plataforma jp ON jp.id_juego = j.id_juego
         JOIN plataforma p ON p.id_plataforma = jp.id_plataforma
WHERE j.precio = (
    SELECT MAX(j2.precio)
    FROM juego j2
             JOIN juego_plataforma jp2 ON jp2.id_juego = j2.id_juego
    WHERE jp2.id_plataforma = p.id_plataforma
);


-- ---------------------------------------------------------
-- Ejercicio 17
-- Muestra los juegos cuyo precio sea superior al precio medio
-- de los juegos disponibles en las mismas plataformas que ese juego.
SELECT DISTINCT j.titulo, j.precio
FROM juego j
WHERE j.precio > (
    SELECT AVG(j2.precio)
    FROM juego j2
             JOIN juego_plataforma jp2 ON jp2.id_juego = j2.id_juego
    WHERE jp2.id_plataforma IN (
        SELECT jp3.id_plataforma
        FROM juego_plataforma jp3
        WHERE jp3.id_juego = j.id_juego
    )
);


-- ---------------------------------------------------------
-- Ejercicio 18
-- Muestra los juegos cuya puntuación sea superior a la puntuación media
-- de los juegos comprados por el mismo usuario que los ha comprado.
SELECT DISTINCT j.titulo, j.puntuacion
FROM juego j
         JOIN compra c ON c.id_juego = j.id_juego
WHERE j.puntuacion > (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
             JOIN compra c2 ON c2.id_juego = j2.id_juego
    WHERE c2.id_usuario = c.id_usuario
);


-- ---------------------------------------------------------
-- Ejercicio 19
-- Muestra los juegos cuyo precio sea inferior al precio medio
-- de los juegos desarrollados por los mismos desarrolladores.
SELECT j.titulo, j.precio
FROM juego j
         JOIN juego_desarrollador jd ON jd.id_juego = j.id_juego
WHERE j.precio < (
    SELECT AVG(j2.precio)
    FROM juego j2
             JOIN juego_desarrollador jd2 ON jd2.id_juego = j2.id_juego
    WHERE jd2.id_desarrollador = jd.id_desarrollador
);


-- ---------------------------------------------------------
-- Ejercicio 20
-- Muestra los juegos cuya puntuación sea superior a la puntuación media
-- de los juegos que han sido añadidos a la wishlist por los mismos usuarios.
-- (NO MUESTRA NADA)
SELECT  j.titulo, j.puntuacion
FROM juego j
         JOIN wishlist w ON w.id_juego = j.id_juego
WHERE j.puntuacion > (
    SELECT AVG(j2.puntuacion)
    FROM juego j2
             JOIN wishlist w2 ON w2.id_juego = j2.id_juego
    WHERE w2.id_usuario = w.id_usuario
);