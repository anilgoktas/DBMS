<?php

require_once("includes/header.php");

if($_GET[name]) {
	$stid = oci_parse($connection, 'select * from '.$_GET[name]);
	oci_execute($stid);

	$resultArray = array();

	while (($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
    	array_push($resultArray, $row);
	}

	echo json_encode($resultArray);
}

require_once("includes/footer.php");

?>