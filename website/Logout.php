<?php
require_once("Includes/Config.php"); 

session_destroy();
header("Location: Login.php");
?>