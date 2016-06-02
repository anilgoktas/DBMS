/*add artists*/

BEGIN
  insertArtist('Rihanna', '20.02.1988');
  insertArtist('David Guetta', '07.11.1967');
  insertArtist('Micheal Jackson', '29.08.1958');
  insertArtist('Sia', '18.12.1975');
  insertArtist('Adele', '05.05.1988');
  insertArtist('Madonna', '16.08.1958');
  insertArtist('Beyonce', '04.09.1981');
  insertArtist('Bruno Mars', '08.10.1985');
  insertArtist('Calvin Harris', '17.01.1984');
  insertArtist('Tiesto', '17.01.1969');
END;

/*add songs*/

BEGIN
  insertSong('Smooth Criminal', '8');
  insertSong('Hello','7');
  insertSong('Diamonds','8');
  insertSong('Titanium','9');
  insertSong('Bad','8');
  insertSong('Grenade','8');
  insertSong('Wasted','8');
  insertSong('I need your love','8');
END;

/*add webuser*/

BEGIN
insertwebuser('kullanici1','1234', 0);
insertwebuser('kullanici2','5678', 0);
insertwebuser('kullanici3','1111', 0);
insertwebuser('kullanici4','2222', 0);
insertwebuser('kullanici5','9999', 0);
insertwebuser('admin', 'bbm473', 1);
END;

/* add publisher*/

BEGIN
insertpublisher('Epic',null,null);
insertpublisher('Jive',null,null);
insertpublisher('Emi',null,null);
insertpublisher('Nation',null,null);
insertpublisher('Roc',null,null);
insertpublisher('Columbia',null,null);
END;

/* add Genre */

BEGIN
  insertGenre('Pop');
  insertGenre('Rock');
  insertGenre('Elecktro');
  insertGenre('Dance');
  insertGenre('Jazz');
END;

/*Add album*/

BEGIN
insertalbum('Bad','8','1987','1');
insertalbum('Unapologetic','7','2012','1');
insertalbum('Nothing but the Beat','9','2011','1');
insertalbum('Doo-Wops & Hooligans','8','2010','2');
insertalbum('18 Months','8','2012','2');
insertalbum('Listen','10','2014','2');
insertalbum('25','7','2015','2');
insertalbum('A Town Called Paradise','6','2014','1');
END;

/* Add album has song */

BEGIN
insertalbumhassong(1, 1);
insertalbumhassong(2, 2);
insertalbumhassong(3, 3);
insertalbumhassong(4, 4);
insertalbumhassong(4, 5);
insertalbumhassong(5, 5);
insertalbumhassong(6, 6);
insertalbumhassong(7, 7);
insertalbumhassong(8, 8);
insertalbumhassong(2, 7);
insertalbumhassong(2, 4);
END;