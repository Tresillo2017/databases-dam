-- Plantilla procedure
DELIMITER $$
CREATE PROCEDURE  nombre_proc(IN p_x INT)
BEGIN
    DECLARE v_y INT;
    -- codigo
END $$
DELIMITER ;

-- Plantilla function
DELIMITER $$
CREATE FUNCTION nombre_fun(p_x INT)
RETURNS INT
BEGIN
    DECLARE v_Y INT;
    -- codigo
    RETURN v_y;
END $$
DELIMITER ;


-- Crea un procedimiento 'incrementar_si_positivo' que reciba un numero por parametro INOUT, Si el numero es mayor o igual que 0, le suma 1. Si es negativo, no lo toca y devuelve el mismo valor
DELIMITER $$

CREATE PROCEDURE incrementar_si_positivo(INOUT p_num INT)
BEGIN
    IF p_num >= 0 THEN
        SET p_num = p_num + 1;
    ELSE
        SELECT p_num AS valor_negativo;
    END IF;
END $$

DELIMITER ;

SET @x = 5;
CALL incrementar_si_positivo(@x)
SELECT @x;

-- Crea una funcion 'cuadrado_num' que reciba un numero entero y devuelva su cuadrado. Usa una variable local dentro de la funcion y pruebala en un SELECT
DELIMITER $$

CREATE FUNCTION cuadrado_num(p_num INT)
RETURNS INT
BEGIN
    DECLARE c_result INT;
    SET c_result = p_num * p_num;
    RETURN c_result;
END $$

DELIMITER ;

SELECT cuadrado_num(5);

-- Crea un procedimiento 'tabla_multiplicar' que reciba un numero 'n' (IN) y muestre su tabla de multiplicar del 1 al 10 usando un bucle 'WHILE'
DELIMITER $$

CREATE PROCEDURE tabla_multiplicar(IN p_n INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE 1 <= 10 DO
        SELECT p_n, i, p_n * i;
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

-- Crea un procedimiento 'insertar_usuario_seguro' que reciba 'p_nombre_usuario' y 'p_email'.
-- Intente insertar en la tabla usuario. Si ocurre algun error (por ejemplo, email duplicado), debe lanzar un error personalizado con el mensaje
-- 'Error: el usuario ya existe o los datos no son validos.' usando EXIT HANDLER y SIGNAL
DELIMITER $$

CREATE PROCEDURE insertar_usuario_seguro(
    IN p_nombre_usuario VARCHAR(50),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: el usuario ya existe o los datos no son validos.';
    INSERT INTO usuario(nombre_usuario, email)
    VALUES (p_nombre_usuario, p_email);
END $$

DELIMITER ;

-- Crea un procedimiento que reciba el email de un usuario.
-- Si el email NO contiene el caracter '@', lanza un error con SIGNAL SQLSTATE '45000', diciendo que el email no es valido. Usa LOCATE('@', p_email) en la condicion.
DELIMITER $$

CREATE PROCEDURE email_usuario(
    IN p_email_usuario VARCHAR(50)
)
BEGIN
    IF LOCATE('@', p_email_usuario) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: el email no es valido';
    END IF;
END $$

-- Crea un procedimiento que reciba el ID de un juego y una cantidad de stock a restar.
-- Si la cantidad es menor o igual que 0, lanza un error con SIGNAL.
-- Si el stock actual del juego es menor que la cantidad a restar, también lanza un error con SIGNAL diciendo que no hay stock suficiente.
DELIMITER $$

CREATE PROCEDURE restar_stock(
    IN p_id_juego INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_stock_actual INT;

    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: la cantidad debe ser mayor que 0.';
    END IF;

    SELECT stock
    INTO v_stock_actual
    FROM juego
    WHERE id_juego = p_id_juego;

    IF v_stock_actual < p_cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: no hay stock suficiente';
    ELSE
        UPDATE juego
        SET stock = stock - p_cantidad;
        WHERE id_juego = p_id_juego;
    END IF;
END $$

DELIMITER ;

-- “Crea un procedimiento comprobar_genero que reciba el nombre de un género de juego (p_nombre_genero).
-- Si el género no existe en la tabla genero, lanza un error con SIGNAL.”
DELIMITER $$

CREATE PROCEDURE comprobar_genero(IN p_nombre_genero VARCHAR(100))
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*)
    INTO v_total
    FROM genero
    WHERE nombre = p_nombre_genero;

    IF v_total = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: el genero no existe';
    END IF;
END $$

DELIMITER ;

-- “Crea un procedimiento comprobar_password que reciba una contraseña (p_password).
-- Si la contraseña tiene menos de 8 caracteres, lanza un error con SIGNAL diciendo
-- 'Error: la contraseña debe tener al menos 8 caracteres.'
-- Usa CHAR_LENGTH(p_password).”
DELIMITER $$

CREATE PROCEDURE comprobar_password(
    IN p_password VARCHAR(120)
)
BEGIN
    IF CHAR_LENGTH(p_password) < 8 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: la password debe tener al menos 8 caracteres';
    END IF ;
END $$
