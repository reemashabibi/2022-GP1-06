
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
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

export { app, db, collection, getDocs, Timestamp, addDoc, doc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);



//add class to drop-down menu
const colRefClass = collection(db, "Level");

getDocs(colRefClass)
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
var prid;
const classForm = document.querySelector('.addClassForm');
export async function addClass(pid) {
    prid = pid;
}
classForm.addEventListener('submit', async (e) => {
    const colRefClass = collection(db, "Class");
    const refrence = doc(db, "School", prid);
    e.preventDefault()
    addDoc(colRefClass, {
        ClassName: classForm.Cname.value,
        Level: parseInt(classForm.classes.value),
        SchoolID: refrence,
    })
    .then(async docRef => { 
      classForm.reset()
      const refrence = doc(db, "Class",  docRef.id);
      let currentClass = await getDoc(refrence);
      const levelID = currentClass.data().Level;
      const qc = query(collection(db, "Level"), where("Number", "==", levelID ));
      const querySnapshotc = await getDocs(qc);
     querySnapshotc.forEach((doc) =>{
       alert(doc.data().Number)
        const colRefTeacherClass = collection(db, "Teacher_Class");
        const subLength= doc.data().Subjects;
        for(let i = 0; i < subLength.length; i++){
        addDoc(colRefTeacherClass, {
        ClassID: refrence,
        Subject: doc.data().Subjects[i],
        TeacherID:  "",
      }).then(() => { 
        console.log("added")
      })}

            });

        })
});