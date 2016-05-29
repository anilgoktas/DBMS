/*
// Drop Tables

DROP TABLE SONG_HAS_GENRE;
DROP TABLE ARTIST_SINGS_SONG;
DROP TABLE ARTIST_HAS_GENRE;
DROP TABLE ARTIST_HAS_ALBUM;
DROP TABLE ALBUM_HAS_SONG;
DROP TABLE ALBUM;
DROP TABLE PLAYLIST;
DROP TABLE WEBUSER_HAS_FAVORITE_GENRE;
DROP TABLE WEBUSER_HAS_FAVORITE_ARTIST;
DROP TABLE ARTIST;
DROP TABLE GENRE;
DROP TABLE PUBLISHER;
DROP TABLE SONG;
DROP TABLE WEBUSER;
*/

/* - Create tables */

CREATE TABLE Artist (
  idArtist int PRIMARY KEY NOT NULL,
  name VARCHAR(45) NOT NULL,
  birthDate VARCHAR(45) NOT NULL
);

CREATE TABLE Genre (
  idGenre int PRIMARY KEY NOT NULL,
  name VARCHAR(45) NOT NULL
);

CREATE TABLE Publisher (
  idPublisher int PRIMARY KEY NOT NULL,
  name VARCHAR(45) NOT NULL,
  address VARCHAR(45),
  telephone VARCHAR(45)
);

CREATE TABLE Song (
  idSong int PRIMARY KEY NOT NULL,
  name VARCHAR(45) NOT NULL,
  rating int NOT NULL
);

CREATE TABLE WebUser (
  idWebUser int PRIMARY KEY NOT NULL,
  nickname VARCHAR(45) NOT NULL,
  password VARCHAR(255) NOT NULL,
  isAdmin int NOT NULL
);

CREATE TABLE Album (
  idAlbum int PRIMARY KEY NOT NULL,
  name VARCHAR(45) NOT NULL,
  rating int NOT NULL,
  year int NOT NULL,
  Publisher_idPublisher int NOT NULL,
  FOREIGN KEY (Publisher_idPublisher) REFERENCES Publisher(idPublisher) ON DELETE CASCADE
);

/* - Create relationship tables */

CREATE TABLE Album_has_Song (
  Album_idAlbum INT NOT NULL,
  Song_idSong INT NOT NULL,
  FOREIGN KEY (Album_idAlbum) REFERENCES Album(idAlbum) ON DELETE CASCADE,
  FOREIGN KEY (Song_idSong) REFERENCES Song(idSong) ON DELETE CASCADE
);

CREATE TABLE Artist_has_Album (
  Artist_idArtist INT NOT NULL,
  Album_idAlbum INT NOT NULL,
  FOREIGN KEY (Artist_idArtist) REFERENCES Artist(idArtist) ON DELETE CASCADE,
  FOREIGN KEY (Album_idAlbum) REFERENCES Album(idAlbum) ON DELETE CASCADE
);

CREATE TABLE Artist_has_Genre (
  Artist_idArtist INT NOT NULL,
  Genre_idGenre INT NOT NULL,
  FOREIGN KEY (Artist_idArtist) REFERENCES Artist(idArtist) ON DELETE CASCADE,
  FOREIGN KEY (Genre_idGenre) REFERENCES Genre(idGenre) ON DELETE CASCADE
);

CREATE TABLE Artist_sings_Song (
  Artist_idArtist INT NOT NULL,
  Song_idSong INT NOT NULL,
  FOREIGN KEY (Artist_idArtist) REFERENCES Artist(idArtist) ON DELETE CASCADE,
  FOREIGN KEY (Song_idSong) REFERENCES Song(idSong) ON DELETE CASCADE
);

CREATE TABLE Playlist (
  WebUser_idWebUser int NOT NULL,
  Song_idSong int NOT NULL,
  FOREIGN KEY (WebUser_idWebUser) REFERENCES WebUser(idWebUser) ON DELETE CASCADE,
  FOREIGN KEY (Song_idSong) REFERENCES Song(idSong) ON DELETE CASCADE
);

CREATE TABLE Song_has_Genre (
  Song_idSong INT NOT NULL,
  Genre_idGenre INT NOT NULL,
  FOREIGN KEY (Song_idSong) REFERENCES Song(idSong) ON DELETE CASCADE,
  FOREIGN KEY (Genre_idGenre) REFERENCES Genre(idGenre) ON DELETE CASCADE
);

CREATE TABLE WebUser_has_favorite_Artist (
  WebUser_idWebUser INT NOT NULL,
  Artist_idArtist INT NOT NULL,
  FOREIGN KEY (WebUser_idWebUser) REFERENCES WebUser(idWebUser) ON DELETE CASCADE,
  FOREIGN KEY (Artist_idArtist) REFERENCES Artist(idArtist) ON DELETE CASCADE
);

CREATE TABLE WebUser_has_favorite_Genre (
  WebUser_idWebUser INT NOT NULL,
  Genre_idGenre INT NOT NULL,
  FOREIGN KEY (WebUser_idWebUser) REFERENCES WebUser(idWebUser) ON DELETE CASCADE,
  FOREIGN KEY (Genre_idGenre) REFERENCES Genre(idGenre) ON DELETE CASCADE
);

/* - Create sequences and triggers */

CREATE SEQUENCE artistSequence START WITH 1;
CREATE OR REPLACE TRIGGER idArtistTrigger
BEFORE INSERT ON Artist
FOR EACH ROW
  BEGIN
    SELECT artistSequence.nextval
    INTO :new.idArtist
    FROM dual;
  END;
ALTER TRIGGER idArtistTrigger ENABLE;

CREATE SEQUENCE genreSequence START WITH 1;
CREATE OR REPLACE TRIGGER idGenreTrigger
BEFORE INSERT ON Genre
FOR EACH ROW
  BEGIN
    SELECT genreSequence.nextval
    INTO :new.idGenre
    FROM dual;
  END;
ALTER TRIGGER idGenreTrigger ENABLE;

CREATE SEQUENCE publisherSequence START WITH 1;
CREATE OR REPLACE TRIGGER idPublisherTrigger
BEFORE INSERT ON Publisher
FOR EACH ROW
  BEGIN
    SELECT publisherSequence.nextval
    INTO :new.idPublisher
    FROM dual;
  END;
ALTER TRIGGER idPublisherTrigger ENABLE;

CREATE SEQUENCE songSequence START WITH 1;
CREATE OR REPLACE TRIGGER idSongTrigger
BEFORE INSERT ON Song
FOR EACH ROW
  BEGIN
    SELECT songSequence.nextval
    INTO :new.idSong
    FROM dual;
  END;
ALTER TRIGGER idSongTrigger ENABLE;

CREATE SEQUENCE WebUserSequence START WITH 1;
CREATE OR REPLACE TRIGGER idWebUserTrigger
BEFORE INSERT ON WebUser
FOR EACH ROW
  BEGIN
    SELECT WebUserSequence.nextval
    INTO :new.idWebUser
    FROM dual;
  END;
ALTER TRIGGER idWebUserTrigger ENABLE;

CREATE SEQUENCE albumSequence START WITH 1;
CREATE OR REPLACE TRIGGER idAlbumTrigger
BEFORE INSERT ON Album
FOR EACH ROW
  BEGIN
    SELECT albumSequence.nextval
    INTO :new.idAlbum
    FROM dual;
  END;
ALTER TRIGGER idAlbumTrigger ENABLE;

/* - Procedures */

/* Artist */

CREATE OR REPLACE PROCEDURE insertArtist (
  name IN Artist.name%TYPE,
  birthDate IN Artist.birthDate%TYPE )
IS
  BEGIN
    INSERT INTO Artist (name, birthDate)
    VALUES (name, birthDate);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updateArtist (
  id IN Artist.idArtist%TYPE,
  name IN Artist.name%TYPE,
  birthDate IN Artist.birthDate%TYPE )
IS
  BEGIN
    UPDATE Artist
    SET NAME=name, BIRTHDATE=birthDate
    WHERE idArtist = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteArtist (
  id IN Artist.idArtist%TYPE )
IS
  BEGIN
    DELETE FROM Artist
    WHERE idArtist = id;
    COMMIT;
  END;

/* Genre */

CREATE OR REPLACE PROCEDURE insertGenre (
  name IN Genre.name%TYPE)
IS
  BEGIN
    INSERT INTO Genre (name)
    VALUES (name);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updateGenre (
  id IN Genre.idGenre%TYPE,
  name IN Genre.name%TYPE )
IS
  BEGIN
    UPDATE Genre
    SET NAME=name
    WHERE idGenre = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteGenre (
  id IN Genre.idGenre%TYPE )
IS
  BEGIN
    DELETE FROM Genre
    WHERE idGenre = id;
    COMMIT;
  END;

/* Publisher */

CREATE OR REPLACE PROCEDURE insertPublisher (
  name IN Publisher.name%TYPE,
  address IN Publisher.address%TYPE,
  telephone IN Publisher.telephone%TYPE )
IS
  BEGIN
    INSERT INTO Publisher (name, address, telephone)
    VALUES (name, address, telephone);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updatePublisher (
  id IN Publisher.idPublisher%TYPE,
  name IN Publisher.name%TYPE,
  address IN Publisher.address%TYPE,
  telephone IN Publisher.telephone%TYPE )
IS
  BEGIN
    UPDATE Publisher
    SET NAME=name, ADDRESS=address, TELEPHONE=telephone
    WHERE idPublisher = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deletePublisher (
  id IN Publisher.idPublisher%TYPE )
IS
  BEGIN
    DELETE FROM Publisher
    WHERE idPublisher = id;
    COMMIT;
  END;

/* Song */

CREATE OR REPLACE PROCEDURE insertSong (
  name IN Song.name%TYPE,
  rating IN Song.rating%TYPE )
IS
  BEGIN
    INSERT INTO Song (name, rating)
    VALUES (name, rating);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updateSong (
  id IN Song.idSong%TYPE,
  name IN Song.name%TYPE,
  rating IN Song.rating%TYPE )
IS
  BEGIN
    UPDATE Song
    SET NAME=name, RATING=rating
    WHERE idSong = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteSong (
  id IN Song.idSong%TYPE )
IS
  BEGIN
    DELETE FROM Song
    WHERE idSong = id;
    COMMIT;
  END;

/* WebUser */

CREATE OR REPLACE PROCEDURE insertWebUser (
  nickname IN WebUser.nickname%TYPE,
  password IN WebUser.password%TYPE,
  isAdmin IN WebUser.isAdmin%TYPE)
IS
  BEGIN
    INSERT INTO WebUser (nickname, password, isAdmin)
    VALUES (nickname, password, isAdmin);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updateWebUser (
  id IN WebUser.idWebUser%TYPE,
  nickname IN WebUser.nickname%TYPE,
  password IN WebUser.password%TYPE )
IS
  BEGIN
    UPDATE WebUser
    SET NICKNAME=nickname, PASSWORD=password
    WHERE idWebUser = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteWebUser (
  id IN WebUser.idWebUser%TYPE )
IS
  BEGIN
    DELETE FROM WebUser
    WHERE idWebUser = id;
    COMMIT;
  END;

/* Album */

CREATE OR REPLACE PROCEDURE insertAlbum (
  name IN Album.name%TYPE,
  rating IN Album.rating%TYPE,
  year IN Album.year%TYPE,
  Publisher_idPublisher IN Album.Publisher_idPublisher%TYPE )
IS
  BEGIN
    INSERT INTO Album (name, rating, year, Publisher_idPublisher)
    VALUES (name, rating, year, Publisher_idPublisher);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE updateAlbum (
  id IN Album.idAlbum%TYPE,
  name IN Album.name%TYPE,
  rating IN Album.rating%TYPE,
  year IN Album.year%TYPE,
  idPublisher IN Album.Publisher_idPublisher%TYPE )
IS
  BEGIN
    UPDATE Album
    SET NAME=name, RATING=rating, YEAR=year, PUBLISHER_IDPUBLISHER = idPublisher
    WHERE idAlbum = id;
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteAlbum (
  id IN Album.idAlbum%TYPE )
IS
  BEGIN
    DELETE FROM Album
    WHERE idAlbum = id;
    COMMIT;
  END;

/* Album_has_Song */

CREATE OR REPLACE PROCEDURE insertAlbumHasSong (
  Album_idAlbum IN Album_has_Song.Album_idAlbum%TYPE,
  Song_idSong IN Album_has_Song.Song_idSong%TYPE )
IS
  BEGIN
    INSERT INTO Album_has_Song (Album_idAlbum, Song_idSong)
    VALUES (Album_idAlbum, Song_idSong);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteAlbumHasSong (
  idAlbum IN Album_has_Song.Album_idAlbum%TYPE,
  idSong IN Album_has_Song.Song_idSong%TYPE )
IS
  BEGIN
    DELETE FROM Album_has_Song
    WHERE ALBUM_IDALBUM = idAlbum AND SONG_IDSONG = idSong;
    COMMIT;
  END;

/* Artist_has_Album */

CREATE OR REPLACE PROCEDURE insertArtistHasAlbum (
  Artist_idArtist IN Artist_has_Album.Artist_idArtist%TYPE,
  Album_idAlbum IN Artist_has_Album.Album_idAlbum%TYPE )
IS
  BEGIN
    INSERT INTO Artist_has_Album (Artist_idArtist, Album_idAlbum)
    VALUES (Artist_idArtist, Album_idAlbum);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteArtistHasAlbum (
  idArtist IN Artist_has_Album.Artist_idArtist%TYPE,
  idAlbum IN Artist_has_Album.Album_idAlbum%TYPE )
IS
  BEGIN
    DELETE FROM Artist_has_Album
    WHERE ARTIST_IDARTIST = idArtist AND ALBUM_IDALBUM = idAlbum;
    COMMIT;
  END;

/* Artist_has_Genre */

CREATE OR REPLACE PROCEDURE insertArtistHasGenre (
  Artist_idArtist IN Artist_has_Genre.Artist_idArtist%TYPE,
  Genre_idGenre IN Artist_has_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    INSERT INTO Artist_has_Genre (Artist_idArtist, Genre_idGenre)
    VALUES (Artist_idArtist, Genre_idGenre);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteArtistHasGenre (
  idArtist IN Artist_has_Genre.Artist_idArtist%TYPE,
  idGenre IN Artist_has_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    DELETE FROM Artist_has_Genre
    WHERE ARTIST_IDARTIST = idArtist AND GENRE_IDGENRE = idGenre;
    COMMIT;
  END;

/* Artist_sings_Song */

CREATE OR REPLACE PROCEDURE insertArtistSingsSong (
  Artist_idArtist IN Artist_sings_Song.Artist_idArtist%TYPE,
  Song_idSong IN Artist_sings_Song.Song_idSong%TYPE )
IS
  BEGIN
    INSERT INTO Artist_sings_Song (Artist_idArtist, Song_idSong)
    VALUES (Artist_idArtist, Song_idSong);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteArtistSingsSong (
  idArtist IN Artist_sings_Song.Artist_idArtist%TYPE,
  idSong IN Artist_sings_Song.Song_idSong%TYPE )
IS
  BEGIN
    DELETE FROM Artist_sings_Song
    WHERE ARTIST_IDARTIST = idArtist AND SONG_IDSONG = idSong;
    COMMIT;
  END;

/* Playlist */

CREATE OR REPLACE PROCEDURE insertPlaylist (
  WebUser_idWebUser IN Playlist.WebUser_idWebUser%TYPE,
  Song_idSong IN Playlist.Song_idSong%TYPE )
IS
  BEGIN
    INSERT INTO Playlist (WebUser_idWebUser, Song_idSong)
    VALUES (WebUser_idWebUser, Song_idSong);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deletePlaylist (
  idWebUser IN Playlist.WebUser_idWebUser%TYPE,
  idSong IN Playlist.Song_idSong%TYPE )
IS
  BEGIN
    DELETE FROM Playlist
    WHERE WEBUSER_IDWEBUSER = idWebUser AND SONG_IDSONG = idSong;
    COMMIT;
  END;

/* Song_has_Genre */

CREATE OR REPLACE PROCEDURE insertSongHasGenre (
  Song_idSong IN Song_has_Genre.Song_idSong%TYPE,
  Genre_idGenre IN Song_has_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    INSERT INTO Song_has_Genre (Song_idSong, Genre_idGenre)
    VALUES (Song_idSong, Genre_idGenre);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteSongHasGenre (
  idSong IN Song_has_Genre.Song_idSong%TYPE,
  idGenre IN Song_has_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    DELETE FROM Song_has_Genre
    WHERE SONG_IDSONG = idSong AND GENRE_IDGENRE = idGenre;
    COMMIT;
  END;

/* WebUser_has_favorite_Artist */

CREATE OR REPLACE PROCEDURE insertWebUserHasFavoriteArtist (
  WebUser_idWebUser IN WebUser_has_favorite_Artist.WebUser_idWebUser%TYPE,
  Artist_idArtist IN WebUser_has_favorite_Artist.Artist_idArtist%TYPE )
IS
  BEGIN
    INSERT INTO WebUser_has_favorite_Artist (WebUser_idWebUser, Artist_idArtist)
    VALUES (WebUser_idWebUser, Artist_idArtist);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteWebUserHasFavoriteArtist (
  idWebUser IN WebUser_has_favorite_Artist.WebUser_idWebUser%TYPE,
  idArtist IN WebUser_has_favorite_Artist.Artist_idArtist%TYPE )
IS
  BEGIN
    DELETE FROM WebUser_has_favorite_Artist
    WHERE WEBUSER_IDWEBUSER = idWebUser AND ARTIST_IDARTIST = idArtist;
    COMMIT;
  END;

/* WebUser_has_favorite_Genre */

CREATE OR REPLACE PROCEDURE insertWebUserHasFavoriteGenre (
  WebUser_idWebUser IN WebUser_has_favorite_Genre.WebUser_idWebUser%TYPE,
  Genre_idGenre IN WebUser_has_favorite_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    INSERT INTO WebUser_has_favorite_Genre (WebUser_idWebUser, Genre_idGenre)
    VALUES (WebUser_idWebUser, Genre_idGenre);
    COMMIT;
  END;

CREATE OR REPLACE PROCEDURE deleteWebUserHasFavoriteGenre (
  idWebUser IN WebUser_has_favorite_Genre.WebUser_idWebUser%TYPE,
  idGenre IN WebUser_has_favorite_Genre.Genre_idGenre%TYPE )
IS
  BEGIN
    DELETE FROM WebUser_has_favorite_Genre
    WHERE WEBUSER_IDWEBUSER = idWebUser AND GENRE_IDGENRE = idGenre;
    COMMIT;
  END;