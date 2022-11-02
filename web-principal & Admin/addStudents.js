

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
$('.loader').show();
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
                  //   if (registerFname.replaceAll("\\s+","").equals("الإسم الأول".replaceAll("\\s+",""))  ||  registerFname.replaceAll("\\s+","").equals("الإسم الاول".replaceAll("\\s+","")) ||  registerFname.replaceAll("\\s+","").equals("الاسم الأول".replaceAll("\\s+","")) || registerFname.replaceAll("\\s+","").equals("الاسم الاول".replaceAll("\\s+","")) )
                  if (registerFname == "الإسم الأول للطالب" || registerFname == "الاسم الأول للطالب" || registerFname == "الإسم الاول للطالب"|| registerFname == "الاسم الاول للطالب")
                     {
                      validate1 = true;
                      //break;
                      }
                    //  if ( registerlname.replaceAll("\\s+","").equals("الإسم الأخير".replaceAll("\\s+",""))  ||  registerlname.replaceAll("\\s+","").equals("الإسم الاخير".replaceAll("\\s+","")) ||  registerlname.replaceAll("\\s+","").equals("الاسم الاخير".replaceAll("\\s+","")) || registerlname.replaceAll("\\s+","").equals("الاسم الأخير".replaceAll("\\s+","")) )
                    if (registerlname == "الإسم الأخير للطالب" || registerlname == "الإسم الاخير للطالب" || registerlname == "الاسم الأخير للطالب"|| registerlname == "الاسم الأخير للطالب")
                      {
                        validate2 = true;
                     // break;
                       }
                       if (registerClass == "اسم الفصل" || registerClass == "الفصل" || registerClass == "إسم الفصل"|| registerClass == "الصف")
                      {
                        validate3 = true;
                     // break;
                       }
                       if (registerLevel == "المستوى" || registerLevel == "المستوي" || registerLevel == "رقم المستوى"|| registerLevel == "مستوى")
                       {
                         validate4 = true;
                      // break;
                        }
                        if (registerParentPhone == "رقم هاتف ولي الأمر" || registerParentPhone == "رقم جوال ولي الأمر" || registerParentPhone == "رقم الجوال"|| registerParentPhone == "رقم الهاتف"|| registerParentPhone == "الهاتف"|| registerParentPhone == "جوال")
                       {
                         validate5 = true;
                      // break;
                        }
                     if (registerParentFname =="الإسم الأول لولي الأمر" || registerParentFname =="الاسم الأول لولي الأمر"|| registerParentFname =="الاسم الأول لولي الامر"|| registerParentFname =="الاسم الاول لولي الأمر")
                     {
                      validate6 = true;
                     // break;
                      } 
                      if (registerParentlname =="الإسم الأخير لولي الأمر" || registerParentlname =="الاسم الاخير لولي الأمر"|| registerParentlname =="الاسم الاخير لولي الامر"|| registerParentlname =="الاسم الأخير لولي الأمر")
                      {
                       validate7 = true;
                      // break;
                       } 
                     if (registerParentEmail == "البريد الإلكتروني لولي الأمر" || registerParentEmail =="البريد الإلكتروني لولي الامر" || registerParentEmail =="البريد الالكتروني لولي الامر"|| registerParentEmail =="البريد الالكتروني لولي الأمر")
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
              alert(" الخانة الأولى يجب أن تحتوي على الاسم الأول للطالب، يرجى تحميل نموذج الإضافة ورفعه ");
             // break;
             }
             if(validate2 == false){ 
              alert("الخانة الثانية يجب أن تحتوي على الاسم الأخير للطالب، يرجى تحميل نموذج الإضافة ورفعه ");
             // break;
             }
             if(validate3 == false){
              alert("الخانة الثالثة يجب أن تحتوي على اسم الفصل، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
             if(validate4 == false){
              alert("الخانة الرابعة يجب أن تحتوي على رقم المستوى، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
             if(validate5 == false){
              alert("الخانة الخامسة يجب أن تحتوي على رقم هاتف ولي الأمر، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
             if(validate6 == false){
              alert("الخانة السادسة يجب أن تحتوي على الاسم الأول لولي الأمر، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
             if(validate7 == false){
              alert("الخانة السابعة يجب أن تحتوي على الاسم الأخير لولي الأمر، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
             if(validate8 == false){
              alert("الخانة الثامنة يجب أن تحتوي على البريد الإلكتروني لولي الأمر، يرجى تحميل نموذج الإضافة ورفعه");
             // break;
             }
      




               //***********/  
            if(validate1 && validate2 && validate3 && validate4 && validate5 && validate6 && validate7 && validate8){
              // alert("true");
             var x = table.rows[0].insertCell(8);
             x.innerHTML = "حالة الإضافة";
             }
 





   
    //Adding
    if(validate1 && validate2 && validate3 && validate4 && validate5 && validate6 && validate7 && validate8){

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
        var ParentId = "null";
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
              ParentId = d.id;
              

          })
        }

            //no parent for the same child
          var ref = doc(db, "School",schoolID,"Parent",ParentId);
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
            if(data.exists()){
            var student = data.data().Students[0];
            alert(student)
            const docSnap = await getDoc(student);
            if( docSnap.data().FirstName == registerFname )
            studentParentExist = true;
            }
          }

          if(studentParentExist){    
          var x = table.rows[row].insertCell(8);
           x.innerHTML = " لم تتم الإضافة، الطالب مسجل بالنظام مسبقاً";
                   }//end if studentParentExist


        
        if (!queryClassSnapshot.empty && !querySnapshot.empty && !studentParentExist) {
          const colRefStudent = collection(db, "School", schoolID, "Student");
          docRef = doc(db, "School", schoolID, "Parent", ParentId);
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

          var x = table.rows[row].insertCell(8);
          x.innerHTML = " لم تتم الإضافة، يوجد خطأ باسم الفصل أو رقم المستوى";
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
          x.innerHTML = "تمت الإضافة";
      })// close then addDoc

    })
    
  
  }).catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      var x = table.rows[row].insertCell(8);
    x.innerHTML = "لم تتم الاضافة، البريد الاكتروني مستخدم مسبقاً";
    });
     

  }
