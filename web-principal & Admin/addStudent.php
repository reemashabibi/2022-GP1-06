<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
<script type="module" src="addStudent.js" type="text/javascript"></script>

    <title>إضافة طالب</title>
</head>

<body>

<div class="center">
  <h1>إضافة طالب</h1>
  <form class="add">

  <div class="inputbox">
      <input id="Fname" type="text" required="required">
      <span>الاسم الأول</span>
    </div>

    <div class="inputbox">
      <input id="Lname" type="text" required="required">
      <span>الاسم  الأخير</span>
    </div>

    <div class="inputbox" ">
      <select style="  margin-top: 15px; padding: 10px; background:#ccc; border: 2px solid #000; width:40%; height: 30px; text-align:center; " id="class" name="class" required>
            <option id="nonID" value="non"></option>
        </select>
      <span style="border: 2px solid #000; width:40%;  text-align:center; border-radius: 10px; font-size: 1.2em; position: absolute; ">الفصل</span>
    </div>

    <div class="inputbox">
      <input type="text" required>
      <span>البريد الإلكتروني لولي الأمر</span>
      <label for="" ><br><br><br><a href="#" onclick="openForm()" class="open-button" style=" display: flex; justify-content: right;">ولي أمر جديد</a></label>
    </div>

    
    <div class="inputbox">
        <button>إضافة</button>
     
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



