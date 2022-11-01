

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
  let registerLevel = "";
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
        for (var cell = 0; cell < 8; cell++) {

          if (row == 0) {
            //herders
            // table_output += sheet_data[row][cell];
          }
          else {
            if (cell == 0) {
              registerFname = sheet_data[row][cell];
            }
            if (cell == 1) {
              registerlname = sheet_data[row][cell];
            }
            if (cell == 2) {
              registerClass = sheet_data[row][cell];

            }
            if (cell == 3) {
              registerLevel = sheet_data[row][cell];
            }
            if (cell == 4) {
              registerParentPhone = parseInt(sheet_data[row][cell]);
            }
            if (cell == 5) {
              registerParentFname = sheet_data[row][cell];
            }
            if (cell == 6) {
              registerParentlname = sheet_data[row][cell];
            }
            if (cell == 7) {
              registerParentEmail = sheet_data[row][cell];
            }
          }
        }
        const q = query(collection(db, "School", schoolID, "Parent"), where("Phonenumber", "==", registerParentPhone));
        const querySnapshot = await getDocs(q);
        const qClass = query(collection(db, "School", schoolID, "Class"), where("ClassName", "==", registerClass), where("Level", "==",registerLevel ));
        const queryClassSnapshot = await getDocs(qClass);
        var parentId = "null";
        var classId = "null";
        var docRef = "null";
        var docRefClass = "null";
        var studentParentExist = false;
        /// class id if exist
        if (!queryClassSnapshot.empty){
        queryClassSnapshot.forEach((doc) => {
          if (!doc.empty)
            classId = doc.id;
        })
      }
        //paret id if exist
        if (!querySnapshot.empty) {
          querySnapshot.forEach(async (d) => {
            if (!d.empty)
              parentId = d.id;
              

          })
        }

            //no parent for the same child
          var ref = doc(db, "School",schoolID,"Parent",parentId);
          var Query = query(collection(db, "School",schoolID,"Student"), where("ParentID", "==", ref));        
          var snapshot = await getDocs(Query);
          if (!snapshot.empty) {
            snapshot.forEach(async (docu) => {
              var FName = docu.data().FirstName;
              if(FName == registerFname){
                studentParentExist = true;
              }//if(FName != table.rows[row].insertCell(0) )
            })//    snapshot.forEach(async (docu)
          }// if (!snapshot.empty)
          if(snapshot.empty){
            let data = await getDoc(ref);
            var student = data.data().Students[0];
            const docSnap = await getDoc(student);
            if( docSnap.data().FirstName == registerFname )
            studentParentExist = true;
          }

          if(studentParentExist){    
            alert("الطالب مسجل بالنظام")
          var x = table.rows[row].insertCell(8);
           x.innerHTML = " لم تتم الإضافة، الطالب مسجل بالنظام مسبقاً";
                   }//end if studentParentExist


        
      
        if (!queryClassSnapshot.empty && !querySnapshot.empty && !studentParentExist) {
              alert("p and c     "+registerFname + "   "+ registerlname + "   "+registerClass+ "   "+ registerParentPhone+ "   "+registerParentFname+ "   "+registerParentEmail)
          const colRefStudent = collection(db, "School", schoolID, "Student");
          docRef = doc(db, "School", schoolID, "Parent", parentId);
          docRefClass = doc(db, "School", schoolID, "Class", classId);
          addDoc(colRefStudent, {
            FirstName: registerFname,
            LastName: registerlname,
            ClassID: docRefClass,
            ParentID: docRef,
          }).then(docu => {
            const StuRef = doc(db, "School", schoolID, "Student", docu.id);
            updateDoc(docRefClass, { Students: arrayUnion(StuRef) })
              .catch(error => {
                console.log(error);
              })
            updateDoc(docRef, { Students: arrayUnion(StuRef) })
              .catch(error => {
                console.log(error);
              })
            
          });

          var x = table.rows[row].insertCell(8);
          x.innerHTML = "تمت الإضافة لولي أمر مسجل بالنظام";

        }//if parent and class exist/

        else if (!queryClassSnapshot.empty && querySnapshot.empty && !studentParentExist ) {
          authParent(registerFname ,registerlname, registerClass,registerParentPhone ,registerParentFname,registerParentlname ,registerParentEmail ,schoolID,registerPass,queryClassSnapshot,row,table)

        } else if(queryClassSnapshot.empty ) {

          alert("Class doesn't exsit")
          var x = table.rows[row].insertCell(8);
          x.innerHTML = " لم تتم الإضافة، يوجد خطأ باسم الفصل أو رقم المستوى";
        }//end else class not exist

    


      }







    }
  }

});
    function authParent(registerFname ,registerlname, registerClass, registerParentPhone, registerParentFname,registerParentlname,registerParentEmail,schoolID,registerPass,queryClassSnapshot,row,table){
let classId;
let user ;
let docRefClass;
const colRefStudent = collection(db, "School", schoolID, "Student");

  registerPass = pass();
  createUserWithEmailAndPassword(authSec, registerParentEmail, registerPass).then((userCredential) => {


      // Signed in 
      user = userCredential.user;
    sendPasswordResetEmail(authSec, registerParentEmail).then(() => {
       
      })

      
     const res = doc(db, "School", schoolID, "Parent", user.uid)
     //add to the document
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
          var x = table.rows[row].insertCell(8);
          x.innerHTML = "تمت الإضافة";
      })// close then addDoc

    })
    
  
  }).catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      var x = table.rows[row].insertCell(8);
    x.innerHTML = "لم تتم الاضافة";
    });
     

  }
