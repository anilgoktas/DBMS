		<div id="Footer"></div>
    </div>
	</body>
</html>
<?php
	if( isset($connection) ) {
		oci_close($connection);
	}
?>