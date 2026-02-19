-- EJERCICIO 1
-- Muestra el nombre de los equipos cuyos jugadores han marcado
-- más goles que la media de goles de los jugadores del equipo
-- más antiguo.

SELECT nombre
FROM equipo
WHERE id_equipo IN (
    SELECT id_equipo
    FROM jugador
    GROUP BY id_equipo
    HAVING SUM(goles) > (
        SELECT AVG(goles)
        FROM jugador
        WHERE id_equipo = (
            SELECT id_equipo
            FROM equipo
            WHERE fundacion = (
                SELECT MIN(fundacion)
                FROM equipo
            )
        )
    )
);

-- EJERCICIO 2
-- Muestra el nombre y goles de los jugadores que han marcado
-- más goles que cualquier jugador del equipo con menos victorias.

SELECT nombre, goles
FROM jugador
WHERE goles > ALL (
    SELECT goles
    FROM jugador
    WHERE id_equipo = (
        SELECT id_equipo
        FROM equipo
        WHERE victorias = (
            SELECT MIN(victorias)
            FROM equipo
        )
    )
);

-- EJERCICIO 3
-- Muestra los equipos que tienen menos jugadores que el equipo
-- que juega como local en el estadio de mayor capacidad.

SELECT e.nombre, COUNT(j.id_jugador)
FROM equipo e
         JOIN jugador j ON e.id_equipo = j.id_equipo
GROUP BY e.id_equipo, e.nombre
HAVING COUNT(j.id_jugador) < (
    SELECT COUNT(j.id_jugador)
    FROM partido p
             JOIN estadio s ON p.id_estadio = s.id_estadio
             JOIN jugador j ON p.equipo_local = j.id_equipo
    WHERE s.capacidad = (
        SELECT MAX(capacidad)
        FROM estadio
    )
);


-- EJERCICIO 4
-- Muestra los jugadores que han marcado más goles que la media
-- de goles de los jugadores que NO han sido sancionados.

SELECT nombre
FROM jugador
WHERE goles > (
    SELECT AVG(goles)
    FROM jugador
    WHERE id_jugador NOT IN (
        SELECT id_jugador
        FROM sancion
    )
);

-- EJERCICIO 5
-- Muestra los equipos que han perdido más partidos que el equipo
-- con más victorias y cuyos jugadores no han sido nunca sancionados.

SELECT nombre
FROM equipo
WHERE derrotas > (
    SELECT derrotas
    FROM equipo
    WHERE victorias = (
        SELECT MAX(victorias)
        FROM equipo
    )
)
  AND NOT EXISTS (
    SELECT *
    FROM sancion s
    WHERE s.id_jugador IN (
        SELECT j.id_jugador
        FROM jugador j
        WHERE j.id_equipo = equipo.id_equipo
    )
);

-- EJERCICIO 6
-- Muestra los equipos cuyos jugadores han marcado más goles
-- que la media de goles de los jugadores del equipo con menos derrotas.

SELECT nombre
FROM equipo
WHERE id_equipo IN (
    SELECT id_equipo
    FROM jugador
    GROUP BY id_equipo
    HAVING SUM(goles) > (
        SELECT AVG(goles)
        FROM jugador
        WHERE id_equipo = (
            SELECT id_equipo
            FROM equipo
            WHERE derrotas = (
                SELECT MIN(derrotas)
                FROM equipo
            )
        )
    )
);

-- EJERCICIO 7
-- Muestra el nombre y edad de los jugadores que tienen más
-- asistencias que cualquier jugador del equipo con menos empates.

SELECT nombre, edad
FROM jugador
WHERE asistencias > ALL (
    SELECT asistencias
    FROM jugador
    WHERE id_equipo = (
        SELECT id_equipo
        FROM equipo
        WHERE empates = (
            SELECT MIN(empates)
            FROM equipo
        )
    )
);

-- EJERCICIO 9
-- Muestra los jugadores que tienen más goles que la media
-- de goles de los jugadores que han sufrido alguna lesión.

SELECT nombre
FROM jugador
WHERE goles > (
    SELECT AVG(goles)
    FROM jugador
    WHERE id_jugador IN (
        SELECT id_jugador
        FROM lesion
    )
);

-- EJERCICIO 11
-- Muestra el nombre de los equipos para los que EXISTE al menos
-- un jugador tal que, para ALGÚN OTRO EQUIPO, existe al menos
-- un jugador que haya marcado menos goles que él.

SELECT e.nombre
FROM equipo e
WHERE EXISTS (
    SELECT j.id_jugador
    FROM jugador j
    WHERE j.id_equipo = e.id_equipo
      AND EXISTS (
        SELECT j2.id_jugador
        FROM jugador j2
        WHERE j2.id_equipo != j.id_equipo
          AND j.goles > j2.goles
    )
);

-- EJERCICIO 12
-- Muestra los jugadores que NO han sido ni sancionados ni lesionados.

SELECT j.nombre
FROM jugador j
WHERE NOT EXISTS (
    SELECT s.id_jugador
    FROM sancion s
    WHERE s.id_jugador = j.id_jugador
)
  AND NOT EXISTS (
    SELECT l.id_jugador
    FROM lesion l
    WHERE l.id_jugador = j.id_jugador
);


-- EJERCICIO 13
-- Muestra los equipos que tienen jugadores, pero NINGUNO de sus
-- jugadores ha sido transferido nunca.

SELECT e.nombre
FROM equipo e
WHERE EXISTS (
    SELECT j.id_jugador
    FROM jugador j
    WHERE j.id_equipo = e.id_equipo
)
  AND NOT EXISTS (
    SELECT t.id_transferencia
    FROM transferencia t
    WHERE EXISTS (
        SELECT j2.id_jugador
        FROM jugador j2
        WHERE j2.id_jugador = t.id_jugador
          AND j2.id_equipo = e.id_equipo
    )
);

-- EJERCICIO 14
-- Muestra los jugadores que han marcado MÁS goles que TODOS
-- los jugadores de SU MISMO EQUIPO.

SELECT j.nombre
FROM jugador j
WHERE NOT EXISTS (
    SELECT j2.id_jugador
    FROM jugador j2
    WHERE j2.id_equipo = j.id_equipo
      AND j2.goles > j.goles
);

-- EJERCICIO 15
-- Muestra los equipos cuyos jugadores NO han sido nunca
-- capitaneados por un jugador de OTRO equipo.

SELECT e.nombre
FROM equipo e
WHERE NOT EXISTS (
    SELECT j.id_jugador
    FROM jugador j
    WHERE j.id_equipo = e.id_equipo
      AND EXISTS (
        SELECT j2.id_jugador
        FROM jugador j2
        WHERE j.id_jugador = j2.id_capitan
          AND j2.id_equipo != e.id_equipo
    )
);

-- EJERCICIO 16
-- Muestra los jugadores que han marcado MÁS goles que TODOS
-- los jugadores de su propio equipo.

SELECT j.nombre
FROM jugador j
WHERE j.goles >= ALL (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo = j.id_equipo
);

-- EJERCICIO 17
-- Muestra los equipos que NO tienen ningún jugador sancionado.

SELECT e.nombre
FROM equipo e
WHERE e.id_equipo NOT IN (
    SELECT j.id_equipo
    FROM jugador j
    WHERE j.id_jugador IN (
        SELECT s.id_jugador
        FROM sancion s
    )
);

-- EJERCICIO 18
-- Muestra los jugadores que han marcado MÁS goles que ALGÚN
-- jugador de OTRO equipo.

SELECT j.nombre
FROM jugador j
WHERE j.goles > ANY (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo != j.id_equipo
);

-- EJERCICIO 19
-- Muestra los equipos cuyos jugadores NO han sido nunca transferidos.

SELECT e.nombre
FROM equipo e
WHERE e.id_equipo NOT IN (
    SELECT j.id_equipo
    FROM jugador j
    WHERE j.id_jugador IN (
        SELECT t.id_jugador
        FROM transferencia t
    )
);

-- EJERCICIO 20
-- Muestra los jugadores que han marcado MENOS goles que TODOS
-- los jugadores de su propio equipo.
-- (mínimo por equipo)

SELECT j.nombre
FROM jugador j
WHERE j.goles <= ALL (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo = j.id_equipo
);

-- EJERCICIO 21
-- Muestra los jugadores que han marcado MÁS goles que TODOS
-- los jugadores de CUALQUIER OTRO equipo.

SELECT j.nombre
FROM jugador j
WHERE j.goles > ALL (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo != j.id_equipo
);

-- EJERCICIO 23
-- Muestra los jugadores que han marcado MÁS goles que ALGÚN
-- jugador de TODOS LOS DEMÁS EQUIPOS.

SELECT j.nombre
FROM jugador j
WHERE j.id_equipo NOT IN (
    SELECT j2.id_equipo
    FROM jugador j2
    WHERE j2.id_equipo != j.id_equipo
      AND j.goles <= ALL (
        SELECT j3.goles
        FROM jugador j3
        WHERE j3.id_equipo = j2.id_equipo
    )
);

-- EJERCICIO 24
-- Muestra los equipos que SOLO tienen jugadores que han marcado
-- MÁS goles que ALGÚN jugador de OTRO equipo.

SELECT e.nombre
FROM equipo e
WHERE e.id_equipo NOT IN (
    SELECT j.id_equipo
    FROM jugador j
    WHERE j.id_equipo = e.id_equipo
      AND j.goles <= ALL (
        SELECT j2.goles
        FROM jugador j2
        WHERE j2.id_equipo != e.id_equipo
    )
);

-- EJERCICIO 25
-- Muestra los jugadores que NO son ni el máximo ni el mínimo
-- goleador de su equipo.
-- (exclusión de extremos sin agregados)

SELECT j.nombre
FROM jugador j
WHERE j.goles != ALL (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo = j.id_equipo
      AND j2.goles >= ALL (
        SELECT j3.goles
        FROM jugador j3
        WHERE j3.id_equipo = j.id_equipo
    )
)
  AND j.goles != ALL (
    SELECT j2.goles
    FROM jugador j2
    WHERE j2.id_equipo = j.id_equipo
      AND j2.goles <= ALL (
        SELECT j3.goles
        FROM jugador j3
        WHERE j3.id_equipo = j.id_equipo
    )
);

-- EJERCICIO 26.
-- Muestra los equipos que han jugado más partidos como local que el equipo más antiguo del sistema.
SELECT e.nombre, COUNT(p.id_partido) AS partidos_local
FROM equipo e
         JOIN partido p ON e.id_equipo = p.equipo_local
GROUP BY e.id_equipo
HAVING COUNT(p.id_partido) > (
    SELECT COUNT(p2.id_partido)
    FROM equipo e2
             JOIN partido p2 ON e2.id_equipo = p2.equipo_local
    WHERE e2.fundacion = (
        SELECT MIN(fundacion) FROM equipo
    )
);

-- EJERCICIO 27.
-- Muestra el nombre de los jugadores que han marcado más goles que cualquier jugador de nacionalidad española.
SELECT nombre, goles
FROM jugador
WHERE goles > ALL (
    SELECT goles
    FROM jugador
    WHERE nacionalidad = 'Española'
);