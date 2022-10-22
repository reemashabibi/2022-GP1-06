import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAuth, signOut } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";;
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
    const auth = getAuth();

    const logout= document.querySelector(".signout");

    logout.addEventListener('click',  async (e) => {
      alert("lohhh");
      e.preventDefault()
      signOut(auth).then(() => {
        alert("تم تسجيل الخروج بنجاح");
        window.location.replace="index.html";
        }).catch((error) => {
        console.log(error.message);
        }); 

     })
   

