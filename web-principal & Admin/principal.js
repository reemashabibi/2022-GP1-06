
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { collection, getDocs, addDoc, Timestamp, deleteDoc  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  //import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
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

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

 // const db = firebase.firestore();
  //db.settings({ timestampsInSnapshots: true});



  const auth = getAuth();
  const user= auth.currentUser
     onAuthStateChanged(auth, (user)=>{
         if(user){
             console.log("the same user");
         }
         else{
             window.location.href="index.html";
             console.log("the  user changed");
         }
     })



export async function callAdmins(sid){
  const refrence = doc(db, "School", sid);
  const q = collection(refrence, "Admin");
  
 
  var i=0;
  const querySnapshot = await getDocs(q);
  querySnapshot.forEach((doc) => {
    // doc.data() is never undefined for query doc snapshots
  
    var data = doc.data();
    var firstName = data.FirstName;
    var lastName = data.LastName;
    var email = data.Email

    const div1 = document.createElement("div");
    div1.className = "job-box d-md-flex align-items-center justify-content-between  mb-30";
    document.getElementById("bigdiv").appendChild(div1);
    const div5 = document.createElement("div");
    div5.className="job-right my-4 flex-shrink-0";
    const a1= document.createElement('button');
    a1.className="btn btn-danger rounded-0 deletebtn";
    a1.type = "button"
    a1.setAttribute('id', doc.ref.path);
    const i = document.createElement('i');
    i.className="fa fa-trash";
    a1.appendChild(i);
    div5.appendChild(a1);
    div1.appendChild(div5);




    const div2 = document.createElement("div");
    div2.className = "job-left my-4 d-md-flex align-items-center flex-wrap";
    div1.appendChild(div2);
    
    const div4 = document.createElement("div");
    div4.className= "job-content";
    div2.appendChild(div4);
    const h5 = document.createElement('h5');
    h5.className="text-center text-md-left";
    h5.appendChild( document.createTextNode(firstName+" "+lastName));
    div4.appendChild(h5);
   
    const ul1 = document.createElement("ul");
    ul1.className="d-md-flex flex-wrap text-capitalize ff-open-sans";
    div4.appendChild(ul1);
    const li1= document.createElement('li');
    li1.className="mr-md-4";
    ul1.appendChild(li1);
    const i1= document.createElement("i");
    i1.appendChild(document.createTextNode(email));
    i1.className="zmdi zmdi-email mr-2";
    li1.appendChild(i1);
   

  });
  $('.loader').hide();

}



$(document).ready(function () {
  $(document).on('click', '.deletebtn', async function () {
    var adminID = $(this).attr('id');
    const docRef = doc(db, adminID);
    if(confirm("هل تأكد حذف الإداري وجميع البيانات المتعلقة به؟")){
    deleteDoc(docRef).then(() => {
      alert("تم حذف الإداري");
      window.location.reload(true);
    })
      .catch(error => {
        console.log(error);
      })
    }
  
  });
});