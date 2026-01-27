-- CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS furboh;
USE furboh;

-- CREACIÓN DE TABLAS

-- Tabla de equipos
CREATE TABLE IF NOT EXISTS equipo (
                                      id_equipo INT AUTO_INCREMENT PRIMARY KEY,
                                      nombre VARCHAR(100) NOT NULL,
                                      ciudad VARCHAR(100) NOT NULL,
                                      fundacion INT NOT NULL,
                                      victorias INT,
                                      empates INT,
                                      derrotas INT
);

-- Tabla de jugadores con relación reflexiva para el capitán
CREATE TABLE IF NOT EXISTS jugador (
                                       id_jugador INT AUTO_INCREMENT PRIMARY KEY,
                                       nombre VARCHAR(100) NOT NULL,
                                       edad INT NOT NULL,
                                       posicion VARCHAR(50),
                                       goles INT DEFAULT 0,
                                       asistencias INT DEFAULT 0,
                                       nacionalidad VARCHAR(255),
                                       id_equipo INT,
                                       id_capitan INT, -- Nuevo campo para el capitán del equipo
                                       FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo) ON DELETE CASCADE,
                                       FOREIGN KEY (id_capitan) REFERENCES jugador(id_jugador) ON DELETE CASCADE -- Relación reflexiva
);


-- Tabla de estadios
CREATE TABLE IF NOT EXISTS estadio (
                                       id_estadio INT AUTO_INCREMENT PRIMARY KEY,
                                       nombre VARCHAR(100) NOT NULL,
                                       capacidad INT NOT NULL,
                                       ciudad VARCHAR(100) NOT NULL
);

-- Tabla de partidos
CREATE TABLE IF NOT EXISTS partido (
                                       id_partido INT AUTO_INCREMENT PRIMARY KEY,
                                       equipo_local INT,
                                       equipo_visitante INT,
                                       fecha DATE NOT NULL,
                                       goles_local INT,
                                       goles_visitante INT,
                                       id_estadio INT,
                                       FOREIGN KEY (equipo_local) REFERENCES equipo(id_equipo) ON DELETE CASCADE,
                                       FOREIGN KEY (equipo_visitante) REFERENCES equipo(id_equipo) ON DELETE CASCADE,
                                       FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio) ON DELETE CASCADE
);

-- Tabla de entrenadores
CREATE TABLE IF NOT EXISTS entrenador (
                                          id_entrenador INT AUTO_INCREMENT PRIMARY KEY,
                                          nombre VARCHAR(100) NOT NULL,
                                          nacionalidad VARCHAR(50) NOT NULL,
                                          id_equipo INT,
                                          FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo) ON DELETE CASCADE
);

-- Tabla de ligas
CREATE TABLE IF NOT EXISTS liga (
                                    id_liga INT AUTO_INCREMENT PRIMARY KEY,
                                    nombre VARCHAR(100) NOT NULL,
                                    temporada VARCHAR(20) NOT NULL
);

-- Tabla de participación en ligas (relación entre equipo y liga)
CREATE TABLE IF NOT EXISTS participacion (
                                             id_liga INT,
                                             id_equipo INT,
                                             FOREIGN KEY (id_liga) REFERENCES liga(id_liga) ON DELETE CASCADE,
                                             FOREIGN KEY (id_equipo) REFERENCES equipo(id_equipo) ON DELETE CASCADE,
                                             PRIMARY KEY (id_liga, id_equipo)
);

CREATE TABLE IF NOT EXISTS lesion (
                                      id_lesion INT AUTO_INCREMENT PRIMARY KEY,
                                      id_jugador INT,
                                      descripcion VARCHAR(200) NOT NULL,
                                      fecha_inicio DATE NOT NULL,
                                      fecha_fin DATE,
                                      FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sancion (
                                       id_sancion INT AUTO_INCREMENT PRIMARY KEY,
                                       id_jugador INT,
                                       descripcion VARCHAR(200) NOT NULL,
                                       fecha_inicio DATE NOT NULL,
                                       fecha_fin DATE,
                                       FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS transferencia (
                                             id_transferencia INT AUTO_INCREMENT PRIMARY KEY,
                                             id_jugador INT,
                                             id_equipo_origen INT,
                                             id_equipo_destino INT,
                                             fecha_transferencia DATE NOT NULL,
                                             coste_transferencia DECIMAL(20, 2),
                                             FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador) ON DELETE CASCADE,
                                             FOREIGN KEY (id_equipo_origen) REFERENCES equipo(id_equipo) ON DELETE CASCADE,
                                             FOREIGN KEY (id_equipo_destino) REFERENCES equipo(id_equipo) ON DELETE CASCADE
);


-- INSERCIÓN DE DATOS

-- Insertar equipos con los campos victorias, empates y derrotas
INSERT INTO equipo (nombre, ciudad, fundacion, victorias, empates, derrotas) VALUES
                                                                                 ('Real Madrid', 'Madrid', 1902, 28, 10, 8),
                                                                                 ('FC Barcelona', 'Barcelona', 1899, 26, 12, 6),
                                                                                 ('Atlético de Madrid', 'Madrid', 1903, 20, 15, 8),
                                                                                 ('Sevilla FC', 'Sevilla', 1890, 18, 14, 10),
                                                                                 ('Real Betis', 'Sevilla', 1907, 15, 11, 12),
                                                                                 ('Valencia CF', 'Valencia', 1919, 19, 9, 8),
                                                                                 ('Athletic Club', 'Bilbao', 1898, 14, 12, 14),
                                                                                 ('Real Sociedad', 'San Sebastián', 1909, 17, 10, 11),
                                                                                 ('Villarreal CF', 'Villarreal', 1923, 21, 8, 6),
                                                                                 ('Celta de Vigo', 'Vigo', 1923, 13, 12, 14),
                                                                                 ('Manchester United', 'Manchester', 1878, 27, 9, 5),
                                                                                 ('Liverpool FC', 'Liverpool', 1892, 25, 13, 7),
                                                                                 ('Juventus', 'Turín', 1897, 29, 10, 6),
                                                                                 ('AC Milan', 'Milán', 1899, 24, 7, 8),
                                                                                 ('Bayern Munich', 'Múnich', 1900, 31, 4, 3),
                                                                                 ('Paris Saint-Germain', 'París', 1970, 30, 5, 2),
                                                                                 ('Ajax', 'Ámsterdam', 1900, 27, 6, 5),
                                                                                 ('Borussia Dortmund', 'Dortmund', 1909, 24, 8, 10),
                                                                                 ('Inter de Milán', 'Milán', 1908, 23, 11, 9),
                                                                                 ('Chelsea FC', 'Londres', 1905, 16, 15, 8),
                                                                                 ('Napoli', 'Nápoles', 1926, 21, 9, 6), -- Serie A (Italia)
                                                                                 ('RB Leipzig', 'Leipzig', 2009, 18, 12, 7), -- Bundesliga (Alemania)
                                                                                 ('Arsenal FC', 'Londres', 1886, 22, 10, 6), -- Premier League (Inglaterra)
                                                                                 ('Olympique de Lyon', 'Lyon', 1950, 19, 14, 8), -- Ligue 1 (Francia)
                                                                                 ('PSV Eindhoven', 'Eindhoven', 1913, 23, 8, 7), -- Eredivisie (Países Bajos)
                                                                                 ('Flamengo', 'Río de Janeiro', 1895, 25, 10, 9), -- Brasileirão (Brasil)
                                                                                 ('Newcastle United', 'Newcastle', 1892, 16, 9, 10); -- Premier League (Inglaterra)

-- Insertar datos en 'jugador'

-- Real Madrid
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Luka Modric', 38, 'Centrocampista', 1, 5, 12, NULL, 'Croacia'), -- Capitán
                                                                                                          ('Vinícius Júnior', 24, 'Delantero', 1, 24, 19, 1, 'Brasil'),
                                                                                                          ('Thibaut Courtois', 31, 'Portero', 1, 0, 0, 1, 'Bélgica'),
                                                                                                          ('Toni Kroos', 33, 'Centrocampista', 1, 4, 8, 1, 'Alemania'),
                                                                                                          ('Rodrygo Goes', 23, 'Delantero', 1, 16, 9, 1, 'Brasil'),
                                                                                                          ('Eduardo Camavinga', 21, 'Centrocampista', 1, 2, 6, 1, 'Francia'),
                                                                                                          ('David Alaba', 31, 'Defensa', 1, 3, 5, 1, 'Austria'),
                                                                                                          ('Antonio Rüdiger', 30, 'Defensa', 1, 2, 2, 1, 'Alemania'),
                                                                                                          ('Federico Valverde', 25, 'Centrocampista', 1, 11, 7, 1, 'Uruguay'),
                                                                                                          ('Ferland Mendy', 28, 'Defensa', 1, 1, 3, 1, 'Francia'),
                                                                                                          ('Dani Carvajal', 32, 'Defensa', 1, 1, 4, 1, 'España'),
                                                                                                          ('Joselu Mato', 34, 'Delantero', 1, 15, 2, 1, 'España'),
                                                                                                          ('Álvaro Odriozola', 28, 'Defensa', 1, 0, 1, 1, 'España');


-- FC Barcelona
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Robert Lewandowski', 35, 'Delantero', 2, 33, 5, NULL, 'Polonia'), -- Capitán
                                                                                                          ('Pedri', 21, 'Centrocampista', 2, 10, 8, 14, 'España'),
                                                                                                          ('Ronald Araújo', 25, 'Defensa', 2, 3, 2, 14, 'Uruguay'),
                                                                                                          ('Marc-André ter Stegen', 32, 'Portero', 2, 0, 0, 14, 'Alemania'),
                                                                                                          ('Frenkie de Jong', 26, 'Centrocampista', 2, 4, 7, 14, 'Países Bajos'),
                                                                                                          ('Jules Koundé', 25, 'Defensa', 2, 2, 3, 14, 'Francia'),
                                                                                                          ('Gavi', 19, 'Centrocampista', 2, 5, 6, 14, 'España'),
                                                                                                          ('Andreas Christensen', 28, 'Defensa', 2, 2, 1, 14, 'Dinamarca'),
                                                                                                          ('Raphinha', 27, 'Delantero', 2, 14, 8, 14, 'Brasil'),
                                                                                                          ('Alejandro Balde', 20, 'Defensa', 2, 1, 5, 14, 'España'),
                                                                                                          ('Sergio Busquets', 35, 'Centrocampista', 2, 0, 4, 14, 'España'),
                                                                                                          ('Ferran Torres', 23, 'Delantero', 2, 9, 3, 14, 'España'),
                                                                                                          ('Iñaki Peña', 24, 'Portero', 2, 0, 0, 14, 'España');



-- Atlético de Madrid
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Antoine Griezmann', 33, 'Delantero', 3, 15, 12, NULL, 'Francia'), -- Capitán
                                                                                                          ('José María Giménez', 29, 'Defensa', 3, 2, 1, 27, 'Uruguay'),
                                                                                                          ('Jan Oblak', 31, 'Portero', 3, 0, 0, 27, 'Eslovenia'),
                                                                                                          ('Álvaro Morata', 31, 'Delantero', 3, 12, 4, 27, 'España'),
                                                                                                          ('Rodrigo de Paul', 29, 'Centrocampista', 3, 3, 6, 27, 'Argentina'),
                                                                                                          ('Mario Hermoso', 28, 'Defensa', 3, 2, 1, 27, 'España');


-- Sevilla FC
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Marcos Acuña', 32, 'Defensa', 4, 2, 5, NULL, 'Argentina'), -- Capitán
                                                                                                          ('Youssef En-Nesyri', 26, 'Delantero', 4, 18, 2, 33, 'Marruecos'),
                                                                                                          ('Bono', 33, 'Portero', 4, 0, 0, 33, 'Marruecos');


-- Real Betis
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Guido Rodríguez', 29, 'Centrocampista', 5, 2, 5, NULL, 'Argentina'), -- Capitán
                                                                                                          ('Borja Iglesias', 31, 'Delantero', 5, 15, 3, 36, 'España'),
                                                                                                          ('Rui Silva', 30, 'Portero', 5, 0, 0, 36, 'Portugal');


-- Valencia CF
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Mouctar Diakhaby', 27, 'Defensa', 6, 2, 1, NULL, 'Francia'), -- Capitán
                                                                                                          ('Hugo Guillamón', 24, 'Defensa', 6, 1, 3, 39, 'España'),
                                                                                                          ('Justin Kluivert', 25, 'Delantero', 6, 10, 4, 39, 'Países Bajos');



-- Athletic Club
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Iñaki Williams', 29, 'Delantero', 7, 14, 5, NULL, 'España'), -- Capitán
                                                                                                          ('Yeray Álvarez', 28, 'Defensa', 7, 1, 2, 42, 'España'),
                                                                                                          ('Unai Simón', 26, 'Portero', 7, 0, 0, 42, 'España');


-- Real Sociedad
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Mikel Oyarzabal', 27, 'Delantero', 8, 13, 6, NULL, 'España'), -- Capitán
                                                                                                          ('Alexander Isak', 25, 'Delantero', 8, 17, 4, 45, 'Suecia'),
                                                                                                          ('Robin Le Normand', 27, 'Defensa', 8, 1, 2, 45, 'Francia');


-- Villarreal CF
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Raúl Albiol', 38, 'Defensa', 9, 1, 0, NULL, 'España'), -- Capitán
                                                                                                          ('Pau Torres', 26, 'Defensa', 9, 3, 1, 48, 'España'),
                                                                                                          ('Yeremi Pino', 21, 'Delantero', 9, 12, 5, 48, 'España');



-- Celta de Vigo
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Iván Villar', 26, 'Portero', 10, 0, 0, NULL, 'España'), -- Capitán
                                                                                                          ('Gabri Veiga', 22, 'Centrocampista', 10, 8, 7, 51, 'España'),
                                                                                                          ('Joseph Aidoo', 28, 'Defensa', 10, 1, 2, 51, 'Ghana');



-- Manchester United
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Bruno Fernandes', 29, 'Centrocampista', 11, 10, 12, NULL, 'Portugal'), -- Capitán
                                                                                                          ('Harry Maguire', 31, 'Defensa', 11, 2, 1, 54, 'Inglaterra'),
                                                                                                          ('David de Gea', 33, 'Portero', 11, 0, 0, 54, 'España');


-- Liverpool FC
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Virgil van Dijk', 32, 'Defensa', 12, 3, 2, NULL, 'Países Bajos'), -- Capitán
                                                                                                          ('Diogo Jota', 27, 'Delantero', 12, 13, 7, 57, 'Portugal'),
                                                                                                          ('Alisson Becker', 31, 'Portero', 12, 0, 0, 57, 'Brasil');


-- Juventus
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Federico Chiesa', 26, 'Delantero', 13, 12, 6, NULL, 'Italia'), -- Capitán
                                                                                                          ('Leonardo Bonucci', 36, 'Defensa', 13, 1, 0, 60, 'Italia'),
                                                                                                          ('Wojciech Szczesny', 33, 'Portero', 13, 0, 0, 60, 'Polonia');


-- AC Milan
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Rafael Leão', 25, 'Delantero', 14, 16, 8, NULL, 'Portugal'), -- Capitán
                                                                                                          ('Fikayo Tomori', 26, 'Defensa', 14, 2, 1, 63, 'Inglaterra'),
                                                                                                          ('Mike Maignan', 29, 'Portero', 14, 0, 0, 63, 'Francia');


-- Bayern Munich
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Joshua Kimmich', 29, 'Centrocampista', 15, 5, 11, NULL, 'Alemania'), -- Capitán
                                                                                                          ('Thomas Müller', 35, 'Delantero', 15, 12, 9, 66, 'Alemania'),
                                                                                                          ('Manuel Neuer', 38, 'Portero', 15, 0, 0, 66, 'Alemania');


-- Paris Saint-Germain
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Achraf Hakimi', 25, 'Defensa', 16, 5, 8, NULL, 'Marruecos'), -- Capitán
                                                                                                          ('Marco Verratti', 31, 'Centrocampista', 16, 3, 6, 69, 'Italia'),
                                                                                                          ('Gianluigi Donnarumma', 25, 'Portero', 16, 0, 0, 69, 'Italia');


-- Ajax
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Steven Berghuis', 32, 'Centrocampista', 17, 10, 8, NULL, 'Países Bajos'), -- Capitán
                                                                                                          ('Jurriën Timber', 22, 'Defensa', 17, 3, 2, 72, 'Países Bajos'),
                                                                                                          ('Davy Klaassen', 31, 'Centrocampista', 17, 8, 5, 72, 'Países Bajos');


-- Borussia Dortmund
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Marco Reus', 34, 'Centrocampista', 18, 12, 10, NULL, 'Alemania'), -- Capitán
                                                                                                          ('Jude Bellingham', 21, 'Centrocampista', 18, 8, 9, 75, 'Inglaterra'),
                                                                                                          ('Mats Hummels', 35, 'Defensa', 18, 1, 1, 75, 'Alemania');


-- Inter de Milán
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Hakan Çalhanoğlu', 29, 'Centrocampista', 19, 8, 9, NULL, 'Turquía'), -- Capitán
                                                                                                          ('Alessandro Bastoni', 25, 'Defensa', 19, 2, 4, 78, 'Italia'),
                                                                                                          ('André Onana', 28, 'Portero', 19, 0, 0, 78, 'Camerún');


-- Chelsea FC
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, id_capitan, nacionalidad) VALUES
                                                                                                          ('Raheem Sterling', 29, 'Delantero', 20, 11, 6, NULL, 'Inglaterra'), -- Capitán
                                                                                                          ('Thiago Silva', 39, 'Defensa', 20, 1, 1, 81, 'Brasil'),
                                                                                                          ('Kepa Arrizabalaga', 29, 'Portero', 20, 0, 0, 81, 'España');


-- Jugadores sin equipo asociado con goles y asistencias
INSERT INTO jugador (nombre, edad, posicion, id_equipo, goles, asistencias, nacionalidad) VALUES
                                                                                              ('Fran García', 24, 'Defensa', NULL, 1, 2, 'España'),
                                                                                              ('Andriy Lunin', 24, 'Portero', NULL, 0, 0, 'Ucrania'),
                                                                                              ('Arda Güler', 18, 'Centrocampista', 1, 2, 3, 'Turquía'),
                                                                                              ('Lucas Vázquez', 32, 'Defensa', NULL, 1, 4, 'España'),
                                                                                              ('Brahim Díaz', 24, 'Centrocampista', NULL, 6, 5, 'España'),
                                                                                              ('Erling Haaland', 23, 'Delantero', NULL, 36, 8, 'Noruega'),

                                                                                              ('Eric García', 22, 'Defensa', NULL, 1, 1, 'España'),
                                                                                              ('Ansu Fati', 21, 'Delantero', NULL, 9, 4, 'España'),
                                                                                              ('Marcos Alonso', 32, 'Defensa', NULL, 2, 2, 'España'),
                                                                                              ('Sergi Roberto', 31, 'Centrocampista', NULL, 3, 3, 'España'),
                                                                                              ('Pablo Torre', 20, 'Centrocampista', NULL, 2, 4, 'España'),

                                                                                              ('Axel Witsel', 34, 'Centrocampista', NULL, 1, 5, 'Bélgica'),
                                                                                              ('Samuel Lino', 24, 'Delantero', NULL, 7, 3, 'Brasil');



-- Insertar datos en 'estadio'
INSERT INTO estadio (nombre, capacidad, ciudad) VALUES
                                                    ('Santiago Bernabéu', 81044, 'Madrid'),
                                                    ('Camp Nou', 99354, 'Barcelona'),
                                                    ('Wanda Metropolitano', 68000, 'Madrid'),
                                                    ('Ramón Sánchez-Pizjuán', 43883, 'Sevilla'),
                                                    ('Benito Villamarín', 60721, 'Sevilla'),
                                                    ('Mestalla', 55000, 'Valencia'),
                                                    ('San Mamés', 53289, 'Bilbao'),
                                                    ('Anoeta', 39500, 'San Sebastián'),
                                                    ('Estadio de la Cerámica', 23500, 'Villarreal'),
                                                    ('Balaídos', 29000, 'Vigo'),
                                                    ('Old Trafford', 74879, 'Manchester'),
                                                    ('Anfield', 53394, 'Liverpool'),
                                                    ('Allianz Stadium', 41507, 'Turín'),
                                                    ('San Siro', 80018, 'Milán'),
                                                    ('Allianz Arena', 75000, 'Múnich'),
                                                    ('Parc des Princes', 47929, 'París'),
                                                    ('Johan Cruyff Arena', 55000, 'Ámsterdam'),
                                                    ('Signal Iduna Park', 81365, 'Dortmund'),
                                                    ('Stamford Bridge', 40834, 'Londres'),
                                                    ('Giuseppe Meazza', 80018, 'Milán'),
                                                    ('Tottenham Hotspur Stadium', 62000, 'Londres'); -- Estadio del Tottenham;

-- Insertar más partidos en 'partido'

-- Real Madrid
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (1, 3, '2023-10-01', 3, 0, 1),
                                                                                                          (1, 4, '2023-09-15', 2, 2, 1),
                                                                                                          (1, 5, '2023-08-30', 1, 1, 1),
                                                                                                          (2, 1, '2023-09-22', 2, 3, 2);

-- FC Barcelona
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (2, 5, '2023-10-01', 3, 1, 2),
                                                                                                          (2, 6, '2023-09-10', 2, 2, 2),
                                                                                                          (3, 2, '2023-08-24', 1, 3, 3),
                                                                                                          (2, 10, '2023-09-18', 4, 1, 2);

-- Atlético de Madrid
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (3, 6, '2023-10-01', 2, 0, 3),
                                                                                                          (4, 3, '2023-09-10', 0, 1, 4),
                                                                                                          (3, 7, '2023-08-22', 2, 2, 3),
                                                                                                          (9, 3, '2023-07-15', 1, 2, 9);

-- Sevilla FC
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (4, 7, '2023-10-01', 3, 0, 4),
                                                                                                          (4, 8, '2023-09-10', 1, 1, 4),
                                                                                                          (5, 4, '2023-08-22', 0, 2, 5),
                                                                                                          (4, 9, '2023-07-30', 1, 0, 4);

-- Real Betis
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (5, 8, '2023-10-01', 2, 2, 5),
                                                                                                          (5, 9, '2023-09-10', 3, 1, 5),
                                                                                                          (10, 5, '2023-08-24', 1, 3, 10),
                                                                                                          (5, 6, '2023-07-30', 2, 2, 5);

-- Valencia CF
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (6, 9, '2023-10-01', 1, 0, 6),
                                                                                                          (6, 10, '2023-09-15', 2, 2, 6),
                                                                                                          (7, 6, '2023-08-24', 1, 1, 7),
                                                                                                          (6, 8, '2023-09-28', 2, 1, 6);

-- Athletic Club
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (7, 10, '2023-10-01', 2, 1, 7),
                                                                                                          (8, 7, '2023-09-10', 0, 2, 8),
                                                                                                          (7, 9, '2023-08-30', 1, 3, 7),
                                                                                                          (10, 7, '2023-09-18', 2, 0, 10);

-- Real Sociedad
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (8, 9, '2023-10-01', 4, 2, 8),
                                                                                                          (8, 10, '2023-09-10', 3, 3, 8),
                                                                                                          (9, 8, '2023-08-22', 1, 2, 9),
                                                                                                          (8, 6, '2023-09-18', 1, 0, 8);

-- Villarreal CF
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (9, 10, '2023-10-01', 3, 1, 9),
                                                                                                          (9, 5, '2023-09-10', 2, 2, 9),
                                                                                                          (10, 9, '2023-08-22', 1, 2, 10),
                                                                                                          (9, 3, '2023-07-30', 3, 0, 9);

-- Celta de Vigo
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (10, 8, '2023-10-01', 2, 3, 10),
                                                                                                          (10, 7, '2023-09-10', 1, 1, 10),
                                                                                                          (5, 10, '2023-08-24', 0, 1, 5),
                                                                                                          (10, 6, '2023-09-30', 1, 2, 10);

-- Manchester United
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (11, 12, '2023-10-01', 2, 1, 11),
                                                                                                          (11, 13, '2023-09-10', 3, 3, 11),
                                                                                                          (14, 11, '2023-08-24', 1, 2, 14),
                                                                                                          (11, 16, '2023-09-30', 1, 0, 11);

-- Liverpool FC
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (12, 14, '2023-10-01', 1, 0, 12),
                                                                                                          (12, 15, '2023-09-10', 3, 2, 12),
                                                                                                          (16, 12, '2023-08-22', 2, 3, 16),
                                                                                                          (12, 17, '2023-09-18', 2, 1, 12);

-- Juventus
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (13, 14, '2023-10-01', 1, 1, 13),
                                                                                                          (13, 15, '2023-09-10', 0, 2, 13),
                                                                                                          (17, 13, '2023-08-22', 2, 2, 17),
                                                                                                          (13, 19, '2023-09-15', 1, 3, 13);

-- AC Milan
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (14, 15, '2023-10-01', 2, 2, 14),
                                                                                                          (14, 16, '2023-09-10', 3, 1, 14),
                                                                                                          (15, 14, '2023-08-22', 1, 2, 15),
                                                                                                          (14, 18, '2023-09-30', 0, 1, 14);

-- Bayern Munich
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (15, 16, '2023-10-01', 3, 1, 15),
                                                                                                          (15, 17, '2023-09-10', 2, 2, 15),
                                                                                                          (16, 15, '2023-08-24', 1, 0, 16),
                                                                                                          (15, 20, '2023-09-18', 2, 3, 15);

-- Paris Saint-Germain
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (16, 17, '2023-10-01', 3, 1, 16),
                                                                                                          (16, 18, '2023-09-10', 1, 2, 16),
                                                                                                          (17, 16, '2023-08-24', 0, 3, 17),
                                                                                                          (16, 19, '2023-09-15', 2, 2, 16);

-- Ajax
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (17, 18, '2023-10-01', 2, 3, 17),
                                                                                                          (17, 19, '2023-09-10', 3, 1, 17),
                                                                                                          (18, 17, '2023-08-24', 1, 2, 18),
                                                                                                          (17, 20, '2023-09-30', 1, 3, 17);

-- Borussia Dortmund
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (18, 19, '2023-10-01', 2, 1, 18),
                                                                                                          (18, 20, '2023-09-10', 1, 1, 18),
                                                                                                          (19, 18, '2023-08-24', 0, 2, 19),
                                                                                                          (18, 11, '2023-09-15', 1, 3, 18);

-- Inter de Milán
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (19, 20, '2023-10-01', 3, 2, 19),
                                                                                                          (19, 11, '2023-09-10', 1, 0, 19),
                                                                                                          (20, 19, '2023-08-24', 2, 3, 20),
                                                                                                          (19, 13, '2023-09-30', 1, 1, 19);

-- Chelsea FC
INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (20, 11, '2023-10-01', 2, 1, 20),
                                                                                                          (20, 12, '2023-09-10', 1, 2, 20),
                                                                                                          (13, 20, '2023-08-24', 0, 3, 13),
                                                                                                          (20, 16, '2023-09-30', 2, 1, 20),
                                                                                                          (12, 14, '2023-11-10', 2, 3, NULL); -- Partido sin estadio definido;

INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (1, 2, '2021-01-15', 2, 1, 1),
                                                                                                          (3, 4, '2021-02-10', 1, 1, 3),
                                                                                                          (5, 6, '2021-03-22', 0, 2, 5),
                                                                                                          (7, 8, '2021-04-18', 3, 0, 7),
                                                                                                          (9, 10, '2021-05-03', 1, 3, 9),
                                                                                                          (11, 12, '2021-06-14', 2, 2, 11),
                                                                                                          (13, 14, '2021-07-07', 0, 1, 13),
                                                                                                          (15, 16, '2021-08-29', 4, 2, 15),
                                                                                                          (17, 18, '2021-09-11', 3, 3, 17),
                                                                                                          (19, 20, '2021-10-20', 1, 0, 19),
                                                                                                          (2, 3, '2021-11-02', 2, 2, 2),
                                                                                                          (4, 1, '2021-12-12', 1, 4, 4);

INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (6, 7, '2022-01-20', 1, 1, 6),
                                                                                                          (8, 9, '2022-02-17', 2, 0, 8),
                                                                                                          (10, 11, '2022-03-22', 3, 2, 10),
                                                                                                          (12, 13, '2022-04-30', 0, 0, 12),
                                                                                                          (14, 15, '2022-05-15', 1, 3, 14),
                                                                                                          (16, 17, '2022-06-09', 4, 1, 16),
                                                                                                          (18, 19, '2022-07-27', 2, 2, 18),
                                                                                                          (20, 1, '2022-08-19', 0, 1, 20),
                                                                                                          (3, 5, '2022-09-05', 3, 3, 3),
                                                                                                          (7, 2, '2022-10-25', 2, 0, 7);

INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (1, 5, '2024-01-10', 3, 1, 1),
                                                                                                          (2, 6, '2024-01-22', 1, 0, 2),
                                                                                                          (3, 7, '2024-02-14', 4, 2, 3),
                                                                                                          (4, 8, '2024-02-28', 2, 2, 4),
                                                                                                          (9, 1, '2024-03-09', 0, 3, 9),
                                                                                                          (10, 2, '2024-03-21', 1, 1, 10),
                                                                                                          (11, 3, '2024-04-01', 3, 4, 11),
                                                                                                          (12, 4, '2024-04-18', 1, 0, 12),
                                                                                                          (13, 5, '2024-05-02', 2, 2, 13),
                                                                                                          (14, 6, '2024-05-20', 1, 3, 14),
                                                                                                          (15, 7, '2024-06-11', 0, 2, 15),
                                                                                                          (16, 8, '2024-06-25', 4, 1, 16),
                                                                                                          (17, 9, '2024-07-13', 1, 1, 17),
                                                                                                          (18, 10, '2024-08-07', 3, 2, 18),
                                                                                                          (19, 11, '2024-09-30', 2, 0, 19);

INSERT INTO partido (equipo_local, equipo_visitante, fecha, goles_local, goles_visitante, id_estadio) VALUES
                                                                                                          (20, 14, '2025-01-12', 1, 1, 20),
                                                                                                          (1, 3, '2025-02-03', 2, 0, 1),
                                                                                                          (5, 8, '2025-03-17', 0, 2, 5),
                                                                                                          (6, 9, '2025-04-29', 3, 3, 6),
                                                                                                          (7, 10, '2025-05-21', 4, 1, 7),
                                                                                                          (11, 13, '2025-06-02', 1, 2, 11),
                                                                                                          (12, 15, '2025-07-18', 2, 2, 12),
                                                                                                          (16, 18, '2025-08-05', 3, 3, 16),
                                                                                                          (17, 20, '2025-09-14', 0, 1, 17),
                                                                                                          (4, 2, '2025-10-01', 1, 0, 4);

-- Insertar datos en 'entrenador'
INSERT INTO entrenador (nombre, nacionalidad, id_equipo) VALUES
                                                             ('Carlo Ancelotti', 'Italia', 1),
                                                             ('Xavi Hernández', 'España', 2),
                                                             ('Diego Simeone', 'Argentina', 3),
                                                             ('Julen Lopetegui', 'España', 4),
                                                             ('Manuel Pellegrini', 'Chile', 5),
                                                             ('José Bordalás', 'España', 6),
                                                             ('Marcelino García', 'España', 7),
                                                             ('Imanol Alguacil', 'España', 8),
                                                             ('Unai Emery', 'España', 9),
                                                             ('Carlos Carvalhal', 'Portugal', 10),
                                                             ('Erik ten Hag', 'Países Bajos', 11),
                                                             ('Jürgen Klopp', 'Alemania', 12),
                                                             ('Massimiliano Allegri', 'Italia', 13),
                                                             ('Stefano Pioli', 'Italia', 14),
                                                             ('Thomas Tuchel', 'Alemania', 15),
                                                             ('Luis Enrique', 'España', 16),
                                                             ('Maurice Steijn', 'Países Bajos', 17),
                                                             ('Edin Terzic', 'Alemania', 18),
                                                             ('Simone Inzaghi', 'Italia', 19),
                                                             ('Mauricio Pochettino', 'Argentina', 20);

-- Entrenadores sin equipo asociado
INSERT INTO entrenador (nombre, nacionalidad, id_equipo) VALUES
                                                             ('Mauricio Sarri', 'Italia', NULL),
                                                             ('Marcelo Gallardo', 'Argentina', NULL),
                                                             ('Ernesto Valverde', 'España', NULL),
                                                             ('Didier Deschamps', 'Francia', NULL),
                                                             ('Zinedine Zidane', 'Francia', NULL);

-- Insertar datos en 'liga'
INSERT INTO liga (nombre, temporada) VALUES
                                         ('La Liga', '2023/2024'),
                                         ('Copa del Rey', '2023/2024'),
                                         ('Premier League', '2023/2024'),
                                         ('Serie A', '2023/2024'),
                                         ('Bundesliga', '2023/2024'),
                                         ('Ligue 1', '2023/2024'),
                                         ('Eredivisie', '2023/2024'),
                                         ('Champions League', '2023/2024'),
                                         ('Europa League', '2023/2024'),
                                         ('FA Cup', '2023/2024');

-- Insertar participaciones de equipos en ligas nacionales y la Champions League

-- Equipos españoles participando en La Liga y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (1, 1),  -- Real Madrid en La Liga
                                                   (1, 2),  -- FC Barcelona en La Liga
                                                   (1, 3),  -- Atlético de Madrid en La Liga
                                                   (8, 1),  -- Real Madrid en Champions League
                                                   (8, 2),  -- FC Barcelona en Champions League
                                                   (8, 3);  -- Atlético de Madrid en Champions League

-- Equipos ingleses participando en la Premier League y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (3, 11),  -- Manchester United en Premier League
                                                   (3, 12),  -- Liverpool FC en Premier League
                                                   (8, 11),  -- Manchester United en Champions League
                                                   (8, 12);  -- Liverpool FC en Champions League

-- Equipos italianos participando en la Serie A y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (4, 13),  -- Juventus en Serie A
                                                   (4, 14),  -- AC Milan en Serie A
                                                   (8, 13),  -- Juventus en Champions League
                                                   (8, 14);  -- AC Milan en Champions League

-- Equipos alemanes participando en la Bundesliga y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (5, 15),  -- Bayern Munich en Bundesliga
                                                   (5, 18),  -- Borussia Dortmund en Bundesliga
                                                   (8, 15),  -- Bayern Munich en Champions League
                                                   (8, 18);  -- Borussia Dortmund en Champions League

-- Equipos franceses participando en la Ligue 1 y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (6, 16),  -- Paris Saint-Germain en Ligue 1
                                                   (8, 16);  -- Paris Saint-Germain en Champions League

-- Equipos neerlandeses participando en la Eredivisie y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (7, 17),  -- Ajax en Eredivisie
                                                   (8, 17);  -- Ajax en Champions League

-- Equipos italianos participando en la Serie A y en la Champions League
INSERT INTO participacion (id_liga, id_equipo) VALUES
                                                   (4, 19),  -- Inter de Milán en Serie A
                                                   (8, 19);  -- Inter de Milán en Champions League

-- Insertar datos en 'lesion'
INSERT INTO lesion (id_jugador, descripcion, fecha_inicio, fecha_fin) VALUES
                                                                          (1, 'Lesión en el tobillo', '2023-08-01', '2023-09-01'),
                                                                          (2, 'Lesión muscular', '2023-09-15', '2023-10-15'),
                                                                          (3, 'Lesión en la rodilla', '2023-07-01', '2023-08-01'),
                                                                          (4, 'Lesión en el hombro', '2023-10-01', NULL),
                                                                          (5, 'Lesión en el muslo', '2023-08-15', '2023-09-15'),
                                                                          (6, 'Lesión en el pie', '2023-09-01', '2023-10-01'),
                                                                          (7, 'Lesión en la cadera', '2023-07-15', '2023-08-15'),
                                                                          (8, 'Lesión en el codo', '2023-10-15', NULL),
                                                                          (9, 'Lesión en la espalda', '2023-08-01', '2023-09-01'),
                                                                          (10, 'Lesión en la pierna', '2023-09-15', '2023-10-15'),
                                                                          (11, 'Lesión en el brazo', '2023-07-01', '2023-08-01'),
                                                                          (12, 'Lesión en la mano', '2023-10-01', NULL),
                                                                          (13, 'Lesión en el dedo', '2023-08-15', '2023-09-15'),
                                                                          (14, 'Lesión en el muslo', '2023-09-01', '2023-10-01'),
                                                                          (15, 'Lesión en la pantorrilla', '2023-07-15', '2023-08-15'),
                                                                          (16, 'Lesión en el tendón', '2023-10-15', NULL),
                                                                          (17, 'Lesión en el ligamento', '2023-08-01', '2023-09-01'),
                                                                          (18, 'Lesión en el menisco', '2023-09-15', '2023-10-15'),
                                                                          (19, 'Lesión en el tobillo', '2023-07-01', '2023-08-01'),
                                                                          (20, 'Lesión en la cabeza', '2023-10-01', NULL),
                                                                          (1, 'Lesión en el tobillo', '2023-08-01', '2023-09-01'),
                                                                          (1, 'Lesión muscular', '2023-09-15', '2023-10-15'),
                                                                          (2, 'Lesión en la rodilla', '2023-07-01', '2023-08-01'),
                                                                          (3, 'Lesión en el hombro', '2023-10-01', NULL),
                                                                          (1, 'Lesión en el muslo', '2023-08-15', '2023-09-15'),
                                                                          (4, 'Lesión en el pie', '2023-09-01', '2023-10-01'),
                                                                          (5, 'Lesión en la cadera', '2023-07-15', '2023-08-15'),
                                                                          (2, 'Lesión en el codo', '2023-10-15', NULL),
                                                                          (3, 'Lesión en la espalda', '2023-08-01', '2023-09-01'),
                                                                          (6, 'Lesión en la pierna', '2023-09-15', '2023-10-15'),
                                                                          (1, 'Lesión en el brazo', '2023-07-01', '2023-08-01'),
                                                                          (7, 'Lesión en la mano', '2023-10-01', NULL),
                                                                          (8, 'Lesión en el dedo', '2023-08-15', '2023-09-15'),
                                                                          (9, 'Lesión en el muslo', '2023-09-01', '2023-10-01'),
                                                                          (10, 'Lesión en la pantorrilla', '2023-07-15', '2023-08-15'),
                                                                          (2, 'Lesión en el tendón', '2023-10-15', NULL),
                                                                          (11, 'Lesión en el ligamento', '2023-08-01', '2023-09-01'),
                                                                          (12, 'Lesión en el menisco', '2023-09-15', '2023-10-15'),
                                                                          (13, 'Lesión en el tobillo', '2023-07-01', '2023-08-01'),
                                                                          (14, 'Lesión en la cabeza', '2023-10-01', NULL);


-- Insertar datos en 'sancion'
INSERT INTO sancion (id_jugador, descripcion, fecha_inicio, fecha_fin) VALUES
                                                                           (1, 'Tarjeta roja', '2023-08-01', '2023-08-15'),
                                                                           (2, 'Suspensión por acumulación de tarjetas', '2023-09-15', '2023-09-30'),
                                                                           (3, 'Sanción por conducta antideportiva', '2023-07-01', '2023-07-15'),
                                                                           (4, 'Suspensión por lesión a un rival', '2023-10-01', NULL),
                                                                           (5, 'Sanción por insultos al árbitro', '2023-08-15', '2023-09-01'),
                                                                           (6, 'Tarjeta amarilla acumulada', '2023-09-01', '2023-09-15'),
                                                                           (7, 'Sanción por falta de respeto al rival', '2023-07-15', '2023-08-01'),
                                                                           (8, 'Suspensión por agresión a un compañero', '2023-10-15', NULL),
                                                                           (9, 'Sanción por falta de respeto al árbitro', '2023-08-01', '2023-08-15'),
                                                                           (10, 'Tarjeta roja directa', '2023-09-15', '2023-09-30'),
                                                                           (11, 'Sanción por comportamiento inapropiado', '2023-07-01', '2023-07-15'),
                                                                           (12, 'Suspensión por uso de sustancias prohibidas', '2023-10-01', NULL),
                                                                           (13, 'Sanción por falta de respeto al público', '2023-08-15', '2023-09-01'),
                                                                           (14, 'Tarjeta amarilla por simulación', '2023-09-01', '2023-09-15'),
                                                                           (15, 'Sanción por falta de respeto a un rival', '2023-07-15', '2023-08-01'),
                                                                           (16, 'Suspensión por agresión a un árbitro', '2023-10-15', NULL),
                                                                           (17, 'Sanción por falta de respeto a un entrenador', '2023-08-01', '2023-08-15'),
                                                                           (18, 'Tarjeta roja por doble amarilla', '2023-09-15', '2023-09-30'),
                                                                           (19, 'Sanción por comportamiento antideportivo', '2023-07-01', '2023-07-15'),
                                                                           (20, 'Suspensión por uso de lenguaje ofensivo', '2023-10-01', NULL),
                                                                           (1, 'Tarjeta roja', '2023-08-01', '2023-08-15'),
                                                                           (1, 'Suspensión por acumulación de tarjetas', '2023-09-15', '2023-09-30'),
                                                                           (2, 'Sanción por conducta antideportiva', '2023-07-01', '2023-07-15'),
                                                                           (3, 'Suspensión por lesión a un rival', '2023-10-01', NULL),
                                                                           (1, 'Sanción por insultos al árbitro', '2023-08-15', '2023-09-01'),
                                                                           (4, 'Tarjeta amarilla acumulada', '2023-09-01', '2023-09-15'),
                                                                           (5, 'Sanción por falta de respeto al rival', '2023-07-15', '2023-08-01'),
                                                                           (2, 'Suspensión por agresión a un compañero', '2023-10-15', NULL),
                                                                           (3, 'Sanción por falta de respeto al árbitro', '2023-08-01', '2023-08-15'),
                                                                           (6, 'Tarjeta roja directa', '2023-09-15', '2023-09-30'),
                                                                           (1, 'Sanción por comportamiento inapropiado', '2023-07-01', '2023-07-15'),
                                                                           (7, 'Suspensión por uso de sustancias prohibidas', '2023-10-01', NULL),
                                                                           (8, 'Sanción por falta de respeto al público', '2023-08-15', '2023-09-01'),
                                                                           (9, 'Tarjeta amarilla por simulación', '2023-09-01', '2023-09-15'),
                                                                           (10, 'Sanción por falta de respeto a un rival', '2023-07-15', '2023-08-01'),
                                                                           (2, 'Suspensión por agresión a un árbitro', '2023-10-15', NULL),
                                                                           (11, 'Sanción por falta de respeto a un entrenador', '2023-08-01', '2023-08-15'),
                                                                           (12, 'Tarjeta roja por doble amarilla', '2023-09-15', '2023-09-30'),
                                                                           (13, 'Sanción por comportamiento antideportivo', '2023-07-01', '2023-07-15'),
                                                                           (14, 'Suspensión por uso de lenguaje ofensivo', '2023-10-01', NULL);


-- Insertar datos en 'transferencia'
INSERT INTO transferencia (id_jugador, id_equipo_origen, id_equipo_destino, fecha_transferencia, coste_transferencia) VALUES
                                                                                                                          (1, 1, 2, '2023-07-01', 50000000.00),
                                                                                                                          (2, 2, 3, '2023-08-01', 30000000.00),
                                                                                                                          (3, 3, 1, '2023-09-01', 40000000.00),
                                                                                                                          (4, 4, 5, '2023-07-15', 20000000.00),
                                                                                                                          (5, 5, 6, '2023-08-15', 15000000.00),
                                                                                                                          (6, 6, 7, '2023-09-15', 25000000.00),
                                                                                                                          (7, 7, 8, '2023-07-01', 35000000.00),
                                                                                                                          (8, 8, 9, '2023-08-01', 45000000.00),
                                                                                                                          (9, 9, 10, '2023-09-01', 10000000.00),
                                                                                                                          (10, 10, 11, '2023-07-15', 60000000.00),
                                                                                                                          (11, 11, 12, '2023-08-15', 70000000.00),
                                                                                                                          (12, 12, 13, '2023-09-15', 80000000.00),
                                                                                                                          (13, 13, 14, '2023-07-01', 90000000.00),
                                                                                                                          (14, 14, 15, '2023-08-01', 100000000.00),
                                                                                                                          (15, 15, 16, '2023-09-01', 110000000.00),
                                                                                                                          (16, 16, 17, '2023-07-15', 120000000.00),
                                                                                                                          (17, 17, 18, '2023-08-15', 130000000.00),
                                                                                                                          (18, 18, 19, '2023-09-15', 140000000.00),
                                                                                                                          (19, 19, 20, '2023-07-01', 150000000.00),
                                                                                                                          (20, 20, 1, '2023-08-01', 160000000.00),
                                                                                                                          (1, 1, 2, '2023-07-01', 50000000.00),
                                                                                                                          (2, 1, 3, '2023-08-01', 30000000.00), -- Real Madrid vende a otro jugador
                                                                                                                          (3, 3, 1, '2023-09-01', 40000000.00),
                                                                                                                          (4, 1, 5, '2023-07-15', 20000000.00), -- Real Madrid vende a otro jugador
                                                                                                                          (5, 5, 6, '2023-08-15', 15000000.00),
                                                                                                                          (6, 6, 7, '2023-09-15', 25000000.00),
                                                                                                                          (7, 7, 8, '2023-07-01', 35000000.00),
                                                                                                                          (8, 8, 9, '2023-08-01', 45000000.00),
                                                                                                                          (9, 9, 10, '2023-09-01', 10000000.00),
                                                                                                                          (10, 10, 11, '2023-07-15', 60000000.00),
                                                                                                                          (11, 11, 12, '2023-08-15', 70000000.00),
                                                                                                                          (12, 12, 13, '2023-09-15', 80000000.00),
                                                                                                                          (13, 13, 14, '2023-07-01', 90000000.00),
                                                                                                                          (14, 14, 15, '2023-08-01', 100000000.00),
                                                                                                                          (15, 15, 16, '2023-09-01', 110000000.00),
                                                                                                                          (16, 16, 17, '2023-07-15', 120000000.00),
                                                                                                                          (17, 17, 18, '2023-08-15', 130000000.00),
                                                                                                                          (18, 18, 19, '2023-09-15', 140000000.00),
                                                                                                                          (19, 19, 20, '2023-07-01', 150000000.00),
                                                                                                                          (20, 20, 1, '2023-08-01', 160000000.00);