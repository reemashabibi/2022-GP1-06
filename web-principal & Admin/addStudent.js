

import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import {
  getAuth, createUserWithEmailAndPassword, onAuthStateChanged, sendEmailVerification, updatePassword, sendPasswordResetEmail, fetchSignInMethodsForEmail
} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, setDoc, FieldValue, arrayUnion, updateDoc, collectionGroup } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
const app2 = initializeApp(firebaseConfig,"Secondary");
const db = getFirestore(app);

export { app, db, collection, getDocs, Timestamp, addDoc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);
const authSec = getAuth(app2);

var uid;
var email;
const auth = getAuth();
var snapshot;
onAuthStateChanged(auth, async (user) => {

    if (user) {
      // User is signed in, see docs for a list of available properties
      // https://firebase.google.com/docs/reference/js/firebase.User
       uid = user.uid;
        email = user.email
         snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    } else {
      // User is signed out
      // ...
    }
  });

//add class to drop-down menu
const schoolID = "kfGIwTyclpNernBQqSpQhkclzhh1";

/*snapshot.docs.forEach(async doc => {
const data = await getDoc(doc.ref.parent.parent);
schoolID = data.id;

});*/
const colRefClass = collection (db, "School",schoolID, "Class");
getDocs(colRefClass) 
  .then(snapshot => {
    
    //console.log(snapshot.docs)
    //let levels = []
    snapshot.docs.forEach(doc => {
      //levels.push({ ...doc.data(), id: doc.id })
      const new_op = document.createElement("option");
      new_op.innerHTML = doc.data().ClassName + ":فصل";
      new_op.setAttribute("id", doc.id);
      new_op.setAttribute("value", doc.data().ClassName);
      document.getElementById("classes").appendChild(new_op);
    })
    //console.log(levels)
  });



//add student info

const colRefStudent = collection(db, "School",schoolID,"Student");
//const colRefParent = collection(db, "Parent");
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
    const q = query(collection(db, "School",schoolID,"Parent"), where("Phonenumber", "==", phoneNumber));
    const querySnapshot = await getDocs(q);
    var parentId = "null";
    var docRef = "null";
    var docRefClass = "null";

    if (querySnapshot.empty) {

    
     // alert("triggerd");
      const registerFname = document.getElementById("FnameParent").value;
      const registerlname = document.getElementById("LnameParent").value;
      const registerEmail = document.getElementById("emailP").value;
      const registerPhone = document.getElementById("phone").value;
      const registerPass = pass();
      const phoneNum = parseInt(registerPhone);
      createUserWithEmailAndPassword(authSec, registerEmail, registerPass)
        .then((userCredential) => {
          // Signed in 
          const user = userCredential.user;

          //send an email to reset password
          sendPasswordResetEmail(authSec, registerEmail).then(() => {
            // EmailSent
            // alert(registerEmail + " -- " + auth);
          //  alert("reset");
          })
          const res = doc(db, "School",schoolID,"Parent", user.uid)

          //add to the document
          setDoc(doc(db, "School",schoolID,"Parent", user.uid), {
            Email: registerEmail,
            FirstName: registerFname,
            LastName: registerlname,
            Phonenumber: phoneNum,
            Students: []
            //schoolID?
          }).then(() => {
            docRef = doc(db, "School",schoolID,"Parent", res.id);
            docRefClass = doc(db, "School",schoolID,"Class", selectedClass[selectedClass.selectedIndex].id);
            addDoc(colRefStudent, {
              FirstName: addStudentForm.Fname.value,
              LastName: addStudentForm.Lname.value,
              ClassID: docRefClass,
              ParentID:docRef, 
            })
            .then(doc => {
              StuRef = doc(db, "School",schoolID,"Student", doc.id);
              updateDoc(docRefClass, {Students: arrayUnion(StuRef) })
              .then(() => {
                  console.log("A New Document Field has been added to an existing document");
              })
              .catch(error => {
                  console.log(error);
              })
              StuRef = doc(db, "School",schoolID,"Student", doc.id);
              updateDoc(docRef, {Students: arrayUnion(StuRef) })
              .then(() => {
                  console.log("A New Document Field has been added to an existing document");
              })
              .catch(error => {
                  console.log(error);
              })
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
      })
    }
else{
    
      querySnapshot.forEach((doc) => {
        if (!doc.empty)
          parentId = doc.id;

        else {
          alert("ولي الأمر غير مسجل، يرجى إكمال البيانات");
        }
      })
      docRef = doc(db, "School",schoolID,"Parent", parentId);
      docRefClass = doc(db, "School",schoolID,"Class", selectedClass[selectedClass.selectedIndex].id);
      addDoc(colRefStudent, {
        FirstName: addStudentForm.Fname.value,
        LastName: addStudentForm.Lname.value,
        ClassID: docRefClass,
        ParentID:docRef, 
      })
        .then(doc => {
          StuRef = doc(db, "School",schoolID,"Student", doc.id);
          updateDoc(docRefClass, {Students: arrayUnion(StuRef) })
          .then(() => {
              console.log("A New Document Field has been added to an existing document");
          })
          .catch(error => {
              console.log(error);
          })
          updateDoc(docRef, {Students: arrayUnion( StuRef) })
          .then(() => {
              console.log("A New Document Field has been added to an existing document");
          })
          .catch(error => {
              console.log(error);
          })

          addStudentForm.reset()
        });
    }
    alert("تمت إضافة الطالب بنجاح")
  
  }
});


$(".phone").change(async function () {

  var phoneNumber = parseInt(addStudentForm.phone.value);

  var q = query(collection(db, "School",schoolID,"Parent"), where("Phonenumber", "==", phoneNumber));
  var querySnapshot = await getDocs(q);
  var parentId = "null";
  if (!querySnapshot.empty) {
    querySnapshot.forEach((doc) => {
      if (!doc.empty) {
        parentId = doc.id;

        $("#FnameParent").val(doc.data().FirstName);
        $("#LnameParent").val(doc.data().LastName);
        $("#emailP").val(doc.data().Email);
        document.getElementById("FnameParent").disabled = true;
        document.getElementById("LnameParent").disabled = true;
        document.getElementById("emailP").disabled = true;

      }
    })
  } else {
    alert("ولي الأمر غير مسجل، يرجى اكمال البيانات");
    $("#FnameParent").val("");
    $("#LnameParent").val("");
    $("#emailP").val("");
    document.getElementById("FnameParent").disabled = false;
    document.getElementById("LnameParent").disabled = false;
    document.getElementById("emailP").disabled = false;
  }



});


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



