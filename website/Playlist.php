<?php 
require_once("Includes/Config.php");
include("Includes/LoginDirection.php");
include("Includes/Header.php");
?>
  
<div id="main">
	<div id="LeftMenu">
        <ul>
        <a class="ActiveMenu">Playlist</a><br/>
        <a href="Albums.php">Albums</a><br/>
        <a href="Artists.php">Artists</a><br/>
        <a href="Songs.php">Songs</a><br/>
        <br/><br/><br/>
        <a href="Logout.php">Logout</a><br/>
        <?php
        if( isset($_SESSION['Admin'])) {
            echo '<li><a href="WebUsers.php">WebUsers</a></li><br/>';
        }
        ?>
        </ul>
    </div>
    
    <div id="Content">
        <h2>Playlist</h2>
        <?php
        $query = "SELECT S.IDSONG as IDSONG, S.NAME as SONGNAME, S.rating as SONGRATING, A.NAME as ALBUMNAME FROM Playlist P
                    INNER JOIN Song S
                    ON S.IDSONG = P.SONG_IDSONG
                    INNER JOIN Album_has_Song A_S
                    ON A_S.SONG_IDSONG = s.IDSONG
                    INNER JOIN Album A
                    ON A.IDALBUM = A_S.ALBUM_IDALBUM
                    WHERE P.WEBUSER_IDWEBUSER = :idWebUser";
        $statement = oci_parse($connection, $query);
        oci_bind_by_name($statement, ":idWebUser", $_SESSION[WebUser]);
        oci_execute($statement);
        
        // Show table
        echo '<table BORDER="1" CELLPADDING="10" CELLSPACING="10">';
        echo '<tr><td>Song</td><td>Rating</td><td>Album</td></tr>';

        while( $playlist = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
            echo
            '<tr>
            <td>', $playlist[SONGNAME], '</td><td>', $playlist[SONGRATING], '</td><td>', $playlist[ALBUMNAME], '</td>
            <td><a href="RemovePlaylist.php?IDSONG=', $playlist[IDSONG], '">[Remove]</a></td>
            </tr>';
        }
        echo '</table>';
        ?>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>