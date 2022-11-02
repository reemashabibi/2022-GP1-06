import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, getDocs, addDoc, Timestamp, setDoc , getDoc, updateDoc , doc , collectionGroup} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
import { getAuth, onAuthStateChanged , updateEmail, updatePassword} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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
const analytics = getAnalytics(app);
const auth = getAuth();
const user= auth.currentUser;
//const uid= user.uid;//"kfGIwTyclpNernBQqSpQhkclzhh1";


export { app, db, collection, getDocs, Timestamp, addDoc };
export { query, orderBy, limit, where, onSnapshot }; 

        const FirstName=document.getElementById("fnameInp");
        const LastName=document.getElementById("lnameInp");
        const Email=document.getElementById("emailInp");
        const Password=document.getElementById("passInp");

        const db = getFirestore(app);
        
       export async function fillData(uid){
            const docSnap = await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', auth.currentUser.email)));
            
            docSnap.forEach( async doc => {
              console.log(doc.data(), doc.id);
              FirstName.value=doc.data().FirstName;
              LastName.value=doc.data().LastName;
              Email.value=doc.data().Email;
              Password.value=auth.currentUser.Password;
          
            })
            $(".loader").hide();
    }

    const save = document.getElementById("subButton");
    save.addEventListener('click', async (e) => {
     e.preventDefault();
     $(".loader").show();

     if(!validate()){
      return;
     }
  const docRef= await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', auth.currentUser.email)));

  docRef.forEach( dooc => {

    var schoolid= dooc.ref.parent.parent.id;

    const reference=doc(db,"School",schoolid,"Admin",dooc.id);
    if(Email.value!=auth.currentUser.email){
   updateEmail(auth.currentUser, Email.value).then(async () => {
    await updateDoc(reference,{
    FirstName: FirstName.value,
    LastName:LastName.value,
    Email: Email.value,
  
  })
  if (Password.value!="undefined"){
    updatePassword(auth.currentUser, Password.value);
  }
  $(".loader").hide();
  alert("تم حفظ التعديلات بنجاح");

     }).catch(()=>{
      $(".loader").hide();
      alert("حصل خطأ، الرجاء المحاولة لاحقًا");
    })
  }
  else{
    if (Password.value!="undefined"){
      updatePassword(auth.currentUser, Password.value);
    }
    updateDoc(reference,{
      FirstName: FirstName.value,
      LastName:LastName.value,
      Email: Email.value,
    
    })
    $(".loader").hide();
    alert("تم حفظ التعديلات بنجاح");
  }
    

  })


   });
   function validate() {
  
    if(Email.value==""||Password.value==""){
      alert("جميع الحقول مطلوبة يرجى التحقق من تعبئتها");
      return false;
    }
    else if (password.value.length < 6) {
      alert(" لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام ");
      return false;
    }
  
    else {
      return true;
     }
   }
    

    
    