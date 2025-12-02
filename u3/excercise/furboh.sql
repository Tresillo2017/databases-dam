-- EJERCICIO 1: Muestra todos los campos de todos los equipos registrados en la tabla equipo.
SELECT * FROM equipo;

-- EJERCICIO 2: Muestra el nombre, ciudad y año de fundación de todos los equipos, ordenados por año de fundación de más antiguo a más moderno.
SELECT nombre, ciudad, fundacion
FROM equipo
ORDER BY fundacion DESC;

-- EJERCICIO 3: Muestra el nombre y la ciudad de los equipos cuya ciudad sea 'Madrid', ordenados alfabéticamente por nombre del equipo.
SELECT nombre, ciudad
FROM equipo
WHERE ciudad = 'madrid'
ORDER BY nombre;

-- EJERCICIO 4: Muestra el nombre, la edad y los goles de los jugadores que hayan marcado más de 10 goles, ordenados de mayor a menor número de goles.
SELECT nombre, edad, goles
FROM jugador
WHERE goles > 10
ORDER BY goles DESC;

-- EJERCICIO 5: Muestra el nombre de los jugadores que actualmente no estén asociados a ningún equipo (jugadores cuyo id_equipo sea NULL).
SELECT nombre, id_equipo
FROM jugador
WHERE id_equipo IS NULL;

-- EJERCICIO 6: Muestra el id del partido, la fecha y los goles de local y visitante de aquellos partidos que no tengan estadio asignado.
SELECT id_partido, fecha, goles_local, goles_visitante, id_estadio
FROM partido
WHERE id_estadio IS NULL;

-- EJERCICIO 7: Muestra las diferentes ciudades en las que haya equipos.
SELECT DISTINCT ciudad FROM equipo;

-- EJERCICIO 8: Muestra el nombre de cada equipo junto con el total de partidos disputados (victorias + empates + derrotas), ordenados de mayor a menor los partidos disputados.
SELECT nombre, victorias + empates + derrotas AS TOTAL_PARTIDOS
FROM equipo
ORDER BY TOTAL_PARTIDOS DESC;

-- EJERCICIO 9: Muestra el nombre de los equipos cuya ciudad sea 'Sevilla' y que además tengan más victorias que derrotas.
SELECT nombre, ciudad, victorias, derrotas
FROM equipo
WHERE ciudad = 'Sevilla'
  AND victorias > derrotas;

-- EJERCICIO 10: Muestra el nombre, la nacionalidad y los goles de los jugadores cuya nacionalidad sea 'España', 'Brasil' o 'Argentina', usando el operador IN. De aquellos jugadores que hayan marcado más de 10 goles.
SELECT nombre, nacionalidad, goles
FROM jugador
WHERE (nacionalidad = 'españa' OR nacionalidad = 'brasil' OR nacionalidad = 'argentina')
  AND goles > 10;

SELECT nombre, nacionalidad, goles
FROM jugador
WHERE nacionalidad IN ('España', 'Brasil', 'Argentina')
  AND goles > 10;

-- EJERCICIO 11: Muestra el nombre, la posición y el equipo de todos los jugadores cuya posición no sea 'Portero'.
SELECT j.nombre AS JUGADOR, j.posicion, e.nombre AS EQUIPO
FROM jugador j
         JOIN equipo e ON j.id_equipo = e.id_equipo
WHERE posicion != 'portero';

-- EJERCICIO 12: Muestra el nombre y la edad de los jugadores cuyo nombre comience por la letra 'A'.
SELECT nombre, edad
FROM jugador
WHERE nombre LIKE 'a%';

-- EJERCICIO 13: Muestra el nombre de los equipos cuyo nombre contenga la palabra 'Real' en cualquier parte del texto.
SELECT nombre
FROM equipo
WHERE nombre LIKE '%real%';

-- EJERCICIO 14: Muestra el nombre y la ciudad de los estadios cuya ciudad tenga como segunda letra la 'a'.
SELECT nombre, ciudad
FROM estadio
WHERE ciudad LIKE '_a%';

-- EJERCICIO 15: Muestra la edad media de todos los jugadores de la base de datos.
SELECT AVG(edad) AS MEDIA_EDAD
FROM jugador;

-- EJERCICIO 16: Muestra el número máximo de goles y el número mínimo de goles marcados por todos los jugadores.
SELECT MAX(goles), MIN(goles)
FROM jugador;

-- EJERCICIO EXTRA: Muestra el nombre del máximo goleador, así como el número de goles que ha marcado.
SELECT nombre, goles
FROM jugador
ORDER BY goles DESC
LIMIT 1;

-- EJERCICIO 17: Muestra la suma total de victorias de todos los equipos de la tabla equipo.
SELECT SUM(victorias) AS TOTAL_VICTORIAS
FROM equipo;

-- EJERCICIO 18: Muestra cuántos jugadores hay que estén asociados a algún equipo (id_equipo NO sea NULL).
SELECT COUNT(id_jugador) AS NUM_JUGADORES
FROM jugador
WHERE id_equipo IS NOT NULL;

-- EJERCICIO 19: Muestra cuántos jugadores hay por cada posición (delantero, defensa, etc.), mostrando la posición y el número de jugadores.
SELECT COUNT(id_jugador) AS NUM_JUGADORES, posicion
FROM jugador
GROUP BY posicion;

-- EJERCICIO 20: Muestra el nombre de cada equipo y cuántos jugadores tiene, usando un JOIN entre equipo y jugador y agrupando por equipo.
SELECT e.nombre AS EQUIPO, COUNT(j.id_jugador) AS NUM_JUGADORES
FROM jugador j
         JOIN equipo e ON j.id_equipo = e.id_equipo
GROUP BY e.nombre;

-- EJERCICIO EXTRA: Muestra cuántos jugadores  no tienen equipo
SELECT COUNT(*)
FROM jugador
WHERE id_equipo IS NULL;

-- EJERCICIO EXTRA: Muestra cuántos jugadores tienen equipo
SELECT COUNT(id_equipo)
FROM jugador;

-- EJERCICIO 21: Muestra el nombre de cada equipo y la media de goles de sus jugadores, mostrando solo aquellos equipos cuya media de goles sea superior a 5.
SELECT e.nombre AS EQUIPO, AVG(j.goles) AS MEDIA_GOLES
FROM jugador j
         JOIN equipo e ON j.id_equipo = e.id_equipo
GROUP BY e.nombre
HAVING MEDIA_GOLES > 5;

-- EJERCICIO 22: Muestra el nombre y la ciudad de cada estadio, junto con el número de partidos que se han jugado en él, ordenados de mayor a menor número de partidos.
SELECT es.nombre AS ESTADIO, es.ciudad, COUNT(*) AS PARTIDOS_JUGADOS
FROM estadio es
         JOIN partido p ON es.id_estadio = p.id_estadio
GROUP BY es.nombre
ORDER BY PARTIDOS_JUGADOS DESC;

-- EJERCICIO 23: Muestra el id del partido, la fecha y el total de goles anotados en cada partido (goles_local + goles_visitante) con el alias TOTAL_GOLES, ordenados de mayor a menor.
SELECT id_partido, fecha, goles_local + goles_visitante AS TOTAL_GOLES
FROM partido
ORDER BY TOTAL_GOLES DESC;

-- EJERCICIO 24: Muestra el nombre de cada equipo y el total de goles como local.
SELECT e.nombre AS EQUIPO, SUM(p.goles_local) AS GOLES_LOCAL
FROM equipo e
         JOIN partido p ON e.id_equipo = p.equipo_local
GROUP BY EQUIPO;

-- EJERCICIO 25: Muestra el nombre de cada jugador, su posición, su nacionalidad y el nombre del equipo en el que juega actualmente.
SELECT j.nombre AS JUGADOR, j.posicion, j.nacionalidad, e.nombre AS EQUIPO
FROM jugador j
         JOIN equipo e ON j.id_equipo = e.id_equipo;

-- EJERCICIO 26: Muestra, para cada partido, la fecha, el nombre del equipo local, el nombre del equipo visitante y el nombre del estadio donde se disputó.
SELECT p.id_partido, p.fecha, el.nombre AS EQUIPO_LOCAL, ev.nombre AS EQUIPO_VISITANTE, es.nombre AS ESTADIO
FROM partido p
         JOIN equipo el ON p.equipo_local = el.id_equipo
         JOIN equipo ev ON p.equipo_visitante = ev.id_equipo
         JOIN estadio es ON es.id_estadio = p.id_estadio;

-- EJERCICIO 27: Muestra el nombre del jugador, la descripción de la lesión y la fecha de inicio de todas las lesiones, ordenadas de más recientes a más antiguas.
SELECT j.nombre AS JUGADOR, l.descripcion, l.fecha_inicio
FROM jugador j
         JOIN lesion l ON j.id_jugador = l.id_jugador
ORDER BY l.fecha_inicio DESC;


-- EJERCICIO 28: Muestra el nombre del jugador y la descripción de todas las sanciones que estén actualmente activas (fecha_fin sea NULL).
SELECT j.nombre AS JUGADOR, s.descripcion, s.fecha_fin
FROM jugador j
         JOIN sancion s ON j.id_jugador = s.id_jugador
WHERE s.fecha_fin IS NULL;

-- EJERCICIO 29: Muestra el nombre del jugador, el nombre del equipo de origen, el nombre del equipo de destino, la fecha de la transferencia y el coste de todas las transferencias registradas.
SELECT DISTINCT j.nombre AS JUGADOR, eo.nombre AS EQ_ORIGEN, ed.nombre AS EQ_DESTINO, t.fecha_transferencia, t.coste_transferencia
FROM jugador j
         JOIN transferencia t ON j.id_jugador = t.id_jugador
         JOIN equipo eo ON eo.id_equipo = t.id_equipo_origen
         JOIN equipo ed ON ed.id_equipo = t.id_equipo_destino;

-- EJERCICIO EXTRA (jueguicos.sql): Muestra el título y el nombre de los géneros principal y secundario de todos los juegos
SELECT j.titulo, gp.nombre_genero AS G_PRINCIPAL, gs.nombre_genero as G_SECUNDARIO
FROM juego j
         JOIN genero gp ON gp.id_genero = j.id_genero1
         JOIN genero gs ON gs.id_genero = j.id_genero2;

-- EJERCICIO 30: Muestra el nombre de cada equipo y cuántas transferencias ha realizado como equipo de origen, ordenando de mayor a menor número de transferencias y después por nombre del equipo.
SELECT e.nombre AS EQUIPO, COUNT(t.id_transferencia) AS NUM_TRANSFERENCIAS
FROM equipo e
         JOIN transferencia t ON e.id_equipo = t.id_equipo_origen
GROUP BY e.nombre
ORDER BY NUM_TRANSFERENCIAS DESC, e.nombre ASC;

-- EJERCICIO 31: Muestra el nombre de los equipos que tienen al menos un jugador que haya más de 10 lesiones
SELECT e.nombre AS EQUIPO, COUNT(l.id_lesion) AS NUM_LESIONES
FROM equipo e
         JOIN jugador j ON j.id_equipo = e.id_equipo
         JOIN lesion l ON l.id_jugador = j.id_jugador
GROUP BY e.nombre
HAVING NUM_LESIONES > 10;

SELECT e.nombre AS EQUIPO, COUNT(l.id_lesion) AS NUM_LESIONES
FROM equipo e
         JOIN jugador j ON j.id_equipo = e.id_equipo
         JOIN lesion l ON l.id_jugador = j.id_jugador
GROUP BY e.nombre;

-- EJERCICIO 32: Muestra el nombre del capitán y el nombre de cada jugador al que capitanea, usando la relación reflexiva de la tabla jugador.
SELECT j.nombre AS JUGADOR, c.nombre AS CAPITAN
FROM jugador j
         JOIN jugador c ON j.id_capitan = c.id_jugador;

-- EJERCICIO 33: Muestra el nombre de todos los jugadores que no han sufrido ninguna lesión, usando un LEFT JOIN entre jugador y lesion.
SELECT j.nombre, l.id_lesion
FROM jugador j
         LEFT JOIN lesion l ON j.id_jugador = l.id_jugador
WHERE l.id_jugador IS NULL;

-- EJERCICIO 34: Muestra el nombre de todos los jugadores que no han recibido ninguna sanción.
SELECT j.nombre AS JUGADOR, s.id_sancion
FROM jugador j
         LEFT JOIN sancion s ON j.id_jugador = s.id_jugador
WHERE s.id_sancion IS NULL;

-- EJERCICIO 35: Muestra el nombre y la nacionalidad de los entrenadores que no tienen equipo asignado.
SELECT nombre, nacionalidad, id_equipo
FROM entrenador
WHERE id_equipo IS NULL;

-- EXTRA: Muestra el nombre de los equipos y de cada uno de sus jugadores (tengan o no) que no tienen un entrenador asociado
SELECT e.nombre AS EQUIPO, j.nombre AS JUGADOR, en.id_entrenador
FROM equipo e
         LEFT JOIN entrenador en ON e.id_equipo = en.id_equipo
         LEFT JOIN jugador j ON e.id_equipo = j.id_equipo
WHERE en.id_entrenador IS NULL;

-- EJERCICIO 36: Muestra el id y la fecha de todos los partidos que no tienen estadio asignado.
SELECT p.id_partido, p.fecha, e.id_estadio
FROM partido p
         LEFT JOIN estadio e ON p.id_estadio = e.id_estadio
WHERE e.id_estadio IS NULL;

SELECT id_partido, fecha, id_estadio
FROM partido
WHERE id_estadio IS NULL;

-- EJERCICIO 37: Muestra el nombre de cada equipo y cuántos partidos ha jugado como local.
SELECT e.nombre AS EQUIPO, COUNT(p.id_partido) AS PARTIDOS_LOCAL
FROM equipo e
         JOIN partido p ON e.id_equipo = p.equipo_local
GROUP BY EQUIPO;

-- EJERCICIO 38: Muestra cuántos partidos se han jugado en cada año, usando la función YEAR sobre la fecha del partido.
SELECT COUNT(id_partido) AS PARTIDOS_JUGADOS, YEAR(fecha) AS AÑO
FROM partido
GROUP BY AÑO;

-- EJERCICIO 39: Muestra cuántos partidos se han jugado en cada mes del año 2023.
SELECT COUNT(id_partido) AS PARTIDOS_JUGADOS, MONTH(fecha) AS MES, YEAR(fecha) AS AÑO
FROM partido
WHERE YEAR(fecha) = 2023
GROUP BY MES;

-- EJERCICIO 40: Muestra la descripción y la fecha de inicio de todas las lesiones que hayan comenzado en el año 2023.
SELECT descripcion, fecha_inicio
FROM lesion
WHERE YEAR(fecha_inicio) >= 2023;

-- EJERCICIO 41: Muestra el nombre del jugador y la descripción de las sanciones que estuvieran activas el día '2023-09-15'. Una sanción está activa si la fecha de inicio es anterior o igual a esa fecha y la fecha de fin es posterior o igual o NULL.
SELECT j.nombre AS JUGADOR, s.descripcion, s.fecha_inicio, s.fecha_fin
FROM jugador j
         JOIN sancion s ON j.id_jugador = s.id_jugador
WHERE s.fecha_inicio <= '2023-09-15' AND (s.fecha_fin >= '2023-09-15' OR s.fecha_fin IS NULL);

-- EJERCICIO 42: Muestra el nombre y los goles de los 5 jugadores que más goles hayan marcado, ordenados de mayor a menor número de goles.
SELECT nombre, goles
FROM jugador
ORDER BY goles DESC
LIMIT 5;

-- EJERCICIO 43: Muestra el nombre y la edad de los 3 jugadores más jóvenes de la base de datos.
SELECT nombre, edad
FROM jugador
ORDER BY edad ASC
LIMIT 3;

-- EJERCICIO 44: Muestra el nombre de los 5 equipos con más victorias, ordenados de mayor a menor número de victorias.
SELECT nombre, victorias
FROM equipo
ORDER BY victorias DESC
LIMIT 5;

-- EJERCICIO 45: Muestra el id del partido, la fecha y el total de goles (goles_local + goles_visitante) de los 10 partidos con más goles anotados.
SELECT id_partido, fecha, SUM(goles_local + goles_visitante) AS TOTAL_GOLES
FROM partido
GROUP BY id_partido
ORDER BY TOTAL_GOLES DESC
LIMIT 10;

SELECT id_partido, fecha, (goles_local + goles_visitante) AS TOTAL_GOLES
FROM partido
ORDER BY TOTAL_GOLES DESC
LIMIT 10;

-- EJERCICIO 46: Muestra el nombre de cada equipo y el nombre de las ligas en las que participa.
SELECT e.nombre AS EQUIPO, l.nombre AS LIGA
FROM equipo e
         JOIN participacion p ON p.id_equipo = e.id_equipo
         JOIN liga l ON l.id_liga = p.id_liga
ORDER BY e.nombre;

-- EJERCICIO 47: Muestra el nombre de cada liga y cuántos equipos participan en ella, ordenados de mayor a menor número de equipos.
SELECT l.nombre AS LIGA, COUNT(e.id_equipo) AS NUM_EQUIPOS
FROM liga l
         JOIN participacion p ON p.id_liga = l.id_liga
         JOIN equipo e ON e.id_equipo = p.id_equipo
GROUP BY LIGA
ORDER BY NUM_EQUIPOS DESC;

-- EJERCICIO 48: Muestra la ciudad y la capacidad media de los estadios en cada ciudad, usando la función AVG sobre la capacidad.
SELECT ciudad, AVG(capacidad) AS CAPACIDAD_MEDIA
FROM estadio
GROUP BY ciudad;

-- EJERCICIO 49: Muestra la nacionalidad y cuántos entrenadores hay de cada nacionalidad, ordenados de mayor a menor número de entrenadores.
SELECT nacionalidad, COUNT(id_entrenador) AS NUM_ENTRENADORES
FROM entrenador
GROUP BY nacionalidad
ORDER BY NUM_ENTRENADORES DESC;

-- EJERCICIO 50: Muestra el nombre de cada jugador y cuántas lesiones tiene registradas (incluyendo a los que no tengan ninguna).
SELECT j.nombre, COUNT(l.id_lesion) AS NUM_LESIONES
FROM jugador j
         LEFT JOIN lesion l ON j.id_jugador = l.id_jugador
GROUP BY j.id_jugador;