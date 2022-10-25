

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




//add class to drop-down menu
const colRefClass = collection(db, "Class");

getDocs(colRefClass)
  .then(snapshot => {
    //console.log(snapshot.docs)
    //let levels = []
    snapshot.docs.forEach(doc => {
      //levels.push({ ...doc.data(), id: doc.id })
      const new_op = document.createElement("option");
      new_op.innerHTML = doc.data().ClassName + ":فصل:" + doc.data().Level + "مستوى";
      new_op.setAttribute("id", doc.id);
      new_op.setAttribute("value", doc.data().ClassName);
      document.getElementById("classes").appendChild(new_op);
    })
    //console.log(levels)
  })



//add student info
const colRefStudent = collection(db, "Student");
const colRefParent = collection(db, "Parent");
const selectedClass = document.getElementById("classes");
const addStudentForm = document.querySelector('.add')
var notValidated = false;
var filledCorrectly = false;



addStudentForm.addEventListener('submit', async (e) => {
  notValidated = false;
  var fname = document.getElementById("Fname");
  var letters = null ;
  if (fname.value == "") {
    alert('يجب أن لا يكون  الاسم الأول للطالب فارغًا');
    fname.focus();
    notValidated = true;
    return false;
  }

  var Lname = document.getElementById("Lname");
  if (Lname.value == "") {
    alert('يجب أن لا يكون  الاسم الأخير للطالب فارغًا');
    Lname.focus();
    notValidated = true;
  }

  var selectedClass = document.getElementById("classes");
  var selectedClassIn = selectedClass[selectedClass.selectedIndex].value;
  if (selectedClassIn == "non") {
    alert('يرجى اختيار الفصل');
    document.querySelector('.add').non.focus();
    notValidated = true;
  }




  var phoneNo = document.getElementById("phone");
  var phoneno = /^\d{10}$/;
  if ((!phoneNo.value.match(phoneno))) {
    alert('يلزم ان يتكون رقم الهاتف ١٠ ارقام باللغة الإنجليزية');
    phoneNo.focus();
    notValidated = true;
  }



  var FnameParent = document.getElementById("FnameParent");
  var letters = null;
  if (FnameParent.value == "") {
    alert('يجب أن لا يكون الاسم الأول لولي الأمر فارغًا');
    FnameParent.focus();
    notValidated = true;
  }

  var LnameParent = document.getElementById("LnameParent");
  if (LnameParent.value == "") {
    alert('يجب أن لا يكون  الاسم الأخير لولي الأمر فارغًا');
    LnameParent.focus();
    notValidated = true;
  }

  var emailP = document.getElementById("emailP");
  var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
  if (!emailP.value.match(mailformat)) {
    alert("الرجاء إدحال بريد إلكتروني صحيح");
    emailP.focus();
    notValidated = true;
  }


  if (notValidated)
    e.preventDefault();

});

addStudentForm.addEventListener('submit', async (e) => {

  e.preventDefault();

  if (!notValidated) {

    ////////////////////////

    const phoneNumber = parseInt(addStudentForm.phone.value);
    const q = query(collection(db, "Parent"), where("PhoneNumber", "==", phoneNumber));
    const querySnapshot = await getDocs(q);
    var parentId = "null";
    var docRef = "null";
    var docRefClass = "null";
    if (!querySnapshot.empty) {
      querySnapshot.forEach((doc) => {
        if (!doc.empty)
          parentId = doc.id;

        else {
          alert("ولي الأمر غير مسجل، يرجى إكمال البيانات");
        }
      })

      docRef = doc(db, "Parent", parentId);
      docRefClass = doc(db, "Class", selectedClass[selectedClass.selectedIndex].id);
      addDoc(colRefStudent, {
        FirstName: addStudentForm.Fname.value,
        LastName: addStudentForm.Lname.value,
        ClassID: docRefClass,
        ParentID: docRef,
      })
        .then(() => {
          addStudentForm.reset()
        });
    }
    if (parentId == "null") {
     // alert("triggerd");
      const registerFname = document.getElementById("FnameParent").value;
      const registerlname = document.getElementById("LnameParent").value;
      const registerEmail = document.getElementById("emailP").value;
      const registerPhone = document.getElementById("phone").value;
      const registerPass = pass();
      const phoneNum = parseInt(registerPhone);
      createUserWithEmailAndPassword(auth, registerEmail, registerPass)
        .then((userCredential) => {
          // Signed in 
          const user = userCredential.user;

          //send an email to reset password
          sendPasswordResetEmail(auth, registerEmail).then(() => {
            // EmailSent
            // alert(registerEmail + " -- " + auth);
          //  alert("reset");
          })
          const res = doc(db, "Parent", user.uid)

          //add to the document
          setDoc(doc(db, "Parent", user.uid), {
            Email: registerEmail,
            FirstName: registerFname,
            LastName: registerlname,
            password: "",
            PhoneNumber: phoneNum,
            //schoolID?
          }).then(() => {
            docRef = doc(db, "Parent", res.id);
            docRefClass = doc(db, "Class", selectedClass[selectedClass.selectedIndex].id);
            addDoc(colRefStudent, {
              FirstName: addStudentForm.Fname.value,
              LastName: addStudentForm.Lname.value,
              ClassID: docRefClass,
              ParentID: docRef,
            });
            addStudentForm.reset();
          });

         // alert("تم");
        }).catch((error) => {
          const errorCode = error.code;
          const errorMessage = error.message;
          // alert("البريد الالكتروني مستخدم من قبل");
          alert(errorMessage);
          addStudentForm.reset();
        });
      // addStudentForm.reset();

    }//end if
    alert("تمت إضافة الطالب بنجاح")

  }


});

$(".phone").change(async function () {

  var phoneNumber = parseInt(addStudentForm.phone.value);

  var q = query(collection(db, "Parent"), where("PhoneNumber", "==", phoneNumber));
  var querySnapshot = await getDocs(q);
  var parentId = "null";
  if (!querySnapshot.empty) {
    querySnapshot.forEach((doc) => {
      if (!doc.empty) {
        parentId = doc.id;

        $("#FnameParent").val(doc.data().FirstName);
        $("#LnameParent").val(doc.data().LastName);
        $("#emailP").val(doc.data().Email);
        $("#password").val(doc.data().Password);
      }
    })
  } else {
    alert("ولي الأمر غير مسجل، يرجى اكمال البيانات");
    $("#FnameParent").val("");
    $("#LnameParent").val("");
    $("#emailP").val("");
    $("#password").val("");
  }



});


//////////////////////parent auth///////////////////////////

const colRef = collection(db, 'Parent');
const auth = getAuth(app);


//get collection data
getDocs(colRef)
  .then((snapshot) => {
    let Parent = []
    snapshot.docs.forEach((doc) => {
      Parent.push({ ...doc.data(), id: doc.id })
    })
    console.log(Parent)
  })
  .catch(err => {
    console.log(err.mssage)
  });

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
             for(var row = 1; row < sheet_data.length; await row++)
            {
                for(var cell = 0; cell < sheet_data[row].length; cell++) {
         
                    if(row == 0){
                        //herders
                      //  table_output += sheet_data[row][cell];
                     }
                    else
                    {
                     if(cell==0){
                       // registerFname  = sheet_data[row][cell];
                       alert(cell[0].value);
                     }
                     if(cell==1){
                       // registerlname = sheet_data[row][cell];
                       // alert(registerlname);                 
                    }
                    if(cell==2){
                     //   registerEmail = sheet_data[row][cell];
                        
                      //  alert(registerEmail);
                    }
                    }
                }
                registerPass = pass();
               // randomID = randID();
                createUserWithEmailAndPassword(auth, registerEmail, registerPass)
                .then(  (userCredential) => {
                    // Signed in 
                     user = userCredential.user;
                   //send an email to reset password
                   sendPasswordResetEmail(auth,registerEmail).then( () => {
                    // EmailSent
                  })
                  //add to the document
                  //
                  }).catch((error) => {
                    const errorCode = error.code;
                    const errorMessage = error.message;
                  })
            }//end row  
        }
    }
});

