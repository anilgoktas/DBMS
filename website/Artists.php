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
        $query = "SELECT * FROM Artist";
        $statement = oci_parse($connection, $query);
        oci_execute($statement);
        
        // Show table
        echo '<table BORDER="1" CELLPADDING="10" CELLSPACING="10">';
        echo '<tr><td>ARTIST</td><td>BIRTH DATE</td></tr>';

        while( $artist = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
            echo
            '<tr>
            <td>', $artist[NAME], '</td><td>', $artist[BIRTHDATE], '</td>
            </tr>';
        }
        echo '</table>';
        ?>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>