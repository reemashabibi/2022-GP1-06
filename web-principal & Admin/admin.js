
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


 