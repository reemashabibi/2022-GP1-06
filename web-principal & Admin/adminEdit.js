import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, getDocs, addDoc, Timestamp, setDoc , getDoc, updateDoc , doc , collectionGroup} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
import { getAuth, onAuthStateChanged , updateEmail, updatePassword, EmailAuthProvider ,reauthenticateWithCredential} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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
    const change =document.getElementById("change");
    save.addEventListener('click', async (e) => {
     e.preventDefault();
     change.addEventListener('click', async (e) => {
      e.preventDefault();
     if(!validate()){
      return;
     }
     $(".loader").show();
     const oldPass= document.getElementById("authPass").value;
     
     const credential = await EmailAuthProvider.credential(auth.currentUser.email, oldPass);
          

    await reauthenticateWithCredential(auth.currentUser, credential).then(async (e) => {
           
  const docRef= await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', auth.currentUser.email)));

  docRef.forEach(async dooc => {

    var schoolid= dooc.ref.parent.parent.id;

    const reference=doc(db,"School",schoolid,"Admin",dooc.id);
    
   
    await updateDoc(reference,{
    FirstName: FirstName.value,
    LastName:LastName.value,
    Email: Email.value,
  
  }).then(() => {
    if(Email.value!=auth.currentUser.email){
     updateEmail(auth.currentUser, Email.value);
    }   
    
  if (Password.value!="undefined"){
    updatePassword(auth.currentUser, Password.value);
  }
  alert("تم حفظ التعديلات بنجاح");
  document.getElementById("myForm").style.display = "none";
  $(".loader").hide();
     }).catch(()=>{
      alert("حدث خطأ يرجى المحاولة في وقتٍ لاحق");
      document.getElementById("myForm").style.display = "none";
      $(".loader").hide();

    })
  })
  
   }).catch((error)=>{
    if(error.message=="Firebase: Error (auth/wrong-password)."){
      $('.loader').hide();

      alert("هناك خطأ في البريد الإلكتروني أو كلمة المرور ");
    }
    else{
    alert("حدث خطأ يرجى المحاولة في وقتٍ لاحق");
    document.getElementById("myForm").style.display = "none";
    $(".loader").hide();}

  })

  });
});
   function validate() {
  
    if(Email.value==""||Password.value==""){
      alert("جميع الحقول مطلوبة يرجى التحقق من تعبئتها");
      return false;
    }
    else if (Password.value.length < 6) {
      alert(" لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام ");
      return false;
    }
  
    else {
      return true;
     }
   }
    

    
    