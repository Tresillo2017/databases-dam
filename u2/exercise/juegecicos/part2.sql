/*
 Parte 2: Modificaciones en la estructura y datos de la base de datos

 ANOTACIÓN: Volver a escribir las restricciones de los campos, si se precisa, cuando se
 vaya a modificar el nombre y/o el tipo de dato de dicho campo para evitar borrar la
 restricción en la creación de la tabla.

 1. Modificar la estructura de una tabla:
    o Añade un nuevo campo a la tabla Juego llamado ventas (INT) que refleje el
      número de copias vendidas.
    o Modifica el nombre del campo clasificacion_edad en la tabla Juego para
      que se llame pegi.
    o Cambia el tipo de dato del campo puntos en la tabla Logro para permitir
      decimales.

 2. Modificar el valor de un dato:
    o Actualiza el precio de un juego específico, aplicando un descuento del
      15% si su disponibilidad es ‘Próximamente’ (asegúrate de haber guardado
      algún juego cuya disponibilidad sea ‘Próximamente’).
    o Cambia el país del usuario cuyo id_usuario sea 4 a "Reino Unido".
    o Actualiza la dificultad del logro cuyo id_logro sea 3 a ‘Difícil’.

 3. Borrar un registro:
    o Asegúrate de que antes de intentar borrar un registro padre se borren los
      registros hijos relacionados.
    o Elimina de la tabla Logro aquellos logros cuya dificultad sea ‘Fácil’.
    o Elimina de la tabla Partida aquellas partidas que duran menos de X
      minutos (establece tú mismo ese valor X acorde a tus datos en la tabla).

 4. Agregar registros y modificar relaciones:
    o Añade un nuevo logro en la tabla Logro con nivel de dificultad ‘Difícil’ y
      asígnalo a tres usuarios distintos.
    o Inserta un nuevo juego en la tabla Juego con una disponibilidad
      ‘Próximamente’ y precio de 20, y añade este juego a dos usuarios.

 5. Operaciones avanzadas:
    o Inserta cinco nuevas partidas multijugador en la tabla Partida,
      asignándolas a distintos juegos y con ganadores distintos.
    o Cambia la disponibilidad de todos los juegos cuyo género sea "Aventura" a
      ‘No Disponible’.
    o Agregar el campo id_amigo a la tabla Usuario y establecer una relación
      reflexiva (relación dentro de la misma tabla) con Usuario a través del
      campo id_amigo, estableciendo así, una relación de amistad entre los
      usuarios de la plataforma.
    o Inserta otros 5 usuarios nuevos que sean amigos de los usuarios que ya
      existen.
 */

USE plataforma_videojuegos;

ALTER TABLE juego
RENAME COLUMN clasificacion_edad TO pegi;

ALTER TABLE logro
MODIFY COLUMN puntos DECIMAL(5,2) CHECK (puntos > 0 AND puntos < 100);

UPDATE juego
SET precio = ROUND(precio * 0.85, 2)
WHERE disponibilidad = 'Próximamente';

UPDATE usuario
SET pais = 'Reino Unido'
WHERE id_usuario = 4;

UPDATE logro
SET dificultad = 'Difícil'
WHERE id_logro = 3;

DELETE FROM logro
WHERE dificultad = 'Fácil';

DELETE FROM partida
WHERE duracion_minutos < 15;

INSERT INTO logro (id_logro, nombre_logro, descripcion, dificultad, puntos, id_juego, id_usuario)
VALUES
(6, 'Logro difícil 1', 'sdad', 'Difícil', 50.00, 1, 1),
(7, 'Logro difícil 2', 'asdasd', 'Difícil', 60.00, 1, 2),
(8, 'Logro difícil 3', 'sada', 'Difícil', 70.00, 1, 3);

INSERT INTO juego (id_juego, genero, precio, pegi, disponibilidad)
VALUES (6, 'Aventura', 20.00, 12, 'Próximamente');

INSERT INTO usuario (id_usuario,nombre_usuario, email, fecha_registro, pais)
VALUES
(6, 'sss', 'test@example.com', DEFAULT, 'España'),
(7, 'sssss', 'test2@example.com', DEFAULT, 'España');

INSERT INTO partida (id_partida, id_juego, id_ganador, duracion_minutos)
VALUES
(6, 1, 1, 45),
(7, 2, 2, 50),
(8, 3, 3, 60),
(9, 4, 4, 70),
(10, 5, 5, 80);

UPDATE juego
SET disponibilidad = 'No Disponible'
WHERE genero = 'Aventura';

ALTER TABLE usuario
ADD COLUMN id_amigo INT,
ADD FOREIGN KEY (id_amigo) REFERENCES usuario(id_usuario) ON DELETE SET NULL;

INSERT INTO usuario (id_usuario,nombre_usuario, email, fecha_registro, pais, id_amigo)
VALUES
(8,'sdsda', 'test333@example.com', DEFAULT, 'España', 1),
(9,'sadads', 'test2333@example.com', DEFAULT, 'España', 2),
(10,'asdsad', 'test2323@example.com', DEFAULT, 'España', 3),
(11,'sdasdads', 'test4@example.com', DEFAULT, 'España', 4),
(12,'sadasdadsd', 'test5@example.com', DEFAULT, 'España', 5);

