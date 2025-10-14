/*
Parte 2: Modificaciones en la estructura y datos de la base de datos
    1. Modificar la estructura de una tabla:
        - Añade un nuevo campo a la tabla Serie para almacenar el número de temporadas.
        - Modifica el nombre del campo correo en la tabla Usuario para que se llame email_usuario.
        - Cambia el tipo de dato del campo duracion en la tabla Episodio para permitir decimales (por ejemplo, episodios de 45.5 minutos).
    2. Modificar el valor de un dato:
        - Actualiza la calificación de la serie cuyo id_serie sea 2, aumentando su calificación a 9.
        - Cambia el género de una serie cuyo id_serie sea 5 a "Comedia".
        - Actualiza el estado de suscripción del usuario cuyo id_usuario sea 3 a "Activo".
    3. Borrar un registro:
        - Elimina de la tabla Episodio todos los episodios cuya duración sea menor a 80 minutos.
        - Borra de la tabla Serie todas las series que fueron estrenadas antes del año 2000.
    4. Agregar registros y modificar relaciones:
        - Añade un nuevo género en la tabla Géneros con el nombre "Animación" y asigna este nuevo género a una nueva serie que debes insertar.
    5. Operaciones avanzadas:
        - Inserta cinco nuevos episodios en la tabla Episodios, asignándolos a distintas series.
        - Crea una nueva tabla llamada Comentario con los campos id_comentario (int), id_usuario, id_serie, texto_comentario (text), y fecha_comentario
            (datetime). El campo texto_comentario no puede esta vacío y el campo fecha_comentario solo debe permitir guardar la fecha actual. Inserta al
            menos diez comentarios realizados por usuarios sobre diferentes series.
        - Cambia el estado de suscripción de todos los usuarios registrados antes de 2022 a "Inactivo".
    6. Borrar una tabla:
        - Asegúrate de que si borras un registro padre, se borran sus hijos.
        - Borra todos los actores cuya edad sea superior a 40.
*/

-- Modificar la estructura de la tabla Serie para añadir el campo numero_temporadas
ALTER TABLE Serie
ADD numero_temporadas INT CHECK (numero_temporadas >= 0);

-- Modificar el nombre del campo correo en la tabla Usuario a email_usuario
ALTER TABLE Usuario
CHANGE COLUMN correo email_usuario VARCHAR(255) NOT NULL;

-- Cambiar el tipo de dato del campo duracion en la tabla Episodio para permitir decimales
ALTER TABLE Episodio
MODIFY COLUMN duracion DECIMAL(5,2) CHECK (duracion > 0);

-- Actualizar la calificación de la serie cuyo id_serie sea 2, aumentando su calificación a 9
UPDATE Serie
SET calificacion = 9
WHERE id_serie = 2;

-- Cambiar el género de una serie cuyo id_serie sea 5 a "Comedia"
UPDATE Serie
SET id_genero = (SELECT id_genero FROM Genero WHERE nombre_genero = 'Comedia' LIMIT 1)
WHERE id_serie = 5;

-- Actualizar el estado de suscripción del usuario cuyo id_usuario sea 3 a "Activo"
UPDATE Usuario
SET suscripcion = 'Activo'
WHERE id_usuario = 3;

-- Eliminar de la tabla Episodio todos los episodios cuya duración sea menor a 80 minutos
DELETE FROM Episodio
WHERE duracion < 80;

-- Borrar de la tabla Serie todas las series que fueron estrenadas antes del año 2000
DELETE FROM Serie
WHERE ano_estreno < 2000;

-- Añadir un nuevo género en la tabla Géneros con el nombre "Animación"
ALTER TABLE Genero CHANGE nombre_genero nombre_genero ENUM('Drama', 'Comedia', 'Ciencia Ficción', 'Acción', 'Terror', 'Fantasía', 'Animación', 'Genero') NOT NULL;

-- Insertar una nueva serie y asignarle el género "Animación"
INSERT INTO Serie (id_serie, titulo_serie, ano_estreno, id_genero, calificacion, numero_temporadas)
VALUES (6, 'Serie Animada', 2021, 6, 8, 2);

-- Insertar cinco nuevos episodios en la tabla Episodio, asignándolos a distintas series
INSERT INTO Episodio (id_episodio, titulo_episodio, temporada, duracion, id_serie, fecha_emision) VALUES
(6, 'Episodio 1', 1, 45.5, 1, '2021-01-01'),
(7, 'Episodio 2', 1, 50.0, 2, '2021-01-08'),
(8, 'Episodio 3', 1, 42.0, 3, '2021-01-15'),
(9, 'Episodio 4', 1, 48.5, 4, '2021-01-22'),
(10, 'Episodio 5', 1, 47.0, 5, '2021-01-29');

-- Crear la tabla Comentario
CREATE TABLE Comentario (
    id_comentario INT PRIMARY KEY,
    id_usuario INT,
    id_serie INT,
    texto_comentario TEXT NOT NULL,
    fecha_comentario DATETIME DEFAULT CURRENT_TIMESTAMP CHECK (fecha_comentario <= NOW()),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_serie) REFERENCES Serie(id_serie)
);

-- Insertar diez comentarios realizados por usuarios sobre diferentes series
INSERT INTO Comentario (id_comentario, id_usuario, id_serie, texto_comentario) VALUES
(1, 1, 1, 'Me encanta esta serie!'),
(2, 2, 2, 'Muy entretenida.'),
(3, 3, 3, 'No es mi favorita.'),
(4, 4, 4, 'Excelente trama y personajes.'),
(5, 5, 5, 'La recomiendo a todos.'),
(6, 1, 2, 'Los episodios son muy cortos.'),
(7, 2, 3, 'La actuación es impresionante.'),
(8, 3, 4, 'Podría mejorar en algunos aspectos.'),
(9, 4, 5, 'La música es genial.'),
(10, 5, 1, 'Espero la próxima temporada con ansias.');

-- Cambiar el estado de suscripción de todos los usuarios registrados antes de 2022 a "Inactivo"
UPDATE Usuario
SET suscripcion = 'Inactivo'
WHERE fecha_registro < '2022-01-01';

-- Borrar todos los actores cuya edad sea superior a 40
DELETE FROM Actor
WHERE fecha_nacimiento < DATE_SUB(CURDATE(), INTERVAL 40 YEAR);