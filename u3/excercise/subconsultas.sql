-- Ejercicio 1: Muestra el nombre y apellidos de los clientes cuyo país tenga más clientes registrados que el país 'USA' y que hayan realizado al menos 5 facturas.
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
WHERE
  (SELECT COUNT(*) FROM Customer c2 WHERE c2.Country = c.Country)
    > (SELECT COUNT(*) FROM Customer WHERE Country = 'Brazil')
  AND (SELECT COUNT(*) FROM Invoice i WHERE i.CustomerId = c.CustomerId) >= 5
ORDER BY c.LastName;

-- Ejercicio 2: Muestra las canciones cuyo precio sea superior al precio medio de todas las canciones de su mismo género.
SELECT g.GenreId, g.Name
FROM Genre g
WHERE g.GenreId NOT IN (
  SELECT t.GenreId
  FROM Track t
  JOIN Album a ON t.AlbumId = a.AlbumId
  JOIN Artist ar ON a.ArtistId = ar.ArtistId
  WHERE ar.Name = 'Metallica'
);

-- Ejercicio 3: Muestra las canciones cuya duración sea inferior a la duración media de algún álbum al que pertenezcan.
SELECT DISTINCT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
WHERE EXISTS (
  SELECT 1
  FROM Invoice i
  JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
  JOIN Track t ON t.TrackId = il.TrackId
  JOIN Album a ON a.AlbumId = t.AlbumId
  JOIN Artist ar ON ar.ArtistId = a.ArtistId
  WHERE i.CustomerId = c.CustomerId
    AND ar.Name = 'Queen'
);

-- Ejercicio 4: Muestra los artistas que tengan más álbumes que el artista 'AC/DC'.
SELECT t.TrackId, t.Name, t.Milliseconds, t.AlbumId
FROM Track t
WHERE t.AlbumId IS NOT NULL
  AND t.Milliseconds < (
    SELECT AVG(t2.Milliseconds)
    FROM Track t2
    WHERE t2.AlbumId = t.AlbumId
  )
ORDER BY t.AlbumId, t.Milliseconds;

-- Ejercicio 5: Muestra las canciones que sean las más largas dentro de su álbum.
SELECT a.AlbumId, a.Title, agg.track_count, agg.avg_ms
FROM Album a
JOIN (
  SELECT AlbumId, COUNT(*) AS track_count, AVG(Milliseconds) AS avg_ms
  FROM Track
  GROUP BY AlbumId
) AS agg ON a.AlbumId = agg.AlbumId
WHERE agg.avg_ms > (
  SELECT AVG(album_avg) FROM (
    SELECT AVG(Milliseconds) AS album_avg
    FROM Track
    GROUP BY AlbumId
  ) AS album_avgs
)
ORDER BY agg.avg_ms DESC;

-- Ejercicio 6: Muestra los clientes cuyo gasto total sea superior al gasto total de algún cliente del país 'Germany'.
SELECT cust.CustomerId, cust.FirstName, cust.LastName, cust_tot.total_spent
FROM (
  SELECT i.CustomerId, SUM(i.Total) AS total_spent
  FROM Invoice i
  GROUP BY i.CustomerId
) AS cust_tot
JOIN Customer cust ON cust.CustomerId = cust_tot.CustomerId
WHERE cust_tot.total_spent > (
  SELECT AVG(total_spent) FROM (
    SELECT SUM(i2.Total) AS total_spent
    FROM Invoice i2
    GROUP BY i2.CustomerId
  ) AS per_customer_totals
)
ORDER BY cust_tot.total_spent DESC;

-- Ejercicio 7: Muestra los clientes que hayan comprado más canciones que la media de canciones compradas por cliente.
UPDATE Track
SET UnitPrice = UnitPrice * 1.10
WHERE GenreId IS NOT NULL
  AND UnitPrice < (
    SELECT AVG(t2.UnitPrice)
    FROM Track t2
    WHERE t2.GenreId = Track.GenreId
  );

-- Ejercicio 8: Muestra los álbumes que tengan más canciones que todos los álbumes del artista 'Queen'.
SELECT a.AlbumId, a.Title
FROM Album a
WHERE (SELECT COUNT(*) FROM Track t WHERE t.AlbumId = a.AlbumId)
  > (SELECT MAX(album_track_count) FROM (
    SELECT COUNT(*) AS album_track_count
    FROM Album a2
    JOIN Track t2 ON t2.AlbumId = a2.AlbumId
    JOIN Artist ar2 ON ar2.ArtistId = a2.ArtistId
    WHERE ar2.Name = 'Queen'
    GROUP BY a2.AlbumId
  ) AS queen_album_counts)
ORDER BY a.Title;