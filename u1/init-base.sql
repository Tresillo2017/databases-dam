-- Crear base de datos
CREATE DATABASE IF NOT EXISTS tienda_online;

-- Seleccionar la base de datos con la que trabajar
USE tienda_online;

-- Crear una tabla producto
CREATE TABLE IF NOT EXISTS producto
(
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre      VARCHAR(200),
    precio      DECIMAL(5, 2),
    stock       INT
    );

-- Crear tabla empleado
DROP TABLE IF EXISTS empleado;
CREATE TABLE IF NOT EXISTS empleado
(
    id_empleado    INT PRIMARY KEY AUTO_INCREMENT,     -- Clave primaria y auto incrementable
    email          VARCHAR(100) UNIQUE,                -- No permito almacenar datos duplicados
    nombre         VARCHAR(50) NOT NULL,               -- No permite almacenar datos vacios en este campo
    edad           INT,                                -- CHECK ( edad >= 18), -- Establezco una condicion previa antes de insertar datos en este campo (edad mayor a 18)
    fecha_contrato DATETIME DEFAULT NOW(),             -- Voy a almacenar un valor predeterminado en este campo.
-- NOW(): Funcion que devuelve la fecha y hora actual del sistema
    estado_civil   ENUM ('Soltero','Casado', 'Viudo'), -- Establezco un rango de valores permitidos en este campo
    id_producto    INT,
    FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
    -- FOREIGN KEY (campo que quiero que see la clave secundaria

    );

-- Inserccion de Datos
INSERT INTO producto (nombre, precio, stock)
VALUES ('Nintendo Switch', 339.99, 50), -- Indicando que valores voy a insertar en cada campo
       ('PlayStation 5 Pro', 869.99, 35),
       ('XBOX Serie X', 543.93, 9);

