import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc , getDoc, updateDoc , doc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
import { getAuth, onAuthStateChanged , updateProfile} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth();
const user= auth.currentUser;

    export { app, db, collection, getDocs, Timestamp, addDoc };
    export { query, orderBy, limit, where, onSnapshot }; 

    const db = getFirestore(app);



const uid=auth.currentUser.uid;// "kfGIwTyclpNernBQqSpQhkclzhh1";
       
  alert(uid);      



       
        
        const schoolName=document.getElementById("snameInp");
        const FirstName=document.getElementById("fnameInp");
        const LastName=document.getElementById("lnameInp");
        const Email=document.getElementById("emailInp");
        const Password=document.getElementById("passInp");
        


        
        export async function fillData(uid){
        alert("docRef");
        docRef= doc(db,"School",uid);
        await getDoc(docRef)
        .then((doc)=>{
            console.log(doc.data(), doc.id);
            document.getElementById("snameInp").value=doc.data().SchoolName;
            FirstName.value=doc.data().PrincipalFirstName;
            LastName.value=doc.data().PrincipalLastName;
            Email.value=doc.data().Email;
            //Password.value=user.Password;

        });
        }
        const save = document.getElementById("subButton");
        save.addEventListener('click', async (e) => {
      e.preventDefault();
      const docRef= doc(db,"School",uid);
      
        updateProfile(auth.currentUser, {
          Email:Email.value , Password:Password.value
         }).then(() => {
            updateDoc(docRef,{
        SchoolName:document.getElementById("snameInp").value,
        PrincipalFirstName: FirstName.value,
        PrincipalLastName:LastName.value,
        Email: Email.value,
      })
  
         });
      
    
    
    })