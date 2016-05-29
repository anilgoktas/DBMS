<?php 
require_once("Includes/Config.php");
include("Includes/LoginDirection.php");
include("Includes/Header.php");
?>
  
<div id="main">
	<div id="LeftMenu">
        <ul>
        <a href="Playlist.php">Playlist</a><br/>
        <a href="Albums.php">Albums</a><br/>
        <a class="ActiveMenu">Artists</a><br/>
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
        <?php
        $query = "SELECT * FROM Song";
        $statement = oci_parse($connection, $query);
        oci_execute($statement);
        
        // Show table
        echo '<table BORDER="1" CELLPADDING="10" CELLSPACING="10">';
        echo '<tr><td>SONG</td><td>RATING</td></tr>';

        while( $song = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
            echo
            '<tr>
            <td>', $song[NAME], '</td><td>', $song[RATING], '</td>
            <td><a href="InsertPlaylist.php?IDSONG=', $song[IDSONG], '">[Insert to Playlist]</a></td>
            </tr>';
        }
        echo '</table>';
        ?>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>