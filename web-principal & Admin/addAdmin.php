<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <script type="module" src="addAdmin.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script type="text/javascript" src="https://unpkg.com/xlsx@0.15.1/dist/xlsx.full.min.js"></script>
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


</body>
</html>



