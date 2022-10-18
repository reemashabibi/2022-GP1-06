<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <script type="module" src="addAdmin.js"></script>
    <title>إضافة إداري</title>
</head>

<body>
<div class="center">
  <h1>إضافة إداري</h1>

  <form class="addAdmin" id="modal-signup">

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
    <button  type="submit"  class="btn" id="reg-btn" >إضافة</button>
    </div>
  </form>
</div>


<script> 
/*function test(){
 Email.send({
  
                SecureToken : "fc2af1b0-d695-40c6-b4e6-7d028e798e39",
                To : "reema.fahad.a99@gmail.com",
                From : "reemafahadshabibi7@gmail.com",
                Subject : "This is the subject",
                Body : "And this is the body  username is:"+Email+" password is:"+ password+" .. thank you"
            }).then(
             // message => alert(message)
             addAdminForm.reset()
             
            );
          }
          */

</script>


</body>
</html>



