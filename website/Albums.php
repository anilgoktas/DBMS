<?php 
require_once("Includes/Config.php");
include("Includes/LoginDirection.php");
include("Includes/Header.php");
?>
  
<div id="main">
	<div id="LeftMenu">
        <ul>
        <a href="Playlist.php">Playlist</a><br/>
        <a class="ActiveMenu">Albums</a><br/>
        <a href="Artists.php">Artists</a><br/>
        <a href="Songs.php">Songs</a><br/>
        <br/><br/><br/>
        <a href=\"Logout.php\">Logout</a><br/>
        </ul>
    </div>
    
    <div id="Content">
        <h2>Albums</h2>
        <?php
        // Query albums
        $query = "SELECT A.idAlbum as IDALBUM, A.name as ALBUMNAME, A.year as ALBUMYEAR, A.rating as ALBUMRATING, P.name as PUBLISHERNAME
                    FROM Album A
                    INNER JOIN Publisher P
                    ON A.Publisher_idPublisher = P.idPublisher";
        $statement = oci_parse($connection, $query);
        oci_execute($statement);
        
        // Show albums
        echo '<table BORDER="1" CELLPADDING="10" CELLSPACING="10">';
        echo '<tr><td>ALBUM</td><td>YEAR</td><td>RATING</td><td>PUBLISHER</td><td>SONGS</td></tr>';

        while( $album = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
            echo
            '<tr> <td>', $album[ALBUMNAME], '</td><td>', $album[ALBUMYEAR], '</td>
            <td>', $album[ALBUMRATING], '</td><td>', $album[PUBLISHERNAME], '</td>
            <td>';
            // Configure for table inside table

            // Query songs
            $songsQuery = "SELECT S.idSong as IDSONG, S.name as SONGNAME, S.rating as SONGRATING
                            FROM Album A
                            INNER JOIN Album_has_Song A_S
                            ON A.idAlbum = A_S.Album_idAlbum
                            INNER JOIN Song S
                            ON A_S.Song_idSong = S.idSong
                            WHERE A.idAlbum = :IDALBUM";
            $songsStatement = oci_parse($connection, $songsQuery);
            oci_bind_by_name($songsStatement, ":IDALBUM", $album[IDALBUM]);
            oci_execute($songsStatement);

            // Show songs
            echo '<table CELLSPACING="3">';
            echo '<tr><td>SONG</td><td>RATING</td></tr>';

            while( $song = oci_fetch_array($songsStatement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
                echo
                '<tr>
                <td>', $song[SONGNAME], '</td><td>', $song[SONGRATING], '</td>
                <td><a href="InsertPlaylist.php?IDSONG=', $song[IDSONG], '">[Insert to Playlist]</a></td>
                </tr>';
            }
            echo '</table>';

            '</td></tr>';
        }
        echo '</table>';
        ?>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>