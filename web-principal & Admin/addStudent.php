<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <title>إضافة طالب</title>
<style>

  .form-popup {
  display: none;
  position: fixed;
  bottom: 0;
  right: 15px;
  border: 3px solid #f1f1f1;
  z-index: 9;
}


.form-popup {
  position: relative;
  padding: 50px 50px;
  background: #fff;
  border-radius: 10px;
}
.form-popup h1 {
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
.form-popup .inputbox {
  position: relative;
  width: 300px;
  height: 50px;
  margin-bottom: 20px;
  
}
.form-popup .inputbox input {
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
.form-popup .inputbox:last-child {
  margin-bottom: 0;
}
.form-popup .inputbox span {
  position: absolute;
  top: 14px;
  right: 20px;
  font-size: 1em;
  transition: 0.6s;
  font-family: sans-serif;
  
}
.form-popup .inputbox input:focus ~ span,
.form-popup .inputbox input:valid ~ span {
  transform: translateX(-13px) translateY(-35px);
  font-size: 1em;
  
}
.form-popup .inputbox [type="button"] {
  width: 50%;
  background: #f1f1f1;
  color:  #555;
  border: #fff;
  text-align: center;
}
.form-popup .inputbox:hover [type="button"] {
  background: #f1f1f1;
}


/* Add styles to the form container */
.form-container {
  max-width: 300px;
  padding: 10px;
  background-color: white;
}


/* Set a style for the submit/login button */
.form-container .btn {
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

/* Add a red background color to the cancel button */
.form-container .cancel {
  border-radius: 10px;
  background-color: #4ebfc1;
}

/* Add some hover effects to buttons */
.form-container .btn:hover, .open-button:hover {
  opacity: 1;
}

</style>
<script type="module" src="addStudent.js" type="text/javascript"></script>

    
</head>

<body>

<div class="center">
  <h1>إضافة طالب</h1>
  <form onsubmit="return validateForm1();" class="add" >

  <div class="inputbox">
      <input type="text" required="required" name ="Fname" id="Fname">
      <span>الاسم الأول</span>
    </div>

    <div class="inputbox">
      <input type="text" required="required" name ="Lname" id="Lname">
      <span>الاسم  الأخير</span>
    </div>

    <div class="inputbox" ">
      <select required="true" style="  margin-top: 15px; padding: 10px; background:#ccc; border: 2px solid #000; width:40%; height: 30px; text-align:center; " id="classes" name="classes">
            <option id="non" value="" name="non">--اختر الفصل--</option>
        </select>
      <span style="border: 2px solid #000; width:40%;  text-align:center; border-radius: 10px; font-size: 1.2em; position: absolute; ">الفصل</span>
    </div>

    <div class="inputbox">
      <input type="email" required="required" name ="email" id="email" >
      <span>البريد الإلكتروني لولي الأمر</span>
      <label for="" ><br><br><br><a href="#" onclick="openForm()" class="open-button" id="open-button" style=" display: flex; justify-content: right;">ولي أمر جديد؟</a></label>
    </div>

    
    <div class="inputbox">
        <button  type="submit"  class="btn">إضافة</button>
    </div>
  </form>
</div>


<!-- Add parent form -->


<div class="form-popup" id="parentForm">
  <h1>إضافة ولي أمر</h1>

  <form  onsubmit="return validateForm2();" class="form-container">


  <div class="inputbox">
      <input type="text" required="required" name ="Fname" id="Fname">
      <span>الاسم الأول</span>
    </div>

    <div class="inputbox">
      <input type="text" required="required" name ="Lname" id="Lname">
      <span>الاسم  الأخير</span>
    </div>


    <div class="inputbox">
      <input type="email" required="required" name ="email" id="email">
      <span>البريد الإلكتروني</span>
    </div>

    <div class="inputbox">
      <input type="tel" required="required" id="phone" name="phone" >
      <span>رقم الجوال</span>
    </div>

    <div class="inputbox">
      <input type="password" required="required" id="password" name="password" ">
      <span>كلمة المرور</span>
    </div>

    <div class="inputbox">
    <button type="submit" class="btn">إضافة</button>
    <button type="button" class="btn cancel" onclick="closeForm()">اغلاق</button>
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

<!-- Add parent script -->
<script>
   
function openForm() {
  document.getElementById("parentForm").style.display = "block";
}

function closeForm() {
  document.getElementById("parentForm").style.display = "none";
}

</script>


<!-- validate -->
<script type="text/javascript">

function validateForm1() {
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


 var selectedClass = document.getElementById( "non" ).value;

 if(selectedClass == "non"){
  alert('أرجو اختيار الفصل');
  document.querySelector('.add').non.focus();}*/
/*
 var email = document.getElementById( "email" );
 var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
 if( !email.value.match(mailformat)){
  alert("You have entered an invalid email address!");
  document.querySelector('.add').email.focus();
  return false;}


 else {
   return true;
  }

 

/*
var selectedClass =  document.getElementById("classes")[ document.getElementById("classes").selectedIndex].id;
alert(selectedClass)
 if(selectedClass == "non"){
  alert("You have to select a class!");
  document.addStudent.classes.focus();
  return false;
 }

 else {
   return true;
  }
}


function validateForm2() {
  
  var fname = document.getElementById( "Fname" );
  var letters = /^[A-Za-z]+$/;
  if( !fname.value.match(letters) )
  {
   alert('first name must have alphabet characters only');
   document.querySelector('.form-container').Fname.focus();
  
   return false;
  }
 
  var lname = document.getElementById( "Lname" );
  if( !lname.value.match(letters) )
  {
   alert('last name must have alphabet characters only');
   document.querySelector('.form-container').Lname.focus();
   return false;
  }

  var email = document.getElementById( "email" );
  var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
  if( !email.value.match(mailformat)){
   alert("You have entered an invalid email address!");
   document.querySelector('.form-container').email.focus();
   return false;}
 
 
  else {
    return true;
   }

   var phoneNo =document.getElementById("phone");
   var phoneno = /^\d{10}$/;
   if((phoneNo.value.match(phoneno)))
         {
       return true;
         }
       else
         {
         alert("Enter a valid phone number");
         document.querySelector('.form-container').phone.focus();
         return false;
         }
 
 
 }*/
    </script>
</body>
</html>

