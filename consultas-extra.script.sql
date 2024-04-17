USE LemonMusic;
SELECT T.Name 'Track', COUNT(*) 'Times in a playlist' 
	FROM Track T 
	JOIN PlaylistTrack PT ON T.TrackId = PT.TrackId 
	GROUP BY T.Name 
	ORDER BY 'Times in a playlist' DESC;
----------------
SELECT T.Name 'Track', ISNULL(SUM(IL.Quantity),0) 'Amount sold' 
	FROM InvoiceLine IL 
	FULL JOIN Track T ON IL.TrackId = T.TrackId
	GROUP BY T.Name
	ORDER BY 'Amount sold' DESC;
------------
SELECT Ar.Name 'Artist', ISNULL(SUM(IL.Quantity),0)'Tracks sold'
FROM Artist Ar 
	JOIN Album Al ON Ar.ArtistId = Al.ArtistId 
	JOIN Track T ON Al.AlbumId = T.AlbumId
	JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
	GROUP BY Ar.Name ORDER BY 'Tracks sold' DESC;

	/* Useful to make sure the right amount was selected on the last two queries:
SELECT Ar.Name 'Artist', T.Name, IL.Quantity 'Tracks sold'
	FROM Artist Ar 
	JOIN Album Al ON Ar.ArtistId = Al.ArtistId 
	JOIN Track T ON Al.AlbumId = T.AlbumId
	JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
	ORDER BY T.Name;*/
------------------
SELECT T.Name 'Track', ISNULL(SUM(IL.Quantity),0) as 'Amount sold'
FROM Track T
	LEFT JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
	GROUP BY T.Name 
	HAVING ISNULL(SUM(IL.Quantity),0) = 0;
-----------
SELECT Ar.Name 'Artist', ISNULL(SUM(IL.Quantity),0) as 'Tracks sold'
FROM Artist Ar 
	LEFT JOIN Album Al ON Ar.ArtistId = Al.ArtistId 
	LEFT JOIN Track T ON Al.AlbumId = T.AlbumId
	LEFT JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
	GROUP BY Ar.Name 
	HAVING ISNULL(SUM(IL.Quantity),0) = 0;