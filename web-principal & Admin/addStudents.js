

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
const auth = getAuth(app);

var schoolID;

function school(id){
  schoolID = id;
  $('.loader').hide();
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



    //***********/  
    let validate1 = false;
    let validate2 = false;
    let validate3 = false;
    let validate4 = false;
    let validate5 = false;
    let validate6 = false;
    let validate7 = false;
    let validate8 = false;
    var studentAdded   = [];
    var parentNumAdded   = [];


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
    document.getElementById('excel_data').innerHTML = '<div class="alert alert-danger">.xls ???? .xlsx ???????? ?????? ???????? ?????? ?????????? </div>';
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



           //validate
            //***********/  
            if (sheet_data.length > 0) {
              for (var row = 0; row < 1; row++) {
                for (var cell = 0; cell < 8 ; cell++) {
                   registerFname = sheet_data[0][0];
                   registerlname = sheet_data[0][1];
                   registerClass =  sheet_data[0][2];
                   registerLevel =  sheet_data[0][3];
                   registerParentPhone =  sheet_data[0][4];
                   registerParentFname =  sheet_data[0][5];
                   registerParentlname =  sheet_data[0][6];
                   registerParentEmail = sheet_data[0][7];
                  if (row == 0) { 
                    //does not ignore whie sapces in Arabic
                  //   if (registerFname.replaceAll("\\s+","").equals("?????????? ??????????".replaceAll("\\s+",""))  ||  registerFname.replaceAll("\\s+","").equals("?????????? ??????????".replaceAll("\\s+","")) ||  registerFname.replaceAll("\\s+","").equals("?????????? ??????????".replaceAll("\\s+","")) || registerFname.replaceAll("\\s+","").equals("?????????? ??????????".replaceAll("\\s+","")) )
                  if (registerFname == "?????????? ?????????? ????????????" || registerFname == "?????????? ?????????? ????????????" || registerFname == "?????????? ?????????? ????????????"|| registerFname == "?????????? ?????????? ????????????")
                     {
                      validate1 = true;
                      //break;
                      }
                    //  if ( registerlname.replaceAll("\\s+","").equals("?????????? ????????????".replaceAll("\\s+",""))  ||  registerlname.replaceAll("\\s+","").equals("?????????? ????????????".replaceAll("\\s+","")) ||  registerlname.replaceAll("\\s+","").equals("?????????? ????????????".replaceAll("\\s+","")) || registerlname.replaceAll("\\s+","").equals("?????????? ????????????".replaceAll("\\s+","")) )
                    if (registerlname == "?????????? ???????????? ????????????" || registerlname == "?????????? ???????????? ????????????" || registerlname == "?????????? ???????????? ????????????"|| registerlname == "?????????? ???????????? ????????????")
                      {
                        validate2 = true;
                     // break;
                       }
                       if (registerClass == "?????? ??????????" || registerClass == "??????????" || registerClass == "?????? ??????????"|| registerClass == "????????")
                      {
                        validate3 = true;
                     // break;
                       }
                       if (registerLevel == "??????????????" || registerLevel == "??????????????" || registerLevel == "?????? ?????????????? ????????????????"|| registerLevel == "?????? ?????????????? ????????????????"|| registerLevel == "?????? ?????????????? ????????????????")
                       {
                         validate4 = true;
                      // break;
                        }
                        if (registerParentPhone == "?????? ???????? ?????? ??????????" || registerParentPhone == "?????? ???????? ?????? ??????????" || registerParentPhone == "?????? ????????????"|| registerParentPhone == "?????? ????????????"|| registerParentPhone == "????????????"|| registerParentPhone == "????????")
                       {
                         validate5 = true;
                      // break;
                        }
                     if (registerParentFname =="?????????? ?????????? ???????? ??????????" || registerParentFname =="?????????? ?????????? ???????? ??????????"|| registerParentFname =="?????????? ?????????? ???????? ??????????"|| registerParentFname =="?????????? ?????????? ???????? ??????????")
                     {
                      validate6 = true;
                     // break;
                      } 
                      if (registerParentlname =="?????????? ???????????? ???????? ??????????" || registerParentlname =="?????????? ???????????? ???????? ??????????"|| registerParentlname =="?????????? ???????????? ???????? ??????????"|| registerParentlname =="?????????? ???????????? ???????? ??????????")
                      {
                       validate7 = true;
                      // break;
                       } 
                     if (registerParentEmail == "???????????? ???????????????????? ???????? ??????????" || registerParentEmail =="???????????? ???????????????????? ???????? ??????????" || registerParentEmail =="???????????? ???????????????????? ???????? ??????????"|| registerParentEmail =="???????????? ???????????????????? ???????? ??????????")
                       {
                        validate8 = true;
                       // break;
                        }     
                  }
                }       
              }        
            }








             //***********/  
             if (validate1 == false){
              alert(" ???????????? ???????????? ?????? ???? ?????????? ?????? ?????????? ?????????? ?????????????? ???????? ?????????? ?????????? ?????????????? ?????????? ");
             // break;
             }
             if(validate2 == false){ 
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????????? ???????????? ?????????????? ???????? ?????????? ?????????? ?????????????? ?????????? ");
             // break;
             }
             if(validate3 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????? ???????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
             if(validate4 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????? ?????????????? ?????????????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
             if(validate5 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????? ???????? ?????? ???????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
             if(validate6 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????????? ?????????? ???????? ???????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
             if(validate7 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ?????????? ???????????? ???????? ???????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
             if(validate8 == false){
              alert("???????????? ?????????????? ?????? ???? ?????????? ?????? ???????????? ???????????????????? ???????? ???????????? ???????? ?????????? ?????????? ?????????????? ??????????");
             // break;
             }
      




               //***********/  
            if(validate1 && validate2 && validate3 && validate4 && validate5 && validate6 && validate7 && validate8){
              // alert("true");
             var x = table.rows[0].insertCell(8);
             x.innerHTML = "???????? ??????????????";
             }
 





   
    //Adding
    if(validate1 && validate2 && validate3 && validate4 && validate5 && validate6 && validate7 && validate8){
      studentAdded   = [];
      parentNumAdded   = [];
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
              registerParentEmail = registerParentEmail.toLowerCase();

            }
          }
        }
        var q = query(collection(db, "School", schoolID, "Parent"), where("Phonenumber", "==", registerParentPhone));
        var querySnapshot = await getDocs(q);
        var qClass = query(collection(db, "School", schoolID, "Class"), where("ClassName", "==", registerClass), where("Level", "==",registerLevel ));
        var queryClassSnapshot = await getDocs(qClass);
        var parentId = "null";
        var classId = "null";
        //var docRef = "null";
        //var docRefClass = "null";
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
            if(studentAdded.length > 0){
              for( var i  = 0 ; i < studentAdded.length ; i++ ){
                if(studentAdded[i] == registerFname && parentNumAdded[i] == registerParentPhone)
                studentParentExist = true;
              }
            }
          }
     if(studentParentExist){    
          var x = table.rows[row].insertCell(8);
           x.innerHTML = " ???? ?????? ???????????????? ???????????? ???????? ?????????????? ????????????";
                   }//end if studentParentExist


        
   
                   if (!queryClassSnapshot.empty && !querySnapshot.empty && !studentParentExist) {
                    const colRefStudent = collection(db, "School", schoolID, "Student");
                    var docRef = doc(db, "School", schoolID, "Parent", parentId);
                    var docRefClass = doc(db, "School", schoolID, "Class", classId);
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
                    x.innerHTML = "?????? ?????????????? ???????? ?????? ???????? ??????????????";
          
                  }//if parent and class exist/
        else if (!queryClassSnapshot.empty && querySnapshot.empty && !studentParentExist ) {
          authParent(registerFname ,registerlname, registerClass,registerParentPhone ,registerParentFname,registerParentlname ,registerParentEmail ,schoolID,registerPass,queryClassSnapshot,row,table)

        } else if(queryClassSnapshot.empty ) {

          var x = table.rows[row].insertCell(8);
          x.innerHTML = " ???? ?????? ???????????????? ???????? ?????? ???????? ?????????? ???? ?????? ??????????????";
        }//end else class not exist

    


      }







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

          /////New code  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
          $.post("http://localhost:8080/addUser",
          {
            email: registerParentEmail,
            password: registerPass
         },
         function (data, stat) {
           if(data.status == 'Successfull'){
            sendPasswordResetEmail(auth, registerParentEmail).then(() => {
       
            })
      
           const res = doc(db, "School", schoolID, "Parent", data.uid)
           //add to the document
           setDoc(res, {
            Email: registerParentEmail ,
            FirstName: registerParentFname,
            LastName: registerParentlname,
            Phonenumber: registerParentPhone,
            Students: [],})
            .then(() => {
            parentNumAdded.push(registerParentPhone);
            studentAdded.push(registerFname);
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
              ParentID: res,
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
                x.innerHTML = "?????? ??????????????";
            })// close then addDoc
      
          }) 
           }
           else{
             if(data.status == 'used'){
             var x = table.rows[row].insertCell(8);
             x.innerHTML = "???? ?????? ???????????????? ???????????? ?????????????????? ???????????? ????????????";
             }
             else if (data == 'error'){
             var x = table.rows[row].insertCell(8);
             x.innerHTML = "???? ?????? ??????????????";}

           }
         });
     // End of new code (remove comment from below to return to old code)!!!!!!!!!!!!!!!!!!!!!!!!!!!  

 /* createUserWithEmailAndPassword(authSec, registerParentEmail, registerPass).then((userCredential) => {

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
      parentNumAdded.push(registerParentPhone);
      studentAdded.push(registerFname);
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
        ParentID: res,
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
          x.innerHTML = "?????? ??????????????";
      })// close then addDoc

    })
    
  
  }).catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      var x = table.rows[row].insertCell(8);
    x.innerHTML = "???? ?????? ???????????????? ???????????? ?????????????????? ???????????? ????????????";
    });*/
     

  }
