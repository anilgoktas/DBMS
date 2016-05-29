<?php
    if( !isset($_SESSION['WebUser']) ) {
        header("Location: Login.php");
    }
?>