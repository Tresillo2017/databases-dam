-- JUEGUICOS

-- Ejercicio 1. Crea un procedimiento que reciba el nombre de una plataforma y muestre todos los títulos de los juegos disponibles en ella.
DELIMITER $$

CREATE PROCEDURE nombre_plataforma(
    IN p_nombre_plataforma CHAR(50)
)
BEGIN
    SELECT j.titulo
    FROM juego j
    INNER JOIN juego_plataforma jp ON j.id_juego = jp.id_juego
    INNER JOIN plataforma p ON jp.id_plataforma = p.id_plataforma
    WHERE p.nombre_plataforma = p_nombre_plataforma;
END $$

DELIMITER ;


-- Ejercicio 2. Crea un procedimiento que reciba el nombre de un usuario y muestre los títulos de los juegos que ha comprado.
DELIMITER $$

CREATE PROCEDURE juegos_por_usuario(
    IN p_nombre_usuario CHAR(50)
)
BEGIN
    SELECT j.titulo
    FROM juego j
    INNER JOIN compra c ON j.id_juego = c.id_juego
    INNER JOIN usuario u ON c.id_usuario = u.id_usuario
    WHERE u.nombre_usuario = p_nombre_usuario;
END $$

DELIMITER ;


-- Ejercicio 3. Crea un procedimiento que reciba id de un juego y muestre todas las reseñas que ha recibido.
DELIMITER $$

CREATE PROCEDURE resenas_juego(
    IN p_id_juego VARCHAR(10)
)
BEGIN
    SELECT r.id_resena, r.puntuacion, r.comentario, r.fecha, u.nombre_usuario
    FROM resena r
    INNER JOIN juego j ON r.id_juego = j.id_juego
    INNER JOIN usuario u ON r.id_usuario = u.id_usuario
    WHERE j.id_juego = p_id_juego;
END $$

DELIMITER ;


-- Ejercicio 4. Crea un procedimiento que reciba una puntuación y muestre los juegos con puntuación mayor o igual a la indicada.
DELIMITER $$

CREATE PROCEDURE juegos_por_puntuacion(
    IN p_puntuacion INT
)
BEGIN
    SELECT id_juego, titulo, puntuacion, precio
    FROM juego
    WHERE puntuacion >= p_puntuacion
    ORDER BY puntuacion DESC;
END $$

DELIMITER ;


-- Ejercicio 5. Crea una función que devuelva una calificación en texto a partir de la puntuación de un juego:
-- ≥9 → "Obra Maestra",
-- ≥7 → "Muy Bueno",
-- ≥5 → "Regular",
-- <5 → "Malo".
-- Utilizando la función, muestra los juegos junto a su calificación.
DELIMITER $$

CREATE FUNCTION calificar_juego(p_puntuacion INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE calificacion VARCHAR(50);

    IF p_puntuacion >= 9 THEN
        SET calificacion = 'Obra Maestra';
    ELSEIF p_puntuacion >= 7 THEN
        SET calificacion = 'Muy Bueno';
    ELSEIF p_puntuacion >= 5 THEN
        SET calificacion = 'Regular';
    ELSE
        SET calificacion = 'Malo';
    END IF;

    RETURN calificacion;
END $$

DELIMITER ;

-- Muestra de resultados con la función:
SELECT titulo, puntuacion, calificar_juego(puntuacion) AS calificacion
FROM juego
ORDER BY puntuacion DESC;


-- Ejercicio 6. Crea una función que reciba un desarrollador y calcule el precio promedio de sus juegos desarrollados.
-- Utilizando la función, muestra el nombre del desarrollador y el precio promedio de sus juegos.
DELIMITER $$

CREATE FUNCTION precio_promedio_desarrollador(p_id_desarrollador VARCHAR(10))
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(10, 2);

    SELECT AVG(j.precio) INTO promedio
    FROM juego j
    INNER JOIN juego_desarrollador jd ON j.id_juego = jd.id_juego
    WHERE jd.id_desarrollador = p_id_desarrollador;

    RETURN IFNULL(promedio, 0);
END $$

DELIMITER ;

-- Muestra de resultados con la función:
SELECT d.nombre, precio_promedio_desarrollador(d.id_desarrollador) AS precio_promedio
FROM desarrollador d
ORDER BY precio_promedio DESC;


-- Ejercicio 7. Crea una función que el nombre de un género y calcule el precio total de todos los juegos que pertenecen a ese género. (Si queréis tener en cuenta ambos géneros se puede hacer un OR en el JOIN, lo vimos en la primera evaluación, investigad ;) )
-- Utilizando la función, muestra los géneros y su precio promedio.
DELIMITER $$

CREATE FUNCTION precio_total_genero(p_nombre_genero VARCHAR(50))
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10, 2);

    SELECT SUM(j.precio) INTO total
    FROM juego j
    INNER JOIN genero g ON (j.id_genero1 = g.id_genero OR j.id_genero2 = g.id_genero)
    WHERE g.nombre_genero = p_nombre_genero;

    RETURN IFNULL(total, 0);
END $$

DELIMITER ;

-- Muestra de resultados con la función:
SELECT DISTINCT nombre_genero, precio_total_genero(nombre_genero) AS precio_total
FROM genero
ORDER BY precio_total DESC;

-- FURBOH

-- Ejercicio 8. Crea un procedimiento que reciba el nombre de un equipo y muestre el nombre, posición y goles de sus jugadores.
DELIMITER $$

CREATE PROCEDURE jugadores_por_equipo(
    IN p_nombre_equipo VARCHAR(100)
)
BEGIN
    SELECT j.nombre, j.posicion, j.goles
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    WHERE e.nombre = p_nombre_equipo
    ORDER BY j.goles DESC;
END $$

DELIMITER ;


-- Ejercicio 9. Crea un procedimiento que muestre los jugadores que han marcado más de un número de goles dado como parámetro.
DELIMITER $$

CREATE PROCEDURE jugadores_por_goles(
    IN p_goles INT
)
BEGIN
    SELECT j.nombre, j.posicion, j.goles, e.nombre AS equipo
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    WHERE j.goles > p_goles
    ORDER BY j.goles DESC;
END $$

DELIMITER ;


-- Ejercicio 10. Crea una función que reciba un equipo y devuelva el porcentaje de partidos ganados (tabla partido).
-- Utilizando la función, muestra el nombre y el porcentaje de victorias del 'Real Madrid'.
DELIMITER $$

CREATE FUNCTION porcentaje_victorias(p_nombre_equipo VARCHAR(100))
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE victorias INT;
    DECLARE total_partidos INT;
    DECLARE porcentaje DECIMAL(5, 2);

    SELECT COUNT(CASE
        WHEN (equipo_local = e.id_equipo AND goles_local > goles_visitante)
             OR (equipo_visitante = e.id_equipo AND goles_visitante > goles_local)
        THEN 1
    END) INTO victorias
    FROM partido p, equipo e
    WHERE e.nombre = p_nombre_equipo
    AND (p.equipo_local = e.id_equipo OR p.equipo_visitante = e.id_equipo);

    SELECT COUNT(*) INTO total_partidos
    FROM partido p, equipo e
    WHERE e.nombre = p_nombre_equipo
    AND (p.equipo_local = e.id_equipo OR p.equipo_visitante = e.id_equipo);

    IF total_partidos = 0 THEN
        SET porcentaje = 0;
    ELSE
        SET porcentaje = (victorias / total_partidos) * 100;
    END IF;

    RETURN porcentaje;
END $$

DELIMITER ;

-- Muestra de resultados:
SELECT nombre, porcentaje_victorias(nombre) AS porcentaje_victorias
FROM equipo
WHERE nombre = 'Real Madrid';


-- Ejercicio 11. Crea una función que reciba un jugador y devuelva "Frágil" si tiene más de 3 lesiones, "Normal" si tiene entre 1 y 3, y "Sano" si no tiene lesiones.
-- Utilizando la función, muestra el nombre y la condición física de todos loss jugadores 'Sanos'.
DELIMITER $$

CREATE FUNCTION condicion_fisica(p_nombre_jugador VARCHAR(100))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE num_lesiones INT;
    DECLARE condicion VARCHAR(50);

    SELECT COUNT(*) INTO num_lesiones
    FROM lesion l
    INNER JOIN jugador j ON l.id_jugador = j.id_jugador
    WHERE j.nombre = p_nombre_jugador
    AND l.fecha_fin IS NULL;

    IF num_lesiones > 3 THEN
        SET condicion = 'Frágil';
    ELSEIF num_lesiones >= 1 THEN
        SET condicion = 'Normal';
    ELSE
        SET condicion = 'Sano';
    END IF;

    RETURN condicion;
END $$

DELIMITER ;

-- Muestra de resultados (solo jugadores Sanos):
SELECT j.nombre, condicion_fisica(j.nombre) AS condicion_fisica
FROM jugador j
HAVING condicion_fisica = 'Sano'
ORDER BY j.nombre;


-- Ejercicio 12. Crea un procedimiento que reciba el nombre de equipo y muestre los jugadores lesionados actuales de ese equipo.
DELIMITER $$

CREATE PROCEDURE jugadores_lesionados_equipo(
    IN p_nombre_equipo VARCHAR(100)
)
BEGIN
    SELECT j.nombre, l.descripcion, l.fecha_inicio
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    INNER JOIN lesion l ON j.id_jugador = l.id_jugador
    WHERE e.nombre = p_nombre_equipo
    AND l.fecha_fin IS NULL
    ORDER BY l.fecha_inicio DESC;
END $$

DELIMITER ;


-- Ejercicio 13. Crea un procedimiento que reciba dos equipos y devuelva cuál tiene más jugadores en plantilla.
DELIMITER $$

CREATE PROCEDURE equipo_mas_jugadores(
    IN p_equipo1 VARCHAR(100),
    IN p_equipo2 VARCHAR(100)
)
BEGIN
    DECLARE count1 INT;
    DECLARE count2 INT;

    SELECT COUNT(*) INTO count1
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    WHERE e.nombre = p_equipo1;

    SELECT COUNT(*) INTO count2
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    WHERE e.nombre = p_equipo2;

    IF count1 > count2 THEN
        SELECT CONCAT(p_equipo1, ' tiene más jugadores: ', count1) AS resultado;
    ELSEIF count2 > count1 THEN
        SELECT CONCAT(p_equipo2, ' tiene más jugadores: ', count2) AS resultado;
    ELSE
        SELECT CONCAT('Ambos equipos tienen la misma cantidad de jugadores: ', count1) AS resultado;
    END IF;
END $$

DELIMITER ;


-- Ejercicio 14. Crea una función que clasifique un equipo según su promedio de goles por jugador (≥ 7: "Ofensivo", ≥ 5: "Equilibrado", < 5: "Defensivo").
-- Utilizando la función, muestra el promedio de goles y el estilo de juego de todos los equipos.
DELIMITER $$

CREATE FUNCTION estilo_juego(p_nombre_equipo VARCHAR(100))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE promedio_goles DECIMAL(10, 2);
    DECLARE estilo VARCHAR(50);

    SELECT AVG(j.goles) INTO promedio_goles
    FROM jugador j
    INNER JOIN equipo e ON j.id_equipo = e.id_equipo
    WHERE e.nombre = p_nombre_equipo;

    IF IFNULL(promedio_goles, 0) >= 7 THEN
        SET estilo = 'Ofensivo';
    ELSEIF IFNULL(promedio_goles, 0) >= 5 THEN
        SET estilo = 'Equilibrado';
    ELSE
        SET estilo = 'Defensivo';
    END IF;

    RETURN estilo;
END $$

DELIMITER ;

-- Muestra de resultados:
SELECT e.nombre,
       ROUND(AVG(j.goles), 2) AS promedio_goles,
       estilo_juego(e.nombre) AS estilo_juego
FROM equipo e
LEFT JOIN jugador j ON e.id_equipo = j.id_equipo
GROUP BY e.id_equipo, e.nombre
ORDER BY promedio_goles DESC;


-- CONTROL ERRORES (Jueguicos)

-- Ejercicio 15. Crea un procedimiento que reciba un id_juego. Debe:
    -- 1. Comprobar si el juego existe.
    -- 2. Si no existe → SIGNAL
    -- 3. Si existe → mostrar su título y precio.
DELIMITER $$

CREATE PROCEDURE obtener_juego(
    IN p_id_juego VARCHAR(10)
)
BEGIN
    DECLARE juego_existe INT;

    SELECT COUNT(*) INTO juego_existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF juego_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El juego no existe';
    ELSE
        SELECT titulo, precio
        FROM juego
        WHERE id_juego = p_id_juego;
    END IF;
END $$

DELIMITER ;


-- Ejercicio 16. Crea una función que reciba un id_juego. Debe:
    -- - Si el juego no existe → SIGNAL
    -- - Si existe → devuelva el precio con un 21% de IVA aplicado.
-- Utilizando la función, muestra el título, el precio original y el precio con IVA de todos los juegos. Ordenados por precio con IVA DESC.
DELIMITER $$

CREATE FUNCTION precio_con_iva(p_id_juego VARCHAR(10))
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE juego_existe INT;
    DECLARE precio_base DECIMAL(10, 2);
    DECLARE precio_iva DECIMAL(10, 2);

    SELECT COUNT(*) INTO juego_existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF juego_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El juego no existe';
    END IF;

    SELECT precio INTO precio_base
    FROM juego
    WHERE id_juego = p_id_juego;

    SET precio_iva = precio_base * 1.21;

    RETURN precio_iva;
END $$

DELIMITER ;

-- Muestra de resultados:
SELECT titulo, precio, precio_con_iva(id_juego) AS precio_con_iva
FROM juego
ORDER BY precio_con_iva(id_juego) DESC;


-- Ejercicio 17. Crea un procedimiento que reciba id_usuario. Debe:
    -- - Si el usuario no tiene compras → SIGNAL
    -- - Si tiene compras → mostrar el nombre de usuario y el número total de compras.
DELIMITER $$

CREATE PROCEDURE compras_usuario(
    IN p_id_usuario VARCHAR(10)
)
BEGIN
    DECLARE num_compras INT;

    SELECT COUNT(*) INTO num_compras
    FROM compra
    WHERE id_usuario = p_id_usuario;

    IF num_compras = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no tiene compras registradas';
    ELSE
        SELECT u.nombre_usuario, num_compras AS total_compras
        FROM usuario u
        WHERE u.id_usuario = p_id_usuario;
    END IF;
END $$

DELIMITER ;


-- Ejercicio 18. Crea un procedimiento insertar_juego_seguro que reciba:
-- id_juego, titulo, precio, fecha_lanzamiento y tenga en cuenta las siguientes validaciones:
    -- 1. Juego duplicado → SIGNAL
    -- 2. Precio negativo → SIGNAL
    -- 3. Fecha futura → SIGNAL
    -- 4. Si todo es correcto → insertar y mostrar un mensaje de éxito.
DELIMITER $$

CREATE PROCEDURE insertar_juego_seguro(
    IN p_id_juego VARCHAR(10),
    IN p_titulo VARCHAR(100),
    IN p_precio DECIMAL(10, 2),
    IN p_fecha_lanzamiento DATE
)
BEGIN
    DECLARE juego_existe INT;

    -- Validar si el juego ya existe
    SELECT COUNT(*) INTO juego_existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF juego_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El juego ya existe en la base de datos';
    END IF;

    -- Validar precio negativo
    IF p_precio < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede ser negativo';
    END IF;

    -- Validar fecha futura
    IF p_fecha_lanzamiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de lanzamiento no puede ser futura';
    END IF;

    -- Insertar el juego
    INSERT INTO juego (id_juego, titulo, precio, fecha_lanzamiento)
    VALUES (p_id_juego, p_titulo, p_precio, p_fecha_lanzamiento);

    SELECT CONCAT('Juego ', p_titulo, ' insertado exitosamente') AS resultado;
END $$

DELIMITER ;


-- Ejercicio 19. Crea un procedimiento que reciba: id_compra, id_usuario, id_juego
-- Validar:
    -- 1. Usuario existe
    -- 2. Juego existe
    -- 3. No comprado previamente
DELIMITER $$

CREATE PROCEDURE registrar_compra_segura(
    IN p_id_compra VARCHAR(10),
    IN p_id_usuario VARCHAR(10),
    IN p_id_juego VARCHAR(10)
)
BEGIN
    DECLARE usuario_existe INT;
    DECLARE juego_existe INT;
    DECLARE compra_previa INT;

    -- Validar que el usuario existe
    SELECT COUNT(*) INTO usuario_existe
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    IF usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Validar que el juego existe
    SELECT COUNT(*) INTO juego_existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF juego_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El juego no existe';
    END IF;

    -- Validar que no haya compra previa
    SELECT COUNT(*) INTO compra_previa
    FROM compra
    WHERE id_usuario = p_id_usuario
    AND id_juego = p_id_juego;

    IF compra_previa > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ya ha comprado este juego anteriormente';
    END IF;

    -- Registrar la compra
    INSERT INTO compra (id_compra, id_usuario, id_juego, fecha_compra)
    VALUES (p_id_compra, p_id_usuario, p_id_juego, CURDATE());

    SELECT 'Compra registrada exitosamente' AS resultado;
END $$

DELIMITER ;


-- Ejercicio 20. Crea una función que reciba id_juego y
-- - Devuelva:
--     'GRATIS' -> Si su precio es 0 (utilizar IFNULL)
--     'BARATO' -> Si su precio está entre 1 y 20 (ambos incluidos)
--     'NORMAL' -> Si su precio está entre 20 y 40
--     'CARO' -> Si es superior 40
-- - Si no existe → 'NO EXISTE'
DELIMITER $$

CREATE FUNCTION clasificar_precio(p_id_juego VARCHAR(10))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE precio DECIMAL(10, 2);
    DECLARE juego_existe INT;
    DECLARE clasificacion VARCHAR(50);

    SELECT COUNT(*) INTO juego_existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF juego_existe = 0 THEN
        RETURN 'NO EXISTE';
    END IF;

    SELECT IFNULL(precio, 0) INTO precio
    FROM juego
    WHERE id_juego = p_id_juego;

    IF precio = 0 THEN
        SET clasificacion = 'GRATIS';
    ELSEIF precio >= 1 AND precio <= 20 THEN
        SET clasificacion = 'BARATO';
    ELSEIF precio > 20 AND precio <= 40 THEN
        SET clasificacion = 'NORMAL';
    ELSE
        SET clasificacion = 'CARO';
    END IF;

    RETURN clasificacion;
END $$

DELIMITER ;

-- Muestra de resultados:
SELECT id_juego, titulo, precio, clasificar_precio(id_juego) AS clasificacion
FROM juego
ORDER BY precio ASC;


-- Ejercicio 21. Crea una función que reciba id_usuario
-- - Devuelva:
--     'NOVATO' -> Si ha comprado menos de 5 juegos
--     'AFICIONADO' -> Si ha comprado entre 5 y 10 juegos
--     'PRO' -> Si ha comprado más de 10 juegos
-- - Si no existe → 'USUARIO NO EXISTE'
DELIMITER $$

CREATE FUNCTION clasificar_usuario(p_id_usuario VARCHAR(10))
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE usuario_existe INT;
    DECLARE num_compras INT;
    DECLARE clasificacion VARCHAR(50);

    SELECT COUNT(*) INTO usuario_existe
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    IF usuario_existe = 0 THEN
        RETURN 'USUARIO NO EXISTE';
    END IF;

    SELECT COUNT(*) INTO num_compras
    FROM compra
    WHERE id_usuario = p_id_usuario;

    IF num_compras < 5 THEN
        SET clasificacion = 'NOVATO';
    ELSEIF num_compras >= 5 AND num_compras <= 10 THEN
        SET clasificacion = 'AFICIONADO';
    ELSE
        SET clasificacion = 'PRO';
    END IF;

    RETURN clasificacion;
END $$

DELIMITER ;

-- Muestra de resultados:
SELECT u.id_usuario, u.nombre_usuario,
       COUNT(c.id_compra) AS total_compras,
       clasificar_usuario(u.id_usuario) AS nivel_usuario
FROM usuario u
LEFT JOIN compra c ON u.id_usuario = c.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
ORDER BY total_compras DESC;
