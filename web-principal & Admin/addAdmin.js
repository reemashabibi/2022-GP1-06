
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword , onAuthStateChanged , sendEmailVerification , updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail, updateCurrentUser

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
  const app2 = initializeApp(firebaseConfig,"Secondary");
  const db = getFirestore(app);

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

  const colRef = collection(db, 'School');
  const auth = getAuth(app);
  const authSec = getAuth(app2);


//get principal ID 
let authPrin = getAuth();
let user= authPrin.currentUser;
let authPrinID = "";
   onAuthStateChanged(authPrin, (user)=>{
       if(user){
         authPrinID =user.uid;
           console.log("the same user");
       }
       else{
           console.log("the  user changed");
       }
   });



  //get collection data
  getDocs(colRef)
    .then((snapshot) => {
     let School = []
     snapshot.docs.forEach((doc)=> {
      School.push({...doc.data(), id: doc.id })
     })
     console.log(School)
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
            if( fname.value == "" )
            {
             alert('يجب أن لا يكون الحقل المطلوب فارغًا');
             document.addAdmin.firstName.focus();
             return false;
            }
           
            var lname = document.getElementById( "lastName" );
            if( lname.value == "" )
            {
            //alert('يجب أن لا يكون الحقل المطلوب فارغًا');
            // document.addAdmin.lastName.focus();
             return false;
            }
           
            var email = document.getElementById( "email" );
            var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            if( !email.value.match(mailformat)){
             alert("الرجاء إدحال بريد إلكتروني صحيح");
             document.addAdmin.email.focus();
             return false;
            }
           
            else {
              return true;
             }
           }



            const addAdminForm = document.querySelector('.addAdmin')
            addAdminForm.addEventListener('submit',  async (e) => {
             // alert("in");
              if(validate()){
              // alert("in2");
              e.preventDefault();
             // alert("triggerd");
              const registerFname = document.getElementById("firstName").value;
              const registerlname = document.getElementById("lastName").value;
              const registerEmail = document.getElementById("email").value;
              const registerPass =  pass();         
              createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
              .then( (userCredential) => {
                  // Signed in 
                 const user = userCredential.user;
     
                setDoc(doc(db, 'School/'+authPrinID+'/Admin', user.uid), {
               // setDoc(doc(db, 'School/'+"kfGIwTyclpNernBQqSpQhkclzhh1"+'/Admin', user.uid), {
                  Email: registerEmail,
                  FirstName: registerFname,
                  LastName: registerlname,               
                })
                
               alert("تمت الإضافة بنجاح");    
               sendPasswordResetEmail(authSec,registerEmail).then(() => {
                // EmailSent
                alert("sent");
              })  
                })

                .catch((error) => {
                  const errorCode = error.code;
                  const errorMessage = error.message;
                  if (errorMessage =="Firebase: Error (auth/email-already-in-use)."){
                       alert("البريد الالكتروني مستخدم من قبل");}
                       else
                  alert(errorMessage);
                  
                  addAdminForm.reset();
                });
                 addAdminForm.reset();
              }//end if
              else{
              }
            }); //The END
           

  