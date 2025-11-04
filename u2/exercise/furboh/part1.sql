/*
Parte 1:
    Crear una base de datos para gestionar la información de una liga de fútbol profesional,
    incluyendo datos sobre equipos, jugadores, partidos, estadios, posiciones en la liga y aficionados.
        ANOTACIÓN: Utilizar el comando USE para seleccionar la base de datos automáticamente, así como el comando CREATE TABLE/DATABASE IF NOT EXISTS para
        evitar que se vuelvan a crear las tablas y/o la base de datos una vez creadas.
    Instrucciones:
        1. Crear la base de datos llamada liga_futbol.
        2. Crear las siguientes tablas con las restricciones indicadas:
            - Equipo:
                ▪ Debe incluir los campos id_equipo (INT), nombre_equipo
                    (VARCHAR), ciudad (VARCHAR), fundacion (INT), posicion (INT),
                    puntos (INT) y diferencia_goles (INT).
                ▪ El campo nombre_equipo debe ser único y no puede estar vacío.
                ▪ El campo fundacion debe ser un valor entre 1850 y el año actual.
                ▪ La posicion debe ser un valor único, debe de ser obligatorio, mayor
                    a 0 y menor o igual que 20.
                ▪ El campo puntos debe ser mayor o igual a 0.
            - Jugador:
                ▪ Debe contener los campos id_jugador (INT), nombre_jugador
                    (VARCHAR), nacionalidad (VARCHAR), posicion (ENUM) con
                    valores ‘Portero’, ‘Defensa’, ‘Centrocampista’ y ‘Delantero’,
                    fecha_nacimiento (DATE), salario (DECIMAL) e id_equipo (INT).
                ▪ La fecha_nacimiento no puede estar vacía.
                ▪ El campo posicion debe ser obligatorio y nombre_jugador no
                    puede estar vacío.
                ▪ El campo salario debe de almacenar dos números decimales y
                    está comprendido entre 100000 y 1000000.
                ▪ Establecer una relación con la tabla Equipo mediante id_equipo.
            - Entrenador:
                ▪ Debe incluir los campos: id_entrenador (INT), nombre_entrenador
                    (VARCHAR), nacionalidad (VARCHAR), fecha_contrato (DATE),
                    salario (DECIMAL) e id_equipo.
                ▪ El campo nombre_entrenador debe de ser único y no puede estar
                    vacío.
                ▪ El campo fecha_contrato es obligatorio y debe de ser posterior al
                    año 2017.
                ▪ El campo salario debe de ser mayor o igual a 30000 y menor a
                    100000. Se deben incluir dos decimales.
                ▪ Establecer una relación con la tabla Equipo mediante id_equipo.
            - Estadio:
                ▪ Debe incluir los campos id_estadio (INT), nombre_estadio
                    (VARCHAR), capacidad (INT), ciudad (VARCHAR) e id_equipo.
                ▪ El campo capacidad debe ser mayor a 5000.
                ▪ El nombre_estadio debe ser único y no puede estar vacío.
                ▪ Establecer una relación con la tabla Equipo mediante id_equipo.
            - Partido:
                ▪ Debe contener los campos id_partido (INT), fecha_partido
                    (DATETIME), id_estadio, id_equipoLocal, id_equipoVisitante y
                    resultado (VARCHAR).
                ▪ El campo resultado debe estar en el formato ‘X - Y’, donde X e Y son
                    los goles marcados por cada equipo.
                ▪ Establecer relaciones con la tabla Estadio con id_estadio y con la
                    tabla Equipo a través de id_equipoLocal y id_equipoVisitante.
            - Aficionado:
                ▪ Debe incluir los campos id_aficionado (INT), nombre_aficionado
                    (VARCHAR), equipo_favorito, fecha_nacimiento (DATE) y genero
                    (ENUM) con valores ‘Masculino’ y ‘Femenino’.
                ▪ La fecha_nacimiento debe ser posterior a 1920.
            ▪ El campo nombre_aficionado no puede estar vacío.
            ▪ Establecer una relación con la tabla Equipo para el campo
                equipo_favorito.
        3. Insertar 5 registros en cada tabla utilizando datos ficticios y respetando las
            restricciones de cada campo. Asegúrate de que las relaciones entre tablas sean
            correctas (por ejemplo, cada jugador debe estar asignado a un equipo, y cada
            equipo debe tener un estadio asignado como principal).
*/

CREATE DATABASE liga_futbol;
USE liga_futbol;

CREATE TABLE IF NOT EXISTS equipo (
    id_equipo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_equipo VARCHAR(100) NOT NULL UNIQUE,
    ciudad VARCHAR(100),
    fundacion INT CHECK(fundacion BETWEEN 1850 and 2025),
    posicion INT UNIQUE CHECK(posicion > 0 and posicion <= 20),
    puntos INT CHECK(puntos >= 0),
    diferencia_goles INT
);

CREATE TABLE IF NOT EXISTS jugador (
    id_jugador INT,
    nombre_jugador VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    posicion ENUM('Portero', 'Defensa', 'Centrocampista', 'Delantero') NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    salario DECIMAL(10,2) CHECK(salario BETWEEN 100000 and 1000000),
    id_equipo INT,
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
);

CREATE TABLE IF NOT EXISTS entrenador (
    id_entrenador INT,
    nombre_entrenador VARCHAR(100) NOT NULL UNIQUE,
    nacionalidad VARCHAR(100),
    fecha_contrato DATE CHECK(fecha_contrato > '2017-12-31'),
    salario DECIMAL(10,2) CHECK(salario >= 30000 and salario < 100000),
    id_equipo INT,
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
);

CREATE TABLE IF NOT EXISTS estadio (
    id_estadio INT NOT NULL PRIMARY KEY,
    nombre_estadio VARCHAR(100) NOT NULL UNIQUE,
    capacidad INT CHECK(capacidad > 5000),
    ciudad VARCHAR(100),
    id_equipo INT,
    FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo)
);

CREATE TABLE IF NOT EXISTS partido (
    id_partido INT,
    fecha_partido DATETIME,
    id_estadio INT,
    id_equipoLocal INT,
    id_equipoVisitante INT,
    resultado VARCHAR(10),
    FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio),
    FOREIGN KEY (id_equipoLocal) REFERENCES equipo(id_equipo),
    FOREIGN KEY (id_equipoVisitante) REFERENCES equipo(id_equipo)
);

CREATE TABLE IF NOT EXISTS aficionado (
    id_aficionado INT,
    nombre_aficionado VARCHAR(100) NOT NULL,
    equipo_favorito INT,
    fecha_nacimiento DATE CHECK(fecha_nacimiento > '1920-12-31'),
    genero ENUM('Masculino', 'Femenino'),
    FOREIGN KEY (equipo_favorito) REFERENCES equipo(id_equipo)
);

INSERT INTO equipo (id_equipo, nombre_equipo, ciudad, fundacion, posicion, puntos, diferencia_goles) VALUES
(1, 'FC Barcelona', 'Barcelona', 1899, 1, 85, 45),
(2, 'Real Madrid', 'Madrid', 1902, 2, 80, 40),
(3, 'Atletico de Madrid', 'Madrid', 1903, 3, 75, 30),
(4, 'Sevilla FC', 'Sevilla', 1890, 4, 70, 25),
(5, 'Valencia CF', 'Valencia', 1919, 5, 65, 20);

INSERT INTO jugador (id_jugador, nombre_jugador, nacionalidad, posicion, fecha_nacimiento, salario, id_equipo) VALUES
(1, 'Lionel Messi', 'Argentina', 'Delantero', '1987-06-24', 950000, 1),
(2, 'Sergio Ramos', 'España', 'Defensa', '1986-03-30', 850000, 2),
(3, 'Koke', 'España', 'Centrocampista', '1992-01-08', 600000, 3),
(4, 'Yassine Bounou', 'Marruecos', 'Portero', '1991-04-05', 400000, 4),
(5, 'Gonçalo Guedes', 'Portugal', 'Delantero', '1996-11-29', 550000, 5);

INSERT INTO entrenador (id_entrenador, nombre_entrenador, nacionalidad, fecha_contrato, salario, id_equipo) VALUES
(1, 'Xavi Hernandez', 'España', '2021-11-06', 75000, 1),
(2, 'Carlo Ancelotti', 'Italia', '2021-06-01', 90000, 2),
(3, 'Diego Simeone', 'Argentina', '2018-12-23', 85000, 3),
(4, 'Julen Lopetegui', 'España', '2019-06-08', 65000, 4),
(5, 'José Bordalás', 'España', '2021-06-01', 60000, 5);

INSERT INTO estadio (id_estadio, nombre_estadio, capacidad, ciudad, id_equipo) VALUES
(1, 'Camp Nou', 99354, 'Barcelona', 1),
(2, 'Santiago Bernabéu', 81044, 'Madrid', 2),
(3, 'Wanda Metropolitano', 68456, 'Madrid', 3),
(4, 'Ramón Sánchez Pizjuán', 43200, 'Sevilla', 4),
(5, 'Mestalla', 55000, 'Valencia', 5);

INSERT INTO partido (id_partido, fecha_partido, id_estadio, id_equipoLocal, id_equipoVisitante, resultado) VALUES
(1, '2023-09-15 20:00:00', 1, 1, 2, '2 - 1'),
(2, '2023-09-16 18:00:00', 2, 2, 3, '1 - 1'),
(3, '2023-09-17 21:00:00', 3, 3, 4, '0 - 2'),
(4, '2023-09-18 19:30:00', 4, 4, 5, '3 - 0'),
(5, '2023-09-19 20:45:00', 5, 5, 1, '1 - 4');

INSERT INTO aficionado (id_aficionado, nombre_aficionado, equipo_favorito, fecha_nacimiento, genero) VALUES
(1, 'Carlos Pérez', 1, '1990-05-12', 'Masculino'),
(2, 'Ana Gómez', 2, '1985-08-23', 'Femenino'),
(3, 'Luis Fernández', 3, '2000-11-30', 'Masculino'),
(4, 'Marta Rodríguez', 4, '1995-02-14', 'Femenino'),
(5, 'Javier Sánchez', 5, '1988-07-07', 'Masculino');