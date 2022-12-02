const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const cors = require("cors")
const route = process.env.PORT || 3000;

const { initializeApp } = require('firebase-admin/app');

var admin = require("firebase-admin");

var serviceAccount = require("./halaqa-89b43-firebase-adminsdk-j33v0-b62f3d0f88.json");

// Intialize the firebase-admin project/account
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

app.use(cors());
var jsonParser = bodyParser.json()

app.get("/status", (req, res) => {
    res.send("ckeck Status");
});


// Add user
app.post('/addUser', jsonParser, async (req, res) => {
    const userData = req.body;
    console.log(userData);

    getAuth()
    .createUser({
      email: userData.email,
      emailVerified: true,
      password: 'secretPassword',
      disabled: false,
    })
    .then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      console.log('Successfully created new user:', userRecord.uid);
    })
    .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        if (errorMessage =="Firebase: Error (auth/email-already-exists)."){
             alert("البريد الالكتروني مستخدم من قبل");}
        else
             alert("حصل خطأ بالنظام، الرجاء المحاولة لاحقًا");
        
      console.log('Error creating new user:', error);
    });

    //reset pass (still hasent figured it out)
  /*  getAuth()
  .generatePasswordResetLink(userData.email)
  .then((link) => {
    // Construct password reset email template, embed the link and send
    // using custom SMTP server.
    return sendCustomPasswordResetEmail(userData.email, displayName, link);
  })
  .catch((error) => {
    // Some error occurred.
  });*/
  })


// Delete user
  app.post('/deleteUser', jsonParser, async (req, res) => {
    const userData = req.body;
    console.log(userData);

    getAuth()
  .deleteUser(userData.uid)
  .then(() => {
    console.log('Successfully deleted user');
  })
  .catch((error) => {
    console.log('Error deleting user:', error);
  });
  })