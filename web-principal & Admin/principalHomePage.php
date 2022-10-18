<!DOCTYPE html>
<?php
$_GET['pid'] = "POTur2qxIKmSafOghaFn";
$pid = $_GET['pid'];
echo "<script type='module'>import { callAdmins } from './principal.js';
document.getElementsByTagName('body').onload = callAdmins('$pid');</script>";
?>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="module" src="principal.js"></script>

    
    <title>الصفحة الرئيسية</title>
    
</head>

<body id="pBody">
<div class="sidebar">
  <a class="active" href="#principalHomePage.php">الصفحة الرئيسية</a>
  <a href="addAdmin.php">إضافة إداري</a>
  <a href="editPrincipal.html">معلومات الحساب</a>
  <a id="signoutlinl">تسجيل الخروج</a>
</div>
<div class="container">
            <div class="row">
                 <div class="col-lg-10 mx-auto mb-4">
                    <div class="section-title text-center ">
                    <h3 class="topTitle">قائمة الإداريين</h3>

                        <button class="button-36 topTitle" onclick="location.href='addAdmin.php'"  >إضافة إداري</button>
                       
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <div class="career-search mb-60">

                        
                        <div class="filter-result" id="bigdiv">




                        </div>
                    </div>


                </div>
            </div>

        </div>


        <link rel="stylesheet" href="principalStyle.css"/>
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-iconic-font/2.2.0/css/material-design-iconic-font.min.css" integrity="sha256-3sPp8BkKUE7QyPSl6VfBByBroQbKxKG7tsusY2mhbVY=" crossorigin="anonymous" />
   
</body>
</html>