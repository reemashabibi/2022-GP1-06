
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
//import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
// import firebase from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
//import "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
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
//firebase.initializeApp(firebaseConfig);
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { app, db, collection, getDocs, Timestamp, addDoc, doc };
export { query, orderBy, limit, where, onSnapshot };
const analytics = getAnalytics(app);


export async function viewTachersAndClasses(aid){
  const adminDocrefrence = doc(db, "Admin", aid);
  const docSnap = await getDoc(adminDocrefrence);
  const refrence = doc(db, "School", docSnap.data().SchoolID);

  const q = query(collection(db, "Class"), where("SchoolID", "==", refrence));
  const qTeacher = query(collection(db, "Teacher"), where("SchoolID", "==", refrence));

  const querySnapshot = await getDocs(q);

  querySnapshot.forEach((doc) => {
    // doc.data() is never undefined for query doc snapshots

    var className = doc.data().ClassName;
    var level = doc.data().Level;

    const div1 = document.createElement("div");
    div1.className = "job-box d-md-flex align-items-center justify-content-between mb-30 theTab ";
    div1.id = level;
  

    document.getElementById("bigdiv").appendChild(div1);

    const div5 = document.createElement("div");

      //delete button
  const a2= document.createElement('button');
  a2.className="btn btn-danger rounded-0 deletebtn";
  a2.type = "button";
  a2.setAttribute('id', doc.id);
  const i = document.createElement('i');
  i.className="fa fa-trash";
  a2.appendChild(i);
 

    div5.className = "job-right my-4 flex-shrink-0";
    const a1 = document.createElement('a');
    a1.className = "btn d-inline w-100 d-sm-inline-inline btn-light";
    a1.appendChild(document.createTextNode("تعيين معلم"));
    a1.onclick = function () {
      location.href = "teacherSubjectClass.html?"+doc.id+"|";
  };

  div5.appendChild(a2);
  div5.appendChild(a1);
  div1.appendChild(div5);


    const div2 = document.createElement("div");
    div2.className = "job-left my-4 d-md-flex align-items-center flex-wrap";
 
    div1.appendChild(div2);

    const div4 = document.createElement("div");
    div4.className = "job-content";
    div2.appendChild(div4);
    const classlink = document.createElement('a');
    classlink.className = "text-center text-md-left";
    classlink.appendChild(document.createTextNode(className + "-" + level));
    classlink.href="students.html?"+doc.id+"|"+docSnap.data().SchoolID.id;
    classlink.id = "className";
    div4.appendChild(classlink);






  });

  $('.loader').hide();
  //view teachers
  const querySnapshot2 = await getDocs(qTeacher);

  if (querySnapshot2.empty) {
    alert("empty");
  }
  querySnapshot2.forEach((doc2) => {
    // doc.data() is never undefined for query doc snapshots

    var firstName = doc2.data().FirstName;
    var lastName = doc2.data().LastName;
    var email = doc2.data().Email

    const div1 = document.createElement("div");
    div1.className = "job-box d-md-flex align-items-center justify-content-between mb-30";
    document.getElementById("bigdiv2").appendChild(div1);
    const div5 = document.createElement("div");
    div5.className = "job-right my-4 flex-shrink-0";
   //delete button
   const a2= document.createElement('button');
   a2.className="btn btn-danger rounded-0 deletebtnTeacher";
   a2.type = "button"
   a2.setAttribute('id', doc2.id);
   const i = document.createElement('i');
   i.className="fa fa-trash";
   a2.appendChild(i);
    div5.appendChild(a2);


    div1.appendChild(div5);
    const div2 = document.createElement("div");
    div2.className = "job-left my-4 d-md-flex align-items-center flex-wrap";
    div1.appendChild(div2);

    const div4 = document.createElement("div");
    div4.className = "job-content";
    div2.appendChild(div4);
    const h5 = document.createElement('h5');
    h5.className = "text-center text-md-left";
    h5.appendChild(document.createTextNode(firstName + " " + lastName));
    div4.appendChild(h5);

    const ul1 = document.createElement("ul");
    ul1.className = "d-md-flex flex-wrap text-capitalize ff-open-sans";
    div4.appendChild(ul1);
    const li1 = document.createElement('li');
    li1.className = "mr-md-4";
    ul1.appendChild(li1);
    const i1 = document.createElement("i");
    i1.className = "zmdi zmdi-email mr-2";
    i1.appendChild(document.createTextNode(email));
    li1.appendChild(i1);


  });


//sort classes by level
$("#bigdiv > .theTab").sort(function(a, b) {
  return parseInt(a.id) - parseInt(b.id);
}).each(function() {
  var elem = $(this);
  elem.remove();
  $(elem).appendTo("#bigdiv");
});
}





export async function viewStudents(classId,school){
  const refrence = doc(db, "Class", classId);

  //for dropdown
  var classes = [];
  const srefrence = doc(db, "School", school);
  const qc = query(collection(db, "Class"), where("SchoolID", "==", srefrence));

  let currentClass = await getDoc(refrence);
  var CurrenrclassName = currentClass.data().ClassName;
  var Currentlevel = currentClass.data().Level;
  var CurrentClassid = currentClass.id;
  classes.push(CurrentClassid);
  classes.push(CurrenrclassName);
  classes.push(Currentlevel);

  const querySnapshotc = await getDocs(qc);
  querySnapshotc.forEach((doc) => {
    if (doc.id == classId) return;

    var className = doc.data().ClassName;
    var level = doc.data().Level;
    var id = doc.id;
    classes.push(id);
    classes.push(className);
    classes.push(level);
  });
  console.log(classes);
  //end of dropdown data

  const q = query(collection(db, "Student"), where("ClassID", "==", refrence));

  const querySnapshot = await getDocs(q);
  if (querySnapshot.empty) {
    alert("لا يوجد طلاب حاليًا في هذا الفصل.");
  }

  querySnapshot.forEach(async (d) => {

    var firstName = d.data().FirstName;
    var lastName = d.data().LastName;
    var parentId = d.data().ParentID;


    var phone = 0;
    var email = "";

    if (parentId) {
      let data = await getDoc(parentId);
      if (data.exists()) {
        phone = data.data().PhoneNumber;
        email = data.data().Email;
      }
    }


    var tr = document.createElement('tr');
    var td = document.createElement('td');
    td.style.width = "10%";
    tr.appendChild(td);


    var a2 = document.createElement('a');
    a2.className = "table-link danger";
    td.appendChild(a2);
    var span2 = document.createElement('span');
    span2.className = "fa-stack";
    a2.appendChild(span2);
    var i3 = document.createElement('i');
    var i4 = document.createElement('i');
    i3.className = "fa fa-square fa-stack-2x";
    i4.className = "fa fa-trash-o fa-stack-1x fa-inverse deltebtn";
    i4.href = "#";
    i4.id = d.id;
    span2.appendChild(i3);
    span2.appendChild(i4);

    var td5 = document.createElement('td');
    tr.appendChild(td5);

    var dropdown = document.createElement("select");
    dropdown.name = "transferClass";
    dropdown.className = "transfer";
    dropdown.id = d.id;
    td5.appendChild(dropdown);


    for (var i = 0; i < classes.length; i++) {
      var option = document.createElement("option");
      option.value = classes[i];
      option.innerHTML = classes[++i] + "-" + classes[++i];

      dropdown.appendChild(option);

    }


    var td2 = document.createElement('td');
    td2.innerHTML = phone;
    tr.appendChild(td2);

    var td3 = document.createElement('td');
    var a3 = document.createElement('a');
    a3.className = 'tdContent';
    a3.innerHTML = email;
    td3.appendChild(a3);
    tr.appendChild(td3);

    var td4 = document.createElement('td');
    var a4 = document.createElement('a');
    a4.className = 'tdContent';
    a4.innerHTML = firstName + " " + lastName;
    td4.appendChild(a4);
    tr.appendChild(td4);

    document.getElementById('schedule').appendChild(tr);


  });
  $('.loader').hide();
}


//put the delete student code here or it wil not work!!!!!!!!!!!! the same for delete class
$(document).ready(function () {
  $(document).on('click', '.deltebtn', function () {
    var studentID = $(this).attr('id');
    const docRef = doc(db, "Student", studentID);
    if(confirm("هل تأكد حذف الطالب وجميع البيانات المتعلقة به؟")){
    deleteDoc(docRef).then(() => {
      alert("تم حذف الطالب");
      window.location.reload(true);
    })
      .catch(error => {
        console.log(error);
      })
    }
  });

  $(document).on('click', '.deletebtnTeacher', function () {
    var teacherID = $(this).attr('id');
    const docRef = doc(db, "Teacher", teacherID);

    if(confirm("هل تأكد حذف المعلم وجميع البيانات المتعلقة به؟")){
      deleteDoc(docRef).then(() => {
        alert("تم حذف المعلم");
        window.location.reload(true);
      })
        .catch(error => {
          console.log(error);
        })
    }

  });

  
});


$(document).ready(function () {
  $(document).on('click', '.deletebtn', async function () {
    var classID = $(this).attr('id');
    const docRef = doc(db, "Class", classID);
    const q = query(collection(db, "Student"), where("ClassID", "==", docRef ));
    const querySnapshot = await getDocs(q);
    if(querySnapshot.empty){
      deleteDoc(docRef).then(() => {
        alert("تم حذف الفصل");
        window.location.reload(true);
      })
      .catch(error => {
        console.log(error);
      })
    }
    else{
      alert("هذا الفصل يحتوي على طلاب. ليتم حذف الفصل يجب ألا يحتوي على أي طالب.");
    }
    
  
  });
});


//trasfer student
$(document).ready(function () {

  $(document).on('change', '.transfer', async function () {
    var studentID = $(this).attr('id');
    var classId = $(this).val();
    const refrence = doc(db, "Class", classId);
    if (confirm("هل تُأكد نقل الطالب إلى فصلٍ آخر؟")) {
      
      const data = {
        ClassID: refrence
      };
      const docRef = doc(db, "Student", studentID);
      updateDoc(docRef, data)
        .then(docRef => {
          console.log("Value of an Existing Document Field has been updated");

          $(this).closest('tr').remove();
        })
        .catch(error => {
          console.log(error);
        })
    }
    else{
      $('.transfer option:first').prop('selected',true);
    }

  });
});




