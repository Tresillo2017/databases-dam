-- Ejercicio 1
-- Muestra el nombre del género, la cantidad de juegos que tiene y el precio medio de sus títulos.
-- Solo queremos considerar aquellos géneros que contengan juegos desarrollados por
-- estudios cuyo país de origen sea 'Japón'.

SELECT g.nombre_genero, COUNT(j.id_juego), AVG(j.precio)
FROM juego j
         JOIN genero g ON j.id_genero1 = g.id_genero
WHERE g. nombre_genero IN (
    SELECT g.nombre_genero
    FROM genero g
             JOIN juego j ON g.id_genero = j.id_genero1
             JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
             JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
    WHERE d.pais_origen = 'Japon'
) GROUP BY g.nombre_genero;

SELECT g.nombre_genero
FROM genero g
         JOIN juego j ON g.id_genero = j.id_genero1
         JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
         JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
WHERE d.pais_origen = 'Japon';


-- Ejercicio 2
-- Muestra el nombre, país y total de trabajadores de aquellos desarrolladores que hayan publicado juegos en plataformas fabricadas
-- por 'Sony' y que tengan más de 100 trabajadores.

SELECT nombre, pais_origen, numero_trabajadores
FROM desarrollador
WHERE nombre IN (
    SELECT d.nombre
    FROM desarrollador d
             JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
             JOIN juego j ON jd.id_juego = j.id_juego
             JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
             JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
    WHERE p.fabricante = 'Sony'
) AND numero_trabajadores > 100
;


SELECT d.nombre
FROM desarrollador d
         JOIN juego_desarrollador jd ON d.id_desarrollador = jd.id_desarrollador
         JOIN juego j ON jd.id_juego = j.id_juego
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.fabricante = 'Sony';


-- Ejercicio 3
-- Muestra los usuarios (nombre y país) y el total de dinero que han gastado en compras de aquellos usuarios que hayan
-- comprado algún juego cuyo precio sea menor que cualquier precio de los juegos del género 'Shooter'.
SELECT u.nombre_usuario, u.pais, SUM(j.precio)
FROM usuario u
         JOIN compra c ON u.id_usuario = c.id_usuario
         JOIN juego j ON c.id_juego = j.id_juego
WHERE u.nombre_usuario IN (
    SELECT u.nombre_usuario
    FROM usuario u
             JOIN compra c ON u.id_usuario = c.id_usuario
             JOIN juego j ON c.id_juego = j.id_juego
    WHERE j.precio <  ANY (
        SELECT j.precio
        FROM juego j
                 JOIN genero g ON j.id_genero1 = g.id_genero
        WHERE g.nombre_genero = 'Shooter'
    )
)GROUP BY u.nombre_usuario;


SELECT nombre_usuario
FROM usuario u
         JOIN compra c ON u.id_usuario = c.id_usuario
         JOIN juego j ON c.id_juego = j.id_juego
WHERE j.precio <  ANY (
    SELECT j.precio
    FROM juego j
             JOIN genero g ON j.id_genero1 = g.id_genero
    WHERE nombre_genero = 'Shooter'
) GROUP BY nombre_usuario;

SELECT j.precio
FROM juego j
         JOIN genero g ON j.id_genero1 = g.id_genero
WHERE nombre_genero = 'Shooter';


-- Ejercicio 4
-- Muestra el título y la puntuación de los juegos cuya puntuación sea mayor que todas las puntuaciones
-- de los juegos desarrollados por 'Ubisoft'.


SELECT j.titulo, r.puntuacion
FROM juego j
         JOIN resena r ON j.id_juego = r.id_juego
WHERE r.puntuacion > ALL (
    SELECT r.puntuacion
    FROM juego j
             JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
             JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
             LEFT JOIN resena r ON j.id_juego = r.id_juego
    WHERE d.nombre = 'Ubisoft'
      AND r.puntuacion IS NOT NULL
);


SELECT j.titulo, r.puntuacion
FROM juego j
         JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
         JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
         LEFT JOIN resena r ON j.id_juego = r.id_juego
WHERE d.nombre = 'Ubisoft';

SELECT j.titulo
FROM juego j
         JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
         JOIN desarrollador d ON jd.id_desarrollador = d.id_desarrollador
WHERE d.nombre = 'Ubisoft';







-- Ejercicio 5
-- Muestra el nombre de cada plataforma y la cantidad de juegos asociados a ellas. Mostrar solo plataformas donde existan juegos que, a su vez,
-- tengan reseñas escritas por usuarios de 'España'.

SELECT p.nombre_plataforma, COUNT(j.id_juego)
FROM plataforma p
         JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
         JOIN juego j ON jp.id_juego = j.id_juego
WHERE p.nombre_plataforma IN (
    SELECT p.nombre_plataforma
    FROM plataforma p
             JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
             JOIN juego j ON jp.id_juego = j.id_juego
             JOIN resena r ON j.id_juego = r.id_juego
             JOIN usuario u ON r.id_usuario = u.id_usuario
    WHERE u.pais = 'España'
      AND j.id_juego IS NOT NULL
    GROUP BY p.nombre_plataforma
) GROUP BY p.nombre_plataforma;


SELECT p.nombre_plataforma
FROM plataforma p
         JOIN juego_plataforma jp ON p.id_plataforma = jp.id_plataforma
         JOIN juego j ON jp.id_juego = jp.id_juego
         JOIN resena r ON j.id_juego = r.id_juego
         JOIN usuario u ON r.id_usuario = u.id_usuario
WHERE u.pais = 'España'
  AND j.id_juego IS NOT NULL
GROUP BY p.nombre_plataforma;





-- Ejercicio 6
-- Muestra los desarrolladores y la antigüedad de su estudio (años desde fundación) de aquellos desarrolladores
-- que hayan creado algún juego que sea una secuela (id_secuela IS NULL) y cuyo "padre" (el juego original) sea del género 'Acción'.






-- Ejercicio 7
-- Muestra el Ranking de usuarios (Top compradores) que han comprado "Juegos Premium".
-- Definimos "Juego Premium" como aquel cuyo precio es mayor que TODOS los precios
-- de los juegos del género 'Aventura'.
SELECT u.nombre_usuario, COUNT(j.id_juego)
FROM usuario u
         JOIN compra c ON u.id_usuario = c.id_usuario
         JOIN juego j ON c.id_juego = j.id_juego
WHERE j.precio >= ALL (
    SELECT j.precio
    FROM juego j
             JOIN genero g ON j.id_genero1 = g.id_genero
    WHERE g.nombre_genero = 'Aventura'
      AND j.precio IS NOT NULL
)GROUP BY u.nombre_usuario
ORDER BY COUNT(j.id_juego) DESC;


SELECT j.precio
FROM juego j
         JOIN genero g ON j.id_genero1 = g.id_genero
WHERE g.nombre_genero = 'Aventura';


-- Ejercicio 8
-- Muestra los usuarios que NO han realizado ninguna compra de juegos desarrollados
-- por 'EA'. Queremos ver su nombre y cuántos amigos (id_amigo2) tienen.





-- Ejercicio 9
-- Muestra los géneros que tienen una puntuación media superior a la de 'RPG',
-- pero calculando dicha media solo con juegos que estén disponibles en PC.

SELECT g.nombre_genero
FROM genero g
         JOIN juego j ON g.id_genero = j.id_genero1
         JOIN resena r ON j.id_juego = r.id_juego
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE p.nombre_plataforma = 'PC'
GROUP BY g.nombre_genero
HAVING AVG(r.puntuacion) > (
    SELECT AVG(r.puntuacion)
    FROM juego j
             JOIN resena r ON j.id_juego = r.id_juego
             JOIN genero g ON j.id_genero1 = g.id_genero
             JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
             JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
    WHERE p.nombre_plataforma = 'PC'
      AND g.nombre_genero = 'RPG'
) ;

SELECT AVG(r.puntuacion)
FROM juego j
         JOIN resena r ON j.id_juego = r.id_juego
         JOIN genero g ON j.id_genero1 = g.id_genero
         JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
         JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE nombre_plataforma = 'PC'
  AND g.nombre_genero = 'RPG';