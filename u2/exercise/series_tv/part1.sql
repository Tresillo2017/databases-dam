/*
Parte 1:
    Crear una base de datos para gestionar la información de una plataforma de juegecicos de
    series de televisión, incluyendo información sobre series, episodios, géneros, actores y usuarios.
Instrucciones:
    1. Crear la base de datos llamada plataforma_series.
    2. Crear las siguientes tablas con las restricciones indicadas:
        - Usuario: Debe contener los campos id_usuario (int), nombre_usuario (varchar), correo (varchar), fecha_registro (datetime) y suscripcion. El
                    correo debe ser único y no puede ser nulo. La fecha de registro no puede ser
                    una fecha futura y por defecto se va a guardar la fecha actual. El campo
                    suscripcion debe permitir valores como "Activo", "Inactivo", o "Pendiente".
        - Genero: Debe tener los campos id_genero (int), nombre_genero e id_serie.
                    El campo nombre_genero solo debe permitir valores como "Drama",
                    "Comedia", "Ciencia Ficción", "Acción", “Terror” y “Fantasía”.
        - Serie: Debe incluir los campos id_serie (int), titulo_serie (varchar),
                    ano_estreno (int), id_genero y calificación (int). El campo calificacion debe
                    ser un valor entre 1 y 10, y el año de estreno debe estar entre 1950 y el año
                    actual. Además, el campo titulo_serie no debe de estar vacío. Establecer
                    una relación con la tabla género utilizando id_genero como clave foránea.
        - Episodio: Debe contener los campos id_episodio (int), titulo_episodio
                    (varchar), temporada (int), duracion (int), id_serie, id_usuario y
                    fecha_emision (date). Los campos duracion y temporada deben ser
                    mayores que 0. Establecer una relación con la tabla Serie utilizando el
                    campo id_serie como clave foránea. Y una relación con la tabla Usuario a
                    través de id_suario. Además, el campo titulo_episodio no debe de estar vacío.
        - Actor: Debe incluir los campos id_actor (int), nombre_actor (varchar),
                    nacionalidad (varchar), fecha_nacimiento (date) e id_serie. La fecha de
                    nacimiento debe estar entre 1900 y el año actual. El campo nacionalidad
                    debe permitir solo ciertos valores como "Estados Unidos", "Reino Unido",
                    "España". Además, el campo nombre_actor no puede estar vacío.
                    Establecer una relación con la tabla Serie mediante id_serie.
    3. Insertar 5 registros en cada tabla utilizando datos ficticios, respetando las
        restricciones de cada campo. Asegúrate de que las relaciones entre tablas sean
        correctas (por ejemplo, cada episodio debe estar asociado a una serie, y cada serie
        debe tener un género).
*/

-- Crear la base de datos llamada plataforma_series
CREATE DATABASE plataforma_series;
USE plataforma_series;

-- Crear la tabla Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP CHECK (fecha_registro <= '2025-12-31'),
    suscripcion ENUM('Activo', 'Inactivo', 'Pendiente') NOT NULL
);

-- Crear la tabla Genero
CREATE TABLE Genero (
    id_genero INT PRIMARY KEY,
    nombre_genero ENUM('Drama', 'Comedia', 'Ciencia Ficción', 'Acción', 'Terror', 'Fantasía') NOT NULL
);

-- Crear la tabla Serie
CREATE TABLE Serie (
    id_serie INT PRIMARY KEY,
    titulo_serie VARCHAR(255) NOT NULL,
    ano_estreno INT CHECK (ano_estreno BETWEEN 1950 AND 2025),
    id_genero INT,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 10),
    FOREIGN KEY (id_genero) REFERENCES Genero(id_genero) ON DELETE CASCADE
);

-- Crear la tabla Episodio
CREATE TABLE Episodio (
    id_episodio INT PRIMARY KEY,
    titulo_episodio VARCHAR(255) NOT NULL,
    temporada INT CHECK (temporada > 0),
    duracion INT CHECK (duracion > 0),
    id_serie INT,
    fecha_emision DATE,
    FOREIGN KEY (id_serie) REFERENCES Serie(id_serie) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-- Crear la tabla Actor
CREATE TABLE Actor (
    id_actor INT PRIMARY KEY,
    nombre_actor VARCHAR(255) NOT NULL,
    nacionalidad ENUM('Estados Unidos', 'Reino Unido', 'España') NOT NULL,
    fecha_nacimiento DATE CHECK (fecha_nacimiento BETWEEN '1900-01-01' AND '2025-12-31'),
    id_serie INT,
    FOREIGN KEY (id_serie) REFERENCES Serie(id_serie) ON DELETE CASCADE
);


-- Insertar registros en la tabla Genero
INSERT INTO Genero (id_genero, nombre_genero) VALUES
(1, 'Drama'),
(2, 'Comedia'),
(3, 'Ciencia Ficción'),
(4, 'Acción'),
(5, 'Terror');

-- Insertar registros en la tabla Serie
INSERT INTO Serie (id_serie, titulo_serie, ano_estreno, id_genero, calificacion) VALUES
(1, 'Breaking Bad', 2008, 1, 10),
(2, 'Friends', 1994, 2, 9),
(3, 'Stranger Things', 2016, 3, 8),
(4, 'The Mandalorian', 2019, 4, 9),
(5, 'The Haunting of Hill House', 2018, 5, 8);

-- Insertar registros en la tabla Episodio
INSERT INTO Episodio (id_episodio, titulo_episodio, temporada, duracion, id_serie, fecha_emision) VALUES
(1, 'Pilot', 1, 58, 1, '2008-01-20'),
(2, 'The One Where Monica Gets a Roommate', 1, 22, 2, '1994-09-22'),
(3, 'Chapter One: The Vanishing of Will Byers', 1, 47, 3, '2016-07-15'),
(4, 'Chapter 1: The Mandalorian', 1, 40, 4, '2019-11-12'),
(5, 'Steven Sees a Ghost', 1, 55, 5, '2018-10-12');

-- Insertar registros en la tabla Actor
INSERT INTO Actor (id_actor, nombre_actor, nacionalidad, fecha_nacimiento, id_serie) VALUES
(1, 'Bryan Cranston', 'Estados Unidos', '1956-03-07', 1),
(2, 'Jennifer Aniston', 'Estados Unidos', '1969-02-11', 2),
(3, 'Millie Bobby Brown', 'Reino Unido', '2004-02-19', 3),
(4, 'Pedro Pascal', 'España', '1975-04-02', 4),
(5, 'Victoria Pedretti', 'Estados Unidos', '1995-03-23', 5);

-- Insertar registros en la tabla Usuario
INSERT INTO Usuario (id_usuario, nombre_usuario, correo, fecha_registro, suscripcion) VALUES
(1, 'juanperez', 'juanperez@example.com', '2023-01-15 10:00:00', 'Activo'),
(2, 'mariagarcia', 'mariagarcia@example.com', '2023-02-20 14:30:00', 'Inactivo'),
(3, 'carloslopez', 'carloslopez@example.com', '2023-03-05 09:15:00', 'Pendiente'),
(4, 'anafernandez', 'anafernandez@example.com', '2023-04-10 16:45:00', 'Activo'),
(5, 'luisgomez', 'luisgomez@example.com', '2023-05-22 11:20:00', 'Activo');

