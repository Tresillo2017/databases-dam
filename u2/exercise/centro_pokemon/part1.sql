/**
Base de datos para un Centro Pokémon
    Parte 1:
        Crear una base de datos para gestionar la información de un Centro Pokémon, incluyendo entrenadores, Pokémon, tipos de Pokémon, movimientos y batallas.
    Instrucciones:
        1. Crear el script completa para una base de datos llamada centro_pokemon.
        2. Crear las siguientes tablas con las restricciones indicadas:
            - Entrenador: (id_entrenador (int), nombre_entrenador (varchar), nivel_entrenador (int) y teléfono (int)). El campo nivel_entrenador debe ser
                          un valor entre 1 y 100. El número de teléfono debe ser único para cada entrenador.
                          El nombre del entrenador no puede repetirse en la base de datos.
            - Tipo: (id_tipo (int) y nombre_tipo). El campo nombre_tipo debe permitir los valores "Fuego", "Agua", "Eléctrico" y "Planta".
            - Pokémon: (id_pokemon (int), nombre_pokemon (varchar), nivel (int), id_entrenador e id_tipo). El nivel del Pokémon debe ser un valor entre 1 y
                       100. Establecer una relación entre Pokémon y Entrenadores utilizando el campo id_entrenador como clave foránea. El nombre del Pokémon no
                       puede repetirse en la base de datos. Además, cada Pokémon debe estar asociado a un tipo utilizando id_tipo como clave foránea.
            - Movimiento: (id_movimiento (int), nombre_movimiento (varchar), potencia (int), precision (int), efecto (text), categoria e id_tipo). El campo
                          potencia debe ser un valor numérico mayor o igual a 0 y el campo precision debe ser un valor entre 10 y 100. El campo categoria debe
                          permitir los valores “Especial” y “Físico”. Establecer una relación entre Movimiento y Tipo utilizando id_tipo como clave foránea.
            - Batalla: (id_batalla (int), id_pokemon1, id_pokemon2, fecha_batalla (datetime) y ganador. El campo fecha_batalla no puede ser nulo y debe de
                       registrar la fecha y hora actual por defecto. Además, el campo ganador   debe permitir los valores “1”, “X” y “2”.
                       Establecer relaciones entre la tabla Batalla y la tabla Pokémon para los campos id_pokemon1 e id_pokemon2,
                       de tal manera que dos Pokémon participen en una batalla.
        3. Insertar 5 registros en cada tabla utilizando datos ficticios, respetando las restricciones de cada campo.
           Asegúrate de que las relaciones entre tablas sean correctas (por ejemplo, cada batalla debe involucrar a dos Pokémon de la tabla Pokémon).
*/


-- Crear base de datos
CREATE DATABASE IF NOT EXISTS centro_pokemon;
USE centro_pokemon;

-- Creacion de tablas
DROP TABLE IF EXISTS entrenador;
CREATE TABLE IF NOT EXISTS entrenador (
    id_entrenador INT PRIMARY KEY AUTO_INCREMENT,
    nombre_entrenador VARCHAR(100) UNIQUE,
    nivel_entrenador INT CHECK (nivel_entrenador BETWEEN 1 AND 100), -- Tambien puede comprobarse con nivel_entrenador >= 1 AND nivel_entrenador <= 100
    telefono INT UNIQUE
);

DROP TABLE IF EXISTS tipo;
CREATE TABLE IF NOT EXISTS tipo (
    id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo ENUM('Fuego', 'Agua', 'Eléctrico', 'Planta')
);

DROP TABLE IF EXISTS pokemon;
CREATE TABLE IF NOT EXISTS pokemon (
    id_pokemon INT PRIMARY KEY AUTO_INCREMENT,
    nombre_pokemon VARCHAR(100) UNIQUE,
    nivel INT CHECK (nivel BETWEEN 1 AND 100),
    id_entrenador INT,
    FOREIGN KEY (id_entrenador) REFERENCES entrenador(id_entrenador) ON DELETE CASCADE, -- Si se borra un entrenador, se borran sus pokemons
    id_tipo INT,
    FOREIGN KEY (id_tipo) REFERENCES tipo(id_tipo) ON DELETE CASCADE -- Si se borra un tipo, se borran los pokemons de ese tipo
);

DROP TABLE IF EXISTS movimiento;
CREATE TABLE IF NOT EXISTS movimiento (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_movimiento VARCHAR(100),
    potencia INT CHECK (potencia >= 0),
    precission INT CHECK (precission BETWEEN 10 AND 100),
    efecto TEXT,
    categoria ENUM('Especial', 'Físico'),
    id_tipo INT,
    FOREIGN KEY (id_tipo) REFERENCES tipo(id_tipo) ON DELETE CASCADE -- Si se borra un tipo, se borran los movimientos de ese tipo
);

DROP TABLE IF EXISTS batalla;
CREATE TABLE IF NOT EXISTS batalla (
    id_batalla INT PRIMARY KEY AUTO_INCREMENT,
    ganador ENUM('1', 'X', '2'),
    id_pokemon1 INT,
    FOREIGN KEY (id_pokemon1) REFERENCES pokemon(id_pokemon) ON DELETE CASCADE, -- id_pokemon1 y id_pokemon2 son claves foraneas que referencian a la tabla pokemon
    id_pokemon2 INT,
    FOREIGN KEY (id_pokemon2) REFERENCES pokemon(id_pokemon) ON DELETE CASCADE,
    fecha_batalla DATETIME NOT NULL DEFAULT NOW()
);