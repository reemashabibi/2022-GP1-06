
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, collectionGroup, getDocs, addDoc, Timestamp, deleteDoc, getDoc, updateDoc,documentId,arrayUnion,arrayRemove } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
import { doc, setDoc } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
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

export async function checkUser(){
const auth = getAuth();
const user= auth.currentUser
   onAuthStateChanged(auth, (user)=>{
       if(user){
           console.log("the same user");
       }
       else{
           window.location.href="index.html";
           console.log("the  user changed");
       }
   })
}
export async function viewTachersAndClasses(aid){
  const docSnap = await getDocs(query(collectionGroup(db, 'Admin'), where('Email', '==', aid)));
  var sid = "";
  docSnap.forEach((doc) => {
   sid = doc.ref.parent.parent.id;
  });
  const refrence = doc(db, "School", sid);
  const q = collection(refrence, "Class");
  
  const qTeacher = collection(refrence, "Teacher");

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
  a2.setAttribute('id', doc.ref.path);
  const i = document.createElement('i');
  i.className="fa fa-trash";
  a2.appendChild(i);
 

    div5.className = "job-right my-4 flex-shrink-0";
    const a1 = document.createElement('a');
    a1.className = "btn d-inline w-100 d-sm-inline-inline btn-light";
    a1.appendChild(document.createTextNode("تعيين معلم"));
    a1.onclick = function () {
      location.href = "teacherSubjectClass.html?"+doc.id+"|"+sid;
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
    classlink.href="students.html?"+doc.id+"|"+sid;
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
   a2.setAttribute('id', doc2.ref.path);
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



var school = null;
var oldClass = null;
export async function viewStudents(classId, schoolId){
  const refrence = doc(db,"School", schoolId,"Class", classId);
  school = schoolId;
  oldClass= classId;
  //for dropdown
  var classes = [];
  const srefrence = doc(db, "School", schoolId);
  const qc = collection(srefrence, "Class");


  let currentClass = await getDoc(refrence);
  var CurrenrclassName = currentClass.data().ClassName;
  var Currentlevel = currentClass.data().Level;
  var CurrentClassid = currentClass.id;
  var CurrenrclassStudents = currentClass.data().Students;
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
  //end of dropdown data
  if (CurrenrclassStudents.length <=0) {
    alert("لا يوجد طلاب حاليًا في هذا الفصل.");
  }
 
  for(var j=0; j<CurrenrclassStudents.length;j++){
    var studentid = CurrenrclassStudents[j];
    alert(studentid.id);
  const d = await getDoc(studentid);


    var firstName = d.data().FirstName;
    var lastName = d.data().LastName;

    var phone = 0;
    var email = "";
     
      let data = await getDoc(d.data().ParentID);
        phone = data.data().Phonenumber;
        email = data.data().Email;

        var tr = document.createElement('tr');

 
tr.id = d.ref.path;

    


    var td5 = document.createElement('td');
    tr.appendChild(td5);

    var dropdown = document.createElement("select");
    dropdown.name = "transferClass";
    dropdown.className = "transfer";
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
    
    var td = document.createElement('td');
    td.style.width = "5%";
    tr.appendChild(td);
    var input = document.createElement('input');
    input.style.marginLeft = "1em";
    input.type = 'checkbox';
    input.value = firstName+" "+lastName;
    input.name = 'chosenstudents[]';
    td.appendChild(input);
    tr.appendChild(td)

    document.getElementById('schedule').appendChild(tr);


  };
  $('.loader').hide();
}


//put the delete student code here or it wil not work!!!!!!!!!!!! the same for delete class
$(document).ready(function () {
  $(document).on('click', '#delete', function () {
    if($('input[name="chosenstudents[]"]:checked').length == 0){
      alert("ليتم حذف الطالب/الطلاب يجب النقر على مربع تحديد واحد أو أكثر ");
      return;
    }
   var deleted = true;
    if(confirm("هل تأكد حذف الطالب/الطلاب وجميع البيانات المتعلقة به/بهم؟")){
      $(':checkbox:checked').each(async function(){

        var studentID = $(this).closest('tr').attr('id');
        const docRef = doc(db,studentID);
        const studentData = await getDoc(docRef);
        var parent = doc(db,"School",school, "Parent", studentData.data().parentID.id);
        var parentData = await getDoc(parent);
        const oldClassRef = doc(db,"School", school,"Class", oldClass);

        updateDoc(oldClassRef, {
          Students: arrayRemove(docRef)
      });
   ;
      if(parentData.data().Students.length == 1){
       await deleteDoc(parent).then(() => {
         deleted = true;
        
       }).catch(error => {
           console.log(error);
           alert("حصل خطأ، الرجاء المحاولة لاحقًا");
           deleted = false;
           return;
         })
     }else{
      await updateDoc(parent, {
        Students: arrayRemove(docRef)
    }).then(() => {
      deleted = true;
      
    })
      .catch(error => {
        console.log(error);
        deleted = false;
        alert("حصل خطأ، الرجاء المحاولة لاحقًا");
        return;
      });
     }
      deleteDoc(docRef).then(() => {
        $(this).closest('tr').remove();
        deleted = true;
       
      })
        .catch(error => {
          console.log(error);
          deleted = false;
          alert("حصل خطأ، الرجاء المحاولة لاحقًا");
          return;
        })


   })

 if(deleted){
  alert("تم حذف الطالب/الطلاب");
 }else{
  
 }
    }
  });

  $(document).on('click', '.deletebtnTeacher', async function () {
    var teacherID = $(this).attr('id');
    const docRef = doc(db, teacherID);
    if(confirm("هل تأكد حذف المعلم وجميع البيانات المتعلقة به؟")){
      var deleted =false;
      const d = await getDoc(docRef);
      if(d.data().Subjects.length >0){
        for(var s=0; s<d.data().Subjects.length; s++ ){
          var data = {
            TeacherID:  ""
          }
        updateDoc(d.data().Subjects[s], data)
         .then(docRef => {
          deleted = true;
        })
        .catch(error => {
          deleted= false;
          console.log(error);
        })
      }
      }
      
        if(deleted){
          deleteDoc(docRef).then(() => {
            alert("تم حذف المعلم");
          })
            .catch(error => {
              deleted= false;
              console.log(error);
            })
          
        }
        else{
          alert("حصل خطأ، الرجاء المحاولة لاحقًا.");
        }
    }

  });

  
});


$(document).ready(function () {
  $(document).on('click', '.deletebtn', async function () {
    var classID = $(this).attr('id');
    const docRef = doc(db, classID);
    var classDoc = await getDoc(docRef);
    if(classDoc.data().Students.length == 0){
      if(confirm(" هل أنت متأكد من حذف الفصل")){
      deleteDoc(docRef).then(() =>{
        alert("تم حذف الفصل");
        window.location.reload(true);
      })
      .catch(error => {
        console.log(error);
      })
      }
     }
     else{
      alert("هذا الفصل يحتوي على طلاب. ليتم حذف الفصل يجب ألا يحتوي على أي طالب.");
  }
  
  });
});


//trasfer student
$(document).ready(function () {

  $(document).on('change', '.transfer', async function () {
    var studentID = doc(db,$(this).closest('tr').attr('id'));
    
    var classId = $(this).val();
    const refrence =  doc(db,"School", school,"Class", classId);
    const oldClassRef = doc(db,"School", school,"Class", oldClass);
    if (confirm("هل تُأكد نقل الطالب إلى فصلٍ آخر؟")) {
      
      const data = {
        ClassID: refrence
      };
    
      updateDoc(studentID, data)
        .then(docRef => {
          console.log("Value of an Existing Document Field has been updated");
           updateDoc(refrence, {
            Students: arrayUnion(studentID)
        });
        updateDoc(oldClassRef, {
          Students: arrayRemove(studentID)
      });
          $(this).closest('tr').remove();
        })
        .catch(error => {
          console.log(error);
          alert(error);
        })
    }
    else{
      $('.transfer option:first').prop('selected',true);
    }

  });
});

$("form").on("submit", function (e) {
  e.preventDefault();
  var changed = true;
  if(confirm(" هل أنت متأكد من حفظ جميع التعديلات؟")){
  $("#codexpl tbody tr").each(function () {
    var rowid = $(this).attr('id');
    var dropdowncell =  $(this).find("td:eq(0)");
    var subjectName = $(this).find("td:eq(1)").text().trim();
    var selectObject = dropdowncell.find("select"); //grab the <select> tag assuming that there will be only single select box within that <td> 
    var teacherValue = selectObject.val(); // get the selected teacher id from current <tr>
alert(teacherValue);
    var teacherRef ="";

    if(teacherValue != ""){
       teacherRef = doc(db,"School",principalId, "Teacher", teacherValue);
    }

    const docRef = doc(db, rowid);
    

    const data = {
      SubjectName: subjectName,
      TeacherID: teacherRef
    };

    setDoc(docRef, data)
     .then(docref => {
      console.log("Entire Document has been updated successfully");
      if(teacherValue != "")
        updateDoc(teacherRef, {
        Subjects: arrayUnion(docRef)
    }).then(dicresfre =>{
    })
    
     })
     .catch(error => {
        console.log(error);
        changed = false;
      })

})
if(changed){
  alert("تم حفظ جميع التعديلات");
}
else{
  alert("حصل خطأ، الرجاء المحاولة لاحقًا");
}
}

  
  
});


