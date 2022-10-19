
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword , onAuthStateChanged , sendEmailVerification , updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail

} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
//
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";


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

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

  const colRef = collection(db, 'Teacher');
  const auth = getAuth(app);

  //get collection data
  getDocs(colRef)
    .then((snapshot) => {
     let Admin = []
     snapshot.docs.forEach((doc)=> {
        Admin.push({...doc.data(), id: doc.id })
     })
     console.log(Admin)
    })
    .catch(err => {
        console.log(err.mssage)
    });



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
            var letters = /^[A-Za-z]+$/;
            if( !fname.value.match(letters) )
            {
             alert('first name must have alphabet characters only');
             document.addAdmin.firstName.focus();
             return false;
            }
           
            var lname = document.getElementById( "lastName" );
            if( !lname.value.match(letters) )
            {
             alert('last name must have alphabet characters only');
             document.addAdmin.lastName.focus();
             return false;
            }
           
            var email = document.getElementById( "email" );
            var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            if( !email.value.match(mailformat)){
             alert("You have entered an invalid email address!");
             document.addAdmin.email.focus();
             return false;
            }
           
            else {
              return true;
             }
           }


           /* get schoolID
           const authPrin = getAuth();
           lest Schoo_lID = null;
           onAuthStateChanged(authPrin, (user) => {
           if (user) {
              // User is signed in, see docs for a list of available properties
             // https://firebase.google.com/docs/reference/js/firebase.User
              Schoo_lID = user.uid;
              // ...
                } else {
                 // User is signed out
                 // ...
                }
            }); */
           
         
        // const registerEmail = null;
           const addAdminForm = document.querySelector('.addTeacher')
           let send = false;
           let adminID = null;
           addAdminForm.addEventListener('submit',  async (e) => {
            // alert("in");
             if(validate()){
             //   alert("in2");
             e.preventDefault()
            // alert("triggerd");
             const registerEmail = document.getElementById("email").value;
             const registerPass =  pass();
             createUserWithEmailAndPassword(auth, registerEmail, registerPass)
             .then(  (userCredential) => {
                 // Signed in 
                alert("triggerd");
                const user = userCredential.user;

                  setDoc(doc(db, "Teacher", user.uid), {
                    Email: addAdminForm.email.value,
                    FirstName: addAdminForm.firstName.value,
                    LastName: addAdminForm.lastName.value, 
                    password: "",
                    //schoolID?
                    schoolID: "/School/"+22,
                  // schoolID:"/School/"+Schoo_lID,
                  });

                  alert("تم بنجاح");
                  sendPasswordResetEmail(auth,registerEmail).then(() => {
                   // EmailSent
                  // alert(registerEmail + " -- " + auth);
                   alert("reset");
                 })      
                })
                .catch((error) => {
                  const errorCode = error.code;
                  const errorMessage = error.message;
                  alert(errorMessage);
                })
                addAdminForm.reset();
             }//end if
             else{
                // alert("return");
       
             }
             
           });//the end

        
       