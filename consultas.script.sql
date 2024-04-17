USE LemonMusic; --I left some hindsight written through comments
-- Listar las pistas (tabla Track) con precio mayor o igual a 1€
SELECT T.Name, T.UnitPrice 
	FROM Track T 
	WHERE UnitPrice >= 1;
-----
-- Listar las pistas de más de 4 minutos de duración
SELECT T.Name, T.Milliseconds 
	FROM Track T 
	WHERE Milliseconds > (4*60*1000) 
	ORDER BY Milliseconds;
-----
-- Listar las pistas que tengan entre 2 y 3 minutos de duración
SELECT T.Name, T.Milliseconds 
	FROM Track T 
	WHERE Milliseconds BETWEEN (2*60*1000) AND (3*60*1000) 
	ORDER BY Milliseconds;
------
-- Listar las pistas que uno de sus compositores (columna Composer) sea Mercury
SELECT T.Name, T.Composer 
	FROM Track T 
	WHERE Composer LIKE '%Mercury%';
-------
-- Calcular la media de duración de las pistas (Track) de la plataforma
SELECT COUNT(T.Name) 'Tracks', AVG(T.Milliseconds) 'Average ms' 
	FROM Track T;
-------
-- Listar los clientes (tabla Customer) de USA, Canada y Brazil
SELECT C.FirstName, C.LastName, C.Country
	FROM Customer C WHERE Country IN ('USA', 'Canada', 'Brazil');
------------
-- Listar todas las pistas del artista 'Queen' (Artist.Name = 'Queen')
	-- Default JOIN is INNER JOIN
SELECT Ar.Name 'Artist', Al.Title 'Album title', T.Name 'Track name' 
	FROM Artist Ar 
	JOIN Album Al ON Ar.ArtistId = Al.ArtistId
	JOIN Track T ON Al.AlbumId =  T.AlbumId 
	WHERE Ar.Name = 'Queen';
-------------
-- Listar las pistas del artista 'Queen' en las que haya participado como compositor David Bowie
SELECT Ar.Name 'Artist', Al.Title 'Album title', T.Name 'Track name', T.Composer 
	FROM Artist Ar 
	JOIN Album Al ON Ar.ArtistId = Al.ArtistId
	JOIN Track T ON Al.AlbumId =  T.AlbumId 
	WHERE Ar.Name = 'Queen' AND T.Composer LIKE '%David Bowie%';
------------------
-- Listar las pistas de la playlist 'Heavy Metal Classic'
SELECT P.Name 'Playlist', T.Name 'Track'  
	FROM Playlist P 
	JOIN PlaylistTrack PT ON P.PlaylistId = PT.PlaylistId
	JOIN Track T ON PT.TrackId = T.TrackId
	WHERE P.Name LIKE 'Heavy Metal Classic';
----------------
-- Listar las playlist junto con el número de pistas que contienen
SELECT P.Name 'Playlist', COUNT(*) 'Tracks'
	FROM Playlist P 
	JOIN PlaylistTrack PT ON P.PlaylistId = PT.PlaylistId
	JOIN Track T ON PT.TrackId = T.TrackId
	GROUP BY P.Name;
------------------
-- Listar las playlist (sin repetir ninguna) que tienen alguna canción de AC/DC
	-- On this case DISTINCT is unnecesary, there are only two different findings here.
SELECT DISTINCT(P.Name) 'Playlist', Ar.Name 'Artist'
	FROM Playlist P 
	JOIN PlaylistTrack PT ON P.PlaylistId = PT.PlaylistId
	JOIN Track T ON PT.TrackId = T.TrackId
	JOIN Album Al ON T.AlbumId = Al.AlbumId
	JOIN Artist Ar ON Al.AlbumId = Ar.ArtistId 
	GROUP BY P.Name, Ar.Name HAVING Ar.Name LIKE 'AC/DC';
-----------------	
-- Listar las playlist que tienen alguna canción del artista Queen, junto con la cantidad que tienen
SELECT P.Name 'Playlist' , Ar.Name 'Artist', COUNT(*) 'Tracks'
	FROM Playlist P 
	JOIN PlaylistTrack PT ON P.PlaylistId = PT.PlaylistId
	JOIN Track T ON PT.TrackId = T.TrackId
	JOIN Album Al ON T.AlbumId = Al.AlbumId
	JOIN Artist Ar ON Al.AlbumId = Ar.ArtistId 
	GROUP BY P.Name, Ar.Name HAVING Ar.Name LIKE '%Queen%';
----------------------------------------------
-- Listar las pistas que no están en ninguna playlist
	--There are no nulls in this query below so... probably there are no songs without playlist
SELECT T.Name 'Track', T.TrackId, PT.PlaylistId  'Playlist'	
	FROM PlaylistTrack PT
	RIGHT JOIN Track T ON PT.TrackId = T.TrackId
	WHERE PT.PlaylistId IS NULL;

/*
Tested this via adding this Track:
INSERT INTO Track (TrackId, Name, UnitPrice, MediaTypeId, Milliseconds) VALUES (99999, 'Devastation and reform', 0.99, 1, 123456)

This query also helps doublecheck:
SELECT T.Name 'Track', T.TrackId, PT.TrackId 'TrackId(Playlist)', PT.PlaylistId  'Playlist'	
	FROM PlaylistTrack PT
	FULL JOIN Track T ON PT.TrackId = T.TrackId
	ORDER BY PT.TrackId; --WHERE PT.PlaylistId IS NULL;
*/
---------------------------------
-- Listar los artistas que no tienen album
SELECT Ar.Name 'Artist', Al.Title 'Album'  
	FROM Artist Ar 
	LEFT JOIN Album Al ON Ar.ArtistId = Al.ArtistId WHERE Al.Title IS NULL

/*
This query also helps double check:
SELECT Ar.Name 'Artist', Al.Title 'Album' 
	FROM Artist Ar 
	FULL JOIN Album Al ON Ar.ArtistId = Al.AlbumId; --WHERE Al.Title IS NULL
*/
-----------------------------
--Listar los artistas con el número de albums que tienen
SELECT Ar.Name 'Artist', COUNT(DISTINCT NULLIF(Al.AlbumId, '')) 'Albums' 
	FROM Artist Ar 
	LEFT JOIN Album Al ON Ar.ArtistId = Al.ArtistId
	GROUP BY Ar.Name ORDER BY 'Albums' DESC; 