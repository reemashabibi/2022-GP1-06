

import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import {
  getAuth, createUserWithEmailAndPassword, onAuthStateChanged, sendEmailVerification, updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail
} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs,getDoc, addDoc, Timestamp, updateDoc, arrayUnion, setDoc, collectionGroup } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
const app2 = initializeApp(firebaseConfig, "Secondary");
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const authSec = getAuth(app2);
const analytics = getAnalytics(app);


var schoolID;

function school(id){
  schoolID = id;
}
export async  function school_ID(email){
  const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
  snapshot.forEach(async doc => {
  const data = await getDoc(doc.ref.parent.parent);
  schoolID = data.id;
  school(schoolID);

  });

}



// = "kfGIwTyclpNernBQqSpQhkclzhh1";

export { app, db, collection, getDocs, Timestamp, addDoc };
export { query, orderBy, limit, where, onSnapshot };





//randomly generated pass
function pass() {
  var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  var string_length = 8;
  var pass = '';
  for (var i = 0; i < string_length; i++) {
    var rnum = Math.floor(Math.random() * chars.length);
    pass += chars.substring(rnum, rnum + 1);
  }
  return pass;
}
///////////////////////////////////// Add StudentS //////////////////////////////////////////////////////
const excel_file = document.getElementById('excel_file');
excel_file.addEventListener('change', (event) => {
  if (!['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel'].includes(event.target.files[0].type)) {
    document.getElementById('excel_data').innerHTML = '<div class="alert alert-danger">.xls او .xlsx يسمح فقط برفع ملف بصيغة </div>';
    excel_file.value = '';
    return false;
  }
  const colRefStudent = collection(db, "School", schoolID, "Student");

  let registerFname = "";
  let registerlname = "";
  let registerClass = "";
  let registerParentPhone = "";
  let registerParentFname = "";
  let registerParentlname = "";
  let registerPass = "";
  let registerParentEmail = "";
  let user;
  let randomID;
  // var counter =0;
  var reader = new FileReader();
  reader.readAsArrayBuffer(event.target.files[0]);
  reader.onload = async function (event) {
    var data = new Uint8Array(reader.result);
    var work_book = XLSX.read(data, { type: 'array' });
    var sheet_name = work_book.SheetNames;
    var sheet_data = XLSX.utils.sheet_to_json(work_book.Sheets[sheet_name[0]], { header: 1 });


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
   
    //Adding
    if (sheet_data.length > 0) {

      for (var row = 1; row < sheet_data[row].length; await row++) {
        for (var cell = 0; cell < 7; cell++) {

          if (row == 0) {
            //herders
            // table_output += sheet_data[row][cell];
          }
          else {
            if (cell == 0) {
              registerFname = sheet_data[row][cell];
              alert(registerFname);               
            }
            if (cell == 1) {
              registerlname = sheet_data[row][cell];
              //alert(registerlname);                 
            }
            if (cell == 2) {
              registerClass = sheet_data[row][cell];

              //alert(registerClass);
            }
            if (cell == 3) {
              registerParentPhone = parseInt(sheet_data[row][cell]);

              // alert(registerParentPhone);
            }
            if (cell == 4) {
              registerParentFname = sheet_data[row][cell];
              // alert(registerParentFname);
            }
            if (cell == 5) {
              registerParentlname = sheet_data[row][cell];
              //alert(registerParentlname);
            }
            if (cell == 6) {
              registerParentEmail = sheet_data[row][cell];
              // alert(registerParentEmail);
            }
          }
        }
        // randomID = randID();

        const q = query(collection(db, "School", schoolID, "Parent"), where("Phonenumber", "==", registerParentPhone));
        const querySnapshot = await getDocs(q);
        const qClass = query(collection(db, "School", schoolID, "Class"), where("ClassName", "==", registerClass));
        const queryClassSnapshot = await getDocs(qClass);
        var parentId = "null";
        var classId = "null"
        var docRef = "null";
        var docRefClass = "null";


        queryClassSnapshot.forEach((doc) => {
          if (!doc.empty)
            classId = doc.id;
        })
        if (!querySnapshot.empty) {
          querySnapshot.forEach((d) => {
            if (!d.empty)
              parentId = d.id;
          })
        }
      

        if (!queryClassSnapshot.empty && !querySnapshot.empty) {
              alert("p and c     "+registerFname + "   "+ registerlname + "   "+registerClass+ "   "+ registerParentPhone+ "   "+registerParentFname+ "   "+registerParentEmail)
          const colRefStudent = collection(db, "School", schoolID, "Student");
          docRef = doc(db, "School", schoolID, "Parent", parentId);
          docRefClass = doc(db, "School", schoolID, "Class", classId);
          addDoc(colRefStudent, {
            FirstName: registerFname,
            LastName: registerlname,
            ClassID: docRefClass,
            parentID: docRef,
          }).then(docu => {
            alert("added")
            alert(docu.id)
            const StuRef = doc(db, "School", schoolID, "Student", docu.id);
            updateDoc(docRefClass, { Students: arrayUnion(StuRef) })
              .then(() => {
                
                console.log("A New Document Field has been added to an existing document");
              })
              .catch(error => {
                console.log(error);
              })
            updateDoc(docRef, { Students: arrayUnion(StuRef) })
              .then(() => {
                
                console.log("A New Document Field has been added to an existing document");
              })
              .catch(error => {
                console.log(error);
              })
            
          });

          var x = table.rows[row].insertCell(7);
          x.innerHTML = "تمت الإضافة لولي أمر مسجل بالنظام";


        }//if parent and class exist/

        else if (!queryClassSnapshot.empty && querySnapshot.empty  ) {
          authParent(registerFname ,registerlname, registerClass,registerParentPhone ,registerParentFname,registerParentlname ,registerParentEmail ,schoolID,registerPass,queryClassSnapshot,row,table)

        } else {
          alert("no class     "+registerFname + "   "+ registerlname + "   "+registerClass+ "   "+ registerParentPhone+ "   "+registerParentFname+ "   "+registerParentEmail)

          alert("Class doesn't exsit")
          var x = table.rows[row].insertCell(7);
          x.innerHTML = "لم تتم الإضافة، يوجد خطأ باسم الفصل";
        }//end else class not exist

    


      }







    }
  }

});
    function authParent(registerFname ,registerlname, registerClass, registerParentPhone, registerParentFname,registerParentlname,registerParentEmail,schoolID,registerPass,queryClassSnapshot,row,table){
  alert("no parent     "+registerFname + "   "+ registerlname + "   "+registerClass+ "   "+ registerParentPhone+ "   "+registerParentFname+ "   "+registerParentEmail)
let classId;
let user ;
let docRefClass;
const colRefStudent = collection(db, "School", schoolID, "Student");

  registerPass = pass();
  createUserWithEmailAndPassword(authSec, registerParentEmail, registerPass).then((userCredential) => {


      // Signed in 
      user = userCredential.user;
    sendPasswordResetEmail(authSec, registerParentEmail).then(() => {
       alert("reset")
      })

      
     const res = doc(db, "School", schoolID, "Parent", user.uid)
     //add to the document
     alert("1###"+registerParentEmail)
     setDoc(res, {
      Email: user.email ,
      FirstName: registerParentFname,
      LastName: registerParentlname,
      Phonenumber: registerParentPhone,
      Students: [],})
      .then(() => {

      queryClassSnapshot.forEach((doc) => {
        if (!doc.empty)
          classId = doc.id;
      })

      //docRef = doc(db, "School",schoolID, "Parent", res.id);
      docRefClass = doc(db, "School", schoolID, "Class", classId);
      addDoc(colRefStudent, {
        FirstName: registerFname,
        LastName: registerlname,
        ClassID: docRefClass,
        parentID: res,
      }).then(d => {



        //docRef = doc(db, "School",schoolID, "Parent", res.id);
        const StuRef = doc(db, "School", schoolID, "Student", d.id);
        updateDoc(docRefClass, { Students: arrayUnion(StuRef) })
          .then(() => {
            console.log("A New Document Field has been added to an existing document");
          })
          .catch(error => {
            console.log(error);
          })
        updateDoc(res, { Students: arrayUnion(StuRef) })
          .then(() => {
            console.log("A New Document Field has been added to an existing document");
          })
          .catch(error => {
            console.log(error);
          })
          var x = table.rows[row].insertCell(7);
          x.innerHTML = "تمت الإضافة";
      })// close then addDoc

    })
    
  
  }).catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      var x = table.rows[row].insertCell(7);
    x.innerHTML = "لم تتم الاضافة";
    });
     
      alert("2###"+registerParentEmail)

  }
