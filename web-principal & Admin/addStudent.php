<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create.css">
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>

    <title>إضافة طالب</title>
    
    <script type="module" src="addStudent.js" type="text/javascript"></script>


</head>

<body>

    <div class="center">
        <h1>إضافة طالب</h1>
        
        <form  class="add" name="add">
        <h3>معلومات الطالب</h3>
        
            <div class="inputbox">
                <input type="text"  required="required" name="Fname" id="Fname">
                <span>الاسم الأول</span>
            </div>

            <div class="inputbox">
                <input type="text" required="required" name="Lname" id="Lname">
                <span>الاسم الأخير</span>
            </div>
            
            <div class="inputbox" ">
      <select required=" true"
                style="  margin-top: 15px; padding: 10px; background:#ccc; border: 2px solid #000; width:40%; height: 30px; text-align:center; "
                id="classes" name="classes">
                <option id="non" value="" name="non">--اختر الفصل--</option>
                </select>
                <span
                    style="border: 2px solid #000; width:40%;  text-align:center; border-radius: 10px; font-size: 1.2em; position: absolute; ">الفصل</span>
            </div>
            <h3>معلومات ولي أمر الطالب</h3>
           
            <div class="inputbox">
                <input type="tel" required="required" name="phone" id="phone" class="phone">
                <span>رقم الجوال</span>
            </div>


           
            <div id="parent"  class="parent">
                <h1>إضافة ولي أمر</h1>

            


            <div class="inputbox">
                    <input type="text" required="required" name="FnameParent" id="FnameParent">
                    <span>الاسم الأول</span>
                </div>
               

                

                <div class="inputbox">
                    <input type="text" required="required" name="LnameParent" id="LnameParent">
                    <span>الاسم الأخير</span>
                </div>


                <div class="inputbox">
                    <input type="email" required="required" name="email" id="emailP">
                    <span>البريد الإلكتروني</span>
                </div>



                <div class="inputbox">
                    <input type="password" required="required" id="password" name="password" ">
    <span>كلمة المرور</span>
  </div>
            </div>
 
            <div class="inputbox">
                <button  type="submit" class="btn" id="btn">إضافة</button>
            </div>
        </form>
    </div>


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