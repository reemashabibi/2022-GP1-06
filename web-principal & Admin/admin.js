
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { collection, getDocs, addDoc, Timestamp, deleteDoc  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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


//Delete student
function deleteStudent(sid){ 
  const colRefStudent = collection(db, "Student");

  getDocs(colRefStudent)
  .then(snapshot => {
     //console.log(snapshot.docs)
    //let levels = []
    snapshot.docs.forEach(doc => {
      if(doc.id == sid)
      deleteDoc(doc)
      .then(() => {
        //delete it from the admin home page.
      })
    })
    //console.log(levels)
  })

}



//Delete class
async function deleteClass(cid){ 
  const q = query(collection(db, "Student"), where("ClassId", "==", "/Class/"+cid));
  const querySnapshot = await getDocs(q);
  querySnapshot.forEach((doc) => {
    // doc.data() is never undefined for query doc snapshots
   // console.log(doc.id, " => ", doc.data());
    if(!doc.empty){
    alert("لا يمكن حذف الفصل، يوجد طلاب تابعين للفصل");
    return false;}
    else{
      deleteDoc(doc);
    }
  
  }); 
}

//Add class
const colRefClass = collection(db, "Class");

//const selectedClass = document.getElementById("classes");
//const selectedClassID = selectedClass[selectedClass.selectedIndex].id;

const addClassForm = document.querySelector('.addClass')
//email = document.getElementById( "email" ).value;
addClassForm.addEventListener('submit', async (e) => {
  e.preventDefault()
  addDoc(colRefClass, {
    ClassName: addClassForm.Cname.value,
    Level: addClassForm.level.value,
    schoolID:  "/School/"+parentId,
  })
  .then(() => { 
    
    addClassForm.reset()
  })
});
