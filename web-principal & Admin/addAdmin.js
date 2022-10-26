
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
  const db = getFirestore(app);

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

  const colRef = collection(db, 'Admin');
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
             alert("الرجاء إدحال بريد إلكتروني صحيح");
             document.addAdmin.email.focus();
             return false;
            }
           
            else {
              return true;
             }
           }


         //  get schoolID
           const authPrin = getAuth();
           let School_ID = null;
           let schoolIDref = "";
           onAuthStateChanged(authPrin, (user) => {
           if (user) {
              // User is signed in, see docs for a list of available properties
             // https://firebase.google.com/docs/reference/js/firebase.User
              School_ID = user.uid;
              schoolIDref = doc(db, 'School', School_ID);
              // ...
                } else {
                 // User is signed out
                 // ...
                }
            }); 


            const addAdminForm = document.querySelector('.addAdmin')
            addAdminForm.addEventListener('submit',  async (e) => {
             // alert("in");
              if(validate()){
              //    alert("in2");
              e.preventDefault();
              alert("triggerd");
              const registerFname = document.getElementById("firstName").value;
              const registerlname = document.getElementById("lastName").value;
              const registerEmail = document.getElementById("email").value;
              const registerPass =  pass();
              e.preventDefault();
              
              createUserWithEmailAndPassword(auth, registerEmail, registerPass)
              .then( (userCredential) => {
                  // Signed in 
                  const user = userCredential.user;
                 //send an email to reset password
                 sendPasswordResetEmail(auth,registerEmail).then(() => {
                  // EmailSent
                })

                //add to the document
                setDoc(doc(db, "Admin", user.uid), {
                  Email: registerEmail,
                  FirstName: registerFname,
                  LastName: registerlname, 
                  password: "",
                  //schoolID?
                   SchoolID: schoolIDref,
                 
                });
               alert("تمت الإضافة بنجاح");
                 
                })
                .catch((error) => {
                  const errorCode = error.code;
                  const errorMessage = error.message;
                  if (errorMessage =="Firebase: Error (auth/email-already-in-use).")
                       alert("البريد الالكتروني مستخدم من قبل");
                  alert(errorMessage);
                  
                  addAdminForm.reset();
                });
                addAdminForm.reset();
              }//end if
              else{
                 // alert("return");
              }
             // window.location.href = "principalHomePage.html";

            }); //The END
           


///////////////////////////////////// Add AdminS //////////////////////////////////////////////////////
const excel_file = document.getElementById('excel_file');
excel_file.addEventListener('change', (event) => {
    if(!['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel'].includes(event.target.files[0].type))
    {
        document.getElementById('excel_data').innerHTML = '<div class="alert alert-danger">Only .xlsx or .xls file format are allowed</div>';
        excel_file.value = '';
        return false;
    }
   let registerFname = "";
   let registerlname = "";
   let registerEmail = "";
   let registerPass = "";
   let user ;
   let randomID;
   // var counter =0;
    var reader = new FileReader();
    reader.readAsArrayBuffer(event.target.files[0]);
    reader.onload = async function(event){
        var data = new Uint8Array(reader.result);
        var work_book = XLSX.read(data, {type:'array'});
        var sheet_name = work_book.SheetNames;
        var sheet_data = XLSX.utils.sheet_to_json(work_book.Sheets[sheet_name[0]], {header:1});

             //view tabel//
        if(sheet_data.length > 0)
        {
            var table_output = '<table class="table table-striped table-bordered">';

            for(var row = 0; row < sheet_data.length; row++)
            {
                table_output += '<tr>';
                for(var cell = 0; cell < sheet_data[row].length; cell++)
                {
                    if(row == 0)
                    {
                        table_output += '<th>'+sheet_data[row][cell]+'</th>';
                    }
                    else
                    {
                        table_output += '<td>'+sheet_data[row][cell]+'</td>';
                    }
                }
                table_output += '</tr>';
            }
            table_output += '</table>';
            document.getElementById('excel_data').innerHTML = table_output;
        }
        excel_file.value = '';



        //Adding
    if(sheet_data.length > 0)
        {
             for(var row = 1; row <5;  row++)
            {
                for(var cell = 0; cell < sheet_data[row].length; cell++) {
         
                    if(row == 0){
                        //herders
                      //  table_output += sheet_data[row][cell];
                     }
                    else
                    {
                     if(cell==0){
                        registerFname  = sheet_data[row][cell];
                       // alert(registerFname);
                     }
                     if(cell==1){
                        registerlname = sheet_data[row][cell];
                       // alert(registerlname);                 
                    }
                    if(cell==2){
                        registerEmail = sheet_data[row][cell];
                      //  alert(registerEmail);
                    }
                    }
                }
                registerPass = pass();
               // randomID = randID();
                createUserWithEmailAndPassword(auth, registerEmail, registerPass)
                .then( (userCredential) => {
                    // Signed in 
                     user = userCredential.user;
                   //send an email to reset password
                   sendPasswordResetEmail(auth,registerEmail).then( () => {
                    // EmailSent
                  }) 
              
                                        //add to the document
                                        setDoc(doc(db, "Admin", user.uid), {
                                          Email: registerEmail,
                                          FirstName: registerFname,
                                          LastName: registerlname, 
                                          password: "",
                                          //schoolID?
                                         // schoolID: "/School/"+School_lID,
                                           schoolID: "/School/"+22,
                                        });
              //    alert(registerFname);
                  }).catch((error) => {
                    const errorCode = error.code;
                    const errorMessage = error.message;
                  })
            }//end row  


        }
    }
});


