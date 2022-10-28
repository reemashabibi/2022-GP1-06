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
  let analytics2 = getAnalytics();


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

    let  sheet_data ;
    let registerFname = "";
    let registerlname = "";
    let registerEmail = "";
    let registerPass = "";

///////////////////////////////////// Add  TeacherS //////////////////////////////////////////////////////
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
    reader.onload =  async function(event){
        var data = new Uint8Array(reader.result);
        var work_book = XLSX.read(data, {type:'array'});
        var sheet_name = work_book.SheetNames;
         sheet_data = XLSX.utils.sheet_to_json(work_book.Sheets[sheet_name[0]], {header:1});

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
            var i = 1;
             for(var row = 1; row <5;  row++)
           {

            for(var cell = 0; cell < 3; cell++) {
         
                if(row == 0){
                    //herders
                 }
                else
                {
                 if(cell==0){
                    registerFname  = sheet_data[row][cell];
                 }
                 if(cell==1){
                    registerlname = sheet_data[row][cell];               
                }
                if(cell==2){
                    registerEmail = sheet_data[row][cell];
                    }
                }            
            }    
                registerPass = pass();        
                authTeacherS (registerFname, registerlname,registerEmail, registerPass);
          }//end row  
        }       
   }
});



 
function authTeacherS (registerFname, registerlname,registerEmail, registerPass){

    registerPass =  pass(); 
    createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
    .then(  (userCredential) => {
        // Signed in 
       // alert(" inn ");   
        const user = userCredential.user;
        sendPasswordResetEmail(authSec,registerEmail).then(() => {
            // EmailSent
           // alert("sent: " +registerEmail );
          }) 
      const res =  doc(db, 'School/'+authPrinID+'/Teacher', user.uid)    
      //alert(" in ");     
      //add to documnet
      setDoc(res, {
       Email: user.email,
       FirstName: registerFname,
       LastName: registerlname,               
     }) 
         
     }).catch((error) => {
         const errorCode = error.code;
         const errorMessage = error.message;
       });
  }
 
