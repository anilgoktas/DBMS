<?php

require_once("includes/header.php");

$stid = oci_parse($connection, 'select table_name from user_tables');
oci_execute($stid);

$resultArray = array();

while (($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
    array_push($resultArray, $row);
}

echo json_encode($resultArray);

require_once("includes/footer.php");

?>