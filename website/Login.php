<?php
require_once("Includes/Config.php");
include("Includes/Header.php");

if( $_GET[Error] == 1 ) {
	$Error = "The email or password you entered is incorrect.";
}
?>

<div id="main">
    <div id="LeftMenu">
        <ul>
            <li><a class="ActiveMenu">Login</a></li><br/><br/>
            <a href="Register.php">Register</a><br/>
        </ul>
    </div>

	<div id="Content">
    	<h2>User Login</h2>
        <form name="Login" action="LoginAuth.php" method="post" >
        <p>
        Email:<br/>
        <input type="text" name="Nickname" >
        </p>
        
        <p>
        Password:<br/>
        <input type="password" name="Password" >
        </p>
        
        <?php
		if($Error) { echo $Error; }
		?>
        
        <p>
        <input type = "submit" value = "Login" />
        </p>
        </form>
    </div>
</div>
        
<?php include("Includes/Footer.php"); ?>