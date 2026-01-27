-- Ejercicio 1: Muestra el nombre, apellido, sexo y país de nacionalidad de los deportistas
-- cuya altura esté entre 175 y 190 cm INCLUSIVE y cuyo peso sea menor de 80 kg
-- o cuyo país de nacionalidad sea 'España'. Muestra los resultados ordenados alfabéticamente nombre del país, por su altura de forma descendente y por su peso de forma ascendente.
SELECT nombre, apellido, sexo, pais_nacionalidad, altura_cm, peso_kg
FROM deportista
WHERE altura_cm BETWEEN 175 AND 190
  AND (peso_kg < 80 OR pais_nacionalidad = 'España')
ORDER BY pais_nacionalidad, altura_cm DESC, peso_kg;

-- Ejercicio 2: Muestra el nombre de todos los eventos junto con el nombre de la disciplina
-- a la que pertenecen y el nombre del deporte de esa disciplina.
SELECT DISTINCT e.nombre AS evento, di.nombre AS disciplina, de.nombre AS deporte
FROM evento e
JOIN disciplina di
    ON e.id_disciplina = di.id_disciplina
JOIN deporte de
    ON di.id_deporte = de.id_deporte;

-- Ejercicio 3. Muestra el nombre completo y la fecha de nacimiento de todos los deportistas que han participado
-- en algún evento de 'tenis'. Meustra los resultaods ordenados por su fecha de nacimiento, mostrando a los deportistas más jóvenes primero.
SELECT dep.nombre, dep.apellido, dep.fecha_nacimiento, ev.nombre AS EVENTO
FROM deportista dep
         JOIN participacion p ON dep.id_deportista = p.id_deportista
         JOIN evento ev ON p.id_evento = ev.id_evento
WHERE ev.nombre LIKE '%tenis%'
ORDER BY dep.fecha_nacimiento DESC;

-- Ejercicio 4. Muestra el nombre completo y la edad (tomando como referencia su año de nacimiento únicamente) de los deportistas que tengan entre 20 y 40 años.
-- Muestra los resultados ordenados por su edad, mostrando a los deportistas más mayores primero.
SELECT nombre, apellido, (YEAR(NOW()) - YEAR(fecha_nacimiento)) AS EDAD
FROM deportista
WHERE (YEAR(NOW()) - YEAR(fecha_nacimiento)) BETWEEN 20 AND 40
ORDER BY EDAD DESC;

-- Ejercicio 5. Muestra cuántos deportistas españoles hay asociados al deporte 'Fútbol'.
SELECT COUNT(dep.id_deportista) AS NUM_FUTBOLISTAS, d.nombre AS DEPORTE, dep.pais_nacionalidad
FROM deportista dep
         JOIN participacion p ON dep.id_deportista = p.id_deportista
         JOIN evento ev ON p.id_evento = ev.id_evento
         JOIN disciplina dis ON ev.id_disciplina = ev.id_disciplina
         JOIN deporte d ON dis.id_deporte = d.id_deporte
WHERE d.nombre = 'Fútbol' AND dep.pais_nacionalidad = 'España';

-- Ejercicio 6. Muestra la ciudad anfitriona y el año de los juegos en los que más deportistas han participado.
SELECT j.ciudad_anfitriona, j.anio AS AÑO, COUNT(p.id_deportista) AS NUM_PARTICIPANTES
FROM juegos j
         JOIN participacion p ON j.id_juegos = p.id_juegos
GROUP BY j.ciudad_anfitriona
ORDER BY NUM_PARTICIPANTES DESC
LIMIT 1;

-- Ejercicio 7. Muestra, para cada país, el total de aforo y el aforo medio de todos sus estadios.
-- A continuación, muestra únicamente aquellos países cuya segunda letra sea la 'S' y cuyo aforo total sea al menos 350 000.
-- Ordena los resultados de mayor a menor aforo total.
SELECT pais, SUM(aforo) AS AFORO_TOTAL, AVG(aforo) AFORO_MEDIO
FROM estadio
WHERE pais LIKE '_S%'
GROUP BY pais
HAVING AFORO_TOTAL >= 350000
ORDER BY AFORO_TOTAL DESC;

-- Ejercicio 8. Muestra para cada evento por equipos, el nombre de su estadio principal y el nombre de su estadio secundario, de aquellos eventos que
-- tengan asociados o no, un estadio secundario
SELECT e.nombre AS evento, e.genero, ep.nombre AS ESTADIO_PRINCIPAL, es.nombre AS ESTADIO_SECUNDARIO, e.es_por_equipos AS POR_EQUIPOS
FROM evento e
         JOIN estadio ep ON e.id_estadio_principal = ep.id_estadio
         LEFT JOIN estadio es ON e.id_estadio_secundario = es.id_estadio
WHERE e.es_por_equipos = 1;

-- Ejercicio 9. Muestra el nombre completo de cada entrenador y de los deportistas a los que entrena. Incluye, además, el nombre del equipo al que pertenecen.
-- Incluye aquellos deportistas que no tienen ningún entrenador asociado ni pertenecen a ningún equipo.
SELECT ent.nombre AS N_ENTRENADOR, ent.apellido AS A_ENTRENADOR, dep.nombre AS N_DEPORTISTA, dep.apellido AS A_DEPORTISTA, eq.nombre AS EQUIPO
FROM deportista dep
         LEFT JOIN deportista ent ON ent.id_deportista = dep.id_entrenador
         LEFT JOIN deportista_equipo deq ON dep.id_deportista = deq.id_deportista
         LEFT JOIN equipo eq ON deq.id_equipo = eq.id_equipo;

-- Ejercicio 10. Muestra la ciudad anfitriona, el año que se celebró y el número de deportistas que no estaban asociados a ningún equipo,
-- ordenados de juegos más antiguos a más recientes.
SELECT j.ciudad_anfitriona, j.anio, COUNT(d.id_deportista) AS DEPORTISTAS_SIN_EQUIPO
FROM juegos j
         JOIN participacion p ON j.id_juegos = p.id_juegos
         JOIN deportista d ON p.id_deportista = d.id_deportista
         LEFT JOIN deportista_equipo deq ON d.id_deportista = deq.id_deportista
WHERE deq.id_deportista IS NULL
GROUP BY j.ciudad_anfitriona
ORDER BY j.anio;

-- Ejercicio 11. Muestra, para cada deportista que actúa como entrenador, su nombre completo, nacionalidad, el número de deportistas de sexo femenino ('F') que entrena
-- que entrenen al menos 2 deportistas
SELECT CONCAT(en.nombre, ' ', en.apellido) AS ENTRENADOR, en.pais_nacionalidad, COUNT(dep.id_deportista) AS DEPORTISTAS_ENTRENADOS
FROM deportista dep
         JOIN deportista en ON dep.id_entrenador = en.id_deportista
WHERE dep.sexo = 'F'
GROUP BY ENTRENADOR
HAVING DEPORTISTAS_ENTRENADOS >= 2;

-- Ejercicio 12. Muestra los deportistas que han participado en eventos cuyo género (Masculino/Femenino) no coincide con su sexo registrado.
SELECT DISTINCT d.nombre, d.apellido, d.sexo, e.genero AS genero_evento
FROM deportista d
         JOIN participacion p ON d.id_deportista = p.id_deportista
         JOIN evento e ON p.id_evento = e.id_evento
WHERE (d.sexo = 'M' AND e.genero = 'Femenino') OR (d.sexo = 'F' AND e.genero = 'Masculino');



