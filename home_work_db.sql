CREATE TABLE IF NOT EXISTS Genres (
 	genre_id SERIAL PRIMARY KEY,
 	title VARCHAR(80) UNIQUE
 	);
 
CREATE TABLE IF NOT EXISTS Artists (
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS GenresArtists (
	genre_id INTEGER REFERENCES Genres(genre_id),
	artist_id INTEGER REFERENCES Artists(artist_id),
	CONSTRAINT ga_pk PRIMARY KEY (genre_id, artist_id)
);

CREATE TABLE IF NOT EXISTS Albums (
	album_id SERIAL PRIMARY KEY,
 	title VARCHAR(80) NOT NULL,
	release_year INTEGER CHECK (release_year >= 2000)
);

 CREATE TABLE IF NOT EXISTS ArtistsAlbums (
	album_id INTEGER REFERENCES Albums(album_id),
	artist_id INTEGER REFERENCES Artists(artist_id),
	CONSTRAINT aa_pk PRIMARY KEY (album_id, artist_id)
);

CREATE TABLE IF NOT EXISTS Tracks (
	track_id SERIAL PRIMARY KEY,
	title VARCHAR(80) NOT NULL,
	duration INTEGER CHECK (duration > 0),
	album_id INTEGER REFERENCES Albums(album_id)
);
 	
 CREATE TABLE IF NOT EXISTS Collections (
	collection_id SERIAL PRIMARY KEY,
 	title VARCHAR(80) NOT NULL,
	release_year INTEGER CHECK (release_year >= 2000)
 );
 	
  CREATE TABLE IF NOT EXISTS TracksCollections (
  	id SERIAL PRIMARY KEY,
	track_id INTEGER NOT NULL REFERENCES Tracks(track_id),
	collection_id INTEGER NOT NULL REFERENCES Collections(collection_id)
);


-- Задание 1

INSERT INTO Artists(name)
VALUES
	  ('NIRVANA'),
	  ('Metallica'),
	  ('Slipcnot'),
	  ('Eminem'),
	  ('50 Cent'),
	  ('2Pac'),
	  ('Lady Gaga'),
	  ('Rihanna'),
	  ('Madonna');
	 
INSERT INTO Genres(title)
VALUES 
	  ('Rap'),
	  ('Rock'),
	  ('Pop');
	 
INSERT INTO GenresArtists(artist_id, genre_id)
VALUES
	  (1, 2),
	  (2, 2),
	  (3, 2),
	  (4, 1),
	  (5, 1),
	  (6, 1),
	  (7, 3),
	  (8, 3),
	  (9, 3),
	  (8, 1),
	  (4, 2);

INSERT INTO Albums(title, release_year)
VALUES 
	  ('Show', 2002),
	  ('72 Seasons', 2023),
	  ('Anti', 2016),
	  ('We Are Not Your Kind', 2020);
	 
INSERT INTO ArtistsAlbums(album_id, artist_id)
VALUES 
	  (1, 4),
	  (2, 2),
	  (3, 8),
	  (4, 3);
	 
INSERT INTO Tracks(title, duration, album_id)
VALUES 
	  ('Desperado', 240, 3),
	  ('Work', 186, 3),
	  ('Screaming Suicide', 287, 2),
	  ('Chasing Light', 370, 2),
	  ('Cleanin Out My Closet', 215, 1),
	  ('Soldier', 257, 1),
	  ('Пройди мой путь', 170, 3),
	  ('Psychosocial', 196, 4);
	 
INSERT INTO Collections(title, release_year)
VALUES 
	  ('Hits', 2019),
	  ('Hits 1', 2020),
	  ('Hits 2', 2017),
	  ('Hits 3', 2022);

INSERT INTO TracksCollections(track_id, collection_id)
VALUES 
	  (1, 1),
	  (2, 1),
	  (3, 2),
	  (4, 2),
	  (5, 3),
	  (6, 3),
	  (1, 4),
	  (6, 4),
	  (4, 4);
	 

-- Задание 2

-- Название и продолжительность самого длительного трека.
SELECT title, duration FROM Tracks
WHERE duration = (SELECT MAX(duration) FROM tracks); 

-- Название треков, продолжительность которых не менее 3,5 минут.
SELECT title FROM Tracks
WHERE duration >= 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT title FROM Collections
WHERE release_year BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова.
SELECT name FROM Artists
WHERE name NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my».
SELECT title FROM Tracks
WHERE title LIKE '%мой%' OR title LIKE '%My%';


-- Задание 3

-- Количество исполнителей в каждом жанре.
SELECT g.title AS genre, COUNT(*) AS artist_count
FROM Genres g
JOIN GenresArtists ga ON ga.genre_id = g.genre_id
JOIN Artists a ON a.artist_id = ga.artist_id
GROUP BY g.title;

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(*) AS track_count
FROM Tracks t 
JOIN Albums a ON t.album_id = a.album_id 
WHERE a.release_year BETWEEN 2019 AND 2020;

-- Средняя продолжительность треков по каждому альбому.
SELECT a.title AS album, AVG(t.duration) AS avg_duration_tracks
FROM Tracks t 
JOIN Albums a ON t.album_id = a.album_id 
GROUP BY a.title;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT a.name AS artists
FROM Artists a 
JOIN ArtistsAlbums aa ON  aa.artist_id = a.artist_id 
JOIN Albums al ON al.album_id = aa.album_id
WHERE release_year != 2020;

-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.title AS collections
FROM Collections c 
JOIN TracksCollections tc ON tc.collection_id = c.collection_id 
JOIN Tracks t ON t.track_id = tc.track_id 
JOIN Albums a ON a.album_id  = t.album_id 
JOIN Artistsalbums aa ON aa.album_id = a.album_id 
JOIN Artists ar ON ar.artist_id = aa.artist_id 
WHERE ar.name = 'Eminem'
GROUP BY c.title;



-- Изменения

INSERT INTO Tracks(title, duration, album_id)
VALUES 
	  ('myself', 230, 3),
	  ('by myself', 195, 1),
	  ('bemy self', 137, 2),
	  ('myself by', 315, 4),
	  ('by myself by', 222, 1),
	  ('beemy', 111, 2),
	  ('premyne', 333, 3);

SELECT title
FROM Tracks
WHERE string_to_array(lower(title), ' ') && ARRAY['my', 'мой'];

SELECT a.name
FROM Artists a
WHERE a.artist_id NOT IN (
    SELECT aa.artist_id
    FROM ArtistsAlbums aa
    JOIN Albums al ON aa.album_id = al.album_id
    WHERE al.release_year = 2020
);


