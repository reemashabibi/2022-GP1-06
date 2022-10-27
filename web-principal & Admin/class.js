
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
        //console.log(snapshot.docs)
        //let levels = []
        snapshot.docs.forEach(doc => {
            //levels.push({ ...doc.data(), id: doc.id })
            const new_op = document.createElement("option");
            new_op.innerHTML = doc.id;
            new_op.setAttribute("id", doc.id);
            document.getElementById("classes").appendChild(new_op);
        })
        //console.log(levels)
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
   

var schoolID = "kfGIwTyclpNernBQqSpQhkclzhh1";
//const docRefSchool = doc(db,"School",schoolID);

//const colRefClass = collection (db, "School",schoolID, "Class");
// collection(db, "School").collection(db, "Class").doc(this.ClassName);
//schoolID.collection(db, "Class");
const classForm = document.querySelector('.addClassForm');
//const refrence = doc(db, "School", prid);
classForm.addEventListener('submit', async (e) => {
    e.preventDefault()
    
   // const snapshot = await getDoc(doc(db, 'Admin', uid));
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.docs.forEach(async doc => {
    //const data = await getDoc(doc.ref.parent.parent);
    //schoolID = data.id;
    const colRefClass = collection (db, "School",schoolID, "Class");
    addDoc(colRefClass, {
        ClassName: classForm.Cname.value,
        Level: parseInt(classForm.classes.value),
        Students: [],
    })
    .then(async docRef => { 
      classForm.reset()
      const refrence = doc(db, "School", schoolID,  "Class",docRef.id);
      let currentClass = await getDoc(refrence);
      const levelID = currentClass.data().Level;
      const qc = query(collection(db, "Level"), where("Number", "==", levelID ));
      const querySnapshotc = await getDocs(qc);
     querySnapshotc.forEach((d) =>{
       
        const colRefSubject = collection(db, "School",schoolID, "Class", docRef.id, "Subject");
        const subLength= d.data().Subjects;
        for(let i = 0; i < subLength.length; i++){
        addDoc(colRefSubject, {
        SubjectName: d.data().Subjects[i],
        TeacherID:  "",
      }).then(() => { 
        console.log("added")
      })}

            });

        })
    });
  
});