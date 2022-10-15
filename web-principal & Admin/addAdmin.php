<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <link rel="stylesheet" href="addAdminStyle.css" />


<title>إضافة إداري</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- Custom Theme files -->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
<!-- //Custom Theme files -->
<!-- web font -->
<link href="//fonts.googleapis.com/css?family=Roboto:300,300i,400,400i,700,700i" rel="stylesheet">
<!-- //web font -->
</head>


<body>
	<!-- main -->
	<div class="main-w3layouts wrapper">
		<h1>إضافة إداري</h1>
		<div class="main-agileinfo">
			<div class="agileits-top">
				<form action="#" method="post">

					<input class="text" type="text" name="First Name" placeholder="الاسم الأول" required="">

                    <br>
                    <br>
					<input class="text" type="text" name="Last Name" placeholder="الاسم الأخير" required="">
                    <br>

					<input class="text email" type="email" name="email" placeholder="البريد الإلكتروني" required="">

			<!--		<input class="text w3lpass" type="password" name="password" placeholder="Confirm Password" required=""> -->
					<div class="wthree-text">
						<div class="clear"> </div>
					</div>
					<input type="submit" value="إضافة">
				</form>
				
			</div>
		</div>
	
	</div>

    
<!-- randomly generated pass -->
<?php
$comb = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
$shfl = str_shuffle($comb);
$pwd = substr($shfl,0,8);
?>

</body>
</html>