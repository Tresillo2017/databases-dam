-- Muestra el nombre de usuario y el total de visualizaciones del usuario que haya visto mas contenido (pelis+episodios) sin usar limit
SELECT u.nombre_usuario,
       COUNT(v.id_visualizacion) AS total_views
FROM usuario u
JOIN visualizacion v ON u.id_usuario = v.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM visualizacion
    GROUP BY id_usuario
);

-- Mostrar los nombres de los actores que hayan participado en mas series que algun otro actor.
SELECT a.nombre, COUNT(DISTINCT r.id_serie) AS total_series
FROM actor a
JOIN reparto r on a.id_actor = r.id_actor
WHERE r.id_serie IS NOT NULL
GROUP BY a.nombre
HAVING COUNT(DISTINCT r.id_serie) > ANY (
    SELECT COUNT(DISTINCT r2.id_serie)
    FROM reparto r2
    WHERE r2.id_serie IS NOT NULL
    GROUP BY r2.id_actor
);

-- Muestra el título, idioma original y recaudación de las películas cuya recaudación sea superior a la recaudación media de las películas de su mismo idioma original. Ordena por recaudación descendente.
SELECT p.titulo, p.idioma_original, p.recaudacion
FROM pelicula p
WHERE p.recaudacion > (
    SELECT AVG(p2.recaudacion)
    FROM pelicula p2
    WHERE p2.idioma_original = p.idioma_original
    )
ORDER BY p.recaudacion DESC;


-- “Mostrar las películas cuya recaudación sea superior a la película más taquillera (recaudación máxima) de cualquier otro idioma original.”
SELECT p.titulo, p.idioma_original, p.recaudacion
FROM pelicula p
WHERE p.recaudacion > ALL(
    SELECT MAX(p2.recaudacion)
    FROM pelicula p2
    WHERE p2.idioma_original != p.idioma_original
    GROUP BY p2.idioma_original
    );

-- “Mostrar el título, presupuesto, recaudación y margen absoluto de las películas con mayor margen de beneficio, entendiendo margen como recaudacion − presupuesto. Si hay empate, se muestran todas.”
SELECT p.titulo, p.presupuesto, p.recaudacion, (p.recaudacion - p.presupuesto) AS margen_beneficio
FROM pelicula p
WHERE p.recaudacion IS NOT NULL
  AND (p.recaudacion - p.presupuesto) >= ALL (
      SELECT (p2.recaudacion - p2.presupuesto)
      FROM pelicula p2
      WHERE p2.recaudacion IS NOT NULL
)

-- “Mostrar el nombre y el país de los actores cuyo país esté entre aquellos países que tienen al menos 3 actores distintos en la base de datos.”
SELECT a.nombre, a.pais
FROM actor a
WHERE a.pais IN (
    SELECT a2.pais
    FROM actor a2
    GROUP BY a2.pais
    HAVING COUNT(a2.id_actor) >= 3
    );