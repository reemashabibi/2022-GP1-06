
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc, getDoc, collectionGroup } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { doc,  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
// import firebase from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
//import "https://www.gstatic.com/firebasejs/9.12.1/firebase-database.js";
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

export { app, db, collection, getDocs, Timestamp, addDoc, doc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);


//add class to drop-down menu
const colRefLevel = collection(db, "Level");

getDocs(colRefLevel)
    .then(snapshot => {
       
        snapshot.docs.forEach(doc => {
            //levels.push({ ...doc.data(), id: doc.id })
            const new_op = document.createElement("option");
            new_op.innerHTML = doc.data().LevelName;
            new_op.setAttribute("id", doc.id);
            document.getElementById("classes").appendChild(new_op);
        })
        $(".loader").hide();
    })





//Add class
var uid;
var email;
const auth = getAuth();

onAuthStateChanged(auth, (user) => {
    if (user) {
      // User is signed in, see docs for a list of available properties
      // https://firebase.google.com/docs/reference/js/firebase.User
       uid = user.uid;
        email = user.email
        
    } else {
      // User is signed out
      // ...
    }
  });
   

let schoolID ;

const classForm = document.querySelector('.addClassForm');

classForm.addEventListener('submit', async (e) => {
    e.preventDefault()
    
    const specialChars = /[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
    if(classForm.Cname.value.match(specialChars))
    {
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">اسم الفصل يجب ان يتكون من حروف فقط</p> </div>';
    setTimeout(() => {
    
      // 👇️ replace element from DOM
      document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';

    }, 9000);
      return;
    }
    $('.loader').show();
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async docSnap => {
    const data = await getDoc(docSnap.ref.parent.parent);
    schoolID = data.id;
 
   const colRefClass = collection (db, "School",schoolID, "Class");
   const qClass = query(collection(db, "School", schoolID, "Class"), where("ClassName", "==", classForm.Cname.value), where("LevelName", "==",classForm.classes.value ));
   const queryClassSnapshot = await getDocs(qClass);
    if(queryClassSnapshot.empty){
      var options = document.getElementById('classes').options;
      var levelId = options[options.selectedIndex].id;
      
   await addDoc(colRefClass, {
        ClassName: classForm.Cname.value,
        LevelName: classForm.classes.value,
        Level: parseInt(levelId),
        Students: [],
        Documents: [],
    })
    .then(async docRef => { 
      classForm.reset();
      const refrence = doc(db, "School", schoolID, "Class", docRef.id);
      let currentClass = await getDoc(refrence);
      const levelName = currentClass.data().LevelName;
      const qc = query(collection(db, "Level"), where("LevelName", "==", levelName ));
      const querySnapshotc = await getDocs(qc);
     querySnapshotc.forEach(async(doc) =>{
       
        const colRefSubject = collection(db, "School",schoolID, "Class", docRef.id, "Subject");
        const subLength= doc.data().Subjects;
        for(let i = 0; i < subLength.length; i++){
       await addDoc(colRefSubject, {
        SubjectName: doc.data().Subjects[i],
        TeacherID:  "",
        customized: false 
      }).then(() => { 
        console.log("added")
      })}

            });
            $('.loader').hide();
document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner"> تمت إضافة الفصل بنجاح</p> </div>';
setTimeout(() => {
    
  // 👇️ replace element from DOM
  document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';

}, 9000);
        })
      }else{
        $(".loader").hide();
       document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">لم تتم الإضافة، يوجد فصل مُطابِق لاسم الفصل والمستوى</p> </div>';
       setTimeout(() => {
    
        // 👇️ replace element from DOM
        document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';

      }, 9000);
       classForm.reset();
      }
      })
});