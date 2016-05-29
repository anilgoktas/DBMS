<?php require_once("Includes/Config.php"); ?>
<?php include("Includes/Header.php"); ?>

<?php
    if( $_GET[Save] == 1 ) {
		if( !isset($_POST[Nickname]) || empty($_POST[Nickname]) || !isset($_POST[Password]) || empty($_POST[Password]) ) {
			$Error = "Please enter your information.\n";
		}
		
        // Check if nickname exists
		$nickname = $_POST[Nickname];
		$statement = oci_parse($connection, "SELECT * FROM WebUser WHERE nickname=:nickname");
        oci_bind_by_name($statement, ":nickname", $nickname);
        oci_execute($statement);

		if( $webUser = oci_fetch_array($statement, OCI_ASSOC+OCI_RETURN_NULLS) ) {
			$Error = "Someone already has that nickname. Please try another.";
		}
		
        // Save new user with nickname
		if( !isset($Error) ) {
            $password = md5($_POST[Password]);
            $isAdmin = 0;

            $sql = 'BEGIN insertWebUser(:nickname, :password, :isAdmin); END;';
            $insertStatement = oci_parse($connection, $sql);
            oci_bind_by_name($insertStatement, ":nickname", $nickname);
            oci_bind_by_name($insertStatement, ":password", $password);
            oci_bind_by_name($insertStatement, ":isAdmin", $isAdmin);
            oci_execute($insertStatement);
			
			$Success = "Your account has been created.\nGo on, create your first playlist!\n\n";
		}
	}
?>

<div id="main">
	<div id="LeftMenu">
    	<ul>
            <a href="Login.php">Login</a><br/><br/><br/>
		    <li><a class="ActiveMenu">Register</a></li><br/>
        </ul>
    </div>
    
    <div id="Content">
        <h2>Register</h2>
        <form name = "Register" action = "Register.php?Save=1" method = "post">
        <?php
		if( $Error )
			echo "<p>{$Error}</p>";
		if( $Success )
			echo "<p>{$Success}</p>";
		?>
        
        <p>
        Nickname:<br/>
        <input type = "text" name = "Nickname" />
        </p>
        
        <p>
        Password:<br/>
        <input type = "password" name = "Password" />
        </p>
        
        <p>
        <input type = "submit" value = "Submit" />
        </p>
        </form>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>