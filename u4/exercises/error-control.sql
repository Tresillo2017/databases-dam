-- Ejercicio 1. Crea un procedimiento que reciba el título y precio de un juego. Si el precio es menor a 0, lanza un error con SIGNAL.
DELIMITER $$

CREATE PROCEDURE insertar_juego(
    IN p_titulo VARCHAR(100),
    IN p_precio DECIMAL(10,2)
)
BEGIN
    IF p_precio < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'EL precio no puede ser menor que 0';
    ELSE
        INSERT INTO juego(idjuego, titulo, precio)
        VALUES (UUID(), p_titulo, p_precio);
    END IF;
end $$;

DELIMITER ;

-- Ejercicio 2. Crea un procedimiento que impida que un usuario compre dos veces el mismo juego. Usa SIGNAL si ya lo compró.
DELIMITER $$

CREATE PROCEDURE hacer_compra(
    IN p_idusuario VARCHAR(10),
    IN p_idjuego VARCHAR(10),
    IN p_metodopago VARCHAR(50)
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM compra
        WHERE idusuario = p_idusuario
            AND idjuego = p_idjuego
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario ya compro este juego';
    ELSE
        INSERT INTO compra(idcompra, idusuario, idjuego, fechacompra, metodopago)
        VALUES (UUID(), p_idusuario, p_idjuego, CURDATE(), p_metodopago);
    END IF;
END $$

DELIMITER ;

-- Ejercicio 3. Crea un procedimiento que verifique que el nombre del usuario no sea menor a 3 caracteres. Si lo es, lanza un error con SIGNAL. Usa CHAR_LENGTH
DELIMITER $$

CREATE PROCEDURE insertar_usuario(
    IN id_usuario   VARCHAR(10),
    IN p_nombre     VARCHAR(50),
    IN p_email      VARCHAR(100)
)
BEGIN
    IF CHAR_LENGTH(p_nombre) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El nombre debe tener al menos 3 caracteres';
    ELSE
        INSERT INTO usuario(idusuario, nombreusuario, email, fecharegistro)
        VALUES (p_idusuario, p_nombnre, p_email, CURDATE());
    END IF;
END$$

DELIMITER ;

-- Ejercicio 4. Crea un procedimiento que reciba IDs y lance un error con SIGNAL si el desarrollador no existe.
DELIMITER $$

CREATE PROCEDURE vincular_juego_desarrollador(
    IN p_idjuego    VARCHAR(10),
    IN p_iddesarrollador    VARCHAR(10)
)
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM desarrollador
        WHERE iddesarrollador = p_iddesarrollador
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'EL desarrollador no existe';
    ELSE
        INSERT INTO juegodesarrollador(idjuego, iddesarrollador)
        VALUES (p_idjuego, p_iddesarrollador);
    END IF;
END$$

DELIMITER ;