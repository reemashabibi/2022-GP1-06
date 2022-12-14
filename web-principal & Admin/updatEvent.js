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
const storage = getStorage(app);
var reference;
var srefrence
var eventID;
export async function updatEvent(eventId, schoolId){ 
     reference = doc(db,"School", schoolId,"Event", eventId);
     srefrence = doc(db, "School", schoolId);
    const qc = collection(srefrence, "Event");
    eventID=eventId;

    let event = await getDoc(reference);
document.getElementById("eventTitle").value=event.data().title;
document.getElementById("content").value=event.data().content;



if(event.data().image!=""){
    getDownloadURL(ref(storage, 'images/'+event.data().image))
    .then((url) => {
      
      const img = document.createElement("img");
      img.setAttribute('src', url);
      img.setAttribute('style','width:30%; hight:30%;')
      document.getElementById("foorm").appendChild(img);
    })

}
}
const save=document.getElementById("eventButton");
save.addEventListener('click', async (e) => {
  e.preventDefault();

const desertRef = ref(storage, document.querySelector("#image").files[0].name+eventID );

// Delete the file
await deleteObject(desertRef).then(() => {
  // File deleted successfully
}).catch((error) => {
  // Uh-oh, an error occurred!
});
const metadata = {
  contentType: document.querySelector("#image").files[0].type
};
const storageRef = ref(storage, 'images/' + document.querySelector("#image").files[0].name+eventID);
const uploadTask = await uploadBytesResumable(storageRef, document.querySelector("#image").files[0], metadata);

await updateDoc(reference,{
  title: document.getElementById("eventTitle").value,
  content: document.getElementById("content").value,
  image:document.querySelector("#image").files[0].name+eventID,

}).then(() => {
  alert("???? ?????????????? ??????????");
})
});