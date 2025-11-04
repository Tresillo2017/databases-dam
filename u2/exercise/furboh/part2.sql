/*
Parte 2 — Modificaciones en la estructura y datos de la base de datos

ANOTACIÓN IMPORTANTE:
- Si vas a cambiar el nombre o tipo de un campo que tiene restricciones (PK, FK, UNIQUE, CHECK, DEFAULT, etc.),
  reescribe las restricciones necesarias al modificar la columna para evitar perderlas involuntariamente.

Tareas:
1) Modificar la estructura de una tabla
   a) Añade un nuevo campo a la tabla Jugador: numero_camisa INT.
      - Debe ser UNIQUE.
      - Debe estar entre 1 y 99 (CHECK).
   b) Renombra el campo ciudad en la tabla Estadio a ubicacion.
      - Asegúrate de mantener/reescribir cualquier restricción asociada.

2) Modificar el valor de un dato
   a) Actualiza la capacidad del estadio con id_estadio = 2 incrementándola en un 20%.
   b) Cambia el equipo_favorito del aficionado con id_aficionado = 4 por otro equipo distinto.

3) Borrar registros (teniendo en cuenta integridad referencial)
   a) Antes de borrar un registro "padre", borra o actualiza los registros "hijo" relacionados (según tu modelo).
   b) Elimina de Jugador todos los jugadores cuyo equipo haya "descendido" (simula equipos que han quedado últimos).
   c) Borra de Partido todos los partidos celebrados en julio de 2024.
      - Asegúrate de haber insertado al menos un partido con fecha en julio de 2024 antes de probar el borrado.
   d) Elimina aquellos jugadores que sean 'Delanteros' y cuyo salario sea mayor que X.
      - Elige X según prefieras (sugerencia: X = 50000).

4) Agregar registros y modificar relaciones
   a) Inserta un nuevo registro en Aficionado y asígnale un equipo_favorito existente (FK a Equipo).
   b) Inserta cinco nuevos partidos en Partido, usando combinaciones distintas de equipos locales y visitantes.

5) Operaciones avanzadas (nuevos campos y actualizaciones condicionales)
   a) Añade a Jugador los campos:
      - partidos_jugados INT CHECK (partidos_jugados >= 0)
      - goles INT CHECK (goles >= 0)
      - asistencias INT CHECK (asistencias >= 0)
      - tarjetas_amarillas INT CHECK (tarjetas_amarillas BETWEEN 0 AND 15)
      - tarjetas_rojas INT CHECK (tarjetas_rojas BETWEEN 0 AND 5)
   b) Aumentos salariales según rendimiento:
      - Aumenta el salario un 25% a jugadores con goles > X1. (sugerencia: X1 = 10)
      - Aumenta el salario un 10% a jugadores con asistencias > X2. (sugerencia: X2 = 8)
      - Aumenta el salario un 50% a jugadores con goles > X3 y asistencias > Y3. (sugerencia: X3 = 15, Y3 = 10)

Indicaciones prácticas y ejemplos de comandos (orientativos)
- Para añadir una columna con CHECK y UNIQUE, puedes usar ALTER TABLE ... ADD COLUMN ... con la cláusula CHECK y luego crear una UNIQUE INDEX si el SGBD no permite UNIQUE en la misma sentencia.
- Para renombrar una columna, usa ALTER TABLE ... RENAME COLUMN ... (o la sintaxis equivalente de tu SGBD) y vuelve a crear CHECK/UNIQUE/FK si es necesario.
- Para actualizar capacidades en 20%:
    UPDATE Estadio SET capacidad = ROUND(capacidad * 1.20) WHERE id_estadio = 2;
- Para borrar dependencias, usa DELETE ... FROM Hijo WHERE ... antes de DELETE FROM Padre WHERE ...
- Para operaciones condicionales sobre salario:
    UPDATE Jugador SET salario = salario * 1.25 WHERE goles > X1;

Entrega
- Incluye en tu solución los ALTER TABLE, UPDATE, INSERT y DELETE necesarios, y verifica las restricciones tras cada cambio.
*/

USE liga_futbol;

ALTER TABLE jugador
ADD COLUMN numero_camisa INT UNIQUE CHECK (numero_camisa BETWEEN 1 AND 99);

ALTER TABLE estadio
RENAME COLUMN ciudad TO ubicacion;

UPDATE estadio
SET capacidad = ROUND(capacidad * 1.20)
WHERE id_estadio = 2;

UPDATE aficionado
SET equipo_favorito = (3)
WHERE id_aficionado = 4;

DELETE FROM jugador
WHERE id_equipo IN (
    SELECT id_equipo
    FROM equipo
    WHERE posicion = 2
);

DELETE FROM partido
WHERE fecha_partido BETWEEN '2024-07-01 00:00:00' AND '2024-07-31 23:59:59';

DELETE FROM jugador
WHERE posicion = 'Delantero' AND salario > 50000;

INSERT INTO aficionado (nombre_aficionado, equipo_favorito, fecha_nacimiento, genero)
VALUES ('Carlos Pérez', 1, '1995-06-15', 'Masculino');

INSERT INTO partido (id_equipoLocal, id_equipoVisitante, fecha_partido, id_estadio)
VALUES (1, 2, '2024-09-10 18:00:00', 1),
       (3, 4, '2024-09-11 20:00:00', 2),
       (5, 1, '2024-09-12 16:00:00', 3),
       (2, 3, '2024-09-13 19:00:00', 4),
       (4, 5, '2024-09-14 21:00:00', 5);

ALTER TABLE jugador
ADD COLUMN partidos_jugados INT CHECK (partidos_jugados >= 0),
ADD COLUMN goles INT CHECK (goles >= 0),
ADD COLUMN asistencias INT CHECK (asistencias >= 0),
ADD COLUMN tarjetas_amarillas INT CHECK (tarjetas_amarillas BETWEEN 0 AND 15),
ADD COLUMN tarjetas_rojas INT CHECK (tarjetas_rojas BETWEEN 0 AND 5);

UPDATE jugador
SET salario = salario * 1.25
WHERE goles > 10;

UPDATE jugador
SET salario = salario * 1.10
WHERE asistencias > 8;

UPDATE jugador
SET salario = salario * 1.50
WHERE goles > 15 AND asistencias > 10;

