<?php 
require_once("Includes/Config.php");
include("Includes/LoginDirection.php");
if( !isset($_SESSION['Admin']) ) {
    header("Location: Playlist.php");
}
include("Includes/Header.php");
?>
  
<div id="main">
	<div id="LeftMenu">
        <ul>
        <a class="ActiveMenu">Web Users</a><br/>
        <a href="Playlist.php">Playlist</a><br/>
        <br/><br/><br/>
        <a href="Logout.php">Logout</a><br/>
        </ul>
    </div>
    
    <div id="Content">
        <h2>Web Users</h2>
        <?php
        $query = "SELECT * FROM WebUser";
        $statement = oci_parse($connection, $query);
        oci_execute($statement);
        
        // Show table
        echo '<table BORDER=1 CELLPADDING="10" CELLSPACING="10">';
        echo '<tr><td>IDWEBUSER</td><td>NICKNAME</td><td>ISADMIN</td></tr>';

        while( $webUser = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
            echo
            '<tr>
            <td>', $webUser[IDWEBUSER], '</td>
            <td>', $webUser[NICKNAME], '</td>
            <td>', $webUser[ISADMIN], '</td>
            </tr>';
        }
        echo '</table>';
        ?>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>