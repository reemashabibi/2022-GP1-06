
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword , onAuthStateChanged , sendEmailVerification , updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail

} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
//
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc, getDoc, collectionGroup } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import {  setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { doc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";


const firebaseConfig = {
    apiKey: "AIzaSyAk1XvudFS302cnbhPpnIka94st5nA23ZE",
    authDomain: "halaqa-89b43.firebaseapp.com",
    projectId: "halaqa-89b43",
    storageBucket: "halaqa-89b43.appspot.com",
    messagingSenderId: "969971486820",
    appId: "1:969971486820:web:40cc0abf19a909cc470f71",
    measurementId: "G-PCYTHJF1SD"
  };

  const app = initializeApp(firebaseConfig);
  const db = getFirestore(app);
  const app2 = initializeApp(firebaseConfig,"Secondary");

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

  const colRef = collection(db, 'School');
  const auth = getAuth(app);
  const authSec = getAuth(app2);


//Add class
let uid;
let email;
let authPrin = getAuth();

onAuthStateChanged(authPrin, (user) => {
    if (user) {
      // User is signed in, see docs for a list of available properties
      // https://firebase.google.com/docs/reference/js/firebase.User
        uid = user.uid;
        email = user.email
        
    } else {
      // User is signed out
      // ...
    }
  });
   
 

  let schoolID  ="";

  //randomly generated pass
  function pass(){
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
            var string_length = 8;
            var pass = '';
            for (var i=0; i<string_length; i++) {
                var rnum = Math.floor(Math.random() * chars.length);
                pass += chars.substring(rnum,rnum+1);
            }
        return pass;
    }

        //validate form
        function validate() {
          var fname = document.getElementById( "firstName" );
          if( fname.value == "" )
          {
           alert('يجب أن لا يكون الحقل المطلوب فارغًا');
           document.addAdmin.firstName.focus();
           return false;
          }
         
          var lname = document.getElementById( "lastName" );
          if( lname.value == "" )
          {
            alert('يجب أن لا يكون الحقل المطلوب فارغًا');
           document.addAdmin.lastName.focus();
           return false;
          }
         
          var email = document.getElementById( "email" );
          var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
          if( !email.value.match(mailformat)){
           alert("الرجاء إدخال بريد إلكتروني صحيح");
           document.addAdmin.email.focus();
           return false;
          }
         
          else {
            return true;
           }
         }
         
         const addTeacherForm = document.querySelector('.addTeacher')
         addTeacherForm.addEventListener('submit',  async (e) => {
         e.preventDefault()
        // alert(email);
         const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email", "==" , email )));
        // alert("!$$!"); //true
         snapshot.forEach(async doc => {
          // alert("!!");
           const data = await getDoc(doc.ref.parent.parent);
           schoolID = data.id;
         //  alert(schoolID);
           // alert("in");
          }) 
           if (validate()) {
             // alert("in2");
             // alert("triggerd");
             const registerFname = document.getElementById("firstName").value;
             const registerlname = document.getElementById("lastName").value;
             const registerEmail = document.getElementById("email").value;
             const registerPass = pass();
             createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
               .then(async (userCredential) => {
                 // Signed in 
                 let user = userCredential.user;
                 //send an email to reset password
                 sendPasswordResetEmail(authSec, registerEmail).then(() => {
                   // EmailSent
                 });
                 let userID =  user.uid;
                 setDoc(doc(db, 'School/'+schoolID+'/Teacher', user.uid), {
                     Email: registerEmail,
                     FirstName: registerFname,
                     LastName: registerlname,
                     Subjects: [],               
                   })
                // alert(" after ");
                 alert("تمت الإضافة بنجاح");
                 addTeacherForm.reset();

               })
               .catch((error) => {
                 const errorCode = error.code;
                 const errorMessage = error.message;
                 if (errorMessage == "Firebase: Error (auth/email-already-in-use).") {
                   alert("البريد الالكتروني مستخدم من قبل");
                 }
                 else
                   alert(errorMessage);
                 addTeacherForm.reset();
               });

           } //end if
           else {
           }

    
         // addTeacherForm.reset();
         }); //The END
