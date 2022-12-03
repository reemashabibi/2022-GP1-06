const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const cors = require("cors")
const route = process.env.PORT || 8080;
const router = express.Router();
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
// add router in express app
app.use("/",router);

var admin = require("firebase-admin");

var serviceAccount = require("C:/Users/ree4m/Downloads/halaqa-89b43-firebase-adminsdk-j33v0-0d2cef029f.json");

// Intialize the firebase-admin project/account
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

app.use(cors());
var jsonParser = bodyParser.json()

app.get("/status", (req, res) => {
    res.send("ckeck Status");
});

router.get('/',(req, res) => {
    res.sendfile('index.html');
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
      res.json({"status": "Successfull" , "uid": userRecord.uid});
    })
    .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        if (errorMessage =="Firebase: Error (auth/email-already-exists)."){
            res.json({"status":'used'});}
        else
        res.end('error');;
        
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

  app.listen(8080,() => {
    console.log("Started on PORT 8080");
    })