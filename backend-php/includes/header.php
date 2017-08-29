<?php

function startsWith($haystack, $needle) {
    // search backwards starting from haystack length characters from the end
    return $needle === "" || strrpos($haystack, $needle, -strlen($haystack)) !== false;
}
 
$connection = oci_connect('b21027037', '21027037', 'test.czyephlunywv.eu-west-1.rds.amazonaws.com:1521/ORCL');

?>