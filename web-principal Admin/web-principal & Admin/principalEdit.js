import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc , getDoc, updateDoc , doc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
import { getAuth, onAuthStateChanged , updatePassword, updateEmail, reauthenticateWithCredential,EmailAuthProvider} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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



  //const uid=user.uid;// "kfGIwTyclpNernBQqSpQhkclzhh1";
       
  //alert(uid);      



       
        
        const schoolName=document.getElementById("snameInp");
        const FirstName=document.getElementById("fnameInp");
        const LastName=document.getElementById("lnameInp");
        const Email=document.getElementById("emailInp");
        const Password=document.getElementById("passInp");
        


        
        export async function fillData(uid){
        
        const docRef= doc(db,"School",uid);
        await getDoc(docRef)
        .then((doc)=>{
            console.log(doc.data(), doc.id);
            //document.getElementById("snameInp").value=doc.data().schoolName;
            schoolName.value = doc.data().schoolName;
            FirstName.value=doc.data().PrincipalFirstName;
            LastName.value=doc.data().PrincipalLastName;
            Email.value=doc.data().Email;
            Password.value=auth.currentUser.Password;

        });
        $(".loader").hide();
        }
        const save = document.getElementById("subButton");
        const change =document.getElementById("change");

        save.addEventListener('click', async (e) => {
          e.preventDefault();
          if(!validate()){
            return false;
          }
          change.addEventListener('click', async (e) => {
            e.preventDefault();
            $(".loader").show();
            const oldPass= document.getElementById("authPass").value;
          const credential = await EmailAuthProvider.credential(auth.currentUser.email, oldPass);
          
          
          await reauthenticateWithCredential(auth.currentUser, credential).then(async () => {
           
            const q = query(collection(db, "School"), where("schoolName", "==", schoolName.value));
            const snapshot = await getDocs(q);
            var SchoolExist = false;
            if(!snapshot.empty){
              snapshot.forEach((doc) => {
                if(doc.data().Email != auth.currentUser.email){
                  $(".loader").hide();
                  document.getElementById("myForm").style.display = "none";
                  document.getElementById('alertContainer').innerHTML = '<div style=" margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">المدرسة مسجلة مسبقاً</p> </div>';
                  setTimeout(() => {
                    document.getElementById('alertContainer').innerHTML='';
                    
                  }, 9000);
                  SchoolExist = true ;
                  return;
                }
               //   exist = true;
              });
              if(SchoolExist){
                return;
              }
           
            }
      
            const docRef= doc(db,"School",auth.currentUser.uid);
            updateDoc(docRef,{
              schoolName:document.getElementById("snameInp").value,
              PrincipalFirstName: FirstName.value,
              PrincipalLastName:LastName.value,
              Email: Email.value,
            }).then(() => {
              if(Email.value!=auth.currentUser.email){
               updateEmail(auth.currentUser, Email.value);
              }   
              
            if (Password.value!="undefined"){
              updatePassword(auth.currentUser, Password.value);
            }
    
            document.getElementById("myForm").style.display = "none";
            $(".loader").hide();
            document.getElementById('alertContainer').innerHTML = '<div style=" margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner">تم حفظ التعديلات بنجاح</p> </div>';
            setTimeout(() => {
              document.getElementById('alertContainer').innerHTML='';
              
            }, 7000);
               });
  
       }).catch((error) => {
        
          if(error.message=="Firebase: Error (auth/wrong-password)."){
            $('.loader').hide();
            document.getElementById("myForm").style.display = "none";
            document.getElementById('alertContainer').innerHTML = '<div  style="margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">هناك خطأ في البريد الإلكتروني أو كلمة المرور</p> </div>';
            setTimeout(() => {
              document.getElementById('alertContainer').innerHTML='';
              
            }, 7000);
          }
          else{
          document.getElementById("myForm").style.display = "none";
          $(".loader").hide();
          document.getElementById('alertContainer').innerHTML = '<div style=" margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حدث خطأ يرجى المحاولة في وقتٍ لاحق</p> </div>';
          setTimeout(() => {
            document.getElementById('alertContainer').innerHTML='';
            
          }, 7000);
        }
          
      
          })
          });

          
          
           
  
     
      
    
    
    });
    function validate() {
  
      if(Email.value==""||Password.value=="" || FirstName.value==''|| LastName.value==''||document.getElementById("snameInp").value==''){
        document.getElementById("myForm").style.display = "none";
        document.getElementById('alertContainer').innerHTML = '<div  style="margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">جميع الحقول مطلوبة يرجى التحقق من تعبئتها </p> </div>';
        setTimeout(() => {
          document.getElementById('alertContainer').innerHTML='';
          
        }, 7000);
        return false;
      }
      else if (Password.value.length < 6) {
        document.getElementById("myForm").style.display = "none";
        document.getElementById('alertContainer').innerHTML = '<div  style="margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام </p> </div>';
        setTimeout(() => {
          document.getElementById('alertContainer').innerHTML='';
          
        }, 7000);
        return false;
      }
    
      else {
        return true;
       }
     }