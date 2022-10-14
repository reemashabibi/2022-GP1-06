
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { collection, getDocs, addDoc, Timestamp  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
    apiKey: "AIzaSyC6_nRiWvynsD9Fq11VfJt0AqAZmb0p-3g",
    authDomain: "first-intilazation.firebaseapp.com",
    databaseURL: "https://first-intilazation-default-rtdb.firebaseio.com",
    projectId: "first-intilazation",
    storageBucket: "first-intilazation.appspot.com",
    messagingSenderId: "217654697689",
    appId: "1:217654697689:web:c88301b0c4d92da9fb28c8",
    measurementId: "G-33Q0636T2D"
  };
  // Initialize Firebase
  //firebase.initializeApp(firebaseConfig);
  const app = initializeApp(firebaseConfig);
  const db = getFirestore(app);

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

 // const db = firebase.firestore();
  //db.settings({ timestampsInSnapshots: true});


var mainText = document.getElementById("mainText");
var submit = document.getElementById("submit");

function submitClick(){
    window.alert("working");
}

const colRef = collection(db, "Class");
const docsSnap = await getDocs(colRef);
docsSnap.forEach(doc => {
    console.log(doc.data());
});