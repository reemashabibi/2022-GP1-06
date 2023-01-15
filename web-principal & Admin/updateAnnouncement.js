import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, collectionGroup, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
import { getAuth, createUserWithEmailAndPassword , updateProfile} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getStorage, uploadBytes, uploadBytesResumable ,getDownloadURL, ref, deleteObject} from "https://www.gstatic.com/firebasejs/9.12.1/firebase-storage.js";



const firebaseConfig = {
  apiKey: "AIzaSyAk1XvudFS302cnbhPpnIka94st5nA23ZE",
  authDomain: "halaqa-89b43.firebaseapp.com",
  projectId: "halaqa-89b43",
  storageBucket: "halaqa-89b43.appspot.com",
  messagingSenderId: "969971486820",
  appId: "1:969971486820:web:40cc0abf19a909cc470f71",
  measurementId: "G-PCYTHJF1SD",
  storageBucket:"gs://halaqa-89b43.appspot.com"
};
const app = initializeApp(firebaseConfig);


export { app, db, collection, getDocs, Timestamp, addDoc, setDoc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);
const auth = getAuth();



const db = getFirestore(app);
var reference;
var srefrence
var announcmentID;
export async function updateAnnouncement(annId, schoolId){ 
     reference = doc(db,"School", schoolId,"Announcement", annId);
     srefrence = doc(db, "School", schoolId);
    const qc = collection(srefrence, "Announcement");
    announcmentID=annId;

    let event = await getDoc(reference);
document.getElementById("eventTitle").value=event.data().title;
document.getElementById("content").value=event.data().content;




}
const save=document.getElementById("eventButton");
save.addEventListener('click', async (e) => {
  e.preventDefault();

  if(document.getElementById("Title").value ==''){
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> يجب تعيين عنوان للإعلان </p> </div>';
    setTimeout(() => {
            
      // 👇️ replace element from DOM
      document.getElementById('alertContainer').innerHTML ='';
    }, 5000);
    return false;
  }

await updateDoc(reference,{
  title: document.getElementById("Title").value,
  content: document.getElementById("content").value,
 

}).then(() => {

  $('.loader').hide();
  document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner">تم التعديل بنجاح </p> </div>';
  setTimeout(() => {
          
    // 👇️ replace element from DOM
    document.getElementById('alertContainer').innerHTML ='';
  }, 5000);
})
});