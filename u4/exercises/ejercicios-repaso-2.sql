-- Crea un PROCEDURE ActualizarEstadoCanal(IN pnombrecanal VARCHAR(25), IN pestado VARCHAR(20))
DROP PROCEDURE IF EXISTS ActualizarEstadoCanal;
DELIMITER $$

CREATE PROCEDURE ActualizarEstadoCanal(
    IN pnombrecanal VARCHAR(25),
    IN pestado VARCHAR(20)
)
BEGIN
    DECLARE v_existe_canal INT DEFAULT 0;
    DECLARE v_directos_emision INT DEFAULT 0;

    -- 1. Canal existe?
    SELECT COUNT(*) INTO v_existe_canal FROM canal WHERE nombre_canal = pnombrecanal;
    IF v_existe_canal = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El canal no existe';
    end if ;

    -- 2. Estado valido?
    IF pestado NOT IN ('activo', 'pausado', 'archivado') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Estado invalido';
    end if ;

    -- 3. Si archivado, directos en emision?
    IF pestado = 'archivado' THEN
        SELECT COUNT(*) INTO v_directos_emision
        FROM canal c JOIN directo d ON c.id_canal = d.id_canal
        WHERE c.nombre_canal = pnombrecanal
        AND d.fecha_inicio <= NOW() AND (d.fecha_fin IS NULL OR d.fecha_fin > NOW());
        IF v_directos_emision > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Canal con directos en emision no se puede archivar';
        END IF ;
    END IF ;

    -- 4. Actualizar
    UPDATE canal SET estado = pestado WHERE nombre_canal = pnombrecanal;
    SELECT 'Actualizado OK' AS resultado, pnombrecanal AS canal, pestado AS estado;
END ;
DELIMITER ;


CALL ActualizarEstadoCanal('Canal de Ibai','pausado');


-- EJERCICIO 1
-- Crea un procedimiento que reciba un id_juego.
-- Debe:
-- 1. Obtener el precio del juego y su fecha_lanzamiento.
-- 2. Calcular cuántos años han pasado desde su lanzamiento.
-- 3. Mostrar un mensaje con este formato:
--    'El juego [titulo] cuesta [precio] € y tiene [n] años de antigüedad'
-- 4. Si el juego no existe, lanzar SIGNAL.
-- 5. Si la fecha_lanzamiento es posterior a la actual o anterior a 1950, lanzar SIGNAL.
-- =====================================================

DROP PROCEDURE IF EXISTS ejercicio1;
DELIMITER $$
CREATE PROCEDURE ejercicio1(IN p_id_juego VARCHAR(10))
BEGIN
    DECLARE precio_juego DECIMAL(10,2);
    DECLARE fecha DATE;
    DECLARE titulo VARCHAR(50);
    DECLARE antiguedad INT;
    DECLARE v_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_existe FROM juego WHERE id_juego = p_id_juego;

    -- 1. Comprobar si el juego existe
    IF v_existe = 0
        THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, no existe juego con ese id';
    END IF;

    SELECT precio, fecha_lanzamiento, titulo
    INTO precio_juego, fecha, titulo
    FROM juego
    WHERE p_id_juego = id_juego;


    -- 2. Fecha lanzamiento no sea posterior a la actual y no anterior a 1950
    IF fecha > CURDATE() OR fecha < '1950-01-01'
        THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, fecha de lanzamiento incorrecta';
    END IF;

    -- 3. Calcular años antiguedad y mostrar el mensaje
    SELECT (TIMESTAMPDIFF(YEAR, fecha, CURDATE()))
        INTO antiguedad;
    SELECT CONCAT('El juego ', titulo,
                  ' cuesta ', precio_juego,
                  ' y tiene ', antiguedad, ' años de antiguedad') AS mensaje;

END $$
DELIMITER ;

CALL ejercicio1('J0001');



-- =====================================================
-- EJERCICIO 2
-- Crea una función que reciba:
-- - id_juego
-- - porcentaje_descuento (INT)
-- Debe:
-- 1. Obtener el precio del juego.
-- 2. Calcular primero el descuento aplicado y después aplicar un 21% de IVA.
    -- Fórmula:
    -- precio_final = (precio - (precio * porcentaje_descuento / 100)) * 1.21
-- 3. Devolver el precio final.
-- 4. Si el juego no existe, lanzar SIGNAL.
-- 5. Si el descuento es negativo o 0, lanzar SIGNAL.

-- Subapartado:
-- Utiliza la función dentro de una consulta para mostrar:
-- titulo, precio y precio con iva y descuento (25%) de todos los juegos.
-- =====================================================

DROP FUNCTION IF EXISTS ejercicio2;
DELIMITER $$
CREATE FUNCTION ejercicio2(p_id_juego VARCHAR(10), porcentaje_descuento INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE precio_juego DECIMAL(10,2);
    DECLARE precio_final DECIMAL(10,2);

    -- 1. Obtener precio juego
    SELECT j.precio
    INTO precio_juego
    FROM juego j
    WHERE j.id_juego = p_id_juego;

    -- 2. Comprobar si el juego existe
    IF precio_juego IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, el juego no existe';
    END IF;

    -- 3. Comprobar si el porcentaje descuento no es negativo
    IF porcentaje_descuento <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, el porcentaje de descuento no puede ser negativo';
    END IF;

    SET precio_final = (precio_juego - (precio_juego * porcentaje_descuento) / 100) * 1.21;
    RETURN precio_final;

END $$
DELIMITER ;

SELECT
    j.titulo,
    j.precio,
    ejercicio2(j.id_juego, 25) AS precio_con_iva_y_descuento
FROM juego j;


-- =====================================================
-- EJERCICIO 3
-- Crea un procedimiento que reciba dos id_jugador.
-- Debe:
-- 1. Obtener el nombre y los goles de ambos jugadores.
-- 2. Calcular la diferencia de goles entre ellos. TIP: Si la diferencia es negativa usar ABS() -> valor abosluto
-- 3. Mostrar:
--    'La diferencia de goles entre [jugador1] y [jugador2] es de [n]'
-- 4. Si alguno de los dos jugadores no existe, lanzar SIGNAL.
-- =====================================================

DROP PROCEDURE IF EXISTS ejercicio3;
DELIMITER $$
CREATE PROCEDURE ejercicio3(
    IN p_id_jugador1 VARCHAR(10),
    IN p_id_jugador2 VARCHAR(10)
)
BEGIN
    DECLARE nombre1 VARCHAR(50);
    DECLARE nombre2 VARCHAR(50);
    DECLARE goles1 INT;
    DECLARE goles2 INT;
    DECLARE diferencia INT;

    -- 1. Cargar datos de ambos jugadores
    SELECT nombre_jugador, goles
    INTO nombre1, goles1
    FROM jugador
    WHERE id_jugador = p_id_jugador1;

    SELECT nombre_jugador, goles
    INTO nombre2, goles2
    FROM jugador
    WHERE id_jugador = p_id_jugador2;

    If nombre1 IS NULL OR nombre2 IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, alguno de los jugadores no existe';
    END IF;

    SET diferencia = ABS(goles1 - goles2);
    SELECT CONCAT(
           'La diferencia de goles entre ',
           nombre1, ' y ', nombre2,
           ' es de ', diferencia
           ) AS mensaje;

END $$
DELIMITER ;

USE jueguicos;
CALL ejercicio3('3', '4');

-- =====================================================
-- EJERCICIO 4
-- Crea un procedimiento que reciba dos id_jugador.
-- Debe:
-- 1. Obtener los goles de ambos jugadores.
-- 2. Calcular la media de goles entre ambos.
    -- Fórmula:
    -- media = goles_j1 + goles_j2 / 2
-- 3. Mostrar:
--    'La media de goles entre ambos jugadores es [media]'
-- 4. Si alguno no existe, lanzar SIGNAL.
-- =====================================================

DROP PROCEDURE IF EXISTS ejercicio4;
DELIMITER $$
CREATE PROCEDURE ejercicio4(
    IN p_id_jugador1 VARCHAR(10),
    IN p_id_jugador2 VARCHAR(10)
)
BEGIN
    DECLARE goles1 INT;
    DECLARE goles2 INT;
    DECLARE media DECIMAL(10,2);

    SELECT goles
    INTO goles1
    FROM jugador
    WHERE p_id_jugador1 = id_jugador;

    SELECT goles
    INTO goles2
    FROM jugador
    WHERE p_id_jugador2 = id_jugador;

    IF p_id_jugador1 IS NULL OR p_id_jugador2 IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error, un jugador no existe';
    END IF;

    SET media = (goles1 + goles2) / 2;
    SELECT CONTACT('La media de goles entre ambos jugadores es ', media) AS mensaje;
END $$
DELIMITER ;

-- =====================================================
-- EJERCICIO 5
-- Crea un procedimiento que reciba un id_usuario.
-- Debe:
-- 1. Obtener el nombre del usuario.
-- 2. Obtener el total gastado en compras.
-- 3. Obtener el número de compras realizadas.
-- 4. Calcular el gasto medio por compra.
    -- Fórmula:
    -- gasto_medio = total_gastado / numero_compras
-- 5. Mostrar:
--    'Usuario: [nombre] | Gasto medio: [importe] €'
-- 6. Si el usuario no existe, lanzar SIGNAL.
-- 7. Si no tiene compras, lanzar SIGNAL.
-- =====================================================

-- =====================================================
-- EJERCICIO 6
-- Crea una función que reciba un id_jugador

-- Debe:
-- 1. Obtener los goles del jugador.
-- 2. Obtener el equipo al que pertenece.
-- 3. Obtener el total de goles de su equipo.
-- 4. Calcular qué porcentaje representan los goles del jugador
--    respecto al total de su equipo.
    -- Fórmula:
    -- porcentaje = goles_jugador / total_goles_equipo * 100
-- 5. Si el jugador no existe, lanzar SIGNAL.
-- 6. Si el equipo no tiene goles, devolver 0. (IFNULL() 😉)
--
-- Subapartado:
-- Utiliza la función dentro de una consulta para mostrar:
-- nombre, goles, nombre del equipo y su porcentaje de goles de su equipo de todos los jugadores
-- =====================================================

-- =====================================================
-- EJERCICIO 7
-- Crea un procedimiento que reciba dos id_jugador.
-- Debe:
-- 1. Obtener nombre y edad de ambos jugadores.
-- 2. Calcular la diferencia de edad. (ABS() por si la diferencia es negativa)
-- 3. Mostrar cuál de los dos es mayor y por cuántos años.
-- 4. Si alguno no existe, lanzar SIGNAL.
-- =====================================================

-- =====================================================
-- EJERCICIO 8
-- Crea una función que reciba un id_juego

-- Debe:
-- 1. Obtener el precio del juego y el número de veces que ha sido comprado.
-- 2. Calcular la recaudación estimada multiplicando precio por unidades.
-- 3. Devolver el resultado.
-- 4. Si el juego no existe, devolver NULL.
-- 5. Si las unidades son negativas, devolver NULL.
--
-- Subapartado:
-- Utiliza la función en una consulta para mostrar:
-- titulo, precio y recaudacion_estimada_juego(id_juego, 1000)
-- =====================================================

DROP FUNCTION IF EXISTS ejercicio8;
DELIMITER $$
CREATE FUNCTION ejercicio8(
    p_id_juego VARCHAR(10),
    p_unidades INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE existe INT;

    SELECT COUNT(*)
    INTO existe
    FROM juego
    WHERE id_juego = p_id_juego;

    IF existe = 0 THEN
        RETURN NULL;
    END IF;

    IF p_unidades < 0 THEN
        RETURN NULL;
    END IF ;

    SELECT precio
    INTO v_precio
    FROM juego
    WHERE id_juego = p_id_juego;

    SET v_total = v_precio * p_unidades;
    RETURN v_total;
END $$

SELECT
    j.titulo,
    j.precio,
    ejercicio8(j.id_juego, 1000) AS recaudacion_estimada
FROM juego j;


-- =====================================================
-- EJERCICIO 9
-- Crea una función que reciba:
    -- id_juego.
    -- nombre_pataforma (VARCHAR)
-- Debe:
-- 1. Obtener la puntuación del juego.
-- 2. Obtener la puntuación media de todos los juegos de la plataforma introducida.
-- 3. Calcular la diferencia entre ambos valores.
-- 4. Devolver dicha diferencia.
-- 5. Si el juego o la plataforma no existe, lanza SIGNAL.
-- 6. Se debe controlar que el juego introducido pertenezca a la plataforma introducida, si no, lanzar SIGNAL
-- (investigad)

-- Subapartado:
-- Utiliza la función en una consulta para mostrar:
-- titulo, puntuacion y diferencia entre la puntuación del juego y la puntuación media de todos los
-- juegos de Nintendo Switch
-- =====================================================

DROP FUNCTION IF EXISTS ejercicio9;
DELIMITER $$
CREATE FUNCTION ejercicio9(
    p_id_juego VARCHAR(10),
    p_nombre_plataforma VARCHAR(50)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_puntuacion_juego INT;
    DECLARE v_media_plataforma DECIMAL(10,2);
    DECLARE v_id_plataforma VARCHAR(10);
    DECLARE v_existe INT;

    SELECT id_plataforma
    INTO v_id_plataforma
    FROM plataforma
    WHERE nombre_plataforma = p_nombre_plataforma;

    IF v_id_plataforma IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La plataforma no existe';
    END IF;

    SELECT COUNT(*)
    INTO v_existe
    FROM juego_plataforma
    WHERE id_juego = p_id_juego
        AND id_plataforma = v_id_plataforma;

    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'EL juego no pertenece a esa plataforma';
    END IF;

    SELECT puntuacion
    INTO v_puntuacion_juego
    FROM juego
    WHERE id_juego = p_id_juego;

    IF v_puntuacion_juego IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El juego no existe';
    END IF;

    SELECT AVG(j.puntuacion)
    INTO v_media_plataforma
    FROM juego j
    JOIN juego_plataforma jp ON jp.id_juego = j.id_juego
    WHERE jp.id_plataforma = v_id_plataforma;

    RETURN v_puntuacion_juego = v_id_plataforma;
END $$

-- =====================================================
-- EJERCICIO 10
-- Crea un procedimiento que reciba un id_jugador.
-- Debe:
-- 1. Obtener los goles del jugador.
-- 2. Obtener la media de goles de todos los jugadores de su mismo equipo.
-- 3. Calcular cuántos goles está por encima o por debajo de esa media.
-- 4. Mostrar:
--    '[nombre] está [n] goles por [encima/debajo] de la media de su equipo'
-- 5. Si el jugador no existe, lanzar SIGNAL.
-- =====================================================
