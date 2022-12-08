

import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import {
  getAuth, createUserWithEmailAndPassword, onAuthStateChanged, sendEmailVerification, updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail
} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, getDoc, addDoc, Timestamp, setDoc, FieldValue, arrayUnion, updateDoc, collectionGroup } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
const app2 = initializeApp(firebaseConfig, "Secondary");
const db = getFirestore(app);

export { app, db, collection, getDocs, Timestamp, addDoc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);
const authSec = getAuth(app2);
const auth = getAuth(app);


var schoolID;
function school(id) {
  schoolID = id;
}
$(".loader").hide();
export async function fillData(email) {
  const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email", "==", email)));
  snapshot.forEach(async doc => {
  const data = await getDoc(doc.ref.parent.parent);
  schoolID = data.id;
  const colRefClass = collection (db, "School",schoolID, "Class");
  getDocs(colRefClass) 
    .then(snapshot => {
      
      snapshot.docs.forEach(doc => {
        const new_op = document.createElement("option");
        new_op.innerHTML = doc.data().Level+ " :المرحلة"+" / "+ doc.data().ClassName + " :فصل";
        new_op.setAttribute("id", doc.id);
        new_op.setAttribute("value", doc.data().ClassName);
        document.getElementById("classes").appendChild(new_op);
      })
     $(".loader").hide();
    });
  
  });

}

const selectedClass = document.getElementById("classes");
const addStudentForm = document.querySelector('.add')
var notValidated = false;
var filledCorrectly = false;



addStudentForm.addEventListener('submit', async (e) => {

  notValidated = false;
  var fname = document.getElementById("Fname");
  var letters = null;
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
    $(".loader").show();


    const phoneNumber = parseInt(addStudentForm.phone.value);
    const q = query(collection(db, "School", schoolID, "Parent"), where("Phonenumber", "==", phoneNumber));
    const querySnapshot = await getDocs(q);
    var ParentId = "null";
    var docRef = "null";
    var docRefClass = "null";
    var emailP = document.getElementById("emailP");

    const colRefStudent = collection(db, "School", schoolID, "Student");

    if (querySnapshot.empty) {//adding new parent to the system 


      const registerFname = document.getElementById("FnameParent").value;
      const registerlname = document.getElementById("LnameParent").value;
      var registerEmail = document.getElementById("emailP").value;
      registerEmail = registerEmail.toLowerCase();
      const registerPhone = document.getElementById("phone").value;
      const registerPass = pass();
      const phoneNum = parseInt(registerPhone);

            /////New code  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
            $.post("http://localhost:8080/addUser",
            {
              email: registerEmail,
              password: registerPass
           },
           function (data, stat) {
             if(data.status == 'Successfull'){
              const res = doc(db, "School", schoolID, "Parent", data.uid)

              //add to the document
              setDoc(doc(db, "School", schoolID, "Parent", data.uid), {
                Email: registerEmail,
                FirstName: registerFname,
                LastName: registerlname,
                Phonenumber: phoneNum,
                Students: []
              }).then(() => {
                docRef = doc(db, "School", schoolID, "Parent", data.uid);
                docRefClass = doc(db, "School", schoolID, "Class", selectedClass[selectedClass.selectedIndex].id);
                addDoc(colRefStudent, {
                  FirstName: addStudentForm.Fname.value,
                  LastName: addStudentForm.Lname.value,
                  ClassID: docRefClass,
                  ParentID: docRef,
                })
                .then( d => {
                  
                  var StuRef = doc(db, "School",schoolID,"Student", d.id);
                  updateDoc(docRefClass, {Students: arrayUnion(StuRef) })
                  .catch(error => {
                    $(".loader").hide();
                      console.log(error);
                  })
                  updateDoc(docRef, {Students: arrayUnion(StuRef) })
                  .catch(error => {
                    $(".loader").hide();
                      console.log(error);
                  })
                  $(".loader").hide();
                  alert("تمت الإضافة بنجاح")
                  addStudentForm.reset();
              });
            }).catch((error) => {
              $(".loader").hide();

              alert("حصل خطأ بالنظام، الرجاء المحاولة لاحقًا");
            });
          }

             else{
               if(data.status == 'used'){
                $(".loader").hide();
               alert("البريد الالكتروني مستخدم من قبل");
               addStudentForm.emailP.focus();}
               else if (data == 'error'){
                $(".loader").hide();
               alert("حصل خطأ بالنظام، الرجاء المحاولة لاحقًا");
              }
             }

           });
       // End of new code (remove comment from below to return to old code)!!!!!!!!!!!!!!!!!!!!!!!!!!!     
    /*  createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
        .then((userCredential) => {
          // Signed in 
          const user = userCredential.user;

          //send an email to reset password
          sendPasswordResetEmail(authSec, registerEmail).then(() => {
            // EmailSent
          })



          const res = doc(db, "School", schoolID, "Parent", user.uid)

          //add to the document
          setDoc(doc(db, "School", schoolID, "Parent", user.uid), {
            Email: registerEmail,
            FirstName: registerFname,
            LastName: registerlname,
            Phonenumber: phoneNum,
            Students: []
          }).then(() => {
            docRef = doc(db, "School", schoolID, "Parent", user.uid);
            docRefClass = doc(db, "School", schoolID, "Class", selectedClass[selectedClass.selectedIndex].id);
            addDoc(colRefStudent, {
              FirstName: addStudentForm.Fname.value,
              LastName: addStudentForm.Lname.value,
              ClassID: docRefClass,
              ParentID: docRef,
            })
            .then( d => {
              
              var StuRef = doc(db, "School",schoolID,"Student", d.id);
              updateDoc(docRefClass, {Students: arrayUnion(StuRef) })
              .catch(error => {
                  console.log(error);
              })
              updateDoc(docRef, {Students: arrayUnion(StuRef) })
              .catch(error => {
                  console.log(error);
              })
              $(".loader").hide();
              alert("تمت الإضافة بنجاح")
              addStudentForm.reset();
          });
        }).catch((error) => {
          $(".loader").hide();
          const errorCode = error.code;
          const errorMessage = error.message;
          if (errorMessage == "Firebase: Error (auth/email-already-in-use).")
              alert("البريد الالكتروني مستخدم من قبل");
          addStudentForm.reset();
        });
      }).catch((error) => {
        $(".loader").hide();
        const errorCode = error.code;
        const errorMessage = error.message;
        if (errorMessage == "Firebase: Error (auth/email-already-in-use).")
            alert("البريد الالكتروني مستخدم من قبل");
        addStudentForm.emailP.focus();
      });*/
    }
    else {

      querySnapshot.forEach(async (d) => {
        if (!d.empty) {
          ParentId = d.id;
          //no parent for the same child
          var ref = doc(db, "School", schoolID, "Parent", ParentId);
          var Query = query(collection(db, "School", schoolID, "Student"), where("ParentID", "==", ref));
          var snapshot = await getDocs(Query);
          if (!snapshot.empty) {
            snapshot.forEach(async (docu) => {
              var FName = docu.data().FirstName;
              if (FName != addStudentForm.Fname.value) {


                docRef = doc(db, "School", schoolID, "Parent", ParentId);
                docRefClass = doc(db, "School", schoolID, "Class", selectedClass[selectedClass.selectedIndex].id);
                addDoc(colRefStudent, {
                  FirstName: addStudentForm.Fname.value,
                  LastName: addStudentForm.Lname.value,
                  ClassID: docRefClass,
                  ParentID: docRef,
                })
                  .then(d => {

                    var StuRef = doc(db, "School", schoolID, "Student", d.id);
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
                    $(".loader").hide();
                    alert("تمت إضافة الطالب بنجاح")
                    addStudentForm.reset()
                  });




              }//if(FName != addStudentForm.Fname.value )
              else {
                alert("الطالب مسجل بالنظام")
                $(".loader").hide();
                addStudentForm.Fname.focus();
                //return;

              }
            })//snapshot.forEach(async (doc)
          }//if (!snapshot.empty) 

        }// if not doc.empty

      })//  querySnapshot.forEach((doc)

    }//else 

  }// if validation 
});


$(".phone").change(async function () {
  var phoneNumber = parseInt(addStudentForm.phone.value);
  var phoneNo = document.getElementById("phone");
  var phoneno = /^\d{10}$/;
  if ((!phoneNo.value.match(phoneno))) {// validate Phone Number
    alert('يلزم ان يتكون رقم الهاتف ١٠ ارقام باللغة الإنجليزية');
    phoneNo.focus();
    notValidated = true;
    document.getElementById("FnameParent").disabled = true;
    document.getElementById("LnameParent").disabled = true;
    document.getElementById("emailP").disabled = true;
    $("#FnameParent").val("");
    $("#LnameParent").val("");
    $("#emailP").val("");
    return;
  } else {
    document.getElementById("FnameParent").disabled = false;
    document.getElementById("LnameParent").disabled = false;
    document.getElementById("emailP").disabled = false;
  }
  $(".loader").show();

  var q = query(collection(db, "School",schoolID,"Parent"), where("Phonenumber", "==", phoneNumber));
  var querySnapshot = await getDocs(q);
  var ParentId = "null";
  if (!querySnapshot.empty) {
    querySnapshot.forEach(async (d) => {
      if (!d.empty) {// the parent is registered in the system previously
        ParentId = d.id;
        //no parent for the same child
        var ref = doc(db, "School", schoolID, "Parent", ParentId);
        var Query = query(collection(db, "School", schoolID, "Student"), where("ParentID", "==", ref));
        var snapshot = await getDocs(Query);

        if (!snapshot.empty) {
          snapshot.forEach(async (doc) => {
            var FName = doc.data().FirstName;
            if (FName != addStudentForm.Fname.value) { 
              // to check if the admin has added the same student for the parent same parent before

        $("#FnameParent").val(d.data().FirstName);
        $("#LnameParent").val(d.data().LastName);
        $("#emailP").val(d.data().Email);
        $(".loader").hide();
            } else{
              $(".loader").hide();

              alert("الطالب مسجل بالنظام")
              addStudentForm.phone.value = "";
              addStudentForm.Fname.value = "";
              addStudentForm.Fname.focus();
            }//else  if(FName != addStudentForm.Fname.value )
          })//forEach
      }//if snapshot not empty
     }
   })
 }
  $(".loader").hide();
});//end on change phone number function 


//////////////////////parent auth///////////////////////////

const colRef = collection(db, 'Parent');


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