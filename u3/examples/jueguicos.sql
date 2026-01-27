-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS jueguicos;
USE jueguicos;

-- Crear la tabla genero
CREATE TABLE IF NOT EXISTS genero (
                                      id_genero VARCHAR(10) PRIMARY KEY,
                                      nombre_genero VARCHAR(50) NOT NULL,
                                      descripcion TEXT
);

-- Crear la tabla juego
CREATE TABLE IF NOT EXISTS juego (
                                     id_juego VARCHAR(10) PRIMARY KEY,
                                     titulo VARCHAR(100) NOT NULL,
                                     descripcion TEXT,
                                     id_genero1 VARCHAR(10),
                                     id_genero2 VARCHAR(10),
                                     id_secuela VARCHAR(10),
                                     precio DECIMAL(10, 2),
                                     fecha_lanzamiento DATE,
                                     puntuacion INT,
                                     clasificacion_edad VARCHAR(5),
                                     FOREIGN KEY (id_genero1) REFERENCES genero(id_genero),
                                     FOREIGN KEY (id_genero2) REFERENCES genero(id_genero),
                                     FOREIGN KEY (id_secuela) REFERENCES juego(id_juego)

);

-- Crear tabla plataformas
CREATE TABLE IF NOT EXISTS plataforma (
                                          id_plataforma VARCHAR(10) PRIMARY KEY,
                                          nombre_plataforma VARCHAR(50) NOT NULL,
                                          fabricante VARCHAR(50),
                                          fecha_lanzamiento DATE
);

CREATE TABLE IF NOT EXISTS desarrollador (
                                             id_desarrollador VARCHAR(10) PRIMARY KEY, -- Identificador único del desarrollador
                                             nombre VARCHAR(100) NOT NULL, -- Nombre del estudio
                                             pais_origen VARCHAR(50) NOT NULL, -- País de origen
                                             continente VARCHAR(50) NOT NULL, -- Continente del estudio
                                             ceo VARCHAR(100), -- Nombre del CEO del estudio
                                             numero_trabajadores INT,
                                             fundacion INT, -- Fecha de fundación del estudio
                                             sitio_web VARCHAR(200) -- Página web oficial del estudio
);


-- Crear tabla juegos_plataformas (relación muchos a muchos entre juegos y plataformas)
CREATE TABLE IF NOT EXISTS juego_plataforma (
                                                id_juego VARCHAR(10),
                                                id_plataforma VARCHAR(10),
                                                PRIMARY KEY (id_juego, id_plataforma),
                                                FOREIGN KEY (id_juego) REFERENCES juego(id_juego) ON DELETE CASCADE,
                                                FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS juego_desarrollador (
                                                   id_juego VARCHAR(10), -- Identificador del juego
                                                   id_desarrollador VARCHAR(10), -- Identificador del desarrollador
                                                   FOREIGN KEY (id_juego) REFERENCES juego(id_juego) ON DELETE CASCADE,
                                                   FOREIGN KEY (id_desarrollador) REFERENCES desarrollador(id_desarrollador) ON DELETE CASCADE,
                                                   PRIMARY KEY (id_juego, id_desarrollador) -- Clave primaria compuesta para evitar duplicados
);


-- Crear tabla usuario
CREATE TABLE IF NOT EXISTS usuario (
                                       id_usuario VARCHAR(10) PRIMARY KEY,
                                       nombre_usuario VARCHAR(50) NOT NULL,
                                       email VARCHAR(100),
                                       pais VARCHAR(50),
                                       fecha_registro DATE,
                                       avatar_url VARCHAR(255), -- URL para el avatar del usuario
                                       telefono VARCHAR(15) -- Opcional para contacto
);

-- Crear tabla de relaciones de amistad
CREATE TABLE IF NOT EXISTS amistad (
                                       id_amigo1 VARCHAR(10),
                                       id_amigo2 VARCHAR(10),
                                       PRIMARY KEY (id_amigo1, id_amigo2),
                                       FOREIGN KEY (id_amigo1) REFERENCES usuario (id_usuario),
                                       FOREIGN KEY (id_amigo2) REFERENCES usuario (id_usuario)
);


-- Crear tabla reseña
CREATE TABLE IF NOT EXISTS resena (
                                      id_resena VARCHAR(10) PRIMARY KEY,
                                      id_juego VARCHAR(10),
                                      id_usuario VARCHAR(10),
                                      puntuacion INT,
                                      comentario TEXT,
                                      fecha DATE,
                                      FOREIGN KEY (id_juego) REFERENCES juego(id_juego) ON DELETE CASCADE,
                                      FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- Crear tabla compra
CREATE TABLE IF NOT EXISTS compra (
                                      id_compra VARCHAR(10) PRIMARY KEY,
                                      id_usuario VARCHAR(10),
                                      id_juego VARCHAR(10),
                                      fecha_compra DATE,
                                      metodo_pago VARCHAR(50), -- Método de pago (e.g., tarjeta, PayPal)
                                      FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
                                      FOREIGN KEY (id_juego) REFERENCES juego(id_juego) ON DELETE CASCADE
);

CREATE TABLE wishlist (
                          id_usuario VARCHAR(10),
                          id_juego VARCHAR(10),
                          fecha_agregado DATE,
                          PRIMARY KEY (id_usuario, id_juego),
                          FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
                          FOREIGN KEY (id_juego) REFERENCES juego(id_juego) ON DELETE CASCADE
);

-- Inserciones para la tabla genero
INSERT INTO genero (id_genero, nombre_genero, descripcion) VALUES
                                                               ('G001', 'Acción', 'Juegos con énfasis en habilidades físicas y reflejos rápidos.'),
                                                               ('G002', 'Aventura', 'Explora mundos abiertos y resuelve acertijos.'),
                                                               ('G003', 'RPG', 'Personaliza personajes y toma decisiones para progresar en la historia.'),
                                                               ('G004', 'Shooter', 'Enfocados en combates con armas, en primera o tercera persona.'),
                                                               ('G005', 'Estrategia', 'Planea y toma decisiones para lograr la victoria.'),
                                                               ('G006', 'Deportes', 'Simulaciones de deportes reales o fantásticos.'),
                                                               ('G007', 'Survival Horror', 'Enfrenta miedos y escasez de recursos para sobrevivir.'),
                                                               ('G008', 'Simulación', 'Recrea actividades de la vida real o fantasiosas.'),
                                                               ('G009', 'Plataformas', 'Saltos y exploración en niveles desafiantes.'),
                                                               ('G010', 'MOBA', 'Batallas estratégicas multijugador por equipos.'),
                                                               ('G011', 'Battle Royale', 'Sobrevive en combates masivos hasta ser el último en pie.'),
                                                               ('G012', 'Lucha', 'Compite en combates cuerpo a cuerpo contra un oponente.'),
                                                               ('G013', 'Carreras', 'Compite en circuitos de alta velocidad.'),
                                                               ('G014', 'Sigilo', 'Énfasis en el sigilo para completar misiones.'),
                                                               ('G015', 'Metroidvania', 'Explora mapas interconectados con progresión no lineal.'),
                                                               ('G016', 'Puzles', 'Resuelve desafíos intelectuales para avanzar.'),
                                                               ('G017', 'Roguelike', 'Explora mazmorras con niveles generados proceduralmente.'),
                                                               ('G018', 'Party', 'Juegos casuales y multijugador ideales para grupos.'),
                                                               ('G019', 'MMORPG', 'Juegos de rol masivos en línea.'),
                                                               ('G020', 'Ritmo', 'Sigue el ritmo y sincroniza tus acciones con la música.'),
                                                               ('G021', 'Survival', 'Supera desafíos y gestiona recursos para sobrevivir.'),
                                                               ('G022', 'Indie', 'Juegos independientes con estilos y mecánicas únicas.'),
                                                               ('G023', 'FPS', 'Juegos de disparos en primera persona.'),
                                                               ('G024', 'Terror', 'Crea una atmósfera para provocar miedo y tensión.'),
                                                               ('G025', 'Cooperativo', 'Diseñados para ser jugados en equipo.'),
                                                               ('G026', 'Aventura Gráfica', 'Narración interactiva con resolución de acertijos.'),
                                                               ('G027', 'Táctico', 'Estrategia en combates por turnos o en tiempo real.'),
                                                               ('G028', 'Exploración', 'Descubre ambientes desconocidos y secretos.'),
                                                               ('G029', 'Bullet Hell', 'Enfrenta oleadas de proyectiles en combates frenéticos.'),
                                                               ('G030', 'Sandbox', 'Libertad para construir y explorar.'),
                                                               ('G031', 'Arcade', 'Juegos rápidos y con mecánicas simples pero adictivas.');

-- Inserciones en la tabla juego
INSERT INTO juego (id_juego, titulo, descripcion, id_genero1, id_genero2, id_secuela, precio, fecha_lanzamiento, puntuacion, clasificacion_edad) VALUES
                                                                                                                                                     ('J0082', 'Hollow Knight: Silksong', 'Una secuela al aclamado juego de plataformas y metroidvania.', 'G015', 'G009', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0141', 'Final Fantasy VII Rebirth', 'La esperadísima nueva historia dentro del proyecto del remake de FINAL FANTASY VII.', 'G003', NULL, NULL, 69.99, '2024-02-29', 92, '+16'),
                                                                                                                                                     ('J0058', 'Forza Horizon 5', 'Carreras en mundo abierto ambientadas en México.', 'G013', NULL, NULL, 59.99, '2021-11-09', 92, '+3'),
                                                                                                                                                     ('J0062', 'The Legend of Zelda: Tears of the Kingdom', 'La secuela de Breath of the Wild con nuevas aventuras en Hyrule.', 'G002', 'G001', NULL, 69.99, '2023-05-12', 96, '+12'),
                                                                                                                                                     ('J0001', 'The Legend of Zelda: Breath of the Wild', 'Explora la vasta tierra de Hyrule.', 'G002', 'G001', 'J0062', 60.06, '2017-03-03', 97, '+12'),
                                                                                                                                                     ('J0002', 'God of War Ragnarök', 'Kratos y Atreus se embarcan en una épica travesía.', 'G002', 'G001', NULL, 48.24, '2022-11-09', 94, '+18'),
                                                                                                                                                     ('J0130', 'Like a Dragon Infinite Wealth', 'Dos héroes más grandes que la vida misma se unen guiados por el destino, o quizás, por algo más siniestro…', 'G003', NULL, NULL, 69.99, '2024-01-25', 89, '+18'),
                                                                                                                                                     ('J0003', 'Super Mario Odyssey', 'Una aventura global con Mario.', 'G009', NULL, NULL, 40.49, '2017-10-27', 97, '+7'),
                                                                                                                                                     ('J0073', 'Hades II', 'Secuela del popular roguelike basado en la mitología griega.', 'G017', NULL, NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0004', 'Hollow Knight', 'Explora las profundidades de un reino olvidado.', 'G015', 'G022', 'J0082', 16.68, '2017-02-24', 90, '+7'),
                                                                                                                                                     ('J0005', 'Celeste', 'Ayuda a Madeline a superar sus demonios internos en su viaje a la cima de la Montaña Celeste.', 'G009', NULL, NULL, 69.57, '2018-01-25', 94, '+7'),
                                                                                                                                                     ('J0006', 'Cuphead', 'Un juego clásico de correr y disparar con una estética de dibujos animados de los años 30.', 'G031', 'G009', NULL, 31.98, '2017-09-29', 86, '+7'),
                                                                                                                                                     ('J0007', 'Stardew Valley', 'Construye la granja de tus sueños.', 'G008', 'G030', NULL, 44.02, '2016-02-26', 89, '+7'),
                                                                                                                                                     ('J0008', 'Uncharted 4: A Thief\'s End', 'Sigue a Nathan Drake en su última aventura.', 'G002', 'G014', NULL, 38.75, '2016-05-10', 93, '+16'),
                                                                                                                                                     ('J0069', 'Marvel\'s Spider-Man 2', 'Peter Parker y Miles Morales unen fuerzas en esta nueva aventura.', 'G001', 'G002', NULL, 69.99, '2023-10-20', 91, '+16'),
                                                                                                                                                     ('J0009', 'Marvel\'s Spider-Man', 'Encárnate en la piel de una araña.', 'G001', 'G002', 'J0069', 34.97, '2018-09-07', 85, '+16'),
                                                                                                                                                     ('J0079', 'The Witcher 4', 'Una nueva aventura en el mundo de Geralt de Rivia.', 'G003', 'G002', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0010', 'Animal Crossing: New Horizons', 'Crea tu paraíso isleño ideal.', 'G008', 'G030', NULL, 34.11, '2020-03-20', 90, '+3'),
                                                                                                                                                     ('J0011', 'The Witcher 3: Wild Hunt', 'Una obra maestra de RPG de mundo abierto.', 'G003', 'G001', 'J0079', 46.34, '2015-05-19', 93, '+18'),
                                                                                                                                                     ('J0012', 'Fire Emblem: Three Houses', 'Lidera a un grupo de estudiantes hacia el éxito en un mundo al borde de la guerra.', 'G027', 'G003', NULL, 54.55, '2019-07-26', 89, '+12'),
                                                                                                                                                     ('J0013', 'Ori and the Will of the Wisps', 'Emprende una nueva aventura en un vasto mundo.', 'G002', 'G009', NULL, 10.67, '2020-03-11', 90, '+7'),
                                                                                                                                                     ('J0014', 'Monster Hunter: World', 'Únete a la caza y derriba monstruos gigantes.', 'G001', 'G021', NULL, 58.5, '2018-01-26', 90, '+16'),
                                                                                                                                                     ('J0015', 'Among Us', 'Encuentra al impostor en este juego de deducción social.', 'G011', 'G022', NULL, 28.08, '2018-06-15', 85, '+7'),
                                                                                                                                                     ('J0016', 'DOOM Eternal', 'Desgarra y destroza hordas de demonios.', 'G023', 'G007', NULL, 35.32, '2020-03-20', 88, '+18'),
                                                                                                                                                     ('J0017', 'The Last of Us Part II', 'Ellie continúa su viaje en un mundo peligroso.', 'G007', 'G002', NULL, 14.77, '2020-06-19', 93, '+18'),
                                                                                                                                                     ('J0018', 'Splatoon 3', 'Un vibrante shooter multijugador con mecánicas únicas.', 'G004', 'G011', NULL, 64.87, '2022-09-09', 83, '+7'),
                                                                                                                                                     ('J0019', 'Hades', 'Lucha para salir del infierno en este roguelike.', 'G017', 'G003', 'J0073', 55.25, '2020-09-17', 93, '+12'),
                                                                                                                                                     ('J0020', 'Disco Elysium', 'Un revolucionario juego de rol.', 'G003', NULL, NULL, 42.89, '2019-10-15', 91, '+18'),
                                                                                                                                                     ('J0021', 'Elden Ring', 'Una nueva épica aventura de FromSoftware.', 'G003', 'G002', NULL, 15.4, '2022-02-25', 96, '+16'),
                                                                                                                                                     ('J0022', 'Xenoblade Chronicles 3', 'Descubre la verdad de un mundo dividido.', 'G003', 'G002', NULL, 37.14, '2022-07-29', 89, '+12'),
                                                                                                                                                     ('J0023', 'Minecraft Dungeons', 'Lucha en una nueva aventura de acción.', 'G001', 'G009', NULL, 65.91, '2020-05-26', 70, '+7'),
                                                                                                                                                     ('J0024', 'Fall Guys', 'El juego de fiesta definitivo.', 'G018', NULL, NULL, 62.68, '2020-08-04', 80, '+3'),
                                                                                                                                                     ('J0025', 'Forza Horizon 4', 'Experimenta las estaciones cambiantes en Gran Bretaña.', 'G013', NULL, 'J0058', 12.33, '2018-10-02', 92, '+3'),
                                                                                                                                                     ('J0026', 'Rocket League', 'Fútbol y coches se combinan en este juego lleno de acción.', 'G013', 'G006', NULL, 14.37, '2015-07-07', 86, '+3'),
                                                                                                                                                     ('J0027', 'Journey', 'Una emotiva aventura a través de un hermoso desierto.', 'G002', NULL, NULL, 18.08, '2012-03-13', 92, '+7'),
                                                                                                                                                     ('J0028', 'Inside', 'Un oscuro juego de plataformas narrativo.', 'G009', 'G024', NULL, 19.8, '2016-06-29', 91, '+18'),
                                                                                                                                                     ('J0029', 'Little Nightmares', 'Una aventura llena de suspense con visuales oscuros y encantadores.', 'G024', 'G009', NULL, 42.4, '2017-04-28', 81, '+16'),
                                                                                                                                                     ('J0030', 'Portal 2', 'Un juego de puzzles alucinante con humor y agudeza.', 'G016', 'G009', NULL, 39.43, '2011-04-19', 95, '+12'),
                                                                                                                                                     ('J0031', 'Final Fantasy VII Remake', 'Una reinvención del clásico RPG.', 'G003', NULL, 'J0141', 36.29, '2020-04-10', 87, '+16'),
                                                                                                                                                     ('J0032', 'Persona 5 Royal', 'Un elegante y profundo RPG.', 'G003', NULL, NULL, 28.99, '2020-03-31', 95, '+16'),
                                                                                                                                                     ('J0033', 'Tunic', 'Explora un reino plagado de leyendas olvidadas.', 'G002', 'G009', NULL, 36.52, '2022-03-16', 85, '+7'),
                                                                                                                                                     ('J0034', 'Sekiro: Shadows Die Twice', 'Un juego de acción y aventura brutal y hermoso.', 'G001', 'G002', NULL, 48.08, '2019-03-22', 90, '+18'),
                                                                                                                                                     ('J0035', 'Yakuza Like a Dragon', 'Lucha por conocer la verdad.', 'G003', NULL, 'J0130', 47.31, '2020-11-10', 84, '+18'),
                                                                                                                                                     ('J0036', 'Cyberpunk 2077', 'Un RPG futurista ambientado en una ciudad expansiva.', 'G003', 'G021', NULL, 62.22, '2020-12-10', 86, '+18'),
                                                                                                                                                     ('J0037', 'Dead Cells', 'Un juego de acción rogue-lite inspirado en metroidvania.', 'G017', 'G015', NULL, 36.96, '2018-08-07', 91, '+16'),
                                                                                                                                                     ('J0038', 'Outer Wilds', 'Un misterio sobre un sistema solar atrapado en un bucle temporal infinito.', 'G002', 'G028', NULL, 66.39, '2019-05-28', 85, '+7'),
                                                                                                                                                     ('J0039', 'No Man\'s Sky', 'Explora un universo infinito.', 'G002', 'G030', NULL, 13.49, '2016-08-09', 61, '+7'),
                                                                                                                                                     ('J0040', 'Bloodborne', 'Un RPG de acción de pesadilla ambientado en una ciudad maldita.', 'G007', 'G003', NULL, 68.78, '2015-03-24', 92, '+16'),
                                                                                                                                                     ('J0041', 'It Takes Two', 'Una aventura cooperativa de plataformas.', 'G025', 'G002', NULL, 56.78, '2021-03-26', 88, '+12'),
                                                                                                                                                     ('J0042', 'Mario Kart 8 Deluxe', 'La experiencia definitiva de carreras de karts.', 'G013', 'G018', NULL, 66.47, '2017-04-28', 92, '+3'),
                                                                                                                                                     ('J0043', 'Super Smash Bros. Ultimate', 'El crossover definitivo de juegos de lucha.', 'G012', NULL, NULL, 32.57, '2018-12-07', 93, '+12'),
                                                                                                                                                     ('J0044', 'Apex Legends', 'Un juego battle royale gratuito.', 'G011', 'G004', NULL, 30.44, '2019-02-04', 89, '+16'),
                                                                                                                                                     ('J0045', 'Overwatch', 'Shooter multijugador basado en equipos con héroes.', 'G004', 'G025', NULL, 58.06, '2016-05-24', 91, '+12'),
                                                                                                                                                     ('J0046', 'League of Legends', 'El popular juego MOBA.', 'G010', NULL, NULL, 41.69, '2009-10-27', 78, '+12'),
                                                                                                                                                     ('J0047', 'Fortnite', 'Construye y lucha para lograr la victoria.', 'G011', 'G008', NULL, 56.28, '2017-07-25', 81, '+12'),
                                                                                                                                                     ('J0048', 'Valorant', 'Un shooter táctico de Riot Games.', 'G004', 'G023', NULL, 12.54, '2020-06-02', 80, '+16'),
                                                                                                                                                     ('J0049', 'Call of Duty: Modern Warfare', 'El regreso de la icónica franquicia de shooters.', 'G023', 'G004', NULL, 28.03, '2019-10-25', 81, '+18'),
                                                                                                                                                     ('J0050', 'Resident Evil Village', 'Sobrevive en un nuevo capítulo de horror de supervivencia.', 'G007', NULL, NULL, 42.29, '2021-05-07', 84, '+18'),
                                                                                                                                                     ('J0051', 'Metroid Dread', 'Samus Aran enfrenta una nueva amenaza en el planeta ZDR.', 'G001', 'G002', NULL, 59.99, '2021-10-08', 88, '+12'),
                                                                                                                                                     ('J0052', 'Ratchet & Clank: Rift Apart', 'Una aventura interdimensional con Ratchet y Clank.', 'G001', 'G002', NULL, 69.99, '2021-06-11', 88, '+12'),
                                                                                                                                                     ('J0053', 'Halo Infinite', 'El Jefe Maestro regresa para confrontar al enemigo más despiadado.', 'G004', 'G001', NULL, 59.99, '2021-12-08', 80, '+16'),
                                                                                                                                                     ('J0054', 'Returnal', 'Una exploradora espacial atrapada en un ciclo temporal en un planeta alienígena.', 'G007', 'G002', NULL, 69.99, '2021-04-30', 86, '+16'),
                                                                                                                                                     ('J0055', 'Kena: Bridge of Spirits', 'Una guía espiritual en una aventura mágica para descubrir los secretos de una aldea olvidada.', 'G002', 'G009', NULL, 39.99, '2021-09-21', 81, '+12'),
                                                                                                                                                     ('J0056', 'Psychonauts 2', 'Únete a Raz en una misión para salvar al mundo de amenazas psíquicas.', 'G002', 'G003', NULL, 59.99, '2021-08-25', 89, '+12'),
                                                                                                                                                     ('J0057', 'Deathloop', 'Dos asesinos rivales atrapados en un bucle temporal en la isla de Blackreef.', 'G001', 'G004', NULL, 59.99, '2021-09-14', 88, '+18'),
                                                                                                                                                     ('J0059', 'Resident Evil 4 Remake', 'Una reimaginación del clásico juego de terror y supervivencia.', 'G007', NULL, NULL, 59.99, '2023-03-24', 93, '+18'),
                                                                                                                                                     ('J0060', 'Hogwarts Legacy', 'Un RPG de mundo abierto ambientado en el universo de Harry Potter.', 'G003', 'G002', NULL, 69.99, '2023-02-10', 85, '+16'),
                                                                                                                                                     ('J0061', 'Starfield', 'Una épica aventura espacial en un vasto universo.', 'G003', 'G002', NULL, 69.99, '2023-09-06', 83, '+18'),
                                                                                                                                                     ('J0063', 'Final Fantasy XVI', 'Una nueva entrada en la aclamada serie de RPG.', 'G003', 'G001', NULL, 69.99, '2023-06-22', 87, '+18'),
                                                                                                                                                     ('J0064', 'Street Fighter 6', 'La última entrega del icónico juego de lucha.', 'G012', NULL, NULL, 59.99, '2023-06-02', 92, '+12'),
                                                                                                                                                     ('J0065', 'Diablo IV', 'El regreso del aclamado RPG de acción en un oscuro mundo de fantasía.', 'G003', NULL, NULL, 69.99, '2023-06-06', 91, '+18'),
                                                                                                                                                     ('J0066', 'Baldur\'s Gate III', 'Un RPG basado en el universo de Dungeons & Dragons.', 'G003', NULL, NULL, 59.99, '2023-08-03', 96, '+18'),
                                                                                                                                                     ('J0067', 'Assassin\'s Creed Mirage', 'Una nueva aventura en la serie de asesinos.', 'G002', 'G014', NULL, 59.99, '2023-10-05', 80, '+18'),
                                                                                                                                                     ('J0068', 'Alan Wake II', 'Una secuela al thriller psicológico original.', 'G007', 'G002', NULL, 59.99, '2023-10-17', 89, '+18'),
                                                                                                                                                     ('J0070', 'EA Sports FC 24', 'La última entrega del popular simulador de fútbol.', 'G006', NULL, NULL, 59.99, '2023-09-29', 79, '+3'),
                                                                                                                                                     ('J0071', 'Call of Duty: Black Ops 6', 'La continuación de la serie de shooters en primera persona.', 'G023', NULL, NULL, 69.99, '2024-10-25', 83, '+18'),
                                                                                                                                                     ('J0072', 'Elden Ring: Shadow of the Erdtree', 'Expansión del aclamado juego de rol.', 'G001', 'G002', NULL, 29.99, '2024-02-28', 94, '+16'),
                                                                                                                                                     ('J0074', 'Metroid Prime 4', 'La cazarrecompensas Samus Aran regresa en una nueva misión.', 'G001', 'G002', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0075', 'Fable', 'Un reinicio de la clásica serie de RPG de acción.', 'G003', 'G002', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0076', 'The Elder Scrolls VI', 'La próxima entrega en la serie de RPG de mundo abierto.', 'G003', NULL, NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0077', 'Grand Theft Auto VI', 'La esperada nueva entrega de la serie de mundo abierto.', 'G002', 'G001', NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0078', 'Star Wars: Knights of the Old Republic Remake', 'Una reimaginación del clásico RPG ambientado en el universo de Star Wars.', 'G003', NULL, NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0080', 'Dragon Age: The Veilguard', 'Una nueva aventura en el continente de Thedas.', 'G003', 'G002', NULL, 69.99, '2024-10-31', 82, '+18'),
                                                                                                                                                     ('J0081', 'Perfect Dark', 'Un reinicio de la clásica serie de acción en primera persona.', 'G004', NULL, NULL, NULL, NULL, NULL, NULL),
                                                                                                                                                     ('J0083', 'Avowed', 'Un RPG de fantasía épica en el mundo de Eora.', 'G003', 'G002', NULL, NULL, '2025-02-18', NULL, NULL),
                                                                                                                                                     ('J0084', 'Hellblade II: Senua\'s Saga', 'Una aventura emocional en un mundo oscuro.', 'G003', 'G007', NULL, 59.99, '2024-05-21', 81, '+18'),
                                                                                                                                                     ('J0085', 'Stalker 2: Heart of Chernobyl', 'Un juego de supervivencia en la zona de exclusión de Chernóbil.', 'G021', NULL, NULL, 59.99, '2024-11-20', 73, '+18'),
                                                                                                                                                     ('J0086', 'Redfall', 'Un shooter cooperativo contra vampiros.', 'G004', 'G025', NULL, 59.99, '2022-05-02', 56, '+18'),
                                                                                                                                                     ('J0087', 'Death Stranding', 'El legendario Hideo Kojima nos ofrece una experiencia que desafía los géneros.', 'G003', 'G002', NULL, 69.99, '2019-11-08', 82, '+18'),
                                                                                                                                                     ('J0088', 'Stray', 'Un gato callejero desentraña un antiguo misterio para escapar de una ciudad cibernética olvidada.', 'G002', NULL, NULL, 29.99, '2022-07-19', 84, '+12'),
                                                                                                                                                     ('J0089', 'Sifu', 'Un joven artista marcial en busca de venganza contra los asesinos de su familia.', 'G001', 'G004', NULL, 39.99, '2022-02-08', 81, '+16'),
                                                                                                                                                     ('J0090', 'Kirby and the Forgotten Land', 'Kirby explora un misterioso mundo en ruinas.', 'G009', 'G002', NULL, 59.99, '2022-03-25', 85, '+7'),
                                                                                                                                                     ('J0091', 'Bayonetta 3', 'La bruja de Umbra regresa para enfrentar nuevas amenazas.', 'G001', 'G002', NULL, 59.99, '2022-10-28', 87, '+16'),
                                                                                                                                                     ('J0092', 'Mario + Rabbids Sparks of Hope', 'Mario y los Rabbids unen fuerzas en una nueva aventura galáctica.', 'G005', 'G002', NULL, 59.99, '2022-10-20', 85, '+7'),
                                                                                                                                                     ('J0093', 'The Callisto Protocol', 'Un juego de terror y supervivencia ambientado en una colonia espacial.', 'G024', 'G007', NULL, 59.99, '2022-12-02', 71, '+18'),
                                                                                                                                                     ('J0094', 'A Plague Tale: Requiem', 'Una historia de supervivencia en una Francia medieval devastada por la peste.', 'G002', 'G007', NULL, 59.99, '2022-10-18', 83, '+18'),
                                                                                                                                                     ('J0095', 'Gotham Knights', 'Los protegidos de Batman defienden Gotham tras su desaparición.', 'G001', 'G004', NULL, 69.99, '2022-10-21', 67, '+16'),
                                                                                                                                                     ('J0096', 'Dying Light 2 Stay Human', 'Sobrevive en una ciudad postapocalíptica infestada de zombis.', 'G021', NULL, NULL, 59.99, '2022-02-04', 76, '+18'),
                                                                                                                                                     ('J0097', 'Ghostwire: Tokyo', 'Una visión sobrenatural de Tokio donde los espíritus han invadido la ciudad.', 'G024', 'G002', NULL, 59.99, '2022-03-25', 77, '+16'),
                                                                                                                                                     ('J0098', 'Triangle Strategy', 'Un juego de rol táctico con decisiones que afectan la historia.', 'G005', 'G027', NULL, 59.99, '2022-03-04', 82, '+12'),
                                                                                                                                                     ('J0099', 'Live A Live', 'Un remake en HD-2D del clásico RPG.', 'G003', 'G002', NULL, 49.99, '2022-07-22', 81, '+12'),
                                                                                                                                                     ('J0100', 'The Quarry', 'Un grupo de adolescentes en un campamento de verano enfrentan una noche de terror.', 'G024', 'G007', NULL, 59.99, '2022-06-10', 80, '+18'),
                                                                                                                                                     ('J0101', 'Cult of the Lamb', 'Un cordero poseído crea su propio culto en un mundo de falsos profetas.', 'G017', 'G002', NULL, 24.99, '2022-08-11', 84, '+12'),
                                                                                                                                                     ('J0102', 'Neon White', 'Un asesino del infierno compite por la redención en el cielo.', 'G001', 'G002', NULL, 24.99, '2022-06-16', 88, '+12'),
                                                                                                                                                     ('J0103', 'Ori and the Blind Forest', 'Una emotiva aventura de plataformas en un bosque mágico.', 'G009', NULL, 'J0013', 19.99, '2015-03-11', 88, '+7'),
                                                                                                                                                     ('J0104', 'Undertale', 'Un RPG donde las decisiones importan y puedes elegir no matar a ningún enemigo.', 'G003', NULL, NULL, 9.99, '2015-09-15', 92, '+7'),
                                                                                                                                                     ('J0105', 'The Witness', 'Un juego de puzles en una isla misteriosa llena de desafíos.', 'G016', NULL, NULL, 39.99, '2016-01-26', 87, '+7'),
                                                                                                                                                     ('J0106', 'Cocoon', 'Te lleva a una aventura a través de mundos dentro de mundos.', 'G009', NULL, NULL, 19.99, '2023-09-29', NULL, '+7'),
                                                                                                                                                     ('J0107', 'Super Meat Boy', 'Un juego de plataformas ultra-difícil donde controlas a un trozo de carne en busca de su amada.', 'G009', NULL, NULL, 14.99, '2010-10-20', 87, '+12'),
                                                                                                                                                     ('J0108', 'Bastion', 'Un RPG de acción con una narrativa envolvente y un hermoso estilo artístico.', 'G003', NULL, NULL, 14.99, '2011-07-20', 89, '+12'),
                                                                                                                                                     ('J0109', 'Limbo', 'Un juego de plataformas y puzles en blanco y negro con una atmósfera inquietante.', 'G009', 'G016', NULL, 9.99, '2010-07-21', 88, '+16'),
                                                                                                                                                     ('J0110', 'Shovel Knight', 'Un juego de plataformas retro donde controlas a un caballero con una pala.', 'G009', NULL, NULL, 24.99, '2014-06-26', 90, '+7'),
                                                                                                                                                     ('J0111', 'Returnal', 'Una exploradora espacial atrapada en un ciclo temporal en un planeta alienígena.', 'G007', 'G002', NULL, 69.99, '2021-04-30', 86, '+16'),
                                                                                                                                                     ('J0112', 'Slay the Spire', 'Un juego de construcción de mazos y roguelike donde asciendes por una torre llena de enemigos.', 'G017', NULL, NULL, 24.99, '2019-01-23', 89, '+7'),
                                                                                                                                                     ('J0113', 'Gris', 'Una experiencia narrativa y visual sobre una joven en su propio mundo.', 'G009', NULL, NULL, 16.99, '2018-12-13', 84, '+7'),
                                                                                                                                                     ('J0114', 'Katana Zero', 'Un juego de acción y plataformas con combates rápidos y una narrativa intrigante.', 'G001', 'G009', NULL, 14.99, '2019-04-18', 83, '+18'),
                                                                                                                                                     ('J0115', 'The Binding of Isaac: Rebirth', 'Un roguelike de acción y disparos con niveles generados al azar.', 'G017', 'G024', NULL, 14.99, '2014-11-04', 86, '+16'),
                                                                                                                                                     ('J0116', 'Oxenfree', 'Una aventura narrativa sobre un grupo de amigos que abren una grieta fantasmal.', 'G027', NULL, NULL, 9.99, '2016-01-15', 85, '+12'),
                                                                                                                                                     ('J0117', 'Firewatch', 'Un juego de aventura en primera persona centrado en la narrativa y la exploración.', 'G027', NULL, NULL, 19.99, '2016-02-09', 85, '+12'),
                                                                                                                                                     ('J0118', 'SOMA', 'Un juego de terror y ciencia ficción que explora la identidad y la conciencia.', 'G024', 'G007', NULL, 29.99, '2015-09-22', 84, '+18'),
                                                                                                                                                     ('J0119', 'God of War', 'En este mundo cruel e implacable debe luchar para sobrevivir...', 'G002', 'G001', 'J0002', 28.24, '2018-04-20', 94, '+18'),
                                                                                                                                                     ('J0120', 'Shantae and the Seven Sirens', 'Una nueva aventura con la genio favorita de todos.', 'G009', NULL, NULL, 29.99, '2020-05-28', 81, '+7'),
                                                                                                                                                     ('J0121', 'Horizon Forbidden West', 'Explora un vasto mundo lleno de máquinas y misterios.', 'G002', 'G001', NULL, 69.99, '2022-02-18', 88, '+16'),
                                                                                                                                                     ('J0122', 'Death\'s Door', 'Explora una tierra llena de criaturas y secretos mientras recolectas almas.', 'G009', 'G002', NULL, 19.99, '2021-07-20', 88, '+12'),
                                                                                                                                                     ('J0123', 'Eastward', 'Un RPG con una narrativa envolvente y un hermoso pixel art.', 'G003', NULL, NULL, 24.99, '2021-09-16', 82, '+12'),
                                                                                                                                                     ('J0124', 'Chicory: A Colorful Tale', 'Un juego de aventuras donde usas un pincel mágico para explorar y resolver puzzles.', 'G009', 'G016', NULL, 19.99, '2021-06-10', 90, '+3'),
                                                                                                                                                     ('J0125', 'Luigi\'s Mansion 3', 'Únete a Luigi, un héroe de lo más cobardica, en una aventura fantasmagórica.', 'G024', 'G002', NULL, 59.99, '2019-10-31', 86, '+7'),
                                                                                                                                                     ('J0126', 'Papers, Please', 'Un juego de simulación donde trabajas como inspector de inmigración.', 'G008', NULL, NULL, 9.99, '2013-08-08', 85, '+16'),
                                                                                                                                                     ('J0127', 'Vampire Survivors', 'Enfréntate a hordas infinitas de enemigos mientras recolectas habilidades.', 'G017', NULL, NULL, 3.99, '2021-12-17', 88, '+12'),
                                                                                                                                                     ('J0128', 'Terraria', 'Explora, cava, construye y lucha en un mundo generado procedimentalmente.', 'G030', 'G008', NULL, 9.99, '2011-05-16', 83, '+12'),
                                                                                                                                                     ('J0129', 'Factorio', 'Construye y administra fábricas automatizadas en un mundo alienígena.', 'G008', NULL, NULL, 29.99, '2020-08-14', 90, '+7'),
                                                                                                                                                     ('J0131', '13 Sentinels: Aegis Rim', 'Disfruta de esta aventura con desplazamiento lateral en 2D con unos escenarios y un estilo artístico espectaculares y revela los misterios que esconde esta historia.', 'G003', 'G002', NULL, 34.99, '2019-11-28', 89, '+16'),
                                                                                                                                                     ('J0132', 'Red Dead Redemption II', 'Épica historia de Arthur Morgan y la banda de Van der Linde.', 'G002', 'G001', NULL, 24.99, '2018-10-26', 97, '+18'),
                                                                                                                                                     ('J0133', 'The Forest', 'Sobrevive en un bosque lleno de misterios y peligros sobrenaturales.', 'G021', NULL, NULL, 19.99, '2018-04-30', 83, '+18'),
                                                                                                                                                     ('J0134', 'Project Zomboid', 'Un simulador de supervivencia en un apocalipsis zombi.', 'G021', 'G008', NULL, 14.99, '2013-11-08', 80, '+18'),
                                                                                                                                                     ('J0135', 'Minecraft', 'Explora mundos generados aleatoriamente y construye cosas maravillosas, desde una simple casa hasta un fastuoso castillo.', 'G030', 'G008', NULL, 19.99, '2009-05-17', 93, '+7'),
                                                                                                                                                     ('J0136', 'Subnautica', 'Explora un océano alienígena mientras gestionas recursos y sobrevives.', 'G021', NULL, NULL, 29.99, '2018-01-23', 87, '+7'),
                                                                                                                                                     ('J0137', 'A Hat in Time', 'A Hat in Time es un plataformas en 3D mono hasta decir basta.', 'G009', NULL, NULL, 28.99, '2017-10-05', 79, '+7'),
                                                                                                                                                     ('J0138', 'Tinykin', '¡Atrapa cientos de tinykin y usa sus poderes especiales para llevar a Milo de vuelta a su planeta natal y a su tamaño normal!', 'G009', NULL, NULL, 24.50, '2022-08-30', 78, '+3'),
                                                                                                                                                     ('J0139', 'Super Mario Bros. Wonder', '¡Únete a Mario y sus amigos en una nueva y maravillosa aventura de desplazamiento lateral en 2D!', 'G009', NULL, NULL, 59.99, '2023-10-20', 92, '+3'),
                                                                                                                                                     ('J0140', 'Darkest Dungeon', 'Un desafiante RPG por turnos con temática gótica.', 'G003', 'G007', NULL, 24.99, '2016-01-19', 84, '+16'),
                                                                                                                                                     ('J0142', 'Paper Mario: The Thousand-Year Door', '¡Una historia clásica comienza a desplegarse en la consola Nintendo Switch!', 'G003', 'G015', NULL, 59.99, '2024-05-23', 88, '+7'),
                                                                                                                                                     ('J0143', 'Satisfactory', 'Construye fábricas masivas en un mundo alienígena.', 'G008', 'G030', NULL, 29.99, '2020-06-08', 85, '+7'),
                                                                                                                                                     ('J0144', 'Hi-Fi RUSH', 'Siente el ritmo y acompaña a Chai y a su grupo en su lucha contra una malvada empresa en un mundo sincronizado con la música.', 'G020', 'G009', NULL, 29.99, '2023-01-25', 87, '+12'),
                                                                                                                                                     ('J0145', 'Astro Bot', 'En tu travesía, aprovecha al máximo los nuevos poderes de ASTRO y reúnete con cantidad de héroes emblemáticos del universo PlayStation.', 'G009', NULL, NULL, 69.99, '2024-09-06', 94, '+7'),
                                                                                                                                                     ('J0146', 'Judgment', 'Lucha por la verdad y descubre el retorcido crimen que se esconde bajo las calles de Tokio.', 'G002', 'G014', NULL, 39.99, '2018-12-13', 80, '+18'),
                                                                                                                                                     ('J0147', 'Metaphor: ReFantazio', 'El trono está vacío tras el asesinato del rey.', 'G003', NULL, NULL, 69.99, '2024-10-11', 94, '+16'),
                                                                                                                                                     ('J0148', 'NieR: Automata', 'Vive la historia de unos androides para recuperar un mundo dominado por las máquinas.', 'G003', NULL, NULL, 39.99, '2017-03-17', 88, '+18'),
                                                                                                                                                     ('J0149', 'Pikmin 4', '¡Los Pikmin regresan para emprender otra gran misión!', 'G030', NULL, NULL, 23.99, '2023-07-21', 87, '+12'),
                                                                                                                                                     ('J0150', 'Grand Theft Auto V', 'Un joven estafador callejero, un ladrón de bancos retirado y un psicópata aterrador se ven involucrados con lo peor y más desquiciado del mundo criminal.', 'G001', 'G002', 'J0077', 39.99, '2013-09-17', 97, '+18');

-- Inserciones para la tabla plataforma
INSERT INTO plataforma (id_plataforma, nombre_plataforma, fabricante, fecha_lanzamiento) VALUES
                                                                                             ('P001', 'PlayStation 3', 'Sony', '2006-11-11'),
                                                                                             ('P002', 'PlayStation 4', 'Sony', '2013-11-15'),
                                                                                             ('P003', 'PlayStation 5', 'Sony', '2020-11-12'),
                                                                                             ('P004', 'Xbox 360', 'Microsoft', '2005-11-22'),
                                                                                             ('P005', 'Xbox One', 'Microsoft', '2013-11-22'),
                                                                                             ('P006', 'Xbox Series X/S', 'Microsoft', '2020-11-10'),
                                                                                             ('P007', 'Nintendo Wii', 'Nintendo', '2006-11-19'),
                                                                                             ('P008', 'Nintendo Wii U', 'Nintendo', '2012-11-18'),
                                                                                             ('P009', 'Nintendo Switch', 'Nintendo', '2017-03-03'),
                                                                                             ('P010', 'PC', 'Microsoft', NULL);

-- Inserciones para la tabla juego_plataforma
INSERT INTO juego_plataforma (id_juego, id_plataforma) VALUES
-- The Legend of Zelda: Breath of the Wild
('J0001', 'P008'), -- Nintendo Wii U
('J0001', 'P009'), -- Nintendo Switch
-- God of War Ragnarök
('J0002', 'P003'), -- PlayStation 5
('J0002', 'P002'), -- PlayStation 4
('J0002', 'P010'), -- PC
-- Super Mario Odyssey
('J0003', 'P009'), -- Nintendo Switch
-- Hollow Knight
('J0004', 'P009'), -- Nintendo Switch
('J0004', 'P010'), -- PC
('J0004', 'P005'), -- Xbox One
('J0004', 'P002'), -- PlayStation 4
-- Celeste
('J0005', 'P010'), -- PC
('J0005', 'P005'), -- Xbox One
('J0005', 'P002'), -- PlayStation 4
('J0005', 'P009'), -- Nintendo Switch
-- Cuphead
('J0006', 'P010'), -- PC
('J0006', 'P005'), -- Xbox One
('J0006', 'P009'), -- Nintendo Switch
('J0006', 'P002'), -- PlayStation 4
-- Stardew Valley
('J0007', 'P009'), -- Nintendo Switch
('J0007', 'P010'), -- PC
('J0007', 'P002'), -- PlayStation 4
('J0007', 'P005'), -- Xbox One
-- Uncharted 4: A Thief's End
('J0008', 'P002'), -- PlayStation 4
-- Marvel's Spider-Man: Miles Morales
('J0009', 'P002'), -- PlayStation 4
-- Animal Crossing: New Horizons
('J0010', 'P009'), -- Nintendo Switch
-- The Witcher 3: Wild Hunt
('J0011', 'P010'), -- PC
('J0011', 'P005'), -- Xbox One
('J0011', 'P002'), -- PlayStation 4
('J0011', 'P003'), -- PlayStation 5
('J0011', 'P009'), -- Nintendo Switch
-- Fire Emblem: Three Houses
('J0012', 'P009'), -- Nintendo Switch
-- Ori and the Will of the Wisps
('J0013', 'P010'), -- PC
('J0013', 'P005'), -- Xbox One
('J0013', 'P009'), -- Nintendo Switch
-- Monster Hunter: World
('J0014', 'P010'), -- PC
('J0014', 'P005'), -- Xbox One
('J0014', 'P002'), -- PlayStation 4
-- Among Us
('J0015', 'P010'), -- PC
('J0015', 'P009'), -- Nintendo Switch
('J0015', 'P005'), -- Xbox One
('J0015', 'P002'), -- PlayStation 4
-- DOOM Eternal
('J0016', 'P010'), -- PC
('J0016', 'P005'), -- Xbox One
('J0016', 'P002'), -- PlayStation 4
('J0016', 'P006'), -- Xbox Series X/S
('J0016', 'P003'), -- PlayStation 5
('J0016', 'P009'), -- Nintendo Switch
-- The Last of Us Part II
('J0017', 'P002'), -- PlayStation 4
('J0017', 'P003'), -- PlayStation 5
-- Splatoon 3
('J0018', 'P009'), -- Nintendo Switch
-- Hades
('J0019', 'P010'), -- PC
('J0019', 'P005'), -- Xbox One
('J0019', 'P002'), -- PlayStation 4
('J0019', 'P003'), -- PlayStation 5
('J0019', 'P009'), -- Nintendo Switch
-- Disco Elysium
('J0020', 'P010'), -- PC
('J0020', 'P005'), -- Xbox One
('J0020', 'P002'), -- PlayStation 4
('J0020', 'P009'), -- Nintendo Switch
-- Elden Ring
('J0021', 'P010'), -- PC
('J0021', 'P005'), -- Xbox One
('J0021', 'P006'), -- Xbox Series X/S
('J0021', 'P002'), -- PlayStation 4
('J0021', 'P003'), -- PlayStation 5
-- Xenoblade Chronicles 3
('J0022', 'P009'), -- Nintendo Switch
-- Minecraft Dungeons
('J0023', 'P010'), -- PC
('J0023', 'P005'), -- Xbox One
('J0023', 'P002'), -- PlayStation 4
('J0023', 'P009'), -- Nintendo Switch
-- Fall Guys
('J0024', 'P010'), -- PC
('J0024', 'P002'), -- PlayStation 4
('J0024', 'P005'), -- Xbox One
('J0024', 'P009'), -- Nintendo Switch
-- Forza Horizon 4
('J0025', 'P010'), -- PC
('J0025', 'P005'), -- Xbox One
-- Rocket League
('J0026', 'P010'), -- PC
('J0026', 'P005'), -- Xbox One
('J0026', 'P006'), -- Xbox Series X/S
('J0026', 'P002'), -- PlayStation 4
('J0026', 'P003'), -- PlayStation 5
('J0026', 'P009'), -- Nintendo Switch
-- Journey
('J0027', 'P002'), -- PlayStation 4
('J0027', 'P001'), -- PlayStation 3
-- Inside
('J0028', 'P010'), -- PC
('J0028', 'P005'), -- Xbox One
('J0028', 'P002'), -- PlayStation 4
('J0028', 'P009'), -- Nintendo Switch
-- Little Nightmares
('J0029', 'P010'), -- PC
('J0029', 'P005'), -- Xbox One
('J0029', 'P002'), -- PlayStation 4
('J0029', 'P009'), -- Nintendo Switch
-- Portal 2
('J0030', 'P010'), -- PC
('J0030', 'P004'), -- Xbox 360
('J0030', 'P001'), -- PlayStation 3
-- Final Fantasy VII Remake
('J0031', 'P002'), -- PlayStation 4
('J0031', 'P003'), -- PlayStation 5
-- Persona 5 Royal
('J0032', 'P002'), -- PlayStation 4
('J0032', 'P003'), -- PlayStation 5
('J0032', 'P009'), -- Nintendo Switch
('J0032', 'P006'), -- Xbox Series X/S
-- Tunic
('J0033', 'P010'), -- PC
('J0033', 'P005'), -- Xbox One
('J0033', 'P006'), -- Xbox Series X/S
('J0033', 'P009'), -- Nintendo Switch
('J0033', 'P002'), -- PlayStation 4
('J0033', 'P003'), -- PlayStation 5
-- Sekiro: Shadows Die Twice
('J0034', 'P010'), -- PC
('J0034', 'P005'), -- Xbox One
('J0034', 'P002'), -- PlayStation 4
-- Yakuza Like a Dragon
('J0035', 'P010'), -- PC
('J0035', 'P005'), -- Xbox One
('J0035', 'P006'), -- Xbox Series X/S
('J0035', 'P002'), -- PlayStation 4
('J0035', 'P003'), -- PlayStation 5
-- Cyberpunk 2077
('J0036', 'P010'), -- PC
('J0036', 'P005'), -- Xbox One
('J0036', 'P006'), -- Xbox Series X/S
('J0036', 'P002'), -- PlayStation 4
('J0036', 'P003'), -- PlayStation 5
-- Dead Cells
('J0037', 'P010'), -- PC
('J0037', 'P005'), -- Xbox One
('J0037', 'P002'), -- PlayStation 4
('J0037', 'P003'), -- PlayStation 5
('J0037', 'P009'), -- Nintendo Switch
-- Outer Wilds
('J0038', 'P010'), -- PC
('J0038', 'P005'), -- Xbox One
('J0038', 'P006'), -- Xbox Series X/S
('J0038', 'P002'), -- PlayStation 4
('J0038', 'P003'), -- PlayStation 5
('J0038', 'P009'), -- Nintendo Switch
-- No Man's Sky
('J0039', 'P010'), -- PC
('J0039', 'P005'), -- Xbox One
('J0039', 'P006'), -- Xbox Series X/S
('J0039', 'P002'), -- PlayStation 4
('J0039', 'P003'), -- PlayStation 5
('J0039', 'P009'), -- Nintendo Switch
-- Bloodborne
('J0040', 'P002'), -- PlayStation 4
-- It Takes Two
('J0041', 'P010'), -- PC
('J0041', 'P005'), -- Xbox One
('J0041', 'P006'), -- Xbox Series X/S
('J0041', 'P002'), -- PlayStation 4
('J0041', 'P003'), -- PlayStation 5
('J0041', 'P009'), -- Nintendo Switch
-- Mario Kart 8 Deluxe
('J0042', 'P009'), -- Nintendo Switch
('J0042', 'P008'), -- Nintendo Wii U
-- Super Smash Bros. Ultimate
('J0043', 'P009'), -- Nintendo Switch
-- Apex Legends
('J0044', 'P010'), -- PC
('J0044', 'P005'), -- Xbox One
('J0044', 'P006'), -- Xbox Series X/S
('J0044', 'P002'), -- PlayStation 4
('J0044', 'P003'), -- PlayStation 5
('J0044', 'P009'), -- Nintendo Switch
-- Overwatch
('J0045', 'P010'), -- PC
('J0045', 'P005'), -- Xbox One
('J0045', 'P006'), -- Xbox Series X/S
('J0045', 'P002'), -- PlayStation 4
('J0045', 'P003'), -- PlayStation 5
('J0045', 'P009'), -- Nintendo Switch
-- League of Legends
('J0046', 'P010'), -- PC
-- Fortnite
('J0047', 'P010'), -- PC
('J0047', 'P005'), -- Xbox One
('J0047', 'P006'), -- Xbox Series X/S
('J0047', 'P002'), -- PlayStation 4
('J0047', 'P003'), -- PlayStation 5
('J0047', 'P009'), -- Nintendo Switch
-- Valorant
('J0048', 'P010'), -- PC
('J0048', 'P003'), -- PlayStation 5
('J0048', 'P006'), -- Xbox Series X/S
-- Call of Duty: Modern Warfare
('J0049', 'P010'), -- PC
('J0049', 'P005'), -- Xbox One
('J0049', 'P006'), -- Xbox Series X/S
('J0049', 'P002'), -- PlayStation 4
('J0049', 'P003'), -- PlayStation 5
-- Resident Evil Village
('J0050', 'P010'), -- PC
('J0050', 'P005'), -- Xbox One
('J0050', 'P006'), -- Xbox Series X/S
('J0050', 'P002'), -- PlayStation 4
('J0050', 'P003'), -- PlayStation 5
('J0050', 'P009'), -- Nintendo Switch
-- Metroid Dread
('J0051', 'P009'), -- Nintendo Switch
-- Ratchet & Clank: Rift Apart
('J0052', 'P003'), -- PlayStation 5
('J0052', 'P010'), -- PC
-- Halo Infinite
('J0053', 'P010'), -- PC
('J0053', 'P006'), -- Xbox Series X/S
-- Returnal
('J0054', 'P003'), -- PlayStation 5
('J0054', 'P010'), -- PC
-- Kena: Bridge of Spirits
('J0055', 'P010'), -- PC
('J0055', 'P002'), -- PlayStation 4
('J0055', 'P003'), -- PlayStation 5
('J0055', 'P005'), -- Xbox One
('J0055', 'P006'), -- Xbox Series X/S
-- Psychonauts 2
('J0056', 'P010'), -- PC
('J0056', 'P005'), -- Xbox One
('J0056', 'P006'), -- Xbox Series X/S
('J0056', 'P002'), -- PlayStation 4
-- Deathloop
('J0057', 'P010'), -- PC
('J0057', 'P003'), -- PlayStation 5
('J0057', 'P006'), -- Xbox Series X/S
-- Forza Horizon 5
('J0058', 'P010'), -- PC
('J0058', 'P006'), -- Xbox Series X/S
-- Resident Evil 4 Remake
('J0059', 'P010'), -- PC
('J0059', 'P005'), -- Xbox One
('J0059', 'P006'), -- Xbox Series X/S
('J0059', 'P002'), -- PlayStation 4
('J0059', 'P003'), -- PlayStation 5
-- Hogwarts Legacy
('J0060', 'P010'), -- PC
('J0060', 'P005'), -- Xbox One
('J0060', 'P006'), -- Xbox Series X/S
('J0060', 'P002'), -- PlayStation 4
('J0060', 'P003'), -- PlayStation 5
('J0060', 'P009'), -- Nintendo Switch
-- Starfield
('J0061', 'P010'), -- PC
('J0061', 'P006'), -- Xbox Series X/S
-- The Legend of Zelda: Tears of the Kingdom
('J0062', 'P009'), -- Nintendo Switch
-- Final Fantasy XVI
('J0063', 'P003'), -- PlayStation 5
('J0063', 'P010'), -- PC
-- Street Fighter 6
('J0064', 'P010'), -- PC
('J0064', 'P005'), -- Xbox One
('J0064', 'P006'), -- Xbox Series X/S
('J0064', 'P002'), -- PlayStation 4
('J0064', 'P003'), -- PlayStation 5
-- Diablo IV
('J0065', 'P010'), -- PC
('J0065', 'P005'), -- Xbox One
('J0065', 'P006'), -- Xbox Series X/S
('J0065', 'P002'), -- PlayStation 4
('J0065', 'P003'), -- PlayStation 5
-- Baldur's Gate III
('J0066', 'P010'), -- PC
('J0066', 'P003'), -- PlayStation 5
('J0066', 'P006'), -- Xbox Serries X/S
-- Assassin's Creed Mirage
('J0067', 'P010'), -- PC
('J0067', 'P005'), -- Xbox One
('J0067', 'P006'), -- Xbox Series X/S
('J0067', 'P002'), -- PlayStation 4
('J0067', 'P003'), -- PlayStation 5
-- Alan Wake II
('J0068', 'P010'), -- PC
('J0068', 'P006'), -- Xbox Series X/S
('J0068', 'P003'), -- PlayStation 5
-- Marvel's Spider-Man 2
('J0069', 'P003'), -- PlayStation 5
-- EA Sports FC 24
('J0070', 'P010'), -- PC
('J0070', 'P005'), -- Xbox One
('J0070', 'P006'), -- Xbox Series X/S
('J0070', 'P002'), -- PlayStation 4
('J0070', 'P003'), -- PlayStation 5
('J0070', 'P009'), -- Nintendo Switch
-- Call of Duty: Black Ops 6
('J0071', 'P010'), -- PC
('J0071', 'P005'), -- Xbox One
('J0071', 'P006'), -- Xbox Series X/S
('J0071', 'P002'), -- PlayStation 4
('J0071', 'P003'), -- PlayStation 5
-- Elden Ring: Shadow of the Erdtree
('J0072', 'P010'), -- PC
('J0072', 'P005'), -- Xbox One
('J0072', 'P006'), -- Xbox Series X/S
('J0072', 'P002'), -- PlayStation 4
('J0072', 'P003'), -- PlayStation 5
-- Hades II
('J0073', 'P003'), -- PlayStation 5
('J0073', 'P010'), -- PC
('J0073', 'P009'), -- Nintendo Switch
('J0073', 'P006'), -- Xbox Series X/S
-- Metroid Prime 4
('J0074', 'P009'), -- Nintendo Switch
-- Fable
('J0075', 'P006'), -- Xbox Series X/S
('J0075', 'P010'), -- PC
-- The Elder Scrolls VI
('J0076', 'P006'), -- Xbox Series X/S
('J0076', 'P010'), -- PC
-- Grand Theft Auto VI
('J0077', 'P003'), -- PlayStation 5
('J0077', 'P006'), -- Xbox Series X/S
('J0077', 'P010'), -- PC
-- Star Wars: Knights of the Old Republic Remake
('J0078', 'P003'), -- PlayStation 5
-- The Witcher 4
('J0079', 'P003'), -- PlayStation 5
('J0079', 'P006'), -- Xbox Series X/S
('J0079', 'P010'), -- PC
-- Dragon Age: The Veilguard
('J0080', 'P010'), -- PC
('J0080', 'P006'), -- Xbox Series X/S
('J0080', 'P003'), -- PlayStation 5
-- Perfect Dark
('J0081', 'P006'), -- Xbox Series X/S
('J0081', 'P010'), -- PC
-- Hollow Knight: Silksong
('J0082', 'P003'), -- PlayStation 5
('J0082', 'P006'), -- Xbox Series X/S
('J0082', 'P009'), -- Nintendo Switch
('J0082', 'P010'), -- PC
-- Avowed
('J0083', 'P006'), -- Xbox Series X/S
('J0083', 'P010'), -- PC
-- Hellblade II: Senua's Saga
('J0084', 'P010'), -- PC
('J0084', 'P006'), -- Xbox Series X/S
-- Stalker 2: Heart of Chernobyl
('J0085', 'P010'), -- PC
('J0085', 'P006'), -- Xbox Series X/S
-- Redfall
('J0086', 'P010'), -- PC
('J0086', 'P006'), -- Xbox Series X/S
-- Death Stranding
('J0087', 'P010'), -- PC
('J0087', 'P003'), -- PlayStation 5
('J0087', 'P002'), -- PlayStation 4
('J0087', 'P006'), -- Xbox Series X/S
-- Stray
('J0088', 'P010'), -- PC
('J0088', 'P009'), -- Nintendo Switch
('J0088', 'P003'), -- PlayStation 5
('J0088', 'P002'), -- PlayStation 4
-- Sifu
('J0089', 'P010'), -- PC
('J0089', 'P003'), -- PlayStation 5
('J0089', 'P002'), -- PlayStation 4
('J0089', 'P005'), -- Xbox One
('J0089', 'P006'), -- Xbox Series X/S
('J0089', 'P009'), -- Nintendo Switch
-- Kirby and the Forgotten Land
('J0090', 'P009'), -- Nintendo Switch
-- Bayonetta 3
('J0091', 'P009'), -- Nintendo Switch
-- Mario + Rabbids Sparks of Hope
('J0092', 'P009'), -- Nintendo Switch
-- The Callisto Protocol
('J0093', 'P010'), -- PC
('J0093', 'P006'), -- Xbox Series X/S
('J0093', 'P003'), -- PlayStation 5
('J0093', 'P002'), -- PlayStation 4
('J0093', 'P005'), -- Xbox One
-- A Plague Tale: Requiem
('J0094', 'P010'), -- PC
('J0094', 'P006'), -- Xbox Series X/S
('J0094', 'P003'), -- PlayStation 5
('J0094', 'P009'), -- Nintnedo Switch
-- Gotham Knights
('J0095', 'P010'), -- PC
('J0095', 'P005'), -- Xbox One
('J0095', 'P006'), -- Xbox Series X/S
('J0095', 'P002'), -- PlayStation 4
('J0095', 'P003'), -- PlayStation 5
-- Dying Light 2 Stay Human
('J0096', 'P010'), -- PC
('J0096', 'P005'), -- Xbox One
('J0096', 'P006'), -- Xbox Series X/S
('J0096', 'P002'), -- PlayStation 4
('J0096', 'P003'), -- PlayStation 5
-- Ghostwire: Tokyo
('J0097', 'P010'), -- PC
('J0097', 'P003'), -- PlayStation 5
('J0097', 'P006'), -- Xbox Series X
-- Triangle Strategy
('J0098', 'P009'), -- Nintendo Switch
('J0098', 'P010'), -- PC
-- Live A Live
('J0099', 'P009'), -- Nintendo Switch
-- The Quarry
('J0100', 'P010'), -- PC
('J0100', 'P006'), -- Xbox Series X/S
('J0100', 'P005'), -- Xbox One
('J0100', 'P003'), -- PlayStation 5
('J0100', 'P002'), -- PlayStation 4
-- Cult of the Lamb
('J0101', 'P010'), -- PC
('J0101', 'P009'), -- Nintendo Switch
('J0101', 'P005'), -- Xbox One
('J0101', 'P006'), -- Xbox Series X/S
('J0101', 'P002'), -- PlayStation 4
('J0101', 'P003'), -- PlayStation 5
-- Neon White
('J0102', 'P010'), -- PC
('J0102', 'P009'), -- Nintendo Switch
('J0102', 'P003'), -- PlayStation 5
-- Ori and the Blind Forest
('J0103', 'P010'), -- PC
('J0103', 'P005'), -- Xbox One
('J0103', 'P006'), -- Xbox Series X/S
('J0103', 'P009'), -- Nintendo Switch
-- Undertale
('J0104', 'P010'), -- PC
('J0104', 'P009'), -- Nintendo Switch
('J0104', 'P002'), -- PlayStation 4
('J0104', 'P005'), -- Xbox One
('J0104', 'P006'), -- Xbox Series X/S
-- The Witness
('J0105', 'P010'), -- PC
('J0105', 'P005'), -- Xbox One
('J0105', 'P002'), -- PlayStation 4
-- Cocoon
('J0106', 'P010'), -- PC
('J0106', 'P009'), -- Nintendo Switch
('J0106', 'P006'), -- Xbox Series X/S
('J0106', 'P005'), -- Xbox One
('J0106', 'P003'), -- PlayStation 5
('J0106', 'P002'), -- PlayStation 4
-- Super Meat Boy
('J0107', 'P010'), -- PC
('J0107', 'P009'), -- Nintendo Switch
('J0107', 'P008'), -- Nintendo Wii U
('J0107', 'P004'), -- Xbox 360
('J0107', 'P002'), -- PlayStation 4
-- Bastion
('J0108', 'P010'), -- PC
('J0108', 'P009'), -- Nintendo Switch
('J0108', 'P002'), -- PlayStation 4
('J0108', 'P003'), -- PlayStation 5
-- Limbo
('J0109', 'P010'), -- PC
('J0109', 'P009'), -- Nintendo Switch
('J0109', 'P005'), -- Xbox One
('J0109', 'P004'), -- Xbox 360
('J0109', 'P002'), -- PlayStation 4
('J0109', 'P001'), -- PlayStation 3
-- Shovel Knight
('J0110', 'P010'), -- PC
('J0110', 'P009'), -- Nintendo Switch
('J0110', 'P008'), -- Nintendo Wii U
('J0110', 'P005'), -- Xbox One
('J0110', 'P003'), -- PlayStation 5
-- Returnal
('J0111', 'P010'), -- PC
('J0111', 'P003'), -- PlayStation 5
-- Slay the Spire
('J0112', 'P010'), -- PC
('J0112', 'P008'), -- Nintendo Wii U
('J0112', 'P009'), -- Nintendo Switch
('J0112', 'P004'), -- Xbox 360
('J0112', 'P005'), -- Xbox One
('J0112', 'P001'), -- PlayStation 3
('J0112', 'P002'), -- PlayStation 4
('J0112', 'P003'), -- PlayStation 5
-- Gris
('J0113', 'P010'), -- PC
('J0113', 'P009'), -- Nintendo Switch
('J0113', 'P005'), -- Xbonx One
('J0113', 'P006'), -- Xbonx Series X/S
('J0113', 'P003'), -- PlayStation 5
('J0113', 'P002'), -- PlayStation 4
-- Katana Zero
('J0114', 'P010'), -- PC
('J0114', 'P009'), -- Nintendo Switch
('J0114', 'P005'), -- Xbox One
('J0114', 'P002'), -- PlayStation 4
-- The Binding of Isaac: Rebirth
('J0115', 'P010'), -- PC
('J0115', 'P009'), -- Nintendo Switch
('J0115', 'P008'), -- Nintendo Wii U
('J0115', 'P005'), -- Xbox One
('J0115', 'P002'), -- PlayStation 4
-- Oxenfree
('J0116', 'P010'), -- PC
('J0116', 'P009'), -- Nintendo Switch
('J0116', 'P005'), -- Xbox One
('J0116', 'P003'), -- PlayStation 5
('J0116', 'P002'), -- PlayStation 4
-- Firewatch
('J0117', 'P010'), -- PC
('J0117', 'P005'), -- Xbox One
('J0117', 'P002'), -- PlayStation 4
('J0117', 'P009'), -- Nintendo Switch
-- SOMA
('J0118', 'P010'), -- PC
('J0118', 'P002'), -- PlayStation 4
('J0118', 'P005'), -- Xbox One
-- God Of War
('J0119', 'P010'), -- PC
('J0119', 'P003'), -- PlayStation 5
-- Shantae and the Seven Sirens
('J0120', 'P010'), -- PC
('J0120', 'P009'), -- Nintendo Switch
('J0120', 'P005'), -- Xbox One
('J0120', 'P003'), -- PlayStation 5
-- Horizon Forbidden West
('J0121', 'P003'), -- PlayStation 5
('J0121', 'P010'), -- PC
-- Death's Door
('J0122', 'P010'), -- PC
('J0122', 'P009'), -- Nintendo Switch
('J0122', 'P005'), -- Xbox One
('J0122', 'P006'), -- Xbox Series X/S
('J0122', 'P003'), -- PlayStation 5
('J0122', 'P002'), -- PlayStation 4
-- Eastward
('J0123', 'P010'), -- PC
('J0123', 'P009'), -- Nintendo Switch
('J0123', 'P005'), -- Xbox One
-- Chicory: A Colorful Tale
('J0124', 'P010'), -- PC
('J0124', 'P009'), -- Nintendo Switch
('J0124', 'P002'), -- PlayStation 4
('J0124', 'P003'), -- PlayStation 5
('J0124', 'P005'), -- Xbox One
('J0124', 'P006'), -- Xbox Series X/S
-- Luigi's Mansion 3
('J0125', 'P009'), -- Nintendo Switch
-- Papers, Please
('J0126', 'P010'), -- PC
-- Vampire Survivors
('J0127', 'P010'), -- PC
('J0127', 'P005'), -- Xbox One
('J0127', 'P006'), -- Xbox Series X/S
('J0127', 'P009'), -- Nintendo Switch
('J0127', 'P002'), -- PlayStation 4
('J0127', 'P003'), -- PlayStation 5
-- Terraria
('J0128', 'P010'), -- PC
('J0128', 'P009'), -- Nintendo Switch
('J0128', 'P008'), -- Nintendo Wii U
('J0128', 'P005'), -- Xbox One
('J0128', 'P003'), -- PlayStation 5
-- Factorio
('J0129', 'P010'), -- PC
('J0129', 'P009'), -- Nintendo Switch
-- Like a Dragon Infinite Wealth
('J0130', 'P010'), -- PC
('J0130', 'P005'), -- Xbox One
('J0130', 'P006'), -- Xbox Series X/S
('J0130', 'P003'), -- PlayStation 5
('J0130', 'P002'), -- PlayStation 4
-- 13 Sentinels: Aegis Rim
('J0131', 'P009'), -- Nintendo Switch
('J0131', 'P002'), -- PlayStation 4
-- Red Dead Redemption II
('J0132', 'P010'), -- PC
('J0132', 'P005'), -- Xbox One
('J0132', 'P002'), -- PlayStation 4
-- The Forest
('J0133', 'P010'), -- PC
('J0133', 'P002'), -- PlayStation 4
-- Project Zomboid
('J0134', 'P010'), -- PC
-- Minecraft
('J0135', 'P010'), -- PC
('J0135', 'P009'), -- Nintendo Switch
('J0135', 'P005'), -- Xbox One
('J0135', 'P006'), -- Xbox Series X/S
('J0135', 'P003'), -- PlayStation 5
('J0135', 'P002'), -- PlayStation 4
-- Subnautica
('J0136', 'P010'), -- PC
('J0136', 'P005'), -- Xbox One
('J0136', 'P009'), -- Nintendo Switch
('J0136', 'P003'), -- PlayStation 5
('J0136', 'P002'), -- PlayStation 4
-- A Hat in Time
('J0137', 'P010'), -- PC
('J0137', 'P009'), -- Nintendo Switch
('J0137', 'P005'), -- Xbox One
('J0137', 'P002'), -- PlayStation 4
-- Tinykin
('J0138', 'P010'), -- PC
('J0138', 'P009'), -- Nintendo Switch
('J0138', 'P005'), -- Xbox One
('J0138', 'P006'), -- Xbox Series X/S
('J0138', 'P003'), -- PlayStation 5
('J0138', 'P002'), -- PlayStation 4
-- Super Mario Bros. Wonder
('J0139', 'P009'), -- Nintendo Switch
-- Darkest Dungeon
('J0140', 'P010'), -- PC
('J0140', 'P009'), -- Nintendo Switch
('J0140', 'P005'), -- Xbox One
('J0140', 'P006'), -- Xbox Series X/S
('J0140', 'P003'), -- PlayStation 5
('J0140', 'P002'), -- PlayStation 4
-- Final Fantasy VII Rebirth
('J0141', 'P003'), -- PlayStation 5
-- Paper Mario: The Thousand-Year Door
('J0142', 'P009'), -- Nintendo Switch
-- Satisfactory
('J0143', 'P010'), -- PC
('J0143', 'P003'), -- PlayStation 5
('J0143', 'P006'), -- Xbox Series X/S
-- Hi-Fi RUSH
('J0144', 'P010'), -- PC
('J0144', 'P006'), -- Xbox Series X/S
('J0144', 'P003'), -- PlayStation 5
-- Astro Bot
('J0145', 'P003'), -- PlayStation 5
-- Judgment
('J0146', 'P010'), -- PC
('J0146', 'P005'), -- Xbox One
('J0146', 'P006'), -- Xbox Series X/S
('J0146', 'P003'), -- PlayStation 5
('J0146', 'P002'), -- PlayStation 4
-- Metaphor: ReFantazio
('J0147', 'P010'), -- PC
('J0147', 'P003'), -- PlayStation 5
('J0147', 'P006'), -- Xbox Series X/S
-- NieR: Automata
('J0148', 'P010'), -- PC
('J0148', 'P009'), -- Nintendo Switch
('J0148', 'P005'), -- Xbox One
('J0148', 'P002'), -- PlayStation 4
-- Pikmin 4
('J0149', 'P009'), -- Nintendo Switch
-- Grand Theft Auto V
('J0150', 'P010'), -- PC
('J0150', 'P005'), -- Xbox One
('J0150', 'P004'), -- Xbox 360
('J0150', 'P006'), -- Xbox Series X/S
('J0150', 'P003'), -- PlayStation 5
('J0150', 'P002'), -- PlayStation 4
('J0150', 'P001'); -- PlayStation 3

-- Inserciones tabla usuario
INSERT INTO usuario (id_usuario, nombre_usuario, email, pais, fecha_registro, avatar_url, telefono) VALUES
                                                                                                        ('U0001', 'Alice Johnson', 'alice.johnson@example.com', 'USA', '2023-01-15', 'https://example.com/avatar1.jpg', '+1234567890'),
                                                                                                        ('U0002', 'Bob Smith', 'bob.smith@example.com', 'Canada', '2023-01-20', 'https://example.com/avatar2.jpg', '+1234567891'),
                                                                                                        ('U0003', 'Charlie Brown', 'charlie.brown@example.com', 'UK', '2023-02-10', 'https://example.com/avatar3.jpg', '+1234567892'),
                                                                                                        ('U0004', 'Daisy Green', 'daisy.green@example.com', 'Australia', '2023-02-15', 'https://example.com/avatar4.jpg', '+1234567893'),
                                                                                                        ('U0005', 'Ethan White', 'ethan.white@example.com', 'Germany', '2023-02-20', 'https://example.com/avatar5.jpg', '+1234567894'),
                                                                                                        ('U0006', 'Fiona Black', 'fiona.black@example.com', 'España', '2023-03-01', 'https://example.com/avatar6.jpg', '+1234567895'),
                                                                                                        ('U0007', 'George Carter', 'george.carter@example.com', 'France', '2023-03-10', 'https://example.com/avatar7.jpg', '+1234567896'),
                                                                                                        ('U0008', 'Hannah Adams', 'hannah.adams@example.com', 'Italy', '2023-03-15', 'https://example.com/avatar8.jpg', '+1234567897'),
                                                                                                        ('U0009', 'Ian Wright', 'ian.wright@example.com', 'Brazil', '2023-04-01', 'https://example.com/avatar9.jpg', '+1234567898'),
                                                                                                        ('U0010', 'Jane King', 'jane.king@example.com', 'India', '2023-04-10', 'https://example.com/avatar10.jpg', '+1234567899'),
                                                                                                        ('U0011', 'Kyle Young', 'kyle.young@example.com', 'Mexico', '2023-04-20', 'https://example.com/avatar11.jpg', '+1234567800'),
                                                                                                        ('U0012', 'Lily Hall', 'lily.hall@example.com', 'Argentina', '2023-05-01', 'https://example.com/avatar12.jpg', '+1234567801'),
                                                                                                        ('U0013', 'Mason Lee', 'mason.lee@example.com', 'Japan', '2023-05-15', 'https://example.com/avatar13.jpg', '+1234567802'),
                                                                                                        ('U0014', 'Nina Scott', 'nina.scott@example.com', 'China', '2023-05-20', 'https://example.com/avatar14.jpg', '+1234567803'),
                                                                                                        ('U0015', 'Oscar Evans', 'oscar.evans@example.com', 'South Korea', '2023-06-01', 'https://example.com/avatar15.jpg', '+1234567804'),
                                                                                                        ('U0016', 'Paula Baker', 'paula.baker@example.com', 'South Africa', '2023-06-10', 'https://example.com/avatar16.jpg', '+1234567805'),
                                                                                                        ('U0017', 'Quinn Mitchell', 'quinn.mitchell@example.com', 'Russia', '2023-06-15', 'https://example.com/avatar17.jpg', '+1234567806'),
                                                                                                        ('U0018', 'Rachel Hughes', 'rachel.hughes@example.com', 'New Zealand', '2023-07-01', 'https://example.com/avatar18.jpg', '+1234567807'),
                                                                                                        ('U0019', 'Sam Wilson', 'sam.wilson@example.com', 'Portugal', '2023-07-10', 'https://example.com/avatar19.jpg', '+1234567808'),
                                                                                                        ('U0020', 'Tina Carter', 'tina.carter@example.com', 'Sweden', '2023-07-20', 'https://example.com/avatar20.jpg', '+1234567809'),
                                                                                                        ('U0021', 'Uma Kelly', 'uma.kelly@example.com', 'Netherlands', '2023-08-01', 'https://example.com/avatar21.jpg', '+1234567810'),
                                                                                                        ('U0022', 'Victor Roberts', 'victor.roberts@example.com', 'Belgium', '2023-08-10', 'https://example.com/avatar22.jpg', '+1234567811'),
                                                                                                        ('U0023', 'Wendy Campbell', 'wendy.campbell@example.com', 'Norway', '2023-08-15', 'https://example.com/avatar23.jpg', '+1234567812'),
                                                                                                        ('U0024', 'Xander Foster', 'xander.foster@example.com', 'Denmark', '2023-08-20', 'https://example.com/avatar24.jpg', '+1234567813'),
                                                                                                        ('U0025', 'Yvonne Morris', 'yvonne.morris@example.com', 'Ireland', '2023-09-01', 'https://example.com/avatar25.jpg', '+1234567814'),
                                                                                                        ('U0026', 'Zachary Turner', 'zachary.turner@example.com', 'Poland', '2023-09-10', 'https://example.com/avatar26.jpg', '+1234567815'),
                                                                                                        ('U0027', 'Amy Taylor', 'amy.taylor@example.com', 'Switzerland', '2023-09-15', 'https://example.com/avatar27.jpg', '+1234567816'),
                                                                                                        ('U0028', 'Brian Walker', 'brian.walker@example.com', 'Austria', '2023-09-20', 'https://example.com/avatar28.jpg', '+1234567817'),
                                                                                                        ('U0029', 'Chloe Lewis', 'chloe.lewis@example.com', 'Czech Republic', '2023-09-25', 'https://example.com/avatar29.jpg', '+1234567818'),
                                                                                                        ('U0030', 'Daniel Edwards', 'daniel.edwards@example.com', 'Hungary', '2023-10-01', 'https://example.com/avatar30.jpg', '+1234567819'),
                                                                                                        ('U0031', 'Emma Collins', 'emma.collins@example.com', 'Finland', '2023-10-05', 'https://example.com/avatar31.jpg', '+1234567820'),
                                                                                                        ('U0032', 'Franklin Diaz', 'franklin.diaz@example.com', 'Chile', '2023-10-10', 'https://example.com/avatar32.jpg', '+1234567821'),
                                                                                                        ('U0033', 'Grace Carter', 'grace.carter@example.com', 'Colombia', '2023-10-15', 'https://example.com/avatar33.jpg', '+1234567822'),
                                                                                                        ('U0034', 'Henry Perez', 'henry.perez@example.com', 'Venezuela', '2023-10-20', 'https://example.com/avatar34.jpg', '+1234567823'),
                                                                                                        ('U0035', 'Isabella Rivera', 'isabella.rivera@example.com', 'Peru', '2023-10-25', 'https://example.com/avatar35.jpg', '+1234567824'),
                                                                                                        ('U0036', 'Jack Simmons', 'jack.simmons@example.com', 'Ecuador', '2023-11-01', 'https://example.com/avatar36.jpg', '+1234567825'),
                                                                                                        ('U0037', 'Katherine Morris', 'katherine.morris@example.com', 'Uruguay', '2023-11-05', 'https://example.com/avatar37.jpg', '+1234567826'),
                                                                                                        ('U0038', 'Liam Stewart', 'liam.stewart@example.com', 'Paraguay', '2023-11-10', 'https://example.com/avatar38.jpg', '+1234567827'),
                                                                                                        ('U0039', 'Mia Bailey', 'mia.bailey@example.com', 'Bolivia', '2023-11-15', 'https://example.com/avatar39.jpg', '+1234567828'),
                                                                                                        ('U0040', 'Noah Wilson', 'noah.wilson@example.com', 'Costa Rica', '2023-11-20', 'https://example.com/avatar40.jpg', '+1234567829'),
                                                                                                        ('U0041', 'Olivia Martinez', 'olivia.martinez@example.com', 'Panama', '2023-11-25', 'https://example.com/avatar41.jpg', '+1234567830'),
                                                                                                        ('U0042', 'Patrick Johnson', 'patrick.johnson@example.com', 'Honduras', '2023-12-01', 'https://example.com/avatar42.jpg', '+1234567831'),
                                                                                                        ('U0043', 'Quincy Taylor', 'quincy.taylor@example.com', 'El Salvador', '2023-12-05', 'https://example.com/avatar43.jpg', '+1234567832'),
                                                                                                        ('U0044', 'Rebecca Harris', 'rebecca.harris@example.com', 'Guatemala', '2023-12-10', 'https://example.com/avatar44.jpg', '+1234567833'),
                                                                                                        ('U0045', 'Samuel Young', 'samuel.young@example.com', 'Dominican Republic', '2023-12-15', 'https://example.com/avatar45.jpg', '+1234567834'),
                                                                                                        ('U0046', 'Tara Mitchell', 'tara.mitchell@example.com', 'Puerto Rico', '2023-12-20', 'https://example.com/avatar46.jpg', '+1234567835'),
                                                                                                        ('U0047', 'Uma Wright', 'uma.wright@example.com', 'Cuba', '2023-12-25', 'https://example.com/avatar47.jpg', '+1234567836'),
                                                                                                        ('U0048', 'Victor Garcia', 'victor.garcia@example.com', 'Haiti', '2023-12-30', 'https://example.com/avatar48.jpg', '+1234567837'),
                                                                                                        ('U0049', 'Wendy Martinez', 'wendy.martinez@example.com', 'Jamaica', '2024-01-01', 'https://example.com/avatar49.jpg', '+1234567838'),
                                                                                                        ('U0050', 'Xavier Lopez', 'xavier.lopez@example.com', 'Trinidad and Tobago', '2024-01-05', 'https://example.com/avatar50.jpg', '+1234567839'),
                                                                                                        ('U0051', 'Yasmin Rivera', 'yasmin.rivera@example.com', 'Guyana', '2024-01-10', 'https://example.com/avatar51.jpg', '+1234567840'),
                                                                                                        ('U0052', 'Zane Clark', 'zane.clark@example.com', 'Suriname', '2024-01-15', 'https://example.com/avatar52.jpg', '+1234567841'),
                                                                                                        ('U0053', 'Alicia Morgan', 'alicia.morgan@example.com', 'Belize', '2024-01-20', 'https://example.com/avatar53.jpg', '+1234567842'),
                                                                                                        ('U0054', 'Benjamin Torres', 'benjamin.torres@example.com', 'Barbados', '2024-01-25', 'https://example.com/avatar54.jpg', '+1234567843'),
                                                                                                        ('U0055', 'Camila Brooks', 'camila.brooks@example.com', 'Bahamas', '2024-01-30', 'https://example.com/avatar55.jpg', '+1234567844'),
                                                                                                        ('U0056', 'David Sanders', 'david.sanders@example.com', 'Grenada', '2024-02-01', 'https://example.com/avatar56.jpg', '+1234567845'),
                                                                                                        ('U0057', 'Eliza Perry', 'eliza.perry@example.com', 'Saint Lucia', '2024-02-05', 'https://example.com/avatar57.jpg', '+1234567846'),
                                                                                                        ('U0058', 'Francis Ramirez', 'francis.ramirez@example.com', 'Saint Kitts and Nevis', '2024-02-10', 'https://example.com/avatar58.jpg', '+1234567847'),
                                                                                                        ('U0059', 'Gabriel Foster', 'gabriel.foster@example.com', 'Antigua and Barbuda', '2024-02-15', 'https://example.com/avatar59.jpg', '+1234567848'),
                                                                                                        ('U0060', 'Hazel Ward', 'hazel.ward@example.com', 'Dominica', '2024-02-20', 'https://example.com/avatar60.jpg', '+1234567849'),
                                                                                                        ('U0061', 'Ian James', 'ian.james@example.com', 'Saint Vincent and the Grenadines', '2024-02-25', 'https://example.com/avatar61.jpg', '+1234567850'),
                                                                                                        ('U0062', 'Jade Peterson', 'jade.peterson@example.com', 'Montserrat', '2024-03-01', 'https://example.com/avatar62.jpg', '+1234567851'),
                                                                                                        ('U0063', 'Kevin Brooks', 'kevin.brooks@example.com', 'Aruba', '2024-03-05', 'https://example.com/avatar63.jpg', '+1234567852'),
                                                                                                        ('U0064', 'Luis Rodríguez', 'luis.rodriguez@example.com', 'México', '2024-01-02', 'https://example.com/avatars/luis.jpg', '+525512345678'),
                                                                                                        ('U0065', 'Emma Gómez', 'emma.gomez@example.com', 'Argentina', '2024-01-03', 'https://example.com/avatars/emma.jpg', '+5491167891234'),
                                                                                                        ('U0066', 'Mateo Fernández', 'mateo.fernandez@example.com', 'Chile', '2024-01-04', 'https://example.com/avatars/mateo.jpg', '+569987654321'),
                                                                                                        ('U0067', 'Isabella López', 'isabella.lopez@example.com', 'Colombia', '2024-01-05', 'https://example.com/avatars/isabella.jpg', '+573212345678'),
                                                                                                        ('U0068', 'Lucas Pérez', 'lucas.perez@example.com', 'Uruguay', '2024-01-06', 'https://example.com/avatars/lucas.jpg', '+59891234567'),
                                                                                                        ('U0069', 'Valentina Díaz', 'valentina.diaz@example.com', 'Perú', '2024-01-07', 'https://example.com/avatars/valentina.jpg', '+51987654321'),
                                                                                                        ('U0070', 'Martín Sánchez', 'martin.sanchez@example.com', 'España', '2024-01-08', 'https://example.com/avatars/martin.jpg', '+34678901235'),
                                                                                                        ('U0071', 'Camila Torres', 'camila.torres@example.com', 'México', '2024-01-09', 'https://example.com/avatars/camila.jpg', '+525512345679'),
                                                                                                        ('U0072', 'Sebastián Romero', 'sebastian.romero@example.com', 'Argentina', '2024-01-10', 'https://example.com/avatars/sebastian.jpg', '+5491167891235'),
                                                                                                        ('U0073', 'Victoria Herrera', 'victoria.herrera@example.com', 'Chile', '2024-01-11', 'https://example.com/avatars/victoria.jpg', '+569987654322'),
                                                                                                        ('U0074', 'Diego Castro', 'diego.castro@example.com', 'Colombia', '2024-01-12', 'https://example.com/avatars/diego.jpg', '+573212345679'),
                                                                                                        ('U0075', 'Daniela Morales', 'daniela.morales@example.com', 'Uruguay', '2024-01-13', 'https://example.com/avatars/daniela.jpg', '+59891234568'),
                                                                                                        ('U0076', 'Javier Méndez', 'javier.mendez@example.com', 'Perú', '2024-01-14', 'https://example.com/avatars/javier.jpg', '+51987654322'),
                                                                                                        ('U0077', 'Sara Ruiz', 'sara.ruiz@example.com', 'España', '2024-01-15', 'https://example.com/avatars/sara.jpg', '+34678901236'),
                                                                                                        ('U0078', 'Alejandro Ortega', 'alejandro.ortega@example.com', 'México', '2024-01-16', 'https://example.com/avatars/alejandro.jpg', '+525512345680'),
                                                                                                        ('U0079', 'Julieta Rivera', 'julieta.rivera@example.com', 'Argentina', '2024-01-17', 'https://example.com/avatars/julieta.jpg', '+5491167891236'),
                                                                                                        ('U0080', 'Tomás Gil', 'tomas.gil@example.com', 'Chile', '2024-01-18', 'https://example.com/avatars/tomas.jpg', '+569987654323'),
                                                                                                        ('U0081', 'Lucía Vargas', 'lucia.vargas@example.com', 'Colombia', '2024-01-19', 'https://example.com/avatars/lucia.jpg', '+573212345680'),
                                                                                                        ('U0082', 'Hugo Peña', 'hugo.pena@example.com', 'Uruguay', '2024-01-20', 'https://example.com/avatars/hugo.jpg', '+59891234569'),
                                                                                                        ('U0083', 'Paula Navarro', 'paula.navarro@example.com', 'Perú', '2024-01-21', 'https://example.com/avatars/paula.jpg', '+51987654323'),
                                                                                                        ('U0084', 'Carlos Reyes', 'carlos.reyes@example.com', 'España', '2024-01-22', 'https://example.com/avatars/carlos.jpg', '+34678901237'),
                                                                                                        ('U0085', 'Elena Flores', 'elena.flores@example.com', 'México', '2024-01-23', 'https://example.com/avatars/elena.jpg', '+525512345681'),
                                                                                                        ('U0086', 'Mario Álvarez', 'mario.alvarez@example.com', 'Argentina', '2024-01-24', 'https://example.com/avatars/mario.jpg', '+5491167891237'),
                                                                                                        ('U0087', 'Andrea Cruz', 'andrea.cruz@example.com', 'Chile', '2024-01-25', 'https://example.com/avatars/andrea.jpg', '+569987654324'),
                                                                                                        ('U0088', 'Pablo Jiménez', 'pablo.jimenez@example.com', 'Colombia', '2024-01-26', 'https://example.com/avatars/pablo.jpg', '+573212345681'),
                                                                                                        ('U0089', 'Claudia Vega', 'claudia.vega@example.com', 'Uruguay', '2024-01-27', 'https://example.com/avatars/claudia.jpg', '+59891234570'),
                                                                                                        ('U0090', 'Santiago Ramos', 'santiago.ramos@example.com', 'Perú', '2024-01-28', 'https://example.com/avatars/santiago.jpg', '+51987654324'),
                                                                                                        ('U0091', 'Nuria Ortiz', 'nuria.ortiz@example.com', 'España', '2024-01-29', 'https://example.com/avatars/nuria.jpg', '+34678901238'),
                                                                                                        ('U0092', 'Adrián Paredes', 'adrian.paredes@example.com', 'México', '2024-01-30', 'https://example.com/avatars/adrian.jpg', '+525512345682'),
                                                                                                        ('U0093', 'Carmen Castillo', 'carmen.castillo@example.com', 'Argentina', '2024-01-31', 'https://example.com/avatars/carmen.jpg', '+5491167891238'),
                                                                                                        ('U0094', 'Felipe Medina', 'felipe.medina@example.com', 'Chile', '2024-02-01', 'https://example.com/avatars/felipe.jpg', '+569987654325'),
                                                                                                        ('U0095', 'Verónica Fuentes', 'veronica.fuentes@example.com', 'Colombia', '2024-02-02', 'https://example.com/avatars/veronica.jpg', '+573212345682'),
                                                                                                        ('U0096', 'Manuel Aguirre', 'manuel.aguirre@example.com', 'Uruguay', '2024-02-03', 'https://example.com/avatars/manuel.jpg', '+59891234571'),
                                                                                                        ('U0097', 'Teresa Escobar', 'teresa.escobar@example.com', 'Perú', '2024-02-04', 'https://example.com/avatars/teresa.jpg', '+51987654325'),
                                                                                                        ('U0098', 'Gabriel Delgado', 'gabriel.delgado@example.com', 'España', '2024-02-05', 'https://example.com/avatars/gabriel.jpg', '+34678901239'),
                                                                                                        ('U0099', 'Ana Campos', 'ana.campos@example.com', 'México', '2024-02-06', 'https://example.com/avatars/ana.jpg', '+525512345683'),
                                                                                                        ('U0100', 'David Bautista', 'david.bautista@example.com', 'Argentina', '2024-02-07', 'https://example.com/avatars/david.jpg', '+5491167891239'),
                                                                                                        ('U0101', 'Carla Gutiérrez', 'carla.gutierrez@example.com', 'Chile', '2024-02-08', 'https://example.com/avatars/carla.jpg', '+569987654326'),
                                                                                                        ('U0102', 'Francisco Molina', 'francisco.molina@example.com', 'Colombia', '2024-02-09', 'https://example.com/avatars/francisco.jpg', '+573212345683'),
                                                                                                        ('U0103', 'Patricia Márquez', 'patricia.marquez@example.com', 'Uruguay', '2024-02-10', 'https://example.com/avatars/patricia.jpg', '+59891234572'),
                                                                                                        ('U0104', 'Álvaro Guerra', 'alvaro.guerra@example.com', 'Perú', '2024-02-11', 'https://example.com/avatars/alvaro.jpg', '+51987654326'),
                                                                                                        ('U0105', 'Irene Blanco', 'irene.blanco@example.com', 'España', '2024-02-12', 'https://example.com/avatars/irene.jpg', '+34678901240'),
                                                                                                        ('U0106', 'Ricardo Suárez', 'ricardo.suarez@example.com', 'México', '2024-02-13', 'https://example.com/avatars/ricardo.jpg', '+525512345684'),
                                                                                                        ('U0107', 'Sandra Acosta', 'sandra.acosta@example.com', 'Argentina', '2024-02-14', 'https://example.com/avatars/sandra.jpg', '+5491167891240'),
                                                                                                        ('U0108', 'Guillermo Cabrera', 'guillermo.cabrera@example.com', 'Chile', '2024-02-15', 'https://example.com/avatars/guillermo.jpg', '+569987654327'),
                                                                                                        ('U0109', 'María Ángeles Bravo', 'maria.bravo@example.com', 'Colombia', '2024-02-16', 'https://example.com/avatars/maria.jpg', '+573212345684'),
                                                                                                        ('U0110', 'José Ignacio Paz', 'jose.paz@example.com', 'Uruguay', '2024-02-17', 'https://example.com/avatars/jose.jpg', '+59891234573'),
                                                                                                        ('U0111', 'Marta Padilla', 'marta.padilla@example.com', 'Perú', '2024-02-18', 'https://example.com/avatars/marta.jpg', '+51987654327'),
                                                                                                        ('U0112', 'César Herrera', 'cesar.herrera@example.com', 'España', '2024-02-19', 'https://example.com/avatars/cesar.jpg', '+34678901241'),
                                                                                                        ('U0113', 'Nerea Sánchez', 'nerea.sanchez@example.com', 'México', '2024-02-20', 'https://example.com/avatars/nerea.jpg', '+525512345685'),
                                                                                                        ('U0114', 'Esteban Vargas', 'esteban.vargas@example.com', 'Argentina', '2024-02-21', 'https://example.com/avatars/esteban.jpg', '+5491167891241'),
                                                                                                        ('U0115', 'Paula Pérez', 'paula.perez@example.com', 'Chile', '2024-02-22', 'https://example.com/avatars/paula.jpg', '+569987654328'),
                                                                                                        ('U0116', 'Héctor Ruiz', 'hector.ruiz@example.com', 'Colombia', '2024-02-23', 'https://example.com/avatars/hector.jpg', '+573212345685'),
                                                                                                        ('U0117', 'Nayara Morales', 'nayara.morales@example.com', 'Uruguay', '2024-02-24', 'https://example.com/avatars/nayara.jpg', '+59891234574'),
                                                                                                        ('U0118', 'Antonio Castillo', 'antonio.castillo@example.com', 'Perú', '2024-02-25', 'https://example.com/avatars/antonio.jpg', '+51987654328'),
                                                                                                        ('U0119', 'Beatriz Gil', 'beatriz.gil@example.com', 'España', '2024-02-26', 'https://example.com/avatars/beatriz.jpg', '+34678901242'),
                                                                                                        ('U0120', 'Damián Ortega', 'damian.ortega@example.com', 'México', '2024-02-27', 'https://example.com/avatars/damian.jpg', '+525512345686'),
                                                                                                        ('U0121', 'Mónica Herrera', 'monica.herrera@example.com', 'Argentina', '2024-02-28', 'https://example.com/avatars/monica.jpg', '+5491167891242'),
                                                                                                        ('U0122', 'Arturo Ramos', 'arturo.ramos@example.com', 'Chile', '2024-02-29', 'https://example.com/avatars/arturo.jpg', '+569987654329'),
                                                                                                        ('U0123', 'Laura Escobar', 'laura.escobar@example.com', 'Colombia', '2024-03-01', 'https://example.com/avatars/laura.jpg', '+573212345686'),
                                                                                                        ('U0124', 'Roberto Paredes', 'roberto.paredes@example.com', 'Uruguay', '2024-03-02', 'https://example.com/avatars/roberto.jpg', '+59891234575'),
                                                                                                        ('U0125', 'Diana Vega', 'diana.vega@example.com', 'Perú', '2024-03-03', 'https://example.com/avatars/diana.jpg', '+51987654329'),
                                                                                                        ('U0126', 'Marcos Navarro', 'marcos.navarro@example.com', 'España', '2024-03-04', 'https://example.com/avatars/marcos.jpg', '+34678901243'),
                                                                                                        ('U0127', 'Luciana López', 'luciana.lopez@example.com', 'México', '2024-03-05', 'https://example.com/avatars/luciana.jpg', '+525512345687'),
                                                                                                        ('U0128', 'Guillermo Díaz', 'guillermo.diaz@example.com', 'Argentina', '2024-03-06', 'https://example.com/avatars/guillermo.jpg', '+5491167891243'),
                                                                                                        ('U0129', 'Patricia Romero', 'patricia.romero@example.com', 'Chile', '2024-03-07', 'https://example.com/avatars/patricia.jpg', '+569987654330'),
                                                                                                        ('U0130', 'Fernando Álvarez', 'fernando.alvarez@example.com', 'Colombia', '2024-03-08', 'https://example.com/avatars/fernando.jpg', '+573212345687'),
                                                                                                        ('U0131', 'Isabel Méndez', 'isabel.mendez@example.com', 'Uruguay', '2024-03-09', 'https://example.com/avatars/isabel.jpg', '+59891234576'),
                                                                                                        ('U0132', 'Ricardo Torres', 'ricardo.torres@example.com', 'Perú', '2024-03-10', 'https://example.com/avatars/ricardo.jpg', '+51987654330'),
                                                                                                        ('U0133', 'Cecilia Sánchez', 'cecilia.sanchez@example.com', 'España', '2024-03-11', 'https://example.com/avatars/cecilia.jpg', '+34678901244'),
                                                                                                        ('U0134', 'Eduardo Jiménez', 'eduardo.jimenez@example.com', 'México', '2024-03-12', 'https://example.com/avatars/eduardo.jpg', '+525512345688'),
                                                                                                        ('U0135', 'Florencia Pérez', 'florencia.perez@example.com', 'Argentina', '2024-03-13', 'https://example.com/avatars/florencia.jpg', '+5491167891244'),
                                                                                                        ('U0136', 'Oscar Castillo', 'oscar.castillo@example.com', 'Chile', '2024-03-14', 'https://example.com/avatars/oscar.jpg', '+569987654331'),
                                                                                                        ('U0137', 'Adriana Vargas', 'adriana.vargas@example.com', 'Colombia', '2024-03-15', 'https://example.com/avatars/adriana.jpg', '+573212345688'),
                                                                                                        ('U0138', 'Vicente Martínez', 'vicente.martinez@example.com', 'Uruguay', '2024-03-16', 'https://example.com/avatars/vicente.jpg', '+59891234577'),
                                                                                                        ('U0139', 'Silvia Herrera', 'silvia.herrera@example.com', 'Perú', '2024-03-17', 'https://example.com/avatars/silvia.jpg', '+51987654331'),
                                                                                                        ('U0140', 'Andrés Gil', 'andres.gil@example.com', 'España', '2024-03-18', 'https://example.com/avatars/andres.jpg', '+34678901245'),
                                                                                                        ('U0141', 'Clara Ortiz', 'clara.ortiz@example.com', 'México', '2024-03-19', 'https://example.com/avatars/clara.jpg', '+525512345689'),
                                                                                                        ('U0142', 'Leonardo Fernández', 'leonardo.fernandez@example.com', 'Argentina', '2024-03-20', 'https://example.com/avatars/leonardo.jpg', '+5491167891245'),
                                                                                                        ('U0143', 'Gabriela Ramos', 'gabriela.ramos@example.com', 'Chile', '2024-03-21', 'https://example.com/avatars/gabriela.jpg', '+569987654332'),
                                                                                                        ('U0144', 'Raúl Acosta', 'raul.acosta@example.com', 'Colombia', '2024-03-22', 'https://example.com/avatars/raul.jpg', '+573212345689'),
                                                                                                        ('U0145', 'Daniela Fuentes', 'daniela.fuentes@example.com', 'Uruguay', '2024-03-23', 'https://example.com/avatars/daniela.jpg', '+59891234578'),
                                                                                                        ('U0146', 'Ignacio Méndez', 'ignacio.mendez@example.com', 'Perú', '2024-03-24', 'https://example.com/avatars/ignacio.jpg', '+51987654332'),
                                                                                                        ('U0147', 'Elisa Blanco', 'elisa.blanco@example.com', 'España', '2024-03-25', 'https://example.com/avatars/elisa.jpg', '+34678901246'),
                                                                                                        ('U0148', 'Cristina Delgado', 'cristina.delgado@example.com', 'México', '2024-03-26', 'https://example.com/avatars/cristina.jpg', '+525512345690'),
                                                                                                        ('U0149', 'Estela Fernández', 'estela.fernandez@example.com', 'Argentina', '2024-03-27', 'https://example.com/avatars/estela.jpg', '+5491167891246'),
                                                                                                        ('U0150', 'Marco Vargas', 'marco.vargas@example.com', 'Chile', '2024-03-28', 'https://example.com/avatars/marco.jpg', '+569987654333'),
                                                                                                        ('U0151', 'Gloria Sánchez', 'gloria.sanchez@example.com', 'Colombia', '2024-03-29', 'https://example.com/avatars/gloria.jpg', '+573212345690'),
                                                                                                        ('U0152', 'Hernán Martínez', 'hernan.martinez@example.com', 'Uruguay', '2024-03-30', 'https://example.com/avatars/hernan.jpg', '+59891234579'),
                                                                                                        ('U0153', 'Rocío Herrera', 'rocio.herrera@example.com', 'Perú', '2024-03-31', 'https://example.com/avatars/rocio.jpg', '+51987654333'),
                                                                                                        ('U0154', 'Ramón Gil', 'ramon.gil@example.com', 'España', '2024-04-01', 'https://example.com/avatars/ramon.jpg', '+34678901247'),
                                                                                                        ('U0155', 'Lorena Escobar', 'lorena.escobar@example.com', 'México', '2024-04-02', 'https://example.com/avatars/lorena.jpg', '+525512345691'),
                                                                                                        ('U0156', 'Juan Ramírez', 'juan.ramirez@example.com', 'Argentina', '2024-04-03', 'https://example.com/avatars/juan.jpg', '+5491167891247'),
                                                                                                        ('U0157', 'Rafaela Blanco', 'rafaela.blanco@example.com', 'Chile', '2024-04-04', 'https://example.com/avatars/rafaela.jpg', '+569987654334'),
                                                                                                        ('U0158', 'Nicolás Torres', 'nicolas.torres@example.com', 'Colombia', '2024-04-05', 'https://example.com/avatars/nicolas.jpg', '+573212345691'),
                                                                                                        ('U0159', 'Fabiola Fuentes', 'fabiola.fuentes@example.com', 'Uruguay', '2024-04-06', 'https://example.com/avatars/fabiola.jpg', '+59891234580'),
                                                                                                        ('U0160', 'Andrés Méndez', 'andres.mendez@example.com', 'Perú', '2024-04-07', 'https://example.com/avatars/andres.jpg', '+51987654334'),
                                                                                                        ('U0161', 'Lidia Delgado', 'lidia.delgado@example.com', 'España', '2024-04-08', 'https://example.com/avatars/lidia.jpg', '+34678901248'),
                                                                                                        ('U0162', 'Iván Cruz', 'ivan.cruz@example.com', 'México', '2024-04-09', 'https://example.com/avatars/ivan.jpg', '+525512345692'),
                                                                                                        ('U0163', 'Camila Martínez', 'camila.martinez@example.com', 'Argentina', '2024-04-10', 'https://example.com/avatars/camila.jpg', '+5491167891248'),
                                                                                                        ('U0164', 'Alberto Gil', 'alberto.gil@example.com', 'Chile', '2024-04-11', 'https://example.com/avatars/alberto.jpg', '+569987654335'),
                                                                                                        ('U0165', 'Yolanda Vargas', 'yolanda.vargas@example.com', 'Colombia', '2024-04-12', 'https://example.com/avatars/yolanda.jpg', '+573212345692'),
                                                                                                        ('U0166', 'Sergio Ramos', 'sergio.ramos@example.com', 'Uruguay', '2024-04-13', 'https://example.com/avatars/sergio.jpg', '+59891234581'),
                                                                                                        ('U0167', 'Natalia Méndez', 'natalia.mendez@example.com', 'Perú', '2024-04-14', 'https://example.com/avatars/natalia.jpg', '+51987654335'),
                                                                                                        ('U0168', 'Pedro Ortega', 'pedro.ortega@example.com', 'España', '2024-04-15', 'https://example.com/avatars/pedro.jpg', '+34678901249'),
                                                                                                        ('U0169', 'Carmen Sánchez', 'carmen.sanchez@example.com', 'México', '2024-04-16', 'https://example.com/avatars/carmen.jpg', '+525512345693'),
                                                                                                        ('U0170', 'Elena Jiménez', 'elena.jimenez@example.com', 'Argentina', '2024-04-17', 'https://example.com/avatars/elena.jpg', '+5491167891249'),
                                                                                                        ('U0171', 'Hugo Vargas', 'hugo.vargas@example.com', 'Chile', '2024-04-18', 'https://example.com/avatars/hugo.jpg', '+569987654336'),
                                                                                                        ('U0172', 'Lucía Torres', 'lucia.torres@example.com', 'Colombia', '2024-04-19', 'https://example.com/avatars/lucia.jpg', '+573212345693'),
                                                                                                        ('U0173', 'Federico Fuentes', 'federico.fuentes@example.com', 'Uruguay', '2024-04-20', 'https://example.com/avatars/federico.jpg', '+59891234582'),
                                                                                                        ('U0174', 'Miriam Delgado', 'miriam.delgado@example.com', 'Perú', '2024-04-21', 'https://example.com/avatars/miriam.jpg', '+51987654336'),
                                                                                                        ('U0175', 'Adriana Martínez', 'adriana.martinez@example.com', 'España', '2024-04-22', 'https://example.com/avatars/adriana.jpg', '+34678901250'),
                                                                                                        ('U0176', 'Rubén Sánchez', 'ruben.sanchez@example.com', 'México', '2024-04-23', 'https://example.com/avatars/ruben.jpg', '+525512345694'),
                                                                                                        ('U0177', 'María Vargas', 'maria.vargas@example.com', 'Argentina', '2024-04-24', 'https://example.com/avatars/maria.jpg', '+5491167891250'),
                                                                                                        ('U0178', 'Jorge Gil', 'jorge.gil@example.com', 'Chile', '2024-04-25', 'https://example.com/avatars/jorge.jpg', '+569987654337'),
                                                                                                        ('U0179', 'Isabel Herrera', 'isabel.herrera@example.com', 'Colombia', '2024-04-26', 'https://example.com/avatars/isabel.jpg', '+573212345694'),
                                                                                                        ('U0180', 'Rafael Paredes', 'rafael.paredes@example.com', 'Uruguay', '2024-04-27', 'https://example.com/avatars/rafael.jpg', '+59891234583'),
                                                                                                        ('U0181', 'Laure Escobar', 'laure.escobar@example.com', 'Perú', '2024-04-28', 'https://example.com/avatars/laura.jpg', '+51987654337'),
                                                                                                        ('U0182', 'Esther Jiménez', 'esther.jimenez@example.com', 'España', '2024-04-29', 'https://example.com/avatars/esther.jpg', '+34678901251'),
                                                                                                        ('U0183', 'Cristian Martínez', 'cristian.martinez@example.com', 'México', '2024-04-30', 'https://example.com/avatars/cristian.jpg', '+525512345695'),
                                                                                                        ('U0184', 'Tania Fuentes', 'tania.fuentes@example.com', 'Argentina', '2024-05-01', 'https://example.com/avatars/tania.jpg', '+5491167891251'),
                                                                                                        ('U0185', 'Vicente Gil', 'vicente.gil@example.com', 'Chile', '2024-05-02', 'https://example.com/avatars/vicente.jpg', '+569987654338'),
                                                                                                        ('U0186', 'Soledad Vargas', 'soledad.vargas@example.com', 'Colombia', '2024-05-03', 'https://example.com/avatars/soledad.jpg', '+573212345695'),
                                                                                                        ('U0187', 'Antonio Blanco', 'antonio.blanco@example.com', 'Uruguay', '2024-05-04', 'https://example.com/avatars/antonio.jpg', '+59891234584'),
                                                                                                        ('U0188', 'Rosa Delgado', 'rosa.delgado@example.com', 'Perú', '2024-05-05', 'https://example.com/avatars/rosa.jpg', '+51987654338'),
                                                                                                        ('U0189', 'Diego Escobar', 'diego.escobar@example.com', 'España', '2024-05-06', 'https://example.com/avatars/diego.jpg', '+34678901252'),
                                                                                                        ('U0190', 'Ángela Sánchez', 'angela.sanchez@example.com', 'México', '2024-05-07', 'https://example.com/avatars/angela.jpg', '+525512345696'),
                                                                                                        ('U0191', 'Fernando Jiménez', 'fernando.jimenez@example.com', 'Argentina', '2024-05-08', 'https://example.com/avatars/fernando.jpg', '+5491167891252'),
                                                                                                        ('U0192', 'Mónica Torres', 'monica.torres@example.com', 'Chile', '2024-05-09', 'https://example.com/avatars/monica.jpg', '+569987654339'),
                                                                                                        ('U0193', 'Javier Vargas', 'javier.vargas@example.com', 'Colombia', '2024-05-10', 'https://example.com/avatars/javier.jpg', '+573212345696'),
                                                                                                        ('U0194', 'Susana Martínez', 'susana.martinez@example.com', 'Uruguay', '2024-05-11', 'https://example.com/avatars/susana.jpg', '+59891234585'),
                                                                                                        ('U0195', 'Anabel Herrera', 'anabel.herrera@example.com', 'Perú', '2024-05-12', 'https://example.com/avatars/anabel.jpg', '+51987654339'),
                                                                                                        ('U0196', 'Félix Martínez', 'felix.martinez@example.com', 'España', '2024-05-13', 'https://example.com/avatars/felix.jpg', '+34678901253'),
                                                                                                        ('U0197', 'Cecilia Jiménez', 'cecilia.jimenez@example.com', 'México', '2024-05-14', 'https://example.com/avatars/cecilia.jpg', '+525512345697'),
                                                                                                        ('U0198', 'Guadalupe Martínez', 'guadalupe.martinez@example.com', 'Argentina', '2024-05-15', 'https://example.com/avatars/guadalupe.jpg', '+5491167891253'),
                                                                                                        ('U0199', 'Enrique Martínez', 'enrique.martinez@example.com', 'Chile', '2024-05-16', 'https://example.com/avatars/enrique.jpg', '+569987654340'),
                                                                                                        ('U0200', 'Mariana Vargas', 'mariana.vargas@example.com', 'Colombia', '2024-05-17', 'https://example.com/avatars/mariana.jpg', '+573212345697'),
                                                                                                        ('U0201', 'Amalia Fuentes', 'amalia.fuentes@example.com', 'Uruguay', '2024-05-18', 'https://example.com/avatars/amalia.jpg', '+59891234586'),
                                                                                                        ('U0202', 'Patricio Herrera', 'patricio.herrera@example.com', 'Perú', '2024-05-19', 'https://example.com/avatars/patricio.jpg', '+51987654340'),
                                                                                                        ('U0203', 'Lorena Vargas', 'lorena.vargas@example.com', 'España', '2024-05-20', 'https://example.com/avatars/lorena.jpg', '+34678901254'),
                                                                                                        ('U0204', 'Esteban Jiménez', 'esteban.jimenez@example.com', 'México', '2024-05-21', 'https://example.com/avatars/esteban.jpg', '+525512345698'),
                                                                                                        ('U0205', 'Rosa Blanco', 'rosa.blanco@example.com', 'Argentina', '2024-05-22', 'https://example.com/avatars/rosa.jpg', '+5491167891254'),
                                                                                                        ('U0206', 'Miguel Paredes', 'miguel.paredes@example.com', 'Chile', '2024-05-23', 'https://example.com/avatars/miguel.jpg', '+569987654341'),
                                                                                                        ('U0207', 'Elena Escobar', 'elena.escobar@example.com', 'Colombia', '2024-05-24', 'https://example.com/avatars/elena.jpg', '+573212345698'),
                                                                                                        ('U0208', 'José Gil', 'jose.gil@example.com', 'Uruguay', '2024-05-25', 'https://example.com/avatars/jose.jpg', '+59891234587'),
                                                                                                        ('U0209', 'Luisa Delgado', 'luisa.delgado@example.com', 'Perú', '2024-05-26', 'https://example.com/avatars/luisa.jpg', '+51987654341'),
                                                                                                        ('U0210', 'César Sánchez', 'cesar.sanchez@example.com', 'España', '2024-05-27', 'https://example.com/avatars/cesar.jpg', '+34678901255'),
                                                                                                        ('U0211', 'Andrea Ramírez', 'andrea.ramirez@example.com', 'México', '2024-05-28', 'https://example.com/avatars/andrea.jpg', '+525512345699'),
                                                                                                        ('U0212', 'Luis Torres', 'luis.torres@example.com', 'Argentina', '2024-05-29', 'https://example.com/avatars/luis.jpg', '+5491167891255'),
                                                                                                        ('U0213', 'Gabriela Herrera', 'gabriela.herrera@example.com', 'Chile', '2024-05-30', 'https://example.com/avatars/gabriela.jpg', '+569987654342'),
                                                                                                        ('U0214', 'Francisco Fuentes', 'francisco.fuentes@example.com', 'Colombia', '2024-05-31', 'https://example.com/avatars/francisco.jpg', '+573212345699'),
                                                                                                        ('U0215', 'Carla Gil', 'carla.gil@example.com', 'Uruguay', '2024-06-01', 'https://example.com/avatars/carla.jpg', '+59891234588'),
                                                                                                        ('U0216', 'Renata Jiménez', 'renata.jimenez@example.com', 'Perú', '2024-06-02', 'https://example.com/avatars/renata.jpg', '+51987654342'),
                                                                                                        ('U0217', 'Ignacio Vargas', 'ignacio.vargas@example.com', 'España', '2024-06-03', 'https://example.com/avatars/ignacio.jpg', '+34678901256'),
                                                                                                        ('U0218', 'Isabel Martínez', 'isabel.martinez@example.com', 'México', '2024-06-04', 'https://example.com/avatars/isabel.jpg', '+525512345700'),
                                                                                                        ('U0219', 'Octavio Blanco', 'octavio.blanco@example.com', 'Argentina', '2024-06-05', 'https://example.com/avatars/octavio.jpg', '+5491167891256'),
                                                                                                        ('U0220', 'Daniela Escobar', 'daniela.escobar@example.com', 'Chile', '2024-06-06', 'https://example.com/avatars/daniela.jpg', '+569987654343'),
                                                                                                        ('U0221', 'Emilio Delgado', 'emilio.delgado@example.com', 'Colombia', '2024-06-07', 'https://example.com/avatars/emilio.jpg', '+573212345700'),
                                                                                                        ('U0222', 'Marisol Torres', 'marisol.torres@example.com', 'Uruguay', '2024-06-08', 'https://example.com/avatars/marisol.jpg', '+59891234589');

-- Inserciones en la tabla resena
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0001', 'J0001', 'U0001', 95, 'Un juego revolucionario. Absolutamente imprescindible.', '2023-06-01'),
                                                                                        ('R0002', 'J0002', 'U0002', 90, 'Una secuela épica. Gran mejora respecto al anterior.', '2023-07-15'),
                                                                                        ('R0003', 'J0003', 'U0003', 87, 'La creatividad de este juego es increíble.', '2023-08-10'),
                                                                                        ('R0004', 'J0004', 'U0004', 89, 'Excelente estilo y jugabilidad fluida.', '2023-08-20'),
                                                                                        ('R0005', 'J0005', 'U0005', 92, 'Difícil pero gratificante. Una joya indie.', '2023-09-05'),
                                                                                        ('R0006', 'J0006', 'U0006', 88, 'Arte visual impresionante y gameplay entretenido.', '2023-09-10'),
                                                                                        ('R0007', 'J0007', 'U0001', 93, 'Ideal para relajarse. Una experiencia única.', '2023-09-15'),
                                                                                        ('R0008', 'J0008', 'U0002', 85, 'Buena historia, pero un poco corto.', '2023-09-20'),
                                                                                        ('R0009', 'J0009', 'U0003', 84, 'Un juego sólido, aunque esperaba más.', '2023-10-01'),
                                                                                        ('R0010', 'J0010', 'U0004', 96, 'Horas y horas de diversión en esta isla.', '2023-10-05'),
                                                                                        ('R0011', 'J0011', 'U0005', 94, 'Un RPG de mundo abierto simplemente espectacular.', '2023-10-10'),
                                                                                        ('R0012', 'J0012', 'U0006', 91, 'Estrategia y narrativa perfectamente combinadas.', '2023-10-15'),
                                                                                        ('R0013', 'J0013', 'U0007', 88, 'Gran historia y mecánicas fluidas.', '2023-10-20'),
                                                                                        ('R0014', 'J0014', 'U0008', 90, 'Monstruos épicos y gran diseño de niveles.', '2023-10-25'),
                                                                                        ('R0015', 'J0015', 'U0009', 82, 'Divertido con amigos, pero se vuelve repetitivo.', '2023-11-01'),
                                                                                        ('R0016', 'J0016', 'U0010', 89, 'Acción frenética y gráficos increíbles.', '2023-11-05'),
                                                                                        ('R0017', 'J0017', 'U0011', 95, 'Una obra maestra de narrativa y emociones.', '2023-11-10'),
                                                                                        ('R0018', 'J0018', 'U0012', 85, 'Divertido, pero el matchmaking podría mejorar.', '2023-11-15'),
                                                                                        ('R0019', 'J0019', 'U0001', 93, 'Un roguelike adictivo con un gran diseño.', '2023-11-20'),
                                                                                        ('R0020', 'J0020', 'U0002', 90, 'Una historia profunda y conmovedora.', '2023-11-25'),
                                                                                        ('R0021', 'J0021', 'U0003', 94, 'Mundo abierto fascinante y desafiante.', '2023-12-01'),
                                                                                        ('R0022', 'J0022', 'U0004', 79, 'Narrativa sólida y mecánicas divertidas.', '2023-12-05'),
                                                                                        ('R0023', 'J0023', 'U0005', 80, 'Simpático, pero un poco superficial.', '2023-12-10'),
                                                                                        ('R0024', 'J0024', 'U0006', 89, 'Perfecto para jugar con amigos.', '2023-12-15'),
                                                                                        ('R0025', 'J0025', 'U0007', 92, 'Gráficos impresionantes y carreras emocionantes.', '2023-12-20'),
                                                                                        ('R0026', 'J0026', 'U0008', 86, 'Un concepto único, pero a veces frustrante.', '2023-12-25'),
                                                                                        ('R0027', 'J0027', 'U0009', 90, 'Pura creatividad en cada nivel.', '2024-01-01'),
                                                                                        ('R0028', 'J0028', 'U0010', 88, 'Historia oscura y mecánicas de juego interesantes.', '2024-01-05'),
                                                                                        ('R0029', 'J0029', 'U0011', 84, 'Visualmente impresionante, pero algo corto.', '2024-01-10'),
                                                                                        ('R0030', 'J0030', 'U0012', 94, 'Un clásico moderno con puzzles geniales.', '2024-01-15'),
                                                                                        ('R0031', 'J0031', 'U0001', 87, 'Una reimaginación fiel pero innovadora.', '2024-01-20'),
                                                                                        ('R0032', 'J0032', 'U0002', 96, 'Un RPG elegante y profundo.', '2024-01-25'),
                                                                                        ('R0033', 'J0033', 'U0003', 85, 'Mecánicas originales y buena exploración.', '2024-02-01'),
                                                                                        ('R0034', 'J0034', 'U0004', 90, 'Desafiante y con combates precisos.', '2024-02-05'),
                                                                                        ('R0035', 'J0035', 'U0005', 91, 'Una mezcla interesante de humor y acción.', '2024-02-10'),
                                                                                        ('R0036', 'J0036', 'U0006', 89, 'Un mundo inmersivo con muchas posibilidades.', '2024-02-15'),
                                                                                        ('R0037', 'J0037', 'U0007', 84, 'Un buen roguelike, aunque algo repetitivo.', '2024-02-20'),
                                                                                        ('R0038', 'J0038', 'U0008', 92, 'Original, desafiante y visualmente impactante.', '2024-02-25'),
                                                                                        ('R0039', 'J0039', 'U0009', 88, 'Gran concepto, pero la ejecución podría mejorar.', '2024-03-01'),
                                                                                        ('R0040', 'J0040', 'U0010', 93, 'Oscuro y fascinante, un juego de culto.', '2024-03-05'),
                                                                                        ('R0041', 'J0041', 'U0011', 90, 'Cooperativo excepcional y muy bien diseñado.', '2024-03-10'),
                                                                                        ('R0042', 'J0042', 'U0012', 89, 'Diversión garantizada en cada carrera.', '2024-03-15'),
                                                                                        ('R0043', 'J0043', 'U0001', 94, 'Una locura de acción y personajes icónicos.', '2024-03-20'),
                                                                                        ('R0044', 'J0044', 'U0002', 87, 'Rápido, frenético y muy competitivo.', '2024-03-25'),
                                                                                        ('R0045', 'J0045', 'U0003', 90, 'Juego en equipo con gran atención al detalle.', '2024-04-01'),
                                                                                        ('R0046', 'J0046', 'U0004', 83, 'Divertido, aunque no para todos los gustos.', '2024-04-05'),
                                                                                        ('R0047', 'J0047', 'U0005', 89, 'Un battle royale entretenido.', '2024-04-10'),
                                                                                        ('R0048', 'J0048', 'U0006', 85, 'Interesante, pero con una curva de aprendizaje alta.', '2024-04-15'),
                                                                                        ('R0049', 'J0049', 'U0007', 91, 'Acción en primera persona al máximo nivel.', '2024-04-20'),
                                                                                        ('R0050', 'J0050', 'U0008', 93, 'Un survival horror moderno y bien ejecutado.', '2024-04-25'),
                                                                                        ('R0051', 'J0051', 'U0009', 94, 'Una obra maestra de Nintendo.', '2024-05-01'),
                                                                                        ('R0052', 'J0052', 'U0010', 88, 'Visualmente hermoso y con gran jugabilidad.', '2024-05-05'),
                                                                                        ('R0053', 'J0053', 'U0011', 86, 'Divertido, pero un poco repetitivo.', '2024-05-10'),
                                                                                        ('R0054', 'J0054', 'U0012', 89, 'Un shooter intenso con gran historia.', '2024-05-15'),
                                                                                        ('R0055', 'J0055', 'U0001', 84, 'Encantador y lleno de magia.', '2024-05-20'),
                                                                                        ('R0056', 'J0056', 'U0002', 87, 'Narrativa única y mecánicas innovadoras.', '2024-05-25'),
                                                                                        ('R0057', 'J0057', 'U0003', 90, 'Una experiencia de bucle temporal brillante.', '2024-06-01'),
                                                                                        ('R0058', 'J0058', 'U0004', 93, 'Carreras de mundo abierto y paisajes espectaculares.', '2024-06-05'),
                                                                                        ('R0059', 'J0059', 'U0005', 88, 'Un remake fiel y visualmente impactante.', '2024-06-10'),
                                                                                        ('R0060', 'J0060', 'U0006', 90, 'Un juego mágico con gran atención al detalle.', '2024-06-15'),
                                                                                        ('R0061', 'J0061', 'U0007', 92, 'Un RPG espacial impresionante.', '2024-06-20'),
                                                                                        ('R0062', 'J0062', 'U0008', 95, 'Un juego que define el género de aventuras.', '2024-06-25'),
                                                                                        ('R0063', 'J0063', 'U0009', 87, 'Visualmente atractivo y entretenido.', '2024-07-01'),
                                                                                        ('R0064', 'J0064', 'U0010', 89, 'Luchas intensas y gran diseño.', '2024-07-05'),
                                                                                        ('R0065', 'J0065', 'U0011', 93, 'Un ARPG épico con contenido interminable.', '2024-07-10'),
                                                                                        ('R0066', 'J0066', 'U0012', 96, 'Una narrativa brillante y combates profundos.', '2024-07-15'),
                                                                                        ('R0067', 'J0067', 'U0001', 85, 'Entretenido, pero no tan innovador.', '2024-07-20'),
                                                                                        ('R0068', 'J0068', 'U0002', 88, 'Oscuro y atmosférico. Muy recomendable.', '2024-07-25'),
                                                                                        ('R0069', 'J0069', 'U0003', 94, 'Un juego que establece nuevos estándares.', '2024-08-01'),
                                                                                        ('R0070', 'J0070', 'U0004', 91, 'Ideal para los fanáticos del fútbol.', '2024-08-05'),
                                                                                        ('R0071', 'J0071', 'U0005', 89, 'Una entrega sólida de la saga.', '2024-08-10'),
                                                                                        ('R0072', 'J0072', 'U0006', 90, 'Una expansión que eleva el juego base.', '2024-08-15'),
                                                                                        ('R0073', 'J0073', 'U0007', 87, 'Emocionante y prometedor.', '2024-08-20'),
                                                                                        ('R0074', 'J0074', 'U0008', 92, 'Una entrega muy esperada y gratificante.', '2024-08-25'),
                                                                                        ('R0075', 'J0075', 'U0009', 85, 'Interesante, pero se siente incompleto.', '2024-09-01'),
                                                                                        ('R0076', 'J0076', 'U0010', 94, 'El mundo abierto más ambicioso jamás creado.', '2024-09-05'),
                                                                                        ('R0077', 'J0077', 'U0011', 95, 'Una obra maestra del mundo criminal.', '2024-09-10'),
                                                                                        ('R0078', 'J0078', 'U0012', 88, 'Un remake bien ejecutado.', '2024-09-15'),
                                                                                        ('R0079', 'J0079', 'U0001', 93, 'Una continuación esperada que no decepciona.', '2024-09-20'),
                                                                                        ('R0080', 'J0080', 'U0002', 90, 'Narrativa excelente y visualmente impresionante.', '2024-09-25'),
                                                                                        ('R0081', 'J0081', 'U0003', 86, 'Un juego prometedor con gran potencial.', '2024-10-01'),
                                                                                        ('R0082', 'J0082', 'U0004', 89, 'Un indie sobresaliente con gran corazón.', '2024-10-05');

-- Reseñas negativas
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0083', 'J0010', 'U0005', 30, 'Monótono y aburrido, esperaba mucho más.', '2024-10-06'),
                                                                                        ('R0084', 'J0025', 'U0006', 40, 'El rendimiento técnico deja mucho que desear.', '2024-10-07'),
                                                                                        ('R0085', 'J0038', 'U0010', 25, 'La mecánica de juego es confusa y frustrante.', '2024-10-08'),
                                                                                        ('R0086', 'J0050', 'U0011', 35, 'Un diseño anticuado que no innova.', '2024-10-09'),
                                                                                        ('R0087', 'J0047', 'U0012', 20, 'Poco equilibrado y lleno de bugs.', '2024-10-10'),
                                                                                        ('R0088', 'J0069', 'U0002', 45, 'El contenido es repetitivo y sin inspiración.', '2024-10-11'),
                                                                                        ('R0089', 'J0071', 'U0003', 10, 'Realmente no vale la pena el tiempo invertido.', '2024-10-12'),
                                                                                        ('R0090', 'J0055', 'U0004', 38, 'La historia prometía más de lo que entrega.', '2024-10-13'),
                                                                                        ('R0091', 'J0060', 'U0007', 15, 'No cumple con los estándares de calidad actuales.', '2024-10-14'),
                                                                                        ('R0092', 'J0039', 'U0008', 25, 'Desbalanceado y con errores persistentes.', '2024-10-15'),
                                                                                        ('R0093', 'J0042', 'U0009', 35, 'Repetitivo y sin innovación alguna.', '2024-10-16'),
                                                                                        ('R0094', 'J0075', 'U0001', 28, 'Demasiado corto y sin desarrollo significativo.', '2024-10-17'),
                                                                                        ('R0095', 'J0079', 'U0006', 20, 'Las expectativas eran altas, pero resultó decepcionante.', '2024-10-18'),
                                                                                        ('R0096', 'J0064', 'U0012', 45, 'La jugabilidad es torpe y poco atractiva.', '2024-10-19'),
                                                                                        ('R0097', 'J0073', 'U0010', 30, 'Poco esfuerzo en el diseño de niveles.', '2024-10-20'),
                                                                                        ('R0098', 'J0022', 'U0011', 10, 'Un desperdicio de potencial en todos los aspectos.', '2024-10-21'),
                                                                                        ('R0099', 'J0034', 'U0012', 20, 'El combate es tedioso y la historia plana.', '2024-10-22'),
                                                                                        ('R0100', 'J0014', 'U0005', 18, 'Parece inacabado y lleno de errores.', '2024-10-23'),
                                                                                        ('R0101', 'J0040', 'U0007', 40, 'Gráficos mediocres y jugabilidad básica.', '2024-10-24'),
                                                                                        ('R0102', 'J0024', 'U0008', 35, 'Un concepto interesante, pero mal ejecutado.', '2024-10-25');

INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha)
VALUES
    ('R0103', 'J0024', 'U0010', 40, 'Mucho potencial, pero decepciona en casi todo.', '2024-10-26'),
    ('R0104', 'J0024', 'U0012', 28, 'Bugs constantes y rendimiento pésimo.', '2024-10-27'),
    ('R0105', 'J0024', 'U0015', 45, 'La historia no engancha y los gráficos son mediocres.', '2024-10-28'),
    ('R0106', 'J0024', 'U0016', 33, 'Esperaba más, me aburrí en la primera hora.', '2024-10-29'),
    ('R0107', 'J0024', 'U0019', 22, 'No se puede jugar bien, muy mal optimizado.', '2024-10-30'),
    ('R0108', 'J0024', 'U0020', 15, 'Una decepción total. Dinero tirado.', '2024-11-01'),
    ('R0109', 'J0024', 'U0021', 39, 'Se hace repetitivo muy rápido.', '2024-11-02'),
    ('R0110', 'J0024', 'U0022', 48, 'Solo salva la música. Lo demás es un desastre.', '2024-11-03'),
    ('R0111', 'J0024', 'U0023', 29, 'Ideas buenas, ejecución pésima.', '2024-11-04'),
    ('R0112', 'J0024', 'U0024', 20, 'Me obligué a terminarlo, pero no lo recomiendo.', '2024-11-05');

-- Reseñas negativas para el juego J0011
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0113', 'J0011', 'U0025', 40, 'Prometía mucho, pero se queda corto.', '2024-11-06'),
                                                                                        ('R0114', 'J0011', 'U0026', 38, 'Controles poco intuitivos y sin emoción.', '2024-11-07'),
                                                                                        ('R0115', 'J0011', 'U0027', 45, 'Muy repetitivo y sin profundidad.', '2024-11-08');

-- Reseñas negativas para el juego J0015
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0116', 'J0015', 'U0028', 30, 'Gráficos decentes, pero jugabilidad aburrida.', '2024-11-09'),
                                                                                        ('R0117', 'J0015', 'U0029', 20, 'Crash constante, injugable.', '2024-11-10'),
                                                                                        ('R0118', 'J0015', 'U0030', 42, 'Lo terminé por compromiso, no por diversión.', '2024-11-11');

-- Reseñas negativas para el juego J0018
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0119', 'J0018', 'U0031', 18, 'El peor juego que he comprado este año.', '2024-11-12'),
                                                                                        ('R0120', 'J0018', 'U0032', 33, 'El ritmo es muy lento y mal estructurado.', '2024-11-13'),
                                                                                        ('R0121', 'J0018', 'U0033', 44, 'Corto, caro y mal optimizado.', '2024-11-14');

-- Reseñas negativas para el juego J0020
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0122', 'J0020', 'U0034', 39, 'El modo historia es muy pobre.', '2024-11-15'),
                                                                                        ('R0123', 'J0020', 'U0035', 25, 'Nada que ver con lo prometido en los tráilers.', '2024-11-16'),
                                                                                        ('R0124', 'J0020', 'U0036', 30, 'Solo lo salva la banda sonora.', '2024-11-17');

-- Reseñas negativas para el juego J0022
INSERT INTO resena (id_resena, id_juego, id_usuario, puntuacion, comentario, fecha) VALUES
                                                                                        ('R0125', 'J0022', 'U0037', 29, 'Un clon barato de otros juegos mejores.', '2024-11-18'),
                                                                                        ('R0126', 'J0022', 'U0038', 41, 'Nada memorable, lo olvidé en dos días.', '2024-11-19'),
                                                                                        ('R0127', 'J0022', 'U0039', 34, 'Mecánicas rotas y falta de contenido.', '2024-11-20');


-- Inserciones en la tabla compra
INSERT INTO compra (id_compra, id_usuario, id_juego, fecha_compra, metodo_pago) VALUES
                                                                                    ('C0001', 'U0001', 'J0001', '2024-01-15', 'Tarjeta de Crédito'),
                                                                                    ('C0002', 'U0002', 'J0002', '2024-02-10', 'PayPal'),
                                                                                    ('C0003', 'U0003', 'J0003', '2024-03-12', 'Transferencia Bancaria'),
                                                                                    ('C0004', 'U0004', 'J0004', '2024-04-08', 'Tarjeta de Débito'),
                                                                                    ('C0005', 'U0005', 'J0005', '2024-05-20', 'Tarjeta de Crédito'),
                                                                                    ('C0006', 'U0006', 'J0006', '2024-06-15', 'PayPal'),
                                                                                    ('C0007', 'U0007', 'J0007', '2024-07-10', 'Tarjeta de Débito'),
                                                                                    ('C0008', 'U0008', 'J0008', '2024-08-18', 'Transferencia Bancaria'),
                                                                                    ('C0009', 'U0009', 'J0009', '2024-09-22', 'Tarjeta de Crédito'),
                                                                                    ('C0010', 'U0010', 'J0010', '2024-10-01', 'PayPal'),
                                                                                    ('C0011', 'U0011', 'J0011', '2024-01-20', 'Tarjeta de Débito'),
                                                                                    ('C0012', 'U0012', 'J0012', '2024-02-14', 'Tarjeta de Crédito'),
                                                                                    ('C0013', 'U0001', 'J0013', '2024-03-03', 'PayPal'),
                                                                                    ('C0014', 'U0002', 'J0014', '2024-04-19', 'Transferencia Bancaria'),
                                                                                    ('C0015', 'U0003', 'J0015', '2024-05-23', 'Tarjeta de Crédito'),
                                                                                    ('C0016', 'U0004', 'J0016', '2024-06-11', 'Tarjeta de Débito'),
                                                                                    ('C0017', 'U0005', 'J0017', '2024-07-30', 'PayPal'),
                                                                                    ('C0018', 'U0006', 'J0018', '2024-08-09', 'Tarjeta de Crédito'),
                                                                                    ('C0019', 'U0007', 'J0019', '2024-09-25', 'Tarjeta de Débito'),
                                                                                    ('C0020', 'U0008', 'J0020', '2024-10-15', 'Transferencia Bancaria'),
                                                                                    ('C0021', 'U0009', 'J0021', '2024-01-10', 'Tarjeta de Crédito'),
                                                                                    ('C0022', 'U0010', 'J0022', '2024-02-08', 'PayPal'),
                                                                                    ('C0023', 'U0011', 'J0023', '2024-03-06', 'Tarjeta de Débito'),
                                                                                    ('C0024', 'U0012', 'J0024', '2024-04-03', 'Transferencia Bancaria'),
                                                                                    ('C0025', 'U0001', 'J0025', '2024-05-01', 'Tarjeta de Crédito'),
                                                                                    ('C0026', 'U0002', 'J0026', '2024-06-12', 'PayPal'),
                                                                                    ('C0027', 'U0003', 'J0027', '2024-07-18', 'Tarjeta de Débito'),
                                                                                    ('C0028', 'U0004', 'J0028', '2024-08-29', 'Transferencia Bancaria'),
                                                                                    ('C0029', 'U0005', 'J0029', '2024-09-30', 'Tarjeta de Crédito'),
                                                                                    ('C0030', 'U0006', 'J0030', '2024-10-05', 'PayPal'),
                                                                                    ('C0031', 'U0013', 'J0031', '2024-01-15', 'Tarjeta de Débito'),
                                                                                    ('C0032', 'U0014', 'J0032', '2024-02-11', 'Transferencia Bancaria'),
                                                                                    ('C0033', 'U0015', 'J0033', '2024-03-05', 'Tarjeta de Crédito'),
                                                                                    ('C0034', 'U0016', 'J0034', '2024-04-08', 'PayPal'),
                                                                                    ('C0035', 'U0017', 'J0035', '2024-05-22', 'Tarjeta de Débito'),
                                                                                    ('C0036', 'U0018', 'J0036', '2024-06-15', 'Transferencia Bancaria'),
                                                                                    ('C0037', 'U0019', 'J0037', '2024-07-09', 'Tarjeta de Crédito'),
                                                                                    ('C0038', 'U0020', 'J0038', '2024-08-17', 'PayPal'),
                                                                                    ('C0039', 'U0021', 'J0039', '2024-09-14', 'Tarjeta de Débito'),
                                                                                    ('C0040', 'U0022', 'J0040', '2024-10-01', 'Transferencia Bancaria'),
                                                                                    ('C0041', 'U0023', 'J0041', '2024-01-10', 'Tarjeta de Crédito'),
                                                                                    ('C0042', 'U0024', 'J0042', '2024-02-18', 'PayPal'),
                                                                                    ('C0043', 'U0025', 'J0043', '2024-03-22', 'Tarjeta de Débito'),
                                                                                    ('C0044', 'U0026', 'J0044', '2024-04-20', 'Transferencia Bancaria'),
                                                                                    ('C0045', 'U0027', 'J0045', '2024-05-15', 'Tarjeta de Crédito'),
                                                                                    ('C0046', 'U0028', 'J0046', '2024-06-18', 'PayPal'),
                                                                                    ('C0047', 'U0029', 'J0047', '2024-07-14', 'Tarjeta de Débito'),
                                                                                    ('C0048', 'U0030', 'J0048', '2024-08-10', 'Transferencia Bancaria'),
                                                                                    ('C0049', 'U0031', 'J0049', '2024-09-07', 'Tarjeta de Crédito'),
                                                                                    ('C0050', 'U0032', 'J0050', '2024-10-01', 'PayPal'),
                                                                                    ('C0051', 'U0033', 'J0051', '2024-01-20', 'Tarjeta de Débito'),
                                                                                    ('C0052', 'U0034', 'J0052', '2024-02-10', 'Transferencia Bancaria'),
                                                                                    ('C0053', 'U0035', 'J0053', '2024-03-15', 'Tarjeta de Crédito'),
                                                                                    ('C0054', 'U0036', 'J0054', '2024-04-11', 'PayPal'),
                                                                                    ('C0055', 'U0037', 'J0055', '2024-05-20', 'Tarjeta de Débito'),
                                                                                    ('C0056', 'U0038', 'J0056', '2024-06-22', 'Transferencia Bancaria'),
                                                                                    ('C0057', 'U0039', 'J0057', '2024-07-18', 'Tarjeta de Crédito'),
                                                                                    ('C0058', 'U0040', 'J0058', '2024-08-12', 'PayPal'),
                                                                                    ('C0059', 'U0041', 'J0059', '2024-09-25', 'Tarjeta de Débito'),
                                                                                    ('C0060', 'U0042', 'J0060', '2024-10-14', 'Transferencia Bancaria'),
                                                                                    ('C0061', 'U0043', 'J0061', '2024-01-19', 'Tarjeta de Crédito'),
                                                                                    ('C0062', 'U0044', 'J0062', '2024-02-15', 'PayPal'),
                                                                                    ('C0063', 'U0045', 'J0063', '2024-03-13', 'Tarjeta de Débito'),
                                                                                    ('C0064', 'U0046', 'J0064', '2024-04-10', 'Transferencia Bancaria'),
                                                                                    ('C0065', 'U0047', 'J0065', '2024-05-25', 'Tarjeta de Crédito'),
                                                                                    ('C0066', 'U0048', 'J0066', '2024-06-29', 'PayPal'),
                                                                                    ('C0067', 'U0049', 'J0067', '2024-07-13', 'Tarjeta de Débito'),
                                                                                    ('C0068', 'U0050', 'J0068', '2024-08-15', 'Tarjeta de crédito'),
                                                                                    ('C0069', 'U0051', 'J0069', '2024-09-12', 'PayPal'),
                                                                                    ('C0070', 'U0052', 'J0070', '2024-10-05', 'Transferencia bancaria'),
                                                                                    ('C0071', 'U0053', 'J0071', '2024-01-28', 'Tarjeta de crédito'),
                                                                                    ('C0072', 'U0054', 'J0072', '2024-02-18', 'PayPal'),
                                                                                    ('C0073', 'U0055', 'J0073', '2024-03-22', 'Tarjeta de crédito'),
                                                                                    ('C0074', 'U0056', 'J0074', '2024-04-19', 'Tarjeta de crédito'),
                                                                                    ('C0075', 'U0057', 'J0075', '2024-05-20', 'PayPal'),
                                                                                    ('C0076', 'U0058', 'J0076', '2024-06-15', 'Transferencia bancaria'),
                                                                                    ('C0077', 'U0059', 'J0077', '2024-07-08', 'Tarjeta de crédito'),
                                                                                    ('C0078', 'U0060', 'J0078', '2024-08-12', 'PayPal'),
                                                                                    ('C0079', 'U0061', 'J0079', '2024-09-14', 'Tarjeta de crédito'),
                                                                                    ('C0080', 'U0062', 'J0080', '2024-10-20', 'Transferencia bancaria'),
                                                                                    ('C0081', 'U0063', 'J0081', '2024-01-18', 'PayPal'),
                                                                                    ('C0082', 'U0064', 'J0082', '2024-02-11', 'Tarjeta de crédito'),
                                                                                    ('C0083', 'U0065', 'J0083', '2024-03-07', 'PayPal'),
                                                                                    ('C0084', 'U0066', 'J0084', '2024-04-03', 'Tarjeta de crédito'),
                                                                                    ('C0085', 'U0067', 'J0085', '2024-05-10', 'Transferencia bancaria'),
                                                                                    ('C0086', 'U0068', 'J0086', '2024-06-14', 'PayPal'),
                                                                                    ('C0087', 'U0069', 'J0087', '2024-07-05', 'Tarjeta de crédito'),
                                                                                    ('C0088', 'U0070', 'J0088', '2024-08-09', 'PayPal'),
                                                                                    ('C0089', 'U0071', 'J0089', '2024-09-21', 'Tarjeta de crédito'),
                                                                                    ('C0090', 'U0072', 'J0090', '2024-10-18', 'Transferencia bancaria'),
                                                                                    ('C0091', 'U0073', 'J0091', '2024-01-24', 'PayPal'),
                                                                                    ('C0092', 'U0074', 'J0092', '2024-02-20', 'Tarjeta de crédito'),
                                                                                    ('C0093', 'U0075', 'J0093', '2024-03-18', 'PayPal'),
                                                                                    ('C0094', 'U0076', 'J0094', '2024-04-17', 'Transferencia bancaria'),
                                                                                    ('C0095', 'U0077', 'J0095', '2024-05-22', 'Tarjeta de crédito'),
                                                                                    ('C0096', 'U0078', 'J0096', '2024-06-26', 'PayPal'),
                                                                                    ('C0097', 'U0079', 'J0097', '2024-07-19', 'Tarjeta de crédito'),
                                                                                    ('C0100', 'U0082', 'J0100', '2024-10-29', 'Tarjeta de crédito'),
                                                                                    ('C0102', 'U0084', 'J0102', '2024-02-14', 'Transferencia bancaria'),
                                                                                    ('C0103', 'U0085', 'J0103', '2024-03-10', 'Tarjeta de crédito'),
                                                                                    ('C0104', 'U0086', 'J0104', '2024-04-13', 'PayPal'),
                                                                                    ('C0105', 'U0087', 'J0105', '2024-05-19', 'Tarjeta de crédito'),
                                                                                    ('C0106', 'U0088', 'J0106', '2024-06-20', 'Transferencia bancaria'),
                                                                                    ('C0107', 'U0089', 'J0107', '2024-07-18', 'PayPal'),
                                                                                    ('C0108', 'U0090', 'J0108', '2024-08-25', 'Tarjeta de crédito'),
                                                                                    ('C0109', 'U0091', 'J0109', '2024-09-27', 'Transferencia bancaria'),
                                                                                    ('C0110', 'U0092', 'J0110', '2024-10-15', 'Tarjeta de crédito'),
                                                                                    ('C0111', 'U0093', 'J0111', '2024-01-23', 'PayPal'),
                                                                                    ('C0112', 'U0094', 'J0112', '2024-02-17', 'Tarjeta de crédito'),
                                                                                    ('C0113', 'U0095', 'J0113', '2024-03-19', 'Transferencia bancaria'),
                                                                                    ('C0114', 'U0096', 'J0114', '2024-04-21', 'PayPal'),
                                                                                    ('C0116', 'U0098', 'J0116', '2024-06-22', 'Transferencia bancaria'),
                                                                                    ('C0117', 'U0099', 'J0117', '2024-07-16', 'PayPal'),
                                                                                    ('C0118', 'U0100', 'J0118', '2024-08-08', 'Tarjeta de crédito'),
                                                                                    ('C0119', 'U0101', 'J0119', '2024-09-15', 'PayPal'),
                                                                                    ('C0120', 'U0102', 'J0120', '2024-10-10', 'Transferencia bancaria'),
                                                                                    ('C0121', 'U0103', 'J0121', '2024-01-13', 'Tarjeta de crédito'),
                                                                                    ('C0122', 'U0104', 'J0122', '2024-02-18', 'PayPal'),
                                                                                    ('C0123', 'U0105', 'J0123', '2024-03-24', 'Transferencia bancaria'),
                                                                                    ('C0124', 'U0106', 'J0124', '2024-04-30', 'Tarjeta de crédito'),
                                                                                    ('C0125', 'U0107', 'J0125', '2024-05-20', 'Efectivo'),
                                                                                    ('C0126', 'U0108', 'J0126', '2024-06-10', 'Tarjeta de crédito'),
                                                                                    ('C0127', 'U0109', 'J0127', '2024-07-05', 'PayPal'),
                                                                                    ('C0128', 'U0110', 'J0128', '2024-08-15', 'Tarjeta de crédito'),
                                                                                    ('C0129', 'U0111', 'J0129', '2024-09-19', 'Transferencia bancaria'),
                                                                                    ('C0130', 'U0112', 'J0130', '2024-10-04', 'PayPal'),
                                                                                    ('C0131', 'U0113', 'J0131', '2024-01-14', 'Efectivo'),
                                                                                    ('C0132', 'U0114', 'J0132', '2024-02-20', 'Tarjeta de crédito'),
                                                                                    ('C0133', 'U0115', 'J0133', '2024-03-18', 'PayPal'),
                                                                                    ('C0134', 'U0116', 'J0134', '2024-04-27', 'Transferencia bancaria'),
                                                                                    ('C0135', 'U0117', 'J0135', '2024-05-31', 'Tarjeta de crédito'),
                                                                                    ('C0136', 'U0118', 'J0136', '2024-06-23', 'Efectivo'),
                                                                                    ('C0137', 'U0119', 'J0137', '2024-07-15', 'PayPal'),
                                                                                    ('C0138', 'U0120', 'J0138', '2024-08-07', 'Tarjeta de crédito'),
                                                                                    ('C0139', 'U0121', 'J0139', '2024-09-20', 'Transferencia bancaria'),
                                                                                    ('C0140', 'U0122', 'J0140', '2024-10-17', 'PayPal'),
                                                                                    ('C0141', 'U0123', 'J0141', '2024-01-30', 'Tarjeta de crédito'),
                                                                                    ('C0142', 'U0124', 'J0142', '2024-02-25', 'Transferencia bancaria'),
                                                                                    ('C0143', 'U0125', 'J0143', '2024-03-15', 'Efectivo'),
                                                                                    ('C0144', 'U0126', 'J0144', '2024-04-12', 'PayPal'),
                                                                                    ('C0145', 'U0127', 'J0145', '2024-05-21', 'Tarjeta de crédito'),
                                                                                    ('C0146', 'U0128', 'J0146', '2024-06-19', 'Transferencia bancaria'),
                                                                                    ('C0147', 'U0129', 'J0147', '2024-07-09', 'Efectivo'),
                                                                                    ('C0148', 'U0130', 'J0148', '2024-08-28', 'PayPal'),
                                                                                    ('C0149', 'U0131', 'J0149', '2024-09-14', 'Tarjeta de crédito'),
                                                                                    ('C0150', 'U0132', 'J0150', '2024-10-25', 'Transferencia bancaria'),
                                                                                    ('C0151', 'U0133', 'J0001', '2024-01-22', 'Efectivo'),
                                                                                    ('C0152', 'U0134', 'J0002', '2024-02-16', 'PayPal'),
                                                                                    ('C0153', 'U0135', 'J0003', '2024-03-11', 'Tarjeta de crédito'),
                                                                                    ('C0154', 'U0136', 'J0004', '2024-04-18', 'Transferencia bancaria'),
                                                                                    ('C0155', 'U0137', 'J0005', '2024-05-12', 'PayPal'),
                                                                                    ('C0156', 'U0138', 'J0006', '2024-06-26', 'Tarjeta de crédito'),
                                                                                    ('C0157', 'U0139', 'J0007', '2024-07-18', 'Transferencia bancaria'),
                                                                                    ('C0158', 'U0140', 'J0008', '2024-08-30', 'Efectivo'),
                                                                                    ('C0159', 'U0141', 'J0009', '2024-09-23', 'PayPal'),
                                                                                    ('C0160', 'U0142', 'J0010', '2024-10-08', 'Tarjeta de crédito'),
                                                                                    ('C0161', 'U0143', 'J0011', '2024-01-05', 'Transferencia bancaria'),
                                                                                    ('C0162', 'U0144', 'J0012', '2024-02-20', 'Efectivo'),
                                                                                    ('C0163', 'U0145', 'J0013', '2024-03-25', 'PayPal'),
                                                                                    ('C0164', 'U0146', 'J0014', '2024-04-21', 'Tarjeta de crédito'),
                                                                                    ('C0165', 'U0147', 'J0015', '2024-05-10', 'Transferencia bancaria'),
                                                                                    ('C0166', 'U0148', 'J0016', '2024-06-22', 'PayPal'),
                                                                                    ('C0167', 'U0149', 'J0017', '2024-07-19', 'Tarjeta de crédito'),
                                                                                    ('C0168', 'U0150', 'J0018', '2024-08-14', 'Transferencia bancaria'),
                                                                                    ('C0169', 'U0151', 'J0019', '2024-09-30', 'Efectivo'),
                                                                                    ('C0170', 'U0152', 'J0020', '2024-10-03', 'PayPal'),
                                                                                    ('C0171', 'U0153', 'J0021', '2024-01-09', 'Tarjeta de crédito'),
                                                                                    ('C0172', 'U0154', 'J0022', '2024-02-15', 'Transferencia bancaria'),
                                                                                    ('C0173', 'U0155', 'J0023', '2024-03-20', 'PayPal'),
                                                                                    ('C0174', 'U0156', 'J0024', '2024-04-27', 'Tarjeta de crédito'),
                                                                                    ('C0175', 'U0157', 'J0025', '2024-05-31', 'Transferencia bancaria'),
                                                                                    ('C0176', 'U0158', 'J0026', '2024-06-18', 'PayPal'),
                                                                                    ('C0177', 'U0159', 'J0027', '2024-07-25', 'Efectivo'),
                                                                                    ('C0178', 'U0160', 'J0028', '2024-08-30', 'Tarjeta de crédito'),
                                                                                    ('C0179', 'U0161', 'J0029', '2024-09-17', 'Transferencia bancaria'),
                                                                                    ('C0180', 'U0162', 'J0030', '2024-10-29', 'PayPal'),
                                                                                    ('C0181', 'U0163', 'J0031', '2024-01-20', 'Tarjeta de crédito'),
                                                                                    ('C0182', 'U0164', 'J0032', '2024-02-12', 'PayPal'),
                                                                                    ('C0183', 'U0165', 'J0033', '2024-03-15', 'Transferencia bancaria'),
                                                                                    ('C0184', 'U0166', 'J0034', '2024-04-22', 'Tarjeta de débito'),
                                                                                    ('C0185', 'U0167', 'J0035', '2024-05-19', 'Efectivo'),
                                                                                    ('C0186', 'U0168', 'J0036', '2024-06-25', 'Tarjeta de crédito'),
                                                                                    ('C0187', 'U0169', 'J0037', '2024-07-08', 'PayPal'),
                                                                                    ('C0188', 'U0170', 'J0038', '2024-08-19', 'Transferencia bancaria'),
                                                                                    ('C0189', 'U0171', 'J0039', '2024-09-11', 'Tarjeta de débito'),
                                                                                    ('C0190', 'U0172', 'J0040', '2024-10-07', 'Efectivo'),
                                                                                    ('C0191', 'U0173', 'J0041', '2024-01-29', 'Tarjeta de crédito'),
                                                                                    ('C0192', 'U0174', 'J0042', '2024-02-23', 'PayPal'),
                                                                                    ('C0193', 'U0175', 'J0043', '2024-03-17', 'Transferencia bancaria'),
                                                                                    ('C0194', 'U0176', 'J0044', '2024-04-16', 'Tarjeta de débito'),
                                                                                    ('C0195', 'U0177', 'J0045', '2024-05-12', 'Efectivo'),
                                                                                    ('C0196', 'U0178', 'J0046', '2024-06-14', 'Tarjeta de crédito'),
                                                                                    ('C0197', 'U0179', 'J0047', '2024-07-07', 'PayPal'),
                                                                                    ('C0198', 'U0180', 'J0048', '2024-08-04', 'Transferencia bancaria'),
                                                                                    ('C0199', 'U0181', 'J0049', '2024-09-27', 'Tarjeta de débito'),
                                                                                    ('C0200', 'U0182', 'J0050', '2024-10-20', 'Efectivo'),
                                                                                    ('C0201', 'U0182', 'J0051', '2024-01-18', 'Tarjeta de crédito'),
                                                                                    ('C0202', 'U0182', 'J0052', '2024-02-21', 'PayPal'),
                                                                                    ('C0203', 'U0182', 'J0053', '2024-03-09', 'Transferencia bancaria'),
                                                                                    ('C0204', 'U0182', 'J0054', '2024-04-24', 'Tarjeta de débito'),
                                                                                    ('C0205', 'U0182', 'J0055', '2024-05-13', 'Efectivo'),
                                                                                    ('C0206', 'U0182', 'J0056', '2024-06-15', 'Tarjeta de crédito'),
                                                                                    ('C0207', 'U0182', 'J0057', '2024-07-02', 'PayPal'),
                                                                                    ('C0208', 'U0182', 'J0058', '2024-08-13', 'Transferencia bancaria'),
                                                                                    ('C0209', 'U0182', 'J0059', '2024-09-06', 'Tarjeta de débito'),
                                                                                    ('C0210', 'U0182', 'J0060', '2024-10-12', 'Efectivo'),
                                                                                    ('C0211', 'U0182', 'J0061', '2024-01-07', 'Tarjeta de crédito'),
                                                                                    ('C0212', 'U0182', 'J0062', '2024-02-14', 'PayPal'),
                                                                                    ('C0213', 'U0182', 'J0063', '2024-03-16', 'Transferencia bancaria'),
                                                                                    ('C0214', 'U0182', 'J0064', '2024-04-10', 'Tarjeta de débito'),
                                                                                    ('C0215', 'U0182', 'J0065', '2024-05-22', 'Efectivo'),
                                                                                    ('C0216', 'U0182', 'J0066', '2024-06-11', 'Tarjeta de crédito'),
                                                                                    ('C0217', 'U0182', 'J0067', '2024-07-28', 'PayPal'),
                                                                                    ('C0218', 'U0182', 'J0068', '2024-08-21', 'Transferencia bancaria'),
                                                                                    ('C0219', 'U0201', 'J0069', '2024-09-25', 'Tarjeta de débito'),
                                                                                    ('C0220', 'U0202', 'J0070', '2024-10-19', 'Efectivo'),
                                                                                    ('C0221', 'U0203', 'J0071', '2024-01-28', 'Tarjeta de crédito'),
                                                                                    ('C0222', 'U0204', 'J0072', '2024-02-17', 'PayPal'),
                                                                                    ('C0223', 'U0205', 'J0073', '2024-03-30', 'Transferencia bancaria'),
                                                                                    ('C0224', 'U0206', 'J0074', '2024-04-29', 'Tarjeta de débito'),
                                                                                    ('C0225', 'U0207', 'J0075', '2024-05-23', 'Efectivo'),
                                                                                    ('C0226', 'U0208', 'J0076', '2024-06-20', 'Tarjeta de crédito'),
                                                                                    ('C0227', 'U0209', 'J0077', '2024-07-22', 'PayPal'),
                                                                                    ('C0228', 'U0210', 'J0078', '2024-08-10', 'Transferencia bancaria'),
                                                                                    ('C0229', 'U0211', 'J0079', '2024-09-19', 'Tarjeta de débito'),
                                                                                    ('C0230', 'U0212', 'J0080', '2024-10-16', 'Efectivo'),
                                                                                    ('C0231', 'U0213', 'J0081', '2024-01-12', 'Tarjeta de crédito'),
                                                                                    ('C0232', 'U0214', 'J0082', '2024-02-26', 'PayPal'),
                                                                                    ('C0233', 'U0215', 'J0083', '2024-03-06', 'Transferencia bancaria'),
                                                                                    ('C0234', 'U0216', 'J0084', '2024-04-04', 'Tarjeta de débito'),
                                                                                    ('C0235', 'U0217', 'J0085', '2024-05-30', 'Efectivo'),
                                                                                    ('C0236', 'U0218', 'J0086', '2024-06-08', 'Tarjeta de crédito'),
                                                                                    ('C0237', 'U0200', 'J0087', '2024-07-14', 'PayPal'),
                                                                                    ('C0238', 'U0210', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0239', 'U0100', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0240', 'U0001', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0241', 'U0202', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0242', 'U0203', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0243', 'U0211', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0244', 'U0215', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0245', 'U0218', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0246', 'U0199', 'J0150', '2024-07-14', 'PayPal'),
                                                                                    ('C0247', 'U0199', 'J0001', '2024-07-14', 'PayPal'),
                                                                                    ('C0248', 'U0201', 'J0133', '2024-03-20', 'Tarjeta de crédito'),
                                                                                    ('C0249', 'U0202', 'J0133', '2024-03-22', 'PayPal'),
                                                                                    ('C0250', 'U0203', 'J0134', '2024-04-28', 'Efectivo'),
                                                                                    ('C0251', 'U0204', 'J0134', '2024-05-01', 'Transferencia bancaria'),
                                                                                    ('C0252', 'U0205', 'J0135', '2024-06-02', 'Tarjeta de crédito'),
                                                                                    ('C0253', 'U0206', 'J0135', '2024-06-05', 'PayPal'),
                                                                                    ('C0254', 'U0207', 'J0136', '2024-07-01', 'Tarjeta de crédito'),
                                                                                    ('C0255', 'U0208', 'J0136', '2024-07-10', 'Efectivo'),
                                                                                    ('C0256', 'U0209', 'J0137', '2024-07-18', 'Transferencia bancaria'),
                                                                                    ('C0257', 'U0210', 'J0138', '2024-08-09', 'PayPal'),
                                                                                    ('C0258', 'U0211', 'J0138', '2024-08-10', 'Tarjeta de crédito'),
                                                                                    ('C0259', 'U0212', 'J0139', '2024-09-22', 'Transferencia bancaria'),
                                                                                    ('C0260', 'U0213', 'J0139', '2024-09-25', 'Efectivo'),
                                                                                    ('C0261', 'U0214', 'J0140', '2024-10-19', 'PayPal'),
                                                                                    ('C0262', 'U0215', 'J0141', '2024-01-31', 'Tarjeta de crédito'),
                                                                                    ('C0263', 'U0216', 'J0141', '2024-02-02', 'PayPal'),
                                                                                    ('C0264', 'U0217', 'J0142', '2024-02-27', 'Transferencia bancaria'),
                                                                                    ('C0265', 'U0218', 'J0143', '2024-03-17', 'Efectivo'),
                                                                                    ('C0266', 'U0219', 'J0144', '2024-04-14', 'PayPal'),
                                                                                    ('C0267', 'U0220', 'J0145', '2024-05-22', 'Tarjeta de crédito'),
                                                                                    ('C0268', 'U0221', 'J0146', '2024-06-20', 'Transferencia bancaria'),
                                                                                    ('C0269', 'U0222', 'J0147', '2024-07-10', 'Efectivo'),
                                                                                    ('C0270', 'U0221', 'J0148', '2024-08-30', 'PayPal'),
                                                                                    ('C0271', 'U0220', 'J0149', '2024-09-15', 'Tarjeta de crédito'),
-- Compras adicionales para J0133
                                                                                    ('C0272', 'U0110', 'J0133', '2024-03-21', 'PayPal'),
                                                                                    ('C0273', 'U0111', 'J0133', '2024-03-23', 'Transferencia bancaria'),
                                                                                    ('C0274', 'U0112', 'J0133', '2024-03-24', 'Efectivo'),
                                                                                    ('C0275', 'U0113', 'J0133', '2024-03-25', 'Tarjeta de crédito'),

-- Compras adicionales para J0134
                                                                                    ('C0276', 'U0114', 'J0134', '2024-04-29', 'PayPal'),
                                                                                    ('C0277', 'U0115', 'J0134', '2024-04-30', 'Transferencia bancaria'),
                                                                                    ('C0278', 'U0116', 'J0134', '2024-05-02', 'Efectivo'),
                                                                                    ('C0279', 'U0117', 'J0134', '2024-05-03', 'Tarjeta de crédito'),
                                                                                    ('C0280', 'U0118', 'J0134', '2024-05-04', 'PayPal'),

-- Compras adicionales para J0135
                                                                                    ('C0281', 'U0119', 'J0135', '2024-05-31', 'Tarjeta de crédito'),
                                                                                    ('C0282', 'U0120', 'J0135', '2024-06-01', 'Transferencia bancaria'),
                                                                                    ('C0283', 'U0121', 'J0135', '2024-06-03', 'Efectivo'),
                                                                                    ('C0284', 'U0122', 'J0135', '2024-06-04', 'PayPal'),

-- Compras adicionales para J0136
                                                                                    ('C0285', 'U0123', 'J0136', '2024-06-24', 'Tarjeta de crédito'),
                                                                                    ('C0286', 'U0124', 'J0136', '2024-06-25', 'Transferencia bancaria'),
                                                                                    ('C0287', 'U0125', 'J0136', '2024-06-26', 'PayPal'),
                                                                                    ('C0288', 'U0126', 'J0136', '2024-06-27', 'Efectivo'),

-- Compras adicionales para J0137
                                                                                    ('C0289', 'U0127', 'J0137', '2024-07-16', 'Transferencia bancaria'),
                                                                                    ('C0290', 'U0128', 'J0137', '2024-07-17', 'PayPal'),
                                                                                    ('C0291', 'U0129', 'J0137', '2024-07-18', 'Efectivo'),

-- Compras adicionales para J0138
                                                                                    ('C0292', 'U0130', 'J0138', '2024-08-08', 'Tarjeta de crédito'),
                                                                                    ('C0293', 'U0131', 'J0138', '2024-08-09', 'PayPal'),
                                                                                    ('C0294', 'U0132', 'J0138', '2024-08-10', 'Transferencia bancaria'),
                                                                                    ('C0295', 'U0133', 'J0138', '2024-08-11', 'Efectivo'),
                                                                                    ('C0296', 'U0134', 'J0138', '2024-08-12', 'Tarjeta de crédito'),

-- Compras adicionales para J0139
                                                                                    ('C0297', 'U0135', 'J0139', '2024-09-21', 'PayPal'),
                                                                                    ('C0298', 'U0136', 'J0139', '2024-09-22', 'Transferencia bancaria'),
                                                                                    ('C0299', 'U0137', 'J0139', '2024-09-23', 'Tarjeta de crédito'),

-- Compras adicionales para J0140
                                                                                    ('C0300', 'U0138', 'J0140', '2024-10-18', 'PayPal'),
                                                                                    ('C0301', 'U0139', 'J0140', '2024-10-19', 'Transferencia bancaria'),
                                                                                    ('C0302', 'U0140', 'J0140', '2024-10-20', 'Efectivo'),

-- Compras adicionales para J0141
                                                                                    ('C0303', 'U0141', 'J0141', '2024-02-01', 'Tarjeta de crédito'),
                                                                                    ('C0304', 'U0142', 'J0141', '2024-02-03', 'PayPal'),
                                                                                    ('C0305', 'U0143', 'J0141', '2024-02-04', 'Transferencia bancaria'),

-- Compras adicionales para J0142
                                                                                    ('C0306', 'U0144', 'J0142', '2024-02-26', 'Efectivo'),
                                                                                    ('C0307', 'U0145', 'J0142', '2024-02-28', 'Tarjeta de crédito'),
                                                                                    ('C0308', 'U0146', 'J0142', '2024-02-29', 'PayPal'),

-- Compras adicionales para J0143
                                                                                    ('C0309', 'U0147', 'J0143', '2024-03-16', 'Transferencia bancaria'),
                                                                                    ('C0310', 'U0148', 'J0143', '2024-03-17', 'Efectivo'),
                                                                                    ('C0311', 'U0149', 'J0143', '2024-03-18', 'PayPal'),

-- Compras adicionales para J0144
                                                                                    ('C0312', 'U0150', 'J0144', '2024-04-13', 'Tarjeta de crédito'),
                                                                                    ('C0313', 'U0151', 'J0144', '2024-04-14', 'Transferencia bancaria'),

-- Compras adicionales para J0145
                                                                                    ('C0314', 'U0152', 'J0145', '2024-05-22', 'Efectivo'),
                                                                                    ('C0315', 'U0153', 'J0145', '2024-05-23', 'Tarjeta de crédito'),
                                                                                    ('C0316', 'U0154', 'J0145', '2024-05-24', 'PayPal'),

-- Compras adicionales para J0146
                                                                                    ('C0317', 'U0155', 'J0146', '2024-06-20', 'Transferencia bancaria'),
                                                                                    ('C0318', 'U0156', 'J0146', '2024-06-21', 'Tarjeta de crédito'),

-- Compras adicionales para J0147
                                                                                    ('C0319', 'U0157', 'J0147', '2024-07-11', 'Efectivo'),
                                                                                    ('C0320', 'U0158', 'J0147', '2024-07-12', 'PayPal'),

-- Compras adicionales para J0148
                                                                                    ('C0321', 'U0159', 'J0148', '2024-08-29', 'Transferencia bancaria'),
                                                                                    ('C0322', 'U0160', 'J0148', '2024-08-30', 'Tarjeta de crédito'),

-- Compras adicionales para J0149
                                                                                    ('C0323', 'U0161', 'J0149', '2024-09-16', 'PayPal'),
                                                                                    ('C0324', 'U0162', 'J0149', '2024-09-17', 'Efectivo'),
                                                                                    ('C0325', 'U0163', 'J0149', '2024-09-18', 'Tarjeta de crédito'),

-- Compras adicionales para J0150
                                                                                    ('C0326', 'U0164', 'J0150', '2024-10-16', 'PayPal'),
                                                                                    ('C0327', 'U0165', 'J0150', '2024-11-17', 'Efectivo'),
                                                                                    ('C0328', 'U0166', 'J0150', '2024-12-18', 'Tarjeta de crédito');

-- Inserciones para la tabla wishlist
INSERT INTO wishlist (id_usuario, id_juego, fecha_agregado) VALUES
                                                                ('U0063', 'J0077', '2024-03-17'),
                                                                ('U0064', 'J0077', '2024-03-18'),
                                                                ('U0065', 'J0077', '2024-03-19'),
                                                                ('U0066', 'J0059', '2024-03-20'),
                                                                ('U0067', 'J0060', '2024-03-21'),
                                                                ('U0068', 'J0061', '2024-03-22'),
                                                                ('U0069', 'J0082', '2024-03-23'),
                                                                ('U0070', 'J0082', '2024-03-24'),
                                                                ('U0071', 'J0082', '2024-03-25'),
                                                                ('U0072', 'J0082', '2024-03-26'),
                                                                ('U0073', 'J0082', '2024-03-27'),
                                                                ('U0074', 'J0082', '2024-03-28'),
                                                                ('U0075', 'J0068', '2024-03-29'),
                                                                ('U0076', 'J0077', '2024-03-30'),
                                                                ('U0077', 'J0077', '2024-03-31'),
                                                                ('U0078', 'J0071', '2024-04-01'),
                                                                ('U0079', 'J0072', '2024-04-02'),
                                                                ('U0080', 'J0073', '2024-04-03'),
                                                                ('U0081', 'J0074', '2024-04-04'),
                                                                ('U0082', 'J0075', '2024-04-05'),
                                                                ('U0083', 'J0076', '2024-04-06'),
                                                                ('U0084', 'J0077', '2024-04-07'),
                                                                ('U0085', 'J0078', '2024-04-08'),
                                                                ('U0086', 'J0077', '2024-04-09'),
                                                                ('U0087', 'J0080', '2024-04-10'),
                                                                ('U0088', 'J0082', '2024-04-11'),
                                                                ('U0089', 'J0082', '2024-04-12'),
                                                                ('U0090', 'J0082', '2024-04-13'),
                                                                ('U0091', 'J0082', '2024-04-14'),
                                                                ('U0092', 'J0079', '2024-04-15'),
                                                                ('U0093', 'J0079', '2024-04-16'),
                                                                ('U0094', 'J0087', '2024-04-17'),
                                                                ('U0095', 'J0077', '2024-04-18'),
                                                                ('U0096', 'J0077', '2024-04-19'),
                                                                ('U0097', 'J0090', '2024-04-20'),
                                                                ('U0098', 'J0091', '2024-04-21'),
                                                                ('U0099', 'J0092', '2024-04-22'),
                                                                ('U0100', 'J0093', '2024-04-23'),
                                                                ('U0101', 'J0094', '2024-04-24'),
                                                                ('U0102', 'J0095', '2024-04-25'),
                                                                ('U0103', 'J0096', '2024-04-26'),
                                                                ('U0104', 'J0097', '2024-04-27'),
                                                                ('U0105', 'J0079', '2024-04-28'),
                                                                ('U0106', 'J0079', '2024-04-29'),
                                                                ('U0107', 'J0079', '2024-04-30'),
                                                                ('U0108', 'J0077', '2024-05-01'),
                                                                ('U0109', 'J0077', '2024-05-02'),
                                                                ('U0110', 'J0077', '2024-05-03'),
                                                                ('U0111', 'J0104', '2024-05-04'),
                                                                ('U0112', 'J0105', '2024-05-05'),
                                                                ('U0113', 'J0106', '2024-05-06'),
                                                                ('U0114', 'J0107', '2024-05-07'),
                                                                ('U0115', 'J0079', '2024-05-08'),
                                                                ('U0116', 'J0109', '2024-05-09'),
                                                                ('U0117', 'J0110', '2024-05-10'),
                                                                ('U0118', 'J0111', '2024-05-11'),
                                                                ('U0119', 'J0112', '2024-05-12'),
                                                                ('U0120', 'J0077', '2024-05-13'),
                                                                ('U0121', 'J0077', '2024-05-14'),
                                                                ('U0122', 'J0077', '2024-05-15'),
                                                                ('U0123', 'J0116', '2024-05-16'),
                                                                ('U0124', 'J0117', '2024-05-17'),
                                                                ('U0125', 'J0077', '2024-05-18'),
                                                                ('U0126', 'J0077', '2024-05-19'),
                                                                ('U0127', 'J0077', '2024-05-20'),
                                                                ('U0128', 'J0077', '2024-05-21'),
                                                                ('U0129', 'J0122', '2024-05-22'),
                                                                ('U0130', 'J0123', '2024-05-23'),
                                                                ('U0131', 'J0124', '2024-05-24'),
                                                                ('U0132', 'J0125', '2024-05-25'),
                                                                ('U0133', 'J0126', '2024-05-26'),
                                                                ('U0134', 'J0127', '2024-05-27'),
                                                                ('U0135', 'J0128', '2024-05-28'),
                                                                ('U0136', 'J0129', '2024-05-29'),
                                                                ('U0137', 'J0077', '2024-05-30'),
                                                                ('U0138', 'J0077', '2024-05-31'),
                                                                ('U0139', 'J0077', '2024-06-01'),
                                                                ('U0140', 'J0077', '2024-06-02'),
                                                                ('U0141', 'J0134', '2024-06-03'),
                                                                ('U0142', 'J0135', '2024-06-04'),
                                                                ('U0143', 'J0077', '2024-06-05'),
                                                                ('U0144', 'J0077', '2024-06-06'),
                                                                ('U0145', 'J0138', '2024-06-07'),
                                                                ('U0146', 'J0139', '2024-06-08'),
                                                                ('U0147', 'J0140', '2024-06-09'),
                                                                ('U0148', 'J0141', '2024-06-10'),
                                                                ('U0149', 'J0142', '2024-06-11'),
                                                                ('U0150', 'J0143', '2024-06-12'),
                                                                ('U0151', 'J0144', '2024-06-13'),
                                                                ('U0152', 'J0145', '2024-06-14'),
                                                                ('U0153', 'J0146', '2024-06-15'),
                                                                ('U0154', 'J0147', '2024-06-16'),
                                                                ('U0155', 'J0148', '2024-06-17'),
                                                                ('U0156', 'J0149', '2024-06-18'),
                                                                ('U0157', 'J0150', '2024-06-19'),
                                                                ('U0158', 'J0056', '2024-06-20'),
                                                                ('U0159', 'J0057', '2024-06-21'),
                                                                ('U0160', 'J0058', '2024-06-22'),
                                                                ('U0161', 'J0059', '2024-06-23'),
                                                                ('U0162', 'J0060', '2024-06-24'),
                                                                ('U0163', 'J0061', '2024-06-25'),
                                                                ('U0164', 'J0062', '2024-06-26'),
                                                                ('U0165', 'J0063', '2024-06-27'),
                                                                ('U0166', 'J0064', '2024-06-28'),
                                                                ('U0167', 'J0065', '2024-06-29'),
                                                                ('U0168', 'J0066', '2024-06-30'),
                                                                ('U0169', 'J0067', '2024-07-01'),
                                                                ('U0170', 'J0068', '2024-07-02'),
                                                                ('U0171', 'J0069', '2024-07-03'),
                                                                ('U0172', 'J0070', '2024-07-04'),
                                                                ('U0173', 'J0071', '2024-07-05'),
                                                                ('U0174', 'J0072', '2024-07-06'),
                                                                ('U0175', 'J0073', '2024-07-07'),
                                                                ('U0176', 'J0074', '2024-07-08'),
                                                                ('U0177', 'J0075', '2024-07-09'),
                                                                ('U0178', 'J0076', '2024-07-10'),
                                                                ('U0179', 'J0077', '2024-07-11'),
                                                                ('U0180', 'J0078', '2024-07-12'),
                                                                ('U0181', 'J0079', '2024-07-13'),
                                                                ('U0182', 'J0080', '2024-07-14'),
                                                                ('U0183', 'J0081', '2024-07-15'),
                                                                ('U0184', 'J0082', '2024-07-16'),
                                                                ('U0185', 'J0083', '2024-07-17'),
                                                                ('U0186', 'J0084', '2024-07-18'),
                                                                ('U0187', 'J0085', '2024-07-19'),
                                                                ('U0188', 'J0086', '2024-07-20'),
                                                                ('U0189', 'J0087', '2024-07-21'),
                                                                ('U0190', 'J0088', '2024-07-22'),
                                                                ('U0191', 'J0089', '2024-07-23'),
                                                                ('U0192', 'J0090', '2024-07-24'),
                                                                ('U0193', 'J0091', '2024-07-25'),
                                                                ('U0194', 'J0092', '2024-07-26'),
                                                                ('U0195', 'J0093', '2024-07-27'),
                                                                ('U0196', 'J0094', '2024-07-28'),
                                                                ('U0197', 'J0095', '2024-07-29'),
                                                                ('U0198', 'J0096', '2024-07-30'),
                                                                ('U0199', 'J0097', '2024-07-31'),
                                                                ('U0200', 'J0098', '2024-08-01'),
                                                                ('U0201', 'J0099', '2024-08-02'),
                                                                ('U0202', 'J0100', '2024-08-03'),
                                                                ('U0203', 'J0101', '2024-08-04'),
                                                                ('U0204', 'J0102', '2024-08-05'),
                                                                ('U0205', 'J0103', '2024-08-06'),
                                                                ('U0206', 'J0104', '2024-08-07'),
                                                                ('U0207', 'J0105', '2024-08-08'),
                                                                ('U0208', 'J0106', '2024-08-09'),
                                                                ('U0209', 'J0107', '2024-08-10'),
                                                                ('U0210', 'J0108', '2024-08-11'),
                                                                ('U0211', 'J0109', '2024-08-12'),
                                                                ('U0212', 'J0110', '2024-08-13'),
                                                                ('U0213', 'J0111', '2024-08-14'),
                                                                ('U0214', 'J0112', '2024-08-15'),
                                                                ('U0215', 'J0113', '2024-08-16'),
                                                                ('U0216', 'J0114', '2024-08-17');

-- Insertar datos en la tabla desarrollador
INSERT INTO desarrollador (id_desarrollador, nombre, pais_origen, continente, ceo, numero_trabajadores, fundacion, sitio_web) VALUES
                                                                                                                                  ('D001', 'Nintendo', 'Japón', 'Asia', 'Shuntaro Furukawa', 6674, 1889, 'https://www.nintendo.co.jp'),
                                                                                                                                  ('D002', 'Santa Monica Studio', 'Estados Unidos', 'América', 'Yumi Yang', 250, 1999, 'https://sms.playstation.com'),
                                                                                                                                  ('D003', 'Team Cherry', 'Australia', 'Oceanía', 'William Pellen', 15, 2017, 'https://www.teamcherry.com.au'),
                                                                                                                                  ('D004', 'Maddy Makes Games', 'Canadá', 'América', 'Maddy Thorson', 5, 2013, 'https://www.maddymakesgames.com'),
                                                                                                                                  ('D005', 'Studio MDHR', 'Canadá', 'América', 'Chad Moldenhauer', 20, 2013, 'https://www.studiomdhr.com'),
                                                                                                                                  ('D006', 'ConcernedApe', 'Estados Unidos', 'América', 'Eric Barone', 1, 2012, 'https://www.concernedape.com'),
                                                                                                                                  ('D007', 'Naughty Dog', 'Estados Unidos', 'América', 'Neil Druckmann', 350, 1984, 'https://www.naughtydog.com'),
                                                                                                                                  ('D008', 'Insomniac Games', 'Estados Unidos', 'América', 'Ted Price', 400, 1994, 'https://www.insomniacgames.com'),
                                                                                                                                  ('D009', 'CD Projekt Red', 'Polonia', 'Europa', 'Adam Kiciński', 1200, 2002, 'https://www.cdprojekt.com'),
                                                                                                                                  ('D010', 'Intelligent Systems', 'Japón', 'Asia', 'Toru Narihiro', 150, 1983, 'https://www.intsys.co.jp'),
                                                                                                                                  ('D011', 'Moon Studios', 'Austria', 'Europa', 'Thomas Mahler', 80, 2010, 'https://www.orithegame.com'),
                                                                                                                                  ('D012', 'Capcom', 'Japón', 'Asia', 'Haruhiro Tsujimoto', 2800, 1979, 'https://www.capcom.co.jp'),
                                                                                                                                  ('D013', 'Innersloth', 'Estados Unidos', 'América', 'Marcus Bromander', 15, 2015, 'https://www.innersloth.com'),
                                                                                                                                  ('D014', 'id Software', 'Estados Unidos', 'América', 'Marty Stratton', 300, 1991, 'https://www.idsoftware.com'),
                                                                                                                                  ('D015', 'Supergiant Games', 'Estados Unidos', 'América', 'Amir Rao', 20, 2009, 'https://www.supergiantgames.com'),
                                                                                                                                  ('D016', 'ZA/UM', 'Estonia', 'Europa', 'Ilmar Kompus', 35, 2016, 'https://www.zaumstudio.com'),
                                                                                                                                  ('D017', 'FromSoftware', 'Japón', 'Asia', 'Hidetaka Miyazaki', 300, 1986, 'https://www.fromsoftware.jp'),
                                                                                                                                  ('D018', 'Mojang Studios', 'Suecia', 'Europa', 'Helen Chiang', 600, 2009, 'https://www.minecraft.net'),
                                                                                                                                  ('D019', 'Mediatonic', 'Reino Unido', 'Europa', 'Dave Bailey', 300, 2005, 'https://www.mediatonicgames.com'),
                                                                                                                                  ('D020', 'Playground Games', 'Reino Unido', 'Europa', 'Trevor Williams', 300, 2010, 'https://www.playground-games.com'),
                                                                                                                                  ('D021', 'Rockstar Games', 'Estados Unidos', 'América', 'Sam Houser', 2000, 1998, 'https://www.rockstargames.com'),
                                                                                                                                  ('D022', 'Blizzard Entertainment', 'Estados Unidos', 'América', 'Mike Ybarra', 4700, 1991, 'https://www.blizzard.com'),
                                                                                                                                  ('D023', 'Riot Games', 'Estados Unidos', 'América', 'Nicolo Laurent', 3000, 2006, 'https://www.riotgames.com'),
                                                                                                                                  ('D024', 'Square Enix', 'Japón', 'Asia', 'Yosuke Matsuda', 5300, 1986, 'https://www.square-enix.com'),
                                                                                                                                  ('D025', 'Ubisoft', 'Francia', 'Europa', 'Yves Guillemot', 20000, 1986, 'https://www.ubisoft.com'),
                                                                                                                                  ('D026', 'Larian Studios', 'Bélgica', 'Europa', 'Swen Vincke', 400, 1996, 'https://www.larian.com'),
                                                                                                                                  ('D027', 'Team Asobi', 'Japón', 'Asia', 'Nicolas Doucet', 80, 2012, 'https://www.teamasobi.com'),
                                                                                                                                  ('D028', 'Hello Games', 'Reino Unido', 'Europa', 'Sean Murray', 30, 2008, 'https://www.hellogames.org'),
                                                                                                                                  ('D029', 'Supermassive Games', 'Reino Unido', 'Europa', 'Pete Samuels', 300, 2008, 'https://www.supermassivegames.com'),
                                                                                                                                  ('D030', 'BioWare', 'Canadá', 'América', 'Gary McKay', 200, 1995, 'https://www.bioware.com'),
                                                                                                                                  ('D031', 'Valve', 'Estados Unidos', 'América', 'Gabe Newell', 360, 1996, 'https://www.valvesoftware.com'),
                                                                                                                                  ('D032', 'Infinity Ward', 'Estados Unidos', 'América', 'Patrick Kelly', 450, 2002, 'https://www.infinityward.com'),
                                                                                                                                  ('D033', 'Tarsier Studios', 'Suecia', 'Europa', 'Andreas Johnsson', 80, 2004, 'https://www.tarsier.se'),
                                                                                                                                  ('D034', 'Arkane Studios', 'Francia', 'Europa', 'Raphael Colantonio', 120, 1999, 'https://www.arkane-studios.com'),
                                                                                                                                  ('D035', 'BlueTwelve Studio', 'Francia', 'Europa', NULL, 15, 2016, 'https://www.bluetwelvestudio.com'),
                                                                                                                                  ('D036', 'Obsidian Entertainment', 'Estados Unidos', 'América', 'Feargus Urquhart', 230, 2003, 'https://www.obsidian.net'),
                                                                                                                                  ('D037', 'MegaCrit', 'Estados Unidos', 'América', NULL, 20, 2017, 'https://www.megacrit.com'),
                                                                                                                                  ('D038', 'Splashteam', 'Francia', 'Europa', NULL, 25, 2018, 'https://splashteam.fr'),
                                                                                                                                  ('D039', 'Yacht Club Games', 'Estados Unidos', 'América', 'Sean Velasco', 30, 2011, 'https://www.yachtclubgames.com'),
                                                                                                                                  ('D040', 'Nicalis', 'Estados Unidos', 'América', 'Tyrone Rodriguez', 50, 2007, 'https://www.nicalis.com'),
                                                                                                                                  ('D041', 'Night School Studio', 'Estados Unidos', 'América', 'Sean Krankel', 30, 2014, 'https://www.nightschoolstudio.com'),
                                                                                                                                  ('D042', 'Toby Fox', 'Estados Unidos', 'América', 'Toby Fox', 1, 2015, 'https://tobyfox.net'),
                                                                                                                                  ('D043', 'Jonathan Blow', 'Estados Unidos', 'América', 'Jonathan Blow', 10, 2008, 'https://thekla.com'),
                                                                                                                                  ('D045', 'Campo Santo', 'Estados Unidos', 'América', 'Sean Vanaman', 12, 2013, 'https://www.camposanto.com'),
                                                                                                                                  ('D046', 'Frictional Games', 'Suecia', 'Europa', 'Thomas Grip', 25, 2007, 'https://frictionalgames.com'),
                                                                                                                                  ('D047', 'Massive Monster', 'Australia', 'Oceanía', 'Julian Wilton', 15, 2017, 'https://www.massivemonster.co'),
                                                                                                                                  ('D048', 'Lucas Pope', 'Estados Unidos', 'América', 'Lucas Pope', 1, 2013, 'https://dukope.com'),
                                                                                                                                  ('D049', 'WayForward', 'Estados Unidos', 'América', 'Voldi Way', 200, 1990, 'https://wayforward.com'),
                                                                                                                                  ('D050', 'Team Meat', 'Estados Unidos', 'América', 'Tommy Refenes', 2, 2010, 'https://supermeatboy.com'),
                                                                                                                                  ('D051', 'Askiisoft', 'Canadá', 'América', NULL, 5, 2008, 'https://askiisoft.com'),
                                                                                                                                  ('D052', 'Re-Logic', 'Estados Unidos', 'América', 'Andrew Spinks', 12, 2011, 'https://terraria.org'),
                                                                                                                                  ('D053', 'Wube Software', 'República Checa', 'Europa', NULL, 30, 2012, 'https://factorio.com'),
                                                                                                                                  ('D054', 'Coffee Stain Studios', 'Suecia', 'Europa', 'Albert Säfström', 90, 2010, 'https://coffeestainstudios.com'),
                                                                                                                                  ('D055', 'Angel Matrix', 'Estados Unidos', 'América', NULL, 15, 2018, 'https://angelmatrix.com'),
                                                                                                                                  ('D056', 'Geometric Interactive', 'Dinamarca', 'Europa', 'Jeppe Carlsen', 8, 2019, 'https://www.geometricinteractive.com'),
                                                                                                                                  ('D057', 'GSC Game World', 'Ucrania', 'Europa', 'Sergey Grigorovich', 300, 1995, 'https://gsc-game.com'),
                                                                                                                                  ('D058', 'The Indie Stone', 'Reino Unido', 'Europa', NULL, 15, 2009, 'https://projectzomboid.com'),
                                                                                                                                  ('D059', 'Unknown Worlds Entertainment', 'Estados Unidos', 'América', NULL, 50, 2001, 'https://unknownworlds.com'),
                                                                                                                                  ('D060', 'Vanillaware', 'Japón', 'Asia', 'George Kamitani', 30, 2002, 'https://www.vanillaware.co.jp'),
                                                                                                                                  ('D061', 'Double Fine Productions', 'Estados Unidos', 'América', 'Tim Schafer', 65, 2000, 'https://www.doublefine.com'),
                                                                                                                                  ('D062', 'Asobo Studio', 'Francia', 'Europa', 'Sebastian Wloch', 250, 2002, 'https://www.asobostudio.com'),
                                                                                                                                  ('D063', 'Red Hook Studios', 'Canadá', 'América', 'Chris Bourassa', 15, 2013, 'https://www.redhookgames.com'),
                                                                                                                                  ('D064', 'Mobius Digital', 'Estados Unidos', 'América', 'Masi Oka', 15, 2013, 'https://www.mobiusdigitalgames.com'),
                                                                                                                                  ('D065', 'Thatgamecompany', 'Estados Unidos', 'América', 'Jenova Chen', 80, 2006, 'https://thatgamecompany.com'),
                                                                                                                                  ('D066', 'Kojima Productions', 'Japón', 'Asia', 'Hideo Kojima', 150, 2015, 'https://www.kojimaproductions.jp/en'),
                                                                                                                                  ('D067', 'Housemarque', 'Finlandia', 'Europa', 'Ilari Kuittinen', 100, 1995, 'https://housemarque.com'),
                                                                                                                                  ('D068', 'Playdead', 'Dinamarca', 'Europa', NULL, 50, 2006, 'https://playdead.com'),
                                                                                                                                  ('D069', 'Finji', 'Estados Unidos', 'América', NULL, 20, 2014, 'https://finji.co'),
                                                                                                                                  ('D070', 'Greg Lobanov Studio', 'Canadá', 'América', 'Greg Lobanov', 10, 2020, 'https://greglobanov.com'),
                                                                                                                                  ('D071', 'Ryu Ga Gotoku Studio', 'Japón', 'Asia', 'Masayoshi Yokoyama', 300, 2011, 'https://ryu-ga-gotoku.com'),
                                                                                                                                  ('D072', 'Gears for Breakfast', 'Dinamarca', 'Europa', 'Jonas Kaerlev', 15, 2013, 'https://www.gearsforbreakfast.com'),
                                                                                                                                  ('D073', 'Nomada Studio', 'España', 'Europa', 'Conrad Roset', 10, 2016, 'https://nomadastudio.eu'),
                                                                                                                                  ('D074', 'Monolith Soft', 'Japón', 'Asia', 'Hitoshi Yamagami', 275, 1999, 'https://www.monolithsoft.co.jp'),
                                                                                                                                  ('D075', 'Psyonix', 'Estados Unidos', 'América', 'Dave Hagewood', 132, 2000, 'https://www.psyonix.com'),
                                                                                                                                  ('D076', 'Atlus', 'Japón', 'Asia', 'Naoto Hiraoka', 450, 1986, 'https://www.atlus.com'),
                                                                                                                                  ('D077', 'Motion Twin', 'Francia', 'Europa', 'Julien Barnoin', 10, 2001, 'https://www.motion-twin.com'),
                                                                                                                                  ('D078', 'Hazelight Studios', 'Suecia', 'Europa', 'Josef Fares', 60, 2014, 'https://www.hazelight.se'),
                                                                                                                                  ('D079', 'Respawn Entertainment', 'Estados Unidos', 'América', 'Vince Zampella', 300, 2010, 'https://www.respawn.com'),
                                                                                                                                  ('D080', 'Epic Games', 'Estados Unidos', 'América', 'Tim Sweeney', 3500, 1991, 'https://www.epicgames.com'),
                                                                                                                                  ('D081', '343 Industries', 'Estados Unidos', 'América', 'Bonnie Ross', 500, 2007, 'https://www.halowaypoint.com'),
                                                                                                                                  ('D082', 'Ember Lab', 'Estados Unidos', 'América', 'Mike Grier', 30, 2009, 'https://www.emberlab.com'),
                                                                                                                                  ('D083', 'Portkey Games', 'Reino Unido', 'Europa', 'Rachel Wakley', 100, 2017, 'https://www.portkeygames.com'),
                                                                                                                                  ('D084', 'Bethesda Game Studios', 'Estados Unidos', 'América', 'Todd Howard', 420, 2001, 'https://bethesda.net'),
                                                                                                                                  ('D085', 'Remedy Entertainment', 'Finlandia', 'Europa', 'Tero Virtala', 300, 1995, 'https://www.remedygames.com'),
                                                                                                                                  ('D086', 'EA Sports', 'Estados Unidos', 'América', 'Cam Weber', 800, 1991, 'https://www.ea.com/ea-sports'),
                                                                                                                                  ('D087', 'Aspyr', 'Estados Unidos', 'América', 'Ted Staloch', 120, 1996, 'https://www.aspyr.com'),
                                                                                                                                  ('D088', 'The Initiative', 'Estados Unidos', 'América', 'Darryl Gallagher', 75, 2018, 'https://www.theinitiative.com'),
                                                                                                                                  ('D089', 'Ninja Theory', 'Reino Unido', 'Europa', 'Tameem Antoniades', 150, 2000, 'https://www.ninjatheory.com'),
                                                                                                                                  ('D090', 'Sloclap', 'Francia', 'Europa', 'Pierre Tarno', 50, 2015, 'https://www.sloclap.com'),
                                                                                                                                  ('D091', 'HAL Laboratory', 'Japón', 'Asia', 'Shigefumi Kawase', 170, 1980, 'https://www.hallab.co.jp'),
                                                                                                                                  ('D092', 'PlatinumGames', 'Japón', 'Asia', 'Atsushi Inaba', 300, 2006, 'https://www.platinumgames.com'),
                                                                                                                                  ('D093', 'Striking Distance Studios', 'Estados Unidos', 'América', 'Glen Schofield', 150, 2019, 'https://www.sds.com'),
                                                                                                                                  ('D094', 'WB Games Montréal', 'Canadá', 'América', 'Marie-Pierre Ducharme', 340, 2010, 'https://wbgamesmontreal.com'),
                                                                                                                                  ('D095', 'Techland', 'Polonia', 'Europa', 'Paweł Marchewka', 400, 1991, 'https://techland.net'),
                                                                                                                                  ('D096', 'Tango Gameworks', 'Japón', 'Asia', 'Shinji Mikami', 120, 2010, 'https://www.tangogameworks.com'),
                                                                                                                                  ('D097', 'Artdink', 'Japón', 'Asia', 'Takashi Hasegawa', 50, 1986, 'https://www.artdink.co.jp'),
                                                                                                                                  ('D098', 'Guerrilla Games', 'Países Bajos', 'Europa', 'Angie Smets', 400, 2000, 'https://www.guerrilla-games.com'),
                                                                                                                                  ('D099', 'Acid Nerve', 'Reino Unido', 'Europa', NULL, 10, 2014, 'https://www.acidnerve.com'),
                                                                                                                                  ('D100', 'Pixpil', 'China', 'Asia', 'Hong Yu', 20, 2016, 'https://www.pixpil.com'),
                                                                                                                                  ('D101', 'Next Level Games', 'Canadá', 'América', 'Douglas Tronsgard', 80, 2002, 'https://www.nextlevelgames.com'),
                                                                                                                                  ('D102', 'Luca Galante', 'Italia', 'Europa', 'Luca Galante', 1, 2020, 'https://www.poncle.co.uk'),
                                                                                                                                  ('D103', 'Endnight Games', 'Canadá', 'América', 'Ben Falcone', 20, 2013, 'https://endnightgames.com');

INSERT INTO amistad (id_amigo1, id_amigo2) VALUES
                                               ('U0001', 'U0023'),
                                               ('U0001', 'U0045'),
                                               ('U0002', 'U0034'),
                                               ('U0002', 'U0056'),
                                               ('U0003', 'U0067'),
                                               ('U0003', 'U0078'),
                                               ('U0004', 'U0089'),
                                               ('U0004', 'U0010'),
                                               ('U0005', 'U0111'),
                                               ('U0005', 'U0022'),
                                               ('U0006', 'U0033'),
                                               ('U0006', 'U0044'),
                                               ('U0007', 'U0055'),
                                               ('U0007', 'U0066'),
                                               ('U0008', 'U0077'),
                                               ('U0008', 'U0088'),
                                               ('U0009', 'U0099'),
                                               ('U0009', 'U0100'),
                                               ('U0010', 'U0011'),
                                               ('U0010', 'U0022'),
                                               ('U0011', 'U0033'),
                                               ('U0011', 'U0044'),
                                               ('U0012', 'U0055'),
                                               ('U0012', 'U0066'),
                                               ('U0013', 'U0077'),
                                               ('U0013', 'U0088'),
                                               ('U0014', 'U0099'),
                                               ('U0014', 'U0100'),
                                               ('U0015', 'U0016'),
                                               ('U0015', 'U0027'),
                                               ('U0016', 'U0038'),
                                               ('U0016', 'U0049'),
                                               ('U0017', 'U0050'),
                                               ('U0017', 'U0061'),
                                               ('U0018', 'U0072'),
                                               ('U0018', 'U0083'),
                                               ('U0019', 'U0094'),
                                               ('U0019', 'U0105'),
                                               ('U0020', 'U0116'),
                                               ('U0020', 'U0127'),
                                               ('U0021', 'U0138'),
                                               ('U0021', 'U0149'),
                                               ('U0022', 'U0150'),
                                               ('U0022', 'U0161'),
                                               ('U0023', 'U0172'),
                                               ('U0023', 'U0183'),
                                               ('U0024', 'U0194'),
                                               ('U0024', 'U0205'),
                                               ('U0025', 'U0216'),
                                               ('U0051', 'U0108'),
                                               ('U0051', 'U0109'),
                                               ('U0052', 'U0110'),
                                               ('U0052', 'U0111'),
                                               ('U0053', 'U0112'),
                                               ('U0053', 'U0113'),
                                               ('U0054', 'U0114'),
                                               ('U0054', 'U0115'),
                                               ('U0055', 'U0116'),
                                               ('U0055', 'U0117'),
                                               ('U0056', 'U0118'),
                                               ('U0056', 'U0119'),
                                               ('U0057', 'U0120'),
                                               ('U0057', 'U0121'),
                                               ('U0058', 'U0122'),
                                               ('U0058', 'U0123'),
                                               ('U0059', 'U0124'),
                                               ('U0059', 'U0125'),
                                               ('U0060', 'U0126'),
                                               ('U0060', 'U0127'),
                                               ('U0061', 'U0128'),
                                               ('U0061', 'U0129'),
                                               ('U0062', 'U0130'),
                                               ('U0062', 'U0131'),
                                               ('U0063', 'U0132'),
                                               ('U0063', 'U0133'),
                                               ('U0064', 'U0134'),
                                               ('U0064', 'U0135'),
                                               ('U0065', 'U0136'),
                                               ('U0065', 'U0137'),
                                               ('U0066', 'U0138'),
                                               ('U0066', 'U0139'),
                                               ('U0067', 'U0140'),
                                               ('U0067', 'U0141'),
                                               ('U0068', 'U0142'),
                                               ('U0068', 'U0143'),
                                               ('U0069', 'U0144'),
                                               ('U0069', 'U0145'),
                                               ('U0070', 'U0146'),
                                               ('U0070', 'U0147'),
                                               ('U0071', 'U0148'),
                                               ('U0071', 'U0149'),
                                               ('U0072', 'U0150'),
                                               ('U0072', 'U0151'),
                                               ('U0073', 'U0152'),
                                               ('U0073', 'U0153'),
                                               ('U0074', 'U0154'),
                                               ('U0074', 'U0155'),
                                               ('U0075', 'U0156'),
                                               ('U0075', 'U0157'),
                                               ('U0076', 'U0158'),
                                               ('U0076', 'U0159'),
                                               ('U0077', 'U0160'),
                                               ('U0077', 'U0161'),
                                               ('U0078', 'U0162'),
                                               ('U0078', 'U0163'),
                                               ('U0079', 'U0164'),
                                               ('U0079', 'U0165'),
                                               ('U0080', 'U0166'),
                                               ('U0080', 'U0167'),
                                               ('U0081', 'U0168'),
                                               ('U0081', 'U0169'),
                                               ('U0082', 'U0170'),
                                               ('U0082', 'U0171'),
                                               ('U0083', 'U0172'),
                                               ('U0083', 'U0173'),
                                               ('U0084', 'U0174'),
                                               ('U0084', 'U0175'),
                                               ('U0085', 'U0176'),
                                               ('U0085', 'U0177'),
                                               ('U0086', 'U0178'),
                                               ('U0086', 'U0179'),
                                               ('U0087', 'U0180'),
                                               ('U0087', 'U0181'),
                                               ('U0088', 'U0182'),
                                               ('U0088', 'U0183'),
                                               ('U0089', 'U0184'),
                                               ('U0089', 'U0185'),
                                               ('U0090', 'U0186'),
                                               ('U0090', 'U0187'),
                                               ('U0091', 'U0188'),
                                               ('U0091', 'U0189'),
                                               ('U0092', 'U0190'),
                                               ('U0092', 'U0191'),
                                               ('U0093', 'U0192'),
                                               ('U0093', 'U0193'),
                                               ('U0094', 'U0194'),
                                               ('U0094', 'U0195'),
                                               ('U0095', 'U0196'),
                                               ('U0095', 'U0197'),
                                               ('U0096', 'U0198'),
                                               ('U0096', 'U0199'),
                                               ('U0097', 'U0200'),
                                               ('U0097', 'U0201'),
                                               ('U0098', 'U0202'),
                                               ('U0098', 'U0203'),
                                               ('U0099', 'U0204'),
                                               ('U0099', 'U0205'),
                                               ('U0100', 'U0206'),
                                               ('U0100', 'U0207');

INSERT INTO juego_desarrollador (id_juego, id_desarrollador) VALUES
                                                                 ('J0001', 'D001'),  -- The Legend of Zelda: Breath of the Wild - Nintendo
                                                                 ('J0002', 'D002'),  -- God of War Ragnarök - Santa Monica Studio
                                                                 ('J0003', 'D001'),  -- Super Mario Odyssey - Nintendo
                                                                 ('J0004', 'D003'),  -- Hollow Knight - Team Cherry
                                                                 ('J0005', 'D004'),  -- Celeste - Maddy Makes Games
                                                                 ('J0006', 'D005'),  -- Cuphead - Studio MDHR
                                                                 ('J0007', 'D006'),  -- Stardew Valley - ConcernedApe
                                                                 ('J0008', 'D007'),  -- Uncharted 4: A Thief's End - Naughty Dog
                                                                 ('J0009', 'D008'),  -- Marvel's Spider-Man - Insomniac Games
                                                                 ('J0010', 'D001'),  -- Animal Crossing: New Horizons - Nintendo
                                                                 ('J0011', 'D009'),  -- The Witcher 3: Wild Hunt - CD Projekt Red
                                                                 ('J0012', 'D010'),  -- Fire Emblem: Three Houses - Intelligent Systems
                                                                 ('J0013', 'D011'),  -- Ori and the Will of the Wisps - Moon Studios
                                                                 ('J0014', 'D012'),  -- Monster Hunter: World - Capcom
                                                                 ('J0015', 'D013'),  -- Among Us - Innersloth
                                                                 ('J0016', 'D014'),  -- DOOM Eternal - id Software
                                                                 ('J0017', 'D007'),  -- The Last of Us Part II - Naughty Dog
                                                                 ('J0018', 'D001'),  -- Splatoon 3 - Nintendo
                                                                 ('J0019', 'D015'),  -- Hades - Supergiant Games
                                                                 ('J0020', 'D016'),  -- Disco Elysium - ZA/UM
                                                                 ('J0021', 'D017'),  -- Elden Ring - FromSoftware
                                                                 ('J0022', 'D074'),  -- Xenoblade Chronicles 3 - Monolith Soft
                                                                 ('J0023', 'D018'),  -- Minecraft Dungeons - Mojang Studios
                                                                 ('J0024', 'D019'),  -- Fall Guys - Mediatonic
                                                                 ('J0025', 'D020'),  -- Forza Horizon 4 - Playground Games
                                                                 ('J0026', 'D075'),  -- Rocket League - Psyonix
                                                                 ('J0027', 'D065'),  -- Journey - Thatgamecompany
                                                                 ('J0028', 'D068'),  -- Inside - Playdead
                                                                 ('J0029', 'D033'),  -- Little Nightmares - Tarsier Studios
                                                                 ('J0030', 'D031'),  -- Portal 2 - Valve
                                                                 ('J0031', 'D024'),  -- Final Fantasy VII Remake - Square Enix
                                                                 ('J0032', 'D076'),  -- Persona 5 Royal - Atlus
                                                                 ('J0033', 'D069'),  -- Tunic - Finji
                                                                 ('J0034', 'D017'),  -- Sekiro: Shadows Die Twice - FromSoftware
                                                                 ('J0035', 'D071'),  -- Yakuza Like a Dragon - Ryu Ga Gotoku Studio
                                                                 ('J0036', 'D009'),  -- Cyberpunk 2077 - CD Projekt Red
                                                                 ('J0037', 'D077'),  -- Dead Cells - Motion Twin
                                                                 ('J0038', 'D064'),  -- Outer Wilds - Mobius Digital
                                                                 ('J0039', 'D028'),  -- No Man's Sky - Hello Games
                                                                 ('J0040', 'D017'),  -- Bloodborne - FromSoftware
                                                                 ('J0041', 'D078'),  -- It Takes Two - Hazelight Studios
                                                                 ('J0042', 'D001'),  -- Mario Kart 8 Deluxe - Nintendo
                                                                 ('J0043', 'D001'),  -- Super Smash Bros. Ultimate - Nintendo
                                                                 ('J0044', 'D079'),  -- Apex Legends - Respawn Entertainment
                                                                 ('J0045', 'D022'),  -- Overwatch - Blizzard Entertainment
                                                                 ('J0046', 'D023'),  -- League of Legends - Riot Games
                                                                 ('J0047', 'D080'),  -- Fortnite - Epic Games
                                                                 ('J0048', 'D023'),  -- Valorant - Riot Games
                                                                 ('J0049', 'D032'),  -- Call of Duty: Modern Warfare - Infinity Ward
                                                                 ('J0050', 'D012'),  -- Resident Evil Village - Capcom
                                                                 ('J0051', 'D001'),  -- Metroid Dread - Nintendo
                                                                 ('J0052', 'D008'),  -- Ratchet & Clank: Rift Apart - Insomniac Games
                                                                 ('J0053', 'D081'),  -- Halo Infinite - 343 Industries
                                                                 ('J0054', 'D067'),  -- Returnal - Housemarque
                                                                 ('J0055', 'D082'),  -- Kena: Bridge of Spirits - Ember Lab
                                                                 ('J0056', 'D061'),  -- Psychonauts 2 - Double Fine Productions
                                                                 ('J0057', 'D034'),  -- Deathloop - Arkane Studios
                                                                 ('J0058', 'D020'),  -- Forza Horizon 5 - Playground Games
                                                                 ('J0059', 'D012'),  -- Resident Evil 4 Remake - Capcom
                                                                 ('J0060', 'D083'),  -- Hogwarts Legacy - Portkey Games
                                                                 ('J0061', 'D084'),  -- Starfield - Bethesda Game Studios
                                                                 ('J0062', 'D001'),  -- The Legend of Zelda: Tears of the Kingdom - Nintendo
                                                                 ('J0063', 'D024'),  -- Final Fantasy XVI - Square Enix
                                                                 ('J0064', 'D012'),  -- Street Fighter 6 - Capcom
                                                                 ('J0065', 'D022'),  -- Diablo IV - Blizzard Entertainment
                                                                 ('J0066', 'D026'),  -- Baldur's Gate III - Larian Studios
                                                                 ('J0067', 'D025'),  -- Assassin's Creed Mirage - Ubisoft
                                                                 ('J0068', 'D085'),  -- Alan Wake II - Remedy Entertainment
                                                                 ('J0069', 'D008'),  -- Marvel's Spider-Man 2 - Insomniac Games
                                                                 ('J0070', 'D086'),  -- EA Sports FC 24 - EA Sports
                                                                 ('J0071', 'D032'),  -- Call of Duty: Black Ops 6 - Infinity Ward
                                                                 ('J0072', 'D017'),  -- Elden Ring: Shadow of the Erdtree - FromSoftware
                                                                 ('J0073', 'D015'),  -- Hades II - Supergiant Games
                                                                 ('J0074', 'D001'),  -- Metroid Prime 4 - Nintendo
                                                                 ('J0075', 'D020'),  -- Fable - Playground Games
                                                                 ('J0076', 'D084'),  -- The Elder Scrolls VI - Bethesda Game Studios
                                                                 ('J0077', 'D021'),  -- Grand Theft Auto VI - Rockstar Games
                                                                 ('J0078', 'D087'),  -- Star Wars: Knights of the Old Republic Remake - Aspyr
                                                                 ('J0079', 'D009'),  -- The Witcher 4 - CD Projekt Red
                                                                 ('J0080', 'D030'),  -- Dragon Age: The Veilguard - BioWare
                                                                 ('J0081', 'D088'),  -- Perfect Dark - The Initiative
                                                                 ('J0082', 'D003'),  -- Hollow Knight: Silksong - Team Cherry
                                                                 ('J0083', 'D036'),  -- Avowed - Obsidian Entertainment
                                                                 ('J0084', 'D089'),  -- Hellblade II: Senua's Saga - Ninja Theory
                                                                 ('J0085', 'D057'),  -- Stalker 2: Heart of Chernobyl - GSC Game World
                                                                 ('J0086', 'D034'),  -- Redfall - Arkane Studios
                                                                 ('J0087', 'D066'),  -- Death Stranding - Kojima Productions
                                                                 ('J0088', 'D035'),  -- Stray - BlueTwelve Studio
                                                                 ('J0089', 'D090'),  -- Sifu - Sloclap
                                                                 ('J0090', 'D091'),  -- Kirby and the Forgotten Land - HAL Laboratory
                                                                 ('J0091', 'D092'),  -- Bayonetta 3 - PlatinumGames
                                                                 ('J0092', 'D025'),  -- Mario + Rabbids Sparks of Hope - Ubisoft
                                                                 ('J0093', 'D093'),  -- The Callisto Protocol - Striking Distance Studios
                                                                 ('J0094', 'D062'),  -- A Plague Tale: Requiem - Asobo Studio
                                                                 ('J0095', 'D094'),  -- Gotham Knights - WB Games Montréal
                                                                 ('J0096', 'D095'),  -- Dying Light 2 Stay Human - Techland
                                                                 ('J0097', 'D096'),  -- Ghostwire: Tokyo - Tango Gameworks
                                                                 ('J0098', 'D097'),  -- Triangle Strategy - Artdink
                                                                 ('J0099', 'D024'),  -- Live A Live - Square Enix
                                                                 ('J0100', 'D029'),  -- The Quarry - Supermassive Games
                                                                 ('J0101', 'D047'),  -- Cult of the Lamb - Massive Monster
                                                                 ('J0102', 'D055'),  -- Neon White - Angel Matrix
                                                                 ('J0103', 'D011'),  -- Ori and the Blind Forest - Moon Studios
                                                                 ('J0104', 'D042'),  -- Undertale - Toby Fox
                                                                 ('J0105', 'D043'),  -- The Witness - Jonathan Blow
                                                                 ('J0106', 'D056'),  -- Cocoon - Geometric Interactive
                                                                 ('J0107', 'D050'),  -- Super Meat Boy - Team Meat
                                                                 ('J0108', 'D015'),  -- Bastion - Supergiant Games
                                                                 ('J0109', 'D068'),  -- Limbo - Playdead
                                                                 ('J0110', 'D039'),  -- Shovel Knight - Yacht Club Games
                                                                 ('J0111', 'D067'),  -- Returnal - Housemarque
                                                                 ('J0112', 'D037'),  -- Slay the Spire - MegaCrit
                                                                 ('J0113', 'D073'),  -- Gris - Nomada Studio
                                                                 ('J0114', 'D051'),  -- Katana Zero - Askiisoft
                                                                 ('J0115', 'D040'),  -- The Binding of Isaac: Rebirth - Nicalis
                                                                 ('J0116', 'D041'),  -- Oxenfree - Night School Studio
                                                                 ('J0117', 'D045'),  -- Firewatch - Campo Santo
                                                                 ('J0118', 'D046'),  -- SOMA - Frictional Games
                                                                 ('J0119', 'D002'),  -- God of War - Santa Monica Studio
                                                                 ('J0120', 'D049'),  -- Shantae and the Seven Sirens - WayForward
                                                                 ('J0121', 'D098'),  -- Horizon Forbidden West - Guerrilla Games
                                                                 ('J0122', 'D099'),  -- Death's Door - Acid Nerve
                                                                 ('J0123', 'D100'),  -- Eastward - Pixpil
                                                                 ('J0124', 'D070'),  -- Chicory: A Colorful Tale - Greg Lobanov Studio
                                                                 ('J0125', 'D101'),  -- Luigi's Mansion 3 - Next Level Games
                                                                 ('J0126', 'D048'),  -- Papers, Please - Lucas Pope
                                                                 ('J0127', 'D102'),  -- Vampire Survivors - Luca Galante
                                                                 ('J0128', 'D052'),  -- Terraria - Re-Logic
                                                                 ('J0129', 'D053'),  -- Factorio - Wube Software
                                                                 ('J0130', 'D071'),  -- Like a Dragon Infinite Wealth - Ryu Ga Gotoku Studio
                                                                 ('J0131', 'D060'),  -- 13 Sentinels: Aegis Rim - Vanillaware
                                                                 ('J0132', 'D021'),  -- Red Dead Redemption II - Rockstar Games
                                                                 ('J0135', 'D018'),  -- Minecraft - Mojang Studios
                                                                 ('J0137', 'D072'),  -- A Hat in Time - Gears for Breakfast
                                                                 ('J0138', 'D038'),  -- Tinykin - Splashteam
                                                                 ('J0139', 'D001'),  -- Super Mario Bros. Wonder - Nintendo
                                                                 ('J0140', 'D063'),  -- Darkest Dungeon - Red Hook Studios
                                                                 ('J0141', 'D024'),  -- Final Fantasy VII Rebirth - Square Enix
                                                                 ('J0142', 'D010'),  -- Paper Mario: The Thousand-Year Door - Intelligent Systems
                                                                 ('J0143', 'D054'),  -- Satisfactory - Coffee Stain Studios
                                                                 ('J0144', 'D096'),  -- Hi-Fi RUSH - Tango Gameworks
                                                                 ('J0145', 'D027'),  -- Astro Bot - Team Asobi
                                                                 ('J0146', 'D071'),  -- Judgment - Ryu Ga Gotoku Studio
                                                                 ('J0147', 'D076'),  -- Metaphor: ReFantazio - Atlus
                                                                 ('J0148', 'D024'),  -- NieR: Automata - Square Enix
                                                                 ('J0149', 'D001'),  -- Pikmin 4 - Nintendo
                                                                 ('J0150', 'D021');  -- Grand Theft Auto V - Rockstar Games
