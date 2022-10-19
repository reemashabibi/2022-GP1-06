

// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
// import firebase from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
//import "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAk1XvudFS302cnbhPpnIka94st5nA23ZE",
  authDomain: "halaqa-89b43.firebaseapp.com",
  projectId: "halaqa-89b43",
  storageBucket: "halaqa-89b43.appspot.com",
  messagingSenderId: "969971486820",
  appId: "1:969971486820:web:40cc0abf19a909cc470f71",
  measurementId: "G-PCYTHJF1SD"
};
// Initialize Firebase
//firebase.initializeApp(firebaseConfig);
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
var notValidated= false ; 



addStudentForm.addEventListener('submit', async (e) => {
notValidated= false ; 
var fname = document.getElementById( "Fname" );
var letters = /^[A-Za-z]+$/;
if( !fname.value.match(letters) )
{
 alert('.يلزم ان يتكون الاسم الأول للطالب من احرف فقط');
 fname.focus();
 notValidated = true;
}

var Lname = document.getElementById( "Lname" );
if( !Lname.value.match(letters) )
{
 alert('.يلزم ان يتكون الاسم الأخير للطالب من احرف فقط');
 Lname.focus();
 notValidated = true;
}

var selectedClass = document.getElementById("classes");
var selectedClassIn = selectedClass[selectedClass.selectedIndex].value;
if(selectedClassIn == "non"){
 alert('.أرجو اختيار الفصل');
 document.querySelector('.add').non.focus();
 notValidated = true;}
       



 var phoneNo =document.getElementById("phone");
          var phoneno = /^\d{10}$/;
          if((!phoneNo.value.match(phoneno)))
                {
                 alert('يلزم ان يتكون رقم الهاتف من ١٠ ارقام فقط');
                phoneNo.focus();
                notValidated = true;
                }
       

         
         var FnameParent = document.getElementById( "FnameParent" );
         var letters = /^[A-Za-z]+$/;
         if( !FnameParent.value.match(letters) )
         {
           alert('.يلزم ان يتكون الاسم الأول لولي الأمر من احرف فقط');
          FnameParent.focus();
          notValidated = true;
         }
     
         var LnameParent = document.getElementById( "LnameParent" );
         if( !LnameParent.value.match(letters) )
         {
           alert('.يلزم ان يتكون الاسم الأخير لولي الأمر من احرف فقط');
          LnameParent.focus();
          notValidated = true;
         }

         var emailP = document.getElementById( "emailP" );
         var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
         if( !emailP.value.match(mailformat)){
           alert('.ارجوا ادخال بريد الكتروني صالح');
          emailP.focus();
          notValidated = true;}

          
          if(notValidated)
          e.preventDefault();

         });

addStudentForm.addEventListener('submit', async (e) => {

  e.preventDefault();
  
if(!notValidated){

  ////////////////////////
  
  const phoneNumber = parseInt(addStudentForm.phone.value);
 const q = query(collection(db, "Parent"), where("PhoneNumber", "==", phoneNumber));
  const querySnapshot = await getDocs(q);
  var parentId = "null";
  var docRef = "null";
  var docRefClass ="null";
  if(!querySnapshot.empty){
  querySnapshot.forEach((doc) => {
    if (!doc.empty)
      parentId = doc.id;

  else {
    alert("ولي الأمر غير مسجل، الرجاء اكمال البيانات");
    addStudentForm.reset()
  }
})
}

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
    const phonenumber = parseInt(addStudentForm.phone.value);
    if(parentId == "null"){
     addDoc(colRefParent, {
       FirstName: addStudentForm.FnameParent.value,
       LastName: addStudentForm.LnameParent.value,
       Email: addStudentForm.emailP.value,
       Password: addStudentForm.password.value,
       PhoneNumber:  phonenumber,
     }).then(() => {
       addStudentForm.reset()
     })
    }

    alert("تمت اضافة الطالب بنجاح")
   })
}


});

$( ".phone" ).change(async function() {
 
  var phoneNumber = parseInt(addStudentForm.phone.value);

  var q = query(collection(db, "Parent"), where("PhoneNumber", "==", phoneNumber));
  var querySnapshot = await getDocs(q);
  var parentId = "null";
  if(!querySnapshot.empty){
  querySnapshot.forEach((doc) => {
    if (!doc.empty)
    {
      parentId = doc.id;
      
    $("#FnameParent").val(doc.data().FirstName);
    $("#LnameParent").val(doc.data().LastName);
    $("#emailP").val(doc.data().Email);
    $("#password").val(doc.data().Password);
  }  
  })}else {
    alert("ولي الأمر غير مسجل، الرجاء اكمال البيانات");
    $("#FnameParent").val("");
    $("#LnameParent").val("");
    $("#emailP").val("");
    $("#password").val("");}



});


