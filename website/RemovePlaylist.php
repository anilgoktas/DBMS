<?php
require_once("Includes/Config.php"); 

$idSong = $_GET[IDSONG];
$idWebUser = $_SESSION['WebUser'];

$sql = 'BEGIN deletePlaylist(:idWebUser, :idSong); END;';
$statement = oci_parse($connection, $sql);
oci_bind_by_name($statement, ":idWebUser", $idWebUser);
oci_bind_by_name($statement, ":idSong", $idSong);
oci_execute($statement);

header("location:javascript://history.go(-1)");

?>