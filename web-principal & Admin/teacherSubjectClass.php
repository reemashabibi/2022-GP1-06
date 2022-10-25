<!DOCTYPE html>


 <script type='module'>
 import { subjectTeacherForm } from './SubjectTeacher.js';
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
 const auth = getAuth();
 const user= auth.currentUser;
    onAuthStateChanged(auth, (user)=>{
        if(user){
            const uid=user.uid;
            var queryString = location.search.substring(1);
            var ids = queryString.split("|");
            document.getElementsByTagName('body').onload = subjectTeacherForm(ids[0], uid);
            console.log("the same user");
        }
        else{
            window.location.href="index.html";
            console.log("the  user changed");
        }
    })
</script>;

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


    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-iconic-font/2.2.0/css/material-design-iconic-font.min.css" integrity="sha256-3sPp8BkKUE7QyPSl6VfBByBroQbKxKG7tsusY2mhbVY=" crossorigin="anonymous" />
  
    <link rel="stylesheet" href="navbar.css"/>
    <script src="navbar.js"></script>

    
    <title>الصفحة الرئيسية</title>
    
</head>

<body>
        <!--start of nav -->
<nav class="navbar navbar-expand-custom navbar-mainbg">
        <a class="navbar-brand navbar-logo" href="#"><img src="navbarlogo.png" alt="logo" height="66"></a>
        <svg viewBox="0 0 512 512" width="30" title="sign-out-alt">
  <path d="M497 273L329 441c-15 15-41 4.5-41-17v-96H152c-13.3 0-24-10.7-24-24v-96c0-13.3 10.7-24 24-24h136V88c0-21.4 25.9-32 41-17l168 168c9.3 9.4 9.3 24.6 0 34zM192 436v-40c0-6.6-5.4-12-12-12H96c-17.7 0-32-14.3-32-32V160c0-17.7 14.3-32 32-32h84c6.6 0 12-5.4 12-12V76c0-6.6-5.4-12-12-12H96c-53 0-96 43-96 96v192c0 53 43 96 96 96h84c6.6 0 12-5.4 12-12z" />
</svg>
        <button class="navbar-toggler" type="button" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <i class="fas fa-bars text-white"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ml-auto">
                <div class="hori-selector"><div class="left"></div><div class="right"></div></div>
                <li class="nav-item active">
                    <a class="nav-link" href="adminHomePage.php">الصفحة الرئيسية</a>
                </li>
                <li class="nav-item ">
                    <a class="nav-link" href="students.php"> إصطحاب الطلاب</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="javascript:void(0);"></i>الإعلانات</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="javascript:void(0);">الأحداث</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="javascript:void(0);">المستندات</a>
                </li>

            </ul>
        </div>
    </nav>
    <!--end of nav -->
    <!--breadcrumb-->

    <!--end of breadcrumb-->


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
            <button class="button-9" style="width:1000%">حفظ التعديلات </button>

</form>
        </div>
    </div>
</div>
</body>
</html>

