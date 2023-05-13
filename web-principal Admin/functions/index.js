const functions = require("firebase-functions");

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const cors = require("cors")
const router = express.Router();


const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');


var admin = require("firebase-admin");

// Intialize the firebase-admin project/account
admin.initializeApp();


app.use(cors({ origin: '*' }));

// add router in express app
app.use("/",router);
var jsonParser = bodyParser.json()

app.get("/status", (req, res) => {
    res.send("ckeck Status");
});

router.get('/',(req, res) => {
    res.sendfile('index.html');
    });

    // Parse URL-encoded bodies (as sent by HTML forms)
app.use(express.urlencoded({
    extended: true
}));

// Parse JSON bodies (as sent by API clients)
app.use(express.json());

// Add user
app.post('/addUser', async (req, res) => {

    const userData = req.body;
    console.log(userData);

    if(typeof userData.email === "string" && userData.email.trim() !== ""){
    getAuth()

    ////changes:
    .createUser({
      email: userData.email,
      password: userData.pass,
      disabled: false,
    })
    .then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      console.log('Successfully created new user:', userRecord.uid);
      res.json({"status": "Successfull" , "uid": userRecord.uid});
     
    })
    .catch((error) => {
        console.log(error.code);
        const errorCode = error.code;
        const errorMessage = error.message;
        if (errorCode =="auth/email-already-exists"){
            res.json({"status":'used'});}
        else
        res.json({"status":'error'});
        
      console.log('Error creating new user:', error);
    });
  }
  else{
    res.json({"status":'error'});
    
  }
  })



   ///Update user
 app.post('/updateUser', async (req, res) => {
  const userData = req.body;
  console.log(userData);
  getAuth()
  .updateUser(userData.uid, {
    email: userData.email,
    //password: userData.pass, ??
    disabled: false,
  })
  .then((userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log('Successfully updated user');
    res.json({"status": "Successfull" })
  })
  .catch((error) => {
    console.log(error.code);
    const errorCode = error.code;
    const errorMessage = error.message;
    if (errorCode =="auth/email-already-exists"){
        res.json({"status":'used'});}
    else
    res.end('error');

    console.log('Error updating user:', error);
  });

});

//update password
app.post('/updateUserPass', async (req, res) => {
  const userData = req.body;
  console.log(userData);
  getAuth()
  .updateUser(userData.uid, {
    email: userData.email,
    password: userData.pass, 
  })
  .then((userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log('Successfully updated user');
    res.json({"status": "Successfull" })
  })
  .catch((error) => {
    console.log(error.code);
    const errorCode = error.code;
    const errorMessage = error.message;
    if (errorCode =="auth/email-already-exists"){
        res.json({"status":'used'});}
    else
    res.end('error');
    console.log('Error updating user:', error);
  });
});

// Delete user
  app.post('/deleteUser',  async (req, res) => {
    const userData = req.body;
    console.log(userData);
    getAuth()
  .deleteUser(userData.uid)
  .then(() => {
    console.log('Successfully deleted user');
    res.send({"status": "Successfull" })
  })
  .catch((error) => {
    console.log('Error deleting user:', error);
    res.end(error);
  });
  })
////the notfications

// These registration tokens come from the client FCM SDKs.

//absence notification
app.post('/absence',  async (req, res) => {
  console.log(req.body.token);
const registrationTokens = req.body.token;

const message = {
  notification: {
    title: 'غياب',
    body: ' نفيدكم بأنه تم احتساب غياب ابنكم/ابنتكم '+req.body.studentName
  },
    token: registrationTokens,
    data: {
      type: 'absence~'+req.body.stuRef,
    }
};


admin.messaging().send(message)
  .then((response) => {
    res.json({"status":'used'});
      // Response is a message ID string.
      console.log('Successfully sent message:', response);
  
  }).catch((error) => {
    console.log('Error sending message:', error);
  });
})

//event notification 
app.post('/event',  async (req, res) => {

const registrationTokens = req.body.token;

const message = {
  notification: {
    title: 'حدث جديد',
    body: req.body.eventName
  },
    tokens: registrationTokens,
    data: {
      type: 'event',
    }
};


admin.messaging().sendMulticast(message)
  .then((response) => {
    res.json({"status":'used'});
      // Response is a message ID string.
      console.log('Successfully sent message:', response);
  
  }).catch((error) => {
    console.log('Error sending message:', error);
  });
})
//update event
app.post('/eventUpdate',  async (req, res) => {

  const registrationTokens = req.body.token;
  
  const message = {
    notification: {
      title: 'تحديث حدث',
      body: req.body.eventName
    },
      tokens: registrationTokens,
      data: {
        type: 'event',
      }
  };
  
  
  admin.messaging().sendMulticast(message)
    .then((response) => {
      res.json({"status":'used'});
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    
    }).catch((error) => {
      console.log('Error sending message:', error);
    });
  })
//////////////////

//new document
app.post('/document',  async (req, res) => {

  const registrationTokens = req.body.token;
  
  const message = {
    notification: {
      title: 'مستند جديد',
      body: req.body.documentName,
    },
      token: registrationTokens,
      data: {
        type: 'document~'+req.body.classes,
      }
  };
  
  
  admin.messaging().send(message)
    .then((response) => {
      res.json({"status":'used'});
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    
    }).catch((error) => {
      console.log('Error sending message:', error);
    });
  })

    //update document
  app.post('/documentUpdate',  async (req, res) => {

    const registrationTokens = req.body.token;
    
    const message = {
      notification: {
        title: 'تحديث مستند',
        body: req.body.documentName,
      },
        token: registrationTokens,
        data: {
          type: 'document~'+req.body.classes,
        }
    };
    
    
    admin.messaging().send(message)
      .then((response) => {
        res.json({"status":'used'});
          // Response is a message ID string.
          console.log('Successfully sent message:', response);
      
      }).catch((error) => {
        console.log('Error sending message:', error);
      });
    })

////////////////////////

//new announcment 
app.post('/announcment',  async (req, res) => {

  const registrationTokens = req.body.token;
  
  const message = {
    notification: {
      title: ' اعلان '+ req.body.announcementTitle,
      body: req.body.announcementContent,
    },
      token: registrationTokens,
      data: {
        type: 'announcment',
      }
  };
  
  
  admin.messaging().send(message)
    .then((response) => {
      res.json({"status":'used'});
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    
    }).catch((error) => {
      console.log('Error sending message:', error);
    });
  })
///////////////////////////////////

  // send chat 
  app.post('/chat',  async (req, res) => {

    const registrationTokens = req.body.token;
    
    const message = {
      notification: {
        title: req.body.name,
        body: req.body.content,
      },
        token: registrationTokens,
        data: {
          type: 'chat~'+req.body.data,
        }
    };
    
    
    admin.messaging().send(message)
      .then((response) => {
        res.json({"status":'used'});
          // Response is a message ID string.
          console.log('Successfully sent message:', response);
      
      }).catch((error) => {
        console.log('Error sending message:', error);
      });
    })

    exports.method = functions.runWith({
      invoker: "public",  
    }).https.onRequest(app);