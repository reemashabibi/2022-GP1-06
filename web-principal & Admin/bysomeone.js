

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
  $(".loader").show();
    const docSnap = await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', email)));
    var schoolId = "";

    docSnap.forEach((doc) => {

      schoolId = doc.ref.parent.parent.id;
    });
    const reference = doc(db, "School", schoolId);
    const q = await collection(reference, "Student");
    const eee= query(q , orderBy("time","desc"));
    const ul1=document.getElementById("1");
    const today = new Date();
const monthNames = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];
const day=" "+monthNames[today.getMonth()]+" "+today.getDate();
    
    onSnapshot(eee,(querySnapshot)=>{
    //const querySnapshot = await getDocs(q);
   
    $(".loader").show();
while (ul1.hasChildNodes()) {
  ul1.removeChild(ul1.firstChild);
}

querySnapshot.forEach((doc)  => {

 // alert(doc.data().date==" Feb 26")
  if (doc.data().date==day && doc.data().someone=="yes"){
    const li = document.createElement("li");
    li.className = "table-row";
    li.id = doc.data().time;
    
   
    
    ul1.appendChild(li);
    
    
    /*const div1 = document.createElement("div");
    div1.className = "col col-1";
    div1.appendChild(document.createTextNode(doc.data().FirstName + " " + doc.data().LastName));
    div1.setAttribute('style','text-align:center; ')
    li.appendChild(div1);*/
    const span1 = document.createElement("div");
    span1.appendChild(document.createTextNode("اسم الطالب :"+doc.data().FirstName + " " + doc.data().LastName));

    span1.appendChild(document.createElement("br"));

    span1.appendChild(document.createTextNode("اسم الموكل لاستلام الطالب :"+doc.data().fullname + " " ));
    span1.appendChild(document.createElement("br"));
    span1.appendChild(document.createTextNode("رقم جوال الموكل   :"+doc.data().phone + " " ));
    span1.appendChild(document.createElement("br"));
    span1.appendChild(document.createTextNode(" رقم هوية الموكل :"+doc.data().nid + " " ));
    span1.setAttribute('style','text-align:center; ');
    //span1.className = "col col-1";
    li.appendChild(span1);
    //li.appendChild(document.createElement("br"));


    //alert(doc.data().time);
    

     

    
    
    //div1.appendChild(document.createElement('hr'));

  }


})

});
$(".loader").hide();
}



