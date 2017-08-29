<?php

require_once("includes/header.php");

// Delete methods

if (isset($_GET[methodName]) && startsWith($_GET[methodName], "delete")) {
	// Delete row of table with one id
	if (isset($_GET[id])) {
		$sql = 'BEGIN '.$_GET[methodName].'(:ID); END;';
		$stmt = oci_parse($connection, $sql);
		oci_bind_by_name($stmt, ":ID", $_GET[id], 32);
		oci_execute($stmt);
	}

	// Delete row of table with two ids
	if (isset($_GET[tableName]) && isset($_GET[firstID]) && isset($_GET[secondID])) {
		$sql = 'BEGIN '.$_GET[methodName].'(:firstID, :secondID); END;';
		$stmt = oci_parse($connection, $sql);
		oci_bind_by_name($stmt, ":firstID", $_GET[firstID]);
		oci_bind_by_name($stmt, ":secondID", $_GET[secondID]);
		oci_execute($stmt);
	}
}

require_once("includes/footer.php");

?>