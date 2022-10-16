<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
<script src="less.js" type="text/javascript"></script>

    <title>إضافة إداري</title>
</head>

<body>

<div class="center">
  <h1>إضافة إداري</h1>
  <form >

  <div class="inputbox">
      <input type="text" required="required">
      <span>الاسم الأول</span>
    </div>

    <div class="inputbox">
      <input type="text" required="required">
      <span>الاسم  الأخير</span>
    </div>


    <div class="inputbox">
      <input type="text" required="required">
      <span>البريد الإلكتروني</span>
    </div>


    <div class="inputbox">
      <input type="button" value="إضافة">
    </div>
  </form>
</div>

<!-- randomly generated pass -->
<?php
$comb = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
$shfl = str_shuffle($comb);
$pwd = substr($shfl,0,8);
?>

<!-- sending email -->


</body>
</html>



