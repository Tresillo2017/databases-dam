-- Muestra el id y nombre de usuario que haya visto más PELÍCULAS (solo visualizaciones con id_pelicula no nulo), sin usar LIMIT, usando al menos una subconsulta.
SELECT v.id_usuario, u.nombre_usuario
FROM visualizacion v
JOIN usuario u ON v.id_usuario = u.id_usuario
WHERE v.id_pelicula IS NOT NULL
GROUP BY v.id_usuario, u.nombre_usuario
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM visualizacion v2
    WHERE v2.id_pelicula IS NOT NULL
    GROUP BY v2.id_usuario
);

-- Muestra los nombres de los actores que hayan participado en más películas que algún otro actor.
SELECT a.nombre
FROM actor a
JOIN reparto r ON a.id_actor = r.id_actor
WHERE r.id_pelicula IS NOT NULL
GROUP BY r.id_actor, a.nombre
HAVING COUNT(*) > ANY (
    SELECT COUNT(*)
    FROM reparto r2
    WHERE r2.id_pelicula IS NOT NULL
    GROUP BY r2.id_actor
)

-- Muestra el título, el género principal y la recaudación de las películas cuya recaudación sea superior a la recaudación media de las películas de su mismo género principal. Ordena por recaudación desc.
SELECT p.titulo, g.nombre AS genero_principal, p.recaudacion
FROM pelicula p
JOIN genero g ON g.id_genero = p.id_genero_principal
WHERE p.recaudacion > (
    SELECT AVG(p2.recaudacion)
    FROM pelicula p2
    WHERE p2.id_genero_principal = p.id_genero_principal
)
ORDER BY p.recaudacion DESC;

-- Mostrar las películas cuya recaudación sea superior a la película más taquillera de cualquier otro género principal.
SELECT p.titulo, p.recaudacion
FROM pelicula p
WHERE p.recaudacion > ALL (
    SELECT MAX(p2.recaudacion)
    FROM pelicula p2
    WHERE p2.id_genero_principal != p.id_genero_principal
    GROUP BY p2.id_genero_principal
);

-- Mostrar los títulos de las series que tengan menos temporadas que al menos una serie de su mismo género principal.
SELECT s.titulo
FROM serie s
WHERE s.numero_temporadas < ANY (
    SELECT s2.numero_temporadas
    FROM serie s2
    WHERE s.id_genero_principal = s2.id_genero_principal
);

-- Muestra el id y nombre de usuario que haya visto más episodios (visualizaciones con id_episodio no nulo) que cualquier otro, sin usar LIMIT, usando una subconsulta con ALL.”
SELECT v.id_usuario, u.nombre_usuario, COUNT(*) AS total_episodios
FROM visualizacion v
JOIN usuario u ON v.id_usuario = u.id_usuario
WHERE v.id_episodio IS NOT NULL
GROUP BY v.id_usuario, u.nombre_usuario
HAVING COUNT(*) >= ALL (
    SELECT COUNT(v2.id_episodio)
    FROM visualizacion v2
    WHERE v2.id_episodio IS NOT NULL
    GROUP BY v2.id_usuario
);

-- Muestra título, género principal y recaudación de las películas que sean las más taquilleras dentro de su género principal (puede haber empates), usando subconsulta correlacionada.
SELECT p.titulo, g.nombre AS genero_principal, p.recaudacion
FROM pelicula p
JOIN genero g ON g.id_genero = p.id_genero_principal
WHERE p.recaudacion = (
    SELECT MAX(p2.recaudacion)
    FROM pelicula p2
    WHERE p2.id_genero_principal = p.id_genero_principal
);

-- Muestra el título, el año de estreno y el presupuesto de las películas más caras de cada año. Ordénalas del año más reciente al más antiguo.
SELECT p.titulo, YEAR(p.fecha_estreno) AS anio, p.presupuesto
FROM pelicula p
WHERE p.presupuesto = (
    SELECT MAX(p2.presupuesto)
    FROM pelicula p2
    WHERE YEAR(p2.fecha_estreno) = YEAR(p.fecha_estreno)
)
ORDER BY YEAR(p.fecha_estreno) DESC;

-- Muestra el país o países que tengan más actores que hayan participado en películas cuyo idioma original sea distinto al país de nacimiento del actor.
SELECT a.pais, COUNT(DISTINCT a.id_actor) AS actores_extranjeros
FROM actor a
JOIN reparto r ON r.id_actor = a.id_actor
JOIN pelicula p ON p.id_pelicula = r.id_pelicula
WHERE p.idioma_original <> a.pais
GROUP BY a.pais
HAVING COUNT(DISTINCT a.id_actor) >= ALL (
    SELECT COUNT(DISTINCT a2.id_actor)
    FROM actor a2
    JOIN reparto r2 ON r2.id_actor = a2.id_actor
    JOIN pelicula p2 ON p2.id_pelicula = r2.id_pelicula
    WHERE p2.idioma_original <> a2.pais
    GROUP BY a2.pais
);

-- Muestra el idioma original y el total de visualizaciones de episodios para aquellos idiomas de series cuya suma de visualizaciones sea mayor que la suma de visualizaciones de las series en Español.
SELECT s.idioma_original, COUNT(v.id_visualizacion) AS total_visualizaciones
FROM serie s
JOIN episodio e ON e.id_serie = s.id_serie
JOIN visualizacion v ON v.id_episodio = e.id_episodio
GROUP BY s.idioma_original
HAVING COUNT(v.id_visualizacion) > (
    SELECT COUNT(v2.id_visualizacion)
    FROM serie s2
    JOIN episodio e2 ON e2.id_serie = s2.id_serie
    JOIN visualizacion v2 ON v2.id_episodio = e2.id_episodio
    WHERE s2.idioma_original = 'Español'
);

-- Mostrar el nombre de los actores cuya cantidad de participaciones en películas con mismo país que su país de nacimiento sea menor que la cantidad de participaciones en películas cuyo idioma original es distinto a su país.
SELECT a.nombre
FROM actor a
WHERE (
    SELECT COUNT(*)
    FROM reparto r
    JOIN pelicula p ON p.id_pelicula = r.id_pelicula
    WHERE r.id_actor = a.id_actor
      AND p.idioma_original = a.pais
) < (
    SELECT COUNT(*)
    FROM reparto r
    JOIN pelicula p ON p.id_pelicula = r.id_pelicula
    WHERE r.id_actor = a.id_actor
      AND p.idioma_original <> a.pais
);

-- Mostrar el título y la recaudación de las películas cuya recaudación sea superior a la recaudación media de todas las películas (no por género, sino global). Ordena por recaudación de mayor a menor.
SELECT p.titulo, p.recaudacion
FROM pelicula p
WHERE p.recaudacion > (
    SELECT AVG(p2.recaudacion)
    FROM pelicula p2
)
ORDER BY p.recaudacion DESC;