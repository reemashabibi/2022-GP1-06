import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword , onAuthStateChanged ,  sendPasswordResetEmail
} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
//
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
   
  let schoolID ;


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

 
    let  sheet_data ;
    let registerFname = "";
    let registerlname = "";
    let registerEmail = "";
    let registerPass = "";
   

///////////////////////////////////// Add TeacherS //////////////////////////////////////////////////////
const excel_file = document.getElementById('excel_file');
excel_file.addEventListener('change', (event) => {
    if(!['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel'].includes(event.target.files[0].type))
    {
        document.getElementById('excel_data').innerHTML = '<div class="alert alert-danger">.xls او .xlsx يسمح فقط برفع ملف بصيغة </div>';
        excel_file.value = '';
        return false; //.xls .xlsx 
    }
 
    var reader = new FileReader();
    reader.readAsArrayBuffer(event.target.files[0]);
    reader.onload = function(event){
        var data = new Uint8Array(reader.result);
        var work_book = XLSX.read(data, {type:'array'});
        var sheet_name = work_book.SheetNames;
         sheet_data = XLSX.utils.sheet_to_json(work_book.Sheets[sheet_name[0]], {header:1});

       //view tabel//
    if (sheet_data.length > 0) {
        var table_output = '<table id="table" class="table table-striped table-bordered">';
  
        for (var row = 0; row < sheet_data.length ; row++) {
          table_output += '<tr id="row">';
          for (var cell = 0; cell <  sheet_data[row].length; cell++) {
            if (row == 0) {
              table_output += '<th>' + sheet_data[row][cell] + '</th>';
            }
            else {
              table_output += '<td id="row' + cell + '">' + sheet_data[row][cell] + '</td>';
            }
          }
    
        }
        table_output += '</table>';
        document.getElementById('excel_data').innerHTML = table_output;
      }
      excel_file.value = '';
     
      table_output += '</tr >';
      const table = document.getElementById("table");

  //Add in users
    if(sheet_data.length > 0)
       {    
        //if not 5 does not work
             for(var row = 1; row <1000;  row++)
           {  
            for(var cell = 0; cell < 3; cell++) {  
                if(row == 0){
                    //herders
                   // table_output += sheet_data[row][cell];
                 }
                else
                {
                 if(cell==0){
                    registerFname  = sheet_data[row][cell];
                    //alert(registerFname);
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
                    //alert("#0");
                     authAdminS (registerFname, registerlname,registerEmail, registerPass,row,table);
                    // alert("#1");
          }//end row  
        }
    }
});




  function authAdminS (registerFname, registerlname,registerEmail, registerPass,row,table){
    //alert("in func");  
   // alert(registerFname + " - " +registerlname + " - "  + registerEmail + " - " +schoolID );
    const snapshot =  getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async doc => {
    const data = await getDoc(doc.ref.parent.parent);
    schoolID = data.id;
  
   alert( schoolID)
    registerPass =  pass(); 
    createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
    .then( (userCredential) => {
        // Signed in 
       const user = userCredential.user;   
     sendPasswordResetEmail(authSec,registerEmail).then(() => {
      // EmailSent
      //alert("sent");
    })  
    const res =  doc(db, 'School/'+schoolID+'/Teacher', user.uid)    
    //alert(" in ");     
    //add to documnet
    var x = table.rows[row].insertCell(3);
    x.innerHTML = "تمت الإضافة";
    setDoc(res, {
     Email: user.email,
     FirstName: registerFname,
     LastName: registerlname,               
   }) 
      })
      .catch((error) => {
        const errorCode = error.code;
        const errorMessage = error.message;
        if (errorMessage =="Firebase: Error (auth/email-already-in-use)."){
            var x = table.rows[row].insertCell(3);
            x.innerHTML = " البريد الإلكتروني مستخدم من قبل";
        }
        var x = table.rows[row].insertCell(3);
        x.innerHTML = "لم تتم الاضافة";
      });
       //alert("out func");
    })
  }
