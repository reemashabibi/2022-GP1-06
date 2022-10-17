import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "AIzaSyAk1XvudFS302cnbhPpnIka94st5nA23ZE",
    authDomain: "halaqa-89b43.firebaseapp.com",
    projectId: "halaqa-89b43",
    storageBucket: "halaqa-89b43.appspot.com",
    messagingSenderId: "969971486820",
    appId: "1:969971486820:web:40cc0abf19a909cc470f71",
    measurementId: "G-PCYTHJF1SD"
  };

  const app = initializeApp(firebaseConfig);
  const db = getFirestore(app);

  export { app, db, collection, getDocs, Timestamp, addDoc };
  export { query, orderBy, limit, where, onSnapshot }; 
  const analytics = getAnalytics(app);

  const colRef = collection(db, 'Admin');

//get collection data
  getDocs(colRef)
    .then((snapshot) => {
     let Admin = []
     snapshot.docs.forEach((doc)=> {
        Admin.push({...doc.data(), id: doc.id })
     })
     console.log(Admin)
    })
    .catch(err => {
        console.log(err.mssage)
    });
/////////////


    function pass(){
        var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
                var string_length = 8;
                var pass = '';
                for (var i=0; i<string_length; i++) {
                    var rnum = Math.floor(Math.random() * chars.length);
                    pass += chars.substring(rnum,rnum+1);
                }
            return pass;
        }


    //adding an admin
    const addAdminForm = document.querySelector('.addAdmin')
   // email = document.getElementById( "email" ).value;
   //var validationFailed = false;
    addAdminForm.addEventListener('submit',  async (e) => {
    e.preventDefault()
    //alert("added");
  //check if one exitsts
    const q = query(collection(db, "Admin"), where("Email", "==", addAdminForm.email.value));
    const querySnapshot = await getDocs(q);
    var exist = false;
    querySnapshot.forEach((doc) => {
        if(!doc.empty)
         exist = true;
         //alert("exist");
        // addAdminForm.reset()
      });

    if (!exist) {
        alert("added");
        addDoc(colRef, {
            Email: addAdminForm.email.value,
            FirstName: addAdminForm.firstName.value,
            LastName: addAdminForm.lastName.value, 
            password: pass(),
            //schoolID?
            schoolID: "/School/"+22,
        })
        .then (() => {
          addAdminForm.reset()
            //send an email
        })

    }
    else{
        alert("exist!!");
        addAdminForm.reset()
    }
    });




    //deleting an admin
