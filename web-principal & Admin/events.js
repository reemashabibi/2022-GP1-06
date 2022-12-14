import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { collection, collectionGroup, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get} from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js";
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
      
  
  
      const db = getFirestore(app);
      const storage = getStorage(app);


export async function viewEvents(email){
   
    
    const docSnap = await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', email)));
    var schoolId = "";

  docSnap.forEach((doc) => {

    schoolId = doc.ref.parent.parent.id;
    
  });
  const reference = await doc(db, "School", schoolId);
  const q = await collection(reference, "Event");

  var i=0;
const querySnapshot = await getDocs(q);
querySnapshot.forEach((doc)  => {
 


  var data = doc.data();
  var title = data.title;
  var content = data.content;
  var image = data.image;
  const div1 = document.createElement("div");
  div1.id = doc.id;
  
  document.getElementById("bigdiv").appendChild(div1);
  const div5 = document.createElement("div");

  const div4 = document.createElement("H5");
  div4.className = "paragraphStyle";
  div4.appendChild(document.createTextNode(title));
  div1.appendChild(div4);

  if (content!=""){

    const div0 = document.createElement("p");
    div0.className = "paragraphStyle";
    div0.appendChild(document.createTextNode(content));
    div1.appendChild(div0);

  }

  if(image!=""){
    getDownloadURL(ref(storage, 'images/'+image))
     .then((url)  => {
       
      const div6 = document.createElement("div");
       const img = document.createElement("img");
       img.setAttribute('src', url);
       img.setAttribute('style','width:40%; hight:40%; margin-left:18%; ');
       img.setAttribute('scrypt','onclick=window.location.href="'+url+'"');
       
       div5.appendChild(img);
       
     })
     .catch((error) => {
       // Handle any errors
     });
     }
  






  //delete button
const a2= document.createElement('button');
a2.className="btn btn-danger rounded-0 deletebtn";
a2.type = "button";
a2.setAttribute('id', doc.ref.path);
const i = document.createElement('i');
i.className="fa fa-trash";
a2.appendChild(i);



div5.className = "job-right my-4 flex-shrink-0";
const a1 = document.createElement('a');
a1.className = "btn d-inline w-100 d-sm-inline-inline btn-light";
a1.appendChild(document.createTextNode(" ??????????"));
a1.onclick = function () {
  location.href = "updateEvent.html?"+doc.id+"|"+schoolId;
};

div5.appendChild(a2);
div5.appendChild(a1);
 div1.appendChild(div5);

 

div1.appendChild(document.createElement('hr'));



});



}



$(document).ready(function () {
  $(document).on('click', '.deletebtn', async function () {
    var eventID = $(this).attr('id');
    const docRef = doc(db, eventID);
    var eventDoc = await getDoc(docRef);
    const desertRef = ref(storage, "images/"+eventDoc.data().image );

    // Delete the file
    await deleteObject(desertRef).then(() => {
      // File deleted successfully
    });
     await deleteDoc(docRef).then(() =>{
        $(".loader").hide();
        alert("???? ?????????? ");
        window.location.reload(true);
      })
      .catch(error => {
        $(".loader").hide();
        console.log(error);
      })
      
   
  
  });
});