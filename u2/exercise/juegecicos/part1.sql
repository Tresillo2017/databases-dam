/*
 Parte 1:

 Crear una base de datos para gestionar la información de una plataforma de videojuegos
 en streaming, incluyendo datos sobre usuarios, juegos, partidas multijugador, logros y
 comentarios sobre los juegos.

 ANOTACIÓN: Utilizar el comando USE para seleccionar la base de datos
 automáticamente, así como el comando CREATE TABLE/DATABASE IF NOT EXISTS para
 evitar que se vuelvan a crear las tablas y/o la base de datos una vez creadas.

 IMPORTANTE: Añadir comentarios sobre lo que se está haciendo.

 Instrucciones:

 1. Crear la base de datos llamada plataforma_videojuegos.

 2. Crear las siguientes tablas con las restricciones indicadas:

    o Juego:
       ▪ Debe incluir los campos id_juego (INT), titulo (VARCHAR), genero
         (VARCHAR), precio (DECIMAL), clasificacion_edad (INT) y
         disponibilidad (ENUM) con valores posibles ‘Disponible’, ‘No
         Disponible’, ‘Próximamente’.
       ▪ El campo precio no puede ser menor a 0 ni nulo.
       ▪ El campo clasificacion_edad debe ser un valor entre 3 y 18.
       ▪ El campo titulo no puede estar vacío y debe ser único.
       ▪ La disponibilidad tendrá como valor predeterminado 'Disponible'.

    o Usuario:
       ▪ Debe contener los campos id_usuario (INT), nombre_usuario
         (VARCHAR), email (VARCHAR), fecha_registro (DATETIME), pais
         (ENUM) con valores posibles ‘Estados Unidos’, ‘Reino Unido’,
         ‘Japón’, ‘España’, y ‘Brasil’, id_juego.
       ▪ El campo email debe ser único y debe ser obligatorio.
       ▪ La fecha_registro debe tener como valor predeterminado la fecha
         actual.
       ▪ El campo nombre_usuario no puede estar vacío y debe ser único.
       ▪ Establecer una relación con la tabla Juego a través de la clave
         foránea id_juego.

    o Partida
       ▪ Debe incluir los campos id_partida (INT), fecha_partida
         (DATETIME), id_juego, id_ganador, y duracion_minutos (INT).
       ▪ La fecha_partida debe tener como valor predeterminado la fecha
         actual.
       ▪ El campo duracion_minutos debe ser mayor a 0 y tener como valor
         predeterminado 30.
       ▪ Establecer una relación con la tabla Juego mediante el campo
         id_juego y con la tabla Usuario mediante id_ganador, que
         representa al usuario que ganó la partida.

    o Logro:
       ▪ Debe contener los campos id_logro (INT), nombre_logro
         (VARCHAR), descripcion (TEXT), dificultad (ENUM) con valores
         ‘Fácil’, ‘Medio’, y ‘Difícil’, puntos (INT), id_juego e id_usuario.
       ▪ El campo nombre_logro debe ser único y no puede ser vacío.
       ▪ El campo descripcion no puede estar vacío.
       ▪ El campo puntos debe ser un valor mayor a 0 y menor a 100, y tener
         como valor predeterminado 10. Tampoco puede estar vacío.
       ▪ La dificultad tendrá como valor predeterminado ‘Medio’.
       ▪ Establecer una relación con la tablas Juego y Usuario a través de
         las claves secundarias id_juego e id_usuario respectivamente.

    o Comentario:
       ▪ Debe contener los campos id_comentario (INT), id_usuario,
         id_juego, texto_comentario (TEXT) y fecha_comentario
         (DATETIME).
       ▪ El campo texto_comentario no puede estar vacío.
       ▪ La fecha_comentario solo debe permitir la fecha actual como valor
         predeterminado.
       ▪ Establecer una relación entre id_usuario de la tabla Usuario y
         id_juego de la tabla Juego.

 3. Insertar 5 registros en cada tabla utilizando datos ficticios y respetando las
    restricciones de cada campo, asegurando que las relaciones entre tablas sean
    correctas (por ejemplo, cada Partida debe estar asociada a un Juego y a un
    Usuario que sea el ganador, y los usuarios pueden tener múltiples amigos, logros y
    juegos en su biblioteca).

 ANOTACIÓN: Al insertar datos en los campos con valores predeterminados
 utilizar la cláusula DEFAULT para insertar el valor por defecto y así poder insertar
 algo diferente a default. Si usas NULL o vacío, no se insertará el dato que hemos
 indicado por defecto. Ejemplo:

 INSERT INTO usuario (nombre_usuario, email, fecha_registro, pais)
 VALUES ('Alberto00', 'alberto@ucam.edu', DEFAULT 'España');
*/

CREATE DATABASE IF NOT EXISTS plataforma_videojuegos;
USE plataforma_videojuegos;

-- Recreated/adjusted tables with corrected column names and constraints
CREATE TABLE IF NOT EXISTS juego (
    id_juego INT PRIMARY KEY,
    genero VARCHAR(100),
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    clasificacion_edad INT NOT NULL CHECK (clasificacion_edad BETWEEN 3 AND 18),
    disponibilidad ENUM('Disponible', 'No Disponible', 'Próximamente') DEFAULT 'Disponible'

CREATE TABLE usuario (
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT(NOW()),
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pais ENUM('Estados Unidos', 'Reino Unido', 'Japón', 'España', 'Brasil'),
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);

CREATE TABLE partida (
CREATE TABLE IF NOT EXISTS partida (
    fecha_partida DATETIME DEFAULT(NOW()),
    fecha_partida DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_juego INT NOT NULL,
    id_ganador INT NOT NULL,
    duracion_minutos INT NOT NULL DEFAULT 30 CHECK (duracion_minutos > 0),
    FOREIGN KEY (id_ganador) REFERENCES usuario(id_usuario)
);

CREATE TABLE logro (
CREATE TABLE IF NOT EXISTS logro (
    id_logro INT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    dificultad ENUM('Facil', 'Medio', 'Dificil') DEFAULT('Medio'),
    dificultad ENUM('Fácil', 'Medio', 'Difícil') NOT NULL DEFAULT 'Medio',
    puntos INT NOT NULL DEFAULT 10 CHECK (puntos > 0 AND puntos < 100),
    id_juego INT NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE comentario (
CREATE TABLE IF NOT EXISTS comentario (
    id_comentario INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_juego INT NOT NULL,
    fecha_comentario DATETIME DEFAULT(NOW()),
    fecha_comentario DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_juego) REFERENCES juego(id_juego)
);

-- Insert 5 juegos
INSERT INTO juego (id_juego, titulo, genero, precio, clasificacion_edad, disponibilidad) VALUES
(1, 'StarQuest Online', 'Aventura', 29.99, 16, DEFAULT),
(2, 'Pixel Racers', 'Carreras', 10.00, 7, 'Disponible'),
(2, 'Pixel Racers', 'Carreras', 0.00, 7, 'Disponible'),
(4, 'Space Strategy', 'Estrategia', 19.50, 10, 'No Disponible'),
(5, 'Puzzle Master', 'Puzzle', 9.99, 3, DEFAULT);

-- Insert 5 usuarios (fecha_registro uses DEFAULT current timestamp)
INSERT INTO usuario (id_usuario, nombre_usuario, email, fecha_registro, pais, id_juego) VALUES
(1, 'gamer_one', 'gamer1@example.com', DEFAULT, 'España', 1),
(2, 'pro_player', 'pro@example.com', DEFAULT, 'Estados Unidos', 2),
(3, 'luzdelnorte', 'norte@example.com', DEFAULT, 'Japón', 3),
(4, 'alice99', 'alice@example.com', DEFAULT, 'Reino Unido', 1),
(5, 'brunoBR', 'bruno@example.com', DEFAULT, 'Brasil', 5);

-- Insert 5 partidas (fecha_partida and/or duracion_minutos using DEFAULT where appropriate)
INSERT INTO partida (id_partida, fecha_partida, id_juego, id_ganador, duracion_minutos) VALUES
(1, DEFAULT, 1, 4, DEFAULT),
(2, DEFAULT, 2, 2, 45),
(3, DEFAULT, 3, 3, 60),
(4, DEFAULT, 1, 1, 20),
(5, DEFAULT, 5, 5, DEFAULT);

-- Insert 5 logros (nombres únicos, descripcion not empty, puntos between 1 and 99)
INSERT INTO logro (id_logro, nombre_logro, descripcion, dificultad, puntos, id_juego, id_usuario) VALUES
(1, 'Veterano de batalla', 'Gana 100 partidas contra otros jugadores', 'Medio', 30, 1, 1),
(2, 'Corredor pixelado', 'Finaliza una carrera en menos de 2 minutos', 'Fácil', 15, 2, 2),
(3, 'Hechicero supremo', 'Aprende y usa 50 hechizos distintos', 'Difícil', 80, 3, 3),
(4, 'Constructor lógico', 'Resuelve 100 puzzles distintos', 'Medio', 25, 5, 5),
(5, 'Maestro estratega', 'Gana una partida sin perder unidades', 'Difícil', 60, 4, 4);

-- Insert 5 comentarios (texto no vacío, fecha_comentario uses DEFAULT)
INSERT INTO comentario (id_comentario, id_usuario, id_juego, texto_comentario, fecha_comentario) VALUES
(1, 1, 1, 'Great game! Loved the multiplayer.', DEFAULT),
(2, 2, 2, 'Graphics are charming and gameplay is tight.', DEFAULT),
(3, 3, 3, 'Excited for the full release.', DEFAULT),
(4, 4, 1, 'Had some connection issues but enjoyable.', DEFAULT),
(5, 5, 5, 'Perfect for short breaks.', DEFAULT);
