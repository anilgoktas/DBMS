<?php
require_once("Includes/Config.php"); 

$nickname = $_POST[Nickname];
$password = $_POST[Password];

$md5Password = md5($password);

$statement = oci_parse($connection, 'SELECT * FROM WebUser WHERE nickname=:nickname AND password=:password');
oci_bind_by_name($statement, ":nickname", $nickname);
oci_bind_by_name($statement, ":password", $md5Password);
oci_execute($statement);

if( !($webUser = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS)) ) {
	// Invalid nickname/password
	header("Location: Login.php?Error=1");
} else if ( $webUser[ISADMIN] == 1 ) {
	// Admin access
	$_SESSION['Admin'] = $webUser[IDWEBUSER];
	$_SESSION['WebUser'] = $webUser[IDWEBUSER];
	header("Location: WebUsers.php");
} else {
	// Web user access
	$_SESSION['WebUser'] = $webUser[IDWEBUSER];
	header("Location: Playlist.php");
}

?>