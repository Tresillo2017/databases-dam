CREATE DATABASE juegos_olimpicos;
USE juegos_olimpicos;

-- ======================================
-- TABLAS PRINCIPALES SIMPLIFICADAS
-- (sin tablas pais ni ciudad)
-- ======================================

CREATE TABLE estadio (
                         id_estadio INT AUTO_INCREMENT PRIMARY KEY,
                         nombre VARCHAR(120) NOT NULL,
                         ciudad VARCHAR(100) NOT NULL,
                         pais VARCHAR(100) NOT NULL,
                         aforo INT NOT NULL
);

CREATE TABLE deporte (
                         id_deporte INT AUTO_INCREMENT PRIMARY KEY,
                         nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE disciplina (
                            id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
                            id_deporte INT NOT NULL,
                            nombre VARCHAR(100) NOT NULL,
                            UNIQUE (id_deporte, nombre),
                            FOREIGN KEY (id_deporte) REFERENCES deporte(id_deporte) ON DELETE CASCADE
);

CREATE TABLE juegos (
                        id_juegos INT AUTO_INCREMENT PRIMARY KEY,
                        anio YEAR NOT NULL,
                        temporada ENUM('Verano','Invierno') NOT NULL,
                        ciudad_anfitriona VARCHAR(100) NOT NULL,
                        pais_anfitrion VARCHAR(100) NOT NULL,
                        fecha_apertura DATE,
                        fecha_cierre DATE,
                        UNIQUE (anio, temporada)
);

CREATE TABLE equipo (
                        id_equipo INT AUTO_INCREMENT PRIMARY KEY,
                        nombre VARCHAR(120) NOT NULL,
                        pais VARCHAR(100) NOT NULL,
                        UNIQUE (nombre, pais)
);

CREATE TABLE deportista (
                            id_deportista INT AUTO_INCREMENT PRIMARY KEY,
                            nombre VARCHAR(60) NOT NULL,
                            apellido VARCHAR(60) NOT NULL,
                            sexo ENUM('M','F') NOT NULL,
                            fecha_nacimiento DATE,
                            altura_cm INT,
                            peso_kg DECIMAL(5,2),
                            pais_nacionalidad VARCHAR(100) NOT NULL,
                            pais_nacimiento VARCHAR(100),
                            id_entrenador INT NULL,  -- relación reflexiva
                            FOREIGN KEY (id_entrenador) REFERENCES deportista(id_deportista) ON DELETE SET NULL
);

-- Relación doble: evento -> estadio (principal y secundario)
CREATE TABLE evento (
                        id_evento INT AUTO_INCREMENT PRIMARY KEY,
                        id_disciplina INT NOT NULL,
                        nombre VARCHAR(120) NOT NULL,
                        genero ENUM('Masculino','Femenino','Mixto') NOT NULL,
                        es_por_equipos BOOLEAN NOT NULL DEFAULT FALSE,
                        id_estadio_principal INT NOT NULL,
                        id_estadio_secundario INT,
                        UNIQUE (id_disciplina, nombre, genero),
                        FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina) ON DELETE CASCADE,
                        FOREIGN KEY (id_estadio_principal) REFERENCES estadio(id_estadio) ON DELETE RESTRICT,
                        FOREIGN KEY (id_estadio_secundario) REFERENCES estadio(id_estadio) ON DELETE SET NULL
);

-- ============================================
-- TABLAS INTERMEDIAS (solo claves)
-- ============================================

CREATE TABLE deportista_equipo (
                                   id_deportista INT NOT NULL,
                                   id_equipo INT NOT NULL,
                                   PRIMARY KEY (id_deportista, id_equipo),
                                   FOREIGN KEY (id_deportista) REFERENCES deportista(id_deportista) ON DELETE CASCADE,
                                   FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo) ON DELETE CASCADE
);

CREATE TABLE evento_juegos (
                               id_evento INT NOT NULL,
                               id_juegos INT NOT NULL,
                               PRIMARY KEY (id_evento, id_juegos),
                               FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON DELETE CASCADE,
                               FOREIGN KEY (id_juegos) REFERENCES juegos(id_juegos) ON DELETE CASCADE
);

-- ===================================
-- PARTICIPACIONES
-- ===================================
CREATE TABLE participacion (
                               id_deportista INT NOT NULL,
                               id_evento INT NOT NULL,
                               id_juegos INT NOT NULL,
                               id_equipo INT NULL,
                               ronda VARCHAR(50),
                               resultado VARCHAR(50),
                               posicion INT,
                               medalla ENUM('Oro','Plata','Bronce'),
                               PRIMARY KEY (id_deportista, id_evento, id_juegos),
                               FOREIGN KEY (id_deportista) REFERENCES deportista(id_deportista) ON DELETE CASCADE,
                               FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON DELETE CASCADE,
                               FOREIGN KEY (id_juegos) REFERENCES juegos(id_juegos) ON DELETE CASCADE,
                               FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo) ON DELETE SET NULL
);

-- ======================================
-- INSERTS — ESTADIOS
-- ======================================

INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (1, 'Estadio Olímpico de Madrid', 'Madrid', 'España', 70000),
                                                                  (2, 'Camp Nou', 'Barcelona', 'España', 90000),
                                                                  (3, 'Estadio Nacional de Tokio', 'Tokio', 'Japón', 68000),
                                                                  (4, 'Maracaná', 'Río de Janeiro', 'Brasil', 78000),
                                                                  (5, 'Stade de France', 'París', 'Francia', 80000),
                                                                  (6, 'Stadium Australia', 'Sídney', 'Australia', 82000),
                                                                  (7, 'Estadio Olímpico de Atenas', 'Atenas', 'Grecia', 72000),
                                                                  (8, 'Beijing National Stadium', 'Pekín', 'China', 80000),
                                                                  (9, 'Wembley Stadium', 'Londres', 'Reino Unido', 90000),
                                                                  (10, 'Estadio Olímpico de Río', 'Río de Janeiro', 'Brasil', 60000),
                                                                  (11, 'Centro Acuático de Tokio', 'Tokio', 'Japón', 17000),
                                                                  (12, 'Arena de Gimnasia París', 'París', 'Francia', 15000);

-- ======================================
-- INSERTS — DEPORTE
-- ======================================

INSERT INTO deporte (id_deporte, nombre) VALUES
                                             (1, 'Atletismo'),
                                             (2, 'Natación'),
                                             (3, 'Gimnasia'),
                                             (4, 'Fútbol'),
                                             (5, 'Ciclismo'),
                                             (6, 'Baloncesto'),
                                             (7, 'Voleibol'),
                                             (8, 'Tenis'),
                                             (9, 'Judo'),
                                             (10, 'Remo');

-- ======================================
-- INSERTS — DISCIPLINA (coherentes con deporte)
-- ======================================

-- 1–3 Atletismo
INSERT INTO disciplina (id_disciplina, id_deporte, nombre) VALUES
                                                               (1, 1, 'Velocidad'),
                                                               (2, 1, 'Fondo'),
                                                               (3, 1, 'Saltos'),
-- 4–5 Natación
                                                               (4, 2, 'Estilo Libre'),
                                                               (5, 2, 'Espalda'),
-- 6 Gimnasia
                                                               (6, 3, 'Artística'),
-- 7 Fútbol
                                                               (7, 4, 'Fútbol 11'),
-- 8 Ciclismo
                                                               (8, 5, 'Ruta'),
-- 9 Baloncesto
                                                               (9, 6, 'Baloncesto 5x5'),
-- 10–11 Voleibol
                                                               (10, 7, 'Voleibol Sala'),
                                                               (11, 7, 'Voleibol Playa'),
-- 12–13 Tenis
                                                               (12, 8, 'Tenis Individual'),
                                                               (13, 8, 'Tenis Dobles'),
-- 14–15 Judo
                                                               (14, 9, 'Judo -73kg'),
                                                               (15, 9, 'Judo -63kg'),
-- 16 Remo
                                                               (16, 10, 'Remo 8+');

-- ======================================
-- INSERTS — JUEGOS OLÍMPICOS
-- ======================================

INSERT INTO juegos (id_juegos, anio, temporada, ciudad_anfitriona, pais_anfitrion, fecha_apertura, fecha_cierre) VALUES
                                                                                                                     (1, 2016, 'Verano', 'Río de Janeiro', 'Brasil', '2016-08-05', '2016-08-21'),
                                                                                                                     (2, 2020, 'Verano', 'Tokio', 'Japón', '2021-07-23', '2021-08-08'),
                                                                                                                     (3, 2024, 'Verano', 'París', 'Francia', '2024-07-26', '2024-08-11'),
                                                                                                                     (4, 2012, 'Verano', 'Londres', 'Reino Unido', '2012-07-27', '2012-08-12'),
                                                                                                                     (5, 2008, 'Verano', 'Pekín', 'China', '2008-08-08', '2008-08-24'),
                                                                                                                     (6, 2004, 'Verano', 'Atenas', 'Grecia', '2004-08-13', '2004-08-29'),
                                                                                                                     (7, 2000, 'Verano', 'Sídney', 'Australia', '2000-09-15', '2000-10-01'),
                                                                                                                     (8, 1992, 'Verano', 'Barcelona', 'España', '1992-07-25', '1992-08-09');

-- ======================================
-- INSERTS — EQUIPOS
-- ======================================

INSERT INTO equipo (id_equipo, nombre, pais) VALUES
                                                 (1, 'España Atletismo', 'España'),
                                                 (2, 'España Fútbol', 'España'),
                                                 (3, 'Estados Unidos Atletismo', 'Estados Unidos'),
                                                 (4, 'Estados Unidos Baloncesto', 'Estados Unidos'),
                                                 (5, 'Brasil Fútbol', 'Brasil'),
                                                 (6, 'Kenia Maratón', 'Kenia'),
                                                 (7, 'Jamaica Velocidad', 'Jamaica'),
                                                 (8, 'Japón Judo', 'Japón'),
                                                 (9, 'Francia Balonmano', 'Francia'),
                                                 (10, 'China Natación', 'China'),
                                                 (11, 'Australia Natación', 'Australia'),
                                                 (12, 'Reino Unido Atletismo', 'Reino Unido');

-- ======================================
-- INSERTS — DEPORTISTAS
-- ======================================

INSERT INTO deportista (id_deportista, nombre, apellido, sexo, fecha_nacimiento,
                        altura_cm, peso_kg, pais_nacionalidad, pais_nacimiento, id_entrenador) VALUES
                                                                                                   (1, 'Carlos', 'Gómez', 'M', '1996-03-12', 180, 75, 'España', 'España', NULL),
                                                                                                   (2, 'Lucía', 'Martín', 'F', '1998-07-20', 165, 54, 'España', 'España', NULL),
                                                                                                   (3, 'John', 'Smith', 'M', '1995-01-15', 185, 80, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (4, 'Ayumi', 'Tanaka', 'F', '1999-11-11', 170, 58, 'Japón', 'Japón', NULL),
                                                                                                   (5, 'Samuel', 'Kipruto', 'M', '1994-09-09', 178, 62, 'Kenia', 'Kenia', NULL),
                                                                                                   (6, 'Pierre', 'Dubois', 'M', '1992-12-01', 182, 76, 'Francia', 'Francia', NULL),
                                                                                                   (7, 'Chen', 'Wei', 'M', '1996-04-03', 175, 70, 'China', 'China', NULL),
                                                                                                   (8, 'Ava', 'Williams', 'F', '2001-05-10', 172, 60, 'Australia', 'Australia', NULL),
                                                                                                   (9, 'Robert', 'Brown', 'M', '1993-06-22', 188, 85, 'Canadá', 'Canadá', NULL),
                                                                                                   (10, 'Hans', 'Müller', 'M', '1997-08-14', 183, 79, 'Alemania', 'Alemania', NULL),
                                                                                                   (11, 'Usain', 'Bolt', 'M', '1986-08-21', 195, 94, 'Jamaica', 'Jamaica', NULL),
                                                                                                   (12, 'Allyson', 'Felix', 'F', '1985-11-18', 168, 55, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (13, 'Mo', 'Farah', 'M', '1983-03-23', 175, 58, 'Reino Unido', 'Somalia', NULL),
                                                                                                   (14, 'Shelly-Ann', 'Fraser-Pryce', 'F', '1986-12-27', 152, 52, 'Jamaica', 'Jamaica', NULL),
                                                                                                   (15, 'Simone', 'Biles', 'F', '1997-03-14', 142, 48, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (16, 'Katie', 'Ledecky', 'F', '1997-03-17', 183, 73, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (17, 'Rafa', 'Nadal', 'M', '1986-06-03', 185, 85, 'España', 'España', NULL),
                                                                                                   (18, 'Novak', 'Djokovic', 'M', '1987-05-22', 188, 80, 'Serbia', 'Serbia', NULL),
                                                                                                   (19, 'Marta', 'Vieira', 'F', '1986-02-19', 162, 57, 'Brasil', 'Brasil', NULL),
                                                                                                   (20, 'Eliud', 'Kipchoge', 'M', '1984-11-05', 167, 52, 'Kenia', 'Kenia', NULL),
                                                                                                   (21, 'Yulimar', 'Rojas', 'F', '1995-10-21', 192, 72, 'Venezuela', 'Venezuela', NULL),
                                                                                                   (22, 'Mireia', 'Belmonte', 'F', '1990-11-10', 170, 59, 'España', 'España', NULL),
                                                                                                   (23, 'Naomi', 'Osaka', 'F', '1997-10-16', 180, 69, 'Japón', 'Japón', NULL),
                                                                                                   (24, 'Karsten', 'Warholm', 'M', '1996-02-28', 187, 80, 'Noruega', 'Noruega', NULL),
                                                                                                   (25, 'Mutaz', 'Barshim', 'M', '1991-06-24', 189, 70, 'Catar', 'Catar', NULL);

-- RELACIÓN REFLEXIVA (algunos tienen entrenador que también es deportista)
UPDATE deportista
SET id_entrenador = 11   -- Usain Bolt
WHERE id_deportista IN (1,2,14);

UPDATE deportista
SET id_entrenador = 20   -- Eliud Kipchoge
WHERE id_deportista IN (5,13);

-- Otros se quedan con id_entrenador = NULL para poder buscar IS NULL

-- ====================================
-- EVENTOS (COHERENTES CON SU DISCIPLINA Y DEPORTE)
-- ====================================

INSERT INTO evento (id_evento, id_disciplina, nombre, genero, es_por_equipos,
                    id_estadio_principal, id_estadio_secundario) VALUES
-- Atletismo Velocidad (disciplina 1)
(1, 1, '100 Metros', 'Masculino', FALSE, 3, 5),
(2, 1, '100 Metros', 'Femenino', FALSE, 3, 5),
(3, 1, '200 Metros', 'Masculino', FALSE, 3, NULL),
-- Atletismo Fondo (disciplina 2)
(4, 2, 'Maratón', 'Masculino', FALSE, 5, 4),
(5, 2, '5000 Metros', 'Femenino', FALSE, 5, NULL),
-- Natación Estilo Libre (disciplina 4)
(6, 4, '200m Libre', 'Femenino', FALSE, 11, 3),
-- Gimnasia Artística (disciplina 6)
(7, 6, 'All Around', 'Femenino', FALSE, 12, 3),
-- Fútbol 11 (disciplina 7)
(8, 7, 'Fútbol Final', 'Masculino', TRUE, 4, 5),
(9, 7, 'Fútbol Final', 'Femenino', TRUE, 5, 4),
-- Ciclismo Ruta (disciplina 8)
(10, 8, 'Carrera en Ruta', 'Masculino', FALSE, 5, 6),
-- Baloncesto 5x5 (disciplina 9)
(11, 9, 'Baloncesto Final', 'Masculino', TRUE, 2, 1),
-- Voleibol Sala (disciplina 10)
(12, 10, 'Voleibol Sala Final', 'Femenino', TRUE, 5, 2),
-- Voleibol Playa (disciplina 11)
(13, 11, 'Voleibol Playa Final', 'Femenino', TRUE, 1, NULL),
-- Tenis Individual (disciplina 12)
(14, 12, 'Tenis Individual Masculino', 'Masculino', FALSE, 9, NULL),
(15, 12, 'Tenis Individual Femenino', 'Femenino', FALSE, 9, NULL),
-- Judo (disciplinas 14 y 15)
(16, 14, 'Judo -73kg', 'Masculino', FALSE, 12, NULL),
(17, 15, 'Judo -63kg', 'Femenino', FALSE, 12, NULL),
-- Remo 8+ (disciplina 16)
(18, 16, 'Remo 8+ Masculino', 'Masculino', TRUE, 10, 8),
-- Natación Espalda (disciplina 5)
(19, 5, '100m Espalda', 'Masculino', FALSE, 11, NULL),
(20, 5, '100m Espalda', 'Femenino', FALSE, 11, NULL);

-- ====================================
-- DEPORTISTA_EQUIPO (TABLA INTERMEDIA SOLO CLAVES)
-- ====================================

INSERT INTO deportista_equipo (id_deportista, id_equipo) VALUES
                                                             (1, 1),   -- Carlos -> España Atletismo
                                                             (2, 1),   -- Lucía -> España Atletismo
                                                             (3, 3),   -- John -> USA Atletismo
                                                             (11, 7),  -- Usain Bolt -> Jamaica Velocidad
                                                             (12, 3),  -- Allyson Felix -> USA Atletismo
                                                             (13, 12), -- Mo Farah -> Reino Unido Atletismo
                                                             (5, 6),   -- Samuel -> Kenia Maratón
                                                             (20, 6),  -- Eliud -> Kenia Maratón
                                                             (17, 1),  -- Rafa Nadal -> España Atletismo (ejemplo)
                                                             (18, 3),  -- Djokovic -> USA Atletismo (ficticio para tener datos)
                                                             (19, 5),  -- Marta -> Brasil Fútbol
                                                             (16, 10), -- Katie Ledecky -> China Natación (ficticio)
                                                             (22, 1),  -- Mireia -> España Atletismo (puede representar equipo natación general)
                                                             (21, 9),  -- Yulimar -> Francia Balonmano (ficticio)
                                                             (24, 12); -- Karsten -> Reino Unido Atletismo

-- ====================================
-- EVENTO_JUEGOS (TABLA INTERMEDIA SOLO CLAVES)
-- ====================================

-- Relacionamos eventos con varias ediciones
INSERT INTO evento_juegos (id_evento, id_juegos) VALUES
                                                     (1, 3),  -- 100m masc París 2024
                                                     (1, 4),  -- 100m masc Londres 2012
                                                     (1, 5),  -- 100m masc Pekín 2008
                                                     (2, 3),  -- 100m fem París 2024
                                                     (3, 3),  -- 200m masc París 2024
                                                     (4, 1),  -- Maratón masc Río 2016
                                                     (4, 3),  -- Maratón masc París 2024
                                                     (5, 3),  -- 5000m fem París 2024
                                                     (6, 2),  -- 200m libre fem Tokio 2020
                                                     (6, 3),  -- 200m libre fem París 2024
                                                     (7, 2),  -- All Around Tokio 2020
                                                     (7, 3),  -- All Around París 2024
                                                     (8, 1),  -- Fútbol final masc Río 2016
                                                     (8, 3),  -- Fútbol final masc París 2024
                                                     (9, 3),  -- Fútbol final fem París 2024
                                                     (10, 3), -- Carrera en ruta masc París 2024
                                                     (11, 3), -- Baloncesto final masc París 2024
                                                     (12, 3), -- Vóley sala final fem París 2024
                                                     (13, 3), -- Vóley playa final fem París 2024
                                                     (14, 5), -- Tenis ind masc Pekín 2008
                                                     (14, 3), -- Tenis ind masc París 2024
                                                     (15, 3), -- Tenis ind fem París 2024
                                                     (16, 3), -- Judo -73kg París 2024
                                                     (17, 3), -- Judo -63kg París 2024
                                                     (18, 1), -- Remo 8+ Río 2016
                                                     (18, 3), -- Remo 8+ París 2024
                                                     (19, 3), -- 100m espalda masc París 2024
                                                     (20, 3); -- 100m espalda fem París 2024

-- ======================================
-- PARTICIPACIONES (VARIADAS, CON ALGUNOS NULL EN FKs)
-- ======================================

-- 100m Masculino (evento 1) París 2024 (juegos 3)
INSERT INTO participacion (id_deportista, id_evento, id_juegos, id_equipo,
                           ronda, resultado, posicion, medalla) VALUES
                                                                    (11, 1, 3, 7, 'Final', '9.80', 1, 'Oro'),    -- Usain Bolt
                                                                    (1, 1, 3, 1, 'Final', '10.10', 5, NULL),     -- Carlos
                                                                    (3, 1, 3, 3, 'Semifinal', '10.25', NULL, NULL);

-- 100m Femenino (evento 2) París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (12, 2, 3, 3, 'Final', '10.85', 1, 'Oro'),   -- Allyson
                              (2, 2, 3, 1, 'Semifinal', '11.30', NULL, NULL),
                              (14, 2, 3, 7, 'Final', '10.95', 3, 'Bronce'); -- Shelly-Ann

-- 200m Masculino (evento 3) París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (11, 3, 3, 7, 'Final', '19.40', 1, 'Oro'),
                              (24, 3, 3, NULL, 'Final', '20.10', 4, NULL); -- Karsten sin equipo

-- Maratón Masculino (evento 4) Río 2016 (juegos 1)
INSERT INTO participacion VALUES
                              (20, 4, 1, 6, 'Final', '2:08:44', 1, 'Oro'),  -- Eliud
                              (5, 4, 1, 6, 'Final', '2:10:10', 5, NULL),
                              (13, 4, 1, 12, 'Final', '2:12:30', 8, NULL);

-- 200m Libre Femenino (evento 6) Tokio 2020 (juegos 2)
INSERT INTO participacion VALUES
                              (16, 6, 2, 10, 'Final', '1:54.35', 1, 'Oro'),  -- Katie
                              (22, 6, 2, 1, 'Final', '1:56.50', 3, 'Bronce'),
                              (6, 6, 2, NULL, 'Series', '2:01.00', NULL, NULL);

-- All Around Femenino (evento 7) Tokio 2020 (juegos 2)
INSERT INTO participacion VALUES
                              (15, 7, 2, 3, 'Final', '58.500', 1, 'Oro'),    -- Simone Biles
                              (4, 7, 2, NULL, 'Final', '55.700', 4, NULL),
                              (21, 7, 2, NULL, 'Clasificación', '53.200', NULL, NULL);

-- Fútbol Final Masculino (evento 8) Río 2016 (juegos 1)
INSERT INTO participacion VALUES
                              (19, 8, 1, 5, 'Final', NULL, 1, 'Oro'),        -- Marta (ejemplo mixto)
                              (9, 8, 1, NULL, 'Final', NULL, 2, 'Plata');    -- Robert sin equipo

-- Baloncesto Final Masculino (evento 11) París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (3, 11, 3, 4, 'Final', NULL, 1, 'Oro'),        -- John en USA Basket
                              (6, 11, 3, NULL, 'Final', NULL, 2, 'Plata');   -- Pierre sin equipo

-- Tenis Individual Masculino (evento 14) Pekín 2008 (juegos 5)
INSERT INTO participacion VALUES
                              (17, 14, 5, 1, 'Final', NULL, 1, 'Oro'),       -- Rafa Nadal
                              (18, 14, 5, NULL, 'Semifinal', NULL, 3, 'Bronce'); -- Djokovic sin equipo

-- Tenis Individual Femenino (evento 15) París 2024 (juegos 3)
INSERT INTO participacion VALUES
    (23, 15, 3, NULL, 'Final', NULL, 2, 'Plata');  -- Naomi Osaka

-- Judo -73kg Masculino (evento 16) París 2024 (juegos 3)
INSERT INTO participacion VALUES
    (7, 16, 3, 8, 'Final', NULL, 1, 'Oro');        -- Chen Wei en Japón Judo

-- Judo -63kg Femenino (evento 17) París 2024 (juegos 3)
INSERT INTO participacion VALUES
    (4, 17, 3, 8, 'Final', NULL, 3, 'Bronce');     -- Ayumi

-- Remo 8+ Masculino (evento 18) Río 2016 (juegos 1)
INSERT INTO participacion VALUES
                              (10, 18, 1, NULL, 'Final', '5:30.00', 4, NULL),
                              (6, 18, 1, NULL, 'Final', '5:28.50', 3, 'Bronce');

-- 100m Espalda Masculino (evento 19) París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (16, 19, 3, 10, 'Final', '52.10', 1, 'Oro'),
                              (33, 19, 3, NULL, 'Series', '54.00', NULL, NULL);  -- si no tienes id 33, comenta esta línea

-- 100m Espalda Femenino (evento 20) París 2024 (juegos 3)
-- (dejamos esta prueba sin participaciones para ejercicios de OUTER JOIN sobre eventos sin resultados)

/* =====================================================
   INSERTS ADICIONALES PARA TODAS LAS TABLAS
   (AÑADIR DESPUÉS DEL SCRIPT ANTERIOR)
   ===================================================== */

-- ======================
-- ESTADIO (IDs 13–20)
-- ======================

INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (13, 'Estadio Olímpico de Londres', 'Londres', 'Reino Unido', 80000),
                                                                  (14, 'Luzhniki Stadium', 'Moscú', 'Rusia', 81000),
                                                                  (15, 'BC Place Stadium', 'Vancouver', 'Canadá', 54000),
                                                                  (16, 'Fisht Olympic Stadium', 'Sochi', 'Rusia', 48000),
                                                                  (17, 'Alpensia Stadium', 'PyeongChang', 'Corea del Sur', 35000),
                                                                  (18, 'National Speed Skating Oval', 'Pekín', 'China', 12000),
                                                                  (19, 'Toyota Stadium', 'Toyota', 'Japón', 45000),
                                                                  (20, 'ANZ Stadium', 'Sídney', 'Australia', 83500);

/* =====================================================
   INSERTS: NUEVOS ESTADIOS POR PAÍS EXISTENTE
   (IDs 21–80, todos usados en tus nuevos eventos)
   ===================================================== */

-- ESPAÑA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (21, 'Estadio Metropolitano', 'Madrid', 'España', 68000),
                                                                  (22, 'Estadio de La Rosaleda', 'Málaga', 'España', 30000),
                                                                  (23, 'Estadio Benito Villamarín', 'Sevilla', 'España', 60000),
                                                                  (24, 'Estadio de Mestalla', 'Valencia', 'España', 49000),
                                                                  (25, 'Estadio Riazor', 'A Coruña', 'España', 32500);

-- JAPÓN
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (26, 'Saitama Stadium 2002', 'Saitama', 'Japón', 63700),
                                                                  (27, 'Nissan Stadium', 'Yokohama', 'Japón', 72300),
                                                                  (28, 'Kobe Wing Stadium', 'Kobe', 'Japón', 30000),
                                                                  (29, 'Sapporo Dome', 'Sapporo', 'Japón', 53700);

-- BRASIL
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (30, 'Arena Corinthians', 'São Paulo', 'Brasil', 49200),
                                                                  (31, 'Mineirão', 'Belo Horizonte', 'Brasil', 62000),
                                                                  (32, 'Arena da Baixada', 'Curitiba', 'Brasil', 42300),
                                                                  (33, 'Arena Fonte Nova', 'Salvador', 'Brasil', 50000);

-- FRANCIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (34, 'Parc des Princes', 'París', 'Francia', 48000),
                                                                  (35, 'Groupama Stadium', 'Lyon', 'Francia', 59000),
                                                                  (36, 'Orange Vélodrome', 'Marsella', 'Francia', 67000),
                                                                  (37, 'Stade Pierre-Mauroy', 'Lille', 'Francia', 50000);

-- AUSTRALIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (38, 'Melbourne Cricket Ground', 'Melbourne', 'Australia', 100000),
                                                                  (39, 'Optus Stadium', 'Perth', 'Australia', 60000),
                                                                  (40, 'Suncorp Stadium', 'Brisbane', 'Australia', 52500),
                                                                  (41, 'Adelaide Oval', 'Adelaida', 'Australia', 53000);

-- GRECIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (42, 'Karaiskakis Stadium', 'Pireo', 'Grecia', 33000),
                                                                  (43, 'Toumba Stadium', 'Tesalónica', 'Grecia', 28800),
                                                                  (44, 'OAKA Velódromo', 'Atenas', 'Grecia', 5600);

-- CHINA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (45, 'Workers Stadium', 'Pekín', 'China', 68000),
                                                                  (46, 'Tianhe Stadium', 'Cantón', 'China', 54400),
                                                                  (47, 'Shanghai Stadium', 'Shanghái', 'China', 56000),
                                                                  (48, 'Chengdu Stadium', 'Chengdu', 'China', 42000),
                                                                  (49, 'Dalian Sports Center', 'Dalian', 'China', 61000);

-- REINO UNIDO
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (50, 'Old Trafford', 'Mánchester', 'Reino Unido', 74000),
                                                                  (51, 'Anfield', 'Liverpool', 'Reino Unido', 54000),
                                                                  (52, 'Hampden Park', 'Glasgow', 'Reino Unido', 52000),
                                                                  (53, 'Principality Stadium', 'Cardiff', 'Reino Unido', 73000);

-- CANADÁ
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (54, 'Tim Hortons Field', 'Hamilton', 'Canadá', 23500),
                                                                  (55, 'Commonwealth Stadium', 'Edmonton', 'Canadá', 56000),
                                                                  (56, 'IG Field', 'Winnipeg', 'Canadá', 33000);

-- RUSIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (57, 'Gazprom Arena', 'San Petersburgo', 'Rusia', 68000),
                                                                  (58, 'Otkrytie Arena', 'Moscú', 'Rusia', 45000),
                                                                  (59, 'Kazan Arena', 'Kazan', 'Rusia', 45000);

-- COREA DEL SUR
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (60, 'Seoul World Cup Stadium', 'Seúl', 'Corea del Sur', 66000),
                                                                  (61, 'Daegu Stadium', 'Daegu', 'Corea del Sur', 66000),
                                                                  (62, 'Incheon Football Stadium', 'Incheon', 'Corea del Sur', 20000);

-- ALEMANIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (63, 'Allianz Arena', 'Múnich', 'Alemania', 75000),
                                                                  (64, 'Signal Iduna Park', 'Dortmund', 'Alemania', 81365),
                                                                  (65, 'Mercedes-Benz Arena', 'Stuttgart', 'Alemania', 60440);

-- NORUEGA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (66, 'Ullevaal Stadion', 'Oslo', 'Noruega', 28000),
                                                                  (67, 'Viking Stadion', 'Stavanger', 'Noruega', 16000);

-- PAÍSES BAJOS
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (68, 'Johan Cruyff Arena', 'Ámsterdam', 'Países Bajos', 54000),
                                                                  (69, 'Philips Stadion', 'Eindhoven', 'Países Bajos', 35000),
                                                                  (70, 'De Kuip', 'Róterdam', 'Países Bajos', 51000);

-- ITALIA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (71, 'San Siro', 'Milán', 'Italia', 80000),
                                                                  (72, 'Stadio Olimpico', 'Roma', 'Italia', 72000),
                                                                  (73, 'Allianz Stadium', 'Turín', 'Italia', 41000);

-- ESTADOS UNIDOS
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (74, 'MetLife Stadium', 'Nueva Jersey', 'Estados Unidos', 82500),
                                                                  (75, 'Rose Bowl', 'Pasadena', 'Estados Unidos', 90000),
                                                                  (76, 'Mercedes-Benz Stadium', 'Atlanta', 'Estados Unidos', 71000),
                                                                  (77, 'Lumen Field', 'Seattle', 'Estados Unidos', 68000),
                                                                  (78, 'Soldier Field', 'Chicago', 'Estados Unidos', 61500);

-- JAMAICA
INSERT INTO estadio (id_estadio, nombre, ciudad, pais, aforo) VALUES
                                                                  (79, 'National Stadium', 'Kingston', 'Jamaica', 35000),
                                                                  (80, 'Montego Bay Sports Complex', 'Montego Bay', 'Jamaica', 7000);

-- ======================
-- DEPORTE (IDs 11–14)
-- ======================

INSERT INTO deporte (id_deporte, nombre) VALUES
                                             (11, 'Triatlón'),
                                             (12, 'Halterofilia'),
                                             (13, 'Taekwondo'),
                                             (14, 'Rugby 7');

-- ======================
-- DISCIPLINA (IDs 17–24)
-- ======================

INSERT INTO disciplina (id_disciplina, id_deporte, nombre) VALUES
                                                               (17, 11, 'Triatlón Olímpico'),
                                                               (18, 12, 'Halterofilia -81kg'),
                                                               (19, 12, 'Halterofilia -96kg'),
                                                               (20, 13, 'Taekwondo -68kg'),
                                                               (21, 13, 'Taekwondo -57kg'),
                                                               (22, 14, 'Rugby 7 Masculino'),
                                                               (23, 14, 'Rugby 7 Femenino'),
                                                               (24, 1,  '400 Metros Vallas');

-- ======================
-- JUEGOS (IDs 9–12, Invierno)
-- ======================

INSERT INTO juegos (id_juegos, anio, temporada, ciudad_anfitriona, pais_anfitrion, fecha_apertura, fecha_cierre) VALUES
                                                                                                                     (9, 2010, 'Invierno', 'Vancouver', 'Canadá', '2010-02-12', '2010-02-28'),
                                                                                                                     (10, 2014, 'Invierno', 'Sochi', 'Rusia', '2014-02-07', '2014-02-23'),
                                                                                                                     (11, 2018, 'Invierno', 'PyeongChang', 'Corea del Sur', '2018-02-09', '2018-02-25'),
                                                                                                                     (12, 2022, 'Invierno', 'Pekín', 'China', '2022-02-04', '2022-02-20');

-- ======================
-- EQUIPO (IDs 13–20)
-- ======================

INSERT INTO equipo (id_equipo, nombre, pais) VALUES
                                                 (13, 'Nueva Zelanda Rugby 7', 'Nueva Zelanda'),
                                                 (14, 'Fiyi Rugby 7', 'Fiyi'),
                                                 (15, 'Sudáfrica Rugby 7', 'Sudáfrica'),
                                                 (16, 'Canadá Hockey Hielo', 'Canadá'),
                                                 (17, 'Noruega Esquí de Fondo', 'Noruega'),
                                                 (18, 'Italia Halterofilia', 'Italia'),
                                                 (19, 'Corea del Sur Patinaje', 'Corea del Sur'),
                                                 (20, 'China Patinaje Velocidad', 'China');

-- ======================
-- DEPORTISTA (IDs 26–40)
-- ======================

INSERT INTO deportista (id_deportista, nombre, apellido, sexo, fecha_nacimiento,
                        altura_cm, peso_kg, pais_nacionalidad, pais_nacimiento, id_entrenador) VALUES
                                                                                                   (26, 'Michael', 'Johnson', 'M', '1967-09-13', 185, 77, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (27, 'Cathy', 'Freeman', 'F', '1973-02-16', 164, 58, 'Australia', 'Australia', NULL),
                                                                                                   (28, 'Blanka', 'Vlasic', 'F', '1983-11-08', 193, 70, 'Croacia', 'Croacia', NULL),
                                                                                                   (29, 'Kohei', 'Uchimura', 'M', '1989-01-03', 161, 52, 'Japón', 'Japón', NULL),
                                                                                                   (30, 'Fiji', 'Talanoa', 'M', '1990-06-10', 182, 90, 'Fiyi', 'Fiyi', NULL),
                                                                                                   (31, 'Portia', 'Woodman', 'F', '1991-07-12', 170, 72, 'Nueva Zelanda', 'Nueva Zelanda', NULL),
                                                                                                   (32, 'Lasha', 'Talakhadze', 'M', '1993-10-02', 197, 175, 'Georgia', 'Georgia', NULL),
                                                                                                   (33, 'Jade', 'Jones', 'F', '1993-03-21', 169, 57, 'Reino Unido', 'Reino Unido', NULL),
                                                                                                   (34, 'Lee', 'Dae-Hoon', 'M', '1992-02-05', 180, 68, 'Corea del Sur', 'Corea del Sur', NULL),
                                                                                                   (35, 'Alistair', 'Brownlee', 'M', '1988-04-23', 184, 70, 'Reino Unido', 'Reino Unido', NULL),
                                                                                                   (36, 'Flora', 'Duffy', 'F', '1987-09-30', 161, 55, 'Bermudas', 'Bermudas', NULL),
                                                                                                   (37, 'Mahe', 'Drysdale', 'M', '1978-11-19', 200, 100, 'Nueva Zelanda', 'Australia', NULL),
                                                                                                   (38, 'Tessa', 'Virtue', 'F', '1989-05-17', 165, 50, 'Canadá', 'Canadá', NULL),
                                                                                                   (39, 'Scott', 'Moir', 'M', '1987-09-02', 180, 75, 'Canadá', 'Canadá', NULL),
                                                                                                   (40, 'Suzanne', 'Schulting', 'F', '1997-09-25', 169, 60, 'Países Bajos', 'Países Bajos', NULL);

-- Más relación reflexiva (entrenadores)
UPDATE deportista
SET id_entrenador = 26    -- Michael Johnson entrena a Cathy Freeman
WHERE id_deportista = 27;

UPDATE deportista
SET id_entrenador = 35    -- Alistair Brownlee entrena a Flora Duffy
WHERE id_deportista = 36;

-- Dejamos varios con id_entrenador = NULL para consultas con IS NULL

-- ======================
-- EVENTO (IDs 21–30)
-- ======================

INSERT INTO evento (id_evento, id_disciplina, nombre, genero, es_por_equipos,
                    id_estadio_principal, id_estadio_secundario) VALUES
-- Atletismo 400 Metros Vallas (disciplina 24)
(21, 24, '400 Metros Vallas', 'Masculino', FALSE, 3, 5),
(22, 24, '400 Metros Vallas', 'Femenino', FALSE, 3, NULL),
-- Triatlón (disciplina 17)
(23, 17, 'Triatlón Individual Masculino', 'Masculino', FALSE, 20, NULL),
(24, 17, 'Triatlón Individual Femenino', 'Femenino', FALSE, 20, NULL),
-- Halterofilia (disciplinas 18 y 19)
(25, 18, 'Halterofilia -81kg Masculino', 'Masculino', FALSE, 7, NULL),
(26, 19, 'Halterofilia -96kg Masculino', 'Masculino', FALSE, 7, NULL),
-- Taekwondo (disciplinas 20 y 21)
(27, 20, 'Taekwondo -68kg Masculino', 'Masculino', FALSE, 12, NULL),
(28, 21, 'Taekwondo -57kg Femenino', 'Femenino', FALSE, 12, NULL),
-- Rugby 7 (disciplinas 22 y 23)
(29, 22, 'Rugby 7 Final Masculina', 'Masculino', TRUE, 13, 20),
(30, 23, 'Rugby 7 Final Femenina', 'Femenino', TRUE, 13, NULL);

-- ======================
-- DEPORTISTA_EQUIPO (nuevas combinaciones, todas con IDs nuevos)
-- ======================

INSERT INTO deportista_equipo (id_deportista, id_equipo) VALUES
                                                             (26, 3),   -- Michael Johnson -> USA Atletismo
                                                             (27, 11),  -- Cathy Freeman -> Australia Natación (ejemplo de mezcla)
                                                             (28, 1),   -- Blanka Vlasic -> España Atletismo (ficticio)
                                                             (29, 8),   -- Kohei Uchimura -> Japón Judo
                                                             (30, 14),  -- Fiji Talanoa -> Fiyi Rugby 7
                                                             (31, 13),  -- Portia Woodman -> Nueva Zelanda Rugby 7
                                                             (32, 18),  -- Lasha -> Italia Halterofilia (ficticio europeo)
                                                             (33, 12),  -- Jade Jones -> Reino Unido Atletismo (equipo multi-deporte)
                                                             (34, 19),  -- Lee Dae-Hoon -> Corea del Sur Patinaje (ejemplo mixto)
                                                             (35, 12),  -- Alistair -> Reino Unido Atletismo
                                                             (36, 11),  -- Flora Duffy -> Australia Natación (para dar variedad)
                                                             (37, 16),  -- Mahe Drysdale -> Canadá Hockey Hielo (totalmente ficticio, para consultas)
                                                             (38, 16),  -- Tessa Virtue -> Canadá Hockey Hielo
                                                             (39, 16),  -- Scott Moir -> Canadá Hockey Hielo
                                                             (40, 17);  -- Suzanne Schulting -> Noruega Esquí de Fondo (mixto)

-- ======================
-- EVENTO_JUEGOS (nuevas relaciones, usando eventos 21–30 y juegos 9–12)
-- ======================

INSERT INTO evento_juegos (id_evento, id_juegos) VALUES
                                                     (21, 3),   -- 400m vallas masc París 2024
                                                     (22, 3),   -- 400m vallas fem París 2024
                                                     (23, 7),   -- Triatlón masc Sídney 2000
                                                     (23, 3),   -- Triatlón masc París 2024
                                                     (24, 3),   -- Triatlón fem París 2024
                                                     (25, 6),   -- Halterofilia -81kg Atenas 2004
                                                     (26, 5),   -- Halterofilia -96kg Pekín 2008
                                                     (27, 2),   -- Taekwondo -68kg Tokio 2020
                                                     (28, 2),   -- Taekwondo -57kg Tokio 2020
                                                     (29, 3),   -- Rugby 7 masc París 2024
                                                     (30, 3),   -- Rugby 7 fem París 2024
                                                     (29, 7),   -- Rugby 7 masc Sídney 2000
                                                     (30, 7),   -- Rugby 7 fem Sídney 2000
                                                     (21, 4),   -- 400m vallas masc Londres 2012
                                                     (22, 4);   -- 400m vallas fem Londres 2012

-- ======================
-- PARTICIPACION (nuevas, con NULL en FKs opcionales)
-- ======================

-- 400m Vallas Masculino (evento 21), París 2024 (juegos 3)
INSERT INTO participacion (id_deportista, id_evento, id_juegos, id_equipo,
                           ronda, resultado, posicion, medalla) VALUES
                                                                    (24, 21, 3, 12, 'Final', '47.95', 1, 'Oro'),   -- Karsten Warholm
                                                                    (26, 21, 3, 3,  'Final', '48.50', 3, 'Bronce'),-- Michael Johnson (hipotético)
                                                                    (1,  21, 3, NULL, 'Series', '50.20', NULL, NULL); -- Carlos sin equipo

-- 400m Vallas Femenino (evento 22), París 2024
INSERT INTO participacion VALUES
                              (27, 22, 3, 11, 'Final', '52.90', 2, 'Plata'), -- Cathy Freeman (hipotético en 2024)
                              (2,  22, 3, 1,  'Semifinal', '55.10', NULL, NULL);

-- Triatlón Individual Masculino (evento 23), Sídney 2000 (juegos 7)
INSERT INTO participacion VALUES
                              (35, 23, 7, 12, 'Final', '1:48:24', 1, 'Oro'), -- Alistair Brownlee (hipotético en 2000)
                              (26, 23, 7, 3,  'Final', '1:49:10', 3, 'Bronce'),
                              (1,  23, 7, NULL, 'Clasificación', '1:52:00', NULL, NULL);

-- Triatlón Individual Femenino (evento 24), París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (36, 24, 3, NULL, 'Final', '1:56:30', 1, 'Oro'),   -- Flora Duffy
                              (27, 24, 3, 11,  'Final', '1:57:05', 2, 'Plata'),
                              (22, 24, 3, NULL, 'Clasificación', '2:02:00', NULL, NULL);

-- Halterofilia -81kg Masculino (evento 25), Atenas 2004 (juegos 6)
INSERT INTO participacion VALUES
                              (32, 25, 6, 18, 'Final', '210kg', 1, 'Oro'),
                              (10, 25, 6, NULL, 'Final', '195kg', 4, NULL);

-- Taekwondo -68kg Masculino (evento 27), Tokio 2020 (juegos 2)
INSERT INTO participacion VALUES
                              (34, 27, 2, 19, 'Final', NULL, 1, 'Oro'),      -- Lee Dae-Hoon
                              (3,  27, 2, NULL, 'Final', NULL, 3, 'Bronce');

-- Taekwondo -57kg Femenino (evento 28), Tokio 2020 (juegos 2)
INSERT INTO participacion VALUES
                              (33, 28, 2, 12, 'Final', NULL, 1, 'Oro'),      -- Jade Jones
                              (4,  28, 2, NULL, 'Final', NULL, 2, 'Plata');

-- Rugby 7 Final Masculina (evento 29), Sídney 2000 (juegos 7)
INSERT INTO participacion VALUES
                              (30, 29, 7, 14, 'Final', NULL, 1, 'Oro'),      -- Fiji Talanoa -> Fiyi Rugby 7
                              (31, 29, 7, 13, 'Final', NULL, 2, 'Plata');

-- Rugby 7 Final Femenina (evento 30), París 2024 (juegos 3)
INSERT INTO participacion VALUES
                              (31, 30, 3, 13, 'Final', NULL, 1, 'Oro'),      -- Portia Woodman
                              (19, 30, 3, 5,  'Final', NULL, 3, 'Bronce');   -- Marta Vieira en Brasil Fútbol (para variedad)

-- Patinaje de velocidad / deportes de invierno (usamos evento 19 y 20 como genérico)
-- 100m Espalda Masculino (evento 19) Vancouver 2010 (juegos 9) - lo usamos como "prueba de invierno" para consultas curiosas
INSERT INTO participacion VALUES
                              (38, 19, 9, 16, 'Final', '59.50', 1, 'Oro'),   -- Tessa Virtue (totalmente ficticio en natación)
                              (39, 19, 9, 16, 'Final', '1:00.10', 2, 'Plata'),
                              (40, 19, 9, NULL, 'Clasificación', '1:02.00', NULL, NULL);

/* =====================================================
   NUEVOS DEPORTISTAS DE TENIS INDIVIDUAL Y DOBLES
   ===================================================== */

INSERT INTO deportista (id_deportista, nombre, apellido, sexo, fecha_nacimiento,
                        altura_cm, peso_kg, pais_nacionalidad, pais_nacimiento, id_entrenador) VALUES
                                                                                                   (41, 'Roger', 'Federer', 'M', '1981-08-08', 185, 85, 'Suiza', 'Suiza', NULL),
                                                                                                   (42, 'Andy', 'Murray', 'M', '1987-05-15', 190, 84, 'Reino Unido', 'Reino Unido', NULL),
                                                                                                   (43, 'Alexander', 'Zverev', 'M', '1997-04-20', 198, 90, 'Alemania', 'Alemania', NULL),
                                                                                                   (44, 'Stefanos', 'Tsitsipas', 'M', '1998-08-12', 193, 84, 'Grecia', 'Grecia', NULL),
                                                                                                   (45, 'Casper', 'Ruud', 'M', '1998-12-22', 183, 80, 'Noruega', 'Noruega', NULL),

                                                                                                   (46, 'Serena', 'Williams', 'F', '1981-09-26', 175, 70, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (47, 'Venus', 'Williams', 'F', '1980-06-17', 185, 74, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (48, 'Ashleigh', 'Barty', 'F', '1996-04-24', 166, 62, 'Australia', 'Australia', NULL),
                                                                                                   (49, 'Iga', 'Świątek', 'F', '2001-05-31', 176, 64, 'Polonia', 'Polonia', NULL),
                                                                                                   (50, 'Simona', 'Halep', 'F', '1991-09-27', 168, 60, 'Rumanía', 'Rumanía', NULL),

-- Deportistas dobles (parejas reales históricas)
                                                                                                   (51, 'Bob', 'Bryan', 'M', '1978-04-29', 193, 84, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (52, 'Mike', 'Bryan', 'M', '1978-04-29', 193, 84, 'Estados Unidos', 'Estados Unidos', NULL),
                                                                                                   (53, 'Nicolas', 'Mahut', 'M', '1982-01-21', 191, 88, 'Francia', 'Francia', NULL),
                                                                                                   (54, 'Pierre-Hugues', 'Herbert', 'M', '1991-03-18', 188, 75, 'Francia', 'Francia', NULL),
                                                                                                   (55, 'Barbora', 'Strýcová', 'F', '1986-03-28', 164, 62, 'Chequia', 'Chequia', NULL);

INSERT INTO equipo (id_equipo, nombre, pais) VALUES
                                                 (21, 'España Tenis', 'España'),
                                                 (22, 'Estados Unidos Tenis', 'Estados Unidos'),
                                                 (23, 'Australia Tenis', 'Australia'),
                                                 (24, 'Francia Tenis', 'Francia'),
                                                 (25, 'Reino Unido Tenis', 'Reino Unido');

INSERT INTO deportista_equipo (id_deportista, id_equipo) VALUES
                                                             (41, 24),  -- Federer -> Francia Tenis (ejemplo, Suiza no existe como equipo)
                                                             (42, 25),  -- Murray -> Reino Unido Tenis
                                                             (43, 10),  -- Zverev -> Alemania Olímpica (ya existe)
                                                             (44, 14),  -- Tsitsipas -> Grecia Atletismo (como equipo multiusos, si quieres)
                                                             (45, 17),  -- Ruud -> Noruega Esquí (equipo mixto, útil para consultas)
                                                             (46, 22),  -- Serena -> USA Tenis
                                                             (47, 22),  -- Venus -> USA Tenis
                                                             (48, 23),  -- Barty -> Australia Tenis
                                                             (49, 21),  -- Swiatek -> España Tenis (mezcla útil para joins)
                                                             (50, 24),  -- Halep -> Francia Tenis
                                                             (51, 22),  -- Bob Bryan -> USA Tenis
                                                             (52, 22),  -- Mike Bryan -> USA Tenis
                                                             (53, 24),  -- Mahut -> Francia Tenis
                                                             (54, 24),  -- Herbert -> Francia Tenis
                                                             (55, 24);  -- Strycova -> Francia Tenis

INSERT INTO evento (id_evento, id_disciplina, nombre, genero, es_por_equipos,
                    id_estadio_principal, id_estadio_secundario) VALUES
                                                                     (31, 13, 'Tenis Dobles Masculino', 'Masculino', TRUE, 9, NULL),
                                                                     (32, 13, 'Tenis Dobles Femenino', 'Femenino', TRUE, 9, NULL);

INSERT INTO evento_juegos (id_evento, id_juegos) VALUES
                                                     (31, 5),  -- Dobles masculino en Pekín 2008
                                                     (31, 3),  -- Dobles masculino París 2024
                                                     (32, 3),  -- Dobles femenino París 2024
                                                     (32, 4);  -- Dobles femenino Londres 2012

INSERT INTO participacion VALUES
                              (41, 14, 5, NULL, 'Final', NULL, 2, 'Plata'),      -- Federer Pekín 2008
                              (42, 14, 5, 25, 'Semifinal', NULL, 3, 'Bronce'),   -- Murray
                              (43, 14, 3, NULL, 'Final', NULL, 4, NULL),         -- Zverev París 2024
                              (44, 14, 3, NULL, 'Final', NULL, 5, NULL),
                              (45, 14, 3, NULL, 'Series', NULL, NULL, NULL);

INSERT INTO participacion VALUES
                              (46, 15, 4, 22, 'Final', NULL, 1, 'Oro'),          -- Serena Londres 2012
                              (47, 15, 4, 22, 'Final', NULL, 2, 'Plata'),        -- Venus Londres 2012
                              (48, 15, 3, 23, 'Semifinal', NULL, 3, 'Bronce'),   -- Barty París 2024
                              (49, 15, 3, 21, 'Final', NULL, 1, 'Oro'),          -- Swiatek París 2024
                              (50, 15, 3, NULL, 'Series', NULL, NULL, NULL);

INSERT INTO participacion VALUES
                              (51, 31, 5, 22, 'Final', NULL, 1, 'Oro'),          -- Bob Bryan
                              (52, 31, 5, 22, 'Final', NULL, 1, 'Oro'),          -- Mike Bryan
                              (53, 31, 3, 24, 'Final', NULL, 2, 'Plata'),        -- Mahut París 2024
                              (54, 31, 3, 24, 'Final', NULL, 2, 'Plata');

INSERT INTO participacion VALUES
                              (46, 32, 4, 22, 'Final', NULL, 1, 'Oro'),          -- Serena
                              (47, 32, 4, 22, 'Final', NULL, 1, 'Oro'),          -- Venus
                              (48, 32, 3, 23, 'Final', NULL, 3, 'Bronce'),       -- Barty
                              (55, 32, 3, 24, 'Final', NULL, 2, 'Plata');        -- Strycova

/* =====================================================
   NUEVOS EVENTOS USANDO LOS ESTADIOS NUEVOS (21–80)
   Y SUS DATOS RELACIONADOS
   ===================================================== */

-- ======================
-- NUEVOS EVENTOS (id_evento 33–44)
-- ======================

INSERT INTO evento (id_evento, id_disciplina, nombre, genero, es_por_equipos,
                    id_estadio_principal, id_estadio_secundario) VALUES
-- Atletismo Fondo (disciplina 2) - España
(33, 2, '1500 Metros', 'Masculino', FALSE, 21, 25),
(34, 2, '1500 Metros', 'Femenino', FALSE, 23, NULL),

-- Atletismo Saltos (disciplina 3) - Francia
(35, 3, 'Salto de Altura Femenino', 'Femenino', FALSE, 36, 34),

-- Fútbol 11 (disciplina 7) - Brasil / Francia
(36, 7, 'Fútbol Cuartos Masculino', 'Masculino', TRUE, 30, 33),
(37, 7, 'Fútbol Cuartos Femenino', 'Femenino', TRUE, 35, 34),

-- Rugby 7 (disciplinas 22 y 23) - Australia
(38, 22, 'Rugby 7 Grupo Masculino', 'Masculino', TRUE, 38, 40),
(39, 23, 'Rugby 7 Grupo Femenino', 'Femenino', TRUE, 38, NULL),

-- Voleibol Sala / Playa (disciplinas 10 y 11) - Reino Unido / Jamaica
(40, 10, 'Voleibol Sala Grupo Femenino', 'Femenino', TRUE, 52, 50),
(41, 11, 'Voleibol Playa Grupo Femenino', 'Femenino', TRUE, 79, 80),

-- Tenis Dobles Mixto (disciplina 13) - Reino Unido
(42, 13, 'Tenis Dobles Mixto', 'Mixto', TRUE, 50, 51),

-- Triatlón (disciplina 17) - Australia
(43, 17, 'Triatlón Relevo Mixto', 'Mixto', TRUE, 41, NULL),

-- Ciclismo Ruta (disciplina 8) - Noruega
(44, 8, 'Contrarreloj Individual Masculino', 'Masculino', FALSE, 66, 67);

-- ======================
-- EVENTO_JUEGOS PARA LOS NUEVOS EVENTOS
-- (todos se disputan al menos en París 2024: id_juegos = 3)
-- ======================

INSERT INTO evento_juegos (id_evento, id_juegos) VALUES
                                                     (33, 3),
                                                     (34, 3),
                                                     (35, 3),
                                                     (36, 3),
                                                     (37, 3),
                                                     (38, 3),
                                                     (39, 3),
                                                     (40, 3),
                                                     (41, 3),
                                                     (42, 3),
                                                     (43, 3),
                                                     (44, 3);

-- ======================
-- PARTICIPACIONES EN LOS NUEVOS EVENTOS
-- (usando deportistas y equipos ya existentes)
-- ======================

-- 1500 Metros Masculino (evento 33) - París 2024 (juegos 3)
INSERT INTO participacion (id_deportista, id_evento, id_juegos, id_equipo,
                           ronda, resultado, posicion, medalla) VALUES
                                                                    (13, 33, 3, 12, 'Final', '3:32.10', 1, 'Oro'),   -- Mo Farah (Reino Unido Atletismo)
                                                                    (20, 33, 3, 6,  'Final', '3:32.80', 2, 'Plata'), -- Eliud Kipchoge (Kenia Maratón)
                                                                    (5,  33, 3, 6,  'Final', '3:34.00', 5, NULL);    -- Samuel Kipruto

-- 1500 Metros Femenino (evento 34) - París 2024
INSERT INTO participacion VALUES
                              (27, 34, 3, 11, 'Final', '4:02.00', 1, 'Oro'),   -- Cathy Freeman (Australia)
                              (36, 34, 3, NULL, 'Final', '4:03.50', 2, 'Plata'), -- Flora Duffy sin equipo
                              (2,  34, 3, 1,   'Series', '4:15.00', NULL, NULL); -- Lucía Martín

-- Salto de Altura Femenino (evento 35) - París 2024
INSERT INTO participacion VALUES
                              (28, 35, 3, NULL, 'Final', '2.05', 1, 'Oro'),    -- Blanka Vlasic
                              (21, 35, 3, 9,    'Final', '2.03', 2, 'Plata'),  -- Yulimar Rojas (Francia Balonmano, ficticio)
                              (40, 35, 3, NULL, 'Final', '1.95', 5, NULL);     -- Suzanne Schulting

-- Fútbol Cuartos Masculino (evento 36) - París 2024
INSERT INTO participacion VALUES
                              (1,  36, 3, 2, 'Cuartos', NULL, NULL, NULL),     -- Carlos Gómez -> España Fútbol
                              (3,  36, 3, 3, 'Cuartos', NULL, NULL, NULL),     -- John Smith -> USA Atletismo (ficticio)
                              (17, 36, 3, 1, 'Cuartos', NULL, NULL, NULL);     -- Rafa Nadal -> España Atletismo

-- Fútbol Cuartos Femenino (evento 37) - París 2024
INSERT INTO participacion VALUES
                              (19, 37, 3, 5,  'Semifinal', NULL, NULL, NULL),  -- Marta Vieira -> Brasil Fútbol
                              (31, 37, 3, 13, 'Semifinal', NULL, NULL, NULL),  -- Portia Woodman -> NZ Rugby 7 (ficticio)
                              (2,  37, 3, 2,  'Semifinal', NULL, NULL, NULL);  -- Lucía Martín -> España Fútbol

-- Rugby 7 Grupo Masculino (evento 38) - París 2024
INSERT INTO participacion VALUES
                              (30, 38, 3, 14, 'Final', NULL, 1, 'Oro'),        -- Fiji Talanoa -> Fiyi Rugby 7
                              (31, 38, 3, 13, 'Final', NULL, 2, 'Plata');      -- Portia Woodman -> NZ Rugby 7

-- Rugby 7 Grupo Femenino (evento 39) - París 2024
INSERT INTO participacion VALUES
                              (31, 39, 3, 13, 'Final', NULL, 1, 'Oro'),        -- Portia Woodman
                              (19, 39, 3, 5,  'Final', NULL, 3, 'Bronce');     -- Marta Vieira

-- Voleibol Sala Grupo Femenino (evento 40) - París 2024
INSERT INTO participacion VALUES
                              (31, 40, 3, 13, 'Grupo', NULL, NULL, NULL),
                              (19, 40, 3, 5,  'Grupo', NULL, NULL, NULL),
                              (2,  40, 3, 2,  'Grupo', NULL, NULL, NULL);

-- Voleibol Playa Grupo Femenino (evento 41) - París 2024
INSERT INTO participacion VALUES
                              (48, 41, 3, 23, 'Grupo', NULL, NULL, NULL),      -- Ash Barty -> Australia Tenis
                              (55, 41, 3, 24, 'Grupo', NULL, NULL, NULL);      -- Barbora Strycova -> Francia Tenis

-- Tenis Dobles Mixto (evento 42) - París 2024
INSERT INTO participacion VALUES
                              (46, 42, 3, 22, 'Final', NULL, 1, 'Oro'),        -- Serena Williams -> USA Tenis
                              (47, 42, 3, 22, 'Final', NULL, 1, 'Oro'),        -- Venus Williams
                              (41, 42, 3, 24, 'Final', NULL, 2, 'Plata'),      -- Roger Federer -> Francia Tenis (ficticio)
                              (17, 42, 3, 21, 'Final', NULL, 3, 'Bronce');     -- Rafa Nadal -> España Tenis

-- Triatlón Relevo Mixto (evento 43) - París 2024
INSERT INTO participacion VALUES
                              (35, 43, 3, 12, 'Final', '1:23:45', 1, 'Oro'),   -- Alistair Brownlee -> Reino Unido Atletismo
                              (36, 43, 3, NULL, 'Final', '1:24:10', 2, 'Plata'), -- Flora Duffy sin equipo
                              (22, 43, 3, 1,   'Final', '1:26:00', 4, NULL);   -- Mireia Belmonte -> España Atletismo

-- Contrarreloj Individual Masculino (evento 44) - París 2024
INSERT INTO participacion VALUES
                              (24, 44, 3, 12, 'Final', '58:30', 1, 'Oro'),     -- Karsten Warholm
                              (37, 44, 3, 16, 'Final', '59:10', 2, 'Plata'),   -- Mahe Drysdale -> Canadá Hockey Hielo
                              (27, 44, 3, NULL, 'Final', '1:02:20', 6, NULL);  -- Cathy Freeman sin equipo

-- Borramos la columna pais_nacimiento
ALTER TABLE deportista DROP pais_nacimiento;