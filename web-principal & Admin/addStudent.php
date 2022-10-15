<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/firebase/7.14.1-0/firebase.js"></script>
    <script type="module" src="addStudent.js"></script>
</head>
<body>
    <script>

function ValidateEmail(inputText)
{
var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
if(inputText.value.match(mailformat))
{
alert("Valid email address!");
document.addStudent.email.focus();

return true;
}
else
{
alert("You have entered an invalid email address!");
document.addStudent.email.focus();
return false;
}
}
</script>
    <!-- test -->

<label >Email:</label>
  <input type="text" placeholder="البريد الالكتروني" id="email" name="email"> <br>

  <input type="submit" name="submit" value="Submit" onclick="ValidateEmail(document.addStudent.email)"/>


</form>
</body>

</html>