<!DOCTYPE html>
<?php
  $cid = $_GET['c'];
  $sid = $_GET['s'];
  echo "<script type='module'>import { viewStudents } from './admin.js';
  document.getElementsByTagName('body').onload = viewStudents('$cid','$sid');</script>";
 ?>
<html lang="en">
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>table user list - Bootdey.com</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="students.css" rel="stylesheet">
	<script src="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    
</head>
<body>

<link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
<hr>
<div class="container bootstrap snippets bootdey">
<button class="button-36 topTitle" >إضافة طالب</button>
<br>
<br>
    <div class="row">
        <div class="col-lg-12">
            <div class="main-box no-header clearfix">
                <div class="main-box-body clearfix">
                    <div class="table-responsive">
                        <table class="table user-list">
                            <thead>
                                <tr>
                                <th><span>حذف </span></th>
                                <th><span>نقل طالب لفصل آخر</span></th>

                                <th><span>رقم تواصل ولي الأمر</span></th>
                                
                                <th><span>البريد الإلكتروني لولي الأمر</span></th>
                                
                                <th><span>الأسم</span></th>
                                </tr>
                            </thead>
                            <tbody id="schedule">
  
                               
                                    
                               
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="loader topTitle"></div>
        </div>
    </div>
</div>

</body>
</html>