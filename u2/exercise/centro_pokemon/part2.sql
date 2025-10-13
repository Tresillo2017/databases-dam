/*
Parte 2: Modificaciones en la estructura y datos de la base de datos
    1. Modificar la estructura de una tabla:
        - Añade un nuevo campo a la tabla Entrenador para almacenar la cantidad de medallas que ha ganado el entrenador.
        - Modifica el nombre del campo telefono en la tabla Entrenadores para que se llame contacto_telefono.
        - Cambia el tipo de dato del campo potencia de la tabla Movimientos para que permita decimales.
    2. Modificar el valor de un dato:
        - Actualiza el nivel de un Pokémon cuyo id_pokemon sea 4, incrementándolo en 5 niveles.
        - Cambia el tipo de un Pokémon de la base de datos para que sea de tipo "Eléctrico".
        - Cambia el número de teléfono de un entrenador de la base de datos.
    3. Agregar registros y modificar relaciones:
        - Modifica la tabla Pokémon para añadir otra clave foránea llamada id_tipoDual, que haga referencia a la tabla Tipo. Ahora añade un nuevo
          Pokémon a la tabla Pokémon con los datos de un tipo dual (por ejemplo, "Planta" y "Agua").
        - Añade cinco nuevos registros en la tabla Batalla, asegurándote de que las fechas de las batallas sean de entre 2020 y 2025.
    4. Borrar un registro:
        - Antes de borrar un registro hay que asegurarse de si borramos un elemento padre, se borren sus hijos.
        - Elimina de la tabla Pokémon todos los registros donde el Pokémon tenga un nivel superior a X.
        - Elimina todas las batallas realizadas antes de la fecha actual.
 */

-- Añade un nuevo campo a la tabla Entrenador para almacenar la cantidad de medallas que ha ganado el entrenador.
ALTER TABLE entrenador
    ADD medallas INT DEFAULT 0; -- Por defecto, un entrenador empieza con 0 medallas

-- Modifica el nombre del campo telefono en la tabla Entrenadores para que se llame contacto_telefono.
ALTER TABLE entrenador
    CHANGE telefono contacto_telefono INT;

-- Cambia el tipo de dato del campo potencia de la tabla Movimientos para que permita decimales. Como maximo puede almacenar 999.99
ALTER TABLE movimiento
    CHANGE potencia potencia DECIMAL(5,2) CHECK (potencia >= 0);

-- Acutualiza el nivel de un Pokémon cuyo id_pokemon sea 4, incrementándolo en 5 niveles.
UPDATE pokemon
SET nivel = nivel + 5
WHERE id_pokemon = 4;

-- Cambia el tipo de un Pokémon de la base de datos para que sea de tipo "Eléctrico".
UPDATE pokemon
SET id_tipo = 4
WHERE id_pokemon = 2; -- Cambiamos el tipo del pokemon con id

-- Modifica la tabla Pokémon para añadir otra clave foránea llamada id_tipoDual, que haga referencia a la tabla Tipo.
ALTER TABLE pokemon
    ADD id_tipoDual INT,
    ADD FOREIGN KEY (id_tipoDual) REFERENCES tipo(id_tipo) ON DELETE CASCADE; -- Si se borra un tipo, se borran los pokemons de ese tipo

-- Ahora añade un nuevo Pokémon a la tabla Pokémon con los datos de un tipo dual (por ejemplo, "Planta" y "Agua").
INSERT INTO pokemon (nombre_pokemon, nivel, id_entrenador, id_tipo, id_tipoDual) VALUES
('LUdicolo', 30, 2, 2, 3); -- Ludicolo es de tipo Agua y Planta

-- Añade cinco nuevos registros en la tabla Batalla, asegurándote de que las fechas de las batallas sean de entre 2020 y 2025.
INSERT INTO batalla (fecha_batalla, ganador, id_pokemon1, id_pokemon2) VALUES
('2021-03-11', '1', 2, 6),
('2021-07-20', '1', 1, 3),
('2022-09-10', 'X', 1, 3),
('2023-11-25', '1', 2, 4),
(DEFAULT,'2', 1, 4);

-- Modifica la fecha de la batalla con id 8 para que sea la fecha actual
UPDATE batalla
SET fecha_batalla = NOW()
WHERE id_batalla = 8;

-- Elimina de la tabla Pokémon todos los registros donde el Pokémon tenga un nivel superior a 50.
DELETE FROM pokemon
WHERE nivel > 50;

-- Elimina todas las batallas realizadas antes de la fecha actual.
DELETE FROM batalla
WHERE fecha_batalla < NOW();