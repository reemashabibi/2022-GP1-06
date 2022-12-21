

// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, collectionGroup, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc,documentId,arrayUnion,arrayRemove } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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



export async function viewStudents(email){
    const docSnap = await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', email)));
    var schoolId = "";

    docSnap.forEach((doc) => {

      schoolId = doc.ref.parent.parent.id;
    });
    const reference = doc(db, "School", schoolId);
    const q = await collection(reference, "Student");

    const querySnapshot = await getDocs(q);
querySnapshot.forEach((doc)  => {
  if (doc.data().picked=="no"){
    const div1 = document.createElement("div");
    div1.className = "job-box d-md-flex align-items-center justify-content-between mb-30 theTab ";
    div1.id = doc.data().id;
  

    document.getElementById("bigdiv").appendChild(div1);

    const div5 = document.createElement("div");
    div5.className = "job-right my-4 flex-shrink-0";
    div1.appendChild(div5);
    const div2 = document.createElement("div");
    div2.className = "job-left my-4 d-md-flex align-items-center flex-wrap";
 
    div1.appendChild(div2);

    const div4 = document.createElement("div");
    div4.className = "job-content";
    div2.appendChild(div4);
    const classlink = document.createElement('p');
    classlink.className = "text-center text-md-left";
    classlink.appendChild(document.createTextNode(doc.data().FirstName + " " + doc.data().LastName));
    classlink.id = "className";
    div4.appendChild(classlink);
    
    //div1.appendChild(document.createElement('hr'));

  }


})
}
