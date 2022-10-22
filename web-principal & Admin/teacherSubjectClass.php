<!DOCTYPE html>
<?php
$_GET['cid'] = "aofgh2evQw8qko6jtwBs";
$cid = $_GET['cid'];
$pid = 'POTur2qxIKmSafOghaFn';
echo "<script type='module'>import { subjectTeacherForm } from './SubjectTeacher.js';
document.getElementsByTagName('body').onload = subjectTeacherForm('$cid', '$pid');
</script>";
?>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="classSubject.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>



    <title>Document</title>
</head>
<body>







<!--  For demo purpose -->
<div class="container text-center text-white">
    <div class="row pt-5">
        <div class="col-lg-8 mx-auto">
            <h1 class="display-4">مواد الفصل</h1>
            <div class="loader topTitle"></div>
                </a>
            </p>
        </div>
    </div>
</div>

<div class="container py-5">
    <div class="row">
        <div class="col-lg-7 mx-auto">
        <form class="form-inline" >
            <div class="card rounded-0 border-0 shadow">
            
                <div class="card-body p-5">
                    
                    <!--  Bootstrap table-->
                    <div class="table-responsive">
                        <table class="table" id="codexpl">
                            <thead>
                                <tr>
                                    <th scope="col" style="width:70%">المعلم/المعلمة</th>
                                    <th scope="col" style="width:70%">المادة</th>
                                    <th scope="col" style="width:70%">حذف المادة</th>
                                  
                                </tr>
                            </thead>
                            <tbody id ='content'>
                       
                        
                            </tbody>
                        </table>
                    </div>

                    <!-- Add rows button-->
                    <input type="text" id="sname" name="sname" placeholder="اسم المادة" style="width:90%" >
                    <br>
                    <button class="button-9" id="add" type="button"style="width:90%">إضافة المادة</button>
                    
                    <button class="btn btn-danger rounded-0"  type="button" id='delete'><i class="fa fa-trash"></i></button>
                </div>

            </div>
            

</form>
        </div>
    </div>
</div>
</body>
</html>

