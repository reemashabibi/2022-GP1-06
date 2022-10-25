

import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import {
  getAuth, createUserWithEmailAndPassword, onAuthStateChanged, sendEmailVerification, updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail
} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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

export { app, db, collection, getDocs, Timestamp, addDoc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);



const colRefStudent = collection(db, "Student");



///////////////////////////////////// Add StudentS //////////////////////////////////////////////////////
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
   let registerClass = "";
   let registerParentPhone = "";
   let registerParentFname = "";
   let registerParentlname = "";
   let registerParentEmail = "";
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
            var table_output = '<table id="table" class="table table-striped table-bordered">';

            for(var row = 0; row < sheet_data.length; row++)
            {
                table_output += '<tr id="row">';
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
        
             for(var row = 1; row < sheet_data.length; await row++)
            {
                for(var cell = 0; cell < 5; cell++) {
         
                    if(row == 0){
                        //herders
                       // table_output += sheet_data[row][cell];
                     }
                    else
                    {
                     if(cell==0){
                        registerFname  = sheet_data[row][cell];
                       alert(registerFname);
                     }
                     if(cell==1){
                        registerlname = sheet_data[row][cell];
                       // alert(registerlname);                 
                    }
                    if(cell==2){
                        registerClass = sheet_data[row][cell];
                        
                      //  alert(registerEmail);
                    }
                    if(cell==3){
                        registerParentPhone = parseInt(sheet_data[row][cell]);
                         
                       //  alert(registerEmail);
                     }
                     if(cell==4){
                        registerParentFname = sheet_data[row][cell];
                         
                       //  alert(registerEmail);
                     }
                     if(cell==5){
                        registerParentlname = sheet_data[row][cell];
                         
                       //  alert(registerEmail);
                     }
                     if(cell==6){
                        registerParentEmail = sheet_data[row][cell];
                         
                       //  alert(registerEmail);
                     }
                    }
                }
               // 
               // randomID = randID();
               
               const q = query(collection(db, "Parent"), where("PhoneNumber", "==", registerParentPhone));
               const querySnapshot = await getDocs(q);
               const qClass = query(collection(db, "Class"), where("ClassName", "==", registerClass ));
               const queryClassSnapshot = await getDocs(qClass);
               var parentId = "null";
               var classId = "null"
               var docRef = "null";
               var docRefClass = "null";

               if (!querySnapshot.empty) {
                 querySnapshot.forEach((doc) => {
                   if (!doc.empty)
                     parentId = doc.id;
                 })

                 if (!queryClassSnapshot.empty) {
                    queryClassSnapshot.forEach((doc) => {
                      if (!doc.empty)
                        classId = doc.id;
                    })
           
                 docRef = doc(db, "Parent", parentId);
                 docRefClass = doc(db, "Class", classId);
                 
                 addDoc(colRefStudent, {
                   FirstName:registerFname ,
                   LastName: registerlname,
                   ClassID: docRefClass,
                   ParentID: docRef,
                 })
                   .then(() => {
                    // addStudentForm.reset()
                   });
               }alert(classId == "null")
               if(classId == "null"){
                    alert(" !الفصل "+registerClass+"غير مسجل بالنظام")
                    return false;}
               if (parentId == "null") {
                alert("triggerd");
                registerPass = pass();
                createUserWithEmailAndPassword(auth, registerParentEmail, registerPass)
                  .then((userCredential) => {
                    // Signed in 
                    const user = userCredential.user;
          
                    //send an email to reset password
                    sendPasswordResetEmail(auth, registerParentEmail).then(() => {
                      // EmailSent
                      // alert(registerEmail + " -- " + auth);
                      alert("reset");
                    })
                    const res = doc(db, "Parent", user.uid)
          
                    //add to the document
                    setDoc(doc(db, "Parent", user.uid), {
                      Email: registerParentEmail,
                      FirstName: registerParentFname,
                      LastName: registerParentlname,
                      PhoneNumber: registerParentPhone,
                    }).then(() => {
                      docRef = doc(db, "Parent", res.id);
                      //docRefClass = doc(db, "Class", selectedClass[selectedClass.selectedIndex].id);
                      addDoc(colRefStudent, {
                        FirstName: registerFname,
                        LastName: registerlname,
                        ClassID: docRefClass,
                        ParentID: docRef,
                      });
                      //addStudentForm.reset();
                    });
                    alert("تم");
                }).catch((error) => {
                  const errorCode = error.code;
                  const errorMessage = error.message;
                  // alert("البريد الالكتروني مستخدم من قبل");
                  alert(errorMessage);
                  addStudentForm.reset();
                });
              // addStudentForm.reset();
        
            }//end if

            }//end row  
        }
    }
 
}
});
