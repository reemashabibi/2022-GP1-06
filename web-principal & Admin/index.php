<?php
echo "hi";
?>
<script type="module"> //Copy and paste these scripts into the bottom of your <body> tag, but before you use any Firebase services
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  const firebaseConfig = {
    apiKey: "AIzaSyC6_nRiWvynsD9Fq11VfJt0AqAZmb0p-3g",
    authDomain: "first-intilazation.firebaseapp.com",
    databaseURL: "https://first-intilazation-default-rtdb.firebaseio.com",
    projectId: "first-intilazation",
    storageBucket: "first-intilazation.appspot.com",
    messagingSenderId: "217654697689",
    appId: "1:217654697689:web:939fa6b9f67413d8fb28c8",
    measurementId: "G-P777M0V91L"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
</script>