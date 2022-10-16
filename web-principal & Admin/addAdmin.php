<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <title>إضافة إداري</title>
    <!-- add database connection + session -->
</head>

<body>
<div class="center">
  <h1>إضافة إداري</h1>

  <form action="addAdminValid.php" method="POST" onsubmit="return validate();">

  <div class="inputbox">
      <input type="text" required="required" name ="firstName" id="firstName">
      <span>الاسم الأول</span>
    </div>

    <div class="inputbox">
      <input type="text" required="required" name ="lastName" id="lastName">
      <span>الاسم  الأخير</span>
    </div>


    <div class="inputbox">
      <input type="email" required="required" name ="email" id="email">
      <span>البريد الإلكتروني</span>
    </div>


    <div class="inputbox">
      <input type="button" value="إضافة" name="rgs_btn" >
    </div>
  </form>
</div>


<!-- validate -->
<script type="text/javascript">
function validate() {
 var fname = document.getElementById( "firstName" );
 var letters = /^[A-Za-z]+$/;
 if( !fname.value.match(letters) )
 {
  alert('first name must have alphabet characters only');
  document.addAdmin.firstName.focus();
  return false;
 }

 var lname = document.getElementById( "lastName" );
 if( !lname.value.match(letters) )
 {
  alert('last name must have alphabet characters only');
  document.addAdmin.lastName.focus();
  return false;
 }

 var email = document.getElementById( "email" );
 var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
 if( !email.value.match(mailformat)){
  alert("You have entered an invalid email address!");
  document.addAdmin.email.focus();
  return false;
 }

 else {
   return true;
  }
}
</script>


</body>
</html>



