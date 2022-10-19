<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <script type="module" src="addTeacher.js"></script>
    <title>إضافة معلم</title>
</head>

<body>
<div class="center">
  <h1>إضافة معلم</h1>

  <form class="addTeacher" id="modal-signup">

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

