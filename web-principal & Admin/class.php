<!DOCTYPE html>
<?php
$_GET['pid'] = 'POTur2qxIKmSafOghaFn';
$pid = $_GET['pid'];
echo "<script type='module'>import { addClass } from './admin.js';
document.getElementById('btn').onclick = function() {
  addClass('$pid');
}
</script>";
?>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/firebase/7.14.1-0/firebase.js"></script>
   
</head>
<body>
<div class="center">
<h1>إضافة فصل</h1>

<form  onsubmit="return validateForm();" class="addClassForm">


<div class="inputbox">
    <input type="text" required="required" name ="Cname" id="Cname">
    <span>اسم الفصل</span>
  </div>

  <div class="inputbox">
    <input type="text" required="required" name ="level" id="level">
    <span>المستوى</span>
  </div>

    <div class="inputbox">

        <button  type="submit" id="btn" class="btn" >إضافة</button> 
    </div>
  </form>
</div>

<script type="module" src="admin.js"></script> 
<!-- Add class style -->
<style>

body {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(45deg, rgb(233, 246, 247), #ccc);
  font-family: "Sansita Swashed", cursive;
}
   

.center {
  position: relative;
  padding: 50px 50px;
  background: #fff;
  border-radius: 10px;
}
.center h1 {
  font-size: 2em;
  border-right: 5px solid rgb(2, 53, 105);
  padding: 10px;
  color: #000;
  letter-spacing: 5px;
  margin-bottom: 60px;
  font-weight: bold;
  padding-left: 10px;
  text-align: right;
}
.center .inputbox {
  position: relative;
  width: 300px;
  height: 50px;
  margin-bottom: 50px;
  
}
.center .inputbox input {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  border: 2px solid #000;
  outline: none;
  background: none;
  padding: 10px;
  border-radius: 10px;
  font-size: 1.2em;
  text-align: right;
}
.center .inputbox:last-child {
  margin-bottom: 0;
}
.center .inputbox span {
  position: absolute;
  top: 14px;
  right: 20px;
  font-size: 1em;
  transition: 0.6s;
  font-family: sans-serif;
  
}
.center .inputbox input:focus ~ span,
.center .inputbox input:valid ~ span {
  transform: translateX(-13px) translateY(-35px);
  font-size: 1em;
  
}
.center .inputbox [type="button"] {
  width: 50%;
  background: #ccc;
  color: #fff;
  border: #fff;
  text-align: center;
}
.center .inputbox:hover [type="button"] {
  background: linear-gradient(45deg, rgb(198, 218, 253), #ccc);
}


/* Add some hover effects to buttons */
.center .btn:hover, .open-button:hover {
  opacity: 1;
}


/* Set a style for the submit/login button */
.center .btn {
  border-radius: 10px;
  background-color: #4ebfc1;
  color: white;
  padding: 16px 20px;
  border: none;
  cursor: pointer;
  width: 100%;
  margin-bottom:10px;
  opacity: 0.8;
}

</style>
<script>

function validateForm() {
    /*
 var fname = document.getElementById( "Fname" );
 var letters = /^[A-Za-z]+$/;
 if( !fname.value.match(letters) )
 {
  alert('first name must have alphabet characters only');
  document.querySelector('.add').Fname.focus();
 
  return false;
 }

 var lname = document.getElementById( "Lname" );
 if( !lname.value.match(letters) )
 {
  alert('last name must have alphabet characters only');
  document.querySelector('.add').Lname.focus();
  return false;
 }
*/
}
</script>
</body>

</html>