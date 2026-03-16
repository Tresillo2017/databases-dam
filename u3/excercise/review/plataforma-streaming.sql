CREATE DATABASE plataforma_streaming;
USE plataforma_streaming;

-- =========================================================
-- GÉNEROS
-- (principal obligatorio, secundario opcional en película/serie)
-- =========================================================
CREATE TABLE genero (
  id_genero INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE
);

-- =========================================================
-- PELÍCULA (incluye relación reflexiva para secuelas)
-- =========================================================
CREATE TABLE pelicula (
  id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  sinopsis TEXT,
  fecha_estreno DATE,
  duracion_min INT,
  idioma_original VARCHAR(80),
  clasificacion_edad ENUM('TP','7+','12+','16+','18+') DEFAULT 'TP',
  presupuesto DECIMAL(12,2),
  recaudacion DECIMAL(12,2),

  id_genero_principal INT NOT NULL,
  id_genero_secundario INT NULL,

  -- Relación reflexiva: esta película es secuela de otra
  id_pelicula_secuela INT NULL,

  FOREIGN KEY (id_genero_principal) REFERENCES genero(id_genero) ON DELETE CASCADE,
  FOREIGN KEY (id_genero_secundario) REFERENCES genero(id_genero) ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula_secuela) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

-- =========================================================
-- SERIE
-- =========================================================
CREATE TABLE serie (
  id_serie INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  sinopsis TEXT,
  fecha_estreno DATE,
  idioma_original VARCHAR(80),
  clasificacion_edad ENUM('TP','7+','12+','16+','18+') DEFAULT 'TP',
  estado ENUM('EN_EMISION','FINALIZADA','CANCELADA') DEFAULT 'EN_EMISION',
  numero_temporadas INT DEFAULT 1,

  id_genero_principal INT NOT NULL,
  id_genero_secundario INT NULL,

  FOREIGN KEY (id_genero_principal) REFERENCES genero(id_genero) ON DELETE CASCADE,
  FOREIGN KEY (id_genero_secundario) REFERENCES genero(id_genero) ON DELETE CASCADE
);

-- =========================================================
-- EPISODIO (asociado directamente a serie, sin tabla temporada)
-- =========================================================
CREATE TABLE episodio (
  id_episodio INT AUTO_INCREMENT PRIMARY KEY,
  id_serie INT NOT NULL,
  numero_temporada INT NOT NULL,
  numero_episodio INT NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  duracion_min INT,
  fecha_estreno DATE,
  UNIQUE (id_serie, numero_temporada, numero_episodio),
  FOREIGN KEY (id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE
);

-- =========================================================
-- ACTORES
-- =========================================================
CREATE TABLE actor (
  id_actor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  fecha_nacimiento DATE,
  pais VARCHAR(100)
);

-- =========================================================
-- REPARTO (tabla intermedia unificada para series y películas)
-- IMPORTANTE (didáctico):
--   - Una fila debe referir a una película (id_pelicula) O a una serie (id_serie).
--   - Sin CHECK, esto se controla por convención (o desde la app / profesor).
-- =========================================================
CREATE TABLE reparto (
  id_reparto INT AUTO_INCREMENT PRIMARY KEY,
  id_actor INT NOT NULL,
  id_pelicula INT NULL,
  id_serie INT NULL,
  personaje VARCHAR(150),

  FOREIGN KEY (id_actor) REFERENCES actor(id_actor) ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE,
  FOREIGN KEY (id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE,

  UNIQUE (id_actor, id_pelicula, id_serie)
);

-- =========================================================
-- USUARIOS
-- =========================================================
CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(200) NOT NULL UNIQUE,
  nombre_usuario VARCHAR(60) NOT NULL UNIQUE,
  nombre VARCHAR(80),
  apellido VARCHAR(120),
  fecha_nacimiento DATE,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  pais VARCHAR(100)
);

-- =========================================================
-- VISUALIZACIÓN (asociada a película O episodio)
-- =========================================================
CREATE TABLE visualizacion (
  id_visualizacion INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_pelicula INT,
  id_episodio INT,
  fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_fin DATETIME,
  dispositivo VARCHAR(80),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE,
  FOREIGN KEY (id_episodio) REFERENCES episodio(id_episodio) ON DELETE CASCADE
);

-- =========================================================
-- INSERCIONES DE DATOS
-- =========================================================

INSERT INTO genero (nombre) VALUES
('Ciencia ficción'),('Drama'),('Acción'),('Comedia'),('Terror'),('Misterio'),('Animación'),('Aventura'),('Thriller'),('Romance'),('Fantástico'),('Documental'),('Suspense'),('Familia'),('Crimen'),('Biográfico');

/* =====================================================
   PELÍCULAS
   ===================================================== */

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
-- Bloque 1
('El muro negro','Thriller alemán de misterio y confinamiento','2025-07-10',120,'Alemán','16+',20.00,85.00,9,6,NULL),
('Las guerreras Kpop','Animación musical de acción y fantasía','2025-06-20',110,'Inglés','12+',30.00,236.00,7,2,NULL),
('Wake Up Dead Man','Suspense policial con misterio profundo','2025-12-12',115,'Inglés','16+',50.00,140.00,9,15,NULL),
('Wicked Parte II','Musical fantástico continuación de Wicked','2025-11-06',140,'Inglés','7+',150.00,230.00,11,2,NULL),
('Zootrópolis 2','Animación familiar de aventuras','2025-11-20',115,'Inglés','TP',200.00,310.00,7,14,NULL),
('El hoyo 2','Terror sci-fi que retoma el universo de El hoyo','2024-10-04',130,'Español','16+',25.00,120.00,5,1,NULL),
('Rebel Moon - Parte 2: La guerrera que deja marca','Fantasía épica secuela espacial','2024-04-19',135,'Inglés','12+',140.00,220.00,8,9,NULL),

-- Bloque 2 (clásicos / populares)
('El padrino Parte II','Continuación de la saga de los Corleone','1974-12-18',202,'Inglés','16+',13.0,92.0,15,2,NULL),
('El padrino','Saga de crimen y familia italiana','1972-03-24',175,'Inglés','16+',6.0,245.0,15,2,8),
('El caballero oscuro','Batman lucha contra el crimen en Gotham','2008-07-18',152,'Inglés','12+',185.0,534.0,3,9,NULL),
('12 hombres sin piedad','Debate de jurado en un caso de homicidio','1957-04-10',96,'Inglés','12+',1.0,4.0,2,15,NULL),
('Forrest Gump','Historia de un hombre con gran corazón','1994-07-06',142,'Inglés','7+',55.0,678.0,2,10,NULL),
('Interstellar','Exploración espacial y la relatividad','2014-11-07',169,'Inglés','12+',165.0,677.0,1,8,NULL),
('Blade Runner 2049','Detective en un futuro distópico','2017-10-06',164,'Inglés','12+',150.0,259.0,1,9,NULL),
('Matrix Revolutions','Conclusión de la trilogía Matrix','2003-11-05',129,'Inglés','12+',110.0,427.0,1,8,NULL),
('Matrix Reloaded','Secuela de Matrix con más acción','2003-05-15',138,'Inglés','12+',127.0,741.0,1,8,15),
('Matrix','Realidad simulada vs humanidad','1999-03-31',136,'Inglés','12+',63.0,466.0,1,8,16),
('Gladiator','Un centurión busca justicia en Roma','2000-05-05',155,'Inglés','16+',103.0,460.0,3,2,NULL),
('El silencio de los inocentes','Thriller con Hannibal Lecter','1991-02-14',118,'Inglés','16+',19.0,272.0,9,15,NULL),
('Los siete samuráis','Clásico de samuráis y honor','1954-04-26',207,'Japonés','12+',3.0,10.0,8,2,NULL),
('Salvando al soldado Ryan','Segunda Guerra Mundial intenso','1998-07-24',169,'Inglés','16+',70.0,482.0,3,2,NULL),
('Pulp Fiction','Historias entrelazadas del crimen','1994-10-14',154,'Inglés','16+',8.0,214.0,15,3,NULL),
('Origen','Sueños dentro de sueños','2010-07-16',148,'Inglés','12+',160.0,829.0,1,9,NULL),
('Kingsman: The Blue Blood','Acción y espionaje británico','2025-09-20',141,'Inglés','16+',150.0,360.0,3,9,NULL),
('Una batalla tras otra','Drama histórico de guerra','2025-07-18',123,'Inglés','16+',40.0,85.0,2,8,NULL),
('Bad Boys: Ride or Die','Comedia policíaca de acción','2025-06-14',124,'Inglés','12+',150.0,420.0,3,4,NULL),
('Frankenstein','Adaptación moderna de un clásico','2025-08-09',130,'Inglés','16+',90.0,210.0,5,1,NULL),
('El misterio de la familia Carman','Comedia dramática familiar','2025-11-22',115,'Inglés','12+',30.0,87.0,4,2,NULL),
('En sueños','Romance fantástico contemporáneo','2025-10-15',105,'Inglés','12+',25.0,95.0,10,2,NULL),
('Selena y los Dinos','Biografía musical vibrante','2025-09-10',118,'Inglés','12+',45.0,170.0,2,10,NULL),
('Una Navidad Extra','Comedia navideña familiar','2025-12-01',98,'Inglés','TP',20.0,130.0,4,14,NULL),
('Aquaman y el reino perdido','Superhéroes y aventuras submarinas','2023-12-20',143,'Inglés','12+',160.0,360.0,8,3,NULL),
('Nosferatu','Terror clásico reimaginado','2025-10-30',125,'Inglés','16+',30.0,75.0,5,9,NULL),
('Materialistas','Comedia romántica contemporánea','2025-08-12',112,'Inglés','12+',35.0,102.0,4,10,NULL),
('Highest 2 Lowest','Acción y drama urbano','2025-03-21',118,'Inglés','16+',60.0,130.0,3,15,NULL),
('The Brutalist','Drama histórico internacional','2025-02-28',130,'Inglés','16+',50.0,145.0,2,15,NULL);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
-- Animación
('Toy Story 3','Los juguetes afrontan el abandono','2010-06-18',103,'Inglés','TP',200,1067,7,14,NULL),
('Toy Story 2','Woody es robado por un coleccionista','1999-11-24',92,'Inglés','TP',90,497,7,14,37),
('Toy Story','Juguetes cobran vida cuando nadie mira','1995-11-22',81,'Inglés','TP',30,373,7,14,38),
('Up','Un anciano viaja en su casa voladora','2009-05-29',96,'Inglés','TP',175,735,7,14,NULL),
('Del revés','Las emociones toman protagonismo','2015-06-19',95,'Inglés','TP',175,858,7,14,NULL),

-- Ciencia ficción
('Blade Runner','Cazador de androides en futuro distópico','1982-06-25',117,'Inglés','16+',28,41,1,9,14),
('2001: Una odisea del espacio','Viaje cósmico y evolución humana','1968-04-03',149,'Inglés','TP',12,146,1,8,NULL),
('Terminator','Un cyborg viaja al pasado','1984-10-26',107,'Inglés','16+',6,78,1,3,NULL),
('E.T.','Un extraterrestre perdido en la Tierra','1982-06-11',115,'Inglés','TP',10,792,1,14,NULL),
('Distrito 9','Alienígenas refugiados en la Tierra','2009-08-14',112,'Inglés','16+',30,210,1,9,NULL),

-- Acción / aventura
('Indiana Jones y la última cruzada','Búsqueda del Santo Grial','1989-05-24',127,'Inglés','12+',48,474,8,3,NULL),
('Mad Max: Fury Road','Huida extrema en mundo postapocalíptico','2015-05-15',120,'Inglés','16+',150,380,3,8,NULL),
('Jurassic Park','Dinosaurios clonados escapan','1993-06-11',127,'Inglés','12+',63,1029,8,1,NULL),
('Piratas del Caribe','Aventura de piratas malditos','2003-07-09',143,'Inglés','12+',140,654,8,3,NULL),

-- Drama
('Cadena perpetua','Esperanza en prisión','1994-09-23',142,'Inglés','16+',25,73,2,15,NULL),
('El club de la lucha','Crítica a la sociedad moderna','1999-10-15',139,'Inglés','18+',63,101,2,15,NULL),
('American Beauty','Crisis vital suburbana','1999-09-15',122,'Inglés','16+',15,356,2,10,NULL),
('El pianista','Supervivencia durante el Holocausto','2002-09-25',150,'Inglés','16+',35,120,2,15,NULL),

-- Comedia
('Atrapado en el tiempo','El mismo día se repite','1993-02-12',101,'Inglés','TP',14,70,4,10,NULL),
('La máscara','Comedia con poderes absurdos','1994-07-29',101,'Inglés','TP',23,351,4,1,NULL),
('Supersalidos','Comedia adolescente','2007-08-17',113,'Inglés','16+',20,170,4,NULL,NULL),

-- Terror
('El exorcista','Posesión demoníaca','1973-12-26',122,'Inglés','18+',12,441,5,15,NULL),
('It','Payaso aterrador regresa','2017-09-08',135,'Inglés','16+',35,701,5,9,NULL),
('Hereditary','Horror psicológico familiar','2018-06-08',127,'Inglés','16+',10,80,5,2,NULL),

-- Romance
('Titanic','Amor durante el desastre','1997-12-19',195,'Inglés','12+',200,2264,10,2,NULL),
('La La Land','Sueños y amor en Hollywood','2016-12-09',128,'Inglés','7+',30,446,10,2,NULL),

-- Cine europeo
('Amélie','Vida imaginativa en París','2001-04-25',122,'Francés','7+',10,174,4,10,NULL),
('Cinema Paradiso','Amor por el cine','1988-11-17',155,'Italiano','TP',5,12,2,10,NULL),
('La vida es bella','Humor y tragedia en la guerra','1997-12-20',116,'Italiano','TP',20,230,2,10,NULL),

-- Thriller / crimen
('Seven','Cazador de asesino serial','1995-09-22',127,'Inglés','16+',33,327,9,15,NULL),
('Zodiac','Investigación obsesiva','2007-03-02',157,'Inglés','16+',65,84,9,15,NULL),
('Drive','Conductor solitario criminal','2011-09-16',100,'Inglés','16+',15,81,9,2,NULL),

-- Documental
('March of the Penguins','Vida de los pingüinos','2005-01-26',80,'Francés','TP',8,127,12,NULL,NULL),
('Free Solo','Escalada sin cuerdas','2018-08-31',100,'Inglés','TP',4,29,12,NULL,NULL);

/* =====================================================
   Más PELÍCULAS con SECUELAS
   ===================================================== */

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('Avatar: Fire and Ash',
 'Nuevas tribus y conflictos en Pandora',
 '2025-12-19', 180, 'Inglés',
 '12+', 400.00, NULL, 1, 8, NULL),

('Avatar: El sentido del agua',
 'La familia Sully explora los océanos de Pandora',
 '2022-12-16', 192, 'Inglés',
 '12+', 350.00, 2320.00, 1, 8, 71),

('Avatar',
 'Un exmarine se integra en la cultura Na’vi en Pandora',
 '2009-12-18', 162, 'Inglés',
 '12+', 237.00, 2923.00, 1, 8, 72);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('El señor de los anillos: El retorno del rey',
 'La batalla final por la Tierra Media',
 '2003-12-17', 201, 'Inglés',
 '12+', 94.00, 1142.00, 11, 8, NULL),

('El señor de los anillos: Las dos torres',
 'La comunidad se separa mientras crece la guerra',
 '2002-12-18', 179, 'Inglés',
 '12+', 94.00, 947.00, 11, 8, 74),

('El señor de los anillos: La comunidad del anillo',
 'Inicio del viaje para destruir el Anillo Único',
 '2001-12-19', 178, 'Inglés',
 '12+', 93.00, 898.00, 11, 8, 75);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('Harry Potter y el prisionero de Azkaban',
 'El pasado de Sirius Black sale a la luz',
 '2004-06-04', 142, 'Inglés',
 'TP', 130.00, 796.00, 11, 14, NULL),

('Harry Potter y la cámara secreta',
 'Una amenaza acecha Hogwarts',
 '2002-11-15', 161, 'Inglés',
 'TP', 100.00, 879.00, 11, 14, 77),

('Harry Potter y la piedra filosofal',
 'Un niño descubre que es mago',
 '2001-11-16', 152, 'Inglés',
 'TP', 125.00, 975.00, 11, 14, 78);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('Five Nights at Freddy''s 2',
 'El terror regresa a Freddy Fazbear',
 '2025-10-31', 105, 'Inglés',
 '16+', 45.00, NULL, 5, 9, NULL),

('Five Nights at Freddy''s',
 'Seguridad nocturna en una pizzería maldita',
 '2023-10-27', 109, 'Inglés',
 '16+', 20.00, 297.00, 5, 9, 80);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('Star Wars: El retorno del Jedi',
 'La caída del Imperio',
 '1983-05-25', 131, 'Inglés',
 'TP', 32.00, 475.00, 1, 8, NULL),

('Star Wars: El Imperio contraataca',
 'El Imperio golpea con fuerza',
 '1980-05-21', 124, 'Inglés',
 'TP', 18.00, 538.00, 1, 8, 82),

('Star Wars: Una nueva esperanza',
 'El inicio de la lucha contra el Imperio',
 '1977-05-25', 121, 'Inglés',
 'TP', 11.00, 775.00, 1, 8, 83);

INSERT INTO pelicula (
  titulo, sinopsis, fecha_estreno, duracion_min, idioma_original,
  clasificacion_edad, presupuesto, recaudacion,
  id_genero_principal, id_genero_secundario, id_pelicula_secuela
) VALUES
('John Wick: Capítulo 4',
 'La guerra definitiva contra la Alta Mesa',
 '2023-03-24', 169, 'Inglés',
 '16+', 100.00, 440.00, 3, 15, NULL),

('John Wick: Capítulo 3 – Parabellum',
 'John Wick huye con una recompensa global sobre su cabeza',
 '2019-05-17', 131, 'Inglés',
 '16+', 75.00, 327.00, 3, 15, 85),

('John Wick: Capítulo 2',
 'John Wick es forzado a cumplir un antiguo juramento',
 '2017-02-10', 122, 'Inglés',
 '16+', 40.00, 171.00, 3, 15, 86),

('John Wick',
 'Un exasesino regresa al mundo criminal por venganza',
 '2014-10-24', 101, 'Inglés',
 '16+', 20.00, 86.00, 3, 15, 87);

/* =====================================================
   SERIES
   ===================================================== */

INSERT INTO serie (
  titulo, sinopsis, fecha_estreno,
  idioma_original, clasificacion_edad, estado, numero_temporadas,
  id_genero_principal, id_genero_secundario
) VALUES
('Stranger Things','Ciencia ficción y misterio sobrenatural','2016-07-15','Inglés','12+','EN_EMISION',5,1,6),
('Black Mirror','Antología de tecnología y dilemas morales','2011-12-04','Inglés','16+','EN_EMISION',7,9,1),
('Cobra Kai','Continuación moderna de Karate Kid','2018-05-02','Inglés','12+','EN_EMISION',6,3,4),
('Sex Education','Comedia dramática sobre adolescencia','2019-01-11','Inglés','12+','FINALIZADA',4,4,2),
('Heartstopper','Romance juvenil y autodescubrimiento','2022-04-22','Inglés','7+','EN_EMISION',3,10,2),
('Pluribus','Drama corporativo de ciencia ficción','2025-03-10','Inglés','16+','EN_EMISION',1,1,2),
('Tabú','Drama histórico y crimen','2017-01-07','Inglés','16+','FINALIZADA',1,2,15),
('One Piece','Aventura pirata basada en el manga','2023-08-31','Inglés','12+','EN_EMISION',3,8,4),
('Arcane: League of Legends','Animación de fantasía y acción','2021-11-06','Inglés','12+','EN_EMISION',2,7,11),
('La noche más larga','Thriller carcelario español','2022-07-08','Español','16+','FINALIZADA',1,9,2),

('Squid Game','Juego de supervivencia con crítica social','2021-09-17','Coreano','16+','FINALIZADA',1,9,15),
('Wednesday','Reinvención del universo Addams','2022-11-23','Inglés','12+','EN_EMISION',2,4,9),
('The Crown','Drama histórico sobre la monarquía británica','2016-11-04','Inglés','12+','EN_EMISION',6,2,15),
('The Mandalorian','Aventura espacial en el universo Star Wars','2019-11-12','Inglés','12+','EN_EMISION',3,1,8),
('Severance','Thriller psicológico corporativo','2022-02-17','Inglés','16+','EN_EMISION',2,9,1),
('The White Lotus','Sátira social en resorts de lujo','2021-07-11','Inglés','16+','EN_EMISION',3,2,9),
('Bluey','Animación infantil familiar','2018-10-01','Inglés','TP','EN_EMISION',4,7,14),
('Platonic','Comedia sobre amistad adulta','2023-03-22','Inglés','12+','FINALIZADA',1,4,2),
('Big Boys','Comedia contemporánea británica','2024-01-10','Inglés','16+','EN_EMISION',2,4,9),
('Such Brave Girls','Comedia dramática feminista','2024-04-25','Inglés','16+','EN_EMISION',1,2,4),

('The Bear','Drama gastronómico intenso','2022-04-23','Inglés','16+','EN_EMISION',3,2,15),
('Alien: Earth','Ciencia ficción y terror','2025-03-15','Inglés','16+','EN_EMISION',1,1,9),
('Dune: The Sisterhood','Precuela del universo Dune','2025-05-02','Inglés','16+','EN_EMISION',1,8,1),
('House of the Dragon','Fantasía épica de los Targaryen','2022-08-21','Inglés','16+','EN_EMISION',3,8,3),
('The Last of Us','Drama postapocalíptico','2023-01-15','Inglés','16+','EN_EMISION',2,2,9),
('Chernobyl: Aftermath','Consecuencias del desastre nuclear','2025-02-20','Inglés','16+','FINALIZADA',1,2,15),
('Mozart in the Jungle','Comedia dramática musical','2014-02-06','Inglés','12+','FINALIZADA',4,4,2),
('Black Sails','Aventura pirata histórica','2014-01-25','Inglés','16+','FINALIZADA',4,8,3),
('Narcos','Historia del narcotráfico','2015-08-28','Inglés','16+','FINALIZADA',3,15,2),

('Lupin','Thriller criminal francés','2021-01-08','Francés','16+','EN_EMISION',3,9,15),
('Bridgerton','Drama romántico de época','2020-12-25','Inglés','12+','EN_EMISION',3,10,2),
('The Witcher','Fantasía medieval oscura','2019-12-20','Inglés','16+','EN_EMISION',4,8,3),
('Rick and Morty','Animación adulta de ciencia ficción','2013-12-02','Inglés','16+','EN_EMISION',6,7,9),
('Friends Reunion','Especial de reencuentro','2025-02-14','Inglés','12+','FINALIZADA',1,4,2),
('Vikingos: Valhalla','Aventura histórica nórdica','2022-02-25','Inglés','16+','EN_EMISION',2,8,15),
('Mindhunter','Crimen psicológico','2017-10-13','Inglés','16+','FINALIZADA',2,9,15),
('Modern Family','Comedia familiar','2009-09-23','Inglés','7+','FINALIZADA',11,4,14),
('La Casa de Papel','Atraco y tensión criminal','2017-05-02','Español','16+','FINALIZADA',5,15,2);

INSERT INTO serie (
  titulo, sinopsis, fecha_estreno,
  idioma_original, clasificacion_edad, estado, numero_temporadas,
  id_genero_principal, id_genero_secundario
) VALUES

('Attack on Titan','La humanidad lucha contra gigantes','2013-04-07','Japonés','16+','FINALIZADA',4,8,NULL),
('Death Note','Un cuaderno que concede poder sobre la muerte','2006-10-03','Japonés','16+','FINALIZADA',1,9,NULL),
('Fullmetal Alchemist: Brotherhood','Dos hermanos buscan la piedra filosofal','2009-04-05','Japonés','12+','FINALIZADA',1,8,11),
('Demon Slayer','Cazadores de demonios en Japón feudal','2019-04-06','Japonés','16+','EN_EMISION',4,8,5),
('One Punch Man','Un héroe que derrota a cualquiera de un golpe','2015-10-05','Japonés','12+','EN_EMISION',2,7,3),

('Los Simpson','Sátira de la familia americana','1989-12-17','Inglés','7+','EN_EMISION',35,7,4),
('Futurama','Ciencia ficción animada y comedia','1999-03-28','Inglés','12+','FINALIZADA',7,7,1),
('Bojack Horseman','Drama animado sobre fama y depresión','2014-08-22','Inglés','16+','FINALIZADA',6,7,2),
('South Park','Humor irreverente y crítica social','1997-08-13','Inglés','16+','EN_EMISION',26,7,4),

('Better Call Saul','El origen del abogado Saul Goodman','2015-02-08','Inglés','16+','FINALIZADA',6,15,2),
('True Detective','Investigaciones criminales profundas','2014-01-12','Inglés','16+','EN_EMISION',4,15,9),

('Band of Brothers','Soldados en la Segunda Guerra Mundial','2001-09-09','Inglés','16+','FINALIZADA',1,2,15),
('The Boys','Superhéroes corruptos y violencia','2019-07-26','Inglés','18+','EN_EMISION',4,3,9),
('Andor','Rebelión temprana contra el Imperio','2022-09-21','Inglés','12+','EN_EMISION',2,1,8),
('Westworld','Parque temático con androides','2016-10-02','Inglés','16+','FINALIZADA',4,1,9);

INSERT INTO serie (
  titulo, sinopsis, fecha_estreno,
  idioma_original, clasificacion_edad, estado, numero_temporadas,
  id_genero_principal, id_genero_secundario
) VALUES
('Haikyuu!!','Un equipo de voleibol escolar lucha por llegar a lo más alto','2014-04-06','Japonés','12+','FINALIZADA',4,2,8),
('Naruto','Un ninja marginado sueña con ser Hokage','2002-10-03','Japonés','12+','FINALIZADA',5,8,3),
('Naruto Shippuden','Naruto regresa para enfrentarse a grandes amenazas','2007-02-15','Japonés','12+','FINALIZADA',10,8,3),
('Dragon Ball','Las aventuras de Son Goku','1986-02-26','Japonés','TP','FINALIZADA',5,8,7),
('Dragon Ball Z','Batallas épicas para salvar la Tierra','1989-04-26','Japonés','12+','FINALIZADA',9,8,3),
('Dragon Ball Super','El poder de los dioses y nuevos universos','2015-07-05','Japonés','12+','FINALIZADA',5,8,3),
('My Hero Academia','Jóvenes héroes entrenan para salvar el mundo','2016-04-03','Japonés','12+','EN_EMISION',6,8,3),
('Jujutsu Kaisen','Hechiceros luchan contra maldiciones','2020-10-03','Japonés','16+','EN_EMISION',2,8,5),
('Tokyo Ghoul','Un joven atrapado entre humanos y monstruos','2014-07-04','Japonés','16+','FINALIZADA',4,9,5),
('Bleach','Un adolescente obtiene poderes espirituales','2004-10-05','Japonés','12+','FINALIZADA',16,8,3),
('Sword Art Online','Jugadores atrapados en un videojuego mortal','2012-07-07','Japonés','12+','EN_EMISION',4,1,8),
('Neon Genesis Evangelion','Mechas y trauma psicológico','1995-10-04','Japonés','16+','FINALIZADA',1,1,2),
('Cowboy Bebop','Cazarrecompensas espaciales','1998-04-03','Japonés','12+','FINALIZADA',1,1,9),
('Steins;Gate','Viajes en el tiempo y consecuencias','2011-04-06','Japonés','12+','FINALIZADA',1,1,9);

INSERT INTO serie (
  titulo, sinopsis, fecha_estreno,
  idioma_original, clasificacion_edad, estado, numero_temporadas,
  id_genero_principal, id_genero_secundario
) VALUES

('Juego de Tronos',
 'Luchas de poder entre casas nobles por el Trono de Hierro',
 '2011-04-17','Inglés','16+','FINALIZADA',8,8,NULL),

('Lost',
 'Supervivientes de un accidente aéreo en una isla misteriosa',
 '2004-09-22','Inglés','12+','FINALIZADA',6,9,NULL),

('Breaking Bad',
 'Un profesor de química se convierte en narcotraficante',
 '2008-01-20','Inglés','16+','FINALIZADA',5,15,NULL),

('Peaky Blinders',
 'Familia criminal en la Inglaterra de posguerra',
 '2013-09-12','Inglés','16+','FINALIZADA',6,15,NULL),

('The Office (US)',
 'Comedia ambientada en una oficina',
 '2005-03-24','Inglés','7+','FINALIZADA',9,4,NULL),

('Dark',
 'Viajes en el tiempo en un pueblo alemán',
 '2017-12-01','Alemán','16+','FINALIZADA',3,1,NULL),

('The Walking Dead',
 'Supervivencia en un mundo zombi',
 '2010-10-31','Inglés','16+','FINALIZADA',11,5,NULL),

('Dragon Ball GT',
 'Aventuras de Goku convertido en niño',
 '1996-02-07','Japonés','TP','FINALIZADA',1,8,NULL),

('Pokémon',
 'Entrenadores viajan para capturar criaturas',
 '1997-04-01','Japonés','TP','EN_EMISION',25,8,NULL),

('Sailor Moon',
 'Guerreras mágicas protegen la Tierra',
 '1992-03-07','Japonés','TP','FINALIZADA',5,11,NULL);

/* =====================================================
   EPISODIOS
   ===================================================== */

-- Stranger Things
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie, 1, 1, 'La desaparición', 48, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 2, 'La chica extraña', 50, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 3, 'Luces en la pared', 47, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 4, 'El cuerpo', 49, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 5, 'El otro lado', 52, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 6, 'La grieta', 51, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 7, 'El sacrificio', 53, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 8, 'El monstruo', 55, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1, 9, 'Oscuridad total', 54, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1,10, 'La huida', 56, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1,11, 'La señal', 57, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1,12, 'El portal', 58, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things'
UNION ALL
SELECT s.id_serie, 1,13, 'Final de temporada', 60, '2016-07-15'
FROM serie s WHERE s.titulo = 'Stranger Things';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(14, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 9, 14, 'La última tentación de Krusty', 22, '1998-02-08'),
(15, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 9, 15, 'La alegría de la secta', 22, '1998-02-15');

-- Black Mirror
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'El himno nacional',44,'2011-12-04' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,2,'15 millones de méritos',62,'2011-12-04' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,3,'El recuerdo de todos',49,'2011-12-04' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,4,'Vuelvo enseguida',47,'2013-02-11' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,5,'Oso blanco',42,'2013-02-18' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,6,'San Junípero',61,'2016-10-21' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,7,'Caída en picado',63,'2016-10-21' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,8,'USS Callister',76,'2017-12-29' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,9,'Bandersnatch',90,'2018-12-28' FROM serie s WHERE s.titulo='Black Mirror'
UNION ALL SELECT s.id_serie,1,10,'Más allá del mar',54,'2023-06-15' FROM serie s WHERE s.titulo='Black Mirror';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(26, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 3, 1, 'Papá, loco de atar', 22, '1991-09-19'),
(27, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 3, 2, 'Lisa va a Washington', 22, '1991-09-26'),
(28, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 3, 3, 'El gato fugitivo', 22, '1991-10-03'),
(29, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 3, 4, 'Homer el hereje', 22, '1991-10-10'),
(30, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 3, 5, 'Bart el asesino', 22, '1991-10-17');

-- Cobra Kai
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Ace Degenerate',30,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,2,'Strike First',28,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,3,'Esqueleto',31,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,4,'Cobayashi',29,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,5,'Counterbalance',32,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,6,'Quiver',30,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,7,'All Valley',34,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai'
UNION ALL SELECT s.id_serie,1,8,'Ex-Degenerate',36,'2018-05-02' FROM serie s WHERE s.titulo='Cobra Kai';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(39, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 1, 'Arde, pequeño Burns', 22, '1996-10-13'),
(40, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 2, 'Solo se muda dos veces', 22, '1996-10-20'),
(41, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 3, 'El Homer que cae', 22, '1996-10-27'),
(42, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 4, 'La casa-árbol del terror VII', 22, '1996-11-03'),
(43, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 5, 'Bart tras el éxito', 22, '1996-11-10'),
(44, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 6, 'Milhouse dividido', 22, '1996-11-17'),
(45, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 8, 7, 'La madre de Homer', 22, '1996-11-24');

-- Sex Education
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Educación sexual',50,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,2,'Asesor improvisado',48,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,3,'Conflictos',51,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,4,'Celos',49,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,5,'Secretos',52,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,6,'Fiesta escolar',53,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,7,'Presiones',54,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,8,'Rupturas',55,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,9,'Confesiones',56,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,10,'Decisiones',57,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education'
UNION ALL SELECT s.id_serie,1,11,'Final de curso',60,'2019-01-11' FROM serie s WHERE s.titulo='Sex Education';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(57, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 4, 1, 'Kampamento Krusty', 22, '1992-09-24'),
(58, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 4, 2, 'Un tranvía llamado Marge', 22, '1992-10-01'),
(59, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 4, 3, 'Homer, el hereje', 22, '1992-10-08'),
(60, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 4, 4, 'Lisa la reina de la belleza', 22, '1992-10-15');

-- Heartstopper
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Conocerse',30,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,2,'Primeras dudas',28,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,3,'Amistad',31,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,4,'Conflictos internos',29,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,5,'Salir del armario',32,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,6,'Apoyo',30,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,7,'Viaje escolar',33,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper'
UNION ALL SELECT s.id_serie,1,8,'Aceptación',35,'2022-04-22' FROM serie s WHERE s.titulo='Heartstopper';

INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(69, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 1, 'Homer el vigilante', 22, '1993-09-30'),
(70, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 2, 'Cabo de miedosos', 22, '1993-10-07'),
(71, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 3, 'Homer va a la universidad', 22, '1993-10-14'),
(72, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 4, 'La casa del terror IV', 22, '1993-10-28'),
(73, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 5, 'Bart consigue un elefante', 22, '1993-11-04'),
(74, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 6, 'El asistente de Santa Claus', 22, '1993-11-11'),
(75, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 7, 'Bart contra Australia', 22, '1993-11-18');

-- Pluribus
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'La empresa',55,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus'
UNION ALL SELECT s.id_serie,1,2,'Identidades fragmentadas',52,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus'
UNION ALL SELECT s.id_serie,1,3,'Protocolos',54,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus'
UNION ALL SELECT s.id_serie,1,4,'Errores humanos',53,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus'
UNION ALL SELECT s.id_serie,1,5,'Fugas de información',57,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus'
UNION ALL SELECT s.id_serie,1,6,'Consecuencias',60,'2025-03-10' FROM serie s WHERE s.titulo='Pluribus';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(82, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 5, 14, 'Lisa contra Malibu Stacy', 22, '1994-02-17');

-- Tabú
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Regreso a Londres',58,'2017-01-07' FROM serie s WHERE s.titulo='Tabú'
UNION ALL SELECT s.id_serie,1,2,'Viejos enemigos',57,'2017-01-07' FROM serie s WHERE s.titulo='Tabú'
UNION ALL SELECT s.id_serie,1,3,'Negocios oscuros',56,'2017-01-07' FROM serie s WHERE s.titulo='Tabú'
UNION ALL SELECT s.id_serie,1,4,'Traiciones',59,'2017-01-07' FROM serie s WHERE s.titulo='Tabú';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(87, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 9, 1, 'La ciudad de Nueva York contra Homer Simpson', 22, '1997-09-21'),
(88, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 9, 2, 'El director y el pobre', 22, '1997-09-28'),
(89, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 9, 3, 'Lisa la escéptica', 22, '1997-10-05');

-- Arcane: League of Legends
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Bienvenidos a Piltover',40,'2021-11-06' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,2,'Algunos errores',42,'2021-11-06' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,3,'La violencia necesaria',41,'2021-11-06' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,4,'Días felices',44,'2021-11-13' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,5,'Todos quieren ser alguien',43,'2021-11-13' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,6,'Cuando estos muros caigan',45,'2021-11-13' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,7,'El salvador',46,'2021-11-20' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,8,'Aceite y agua',44,'2021-11-20' FROM serie s WHERE s.titulo='Arcane: League of Legends'
UNION ALL SELECT s.id_serie,1,9,'El monstruo que creaste',47,'2021-11-20' FROM serie s WHERE s.titulo='Arcane: League of Legends';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(99, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 1, '¿Quién disparó al Sr. Burns? (Parte II)', 22, '1995-09-17'),
(100, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 2, 'Radio Bart', 22, '1995-09-24'),
(101, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 3, 'La casa del terror de Homer', 22, '1995-10-01'),
(102, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 4, 'Bart vende su alma', 22, '1995-10-08'),
(103, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 5, 'Lisa la vegetariana', 22, '1995-10-15'),
(104, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 7, 6, 'Especial de Halloween VI', 22, '1995-10-29');

-- La noche más larga
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'El asalto',45,'2022-07-08' FROM serie s WHERE s.titulo='La noche más larga'
UNION ALL SELECT s.id_serie,1,2,'Control perdido',44,'2022-07-08' FROM serie s WHERE s.titulo='La noche más larga'
UNION ALL SELECT s.id_serie,1,3,'Resistencia',46,'2022-07-08' FROM serie s WHERE s.titulo='La noche más larga'
UNION ALL SELECT s.id_serie,1,4,'Últimos recursos',43,'2022-07-08' FROM serie s WHERE s.titulo='La noche más larga'
UNION ALL SELECT s.id_serie,1,5,'Amanecer',47,'2022-07-08' FROM serie s WHERE s.titulo='La noche más larga';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(110, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 7, 9, 'Sideshow Bob Roberts', 22, '1995-11-05'),
(111, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 7, 10, 'El 138º episodio espectacular', 22, '1995-12-03');

-- One Piece
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Romance Dawn',48,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,2,'El pirata cazador',50,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,3,'Mapas y promesas',52,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,4,'El payaso Buggy',49,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,5,'La tripulación',54,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,6,'Baratie',55,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,7,'El cocinero',53,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,8,'Arlong Park',56,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,9,'Pasado doloroso',58,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,10,'Liberación',57,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,11,'Nuevos rumbos',52,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,12,'La Marina',54,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,13,'El Grand Line',56,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,14,'Decisiones',55,'2023-08-31' FROM serie s WHERE s.titulo='One Piece'
UNION ALL SELECT s.id_serie,1,15,'El comienzo real',60,'2023-08-31' FROM serie s WHERE s.titulo='One Piece';

-- Squid Game
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie, 1, 1, 'Luz roja, luz verde', 55, '2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,2,'Infierno',52,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,3,'El hombre del paraguas',50,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,4,'No abandonen el equipo',54,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,5,'Un mundo justo',58,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,6,'Gganbu',63,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,7,'VIPs',60,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,8,'El líder',57,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game'
UNION ALL SELECT s.id_serie,1,9,'Un día de suerte',55,'2021-09-17' FROM serie s WHERE s.titulo='Squid Game';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(136, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 8, 'Huracán Neddy', 22, '1996-09-29'),
(137, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 9, 'Solo se muda dos veces', 22, '1996-10-06'),
(138, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 10, 'El hermano del mismo planeta', 22, '1996-10-13'),
(139, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 11, 'Especial de Halloween VII', 22, '1996-10-27'),
(140, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 12, 'Bart después del anochecer', 22, '1996-11-03'),
(141, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 8, 13, 'Un Milhouse dividido', 22, '1996-11-10');

-- Wednesday
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Miércoles es la niña perfecta',50,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,2,'El crimen de Nevermore',48,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,3,'Amistades peligrosas',51,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,4,'Baile macabro',49,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,5,'Secretos enterrados',52,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,6,'El monstruo interior',50,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,7,'Traiciones',54,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday'
UNION ALL SELECT s.id_serie,1,8,'El destino de Nevermore',55,'2022-11-23' FROM serie s WHERE s.titulo='Wednesday';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(150, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 8, 'La ciudad de Nueva York contra Homer Simpson', 22, '1997-09-21'),
(151, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 9, 'El director y el pobre', 22, '1997-09-28'),
(152, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 10, 'Lisa la escéptica', 22, '1997-10-05'),
(153, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 4, 'Especial de Halloween VIII', 22, '1997-10-26'),
(154, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 5, 'Un cartucho de amor', 22, '1997-11-02'),
(155, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 6, 'Bart Star', 22, '1997-11-09'),
(156, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 9, 7, 'El de dos señoras Nahasapeemapetilon', 22, '1997-11-16');

-- The Crown
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Wolferton Splash',58,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,2,'Hyde Park Corner',57,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,3,'Windsor',56,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,4,'Act of God',59,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,5,'Smoke and Mirrors',55,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,6,'Gelignite',54,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,7,'Scientia Potentia Est',56,'2016-11-04' FROM serie s WHERE s.titulo='The Crown'
UNION ALL SELECT s.id_serie,1,8,'Pride & Joy',58,'2016-11-04' FROM serie s WHERE s.titulo='The Crown';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(165, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 1, 'Lard of the Dance', 22, '1998-08-23'),
(166, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 2, 'El mago de Evergreen Terrace', 22, '1998-09-20'),
(167, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 3, 'Bart, la madre', 22, '1998-09-27'),
(168, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 4, 'Especial de Halloween IX', 22, '1998-10-25'),
(169, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 5, 'Cuando se anhela una estrella', 22, '1998-11-01'),
(170, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 6, 'D’oh-in’ in the Wind', 22, '1998-11-15'),
(171, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 10, 7, 'Lisa consigue un A', 22, '1998-11-22');

-- The Mandalorian
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'El Mandaloriano',39,'2019-11-12' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,2,'El niño',32,'2019-11-12' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,3,'El pecado',37,'2019-11-19' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,4,'Santuario',41,'2019-11-26' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,5,'El pistolero',35,'2019-12-03' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,6,'El prisionero',44,'2019-12-06' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,7,'El ajuste de cuentas',42,'2019-12-18' FROM serie s WHERE s.titulo='The Mandalorian'
UNION ALL SELECT s.id_serie,1,8,'Redención',48,'2019-12-27' FROM serie s WHERE s.titulo='The Mandalorian';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(180, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 1, 'Más vale pájaro en mano', 22, '1999-09-26'),
(181, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 2, 'El problema con los trillizos', 22, '1999-10-03'),
(182, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 3, 'La casa del terror X', 22, '1999-10-31'),
(183, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 4, 'E-I-E-I-(Fastidioso gruñido)', 22, '1999-11-07'),
(184, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 5, 'Hola, Friki', 22, '1999-11-14'),
(185, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 6, 'Ocho traviesos pequeños', 22, '1999-11-21'),
(186, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 11, 7, 'La sopa está caliente', 22, '1999-11-28');

-- Severance
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Buenas noticias sobre el infierno',57,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,2,'Medio bucle',52,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,3,'En perpetuidad',54,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,4,'El tú que eres',53,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,5,'El grimorio',57,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,6,'Escondite',56,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,7,'Defiant Jazz',55,'2022-02-17' FROM serie s WHERE s.titulo='Severance'
UNION ALL SELECT s.id_serie,1,8,'¿Qué hay para cenar?',60,'2022-02-17' FROM serie s WHERE s.titulo='Severance';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(195, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 1, 'Árbol genealógico Simpson', 22, '2000-11-05'),
(196, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 2, 'Un día sin Homer', 22, '2000-11-12'),
(197, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 3, 'Insane Clown Poppy', 22, '2000-11-19'),
(198, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 4, 'Lisa, la reina del drama', 22, '2000-11-26'),
(199, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 5, 'Homer vs. Dignity', 22, '2000-12-03'),
(200, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 6, 'El día que la violencia murió', 22, '2000-12-10'),
(201, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 12, 7, 'El gran fraude', 22, '2000-12-17');

INSERT INTO episodio
(id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
VALUES
(202, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 1, 'Bart el genio', 22, '1990-01-14'),
(203, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 2, 'Especial de San Valentín', 22, '1990-01-21'),
(204, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 3, 'El heredero de Burns', 22, '1990-01-28'),
(205, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 4, 'D’oh-in’ en el viento', 22, '1990-02-04'),
(206, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 5, 'La casa del terror II', 22, '1990-02-11'),
(207, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 2, 6, 'El que ríe último', 22, '1990-02-18');

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(208, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 13, 1, 'Especial Papá Noel', 22, '2001-11-11');

-- The White Lotus
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Llegadas',58,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus'
UNION ALL SELECT s.id_serie,1,2,'Nuevo día',56,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus'
UNION ALL SELECT s.id_serie,1,3,'Misterios',57,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus'
UNION ALL SELECT s.id_serie,1,4,'Disrupción',55,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus'
UNION ALL SELECT s.id_serie,1,5,'Loto marchito',59,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus'
UNION ALL SELECT s.id_serie,1,6,'Partidas',62,'2021-07-11' FROM serie s WHERE s.titulo='The White Lotus';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(215, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 10, 12, 'Domingo, horrible domingo', 22, '1999-01-31');

-- Bluey
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Hospital',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,2,'Montaña mágica',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,3,'La bicicleta',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,4,'Calypso',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,5,'El mercado',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,6,'Piscina',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey'
UNION ALL SELECT s.id_serie,1,7,'Camping',7,'2018-10-01' FROM serie s WHERE s.titulo='Bluey';

-- Platonic
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Viejos amigos',30,'2023-03-22' FROM serie s WHERE s.titulo='Platonic'
UNION ALL SELECT s.id_serie,1,2,'Reencuentro',29,'2023-03-22' FROM serie s WHERE s.titulo='Platonic'
UNION ALL SELECT s.id_serie,1,3,'Límites',31,'2023-03-22' FROM serie s WHERE s.titulo='Platonic'
UNION ALL SELECT s.id_serie,1,4,'Celos',30,'2023-03-22' FROM serie s WHERE s.titulo='Platonic'
UNION ALL SELECT s.id_serie,1,5,'Decisiones',32,'2023-03-22' FROM serie s WHERE s.titulo='Platonic';

-- Big Boys
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Mudanza',28,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys'
UNION ALL SELECT s.id_serie,1,2,'Primeros días',29,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys'
UNION ALL SELECT s.id_serie,1,3,'Confesiones',27,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys'
UNION ALL SELECT s.id_serie,1,4,'Choques',30,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys'
UNION ALL SELECT s.id_serie,1,5,'Avances',31,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys'
UNION ALL SELECT s.id_serie,1,6,'Final de curso',33,'2024-01-10' FROM serie s WHERE s.titulo='Big Boys';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(228, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 11, 10, 'La ayudita del hermano', 22, '1999-10-03'),
(229, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 15, 1, 'El horror de Lisa', 22, '2003-11-02');

-- Such Brave Girls
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Familia disfuncional',28,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls'
UNION ALL SELECT s.id_serie,1,2,'Decisiones equivocadas',27,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls'
UNION ALL SELECT s.id_serie,1,3,'Verdades incómodas',29,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls'
UNION ALL SELECT s.id_serie,1,4,'Responsabilidades',26,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls'
UNION ALL SELECT s.id_serie,1,5,'Choques emocionales',30,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls'
UNION ALL SELECT s.id_serie,1,6,'Aceptar la realidad',31,'2024-04-25' FROM serie s WHERE s.titulo='Such Brave Girls';

-- Los Simpson
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(236, (SELECT id_serie FROM serie WHERE titulo='Los Simpson'), 16, 1, 'Casa grande, casa pequeña', 22, '2004-11-07');
INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(243, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 11, 17, 'Bart al futuro', 22, '2000-03-19');

-- The Bear
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Sistema',30,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,2,'Manos',28,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,3,'Brigada',31,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,4,'Presión',29,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,5,'Errores',32,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,6,'Servicio',34,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,7,'Familia',36,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,8,'Colapso',35,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,9,'Reinicio',33,'2022-04-23' FROM serie s WHERE s.titulo='The Bear'
UNION ALL SELECT s.id_serie,1,10,'El futuro',38,'2022-04-23' FROM serie s WHERE s.titulo='The Bear';

INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(254, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 12, 11, 'El ordenador que acabó con Homero', 22, '2000-12-03'),
(255, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 12, 12, 'El gran timo', 22, '2000-12-10'),
(256, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 12, 8, 'Skinner y su concepto de un día de nieve', 22, '2000-12-17'),
(257, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 12, 9, 'HOMЯ', 22, '2001-01-07'),
(258, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 12, 10, 'Chiromamá', 22, '2001-01-14');

-- Alien: Earth
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Contacto',50,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,2,'Colonia',52,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,3,'La señal',49,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,4,'Incubación',53,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,5,'Supervivientes',55,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,6,'Evolución',54,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth'
UNION ALL SELECT s.id_serie,1,7,'Extinción',58,'2025-03-15' FROM serie s WHERE s.titulo='Alien: Earth';

-- Dune: The Sisterhood
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno)
SELECT s.id_serie,1,1,'Las Bene Gesserit',55,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,2,'El origen',57,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,3,'Manipulación',56,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,4,'El poder',58,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,5,'Sacrificio',60,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,6,'La profecía',59,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,7,'Control genético',61,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood'
UNION ALL SELECT s.id_serie,1,8,'El futuro del Imperio',63,'2025-05-02' FROM serie s WHERE s.titulo='Dune: The Sisterhood';

INSERT INTO episodio (id_episodio, id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
(274, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 5, 'Aquellos patosos años', 22, '2001-12-09'),
(275, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 6, 'Ella de poca fe', 22, '2001-12-16'),
(276, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 7, 'Discusión familiar', 22, '2002-01-06'),
(277, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 8, 'Marge agridulce', 22, '2002-01-20'),
(278, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 9, 'En mandíbula cerrada...', 22, '2002-01-27'),
(279, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 10, 'Bart quiere lo que quiere', 22, '2002-02-10'),
(280, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 13, 11, 'Bart se enamora', 22, '2002-02-17');

-- =====================================================
-- House of the Dragon (10 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,1,'Los herederos del dragón',60,'2022-08-21'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,2,'El príncipe rebelde',58,'2022-08-28'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,3,'Segunda del nombre',59,'2022-09-04'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,4,'El rey del mar Angosto',61,'2022-09-11'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,5,'Iluminamos el camino',57,'2022-09-18'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,6,'La princesa y la reina',64,'2022-09-25'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,7,'Deriva',58,'2022-10-02'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,8,'El señor de las mareas',63,'2022-10-09'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,9,'El consejo verde',60,'2022-10-16'),
((SELECT id_serie FROM serie WHERE titulo='House of the Dragon'),1,10,'La reina negra',59,'2022-10-23');

-- =====================================================
-- Chernobyl (5 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Chernobyl: Aftermath'),1,1,'1:23:45',59,'2019-05-06'),
((SELECT id_serie FROM serie WHERE titulo='Chernobyl: Aftermath'),1,2,'Por favor mantenga la calma',65,'2019-05-13'),
((SELECT id_serie FROM serie WHERE titulo='Chernobyl: Aftermath'),1,3,'Abran bien de par en par',58,'2019-05-20'),
((SELECT id_serie FROM serie WHERE titulo='Chernobyl: Aftermath'),1,4,'La felicidad de toda la humanidad',67,'2019-05-27'),
((SELECT id_serie FROM serie WHERE titulo='Chernobyl: Aftermath'),1,5,'Vichnaya Pamyat',72,'2019-06-03');

-- =====================================================
-- Mozart in the Jungle (10 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,1,'Piloto',28,'2014-02-06'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,2,'Las audiciones',29,'2014-02-06'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,3,'Maestros',30,'2014-02-06'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,4,'La batuta',27,'2014-02-06'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,5,'Ensayos',31,'2014-02-06'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,6,'Solistas',29,'2014-02-13'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,7,'Errores',28,'2014-02-13'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,8,'Debut',30,'2014-02-13'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,9,'Críticas',27,'2014-02-13'),
((SELECT id_serie FROM serie WHERE titulo='Mozart in the Jungle'),1,10,'Aplausos',32,'2014-02-13');

-- =====================================================
-- Black Sails (8 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,1,'I',55,'2014-01-25'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,2,'II',53,'2014-02-01'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,3,'III',54,'2014-02-08'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,4,'IV',52,'2014-02-15'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,5,'V',56,'2014-02-22'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,6,'VI',55,'2014-03-01'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,7,'VII',57,'2014-03-08'),
((SELECT id_serie FROM serie WHERE titulo='Black Sails'),1,8,'VIII',58,'2014-03-15');

-- =====================================================
-- Narcos (10 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,1,'Descenso',50,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,2,'La espada de Simón Bolívar',49,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,3,'Los hombres de siempre',51,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,4,'El palacio en llamas',48,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,5,'Hay plata o plomo',52,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,6,'Explosivos',50,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,7,'Colaboradores',53,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,8,'La gran mentira',54,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,9,'Traición',55,'2015-08-28'),
((SELECT id_serie FROM serie WHERE titulo='Narcos'),1,10,'La caída',58,'2015-08-28');

-- =====================================================
-- Lupin (6 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,1,'Capítulo 1',48,'2021-01-08'),
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,2,'Capítulo 2',47,'2021-01-08'),
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,3,'Capítulo 3',49,'2021-01-08'),
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,4,'Capítulo 4',46,'2021-01-08'),
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,5,'Capítulo 5',50,'2021-01-08'),
((SELECT id_serie FROM serie WHERE titulo='Lupin'),1,6,'Capítulo 6',52,'2021-01-08');

-- =====================================================
-- Bridgerton (8 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,1,'Diamante de la temporada',58,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,2,'Choque de voluntades',56,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,3,'El arte del desmayo',57,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,4,'Un asunto de honor',55,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,5,'El duque y yo',59,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,6,'Escándalos',60,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,7,'Revelaciones',58,'2020-12-25'),
((SELECT id_serie FROM serie WHERE titulo='Bridgerton'),1,8,'Después de la lluvia',62,'2020-12-25');

-- =====================================================
-- The Witcher (8 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,1,'El principio del fin',60,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,2,'Cuatro marcos',58,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,3,'Luna traicionera',59,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,4,'Banquetes, bastardos',57,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,5,'Deseos embotellados',61,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,6,'Especies raras',62,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,7,'Antes de caer',60,'2019-12-20'),
((SELECT id_serie FROM serie WHERE titulo='The Witcher'),1,8,'Mucho más',63,'2019-12-20');

-- =====================================================
-- Rick and Morty (10 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,1,'Piloto',22,'2013-12-02'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,2,'Perros con telepatía',22,'2013-12-09'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,3,'Parque anatómico',21,'2013-12-16'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,4,'Alienígenas parásitos',22,'2014-01-13'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,5,'Realidades alternativas',23,'2014-01-20'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,6,'Viajes temporales',22,'2014-01-27'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,7,'Baterías humanas',21,'2014-02-03'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,8,'Cables interdimensionales',22,'2014-02-10'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,9,'Sueños compartidos',23,'2014-02-17'),
((SELECT id_serie FROM serie WHERE titulo='Rick and Morty'),1,10,'Evil Morty',24,'2014-02-24');

-- =====================================================
-- Friends Reunion (3 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Friends Reunion'),1,1,'Reencuentro',62,'2025-02-14'),
((SELECT id_serie FROM serie WHERE titulo='Friends Reunion'),1,2,'Detrás de cámaras',25,'2025-02-14'),
((SELECT id_serie FROM serie WHERE titulo='Friends Reunion'),1,3,'Recuerdos',28,'2025-02-14');

-- =====================================================
-- Vikingos: Valhalla (8 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,1,'La marea',50,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,2,'El asedio',48,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,3,'Juramentos',51,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,4,'Traiciones',49,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,5,'La sangre llama',52,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,6,'El precio del poder',53,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,7,'Hermanos',54,'2022-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Vikingos: Valhalla'),1,8,'Valhalla',56,'2022-02-25');

-- =====================================================
-- Mindhunter (9 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,1,'Inicio',55,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,2,'Entrevistas',54,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,3,'Patrones',53,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,4,'Violencia',56,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,5,'Confesiones',52,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,6,'Errores',55,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,7,'Presión',57,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,8,'Oscuridad',58,'2017-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Mindhunter'),1,9,'El perfil',60,'2017-10-13');

-- =====================================================
-- Modern Family (10 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,1,'Piloto',22,'2009-09-23'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,2,'El cambio',22,'2009-09-30'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,3,'El bebé',21,'2009-10-07'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,4,'Viajes',22,'2009-10-14'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,5,'Fiestas',23,'2009-10-21'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,6,'Conflictos',22,'2009-10-28'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,7,'Revelaciones',21,'2009-11-04'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,8,'Navidad',22,'2009-11-11'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,9,'Aniversario',23,'2009-11-18'),
((SELECT id_serie FROM serie WHERE titulo='Modern Family'),1,10,'Familia',24,'2009-11-25');

-- =====================================================
-- La Casa de Papel (9 episodios)
-- =====================================================
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,1,'Efectuar lo acordado',50,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,2,'Imprudencias',48,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,3,'Errar al disparar',51,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,4,'Caballo de Troya',49,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,5,'El día de la marmota',52,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,6,'La cálida Guerra Fría',53,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,7,'Refrigerada inestabilidad',54,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,8,'Tú lo has buscado',55,'2017-05-02'),
((SELECT id_serie FROM serie WHERE titulo='La Casa de Papel'),1,9,'La ejecución',57,'2017-05-02');

/* =====================================================
   ATTACK ON TITAN (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,1,'A ti, dentro de 2000 años',24,'2013-04-07'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,2,'Ese día',24,'2013-04-14'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,3,'Una luz tenue',24,'2013-04-21'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,4,'La noche del cierre',24,'2013-04-28'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,5,'Primera batalla',24,'2013-05-05'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,6,'El mundo que vio la chica',24,'2013-05-12'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,7,'Pequeña espada',24,'2013-05-19'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,8,'Oídos sordos',24,'2013-05-26'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,9,'Brazo izquierdo',24,'2013-06-02'),
((SELECT id_serie FROM serie WHERE titulo='Attack on Titan'),1,10,'Respuesta',24,'2013-06-09');

/* =====================================================
   DEATH NOTE (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,1,'Renacimiento',23,'2006-10-03'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,2,'Confrontación',23,'2006-10-10'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,3,'Tratos',23,'2006-10-17'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,4,'Persecución',23,'2006-10-24'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,5,'Estrategia',23,'2006-10-31'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,6,'Desenmascarar',23,'2006-11-07'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,7,'Nublado',23,'2006-11-14'),
((SELECT id_serie FROM serie WHERE titulo='Death Note'),1,8,'Miradas',23,'2006-11-21');

/* =====================================================
   FULLMETAL ALCHEMIST: BROTHERHOOD (12 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,1,'El alquimista de acero',24,'2009-04-05'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,2,'El primer día',24,'2009-04-12'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,3,'Ciudad de herejes',24,'2009-04-19'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,4,'La angustia del alquimista',24,'2009-04-26'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,5,'Lluvia de tristeza',24,'2009-05-03'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,6,'Camino de la esperanza',24,'2009-05-10'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,7,'Verdad oculta',24,'2009-05-17'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,8,'El quinto laboratorio',24,'2009-05-24'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,9,'El cuerpo artificial',24,'2009-05-31'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,10,'Traición',24,'2009-06-07'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,11,'Milagro falso',24,'2009-06-14'),
((SELECT id_serie FROM serie WHERE titulo='Fullmetal Alchemist: Brotherhood'),1,12,'Uno es todo',24,'2009-06-21');

/* =====================================================
   DEMON SLAYER (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,1,'Crueldad',24,'2019-04-06'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,2,'Entrenamiento',24,'2019-04-13'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,3,'Sabito y Makomo',24,'2019-04-20'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,4,'Selección final',24,'2019-04-27'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,5,'Mi propia espada',24,'2019-05-04'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,6,'Cazador de demonios',24,'2019-05-11'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,7,'Muzan Kibutsuji',24,'2019-05-18'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,8,'El aroma de la sangre',24,'2019-05-25'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,9,'Temari',24,'2019-06-01'),
((SELECT id_serie FROM serie WHERE titulo='Demon Slayer'),1,10,'Siempre juntos',24,'2019-06-08');

/* =====================================================
   ONE PUNCH MAN (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,1,'El héroe más fuerte',24,'2015-10-05'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,2,'El cyborg solitario',24,'2015-10-12'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,3,'El científico obsesivo',24,'2015-10-19'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,4,'El ninja moderno',24,'2015-10-26'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,5,'El gran maestro',24,'2015-11-02'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,6,'La ciudad aterrada',24,'2015-11-09'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,7,'El discípulo definitivo',24,'2015-11-16'),
((SELECT id_serie FROM serie WHERE titulo='One Punch Man'),1,8,'El rey del mar profundo',24,'2015-11-23');

/* =====================================================
   LOS SIMPSON (12 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,1,'Especial de Navidad',22,'1989-12-17'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,2,'Bart el genio',22,'1990-01-14'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,3,'Homer contra Lisa',22,'1990-01-21'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,4,'Hogar, dulce hogar',22,'1990-01-28'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,5,'Bart el general',22,'1990-02-04'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,6,'Moaning Lisa',22,'1990-02-11'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,7,'El patriarca',22,'1990-02-18'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,8,'La odisea de Homero',22,'1990-02-25'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,9,'Life on the Fast Lane',22,'1990-03-18'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,10,'Homer’s Night Out',22,'1990-03-25'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,11,'The Crepes of Wrath',22,'1990-04-15'),
((SELECT id_serie FROM serie WHERE titulo='Los Simpson'),1,12,'Krusty Gets Busted',22,'1990-04-29');

/* =====================================================
   FUTURAMA (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,1,'Piloto espacial 3000',22,'1999-03-28'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,2,'La serie ha aterrizado',22,'1999-04-04'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,3,'Soy yo, Leela',22,'1999-04-11'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,4,'Amor y cohetes',22,'1999-04-18'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,5,'Miedo al planeta robótico',22,'1999-04-25'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,6,'Un pez lleno de dólares',22,'1999-05-02'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,7,'Mi tres soles',22,'1999-05-09'),
((SELECT id_serie FROM serie WHERE titulo='Futurama'),1,8,'Un gran pedazo de basura',22,'1999-05-16');

/* =====================================================
   BOJACK HORSEMAN (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,1,'BoJack Horseman',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,2,'BoJack odia a los Trotsky',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,3,'Pruebas',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,4,'Zoë y Zelda',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,5,'Live Fast, Diane Nguyen',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,6,'Nuestro A-Story es un D-Story',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,7,'Día de limpieza',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,8,'El telescopio',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,9,'Horse Majeure',25,'2014-08-22'),
((SELECT id_serie FROM serie WHERE titulo='Bojack Horseman'),1,10,'Más tarde',25,'2014-08-22');

/* =====================================================
   SOUTH PARK (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,1,'Cartman consigue una sonda anal',22,'1997-08-13'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,2,'Engranajes de peso',22,'1997-08-20'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,3,'Volcano',22,'1997-08-27'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,4,'Big Gay Al',22,'1997-09-03'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,5,'Un elefante hace el amor',22,'1997-09-10'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,6,'Muerte',22,'1997-09-17'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,7,'Pinkeye',22,'1997-10-29'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,8,'Starvin Marvin',22,'1997-11-19'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,9,'Mr Hankey',22,'1997-12-17'),
((SELECT id_serie FROM serie WHERE titulo='South Park'),1,10,'Damien',22,'1998-02-04');

/* =====================================================
   THE LAST OF US (9 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,1,'Cuando estés perdido en la oscuridad',80,'2023-01-15'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,2,'Infectados',55,'2023-01-22'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,3,'Mucho, mucho tiempo',60,'2023-01-29'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,4,'Por favor, aguanta mi mano',50,'2023-02-05'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,5,'Resistir y sobrevivir',52,'2023-02-12'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,6,'Familia',59,'2023-02-19'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,7,'Lo que dejamos atrás',56,'2023-02-26'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,8,'Cuando más necesitamos',58,'2023-03-05'),
((SELECT id_serie FROM serie WHERE titulo='The Last of Us'),1,9,'Busca la luz',45,'2023-03-12');

/* =====================================================
   BETTER CALL SAUL (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,1,'Uno',53,'2015-02-08'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,2,'Mijo',46,'2015-02-09'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,3,'Nacho',47,'2015-02-16'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,4,'Hero',45,'2015-02-23'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,5,'Alpine Shepherd Boy',46,'2015-03-02'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,6,'Five-O',46,'2015-03-09'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,7,'Bingo',47,'2015-03-16'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,8,'RICO',46,'2015-03-23'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,9,'Pimento',46,'2015-03-30'),
((SELECT id_serie FROM serie WHERE titulo='Better Call Saul'),1,10,'Marco',46,'2015-04-06');

/* =====================================================
   TRUE DETECTIVE (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,1,'The Long Bright Dark',60,'2014-01-12'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,2,'Seeing Things',58,'2014-01-19'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,3,'The Locked Room',59,'2014-01-26'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,4,'Who Goes There',57,'2014-02-09'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,5,'The Secret Fate',61,'2014-02-16'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,6,'Haunted Houses',60,'2014-02-23'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,7,'After You’ve Gone',58,'2014-03-02'),
((SELECT id_serie FROM serie WHERE titulo='True Detective'),1,8,'Form and Void',62,'2014-03-09');

/* =====================================================
   BAND OF BROTHERS (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,1,'Currahee',68,'2001-09-09'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,2,'Day of Days',58,'2001-09-16'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,3,'Carentan',63,'2001-09-23'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,4,'Replacements',56,'2001-09-30'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,5,'Crossroads',58,'2001-10-07'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,6,'Bastogne',64,'2001-10-14'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,7,'The Breaking Point',66,'2001-10-21'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,8,'The Last Patrol',58,'2001-10-28'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,9,'Why We Fight',59,'2001-11-04'),
((SELECT id_serie FROM serie WHERE titulo='Band of Brothers'),1,10,'Points',70,'2001-11-11');

/* =====================================================
   THE BOYS (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,1,'El nombre del juego',60,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,2,'Cherry',59,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,3,'Get Some',58,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,4,'The Female of the Species',61,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,5,'Good for the Soul',60,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,6,'The Innocents',62,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,7,'The Self-Preservation Society',63,'2019-07-26'),
((SELECT id_serie FROM serie WHERE titulo='The Boys'),1,8,'You Found Me',68,'2019-07-26');

/* =====================================================
   ANDOR (12 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,1,'Kassa',40,'2022-09-21'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,2,'That Would Be Me',42,'2022-09-21'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,3,'Reckoning',45,'2022-09-21'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,4,'Aldhani',50,'2022-09-28'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,5,'The Axe Forgets',48,'2022-10-05'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,6,'The Eye',55,'2022-10-12'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,7,'Announcement',47,'2022-10-19'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,8,'Narkina 5',52,'2022-10-26'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,9,'Nobody’s Listening',51,'2022-11-02'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,10,'One Way Out',54,'2022-11-09'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,11,'Daughter of Ferrix',53,'2022-11-16'),
((SELECT id_serie FROM serie WHERE titulo='Andor'),1,12,'Rix Road',57,'2022-11-23');

/* =====================================================
   WESTWORLD (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,1,'The Original',68,'2016-10-02'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,2,'Chestnut',60,'2016-10-09'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,3,'The Stray',58,'2016-10-16'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,4,'Dissonance Theory',62,'2016-10-23'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,5,'Contrapasso',61,'2016-10-30'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,6,'The Adversary',64,'2016-11-06'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,7,'Trompe L’Oeil',59,'2016-11-13'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,8,'Trace Decay',60,'2016-11-20'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,9,'The Well-Tempered Clavier',66,'2016-11-27'),
((SELECT id_serie FROM serie WHERE titulo='Westworld'),1,10,'The Bicameral Mind',90,'2016-12-04');

/* =====================================================
   Haikyuu!! (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,1,'El final y el comienzo',24,'2014-04-06'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,2,'Club de voleibol del instituto Karasuno',24,'2014-04-13'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,3,'El más fuerte',24,'2014-04-20'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,4,'Vista desde arriba',24,'2014-04-27'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,5,'Un tonto y un genio',24,'2014-05-04'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,6,'Interesante',24,'2014-05-11'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,7,'Versus el gran rey',24,'2014-05-18'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,8,'El que llaman as',24,'2014-05-25'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,9,'Un punto',24,'2014-06-01'),
((SELECT id_serie FROM serie WHERE titulo='Haikyuu!!'),1,10,'Renacimiento',24,'2014-06-08');


/* =====================================================
   Naruto (12 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,1,'¡Naruto Uzumaki!',23,'2002-10-03'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,2,'¡Mi nombre es Konohamaru!',23,'2002-10-10'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,3,'¡Sasuke y Sakura!',23,'2002-10-17'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,4,'¡Examen de supervivencia!',23,'2002-10-24'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,5,'¡Fracaso total!',23,'2002-10-31'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,6,'¡Una misión peligrosa!',23,'2002-11-07'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,7,'¡El asesino de la niebla!',23,'2002-11-14'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,8,'¡El juramento del dolor!',23,'2002-11-21'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,9,'¡Kakashi Sharingan!',23,'2002-11-28'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,10,'¡El bosque de Chakra!',23,'2002-12-05'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,11,'¡El país de las olas!',23,'2002-12-12'),
((SELECT id_serie FROM serie WHERE titulo='Naruto'),1,12,'¡Batalla en el puente!',23,'2002-12-19');


/* =====================================================
   Naruto Shippuden (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,1,'Regreso a Konoha',23,'2007-02-15'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,2,'Los Akatsuki se mueven',23,'2007-02-22'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,3,'Resultados del entrenamiento',23,'2007-03-01'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,4,'El rescate del Kazekage',23,'2007-03-08'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,5,'El enemigo invisible',23,'2007-03-15'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,6,'La fuerza del Jinchuriki',23,'2007-03-22'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,7,'La técnica prohibida',23,'2007-03-29'),
((SELECT id_serie FROM serie WHERE titulo='Naruto Shippuden'),1,8,'Sacrificio',23,'2007-04-05');


/* =====================================================
   Dragon Ball (7 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,1,'Bulma y Son Goku',24,'1986-02-26'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,2,'El emperador Pilaf',24,'1986-03-05'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,3,'La nube voladora',24,'1986-03-12'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,4,'Oolong el terrible',24,'1986-03-19'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,5,'El dragón Shenlong',24,'1986-03-26'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,6,'El deseo cumplido',24,'1986-04-02'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball'),1,7,'El entrenamiento comienza',24,'1986-04-09');


/* =====================================================
   Dragon Ball Z (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,1,'El guerrero más poderoso',24,'1989-04-26'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,2,'Un enemigo desconocido',24,'1989-05-03'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,3,'La llegada de Raditz',24,'1989-05-10'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,4,'El sacrificio de Piccolo',24,'1989-05-17'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,5,'Gohan pierde el control',24,'1989-05-24'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,6,'El entrenamiento extremo',24,'1989-05-31'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,7,'El viaje al más allá',24,'1989-06-07'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,8,'La amenaza Saiyan',24,'1989-06-14'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,9,'La batalla comienza',24,'1989-06-21'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Z'),1,10,'Poder oculto',24,'1989-06-28');


/* =====================================================
   Dragon Ball Super (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,1,'El sueño de Beerus',24,'2015-07-05'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,2,'La profecía del dios',24,'2015-07-12'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,3,'El poder divino',24,'2015-07-19'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,4,'La llegada de Beerus',24,'2015-07-26'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,5,'El ritual Saiyan',24,'2015-08-02'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball Super'),1,6,'Super Saiyan God',24,'2015-08-09');


/* =====================================================
   My Hero Academia (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,1,'Izuku Midoriya: Origen',23,'2016-04-03'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,2,'Lo que se necesita para ser un héroe',23,'2016-04-10'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,3,'Rugido, músculos',23,'2016-04-17'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,4,'Inicio del entrenamiento',23,'2016-04-24'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,5,'Lo que puedo hacer ahora',23,'2016-05-01'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,6,'La ira de Bakugo',23,'2016-05-08'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,7,'Villanos',23,'2016-05-15'),
((SELECT id_serie FROM serie WHERE titulo='My Hero Academia'),1,8,'Héroes contra villanos',23,'2016-05-22');


/* =====================================================
   Jujutsu Kaisen (5 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Jujutsu Kaisen'),1,1,'Ryomen Sukuna',23,'2020-10-03'),
((SELECT id_serie FROM serie WHERE titulo='Jujutsu Kaisen'),1,2,'Por mí mismo',23,'2020-10-10'),
((SELECT id_serie FROM serie WHERE titulo='Jujutsu Kaisen'),1,3,'Chica de acero',23,'2020-10-17'),
((SELECT id_serie FROM serie WHERE titulo='Jujutsu Kaisen'),1,4,'Maldición',23,'2020-10-24'),
((SELECT id_serie FROM serie WHERE titulo='Jujutsu Kaisen'),1,5,'Maldito nacimiento',23,'2020-10-31');


/* =====================================================
   Tokyo Ghoul (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,1,'Tragedia',24,'2014-07-04'),
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,2,'Incubación',24,'2014-07-11'),
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,3,'Paloma',24,'2014-07-18'),
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,4,'Cena',24,'2014-07-25'),
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,5,'Cicatrices',24,'2014-08-01'),
((SELECT id_serie FROM serie WHERE titulo='Tokyo Ghoul'),1,6,'Lluvia',24,'2014-08-08');


/* =====================================================
   Bleach (7 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,1,'El día que me convertí en Shinigami',24,'2004-10-05'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,2,'El trabajo de un Shinigami',24,'2004-10-12'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,3,'El hermano mayor de Ichigo',24,'2004-10-19'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,4,'El parakeet maldito',24,'2004-10-26'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,5,'Derrota invisible',24,'2004-11-02'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,6,'Combate mortal',24,'2004-11-09'),
((SELECT id_serie FROM serie WHERE titulo='Bleach'),1,7,'Saludos desde el más allá',24,'2004-11-16');


/* =====================================================
   Sword Art Online (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,1,'El mundo de las espadas',24,'2012-07-07'),
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,2,'Beater',24,'2012-07-14'),
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,3,'El reno de nariz roja',24,'2012-07-21'),
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,4,'El espadachín negro',24,'2012-07-28'),
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,5,'La chica del amanecer',24,'2012-08-04'),
((SELECT id_serie FROM serie WHERE titulo='Sword Art Online'),1,6,'Ilusión',24,'2012-08-11');


/* =====================================================
   Neon Genesis Evangelion (5 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Neon Genesis Evangelion'),1,1,'El ataque del ángel',24,'1995-10-04'),
((SELECT id_serie FROM serie WHERE titulo='Neon Genesis Evangelion'),1,2,'La bestia',24,'1995-10-11'),
((SELECT id_serie FROM serie WHERE titulo='Neon Genesis Evangelion'),1,3,'El dilema del piloto',24,'1995-10-18'),
((SELECT id_serie FROM serie WHERE titulo='Neon Genesis Evangelion'),1,4,'La lluvia',24,'1995-10-25'),
((SELECT id_serie FROM serie WHERE titulo='Neon Genesis Evangelion'),1,5,'Rei, al otro lado',24,'1995-11-01');

/* =====================================================
   Cowboy Bebop (5 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Cowboy Bebop'),1,1,'Asteroid Blues',24,'1998-04-03'),
((SELECT id_serie FROM serie WHERE titulo='Cowboy Bebop'),1,2,'Stray Dog Strut',24,'1998-04-10'),
((SELECT id_serie FROM serie WHERE titulo='Cowboy Bebop'),1,3,'Honky Tonk Women',24,'1998-04-17'),
((SELECT id_serie FROM serie WHERE titulo='Cowboy Bebop'),1,4,'Gateway Shuffle',24,'1998-04-24'),
((SELECT id_serie FROM serie WHERE titulo='Cowboy Bebop'),1,5,'Ballad of Fallen Angels',24,'1998-05-01');

/* =====================================================
   Juego de Tronos (10 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,1,'Se acerca el invierno',62,'2011-04-17'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,2,'El camino real',56,'2011-04-24'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,3,'Lord Nieve',58,'2011-05-01'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,4,'Tullidos, bastardos y cosas rotas',56,'2011-05-08'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,5,'El lobo y el león',55,'2011-05-15'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,6,'Una corona de oro',53,'2011-05-22'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,7,'Ganas o mueres',59,'2011-05-29'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,8,'Por el lado puntiagudo',58,'2011-06-05'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,9,'Baelor',56,'2011-06-12'),
((SELECT id_serie FROM serie WHERE titulo='Juego de Tronos'),1,10,'Fuego y sangre',68,'2011-06-19');


/* =====================================================
   Lost (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,1,'Piloto (Parte 1)',42,'2004-09-22'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,2,'Piloto (Parte 2)',42,'2004-09-22'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,3,'Tabula Rasa',43,'2004-09-29'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,4,'Walkabout',43,'2004-10-06'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,5,'White Rabbit',42,'2004-10-13'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,6,'House of the Rising Sun',43,'2004-10-20'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,7,'The Moth',42,'2004-10-27'),
((SELECT id_serie FROM serie WHERE titulo='Lost'),1,8,'Confidence Man',43,'2004-11-03');


/* =====================================================
   Breaking Bad (7 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,1,'Piloto',58,'2008-01-20'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,2,'Cat''s in the Bag...',48,'2008-01-27'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,3,'...And the Bag''s in the River',48,'2008-02-10'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,4,'Cancer Man',48,'2008-02-17'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,5,'Gray Matter',48,'2008-02-24'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,6,'Crazy Handful of Nothin''',48,'2008-03-02'),
((SELECT id_serie FROM serie WHERE titulo='Breaking Bad'),1,7,'A No-Rough-Stuff-Type Deal',48,'2008-03-09');


/* =====================================================
   Peaky Blinders (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,1,'Episodio 1',58,'2013-09-12'),
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,2,'Episodio 2',58,'2013-09-19'),
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,3,'Episodio 3',57,'2013-09-26'),
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,4,'Episodio 4',58,'2013-10-03'),
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,5,'Episodio 5',59,'2013-10-10'),
((SELECT id_serie FROM serie WHERE titulo='Peaky Blinders'),1,6,'Episodio 6',60,'2013-10-17');

/* =====================================================
   The Office (US) (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,1,'Piloto',23,'2005-03-24'),
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,2,'Diversity Day',22,'2005-03-29'),
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,3,'Health Care',22,'2005-04-05'),
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,4,'The Alliance',22,'2005-04-12'),
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,5,'Basketball',22,'2005-04-19'),
((SELECT id_serie FROM serie WHERE titulo='The Office (US)'),1,6,'Hot Girl',22,'2005-04-26');

/* =====================================================
   Dark (6 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,1,'Secretos',53,'2017-12-01'),
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,2,'Mentiras',45,'2017-12-01'),
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,3,'Pasado y presente',46,'2017-12-01'),
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,4,'Doble vida',48,'2017-12-01'),
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,5,'Verdades',52,'2017-12-01'),
((SELECT id_serie FROM serie WHERE titulo='Dark'),1,6,'Sic Mundus Creatus Est',53,'2017-12-01');

/* =====================================================
   The Walking Dead (7 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,1,'Days Gone Bye',67,'2010-10-31'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,2,'Guts',45,'2010-11-07'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,3,'Tell It to the Frogs',45,'2010-11-14'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,4,'Vatos',45,'2010-11-21'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,5,'Wildfire',45,'2010-11-28'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,6,'TS-19',45,'2010-12-05'),
((SELECT id_serie FROM serie WHERE titulo='The Walking Dead'),1,7,'Nuevo comienzo',45,'2010-12-12');

/* =====================================================
   Dragon Ball GT (5 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball GT'),1,1,'El deseo final',24,'1996-02-07'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball GT'),1,2,'La nave espacial',24,'1996-02-14'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball GT'),1,3,'La búsqueda comienza',24,'1996-02-21'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball GT'),1,4,'Planeta peligroso',24,'1996-02-28'),
((SELECT id_serie FROM serie WHERE titulo='Dragon Ball GT'),1,5,'El poder Saiyan',24,'1996-03-06');

/* =====================================================
   Pokémon (8 episodios)
   ===================================================== */
INSERT INTO episodio (id_serie, numero_temporada, numero_episodio, titulo, duracion_min, fecha_estreno) VALUES
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,1,'¡Pokémon, te elijo a ti!',22,'1997-04-01'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,2,'¡Emergencia Pokémon!',22,'1997-04-08'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,3,'¡Ash atrapa un Pokémon!',22,'1997-04-15'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,4,'¡Desafío Samurai!',22,'1997-04-22'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,5,'¡Duelo en Ciudad Plateada!',22,'1997-04-29'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,6,'¡Clefairy y la piedra lunar!',22,'1997-05-06'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,7,'¡La flor acuática de Ciudad Celeste!',22,'1997-05-13'),
((SELECT id_serie FROM serie WHERE titulo='Pokémon'),1,8,'¡La senda a la Liga Pokémon!',22,'1997-05-20');

/* =====================================================
   ACTORES
   ===================================================== */

-- El muro negro (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Matthias Schweighöfer','1981-03-11','Alemania'),
('Ruby O. Fee','1996-02-07','Alemania'),
('Frederick Lau','1989-08-17','Alemania');

-- Las guerreras Kpop (2 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Stephanie Beatriz','1981-02-10','Estados Unidos'),
('Awkwafina','1988-06-02','Estados Unidos');

-- Wake Up Dead Man (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Daniel Craig','1968-03-02','Reino Unido'),
('Josh O''Connor','1990-05-20','Reino Unido'),
('Glenn Close','1947-03-19','Estados Unidos');

-- Wicked Parte II (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Cynthia Erivo','1987-01-08','Reino Unido'),
('Ariana Grande','1993-06-26','Estados Unidos'),
('Michelle Yeoh','1962-08-06','Malasia');

-- Zootrópolis 2 (3 actores/actrices de voz)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ginnifer Goodwin','1978-05-22','Estados Unidos'),
('Jason Bateman','1969-01-14','Estados Unidos'),
('Shakira','1977-02-02','Colombia');

-- Rebel Moon - Parte 2: La guerrera que deja marca (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sofia Boutella','1982-04-03','Francia'),
('Ed Skrein','1983-03-29','Reino Unido'),
('Djimon Hounsou','1964-04-06','Estados Unidos');

-- El padrino (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Marlon Brando','1924-04-03','Estados Unidos'),
('James Caan','1940-03-26','Estados Unidos');

-- El caballero oscuro (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Christian Bale','1974-01-30','Reino Unido'),
('Heath Ledger','1979-04-04','Australia'),
('Michael Caine','1933-03-14','Reino Unido');

-- El padrino Parte II (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Al Pacino','1940-04-25','Estados Unidos'),
('Robert De Niro','1943-08-17','Estados Unidos'),
('Robert Duvall','1931-01-05','Estados Unidos');

-- 12 hombres sin piedad (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Henry Fonda','1905-05-16','Estados Unidos'),
('Lee J. Cobb','1911-02-28','Estados Unidos'),
('Jack Klugman','1922-04-27','Estados Unidos');

-- Forrest Gump (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Tom Hanks','1956-07-09','Estados Unidos'),
('Robin Wright','1966-04-08','Estados Unidos'),
('Gary Sinise','1955-03-17','Estados Unidos');

-- Interstellar (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Anne Hathaway','1982-11-12','Estados Unidos'),
('Jessica Chastain','1977-03-24','Estados Unidos');

-- Blade Runner 2049 (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ryan Gosling','1980-11-12','Canadá'),
('Ana de Armas','1988-04-30','Cuba');

-- Matrix (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Laurence Fishburne','1961-07-30','Estados Unidos'),
('Carrie-Anne Moss','1967-08-21','Canadá');

-- Gladiator (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Russell Crowe','1964-04-07','Nueva Zelanda'),
('Joaquin Phoenix','1974-10-28','Estados Unidos'),
('Connie Nielsen','1965-07-03','Dinamarca');

-- El silencio de los inocentes (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jodie Foster','1962-11-19','Estados Unidos'),
('Anthony Hopkins','1937-12-31','Reino Unido'),
('Scott Glenn','1939-01-26','Estados Unidos');

-- Los siete samuráis (2 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Toshiro Mifune','1920-04-01','Japón'),
('Takashi Shimura','1905-03-12','Japón');

-- Salvando al soldado Ryan (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Matt Damon','1970-10-08','Estados Unidos'),
('Vin Diesel','1967-07-18','Estados Unidos');

-- Pulp Fiction (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('John Travolta','1954-02-18','Estados Unidos'),
('Samuel L. Jackson','1948-12-21','Estados Unidos'),
('Uma Thurman','1970-04-29','Estados Unidos');

-- Origen (Inception) (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Joseph Gordon-Levitt','1981-02-17','Estados Unidos'),
('Ellen Page','1987-02-21','Canadá'); -- protagonismo confirmado

-- Kingsman: The Blue Blood (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Taron Egerton','1989-11-10','Reino Unido'),
('Colin Firth','1960-09-10','Reino Unido'),
('Halle Berry','1966-08-14','Estados Unidos');

-- Una batalla tras otra (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Chris Hemsworth','1983-08-11','Australia'),
('Tessa Thompson','1983-10-03','Estados Unidos'),
('Idris Elba','1972-09-06','Reino Unido');

-- Bad Boys: Ride or Die (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Will Smith','1968-09-25','Estados Unidos'),
('Martin Lawrence','1965-04-16','Estados Unidos'),
('Paola Nunez','1981-04-08','México'); -- reparto destacado

-- Frankenstein (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Boris Karloff','1887-11-23','Reino Unido'),
('Colin Clive','1900-01-22','Reino Unido'),
('Mae Clarke','1910-11-16','Estados Unidos');

-- El misterio de la familia Carman (1 actor)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ana de la Reguera','1977-04-08','México');

-- En sueños (2 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Chris Sarandon','1942-07-24','Estados Unidos');

-- Selena y los Dinos (2 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jennifer Lopez','1969-07-24','Estados Unidos'),
('Edward James Olmos','1947-02-24','Estados Unidos');

-- Una Navidad Extra (1 actor)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kathy Bates','1948-06-28','Estados Unidos');

-- Aquaman y el Reino Perdido (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jason Momoa','1979-08-01','Estados Unidos'),
('Amber Heard','1986-04-22','Estados Unidos'),
('Patrick Wilson','1973-07-03','Estados Unidos');

-- Nosferatu (2 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Max Schreck','1879-09-06','Alemania'),
('Greta Schröder','1892-06-27','Alemania');

-- Materialistas (2 actores) — reparto estimado
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Lily James','1989-04-05','Reino Unido'),
('Dev Patel','1990-04-23','Reino Unido');

-- Highest 2 Lowest (2 actores) — reparto estimado
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('John Boyega','1992-03-17','Reino Unido'),
('Jodie Turner-Smith','1986-09-07','Reino Unido');

-- The Brutalist (3 actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Felicity Jones','1983-10-17','Reino Unido'),
('Guy Pearce','1967-10-05','Australia');

-- Toy Story (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Tim Allen','1953-06-13','Estados Unidos');

-- Toy Story 2 (2) — secuela de Toy Story
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Joan Cusack','1962-10-11','Estados Unidos'),
('John Ratzenberger','1947-04-06','Estados Unidos');

-- Toy Story 3 (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('John Morris','1984-10-02','Estados Unidos'),
('Wallace Shawn','1947-11-12','Estados Unidos');

-- Up (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Edward Asner','1925-11-15','Estados Unidos'),
('Jordan Nagai','2000-02-05','Estados Unidos'); -- voz de Russell :contentReference[oaicite:0]{index=0}

-- Del revés (Inside Out) (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Amy Poehler','1971-09-16','Estados Unidos'),
('Bill Hader','1978-06-07','Estados Unidos'),
('Phyllis Smith','1951-07-10','Estados Unidos'); -- principales voces :contentReference[oaicite:1]{index=1}

-- Blade Runner (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Rutger Hauer','1944-01-23','Países Bajos'); -- protagonista clásico

-- 2001: Una odisea del espacio (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Keir Dullea','1939-05-30','Estados Unidos'),
('Gary Lockwood','1937-02-21','Estados Unidos'); -- protagonistas :contentReference[oaicite:2]{index=2}

-- Terminator (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Arnold Schwarzenegger','1947-07-30','Austria'),
('Linda Hamilton','1956-09-26','Estados Unidos'),
('Michael Biehn','1956-07-31','Estados Unidos'); -- reparto principal

-- E.T. el extraterrestre (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Henry Thomas','1971-09-09','Estados Unidos'),
('Drew Barrymore','1975-02-22','Estados Unidos'); -- principales

-- Distrito 9 (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sharlto Copley','1973-11-27','Sudáfrica'),
('Jason Cope','1974-07-24','Sudáfrica'); -- reparto principal :contentReference[oaicite:3]{index=3}

-- Indiana Jones y la última cruzada (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Harrison Ford','1942-07-13','Estados Unidos'), -- ya puesto arriba, no duplicar si tu base lo evita
('Sean Connery','1930-08-25','Reino Unido'),
('Denholm Elliott','1922-05-31','Reino Unido'); -- papeles principales

-- Mad Max: Fury Road (1-3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Tom Hardy','1977-09-15','Reino Unido'),         -- Protagonista Max Rockatansky :contentReference[oaicite:0]{index=0}
('Charlize Theron','1975-08-07','Sudáfrica');      -- Imperator Furiosa :contentReference[oaicite:1]{index=1}

-- Jurassic Park (1-3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sam Neill','1947-09-14','Nueva Zelanda'),       -- Dr. Alan Grant :contentReference[oaicite:2]{index=2}
('Laura Dern','1967-02-10','Estados Unidos'),    -- Dra. Ellie Sattler :contentReference[oaicite:3]{index=3}
('Jeff Goldblum','1952-10-22','Estados Unidos'); -- Dr. Ian Malcolm :contentReference[oaicite:4]{index=4}

-- Piratas del Caribe: La maldición del Perla Negra
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Johnny Depp','1963-06-09','Estados Unidos');   -- Capitán Jack Sparrow :contentReference[oaicite:5]{index=5}

-- Cadena perpetua (The Shawshank Redemption)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Tim Robbins','1958-10-16','Estados Unidos');-- Red :contentReference[oaicite:7]{index=7}

-- El club de la lucha (Fight Club)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Edward Norton','1969-08-18','Estados Unidos');-- Narrador

-- American Beauty
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kevin Spacey','1959-07-26','Estados Unidos'),  -- Lester Burnham
('Annette Bening','1958-05-29','Estados Unidos');

-- El pianista (The Pianist)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Adrien Brody','1973-04-14','Estados Unidos');  -- Wladyslaw Szpilman

-- Atrapado en el tiempo (Groundhog Day)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Bill Murray','1950-09-21','Estados Unidos');   -- Phil Connors

-- La máscara (The Mask)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jim Carrey','1962-01-17','Canadá');            -- Stanley Ipkiss

-- Supersalidos (Superbad)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jonah Hill','1983-12-20','Estados Unidos');    -- Seth

-- El exorcista (The Exorcist)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ellen Burstyn','1932-12-07','Estados Unidos'); -- Chris MacNeil

-- It
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Bill Skarsgård','1990-08-09','Suecia');        -- Pennywise

-- Hereditary
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Toni Collette','1972-11-01','Australia');      -- Annie Graham

-- Titanic
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Leonardo DiCaprio','1974-11-11','Estados Unidos'), -- Jack Dawson :contentReference[oaicite:8]{index=8}
('Kate Winslet','1975-10-05','Reino Unido');         -- Rose Dewitt Bukater

-- La La Land (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Emma Stone','1988-11-06','Estados Unidos');

-- Amélie (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Audrey Tautou','1976-08-09','Francia'),
('Mathieu Kassovitz','1967-08-03','Francia');

-- La vida es bella (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Roberto Benigni','1952-10-27','Italia');

-- Seven (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Brad Pitt','1963-12-18','Estados Unidos'),
('Gwyneth Paltrow','1972-09-27','Estados Unidos');

-- Zodiac (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jake Gyllenhaal','1980-12-19','Estados Unidos'),
('Robert Downey Jr.','1965-04-04','Estados Unidos');

-- Drive (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Carey Mulligan','1985-05-28','Reino Unido');

-- March of the Penguins (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Morgan Freeman','1937-06-01','Estados Unidos');

-- Free Solo (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Alex Honnold','1985-08-17','Estados Unidos');

-- Avatar (3) — saga original
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sam Worthington','1976-08-02','Australia'),
('Zoe Saldaña','1978-06-19','Estados Unidos'),
('Sigourney Weaver','1949-10-08','Estados Unidos');

-- Avatar: El sentido del agua / Fire and Ash (2 más)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Stephen Lang','1952-07-11','Estados Unidos');

-- El señor de los anillos: La comunidad del anillo (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Elijah Wood','1981-01-28','Estados Unidos'),
('Ian McKellen','1939-05-25','Reino Unido'),
('Viggo Mortensen','1958-10-20','Estados Unidos');

-- El señor de los anillos: Las dos torres (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Orlando Bloom','1977-01-13','Reino Unido'),
('Sean Astin','1971-02-25','Estados Unidos');

-- El señor de los anillos: El retorno del rey (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Cate Blanchett','1969-05-14','Australia'),
('John Rhys-Davies','1944-05-05','Reino Unido');

-- Harry Potter y la piedra filosofal (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Daniel Radcliffe','1989-07-23','Reino Unido'),
('Emma Watson','1990-04-15','Reino Unido'),
('Rupert Grint','1988-08-24','Reino Unido'); -- protagonistas de la saga :contentReference[oaicite:0]{index=0}

-- Harry Potter y la cámara secreta (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Richard Harris','1930-10-01','Reino Unido'); -- vuelve a aparecer pero puede ignorarse si ya está :contentReference[oaicite:1]{index=1}

-- Harry Potter y el prisionero de Azkaban (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Maggie Smith','1934-12-28','Reino Unido'); -- papel importante como Minerva McGonagall :contentReference[oaicite:2]{index=2}

-- Five Nights at Freddy's (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Josh Hutcherson','1992-10-12','Estados Unidos'),
('Elizabeth Lail','1992-03-25','Estados Unidos'); -- protagonistas según reparto oficial :contentReference[oaicite:3]{index=3}

-- Five Nights at Freddy's 2 (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Matthew Lillard','1970-03-24','Estados Unidos'); -- papel destacado en la saga FNAF :contentReference[oaicite:4]{index=4}

-- Star Wars: Una nueva esperanza (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Mark Hamill','1951-09-25','Estados Unidos'),
('Carrie Fisher','1956-10-21','Estados Unidos'),
('Alec Guinness','1914-04-02','Reino Unido'); -- reparto principal :contentReference[oaicite:5]{index=5}

-- Star Wars: El Imperio contraataca (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Peter Mayhew','1944-05-19','Reino Unido'),
('Anthony Daniels','1946-02-21','Reino Unido'); -- repiten de la trilogía original :contentReference[oaicite:6]{index=6}

-- Star Wars: El retorno del Jedi (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('David Prowse','1935-07-01','Reino Unido'),
('Kenny Baker','1934-08-24','Reino Unido'); -- personajes icónicos :contentReference[oaicite:7]{index=7}

-- John Wick (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Keanu Reeves','1964-09-02','Canadá'),
('Michael Nyqvist','1960-11-08','Suecia'),
('Willem Dafoe','1953-07-22','Estados Unidos'); -- reparto principal según datos SensaCine :contentReference[oaicite:8]{index=8}

-- John Wick: Capítulo 2 (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ian McShane','1942-09-22','Reino Unido'),
('Bridget Moynahan','1971-04-28','Estados Unidos'); -- papeles importantes :contentReference[oaicite:9]{index=9}

-- John Wick: Capítulo 3 – Parabellum (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Lance Reddick','1962-12-31','Estados Unidos'),
('Tait Fletcher','1973-06-06','Estados Unidos'); -- figuras recurrentes en la saga :contentReference[oaicite:10]{index=10}

-- Stranger Things (4)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Finn Wolfhard','2002-12-23','Canadá'),
('Gaten Matarazzo','2002-09-08','Estados Unidos'),
('Noah Schnapp','2004-10-03','Estados Unidos'); -- (ya añadido previamente si está repetido, MySQL ignorará por UNIQUE si lo marcas)

-- Black Mirror (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Daniel Kaluuya','1989-02-24','Reino Unido'),
('Paul Giamatti','1967-06-06','Estados Unidos'),
('Rashida Jones','1976-02-25','Estados Unidos');

-- Cobra Kai (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ralph Macchio','1961-11-04','Estados Unidos'),
('William Zabka','1965-10-20','Estados Unidos'),
('Mary Mouser','1999-05-09','Estados Unidos');

-- Sex Education (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Asa Butterfield','1997-04-01','Reino Unido'),
('Emma Mackey','1996-01-04','Francia'),
('Ncuti Gatwa','1992-10-15','Reino Unido');

-- Heartstopper (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kit Connor','2004-03-08','Reino Unido'),
('Joe Locke','2003-12-24','Reino Unido');

-- Pluribus (2 — ficción corporativa, supuestos actores)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Corey Stoll','1976-12-14','Estados Unidos'),
('Jennifer Connelly','1970-12-12','Estados Unidos');

-- Tabú (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Oona Chaplin','1986-06-04','España');

-- One Piece (3 — live-action)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Iñaki Godoy','2003-10-25','México'),
('Mackenyu','1996-11-16','Japón'),
('Emily Rudd','1993-07-24','Estados Unidos');

-- Arcane: League of Legends (3 — voces)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Hailee Steinfeld','1996-12-11','Estados Unidos'),
('Kevin Alejandro','1976-04-07','Estados Unidos'),
('Toks Olagundoye','1975-06-22','Nigeria');

-- La noche más larga (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Luis Callejo','1970-11-05','España'),
('Alberto Ammann','1978-08-20','España'),
('Bárbara Goenaga','1979-10-25','España');

-- The Bear (5 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jeremy Allen White','1991-02-17','Estados Unidos'),
('Ayo Edebiri','1995-10-03','Estados Unidos'),
('Ebon Moss-Bachrach','1977-12-14','Estados Unidos'),
('Lionel Boyce','1992-07-15','Estados Unidos'),
('Liza Colón-Zayas','1972-05-25','Estados Unidos');

-- Alien: Earth (4 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sydney Chandler','1999-07-13','Estados Unidos'),
('Alex Lawther','1995-05-07','Reino Unido'),
('Timothy Olyphant','1968-05-20','Estados Unidos'),
('Essie Davis','1970-02-17','Australia');

-- Dune: The Sisterhood (3 actores principales aproximados)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jessica Barden','1992-07-28','Reino Unido'),
('Travis Fimmel','1979-07-15','Australia');

-- House of the Dragon (3 actores principales conocidos)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Emma D’Arcy','1992-06-02','Reino Unido'),
('Matt Smith','1982-10-28','Reino Unido'),
('Rhys Ifans','1967-07-22','Reino Unido');

-- The Last of Us (2 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Bella Ramsey','2003-09-25','Reino Unido');

-- Chernobyl: Aftermath (3 actores principales del miniserie original Chernobyl)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jared Harris','1961-08-24','Reino Unido'),
('Stellan Skarsgård','1951-06-13','Suecia'),
('Emily Watson','1967-01-14','Reino Unido');

-- Mozart in the Jungle (2 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Gael García Bernal','1978-11-30','México'),
('Saffron Burrows','1968-10-22','Reino Unido');

-- Black Sails (3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Toby Stephens','1969-04-21','Reino Unido'),
('Hannah New','1990-04-13','Nueva Zelanda'),
('Luke Arnold','1984-05-05','Australia');

-- Narcos (3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Wagner Moura','1976-06-27','Brasil'),
('Pedro Pascal','1975-04-02','Chile'),
('Boyd Holbrook','1981-09-01','Estados Unidos');

-- Lupin (2 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Omar Sy','1978-01-20','Francia'),
('Ludivine Sagnier','1979-07-03','Francia');

-- Bridgerton (2 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Phoebe Dynevor','1995-04-17','Reino Unido'),
('Regé-Jean Page','1990-04-27','Reino Unido');

-- The Witcher (2 actores principales — elección de reparto)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Henry Cavill','1983-05-05','Reino Unido'),
('Anya Chalotra','1996-07-21','Reino Unido');

-- Rick and Morty (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Justin Roiland','1980-02-21','Estados Unidos'),
('Sarah Chalke','1976-08-24','Canadá');

-- Friends Reunion (2 protagonistas principales del especial)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jennifer Aniston','1969-02-11','Estados Unidos'),
('Courteney Cox','1964-06-15','Estados Unidos');

-- Vikings: Valhalla (3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sam Corlett','1995-03-19','Australia'),
('Frida Gustavsson','1993-06-06','Suecia'),
('Leo Suter','1993-05-26','Reino Unido');

-- Mindhunter (2 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jonathan Groff','1985-03-26','Estados Unidos'),
('Holt McCallany','1963-09-03','Estados Unidos');

-- Modern Family (3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ed ONeill','1946-04-12','Estados Unidos'),
('Sofía Vergara','1972-07-10','Colombia'),
('Julie Bowen','1970-03-03','Estados Unidos');

-- La Casa de Papel (3 actores principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Álvaro Morte','1975-02-23','España'),
('Úrsula Corberó','1989-08-11','España'),
('Itziar Ituño','1974-06-18','España');

-- Attack on Titan (3 voces principales del anime)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Yuki Kaji','1985-09-03','Japón'),
('Yui Ishikawa','1988-07-19','Japón'),
('Marina Inoue','1985-09-20','Japón');

-- Death Note (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kappei Yamaguchi','1965-05-24','Japón'); -- Voz de L (actor de doblaje japonés)

-- Fullmetal Alchemist: Brotherhood (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Romi Park','1972-01-22','Corea del Sur / Japón'),  -- Voz de Edward Elric :contentReference[oaicite:2]{index=2}
('Maxey Whitehead','1988-09-16','Estados Unidos');  -- Voz de Alphonse Elric :contentReference[oaicite:3]{index=3}

-- Demon Slayer (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Natsuki Hanae','1991-06-26','Japón'),  -- Voz de Tanjiro
('Zach Aguilar','1998-02-21','Estados Unidos');  -- Voz de Tanjiro en inglés :contentReference[oaicite:4]{index=4}

-- One Punch Man (1)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Max Mittelman','1990-09-05','Estados Unidos');  -- Voz de Saitama :contentReference[oaicite:5]{index=5}

-- Los Simpson (3 voces principales, versión original)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Dan Castellaneta','1957-10-29','Estados Unidos'),
('Julie Kavner','1950-09-07','Estados Unidos'),
('Nancy Cartwright','1957-10-25','Estados Unidos');

-- Futurama (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Billy West','1952-04-16','Estados Unidos'),
('Katey Sagal','1954-01-19','Estados Unidos');

-- Bojack Horseman (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Will Arnett','1970-05-04','Canadá'),
('Aaron Paul','1979-08-27','Estados Unidos');

-- South Park (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Trey Parker','1969-10-19','Estados Unidos'),
('Matt Stone','1971-05-26','Estados Unidos');

-- Better Call Saul (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Bob Odenkirk','1962-10-22','Estados Unidos'),
('Rhea Seehorn','1972-05-12','Estados Unidos');

-- True Detective (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Matthew McConaughey','1969-11-04','Estados Unidos'),
('Woody Harrelson','1961-07-23','Estados Unidos');

-- Band of Brothers (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Damian Lewis','1971-02-11','Reino Unido'),
('Ron Livingston','1967-06-05','Estados Unidos');

-- The Boys (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Karl Urban','1972-06-07','Nueva Zelanda'),
('Jack Quaid','1992-04-24','Estados Unidos');

-- Andor (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Diego Luna','1979-12-29','México');

-- Westworld (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Evan Rachel Wood','1987-09-07','Estados Unidos'),
('Jeffrey Wright','1965-12-05','Estados Unidos');

-- Haikyuu!! (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ayumu Murase','1993-08-27','Japón'), -- Voz de Shōyō Hinata
('Kaito Ishikawa','1993-05-23','Japón'); -- Voz de Tobio Kageyama

-- Naruto (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Junko Takeuchi','1972-04-05','Japón'), -- Voz de Naruto :contentReference[oaicite:6]{index=6}
('Maile Flanagan','1965-03-31','Estados Unidos'); -- Voz de Naruto en inglés

-- Naruto Shippuden (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kazuhiko Inoue','1954-05-05','Japón'), -- Voz de Kakashi
('Kate Higgins','1968-08-16','Estados Unidos'); -- Voz de Sakura en inglés

-- Dragon Ball (2 voces principales)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Sean Schemmel','1968-11-03','Estados Unidos'); -- Voz de Goku en inglés

-- Dragon Ball Z (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kyle Hebert','1969-10-26','Estados Unidos'); -- Voz de adult Gohan

-- Dragon Ball Super (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ian Sinclair','1976-08-08','Estados Unidos'), -- Voz de Goku Black
('Colleen Clinkenbeard','1972-10-13','Estados Unidos'); -- Voz de Android 18

-- My Hero Academia (3 voces principales) :contentReference[oaicite:0]{index=0}
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Justin Briner','1993-08-14','Estados Unidos'),  -- Voz de Izuku Midoriya :contentReference[oaicite:1]{index=1}
('Christopher Sabat','1973-02-20','Estados Unidos'), -- Voz de All-Might :contentReference[oaicite:2]{index=2}
('Monica Rial','1975-10-05','Estados Unidos');   -- Voz de Tsuyu Asui :contentReference[oaicite:3]{index=3}

-- Jujutsu Kaisen (2) — voz principal e interpretación destacada :contentReference[oaicite:4]{index=4}
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Yūichi Nakamura','1980-05-20','Japón'); -- Voz de Satoru Gojo / otros roles :contentReference[oaicite:5]{index=5}

-- Tokyo Ghoul (2) — voces representativas (anime)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Mamoru Miyano','1983-06-15','Japón'),
('Sōma Saitō','1991-06-22','Japón');

-- Bleach (2) — voces principales anime :contentReference[oaicite:7]{index=7}
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Jun’ichi Suwabe','1973-10-29','Japón'), -- también interpretó en varias series :contentReference[oaicite:8]{index=8}
('Shō Hayami','1958-07-02','Japón');    -- voz de Aizen :contentReference[oaicite:9]{index=9}

-- Sword Art Online (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Haruka Tomatsu','1990-02-04','Japón'),
('Yoshitsugu Matsuoka','1986-09-17','Japón');

-- Neon Genesis Evangelion (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Megumi Ogata','1969-06-06','Japón');

-- Cowboy Bebop (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kôichi Yamadera','1961-06-17','Japón'),
('Unshō Ishizuka','1951-05-16','Japón');

-- Steins;Gate (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Asami Imai','1977-08-07','Japón');

-- Juego de Tronos (3) — reparto principal
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kit Harington','1986-12-26','Reino Unido'),
('Emilia Clarke','1986-10-23','Reino Unido'),
('Peter Dinklage','1969-06-11','Estados Unidos');

-- Lost (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Matthew Fox','1966-07-14','Estados Unidos'),
('Evangeline Lilly','1979-08-03','Canadá'),
('Terry O’Quinn','1952-07-15','Estados Unidos');

-- Breaking Bad (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Bryan Cranston','1956-03-07','Estados Unidos'),
('Anna Gunn','1968-08-11','Estados Unidos');

-- Peaky Blinders (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Cillian Murphy','1976-05-25','Irlanda'),
('Helen McCrory','1968-08-17','Reino Unido');

-- The Office (US) (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Steve Carell','1962-08-16','Estados Unidos'),
('John Krasinski','1979-10-20','Estados Unidos'),
('Jenna Fischer','1974-03-07','Estados Unidos');

-- Dark (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Louis Hofmann','1997-06-23','Alemania'),
('Lisa Vicari','1997-02-11','Alemania');

-- The Walking Dead (3)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Andrew Lincoln','1973-09-14','Reino Unido'),
('Norman Reedus','1969-01-06','Estados Unidos'),
('Melissa McBride','1965-05-23','Estados Unidos');

-- Dragon Ball GT (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Masako Nozawa','1936-10-25','Japón'), -- voz de Goku :contentReference[oaicite:10]{index=10}
('Rica Matsumoto','1969-11-30','Japón');  -- voz de Goku niño :contentReference[oaicite:11]{index=11}

-- Pokémon (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Ikue Ōtani','1965-08-18','Japón'), -- voz de Pikachu :contentReference[oaicite:12]{index=12}
('Veronica Taylor','1970-08-03','Estados Unidos'); -- voz de Ash en inglés

-- Sailor Moon (2)
INSERT INTO actor (nombre, fecha_nacimiento, pais) VALUES
('Kotono Mitsuishi','1967-08-08','Japón'), -- voz de Usagi/Sailor Moon
('Ayane Sakura','1994-01-29','Japón');     -- voz en varias series anime :contentReference[oaicite:13]{index=13}

/* =====================================================
   REPARTO
   ===================================================== */

-- El muro negro
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Matthias Schweighöfer'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El muro negro'), NULL, 'Tim'),
((SELECT id_actor FROM actor WHERE nombre = 'Ruby O. Fee'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El muro negro'), NULL, 'Olivia'),
((SELECT id_actor FROM actor WHERE nombre = 'Frederick Lau'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El muro negro'), NULL, 'Marvin');

-- Las guerreras Kpop
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Stephanie Beatriz'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Las guerreras Kpop'), NULL, 'Rumi'),
((SELECT id_actor FROM actor WHERE nombre = 'Awkwafina'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Las guerreras Kpop'), NULL, 'Mira');

-- Wake Up Dead Man
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Daniel Craig'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wake Up Dead Man'), NULL, 'Benoit Blanc'),
((SELECT id_actor FROM actor WHERE nombre = 'Josh O''Connor'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wake Up Dead Man'), NULL, 'Jud Duplenticy'),
((SELECT id_actor FROM actor WHERE nombre = 'Glenn Close'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wake Up Dead Man'), NULL, 'Martha Delacroix');

-- Wicked Parte II
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Cynthia Erivo'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wicked Parte II'), NULL, 'Elphaba'),
((SELECT id_actor FROM actor WHERE nombre = 'Ariana Grande'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wicked Parte II'), NULL, 'Glinda'),
((SELECT id_actor FROM actor WHERE nombre = 'Michelle Yeoh'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Wicked Parte II'), NULL, 'Madame Morrible');

-- Zootrópolis 2
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ginnifer Goodwin'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Zootrópolis 2'), NULL, 'Judy Hopps'),
((SELECT id_actor FROM actor WHERE nombre = 'Jason Bateman'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Zootrópolis 2'), NULL, 'Nick Wilde'),
((SELECT id_actor FROM actor WHERE nombre = 'Shakira'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Zootrópolis 2'), NULL, 'Gazelle');

-- Rebel Moon - Parte 2: La guerrera que deja marca
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sofia Boutella'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Rebel Moon - Parte 2: La guerrera que deja marca'), NULL, 'Kora'),
((SELECT id_actor FROM actor WHERE nombre = 'Ed Skrein'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Rebel Moon - Parte 2: La guerrera que deja marca'), NULL, 'Jedikiah'),
((SELECT id_actor FROM actor WHERE nombre = 'Djimon Hounsou'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Rebel Moon - Parte 2: La guerrera que deja marca'), NULL, 'Trey');

-- El padrino
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Marlon Brando'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino'), NULL, 'Vito Corleone'),
((SELECT id_actor FROM actor WHERE nombre = 'James Caan'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino'), NULL, 'Sonny Corleone'),
((SELECT id_actor FROM actor WHERE nombre = 'Al Pacino'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino'), NULL, 'Michael Corleone');

-- El caballero oscuro
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Christian Bale'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El caballero oscuro'), NULL, 'Bruce Wayne / Batman'),
((SELECT id_actor FROM actor WHERE nombre = 'Heath Ledger'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El caballero oscuro'), NULL, 'Joker'),
((SELECT id_actor FROM actor WHERE nombre = 'Michael Caine'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El caballero oscuro'), NULL, 'Alfred Pennyworth');

-- El padrino Parte II
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Al Pacino'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino Parte II'), NULL, 'Michael Corleone'),
((SELECT id_actor FROM actor WHERE nombre = 'Robert De Niro'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino Parte II'), NULL, 'Vito Corleone joven'),
((SELECT id_actor FROM actor WHERE nombre = 'Robert Duvall'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El padrino Parte II'), NULL, 'Tom Hagen');

-- 12 hombres sin piedad
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Henry Fonda'), (SELECT id_pelicula FROM pelicula WHERE titulo = '12 hombres sin piedad'), NULL, 'Juror #8'),
((SELECT id_actor FROM actor WHERE nombre = 'Lee J. Cobb'), (SELECT id_pelicula FROM pelicula WHERE titulo = '12 hombres sin piedad'), NULL, 'Juror #3'),
((SELECT id_actor FROM actor WHERE nombre = 'Jack Klugman'), (SELECT id_pelicula FROM pelicula WHERE titulo = '12 hombres sin piedad'), NULL, 'Juror #5');

-- Forrest Gump
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hanks'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Forrest Gump'), NULL, 'Forrest Gump'),
((SELECT id_actor FROM actor WHERE nombre = 'Robin Wright'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Forrest Gump'), NULL, 'Jenny Curran'),
((SELECT id_actor FROM actor WHERE nombre = 'Gary Sinise'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Forrest Gump'), NULL, 'Lieutenant Dan Taylor');

-- Interstellar
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Anne Hathaway'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Amelia Brand'),
((SELECT id_actor FROM actor WHERE nombre = 'Jessica Chastain'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Murph Cooper'),
((SELECT id_actor FROM actor WHERE nombre = 'Matthew McConaughey'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Cooper');

-- Blade Runner 2049
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ryan Gosling'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Blade Runner 2049'), NULL, 'K'),
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Blade Runner 2049'), NULL, 'Rick Deckard'),
((SELECT id_actor FROM actor WHERE nombre = 'Ana de Armas'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Blade Runner 2049'), NULL, 'Joi');

-- Matrix
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keanu Reeves'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Matrix'), NULL, 'Neo'),
((SELECT id_actor FROM actor WHERE nombre = 'Laurence Fishburne'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Matrix'), NULL, 'Morpheus'),
((SELECT id_actor FROM actor WHERE nombre = 'Carrie-Anne Moss'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Matrix'), NULL, 'Trinity');

-- Gladiator
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Russell Crowe'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Gladiator'), NULL, 'Maximus Decimus Meridius'),
((SELECT id_actor FROM actor WHERE nombre = 'Joaquin Phoenix'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Gladiator'), NULL, 'Commodus'),
((SELECT id_actor FROM actor WHERE nombre = 'Connie Nielsen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Gladiator'), NULL, 'Lucilla');

-- El silencio de los inocentes
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jodie Foster'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El silencio de los inocentes'), NULL, 'Clarice Starling'),
((SELECT id_actor FROM actor WHERE nombre = 'Anthony Hopkins'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El silencio de los inocentes'), NULL, 'Hannibal Lecter'),
((SELECT id_actor FROM actor WHERE nombre = 'Scott Glenn'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El silencio de los inocentes'), NULL, 'Jack Crawford');

-- Los siete samuráis
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Toshiro Mifune'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Los siete samuráis'), NULL, 'Kikuchiyo'),
((SELECT id_actor FROM actor WHERE nombre = 'Takashi Shimura'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Los siete samuráis'), NULL, 'Kambei Shimada');

-- Salvando al soldado Ryan
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hanks'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Salvando al soldado Ryan'), NULL, 'Captain John H. Miller'),
((SELECT id_actor FROM actor WHERE nombre = 'Matt Damon'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Salvando al soldado Ryan'), NULL, 'Private James Francis Ryan'),
((SELECT id_actor FROM actor WHERE nombre = 'Vin Diesel'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Salvando al soldado Ryan'), NULL, 'Private Adrian Caparzo');

-- Pulp Fiction
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'John Travolta'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Pulp Fiction'), NULL, 'Vincent Vega'),
((SELECT id_actor FROM actor WHERE nombre = 'Samuel L. Jackson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Pulp Fiction'), NULL, 'Jules Winnfield'),
((SELECT id_actor FROM actor WHERE nombre = 'Uma Thurman'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Pulp Fiction'), NULL, 'Mia Wallace');

-- Origen (Inception)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Joseph Gordon-Levitt'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Arthur'),
((SELECT id_actor FROM actor WHERE nombre = 'Ellen Page'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Ariadne'),
((SELECT id_actor FROM actor WHERE nombre = 'Leonardo DiCaprio'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Interstellar'), NULL, 'Dom Cobb');

-- Kingsman: The Blue Blood
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Taron Egerton'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Kingsman: The Blue Blood'), NULL, 'Eggsy'),
((SELECT id_actor FROM actor WHERE nombre = 'Colin Firth'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Kingsman: The Blue Blood'), NULL, 'Harry Hart'),
((SELECT id_actor FROM actor WHERE nombre = 'Halle Berry'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Kingsman: The Blue Blood'), NULL, 'Ginger Ale');

-- Una batalla tras otra
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Chris Hemsworth'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Una batalla tras otra'), NULL, 'Maximus'),
((SELECT id_actor FROM actor WHERE nombre = 'Tessa Thompson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Una batalla tras otra'), NULL, 'Valencia'),
((SELECT id_actor FROM actor WHERE nombre = 'Idris Elba'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Una batalla tras otra'), NULL, 'Komodo');

-- Bad Boys: Ride or Die
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Will Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Bad Boys: Ride or Die'), NULL, 'Mike Lowrey'),
((SELECT id_actor FROM actor WHERE nombre = 'Martin Lawrence'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Bad Boys: Ride or Die'), NULL, 'Marcus Burnett'),
((SELECT id_actor FROM actor WHERE nombre = 'Paola Nunez'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Bad Boys: Ride or Die'), NULL, 'Isabel Aretas');

-- Frankenstein
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Boris Karloff'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Frankenstein'), NULL, 'Frankenstein\'s Monster'),
((SELECT id_actor FROM actor WHERE nombre = 'Colin Clive'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Frankenstein'), NULL, 'Dr. Henry Frankenstein'),
((SELECT id_actor FROM actor WHERE nombre = 'Mae Clarke'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Frankenstein'), NULL, 'Elizabeth Lavenza');

-- El misterio de la familia Carman
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ana de la Reguera'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El misterio de la familia Carman'), NULL, 'Protagonista Carman');

-- En sueños
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ellen Burstyn'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'En sueños'), NULL, 'Sara Goldfarb'),
((SELECT id_actor FROM actor WHERE nombre = 'Chris Sarandon'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'En sueños'), NULL, 'Roger Hobbs');

-- Selena y los Dinos
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jennifer Lopez'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Selena y los Dinos'), NULL, 'Selena Quintanilla'),
((SELECT id_actor FROM actor WHERE nombre = 'Edward James Olmos'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Selena y los Dinos'), NULL, 'Abraham Quintanilla');

-- Una Navidad Extra
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kathy Bates'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Una Navidad Extra'), NULL, 'Ellen');

-- Aquaman y el Reino Perdido
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jason Momoa'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Aquaman y el reino perdido'), NULL, 'Arthur Curry / Aquaman'),
((SELECT id_actor FROM actor WHERE nombre = 'Amber Heard'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Aquaman y el reino perdido'), NULL, 'Mera'),
((SELECT id_actor FROM actor WHERE nombre = 'Patrick Wilson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Aquaman y el reino perdido'), NULL, 'Orm / Ocean Master');

-- Nosferatu
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Max Schreck'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Nosferatu'), NULL, 'Graf Orlok'),
((SELECT id_actor FROM actor WHERE nombre = 'Greta Schröder'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Nosferatu'), NULL, 'Ellen Hutter');

-- Materialistas
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Lily James'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Materialistas'), NULL, 'Lucy'),
((SELECT id_actor FROM actor WHERE nombre = 'Dev Patel'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Materialistas'), NULL, 'Harry');

-- Highest 2 Lowest
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'John Boyega'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Highest 2 Lowest'), NULL, 'Detective Earl Bridges'),
((SELECT id_actor FROM actor WHERE nombre = 'Jodie Turner-Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Highest 2 Lowest'), NULL, 'Detective Bell');

-- The Brutalist
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Felicity Jones'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'The Brutalist'), NULL, 'Erzsébet Tóth'),
((SELECT id_actor FROM actor WHERE nombre = 'Guy Pearce'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'The Brutalist'), NULL, 'Harrison Lee Van Buren Sr.'),
((SELECT id_actor FROM actor WHERE nombre = 'Adrien Brody'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'The Brutalist'), NULL, 'László Tóth');

-- Toy Story
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hanks'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story'), NULL, 'Woody'),
((SELECT id_actor FROM actor WHERE nombre = 'Tim Allen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story'), NULL, 'Buzz Lightyear');

-- Toy Story 2
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tim Allen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 2'), NULL, 'Buzz Lightyear'),
((SELECT id_actor FROM actor WHERE nombre = 'Joan Cusack'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 2'), NULL, 'Jessie'),
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hanks'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 2'), NULL, 'Woody'),
((SELECT id_actor FROM actor WHERE nombre = 'John Ratzenberger'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 2'), NULL, 'Hamm');

-- Toy Story 3
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'John Morris'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 3'), NULL, 'Andy Davis'),
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hanks'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 3'), NULL, 'Woody'),
((SELECT id_actor FROM actor WHERE nombre = 'Tim Allen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 3'), NULL, 'Buzz Lightyear'),
((SELECT id_actor FROM actor WHERE nombre = 'Wallace Shawn'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Toy Story 3'), NULL, 'Rex');

-- Up
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Edward Asner'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Up'), NULL, 'Carl Fredricksen'),
((SELECT id_actor FROM actor WHERE nombre = 'Jordan Nagai'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Up'), NULL, 'Russell');

-- Del revés (Inside Out)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Amy Poehler'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Del revés'), NULL, 'Alegría'),
((SELECT id_actor FROM actor WHERE nombre = 'Bill Hader'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Del revés'), NULL, 'Temor'),
((SELECT id_actor FROM actor WHERE nombre = 'Phyllis Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Del revés'), NULL, 'Tristeza');

-- Blade Runner (original)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Rutger Hauer'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Blade Runner'), NULL, 'Roy Batty'),
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Blade Runner'), NULL, 'Rick Deckard');

-- 2001: Una odisea del espacio
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keir Dullea'), (SELECT id_pelicula FROM pelicula WHERE titulo = '2001: Una odisea del espacio'), NULL, 'Dr. David Bowman'),
((SELECT id_actor FROM actor WHERE nombre = 'Gary Lockwood'), (SELECT id_pelicula FROM pelicula WHERE titulo = '2001: Una odisea del espacio'), NULL, 'Dr. Frank Poole');

-- Terminator
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Arnold Schwarzenegger'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Terminator'), NULL, 'Terminator'),
((SELECT id_actor FROM actor WHERE nombre = 'Linda Hamilton'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Terminator'), NULL, 'Sarah Connor'),
((SELECT id_actor FROM actor WHERE nombre = 'Michael Biehn'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Terminator'), NULL, 'Kyle Reese');

-- E.T. el extraterrestre
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Henry Thomas'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'E.T. el extraterrestre'), NULL, 'Elliott'),
((SELECT id_actor FROM actor WHERE nombre = 'Drew Barrymore'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'E.T. el extraterrestre'), NULL, 'Gertie');

-- Distrito 9
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sharlto Copley'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Distrito 9'), NULL, 'Wikus van de Merwe'),
((SELECT id_actor FROM actor WHERE nombre = 'Jason Cope'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Distrito 9'), NULL, 'Grey Bradnam');

-- Indiana Jones y la última cruzada
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Indiana Jones y la última cruzada'), NULL, 'Indiana Jones'),
((SELECT id_actor FROM actor WHERE nombre = 'Sean Connery'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Indiana Jones y la última cruzada'), NULL, 'Professor Henry Jones'),
((SELECT id_actor FROM actor WHERE nombre = 'Denholm Elliott'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Indiana Jones y la última cruzada'), NULL, 'Marcus Brody');

-- Mad Max: Fury Road
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hardy'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Mad Max: Fury Road'), NULL, 'Max Rockatansky'),
((SELECT id_actor FROM actor WHERE nombre = 'Charlize Theron'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Mad Max: Fury Road'), NULL, 'Imperator Furiosa');

-- Jurassic Park
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sam Neill'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Jurassic Park'), NULL, 'Dr. Alan Grant'),
((SELECT id_actor FROM actor WHERE nombre = 'Laura Dern'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Jurassic Park'), NULL, 'Dra. Ellie Sattler'),
((SELECT id_actor FROM actor WHERE nombre = 'Jeff Goldblum'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Jurassic Park'), NULL, 'Dr. Ian Malcolm');

-- Piratas del Caribe: La maldición del Perla Negra
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Johnny Depp'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Piratas del Caribe: La maldición del Perla Negra'), NULL, 'Capitán Jack Sparrow');

-- Cadena perpetua (The Shawshank Redemption)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tim Robbins'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Cadena perpetua'), NULL, 'Andy Dufresne'),
((SELECT id_actor FROM actor WHERE nombre = 'Morgan Freeman'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Cadena perpetua'), NULL, 'Ellis Boyd \"Red\" Redding');

-- El club de la lucha (Fight Club)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Brad Pitt'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El club de la lucha'), NULL, 'Tyler Durden'),
((SELECT id_actor FROM actor WHERE nombre = 'Edward Norton'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El club de la lucha'), NULL, 'El Narrador');

-- American Beauty
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kevin Spacey'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'American Beauty'), NULL, 'Lester Burnham'),
((SELECT id_actor FROM actor WHERE nombre = 'Annette Bening'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'American Beauty'), NULL, 'Carolyn Burnham');

-- El pianista (The Pianist)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Adrien Brody'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El pianista'), NULL, 'Wladyslaw Szpilman');

-- Atrapado en el tiempo (Groundhog Day)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Bill Murray'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Atrapado en el tiempo'), NULL, 'Phil Connors');

-- La máscara (The Mask)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jim Carrey'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'La máscara'), NULL, 'Stanley Ipkiss / The Mask');

-- Supersalidos (Superbad)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jonah Hill'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Supersalidos'), NULL, 'Seth');

-- El exorcista (The Exorcist)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ellen Burstyn'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El exorcista'), NULL, 'Chris MacNeil');

-- It
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Bill Skarsgård'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'It'), NULL, 'Pennywise / Eso');

-- Hereditary
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Toni Collette'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Hereditary'), NULL, 'Annie Graham');

-- Titanic
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Leonardo DiCaprio'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Titanic'), NULL, 'Jack Dawson'),
((SELECT id_actor FROM actor WHERE nombre = 'Kate Winslet'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Titanic'), NULL, 'Rose DeWitt Bukater');

-- La La Land
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ryan Gosling'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'La La Land'), NULL, 'Sebastian "Seb" Wilder'),
((SELECT id_actor FROM actor WHERE nombre = 'Emma Stone'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'La La Land'), NULL, 'Amelia "Mia" Dolan');

-- Amélie
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Audrey Tautou'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Amélie'), NULL, 'Amélie Poulain'),
((SELECT id_actor FROM actor WHERE nombre = 'Mathieu Kassovitz'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Amélie'), NULL, 'Nino Quincampoix');

-- La vida es bella
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Roberto Benigni'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'La vida es bella'), NULL, 'Guido Orefice');

-- Seven
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Brad Pitt'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Seven'), NULL, 'Detective David Mills'),
((SELECT id_actor FROM actor WHERE nombre = 'Morgan Freeman'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Seven'), NULL, 'Detective Lt. William Somerset'),
((SELECT id_actor FROM actor WHERE nombre = 'Gwyneth Paltrow'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Seven'), NULL, 'Tracy Mills');

-- Zodiac
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jake Gyllenhaal'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Zodiac'), NULL, 'Robert Graysmith'),
((SELECT id_actor FROM actor WHERE nombre = 'Robert Downey Jr.'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Zodiac'), NULL, 'Paul Avery');

-- Drive
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ryan Gosling'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Drive'), NULL, 'Driver'),
((SELECT id_actor FROM actor WHERE nombre = 'Carey Mulligan'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Drive'), NULL, 'Irene');

-- March of the Penguins
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Morgan Freeman'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'March of the Penguins'), NULL, 'Narrador');

-- Free Solo
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Alex Honnold'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Free Solo'), NULL, 'Himself');

-- Avatar (2009)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sam Worthington'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar'), NULL, 'Jake Sully'),
((SELECT id_actor FROM actor WHERE nombre = 'Zoe Saldaña'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar'), NULL, 'Neytiri'),
((SELECT id_actor FROM actor WHERE nombre = 'Stephen Lang'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar'), NULL, 'Coronel Miles Quaritch'),
((SELECT id_actor FROM actor WHERE nombre = 'Sigourney Weaver'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar'), NULL, 'Dra. Grace Augustine');

-- Avatar: El sentido del agua
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sam Worthington'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: El sentido del agua'), NULL, 'Jake Sully'),
((SELECT id_actor FROM actor WHERE nombre = 'Zoe Saldaña'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: El sentido del agua'), NULL, 'Neytiri'),
((SELECT id_actor FROM actor WHERE nombre = 'Sigourney Weaver'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: El sentido del agua'), NULL, 'Kiri'),
((SELECT id_actor FROM actor WHERE nombre = 'Stephen Lang'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: El sentido del agua'), NULL, 'Coronel Miles Quaritch');

-- Avatar: Fire and Ash
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sam Worthington'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: Fire and Ash'), NULL, 'Jake Sully'),
((SELECT id_actor FROM actor WHERE nombre = 'Zoe Saldaña'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: Fire and Ash'), NULL, 'Neytiri'),
((SELECT id_actor FROM actor WHERE nombre = 'Sigourney Weaver'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: Fire and Ash'), NULL, 'Kiri'),
((SELECT id_actor FROM actor WHERE nombre = 'Stephen Lang'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: Fire and Ash'), NULL, 'Coronel Miles Quaritch'),
((SELECT id_actor FROM actor WHERE nombre = 'Oona Chaplin'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Avatar: Fire and Ash'), NULL, 'Varang');

-- El señor de los anillos: La comunidad del anillo
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Elijah Wood'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Frodo Bolsón'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McKellen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Gandalf'),
((SELECT id_actor FROM actor WHERE nombre = 'Viggo Mortensen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Aragorn'),
((SELECT id_actor FROM actor WHERE nombre = 'Orlando Bloom'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Legolas'),
((SELECT id_actor FROM actor WHERE nombre = 'Sean Astin'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Samwise Gamyi'),
((SELECT id_actor FROM actor WHERE nombre = 'Cate Blanchett'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Galadriel'),
((SELECT id_actor FROM actor WHERE nombre = 'John Rhys-Davies'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: La comunidad del anillo'), NULL, 'Gimli');

-- El señor de los anillos: Las dos torres
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Elijah Wood'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Frodo Bolsón'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McKellen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Gandalf'),
((SELECT id_actor FROM actor WHERE nombre = 'Viggo Mortensen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Aragorn'),
((SELECT id_actor FROM actor WHERE nombre = 'Orlando Bloom'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Legolas'),
((SELECT id_actor FROM actor WHERE nombre = 'Sean Astin'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Samwise Gamyi'),
((SELECT id_actor FROM actor WHERE nombre = 'Cate Blanchett'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Galadriel'),
((SELECT id_actor FROM actor WHERE nombre = 'John Rhys-Davies'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: Las dos torres'), NULL, 'Gimli');

-- El señor de los anillos: El retorno del rey
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Elijah Wood'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Frodo Bolsón'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McKellen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Gandalf'),
((SELECT id_actor FROM actor WHERE nombre = 'Viggo Mortensen'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Aragorn'),
((SELECT id_actor FROM actor WHERE nombre = 'Orlando Bloom'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Legolas'),
((SELECT id_actor FROM actor WHERE nombre = 'Sean Astin'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Samwise Gamyi'),
((SELECT id_actor FROM actor WHERE nombre = 'Cate Blanchett'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Galadriel'),
((SELECT id_actor FROM actor WHERE nombre = 'John Rhys-Davies'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'El señor de los anillos: El retorno del rey'), NULL, 'Gimli');

-- Five Nights at Freddy's
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Josh Hutcherson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s'), NULL, 'Mike Schmidt'),
((SELECT id_actor FROM actor WHERE nombre = 'Elizabeth Lail'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s'), NULL, 'Vanessa Shelly'),
((SELECT id_actor FROM actor WHERE nombre = 'Matthew Lillard'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s'), NULL, 'Steve Raglan / William Afton');

-- Five Nights at Freddy's 2
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Josh Hutcherson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s 2'), NULL, 'Mike Schmidt'),
((SELECT id_actor FROM actor WHERE nombre = 'Elizabeth Lail'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s 2'), NULL, 'Vanessa Shelly'),
((SELECT id_actor FROM actor WHERE nombre = 'Matthew Lillard'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Five Nights at Freddy''s 2'), NULL, 'William Afton');

-- Star Wars: Una nueva esperanza
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mark Hamill'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Luke Skywalker'),
((SELECT id_actor FROM actor WHERE nombre = 'Carrie Fisher'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Princess Leia'),
((SELECT id_actor FROM actor WHERE nombre = 'Alec Guinness'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Obi-Wan Kenobi'),
((SELECT id_actor FROM actor WHERE nombre = 'Peter Mayhew'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Chewbacca'),
((SELECT id_actor FROM actor WHERE nombre = 'Anthony Daniels'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'C-3PO'),
((SELECT id_actor FROM actor WHERE nombre = 'David Prowse'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Darth Vader'),
((SELECT id_actor FROM actor WHERE nombre = 'Kenny Baker'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'R2-D2'),
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Han Solo');

-- Star Wars: El Imperio contraataca
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mark Hamill'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'Luke Skywalker'),
((SELECT id_actor FROM actor WHERE nombre = 'Carrie Fisher'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'Princess Leia'),
((SELECT id_actor FROM actor WHERE nombre = 'Alec Guinness'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'Obi-Wan Kenobi'),
((SELECT id_actor FROM actor WHERE nombre = 'Peter Mayhew'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'Chewbacca'),
((SELECT id_actor FROM actor WHERE nombre = 'Anthony Daniels'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'C-3PO'),
((SELECT id_actor FROM actor WHERE nombre = 'David Prowse'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'Darth Vader'),
((SELECT id_actor FROM actor WHERE nombre = 'Kenny Baker'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El Imperio contraataca'), NULL, 'R2-D2'),
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Han Solo');

-- Star Wars: El retorno del Jedi
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mark Hamill'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'Luke Skywalker'),
((SELECT id_actor FROM actor WHERE nombre = 'Carrie Fisher'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'Princess Leia'),
((SELECT id_actor FROM actor WHERE nombre = 'Alec Guinness'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'Obi-Wan Kenobi'),
((SELECT id_actor FROM actor WHERE nombre = 'Peter Mayhew'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'Chewbacca'),
((SELECT id_actor FROM actor WHERE nombre = 'Anthony Daniels'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'C-3PO'),
((SELECT id_actor FROM actor WHERE nombre = 'David Prowse'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'Darth Vader'),
((SELECT id_actor FROM actor WHERE nombre = 'Kenny Baker'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: El retorno del Jedi'), NULL, 'R2-D2'),
((SELECT id_actor FROM actor WHERE nombre = 'Harrison Ford'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Star Wars: Una nueva esperanza'), NULL, 'Han Solo');

-- Harry Potter y la piedra filosofal
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Daniel Radcliffe'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la piedra filosofal'), NULL, 'Harry Potter'),
((SELECT id_actor FROM actor WHERE nombre = 'Emma Watson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la piedra filosofal'), NULL, 'Hermione Granger'),
((SELECT id_actor FROM actor WHERE nombre = 'Rupert Grint'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la piedra filosofal'), NULL, 'Ron Weasley'),
((SELECT id_actor FROM actor WHERE nombre = 'Richard Harris'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la piedra filosofal'), NULL, 'Albus Dumbledore'),
((SELECT id_actor FROM actor WHERE nombre = 'Maggie Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la piedra filosofal'), NULL, 'Minerva McGonagall');

-- Harry Potter y la cámara secreta
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Daniel Radcliffe'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la cámara secreta'), NULL, 'Harry Potter'),
((SELECT id_actor FROM actor WHERE nombre = 'Emma Watson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la cámara secreta'), NULL, 'Hermione Granger'),
((SELECT id_actor FROM actor WHERE nombre = 'Rupert Grint'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la cámara secreta'), NULL, 'Ron Weasley'),
((SELECT id_actor FROM actor WHERE nombre = 'Richard Harris'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la cámara secreta'), NULL, 'Albus Dumbledore'),
((SELECT id_actor FROM actor WHERE nombre = 'Maggie Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y la cámara secreta'), NULL, 'Minerva McGonagall');

-- Harry Potter y el prisionero de Azkaban
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Daniel Radcliffe'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y el prisionero de Azkaban'), NULL, 'Harry Potter'),
((SELECT id_actor FROM actor WHERE nombre = 'Emma Watson'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y el prisionero de Azkaban'), NULL, 'Hermione Granger'),
((SELECT id_actor FROM actor WHERE nombre = 'Rupert Grint'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y el prisionero de Azkaban'), NULL, 'Ron Weasley'),
((SELECT id_actor FROM actor WHERE nombre = 'Maggie Smith'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'Harry Potter y el prisionero de Azkaban'), NULL, 'Minerva McGonagall');

-- John Wick
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keanu Reeves'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick'), NULL, 'John Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Michael Nyqvist'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick'), NULL, 'Viggo Tarasov'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McShane'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick'), NULL, 'Winston Scott'),
((SELECT id_actor FROM actor WHERE nombre = 'Bridget Moynahan'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick'), NULL, 'Holly Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Willem Dafoe'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick'), NULL, 'Marcus');

-- John Wick: Capítulo 2
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keanu Reeves'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 2'), NULL, 'John Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McShane'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 2'), NULL, 'Winston Scott'),
((SELECT id_actor FROM actor WHERE nombre = 'Bridget Moynahan'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 2'), NULL, 'Holly Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Tait Fletcher'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 2'), NULL, 'Bassani');

-- John Wick: Capítulo 3 – Parabellum
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keanu Reeves'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 3 – Parabellum'), NULL, 'John Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McShane'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 3 – Parabellum'), NULL, 'Winston Scott'),
((SELECT id_actor FROM actor WHERE nombre = 'Lance Reddick'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 3 – Parabellum'), NULL, 'Charon'),
((SELECT id_actor FROM actor WHERE nombre = 'Halle Berry'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 3 – Parabellum'), NULL, 'Sofia'),
((SELECT id_actor FROM actor WHERE nombre = 'Laurence Fishburne'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 3 – Parabellum'), NULL, 'Bowery King');

-- John Wick: Capítulo 4
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Keanu Reeves'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 4'), NULL, 'John Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Ian McShane'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 4'), NULL, 'Winston Scott'),
((SELECT id_actor FROM actor WHERE nombre = 'Lance Reddick'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 4'), NULL, 'Charon'),
((SELECT id_actor FROM actor WHERE nombre = 'Bridget Moynahan'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 4'), NULL, 'Holly Wick'),
((SELECT id_actor FROM actor WHERE nombre = 'Bill Skarsgård'), (SELECT id_pelicula FROM pelicula WHERE titulo = 'John Wick: Capítulo 4'), NULL, 'Marquis Vincent Bisset de Gramont');

-- Stranger Things
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Finn Wolfhard'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Stranger Things'), 'Mike Wheeler'),
((SELECT id_actor FROM actor WHERE nombre = 'Gaten Matarazzo'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Stranger Things'), 'Dustin Henderson'),
((SELECT id_actor FROM actor WHERE nombre = 'Noah Schnapp'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Stranger Things'), 'Will Byers');

-- Black Mirror
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Daniel Kaluuya'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Mirror'), 'Bingham "Black Dog" Madsen'),
((SELECT id_actor FROM actor WHERE nombre = 'Paul Giamatti'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Mirror'), 'Elliot'),
((SELECT id_actor FROM actor WHERE nombre = 'Rashida Jones'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Mirror'), 'Nurse');

-- Cobra Kai
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ralph Macchio'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Cobra Kai'), 'Daniel LaRusso'),
((SELECT id_actor FROM actor WHERE nombre = 'William Zabka'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Cobra Kai'), 'Johnny Lawrence'),
((SELECT id_actor FROM actor WHERE nombre = 'Mary Mouser'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Cobra Kai'), 'Sam LaRusso');

-- Sex Education
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Asa Butterfield'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sex Education'), 'Otis Milburn'),
((SELECT id_actor FROM actor WHERE nombre = 'Emma Mackey'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sex Education'), 'Maeve Wiley'),
((SELECT id_actor FROM actor WHERE nombre = 'Ncuti Gatwa'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sex Education'), 'Eric Effiong');

-- Heartstopper
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kit Connor'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Heartstopper'), 'Nick Nelson'),
((SELECT id_actor FROM actor WHERE nombre = 'Joe Locke'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Heartstopper'), 'Charlie Spring');

-- Pluribus
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Corey Stoll'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Pluribus'), 'David'),
((SELECT id_actor FROM actor WHERE nombre = 'Jennifer Connelly'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Pluribus'), 'Eva');

-- Tabú
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Tom Hardy'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Tabú'), 'James Keziah Delaney'),
((SELECT id_actor FROM actor WHERE nombre = 'Oona Chaplin'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Tabú'), 'Zilpha Geary');

-- One Piece (live-action)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Iñaki Godoy'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'One Piece'), 'Monkey D. Luffy'),
((SELECT id_actor FROM actor WHERE nombre = 'Mackenyu'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'One Piece'), 'Roronoa Zoro'),
((SELECT id_actor FROM actor WHERE nombre = 'Emily Rudd'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'One Piece'), 'Nami');

-- Arcane: League of Legends
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Hailee Steinfeld'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Arcane: League of Legends'), 'Vi'),
((SELECT id_actor FROM actor WHERE nombre = 'Kevin Alejandro'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Arcane: League of Legends'), 'Caitlyn Kiramman'),
((SELECT id_actor FROM actor WHERE nombre = 'Toks Olagundoye'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Arcane: League of Legends'), 'Mel Medarda');

-- La noche más larga
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Luis Callejo'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La noche más larga'), 'Antonio'),
((SELECT id_actor FROM actor WHERE nombre = 'Alberto Ammann'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La noche más larga'), 'Carlos'),
((SELECT id_actor FROM actor WHERE nombre = 'Bárbara Goenaga'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La noche más larga'), 'Marta');

-- The Bear
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jeremy Allen White'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Bear'), 'Carmy Berzatto'),
((SELECT id_actor FROM actor WHERE nombre = 'Ayo Edebiri'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Bear'), 'Sydney Adamu'),
((SELECT id_actor FROM actor WHERE nombre = 'Ebon Moss-Bachrach'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Bear'), 'Richie Jerimovich'),
((SELECT id_actor FROM actor WHERE nombre = 'Lionel Boyce'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Bear'), 'Marcus'),
((SELECT id_actor FROM actor WHERE nombre = 'Liza Colón-Zayas'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Bear'), 'Tina Marrero');

-- Alien: Earth
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sydney Chandler'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Alien: Earth'), 'Wendy'),
((SELECT id_actor FROM actor WHERE nombre = 'Alex Lawther'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Alien: Earth'), 'CJ “Hermit”'),
((SELECT id_actor FROM actor WHERE nombre = 'Timothy Olyphant'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Alien: Earth'), 'Kirsh'),
((SELECT id_actor FROM actor WHERE nombre = 'Essie Davis'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Alien: Earth'), 'Dame Sylvia');

-- Dune: The Sisterhood
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Emily Watson'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dune: The Sisterhood'), 'Valya Harkonnen'),
((SELECT id_actor FROM actor WHERE nombre = 'Jessica Barden'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dune: The Sisterhood'), 'Young Valya Harkonnen'),
((SELECT id_actor FROM actor WHERE nombre = 'Travis Fimmel'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dune: The Sisterhood'), 'Desmond Hart');

-- House of the Dragon
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Emma D’Arcy'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'House of the Dragon'), 'Rhaenyra Targaryen'),
((SELECT id_actor FROM actor WHERE nombre = 'Matt Smith'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'House of the Dragon'), 'Daemon Targaryen'),
((SELECT id_actor FROM actor WHERE nombre = 'Rhys Ifans'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'House of the Dragon'), 'Ser Otto Hightower');

-- The Last of Us
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Pedro Pascal'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Last of Us'), 'Joel Miller'),
((SELECT id_actor FROM actor WHERE nombre = 'Bella Ramsey'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Last of Us'), 'Ellie Williams');

-- Chernobyl: Aftermath (usando reparto de la miniserie original 'Chernobyl')
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jared Harris'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Chernobyl: Aftermath'), 'Valeri Legásov'),
((SELECT id_actor FROM actor WHERE nombre = 'Stellan Skarsgård'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Chernobyl: Aftermath'), 'Boris Shcherbina'),
((SELECT id_actor FROM actor WHERE nombre = 'Emily Watson'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Chernobyl: Aftermath'), 'Uliana Khomyuk');

-- Mozart in the Jungle
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Gael García Bernal'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Mozart in the Jungle'), 'Rodrigo De Souza'),
((SELECT id_actor FROM actor WHERE nombre = 'Saffron Burrows'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Mozart in the Jungle'), 'Cynthia');

-- Black Sails
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Toby Stephens'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Sails'), 'Captain James Flint'),
((SELECT id_actor FROM actor WHERE nombre = 'Hannah New'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Sails'), 'Eleanor Guthrie'),
((SELECT id_actor FROM actor WHERE nombre = 'Luke Arnold'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Black Sails'), 'Long John Silver');

-- Narcos
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Wagner Moura'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Narcos'), 'Pablo Escobar'),
((SELECT id_actor FROM actor WHERE nombre = 'Pedro Pascal'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Narcos'), 'Javier Peña'),
((SELECT id_actor FROM actor WHERE nombre = 'Boyd Holbrook'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Narcos'), 'Steve Murphy');

-- Lupin
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Omar Sy'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Lupin'), 'Assane Diop'),
((SELECT id_actor FROM actor WHERE nombre = 'Ludivine Sagnier'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Lupin'), 'Claire Laurent');

-- Bridgerton
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Phoebe Dynevor'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bridgerton'), 'Daphne Bridgerton'),
((SELECT id_actor FROM actor WHERE nombre = 'Regé-Jean Page'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bridgerton'), 'Simon Basset, Duke of Hastings');

-- The Witcher
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Henry Cavill'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Witcher'), 'Geralt of Rivia'),
((SELECT id_actor FROM actor WHERE nombre = 'Anya Chalotra'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Witcher'), 'Yennefer of Vengerberg');

-- Rick and Morty
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Justin Roiland'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Rick and Morty'), 'Rick Sanchez (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Sarah Chalke'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Rick and Morty'), 'Beth Smith (voz)');

-- Friends Reunion
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jennifer Aniston'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Friends Reunion'), 'Herself'),
((SELECT id_actor FROM actor WHERE nombre = 'Courteney Cox'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Friends Reunion'), 'Herself');

-- Vikings: Valhalla
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Sam Corlett'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Vikingos: Valhalla'), 'Harald Sigurdsson'),
((SELECT id_actor FROM actor WHERE nombre = 'Frida Gustavsson'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Vikingos: Valhalla'), 'Freydís Eiríksdóttir'),
((SELECT id_actor FROM actor WHERE nombre = 'Leo Suter'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Vikingos: Valhalla'), 'Otto');

-- Mindhunter
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jonathan Groff'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Mindhunter'), 'Holden Ford'),
((SELECT id_actor FROM actor WHERE nombre = 'Holt McCallany'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Mindhunter'), 'Bill Tench');

-- Modern Family
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ed ONeill'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Modern Family'), 'Jay Pritchett'),
((SELECT id_actor FROM actor WHERE nombre = 'Sofía Vergara'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Modern Family'), 'Gloria Delgado-Pritchett'),
((SELECT id_actor FROM actor WHERE nombre = 'Julie Bowen'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Modern Family'), 'Claire Dunphy');

-- La Casa de Papel
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Álvaro Morte'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La Casa de Papel'), 'El Profesor'),
((SELECT id_actor FROM actor WHERE nombre = 'Úrsula Corberó'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La Casa de Papel'), 'Tokio'),
((SELECT id_actor FROM actor WHERE nombre = 'Itziar Ituño'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'La Casa de Papel'), 'Lisboa');

-- Attack on Titan
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Yuki Kaji'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Attack on Titan'), 'Eren Yeager (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Yui Ishikawa'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Attack on Titan'), 'Mikasa Ackerman (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Marina Inoue'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Attack on Titan'), 'Armin Arlert (voz)');

-- Death Note
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mamoru Miyano'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Death Note'), 'Light Yagami (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Kappei Yamaguchi'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Death Note'), 'L (voz)');

-- Fullmetal Alchemist: Brotherhood
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Romi Park'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Fullmetal Alchemist: Brotherhood'), 'Edward Elric (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Maxey Whitehead'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Fullmetal Alchemist: Brotherhood'), 'Alphonse Elric (voz)');

-- Demon Slayer
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Natsuki Hanae'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Demon Slayer'), 'Tanjiro Kamado (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Zach Aguilar'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Demon Slayer'), 'Tanjiro Kamado (voz – inglés)');

-- One Punch Man
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Max Mittelman'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'One Punch Man'), 'Saitama (voz)');

-- Los Simpson
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Dan Castellaneta'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 'Homer Simpson (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Julie Kavner'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 'Marge Simpson (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Nancy Cartwright'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Los Simpson'), 'Bart Simpson (voz)');

-- Futurama
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Billy West'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Futurama'), 'Philip J. Fry (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Katey Sagal'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Futurama'), 'Turanga Leela (voz)');

-- Bojack Horseman
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Will Arnett'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bojack Horseman'), 'Bojack Horseman (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Aaron Paul'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bojack Horseman'), 'Todd Chavez (voz)');

-- South Park
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Trey Parker'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'South Park'), 'Stan Marsh (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Matt Stone'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'South Park'), 'Kyle Broflovski (voz)');

-- Better Call Saul
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Bob Odenkirk'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Better Call Saul'), 'Jimmy McGill / Saul Goodman'),
((SELECT id_actor FROM actor WHERE nombre = 'Rhea Seehorn'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Better Call Saul'), 'Kim Wexler');

-- True Detective (asumiendo temporada 1 como referencia)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Matthew McConaughey'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'True Detective'), 'Detective Rust Cohle'),
((SELECT id_actor FROM actor WHERE nombre = 'Woody Harrelson'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'True Detective'), 'Detective Marty Hart');

-- Band of Brothers
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Damian Lewis'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Band of Brothers'), 'Richard Winters'),
((SELECT id_actor FROM actor WHERE nombre = 'Ron Livingston'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Band of Brothers'), 'Lewis Nixon');

-- The Boys
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Karl Urban'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Boys'), 'Billy Butcher'),
((SELECT id_actor FROM actor WHERE nombre = 'Jack Quaid'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Boys'), 'Hughie Campbell');

-- Andor
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Diego Luna'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Andor'), 'Cassian Andor'),
((SELECT id_actor FROM actor WHERE nombre = 'Stellan Skarsgård'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Andor'), 'Luthen Rael');

-- Westworld
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Evan Rachel Wood'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Westworld'), 'Dolores Abernathy'),
((SELECT id_actor FROM actor WHERE nombre = 'Jeffrey Wright'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Westworld'), 'Bernard Lowe');

-- Haikyuu!! (voz de anime)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ayumu Murase'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Haikyuu!!'), 'Shōyō Hinata (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Kaito Ishikawa'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Haikyuu!!'), 'Tobio Kageyama (voz)');

-- Naruto (voz de anime)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Junko Takeuchi'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Naruto'), 'Naruto Uzumaki (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Maile Flanagan'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Naruto'), 'Naruto Uzumaki (voz — inglés)');

-- Naruto Shippuden (voz de anime)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kazuhiko Inoue'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Naruto Shippuden'), 'Kakashi Hatake (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Kate Higgins'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Naruto Shippuden'), 'Sakura Haruno (voz — inglés)');

-- Dragon Ball
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Masako Nozawa'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball'), 'Goku (voz — japonés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Sean Schemmel'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball'), 'Goku (voz — inglés)');

-- Dragon Ball Z
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Christopher Sabat'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball Z'), 'Vegeta (voz — inglés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Kyle Hebert'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball Z'), 'Gohan adulto (voz — inglés)');

-- Dragon Ball Super
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ian Sinclair'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball Super'), 'Goku Black (voz — inglés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Colleen Clinkenbeard'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball Super'), 'Android 18 (voz — inglés)');

-- My Hero Academia
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Justin Briner'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'My Hero Academia'), 'Izuku Midoriya (voz — inglés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Christopher Sabat'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'My Hero Academia'), 'All Might (voz — inglés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Monica Rial'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'My Hero Academia'), 'Tsuyu Asui (voz — inglés)');

-- Jujutsu Kaisen
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Yūichi Nakamura'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Jujutsu Kaisen'), 'Satoru Gojo (voz — japonés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Jun’ichi Suwabe'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Jujutsu Kaisen'), 'Ryomen Sukuna (voz — japonés)');

-- Tokyo Ghoul
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mamoru Miyano'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Tokyo Ghoul'), 'Ken Kaneki (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Sōma Saitō'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Tokyo Ghoul'), 'Tōru Mutsuki (voz)');

-- Bleach
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Jun’ichi Suwabe'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bleach'), 'Byakuya Kuchiki (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Shō Hayami'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Bleach'), 'Sōsuke Aizen (voz)');

-- Sword Art Online
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Haruka Tomatsu'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sword Art Online'), 'Asuna Yuuki (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Yoshitsugu Matsuoka'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sword Art Online'), 'Kirito (voz)');

-- Neon Genesis Evangelion
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Megumi Ogata'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Neon Genesis Evangelion'), 'Shinji Ikari (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Kotono Mitsuishi'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Neon Genesis Evangelion'), 'Misato Katsuragi (voz)');

-- Cowboy Bebop
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kôichi Yamadera'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Cowboy Bebop'), 'Spike Spiegel (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Unshō Ishizuka'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Cowboy Bebop'), 'Jet Black (voz)');

-- Steins;Gate
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Mamoru Miyano'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Steins;Gate'), 'Rintarou Okabe (voz)'),
((SELECT id_actor FROM actor WHERE nombre = 'Asami Imai'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Steins;Gate'), 'Kurisu Makise (voz)');

-- Juego de Tronos
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kit Harington'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Juego de Tronos'), 'Jon Snow'),
((SELECT id_actor FROM actor WHERE nombre = 'Emilia Clarke'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Juego de Tronos'), 'Daenerys Targaryen'),
((SELECT id_actor FROM actor WHERE nombre = 'Peter Dinklage'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Juego de Tronos'), 'Tyrion Lannister');

-- Lost
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Matthew Fox'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Lost'), 'Jack Shephard'),
((SELECT id_actor FROM actor WHERE nombre = 'Evangeline Lilly'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Lost'), 'Kate Austen'),
((SELECT id_actor FROM actor WHERE nombre = 'Terry O’Quinn'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Lost'), 'John Locke');

-- Breaking Bad
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Bryan Cranston'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Breaking Bad'), 'Walter White'),
((SELECT id_actor FROM actor WHERE nombre = 'Aaron Paul'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Breaking Bad'), 'Jesse Pinkman'),
((SELECT id_actor FROM actor WHERE nombre = 'Anna Gunn'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Breaking Bad'), 'Skyler White');

-- Peaky Blinders
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Cillian Murphy'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Peaky Blinders'), 'Tommy Shelby'),
((SELECT id_actor FROM actor WHERE nombre = 'Helen McCrory'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Peaky Blinders'), 'Polly Gray');

-- The Office (US)
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Steve Carell'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Office (US)'), 'Michael Scott'),
((SELECT id_actor FROM actor WHERE nombre = 'John Krasinski'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Office (US)'), 'Jim Halpert'),
((SELECT id_actor FROM actor WHERE nombre = 'Jenna Fischer'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Office (US)'), 'Pam Beesly');

-- Dark
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Louis Hofmann'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dark'), 'Jonas Kahnwald'),
((SELECT id_actor FROM actor WHERE nombre = 'Lisa Vicari'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dark'), 'Martha Nielsen');

-- The Walking Dead
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Andrew Lincoln'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Walking Dead'), 'Rick Grimes'),
((SELECT id_actor FROM actor WHERE nombre = 'Norman Reedus'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Walking Dead'), 'Daryl Dixon'),
((SELECT id_actor FROM actor WHERE nombre = 'Melissa McBride'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'The Walking Dead'), 'Carol Peletier');

-- Dragon Ball GT
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Masako Nozawa'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball GT'), 'Goku (voz — japonés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Rica Matsumoto'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Dragon Ball GT'), 'Goku niño (voz — japonés)');

-- Pokémon
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Ikue Ōtani'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Pokémon'), 'Pikachu (voz — japonés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Veronica Taylor'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Pokémon'), 'Ash Ketchum (voz — inglés)');

-- Sailor Moon
INSERT INTO reparto (id_actor, id_pelicula, id_serie, personaje) VALUES
((SELECT id_actor FROM actor WHERE nombre = 'Kotono Mitsuishi'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sailor Moon'), 'Usagi Tsukino / Sailor Moon (voz — japonés)'),
((SELECT id_actor FROM actor WHERE nombre = 'Ayane Sakura'), NULL, (SELECT id_serie FROM serie WHERE titulo = 'Sailor Moon'), 'Rei Hino / Sailor Mars (voz — japonés)');

/* =====================================================
   USUARIOS
   ===================================================== */

INSERT INTO usuario (email, nombre_usuario, nombre, apellido, fecha_nacimiento, fecha_registro, pais) VALUES
('lucas.martin@mail.com','lucas_stream','Lucas','Martín','1992-03-14','2016-05-21','España'),
('anna.keller@mail.com','annak_view','Anna','Keller','1989-11-02','2017-09-13','Alemania'),
('john.reed@mail.com','johnreed87','John','Reed','1987-06-08','2015-02-19','Estados Unidos'),
('marie.dubois@mail.com','mariedbx','Marie','Dubois','1994-01-22','2018-11-30','Francia'),
('paolo.rossi@mail.com','paolor_tv','Paolo','Rossi','1985-07-19','2016-08-04','Italia'),
('sofia.nilsson@mail.com','sofia_nls','Sofia','Nilsson','1996-05-11','2019-01-15','Suecia'),
('daniel.brown@mail.com','danbrown_tv','Daniel','Brown','1990-09-03','2017-06-27','Reino Unido'),
('laura.gomez@mail.com','laurag_stream','Laura','Gómez','1998-12-18','2020-04-09','España'),
('michael.chen@mail.com','mchen_view','Michael','Chen','1984-04-25','2015-10-01','Canadá'),
('yuki.tanaka@mail.com','yuki_watch','Yuki','Tanaka','1993-08-30','2018-03-17','Japón'),

('carlos.mendez@mail.com','carlosmx','Carlos','Méndez','1986-02-10','2016-12-22','México'),
('irene.papad@mail.com','irene_pap','Irene','Papadopoulos','1991-06-05','2019-07-11','Grecia'),
('tom.hughes@mail.com','tom_h_view','Tom','Hughes','1988-10-28','2017-01-08','Reino Unido'),
('nadia.ali@mail.com','nadia_stream','Nadia','Ali','1995-04-17','2021-05-19','Emiratos Árabes Unidos'),
('alex.popescu@mail.com','alex_ro','Alex','Popescu','1992-09-09','2018-10-02','Rumanía'),
('bruno.silva@mail.com','bruno_br','Bruno','Silva','1987-01-14','2016-06-18','Brasil'),
('emma.wilson@mail.com','emma_wtv','Emma','Wilson','1999-07-21','2022-03-05','Estados Unidos'),
('leo.kovac@mail.com','leo_kv','Leo','Kovač','1994-11-06','2019-09-27','Croacia'),
('fatima.el@mail.com','fatima_view','Fátima','El Amrani','1990-05-29','2017-04-14','Marruecos'),
('oscar.lopez@mail.com','oscarflix','Óscar','López','1983-12-01','2015-11-20','España'),

('hanna.mueller@mail.com','hmueller_tv','Hanna','Müller','1997-02-24','2020-08-16','Alemania'),
('victor.petrov@mail.com','vpetrov','Victor','Petrov','1989-06-13','2016-03-09','Bulgaria'),
('sarah.connor@mail.com','sconnor_tv','Sarah','Connor','1992-10-10','2018-02-01','Estados Unidos'),
('diego.ferrer@mail.com','diego_frr','Diego','Ferrer','1985-03-07','2015-07-23','Argentina'),
('mina.choi@mail.com','mina_view','Mina','Choi','1996-09-18','2021-11-12','Corea del Sur'),
('oliver.jones@mail.com','ojones_stream','Oliver','Jones','1991-01-05','2017-05-28','Australia'),
('ines.santos@mail.com','ines_snt','Inés','Santos','1998-04-26','2022-06-30','Portugal'),
('henrik.lars@mail.com','hlars_tv','Henrik','Larsson','1984-08-02','2016-09-15','Suecia'),
('martina.bianchi@mail.com','marti_b','Martina','Bianchi','1995-12-09','2019-12-03','Italia'),
('kevin.obrien@mail.com','kobrien','Kevin','OBrien','1987-07-27','2015-01-17','Irlanda'),

('lina.hassan@mail.com','lina_hs','Lina','Hassan','1993-03-11','2018-08-08','Egipto'),
('robert.king@mail.com','rking_tv','Robert','King','1982-11-19','2015-06-02','Estados Unidos'),
('julien.moreau@mail.com','jmoreau','Julien','Moreau','1990-05-06','2017-10-19','Francia'),
('sven.jorg@mail.com','sven_j','Sven','Jørgensen','1986-01-30','2016-04-25','Dinamarca'),
('ana.petrova@mail.com','apetrova','Ana','Petrova','1994-09-14','2020-02-20','Serbia'),
('li.wei@mail.com','liwei_tv','Li','Wei','1988-06-01','2015-12-10','China'),
('camilo.rojos@mail.com','camirojo','Camilo','Rojos','1997-02-28','2021-09-01','Chile'),
('markus.fischer@mail.com','mfischer','Markus','Fischer','1985-10-16','2016-11-05','Austria'),
('nora.holm@mail.com','noraholm','Nora','Holm','1992-07-04','2018-05-26','Noruega'),
('ivan.smirnov@mail.com','ivan_sm','Iván','Smirnov','1989-12-22','2017-03-14','Rusia'),

('paulina.kow@mail.com','pauli_k','Paulina','Kowalska','1996-04-08','2020-07-07','Polonia'),
('andrew.scott@mail.com','ascott_tv','Andrew','Scott','1983-02-03','2015-08-29','Reino Unido'),
('lucie.martin@mail.com','luciem','Lucie','Martin','1999-11-25','2023-01-10','Francia'),
('mateo.garcia@mail.com','mateogc','Mateo','García','1991-06-17','2018-06-12','Colombia'),
('sandra.nowak@mail.com','snowak','Sandra','Nowak','1987-09-05','2016-10-18','Alemania'),
('jonas.berg@mail.com','jonasbg','Jonas','Berg','1994-01-09','2019-04-03','Islandia');

INSERT INTO usuario (email, nombre_usuario, nombre, apellido, fecha_nacimiento, fecha_registro, pais) VALUES
('lucia.mora@mail.com','lucia_mora','Lucía','Mora','1994-03-12','2016-05-18','España'),
('daniel.ross@mail.com','danross','Daniel','Ross','1988-11-04','2017-02-10','Estados Unidos'),
('irene.pastor@mail.com','irenep','Irene','Pastor','1996-07-21','2018-09-03','España'),
('marco.bianchi@mail.com','marcobianchi','Marco','Bianchi','1985-01-19','2015-11-27','Italia'),
('sophie.dupont@mail.com','sophie_d','Sophie','Dupont','1992-04-30','2019-06-14','Francia'),
('alex.morales@mail.com','alexm_92','Alex','Morales','1992-08-16','2020-01-09','México'),
('laura.king@mail.com','lauraking','Laura','King','1989-02-05','2016-10-22','Reino Unido'),
('peter.schmidt@mail.com','petersch','Peter','Schmidt','1983-12-01','2015-03-30','Alemania'),
('valentina.rios@mail.com','valerios','Valentina','Ríos','1998-05-25','2021-07-11','Argentina'),
('jonas.nilsson@mail.com','jonasn','Jonas','Nilsson','1990-09-14','2017-12-19','Suecia'),

('andrea.conti@mail.com','andreaconti','Andrea','Conti','1987-06-08','2018-04-02','Italia'),
('miguel.soto@mail.com','miguelsoto','Miguel','Soto','1995-10-10','2022-02-18','Chile'),
('natalie.green@mail.com','natgreen','Natalie','Green','1991-01-27','2016-08-07','Canadá'),
('diego.farias@mail.com','diegof','Diego','Farías','1986-03-09','2015-09-15','Portugal'),
('emma.larsson@mail.com','emmal','Emma','Larsson','1999-07-03','2023-05-20','Noruega'),
('raul.mendez@mail.com','raulm','Raúl','Méndez','1984-11-22','2016-01-13','España'),
('kevin.brooks@mail.com','kevinb','Kevin','Brooks','1993-06-17','2019-11-04','Estados Unidos'),
('paula.santos@mail.com','paulas','Paula','Santos','1997-04-11','2020-06-30','Brasil'),
('tomas.kovac@mail.com','tomask','Tomás','Kovač','1989-02-14','2018-09-25','Croacia'),
('hannah.miller@mail.com','hmiller','Hannah','Miller','1994-12-06','2021-03-08','Estados Unidos'),

('sergio.lozano@mail.com','sergiol','Sergio','Lozano','1982-05-29','2015-07-01','España'),
('anna.novak@mail.com','annan','Anna','Novak','1996-09-18','2019-02-12','Polonia'),
('julien.morel@mail.com','jmorel','Julien','Morel','1988-08-23','2017-05-09','Francia'),
('lucas.ferreira@mail.com','lucasf','Lucas','Ferreira','1992-01-31','2016-12-21','Brasil'),
('isabel.castro@mail.com','isacastro','Isabel','Castro','1985-10-02','2015-06-16','España'),
('noah.wilson@mail.com','noahw','Noah','Wilson','2000-04-27','2024-01-05','Estados Unidos'),
('camila.rojas@mail.com','camirojas','Camila','Rojas','1999-07-19','2023-09-14','Colombia'),
('marko.petrovic@mail.com','markop','Marko','Petrović','1987-03-03','2018-10-28','Serbia'),
('olga.ivanova@mail.com','olgaiv','Olga','Ivanova','1991-06-15','2017-01-17','Rusia'),
('samuel.lee@mail.com','samlee','Samuel','Lee','1984-12-09','2016-04-06','Corea del Sur'),

('patricia.duran@mail.com','patduran','Patricia','Durán','1993-02-26','2019-07-22','España'),
('leo.martins@mail.com','leomartins','Leonardo','Martins','1986-05-18','2015-08-29','Brasil'),
('sofia.keller@mail.com','sofiak','Sofía','Keller','1998-11-11','2022-06-01','Suiza'),
('adrian.popescu@mail.com','adrianp','Adrián','Popescu','1989-09-05','2018-03-19','Rumanía'),
('monica.hernandez@mail.com','moniher','Mónica','Hernández','1994-01-08','2020-10-10','México'),
('felix.meyer@mail.com','felixm','Félix','Meyer','1981-07-24','2015-02-08','Alemania'),
('irina.kuznetsova@mail.com','irinak','Irina','Kuznetsova','1996-04-02','2021-11-30','Ucrania'),
('danilo.silva@mail.com','danilos','Danilo','Silva','1990-06-27','2017-08-16','Brasil'),
('victor.ortega@mail.com','victorort','Víctor','Ortega','1983-03-15','2016-09-05','España'),
('amelie.bernard@mail.com','amelieb','Amélie','Bernard','1997-12-20','2024-04-18','Francia');

INSERT INTO usuario (email, nombre_usuario, nombre, apellido, fecha_nacimiento, fecha_registro, pais) VALUES
('alberto.m@mail.com','alberto_dev','Alberto','Moreno','1986-03-12','2016-05-21','España'),
('lucia.rom@mail.com','lucia_rom','Lucía','Romero','1992-07-18','2017-09-03','España'),
('thomas.k@mail.com','thomas_k','Thomas','Klein','1984-11-02','2015-02-14','Alemania'),
('emma.l@mail.com','emma_london','Emma','Lewis','1990-04-25','2018-06-30','Reino Unido'),
('marco.r@mail.com','marco_roma','Marco','Rossi','1988-09-10','2019-01-11','Italia'),
('julien.d@mail.com','julien_paris','Julien','Dubois','1995-12-05','2020-03-19','Francia'),
('sofia.p@mail.com','sofia_porto','Sofía','Pereira','1993-06-08','2017-08-22','Portugal'),
('andreas.s@mail.com','andreas_swe','Andreas','Svensson','1981-01-30','2016-10-09','Suecia'),
('nina.h@mail.com','nina_helsinki','Nina','Korhonen','1996-05-14','2021-04-27','Finlandia'),
('peter.v@mail.com','peter_nl','Peter','Van Dijk','1985-02-19','2015-11-06','Países Bajos'),

('anna.k@mail.com','anna_krakow','Anna','Kowalska','1991-07-21','2018-02-17','Polonia'),
('matej.n@mail.com','matej_prg','Matej','Novak','1987-10-11','2019-06-05','República Checa'),
('ivan.p@mail.com','ivan_bg','Ivan','Petrov','1983-08-03','2016-09-18','Bulgaria'),
('elena.i@mail.com','elena_ro','Elena','Ionescu','1994-01-27','2020-12-01','Rumanía'),
('nikos.g@mail.com','nikos_gr','Nikos','Georgiou','1989-04-09','2017-07-13','Grecia'),
('kemal.y@mail.com','kemal_tr','Kemal','Yilmaz','1982-06-16','2015-03-28','Turquía'),
('olga.s@mail.com','olga_ru','Olga','Smirnova','1990-09-04','2018-11-20','Rusia'),
('yuki.t@mail.com','yuki_tokyo','Yuki','Tanaka','1997-12-12','2022-05-07','Japón'),
('min.j@mail.com','min_seoul','Min','Jung','1995-02-06','2021-09-15','Corea del Sur'),
('li.w@mail.com','li_shanghai','Li','Wang','1986-07-29','2016-04-02','China'),

('carlos.m@mail.com','carlos_mx','Carlos','Mendoza','1988-11-18','2017-01-24','México'),
('ana.s@mail.com','ana_ar','Ana','Suárez','1993-03-07','2019-08-10','Argentina'),
('rodrigo.f@mail.com','rodrigo_cl','Rodrigo','Fuentes','1985-05-22','2016-12-19','Chile'),
('lucas.b@mail.com','lucas_br','Lucas','Barbosa','1992-09-01','2020-06-14','Brasil'),
('diego.p@mail.com','diego_pe','Diego','Paredes','1990-04-17','2018-03-05','Perú'),
('jose.c@mail.com','jose_co','José','Cárdenas','1987-08-26','2017-10-30','Colombia'),
('andres.m@mail.com','andres_uy','Andrés','Martínez','1994-12-09','2021-02-18','Uruguay'),
('maria.v@mail.com','maria_ve','María','Vargas','1989-06-02','2016-07-11','Venezuela'),
('paula.e@mail.com','paula_ec','Paula','Espinoza','1996-01-15','2022-11-04','Ecuador'),
('luis.b@mail.com','luis_bo','Luis','Bautista','1984-10-28','2015-08-23','Bolivia'),

('john.m@mail.com','john_usa','John','Miller','1982-02-14','2015-01-09','Estados Unidos'),
('sarah.w@mail.com','sarah_ca','Sarah','Wilson','1991-05-30','2018-04-26','Canadá'),
('michael.o@mail.com','michael_ie','Michael','OConnor','1987-09-19','2017-06-01','Irlanda'),
('liam.m@mail.com','liam_nz','Liam','McKenzie','1993-07-07','2020-09-12','Nueva Zelanda'),
('oliver.b@mail.com','oliver_au','Oliver','Brown','1985-03-25','2016-02-08','Australia'),
('noah.s@mail.com','noah_sa','Noah','Stein','1998-11-03','2023-01-19','Israel'),
('amir.k@mail.com','amir_uae','Amir','Khan','1990-04-01','2019-05-16','Emiratos Árabes Unidos'),
('farah.a@mail.com','farah_ma','Farah','Alami','1994-08-20','2021-07-28','Marruecos'),
('sami.h@mail.com','sami_tn','Sami','Haddad','1986-12-31','2016-10-05','Túnez'),
('leila.b@mail.com','leila_eg','Leila','Bakr','1992-06-11','2018-12-22','Egipto');

/* =====================================================
   VISUALIZACION
   ===================================================== */

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(1,  1,   NULL, '2015-02-14 21:05:00', '2015-02-14 23:02:00', 'TV'),
(1,  NULL, 12,  '2016-10-03 19:40:00', '2016-10-03 20:28:00', 'Laptop'),
(2,  7,   NULL, '2017-06-22 22:10:00', NULL,                 'Mobile'),
(2,  NULL, 45,  '2018-01-09 18:15:00', '2018-01-09 18:58:00', 'Tablet'),
(3,  12,  NULL, '2019-11-30 20:00:00', '2019-11-30 22:06:00', 'TV'),
(3,  NULL, 101, '2020-03-12 23:05:00', NULL,                 'Laptop'),
(4,  25,  NULL, '2021-08-07 16:30:00', '2021-08-07 18:05:00', 'Desktop'),
(4,  NULL, 9,   '2021-08-08 17:10:00', '2021-08-08 18:00:00', 'SmartTV'),
(5,  33,  NULL, '2022-12-24 21:50:00', '2022-12-24 23:55:00', 'TV'),
(5,  NULL, 210, '2023-01-02 20:20:00', '2023-01-02 21:05:00', 'Mobile'),

(6,  41,  NULL, '2015-07-19 19:00:00', '2015-07-19 21:55:00', 'Laptop'),
(6,  NULL, 333, '2016-05-28 22:15:00', NULL,                 'Tablet'),
(7,  2,   NULL, '2017-09-03 18:40:00', '2017-09-03 20:20:00', 'TV'),
(7,  NULL, 76,  '2018-09-04 19:10:00', '2018-09-04 19:55:00', 'Mobile'),
(8,  58,  NULL, '2019-02-11 21:30:00', NULL,                 'SmartTV'),
(8,  NULL, 87,  '2019-02-12 22:00:00', '2019-02-12 22:48:00', 'Laptop'),
(9,  66,  NULL, '2020-07-01 20:10:00', '2020-07-01 22:00:00', 'TV'),
(9,  NULL, 14,  '2020-07-02 21:05:00', NULL,                 'Mobile'),
(10, 11,  NULL, '2021-04-18 17:25:00', '2021-04-18 19:45:00', 'Tablet'),
(10, NULL, 189, '2021-04-19 18:00:00', '2021-04-19 18:52:00', 'Laptop'),

(11, 73,  NULL, '2022-02-05 22:35:00', '2022-02-06 00:10:00', 'TV'),
(11, NULL, 250, '2022-02-06 00:25:00', NULL,                 'Mobile'),
(12, 6,   NULL, '2016-12-31 23:10:00', NULL,                 'Laptop'),
(12, NULL, 28,  '2017-01-01 00:30:00', '2017-01-01 01:15:00', 'Tablet'),
(13, 18,  NULL, '2018-06-10 16:00:00', '2018-06-10 18:25:00', 'TV'),
(13, NULL, 305, '2019-06-11 21:10:00', '2019-06-11 22:02:00', 'SmartTV'),
(14, 22,  NULL, '2020-10-20 19:45:00', '2020-10-20 21:55:00', 'Desktop'),
(14, NULL, 402, '2020-10-21 20:05:00', NULL,                 'Mobile'),
(15, 80,  NULL, '2021-11-15 21:15:00', '2021-11-15 23:05:00', 'TV'),
(15, NULL, 55,  '2021-11-16 22:10:00', '2021-11-16 22:55:00', 'Laptop'),

(16, 3,   NULL, '2015-03-08 18:20:00', '2015-03-08 20:45:00', 'TV'),
(16, NULL, 7,   '2015-03-09 19:10:00', NULL,                 'Mobile'),
(17, 47,  NULL, '2017-11-01 22:00:00', '2017-11-02 00:40:00', 'Laptop'),
(17, NULL, 118, '2018-11-02 20:30:00', '2018-11-02 21:18:00', 'Tablet'),
(18, 52,  NULL, '2019-09-17 21:05:00', NULL,                 'SmartTV'),
(18, NULL, 520, '2024-05-10 19:00:00', '2024-05-10 19:50:00', 'TV'),
(19, 35,  NULL, '2020-01-26 17:40:00', '2020-01-26 19:30:00', 'Desktop'),
(19, NULL, 390, '2020-01-27 18:10:00', NULL,                 'Mobile'),
(20, 14,  NULL, '2021-06-03 22:20:00', '2021-06-04 00:05:00', 'TV'),
(20, NULL, 66,  '2021-06-04 00:20:00', '2021-06-04 01:05:00', 'Laptop'),

(21, 84,  NULL, '2022-08-30 20:00:00', '2022-08-30 22:10:00', 'Tablet'),
(21, NULL, 470, '2022-08-31 21:10:00', NULL,                 'Mobile'),
(22, 29,  NULL, '2023-03-14 18:25:00', '2023-03-14 20:05:00', 'TV'),
(22, NULL, 155, '2023-03-15 19:00:00', '2023-03-15 19:50:00', 'Laptop'),
(23, 9,   NULL, '2018-04-02 21:30:00', NULL,                 'TV'),
(24, NULL, 580, '2025-09-01 22:10:00', '2025-09-01 23:00:00', 'SmartTV'),
(25, 61,  NULL, '2024-12-12 20:15:00', '2024-12-12 22:05:00', 'TV'),
(25, NULL, 222, '2024-12-13 21:10:00', NULL,                 'Mobile'),

-- 2 filas “raras” para practicar OUTER JOIN (sin película ni episodio)
(30, NULL, NULL, '2019-05-05 18:00:00', '2019-05-05 18:20:00', 'Mobile'),
(44, NULL, NULL, '2022-01-09 23:40:00', NULL,                 'Laptop'),

(31, 77,  NULL, '2025-02-02 19:30:00', '2025-02-02 21:10:00', 'TV'),
(31, NULL, 501, '2025-02-03 20:00:00', NULL,                 'Tablet'),
(32, 40,  NULL, '2016-08-18 22:05:00', '2016-08-19 00:10:00', 'Desktop'),
(33, NULL, 312, '2017-08-19 21:15:00', '2017-08-19 22:05:00', 'Mobile'),
(34, 5,   NULL, '2020-02-29 20:45:00', '2020-02-29 22:40:00', 'TV'),
(35, NULL, 33,  '2021-03-01 19:10:00', NULL,                 'Laptop'),
(36, 70,  NULL, '2023-10-31 23:00:00', NULL,                 'Mobile'),
(37, NULL, 98,  '2024-01-06 18:30:00', '2024-01-06 19:20:00', 'SmartTV'),
(38, 86,  NULL, '2025-07-20 21:40:00', '2025-07-20 23:35:00', 'TV'),
(39, NULL, 411, '2025-07-21 20:10:00', '2025-07-21 21:00:00', 'Tablet');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(26, 12,  NULL, '2016-04-12 21:00:00', '2016-04-12 23:05:00', 'TV'),
(26, NULL, 143, '2016-04-13 20:10:00', NULL,                 'Laptop'),

(27, 44,  NULL, '2017-09-18 22:15:00', '2017-09-19 00:30:00', 'SmartTV'),
(27, NULL, 210, '2017-09-20 19:30:00', '2017-09-20 20:20:00', 'Tablet'),

(28, 3,   NULL, '2018-01-05 18:40:00', '2018-01-05 21:10:00', 'Desktop'),
(28, NULL, 18,  '2018-01-06 19:00:00', NULL,                 'Mobile'),

(29, 77,  NULL, '2019-05-22 21:20:00', '2019-05-22 23:15:00', 'TV'),
(29, NULL, 322, '2019-05-23 20:00:00', '2019-05-23 20:55:00', 'Laptop'),

(30, 59,  NULL, '2020-03-11 22:00:00', NULL,                 'SmartTV'),
(30, NULL, 405, '2020-03-12 21:05:00', '2020-03-12 21:55:00', 'Tablet'),

(31, 10,  NULL, '2021-07-01 19:45:00', '2021-07-01 21:35:00', 'TV'),
(31, NULL, 97,  '2021-07-02 20:10:00', NULL,                 'Mobile'),

(32, 68,  NULL, '2022-02-14 22:30:00', '2022-02-15 00:10:00', 'Desktop'),
(32, NULL, 511, '2022-02-16 19:00:00', '2022-02-16 19:48:00', 'Laptop'),

(33, 21,  NULL, '2016-11-08 20:15:00', '2016-11-08 22:00:00', 'TV'),
(33, NULL, 61,  '2016-11-09 21:10:00', '2016-11-09 21:55:00', 'Tablet'),

(34, 85,  NULL, '2017-12-26 23:00:00', NULL,                 'Mobile'),
(34, NULL, 276, '2017-12-27 20:05:00', '2017-12-27 21:00:00', 'Laptop'),

(35, 6,   NULL, '2018-08-17 18:30:00', '2018-08-17 20:45:00', 'TV'),
(35, NULL, 14,  '2018-08-18 19:00:00', NULL,                 'Mobile'),

(36, 52,  NULL, '2019-10-02 21:10:00', '2019-10-02 23:00:00', 'SmartTV'),
(36, NULL, 198, '2019-10-03 20:00:00', '2019-10-03 20:50:00', 'Tablet'),

(37, 39,  NULL, '2020-06-21 22:20:00', NULL,                 'TV'),
(37, NULL, 341, '2020-06-22 21:05:00', '2020-06-22 21:55:00', 'Laptop'),

(38, 71,  NULL, '2021-09-09 19:40:00', '2021-09-09 21:30:00', 'Desktop'),
(38, NULL, 509, '2021-09-10 20:00:00', NULL,                 'Mobile'),

(39, 17,  NULL, '2022-04-03 22:00:00', '2022-04-03 23:50:00', 'TV'),
(39, NULL, 88,  '2022-04-04 19:10:00', '2022-04-04 20:00:00', 'Laptop'),

(40, 63,  NULL, '2023-01-15 21:30:00', NULL,                 'SmartTV'),
(40, NULL, 624, '2023-01-16 20:05:00', '2023-01-16 20:55:00', 'Tablet'),

(41, 27,  NULL, '2024-05-18 22:10:00', '2024-05-18 23:55:00', 'TV'),
(41, NULL, 702, '2024-05-19 19:00:00', NULL,                 'Mobile'),

-- Registros sin contenido (OUTER JOIN)
(42, NULL, NULL, '2019-02-02 18:00:00', '2019-02-02 18:15:00', 'Mobile'),
(55, NULL, NULL, '2022-10-10 23:30:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(7,  14,  NULL, '2016-05-14 21:10:00', '2016-05-14 23:05:00', 'TV'),
(7,  NULL, 211, '2016-05-15 20:00:00', NULL,                 'Laptop'),
(7,  NULL, 212, '2016-05-16 19:40:00', '2016-05-16 20:25:00', 'Mobile'),

(42, 61,  NULL, '2018-03-22 22:00:00', '2018-03-23 00:10:00', 'SmartTV'),

(89, NULL, 77,  '2019-11-04 18:30:00', '2019-11-04 19:20:00', 'Tablet'),
(89, NULL, 78,  '2019-11-05 18:35:00', NULL,                 'Tablet'),

(15,  3,   NULL, '2020-01-10 20:00:00', '2020-01-10 22:30:00', 'TV'),
(15,  44,  NULL, '2020-01-12 21:15:00', NULL,                 'Desktop'),
(15,  NULL, 320, '2020-01-13 19:00:00', '2020-01-13 19:50:00', 'Laptop'),
(15,  NULL, 321, '2020-01-14 19:10:00', NULL,                 'Mobile'),

(63,  88,  NULL, '2021-07-07 22:20:00', '2021-07-08 00:05:00', 'TV'),

(101, NULL, 502, '2022-02-18 20:30:00', '2022-02-18 21:15:00', 'SmartTV'),
(101, NULL, 503, '2022-02-19 21:00:00', NULL,                 'SmartTV'),

(3,   27,  NULL, '2017-09-09 18:10:00', '2017-09-09 20:00:00', 'Laptop'),

(77,  NULL, 690, '2024-04-12 22:05:00', '2024-04-12 22:55:00', 'Tablet'),
(77,  56,  NULL, '2024-04-13 21:30:00', NULL,                 'TV'),

(9,   12,  NULL, '2015-12-01 19:45:00', '2015-12-01 22:00:00', 'Desktop'),

(54,  NULL, 404, '2019-06-22 20:10:00', '2019-06-22 20:55:00', 'Mobile'),

(120, 71,  NULL, '2025-01-19 21:00:00', '2025-01-19 23:15:00', 'TV'),
(120, NULL, 702, '2025-01-20 20:05:00', NULL,                 'Laptop'),

(18,  NULL, 14,  '2016-02-03 19:00:00', '2016-02-03 19:45:00', 'Tablet'),
(18,  NULL, 15,  '2016-02-04 19:10:00', NULL,                 'Tablet'),

(90,  5,   NULL, '2018-08-30 22:30:00', '2018-08-31 00:20:00', 'SmartTV'),

(64,  NULL, 198, '2020-10-06 20:00:00', '2020-10-06 20:50:00', 'Mobile'),

(11,  33,  NULL, '2019-03-15 21:10:00', '2019-03-15 23:05:00', 'TV'),
(11,  NULL, 199, '2019-03-16 20:00:00', NULL,                 'Laptop'),

(4,   NULL, 512, '2023-06-08 19:30:00', '2023-06-08 20:20:00', 'SmartTV'),

(58,  68,  NULL, '2021-11-21 22:00:00', '2021-11-22 00:00:00', 'TV'),

(96,  NULL, 88,  '2017-04-17 18:45:00', '2017-04-17 19:30:00', 'Mobile'),

(23,  9,   NULL, '2018-01-05 20:10:00', '2018-01-05 22:00:00', 'Desktop'),

(112, NULL, 611, '2024-09-03 21:00:00', NULL,                 'Tablet'),

-- sesiones sin contenido asociado
(65,  NULL, NULL, '2020-12-31 23:50:00', '2021-01-01 00:05:00', 'Mobile'),
(98,  NULL, NULL, '2023-02-11 18:00:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(92,  18,  NULL, '2016-03-11 22:00:00', '2016-03-12 00:10:00', 'TV'),
(92,  NULL, 305, '2016-03-13 20:15:00', NULL,                 'Laptop'),
(92,  NULL, 306, '2016-03-14 20:20:00', '2016-03-14 21:05:00', 'Laptop'),

(5,   61,  NULL, '2017-07-08 21:10:00', '2017-07-08 23:00:00', 'SmartTV'),

(118, NULL, 501, '2018-12-20 19:30:00', '2018-12-20 20:20:00', 'Tablet'),
(118, NULL, 502, '2018-12-21 19:35:00', NULL,                 'Tablet'),

(14,  33,  NULL, '2019-02-16 22:15:00', '2019-02-17 00:05:00', 'TV'),
(14,  NULL, 189, '2019-02-18 21:00:00', '2019-02-18 21:55:00', 'Mobile'),
(14,  NULL, 190, '2019-02-19 21:05:00', NULL,                 'Mobile'),

(67,  9,   NULL, '2020-10-03 18:40:00', '2020-10-03 20:30:00', 'Desktop'),

(81,  NULL, 77,  '2021-05-14 19:10:00', '2021-05-14 19:55:00', 'Laptop'),
(81,  NULL, 78,  '2021-05-15 19:20:00', NULL,                 'Laptop'),
(81,  NULL, 79,  '2021-05-16 19:25:00', '2021-05-16 20:10:00', 'Laptop'),

(2,   70,  NULL, '2016-09-21 22:30:00', NULL,                 'TV'),

(103, NULL, 412, '2022-01-08 20:05:00', '2022-01-08 20:50:00', 'Tablet'),

(56,  48,  NULL, '2023-06-17 21:40:00', '2023-06-17 23:25:00', 'SmartTV'),
(56,  NULL, 624, '2023-06-18 19:00:00', NULL,                 'Mobile'),

(19,  NULL, 14,  '2015-11-02 18:30:00', '2015-11-02 19:15:00', 'Tablet'),

(121, 88,  NULL, '2025-03-09 22:10:00', '2025-03-10 00:20:00', 'TV'),

(44,  NULL, 275, '2018-04-07 20:00:00', '2018-04-07 20:45:00', 'Mobile'),

(71,  6,   NULL, '2017-01-14 21:30:00', '2017-01-14 23:10:00', 'Desktop'),

(34,  NULL, 98,  '2020-12-01 19:05:00', NULL,                 'Laptop'),

(86,  27,  NULL, '2021-08-19 22:20:00', '2021-08-20 00:05:00', 'TV'),
(86,  NULL, 509, '2021-08-21 20:10:00', '2021-08-21 21:00:00', 'Tablet'),

(8,   12,  NULL, '2019-10-31 21:45:00', '2019-10-31 23:55:00', 'SmartTV'),

(59,  NULL, 340, '2020-06-02 18:55:00', '2020-06-02 19:40:00', 'Mobile'),

(110, 71,  NULL, '2024-11-05 21:30:00', NULL,                 'TV'),
(110, NULL, 702, '2024-11-06 20:00:00', '2024-11-06 20:50:00', 'Laptop'),

(16,  52,  NULL, '2018-02-23 22:00:00', '2018-02-24 00:00:00', 'TV'),

(73,  NULL, 198, '2019-09-11 19:10:00', '2019-09-11 20:00:00', 'Tablet'),

(28,  5,   NULL, '2017-12-03 20:30:00', NULL,                 'Desktop'),

(95,  NULL, 611, '2023-09-01 21:00:00', '2023-09-01 21:55:00', 'Mobile'),

-- sesiones huérfanas
(62,  NULL, NULL, '2018-07-07 18:00:00', '2018-07-07 18:10:00', 'Mobile'),
(107, NULL, NULL, '2022-12-31 23:40:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(3,   NULL, 412, '2016-01-08 19:10:00', '2016-01-08 20:00:00', 'Tablet'),
(3,   NULL, 413, '2016-01-09 19:15:00', NULL,                 'Tablet'),
(3,   17,  NULL, '2016-01-10 21:30:00', '2016-01-10 23:25:00', 'TV'),

(48,  63,  NULL, '2017-06-14 22:10:00', '2017-06-15 00:05:00', 'SmartTV'),

(91,  NULL, 77,  '2018-03-03 18:40:00', '2018-03-03 19:30:00', 'Mobile'),
(91,  NULL, 78,  '2018-03-04 18:45:00', NULL,                 'Mobile'),
(91,  NULL, 79,  '2018-03-05 18:50:00', '2018-03-05 19:35:00', 'Mobile'),

(12,  6,   NULL, '2019-12-24 23:00:00', '2019-12-25 01:00:00', 'TV'),

(104, NULL, 511, '2020-07-18 20:05:00', '2020-07-18 20:55:00', 'Laptop'),

(67,  52,  NULL, '2021-02-02 21:45:00', NULL,                 'SmartTV'),

(22,  NULL, 98,  '2015-10-11 19:00:00', '2015-10-11 19:50:00', 'Tablet'),

(118, 71,  NULL, '2022-08-05 22:20:00', '2022-08-06 00:10:00', 'TV'),
(118, NULL, 702, '2022-08-07 19:30:00', NULL,                 'Laptop'),

(35,  14,  NULL, '2017-04-21 20:10:00', '2017-04-21 22:00:00', 'Desktop'),

(88,  NULL, 305, '2018-09-13 21:00:00', '2018-09-13 21:50:00', 'Tablet'),

(9,   12,  NULL, '2019-11-02 21:40:00', '2019-11-02 23:50:00', 'TV'),

(52,  NULL, 198, '2020-04-19 19:15:00', NULL,                 'Mobile'),

(66,  80,  NULL, '2021-12-30 22:30:00', '2021-12-31 00:20:00', 'SmartTV'),

(41,  NULL, 340, '2016-02-07 18:55:00', '2016-02-07 19:45:00', 'Laptop'),

(101, 5,   NULL, '2023-05-14 21:10:00', NULL,                 'TV'),

(57,  NULL, 624, '2024-01-06 20:00:00', '2024-01-06 20:55:00', 'Tablet'),

(14,  33,  NULL, '2018-06-01 22:15:00', '2018-06-02 00:00:00', 'TV'),
(14,  NULL, 189, '2018-06-03 21:05:00', NULL,                 'Mobile'),
(14,  NULL, 190, '2018-06-04 21:10:00', '2018-06-04 22:00:00', 'Mobile'),

(75,  27,  NULL, '2020-09-09 22:00:00', '2020-09-10 00:10:00', 'Desktop'),

(83,  NULL, 88,  '2017-11-18 18:40:00', '2017-11-18 19:30:00', 'Tablet'),

(60,  59,  NULL, '2021-03-03 21:30:00', NULL,                 'SmartTV'),

(20,  NULL, 14,  '2015-05-04 19:10:00', '2015-05-04 19:55:00', 'Mobile'),

(116, 86,  NULL, '2025-06-22 22:20:00', '2025-06-23 00:30:00', 'TV'),

(39,  NULL, 411, '2019-01-17 20:05:00', NULL,                 'Laptop'),

(28,  3,   NULL, '2016-12-09 21:45:00', '2016-12-09 23:50:00', 'TV'),

(95,  NULL, 611, '2023-10-31 21:00:00', '2023-10-31 21:55:00', 'Tablet'),

-- sesiones sin contenido
(74,  NULL, NULL, '2018-01-01 00:10:00', '2018-01-01 00:25:00', 'Mobile'),
(109, NULL, NULL, '2022-06-06 23:40:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(6,   NULL, 515, '2015-06-12 19:05:00', '2015-06-12 19:55:00', 'Tablet'),
(6,   NULL, 516, '2015-06-13 19:10:00', NULL,                 'Tablet'),
(6,   24,  NULL, '2015-06-14 21:30:00', '2015-06-14 23:10:00', 'TV'),

(97,  65,  NULL, '2016-10-02 22:15:00', '2016-10-03 00:05:00', 'SmartTV'),

(51,  NULL, 143, '2017-02-08 20:00:00', '2017-02-08 20:50:00', 'Laptop'),

(1,   9,   NULL, '2018-04-17 21:45:00', '2018-04-17 23:35:00', 'TV'),
(1,   NULL, 14,  '2018-04-18 19:00:00', NULL,                 'Mobile'),

(84,  NULL, 332, '2019-07-21 18:40:00', '2019-07-21 19:30:00', 'Tablet'),

(69,  41,  NULL, '2020-02-02 22:30:00', NULL,                 'Desktop'),

(102, NULL, 702, '2021-01-10 20:00:00', '2021-01-10 20:55:00', 'Laptop'),

(17,  58,  NULL, '2016-12-30 23:00:00', '2016-12-31 01:05:00', 'TV'),

(40,  NULL, 98,  '2017-11-04 19:10:00', '2017-11-04 20:00:00', 'Mobile'),

(72,  12,  NULL, '2018-06-22 22:20:00', '2018-06-23 00:15:00', 'SmartTV'),

(53,  NULL, 410, '2019-09-15 20:05:00', NULL,                 'Tablet'),

(111, 80,  NULL, '2020-12-24 21:45:00', '2020-12-24 23:40:00', 'TV'),

(21,  NULL, 189, '2015-03-18 18:30:00', '2015-03-18 19:20:00', 'Laptop'),

(87,  33,  NULL, '2016-08-09 21:15:00', NULL,                 'Desktop'),

(58,  NULL, 624, '2017-10-14 19:05:00', '2017-10-14 19:55:00', 'Mobile'),

(94,  71,  NULL, '2018-12-01 22:10:00', '2018-12-02 00:05:00', 'TV'),

(12,  NULL, 77,  '2019-05-03 18:45:00', NULL,                 'Tablet'),

(45,  5,   NULL, '2020-07-19 21:40:00', '2020-07-19 23:30:00', 'SmartTV'),

(109, NULL, 611, '2021-09-07 20:00:00', '2021-09-07 20:55:00', 'Laptop'),

(30,  27,  NULL, '2022-02-11 22:20:00', NULL,                 'TV'),

(68,  NULL, 340, '2023-04-05 19:15:00', '2023-04-05 20:05:00', 'Mobile'),

(4,   52,  NULL, '2016-01-22 21:10:00', '2016-01-22 23:00:00', 'Desktop'),

(74,  NULL, 411, '2017-03-02 18:50:00', NULL,                 'Tablet'),

(99,  86,  NULL, '2024-08-16 22:30:00', '2024-08-17 00:30:00', 'TV'),

(26,  NULL, 198, '2018-05-09 19:00:00', '2018-05-09 19:50:00', 'Laptop'),

(63,  70,  NULL, '2019-11-21 21:45:00', NULL,                 'SmartTV'),

(114, NULL, 702, '2025-05-01 20:10:00', '2025-05-01 21:05:00', 'Mobile'),

-- sesiones sin contenido
(52,  NULL, NULL, '2017-07-07 18:00:00', '2017-07-07 18:20:00', 'Mobile'),
(83,  NULL, NULL, '2022-04-30 23:40:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(12,  NULL, 502, '2015-02-04 18:45:00', '2015-02-04 19:35:00', 'Tablet'),
(12,  NULL, 503, '2015-02-05 18:50:00', NULL,                 'Tablet'),

(88,  41,  NULL, '2016-06-19 22:10:00', '2016-06-20 00:20:00', 'TV'),

(4,   NULL, 77,  '2017-01-11 19:00:00', '2017-01-11 19:45:00', 'Mobile'),
(4,   NULL, 78,  '2017-01-12 19:05:00', NULL,                 'Mobile'),

(73,  18,  NULL, '2018-03-22 21:30:00', '2018-03-22 23:20:00', 'Desktop'),

(101, NULL, 624, '2019-05-08 20:00:00', '2019-05-08 20:55:00', 'Laptop'),
(101, NULL, 625, '2019-05-09 20:05:00', NULL,                 'Laptop'),

(29,  6,   NULL, '2020-02-14 22:40:00', '2020-02-15 00:30:00', 'SmartTV'),

(65,  NULL, 340, '2016-09-03 19:10:00', '2016-09-03 19:55:00', 'Tablet'),

(56,  71,  NULL, '2017-12-21 22:00:00', '2017-12-22 00:10:00', 'TV'),

(7,   NULL, 189, '2018-07-01 18:45:00', NULL,                 'Mobile'),
(7,   NULL, 190, '2018-07-02 18:50:00', '2018-07-02 19:40:00', 'Mobile'),

(94,  33,  NULL, '2019-10-12 21:15:00', '2019-10-12 23:05:00', 'Desktop'),

(83,  NULL, 14,  '2020-04-04 19:00:00', '2020-04-04 19:50:00', 'Tablet'),

(22,  52,  NULL, '2021-06-09 22:30:00', NULL,                 'SmartTV'),

(114, NULL, 702, '2022-01-18 20:10:00', '2022-01-18 21:00:00', 'Laptop'),

(39,  NULL, 411, '2016-11-07 19:20:00', NULL,                 'Mobile'),

(48,  80,  NULL, '2017-05-27 21:45:00', '2017-05-27 23:40:00', 'TV'),

(5,   NULL, 305, '2018-08-13 20:05:00', '2018-08-13 20:55:00', 'Tablet'),

(119, 12,  NULL, '2019-12-24 22:20:00', '2019-12-25 00:10:00', 'TV'),

(68,  NULL, 98,  '2020-10-01 19:00:00', '2020-10-01 19:45:00', 'Laptop'),

(17,  27,  NULL, '2021-03-03 22:10:00', NULL,                 'SmartTV'),

(102, NULL, 611, '2022-05-14 20:00:00', '2022-05-14 20:55:00', 'Mobile'),

(60,  5,   NULL, '2023-07-07 21:30:00', '2023-07-07 23:20:00', 'TV'),

(33,  NULL, 198, '2016-02-22 18:55:00', '2016-02-22 19:45:00', 'Tablet'),

(86,  70,  NULL, '2017-11-19 22:15:00', NULL,                 'Desktop'),

(25,  NULL, 624, '2018-09-05 20:10:00', '2018-09-05 21:00:00', 'Laptop'),

(110, 88,  NULL, '2024-03-17 22:30:00', '2024-03-18 00:30:00', 'TV'),

(41,  NULL, 340, '2019-04-09 19:00:00', NULL,                 'Mobile'),

(91,  59,  NULL, '2020-06-16 21:40:00', '2020-06-16 23:30:00', 'SmartTV'),

(8,   NULL, 14,  '2015-01-19 18:40:00', '2015-01-19 19:30:00', 'Tablet'),

(77,  NULL, 702, '2025-08-11 20:05:00', NULL,                 'Laptop'),

-- sesiones sin contenido
(66,  NULL, NULL, '2018-12-31 23:50:00', '2019-01-01 00:05:00', 'Mobile'),
(97,  NULL, NULL, '2022-07-14 18:00:00', NULL,                 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
(5,   12,  NULL, '2016-04-10 21:10:00', '2016-04-10 23:05:00', 'TV'),
(8,   NULL, 342, '2017-09-22 18:30:00', NULL,                 'Mobile'),
(8,   44,  NULL, '2018-01-05 22:00:00', '2018-01-06 00:15:00', 'Laptop'),
(12,  NULL, 19,  '2019-06-11 20:05:00', '2019-06-11 20:55:00', 'Tablet'),
(12,  NULL, 20,  '2019-06-12 21:00:00', NULL,                 'Mobile'),

(19,  3,   NULL, '2015-11-03 17:40:00', '2015-11-03 20:05:00', 'TV'),
(21,  NULL, 501, '2024-03-19 22:10:00', '2024-03-19 23:00:00', 'SmartTV'),
(21,  78,  NULL, '2024-03-20 19:00:00', NULL,                 'Mobile'),
(22,  NULL, 64,  '2016-08-09 18:30:00', '2016-08-09 19:20:00', 'Laptop'),
(22,  NULL, 65,  '2016-08-10 19:10:00', NULL,                 'Tablet'),

(27,  55,  NULL, '2020-02-14 22:45:00', '2020-02-15 00:30:00', 'TV'),
(27,  NULL, 310, '2020-02-16 21:00:00', '2020-02-16 21:45:00', 'Mobile'),
(27,  NULL, 311, '2020-02-17 21:10:00', NULL,                 'Mobile'),
(30,  9,   NULL, '2017-12-01 20:30:00', '2017-12-01 22:40:00', 'Desktop'),
(31,  NULL, 402, '2021-10-05 19:15:00', '2021-10-05 20:00:00', 'Laptop'),

(33,  61,  NULL, '2023-07-22 21:00:00', '2023-07-22 23:00:00', 'TV'),
(33,  NULL, 145, '2023-07-23 18:40:00', NULL,                 'Mobile'),
(33,  NULL, 146, '2023-07-24 19:00:00', '2023-07-24 19:50:00', 'Tablet'),
(36,  70,  NULL, '2024-10-31 23:30:00', NULL,                 'Mobile'),
(38,  NULL, 88,  '2015-05-18 17:20:00', '2015-05-18 18:05:00', 'Laptop'),

(41,  14,  NULL, '2018-09-07 22:10:00', '2018-09-08 00:05:00', 'TV'),
(41,  NULL, 210, '2018-09-09 21:00:00', NULL,                 'Mobile'),
(44,  82,  NULL, '2022-04-01 20:30:00', '2022-04-01 22:25:00', 'SmartTV'),
(44,  NULL, 399, '2022-04-02 21:10:00', '2022-04-02 22:00:00', 'Tablet'),
(44,  NULL, 400, '2022-04-03 22:00:00', NULL,                 'Mobile'),

(50,  18,  NULL, '2016-12-24 19:00:00', '2016-12-24 21:35:00', 'TV'),
(52,  NULL, 601, '2025-01-05 22:15:00', '2025-01-05 23:05:00', 'Laptop'),
(55,  27,  NULL, '2019-03-02 18:45:00', NULL,                 'Mobile'),
(58,  NULL, 74,  '2015-06-11 17:10:00', '2015-06-11 18:00:00', 'Tablet'),
(60,  88,  NULL, '2024-08-18 21:20:00', '2024-08-18 23:10:00', 'TV'),

(60,  NULL, 275, '2024-08-19 20:15:00', NULL,                 'Mobile'),
(63,  6,   NULL, '2017-01-14 22:00:00', '2017-01-15 00:10:00', 'Laptop'),
(67,  NULL, 503, '2025-02-11 19:30:00', '2025-02-11 20:15:00', 'Tablet'),
(70,  48,  NULL, '2021-05-06 20:10:00', NULL,                 'SmartTV'),
(72,  NULL, 12,  '2016-03-03 18:20:00', '2016-03-03 19:05:00', 'Mobile'),

(75,  33,  NULL, '2020-11-28 21:30:00', '2020-11-28 23:40:00', 'TV'),
(75,  NULL, 120, '2020-11-29 22:00:00', NULL,                 'Laptop'),
(80,  NULL, 707, '2025-12-01 20:00:00', '2025-12-01 20:50:00', 'Tablet'),
(83,  1,   NULL, '2015-01-03 17:00:00', '2015-01-03 19:05:00', 'TV'),
(90,  NULL, 333, '2019-09-09 21:45:00', NULL,                 'Mobile');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
-- Usuario 7 (13 visualizaciones)
(7,  5,   NULL, '2018-01-10 20:00:00', '2018-01-10 21:55:00', 'TV'),
(7,  12,  NULL, '2018-01-11 22:10:00', NULL,                 'Laptop'),
(7,  NULL, 34,  '2018-01-12 19:00:00', '2018-01-12 19:45:00', 'Mobile'),
(7,  NULL, 35,  '2018-01-12 20:00:00', '2018-01-12 20:48:00', 'Mobile'),
(7,  NULL, 36,  '2018-01-13 21:00:00', NULL,                 'Tablet'),
(7,  41,  NULL, '2018-01-14 22:15:00', '2018-01-15 00:10:00', 'TV'),
(7,  NULL, 120, '2018-01-16 18:30:00', '2018-01-16 19:15:00', 'Laptop'),
(7,  NULL, 121, '2018-01-16 19:20:00', '2018-01-16 20:05:00', 'Laptop'),
(7,  NULL, 122, '2018-01-16 20:10:00', NULL,                 'Laptop'),
(7,  8,   NULL, '2018-01-18 22:00:00', '2018-01-19 00:30:00', 'TV'),
(7,  NULL, 401, '2018-01-20 17:00:00', '2018-01-20 17:42:00', 'Mobile'),
(7,  66,  NULL, '2018-01-21 21:30:00', NULL,                 'SmartTV'),
(7,  NULL, 402, '2018-01-22 22:00:00', '2018-01-22 22:50:00', 'Tablet'),

-- Usuario 19 (12 visualizaciones)
(19, 22,  NULL, '2020-06-05 20:15:00', '2020-06-05 22:10:00', 'TV'),
(19, NULL, 88,  '2020-06-06 18:40:00', '2020-06-06 19:30:00', 'Mobile'),
(19, NULL, 89,  '2020-06-06 19:35:00', NULL,                 'Mobile'),
(19, 70,  NULL, '2020-06-07 22:00:00', '2020-06-08 00:05:00', 'Laptop'),
(19, NULL, 240, '2020-06-09 17:10:00', '2020-06-09 17:55:00', 'Tablet'),
(19, NULL, 241, '2020-06-09 18:00:00', '2020-06-09 18:50:00', 'Tablet'),
(19, NULL, 242, '2020-06-09 18:55:00', NULL,                 'Tablet'),
(19, 14,  NULL, '2020-06-10 21:00:00', '2020-06-10 23:10:00', 'TV'),
(19, NULL, 510, '2020-06-12 19:30:00', '2020-06-12 20:20:00', 'SmartTV'),
(19, 3,   NULL, '2020-06-14 22:20:00', NULL,                 'Desktop'),
(19, NULL, 511, '2020-06-15 18:10:00', '2020-06-15 19:00:00', 'Mobile'),
(19, NULL, 512, '2020-06-15 19:05:00', '2020-06-15 19:55:00', 'Mobile'),

-- Usuario 42 (15 visualizaciones)
(42, 9,   NULL, '2023-03-01 20:00:00', '2023-03-01 22:00:00', 'TV'),
(42, NULL, 301, '2023-03-02 18:00:00', '2023-03-02 18:45:00', 'Laptop'),
(42, NULL, 302, '2023-03-02 18:50:00', '2023-03-02 19:40:00', 'Laptop'),
(42, NULL, 303, '2023-03-02 19:45:00', NULL,                 'Laptop'),
(42, 55,  NULL, '2023-03-03 22:10:00', '2023-03-04 00:00:00', 'TV'),
(42, NULL, 610, '2023-03-05 17:30:00', '2023-03-05 18:15:00', 'Mobile'),
(42, NULL, 611, '2023-03-05 18:20:00', '2023-03-05 19:05:00', 'Mobile'),
(42, NULL, 612, '2023-03-05 19:10:00', NULL,                 'Mobile'),
(42, 1,   NULL, '2023-03-06 21:00:00', '2023-03-06 23:00:00', 'SmartTV'),
(42, NULL, 150, '2023-03-08 18:00:00', '2023-03-08 18:50:00', 'Tablet'),
(42, NULL, 151, '2023-03-08 18:55:00', '2023-03-08 19:45:00', 'Tablet'),
(42, NULL, 152, '2023-03-08 19:50:00', NULL,                 'Tablet'),
(42, 88,  NULL, '2023-03-09 22:30:00', '2023-03-10 00:40:00', 'TV'),
(42, NULL, 680, '2023-03-11 16:30:00', '2023-03-11 17:15:00', 'Mobile'),
(42, NULL, 681, '2023-03-11 17:20:00', '2023-03-11 18:05:00', 'Mobile'),

-- Usuario 88 (10 visualizaciones)
(88, 31,  NULL, '2024-10-01 21:10:00', '2024-10-01 23:05:00', 'TV'),
(88, NULL, 410, '2024-10-02 18:00:00', '2024-10-02 18:45:00', 'Laptop'),
(88, NULL, 411, '2024-10-02 18:50:00', NULL,                 'Laptop'),
(88, 77,  NULL, '2024-10-03 22:00:00', '2024-10-04 00:20:00', 'SmartTV'),
(88, NULL, 690, '2024-10-05 17:30:00', '2024-10-05 18:15:00', 'Mobile'),
(88, NULL, 691, '2024-10-05 18:20:00', '2024-10-05 19:05:00', 'Mobile'),
(88, NULL, 692, '2024-10-05 19:10:00', NULL,                 'Mobile'),
(88, 16,  NULL, '2024-10-06 21:00:00', '2024-10-06 22:55:00', 'TV'),
(88, NULL, 250, '2024-10-07 18:10:00', '2024-10-07 19:00:00', 'Tablet'),
(88, NULL, 251, '2024-10-07 19:05:00', '2024-10-07 19:55:00', 'Tablet');

INSERT INTO visualizacion
(id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES

-- Usuario 62 (12 visualizaciones)
(62, 14, NULL, '2018-03-10 20:10:00', '2018-03-10 22:05:00', 'TV'),
(62, NULL, 201, '2018-03-11 19:30:00', '2018-03-11 20:15:00', 'Laptop'),
(62, NULL, 202, '2018-03-11 20:20:00', '2018-03-11 21:05:00', 'Laptop'),
(62, NULL, 203, '2018-03-12 21:00:00', NULL, 'Mobile'),
(62, 33, NULL, '2019-01-22 22:00:00', '2019-01-23 00:05:00', 'TV'),
(62, NULL, 310, '2019-01-24 18:45:00', '2019-01-24 19:30:00', 'Tablet'),
(62, NULL, 311, '2019-01-24 19:35:00', '2019-01-24 20:20:00', 'Tablet'),
(62, 51, NULL, '2020-07-02 21:10:00', '2020-07-02 23:00:00', 'SmartTV'),
(62, NULL, 402, '2021-02-14 17:40:00', NULL, 'Mobile'),
(62, NULL, 403, '2021-02-15 18:00:00', '2021-02-15 18:50:00', 'Laptop'),
(62, 72, NULL, '2023-10-10 22:30:00', '2023-10-11 00:20:00', 'TV'),
(62, NULL, 588, '2024-04-05 19:15:00', '2024-04-05 20:05:00', 'Tablet'),

-- Usuario 77 (10 visualizaciones)
(77, NULL, 88,  '2016-09-04 21:00:00', '2016-09-04 21:45:00', 'Laptop'),
(77, NULL, 89,  '2016-09-05 21:10:00', '2016-09-05 21:55:00', 'Laptop'),
(77, 6,   NULL, '2017-02-11 22:20:00', '2017-02-12 00:05:00', 'TV'),
(77, NULL, 145, '2018-06-14 18:30:00', NULL, 'Mobile'),
(77, 19,  NULL, '2019-08-22 21:40:00', '2019-08-22 23:30:00', 'SmartTV'),
(77, NULL, 333, '2020-01-09 19:10:00', '2020-01-09 19:55:00', 'Tablet'),
(77, NULL, 334, '2020-01-09 20:00:00', '2020-01-09 20:45:00', 'Tablet'),
(77, 44,  NULL, '2022-11-03 22:00:00', '2022-11-04 00:10:00', 'TV'),
(77, NULL, 511, '2023-03-18 18:50:00', NULL, 'Mobile'),
(77, 81,  NULL, '2025-01-12 21:30:00', '2025-01-12 23:15:00', 'TV'),

-- Usuario 103 (13 visualizaciones)
(103, 9,  NULL, '2015-05-20 19:00:00', '2015-05-20 20:50:00', 'TV'),
(103, NULL, 17, '2015-05-21 18:40:00', '2015-05-21 19:25:00', 'Laptop'),
(103, NULL, 18, '2015-05-21 19:30:00', NULL, 'Laptop'),
(103, 22, NULL, '2016-11-11 21:15:00', '2016-11-11 23:05:00', 'TV'),
(103, NULL, 266,'2017-09-01 20:10:00', '2017-09-01 20:55:00', 'Mobile'),
(103, NULL, 267,'2017-09-01 21:00:00', '2017-09-01 21:45:00', 'Mobile'),
(103, 37, NULL, '2018-12-24 22:30:00', '2018-12-25 00:25:00', 'TV'),
(103, NULL, 411,'2020-02-14 19:20:00', NULL, 'Tablet'),
(103, NULL, 412,'2020-02-15 18:30:00', '2020-02-15 19:15:00', 'Tablet'),
(103, 65, NULL, '2021-06-10 21:40:00', '2021-06-10 23:30:00', 'SmartTV'),
(103, NULL, 590,'2023-04-01 17:55:00', '2023-04-01 18:45:00', 'Laptop'),
(103, NULL, 591,'2023-04-01 18:50:00', NULL, 'Laptop'),
(103, 88, NULL, '2025-06-18 22:10:00', '2025-06-19 00:05:00', 'TV'),

-- Usuario 118 (15 visualizaciones)
(118, NULL, 301,'2019-01-05 18:10:00', '2019-01-05 18:55:00', 'Mobile'),
(118, NULL, 302,'2019-01-05 19:00:00', '2019-01-05 19:45:00', 'Mobile'),
(118, NULL, 303,'2019-01-05 19:50:00', NULL, 'Mobile'),
(118, 12, NULL, '2019-02-10 22:00:00', '2019-02-11 00:00:00', 'TV'),
(118, 27, NULL, '2020-03-14 21:30:00', '2020-03-14 23:20:00', 'TV'),
(118, NULL, 420,'2021-01-08 18:25:00', '2021-01-08 19:10:00', 'Tablet'),
(118, NULL, 421,'2021-01-08 19:15:00', '2021-01-08 20:00:00', 'Tablet'),
(118, 49, NULL, '2021-12-24 22:40:00', '2021-12-25 00:30:00', 'SmartTV'),
(118, NULL, 505,'2022-06-02 20:10:00', NULL, 'Mobile'),
(118, 61, NULL, '2023-02-17 21:50:00', '2023-02-17 23:45:00', 'TV'),
(118, NULL, 606,'2023-10-09 18:00:00', '2023-10-09 18:45:00', 'Laptop'),
(118, NULL, 607,'2023-10-09 18:50:00', '2023-10-09 19:35:00', 'Laptop'),
(118, NULL, 608,'2023-10-09 19:40:00', NULL, 'Laptop'),
(118, 75, NULL, '2024-11-03 22:20:00', '2024-11-04 00:10:00', 'TV'),
(118, 83, NULL, '2025-05-22 21:15:00', '2025-05-22 23:05:00', 'SmartTV');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES
-- Usuario 12 (13 episodios seguidos)
(12, NULL, 34,  '2019-02-10 18:00:00', '2019-02-10 18:25:00', 'TV'),
(12, NULL, 35,  '2019-02-10 18:30:00', '2019-02-10 18:55:00', 'TV'),
(12, NULL, 36,  '2019-02-10 19:00:00', '2019-02-10 19:24:00', 'TV'),
(12, NULL, 37,  '2019-02-10 19:30:00', '2019-02-10 19:55:00', 'TV'),
(12, NULL, 38,  '2019-02-10 20:00:00', '2019-02-10 20:22:00', 'TV'),
(12, NULL, 39,  '2019-02-10 20:30:00', '2019-02-10 20:55:00', 'TV'),
(12, NULL, 40,  '2019-02-10 21:00:00', '2019-02-10 21:25:00', 'TV'),
(12, NULL, 41,  '2019-02-10 21:30:00', '2019-02-10 21:55:00', 'TV'),
(12, NULL, 42,  '2019-02-10 22:00:00', '2019-02-10 22:24:00', 'TV'),
(12, NULL, 43,  '2019-02-10 22:30:00', '2019-02-10 22:55:00', 'TV'),
(12, NULL, 44,  '2019-02-10 23:00:00', NULL,                  'TV'),
(12, NULL, 45,  '2019-02-11 18:00:00', '2019-02-11 18:24:00', 'TV'),
(12, NULL, 46,  '2019-02-11 18:30:00', '2019-02-11 18:55:00', 'TV'),

-- Usuario 47 (10 episodios, móvil + tablet)
(47, NULL, 112, '2021-06-05 16:00:00', '2021-06-05 16:45:00', 'Mobile'),
(47, NULL, 113, '2021-06-05 17:00:00', '2021-06-05 17:42:00', 'Mobile'),
(47, NULL, 114, '2021-06-05 18:00:00', '2021-06-05 18:40:00', 'Tablet'),
(47, NULL, 115, '2021-06-05 19:00:00', '2021-06-05 19:45:00', 'Tablet'),
(47, NULL, 116, '2021-06-05 20:00:00', '2021-06-05 20:43:00', 'Tablet'),
(47, NULL, 117, '2021-06-05 21:00:00', '2021-06-05 21:44:00', 'Tablet'),
(47, NULL, 118, '2021-06-06 16:00:00', '2021-06-06 16:45:00', 'Mobile'),
(47, NULL, 119, '2021-06-06 17:00:00', NULL,                  'Mobile'),
(47, NULL, 120, '2021-06-06 18:00:00', '2021-06-06 18:40:00', 'Tablet'),
(47, NULL, 121, '2021-06-06 19:00:00', '2021-06-06 19:42:00', 'Tablet'),

-- Usuario 89 (15 episodios intensivos, portátil)
(89, NULL, 301, '2024-01-03 10:00:00', '2024-01-03 10:55:00', 'Laptop'),
(89, NULL, 302, '2024-01-03 11:00:00', '2024-01-03 11:52:00', 'Laptop'),
(89, NULL, 303, '2024-01-03 12:00:00', '2024-01-03 12:50:00', 'Laptop'),
(89, NULL, 304, '2024-01-03 13:00:00', '2024-01-03 13:48:00', 'Laptop'),
(89, NULL, 305, '2024-01-03 14:00:00', '2024-01-03 14:45:00', 'Laptop'),
(89, NULL, 306, '2024-01-03 15:00:00', '2024-01-03 15:50:00', 'Laptop'),
(89, NULL, 307, '2024-01-03 16:00:00', '2024-01-03 16:44:00', 'Laptop'),
(89, NULL, 308, '2024-01-03 17:00:00', '2024-01-03 17:55:00', 'Laptop'),
(89, NULL, 309, '2024-01-03 18:00:00', '2024-01-03 18:48:00', 'Laptop'),
(89, NULL, 310, '2024-01-03 19:00:00', '2024-01-03 19:52:00', 'Laptop'),
(89, NULL, 311, '2024-01-03 20:00:00', '2024-01-03 20:49:00', 'Laptop'),
(89, NULL, 312, '2024-01-03 21:00:00', NULL,                  'Laptop'),
(89, NULL, 313, '2024-01-04 10:00:00', '2024-01-04 10:50:00', 'Laptop'),
(89, NULL, 314, '2024-01-04 11:00:00', '2024-01-04 11:45:00', 'Laptop'),
(89, NULL, 315, '2024-01-04 12:00:00', '2024-01-04 12:55:00', 'Laptop');

INSERT INTO visualizacion (id_usuario, id_pelicula, id_episodio, fecha_inicio, fecha_fin, dispositivo) VALUES

-- Usuario 7 (13 películas)
(7,  3, NULL, '2016-02-10 21:00:00', '2016-02-10 23:10:00', 'TV'),
(7, 12, NULL, '2016-02-12 22:00:00', NULL,                 'Laptop'),
(7, 18, NULL, '2017-01-05 20:30:00', '2017-01-05 22:40:00', 'TV'),
(7, 21, NULL, '2017-03-18 18:10:00', '2017-03-18 20:05:00', 'Tablet'),
(7, 25, NULL, '2018-06-01 21:45:00', NULL,                 'Mobile'),
(7, 29, NULL, '2018-08-14 22:15:00', '2018-08-15 00:30:00', 'TV'),
(7, 34, NULL, '2019-04-22 19:30:00', '2019-04-22 21:25:00', 'Desktop'),
(7, 41, NULL, '2020-01-10 21:00:00', '2020-01-10 23:50:00', 'TV'),
(7, 48, NULL, '2020-07-03 22:20:00', NULL,                 'Laptop'),
(7, 52, NULL, '2021-09-19 20:00:00', '2021-09-19 22:10:00', 'SmartTV'),
(7, 61, NULL, '2022-11-11 21:30:00', '2022-11-11 23:40:00', 'TV'),
(7, 70, NULL, '2023-03-08 22:00:00', NULL,                 'Mobile'),
(7, 84, NULL, '2024-12-02 20:10:00', '2024-12-02 22:05:00', 'TV'),

-- Usuario 19 (10 películas)
(19,  1, NULL, '2015-05-21 21:15:00', '2015-05-21 23:00:00', 'TV'),
(19,  6, NULL, '2016-09-10 20:30:00', NULL,                 'Laptop'),
(19, 14, NULL, '2017-12-02 22:00:00', '2017-12-03 00:10:00', 'TV'),
(19, 22, NULL, '2018-04-19 19:45:00', '2018-04-19 21:50:00', 'Tablet'),
(19, 30, NULL, '2019-08-07 21:00:00', NULL,                 'Mobile'),
(19, 39, NULL, '2020-10-15 22:10:00', '2020-10-16 00:20:00', 'TV'),
(19, 46, NULL, '2021-06-01 20:30:00', '2021-06-01 22:40:00', 'Desktop'),
(19, 55, NULL, '2022-01-09 21:50:00', NULL,                 'Laptop'),
(19, 68, NULL, '2023-09-17 22:00:00', '2023-09-18 00:05:00', 'TV'),
(19, 82, NULL, '2024-05-25 20:15:00', '2024-05-25 22:10:00', 'SmartTV'),

-- Usuario 42 (15 películas)
(42,  4, NULL, '2016-03-11 18:30:00', '2016-03-11 20:40:00', 'TV'),
(42,  9, NULL, '2016-04-01 22:00:00', NULL,                 'Mobile'),
(42, 13, NULL, '2017-02-20 21:10:00', '2017-02-20 23:00:00', 'Laptop'),
(42, 17, NULL, '2017-06-05 19:45:00', '2017-06-05 21:35:00', 'Tablet'),
(42, 24, NULL, '2018-09-18 22:30:00', NULL,                 'TV'),
(42, 28, NULL, '2019-01-27 21:00:00', '2019-01-27 23:15:00', 'Desktop'),
(42, 32, NULL, '2019-11-09 20:20:00', '2019-11-09 22:10:00', 'TV'),
(42, 37, NULL, '2020-05-03 21:50:00', NULL,                 'Laptop'),
(42, 44, NULL, '2020-12-26 22:15:00', '2020-12-27 00:30:00', 'TV'),
(42, 50, NULL, '2021-07-14 19:40:00', '2021-07-14 21:50:00', 'SmartTV'),
(42, 57, NULL, '2022-02-18 21:30:00', NULL,                 'Mobile'),
(42, 63, NULL, '2022-10-01 22:00:00', '2022-10-02 00:05:00', 'TV'),
(42, 71, NULL, '2023-06-11 20:15:00', '2023-06-11 22:00:00', 'Laptop'),
(42, 76, NULL, '2024-03-09 21:45:00', NULL,                 'Tablet'),
(42, 88, NULL, '2025-01-04 22:10:00', '2025-01-05 00:20:00', 'TV');