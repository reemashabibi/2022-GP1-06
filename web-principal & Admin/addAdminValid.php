<?php
//session start
//include database connenction


if(isset($_POST['rgs_btn'])){

    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $email = $_POST['email'];
   // <!-- randomly generated pass -->
    $comb = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    $shfl = str_shuffle($comb);
    $password = substr($shfl,0,8);

    



}



?>