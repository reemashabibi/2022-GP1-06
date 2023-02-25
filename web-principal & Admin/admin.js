
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
    if(user.displayName=="Principal"){
      window.location.href="index.html";
      }
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
    var levelName = doc.data().LevelName;

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
    classlink.appendChild(document.createTextNode(levelName + "-" + className));
    classlink.href="students.html?"+doc.id+"|"+sid;
    classlink.id = "className";
    div4.appendChild(classlink);






  });

  $('.loader').hide();
  //view teachers
  const querySnapshot2 = await getDocs(qTeacher);

  querySnapshot2.forEach((doc2) => {
    // doc.data() is never undefined for query doc snapshots

    var firstName = doc2.data().FirstName;
    var lastName = doc2.data().LastName;
    var email = doc2.data().Email

    const div1 = document.createElement("div");
    div1.className = "job-box d-md-flex align-items-center justify-content-between mb-30 theTab";
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
    h5.className = "text-center text-md-right";
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


// view students
var school = null;
var oldClass = null;
var date = new Date().toJSON().slice(0,10);

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
  var Currentlevel = currentClass.data().LevelName;
  var CurrentClassid = currentClass.id;
  var CurrenrclassStudents = currentClass.data().Students;
  classes.push(CurrentClassid);
  classes.push(Currentlevel);
  classes.push(CurrenrclassName);
 var titleName= document.createTextNode(currentClass.data().LevelName+"-"+CurrenrclassName);
  document.getElementById('className').appendChild(titleName);
  const querySnapshotc = await getDocs(qc);
  querySnapshotc.forEach((doc) => {
    if (doc.id == classId) return;

    var className = doc.data().ClassName;
    var level = doc.data().LevelName;
    var id = doc.id;
    classes.push(id);
    classes.push(level);
    classes.push(className);
  });
  //end of dropdown data
  if (CurrenrclassStudents.length <=0) {
    
    var trNoStudents = document.createElement('tr');
    trNoStudents.style.textAlign = 'center';
    var tdNoStudnets = document.createElement('td');
    tdNoStudnets.colSpan = 6;
    tdNoStudnets.innerHTML = "لا يوجد طلاب حاليًا في هذا الفصل"
   trNoStudents.appendChild(tdNoStudnets);
   document.getElementById('schedule').appendChild(trNoStudents);
  }
 
  for(var j=0; j<CurrenrclassStudents.length;j++){
    var studentid = CurrenrclassStudents[j];
    
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

    
   var tdAbcense = document.createElement('td');
   tr.appendChild(tdAbcense);
   var abcenseBtn = document.createElement("button");
   abcenseBtn.className = "button-5";
   abcenseBtn.role = "button";

 
   tdAbcense.appendChild(abcenseBtn);
   abcenseBtn.textContent = "حاضر";
   tdAbcense.className = "in abcenseBtn";
   var abcense = await getDoc(doc(db, d.ref.path+'/Absence', date))
    if (abcense.exists()) {
      abcenseBtn.style.backgroundColor = "#fb8332";
      abcenseBtn.textContent = 'غائب';
      tdAbcense.className = "abcenseBtn out";
    }



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
   td4.className = 'notify';
    var a4 = document.createElement('a');
    a4.className = 'tdContent notification';
    var spanName = document.createElement('span');
    spanName.innerHTML = firstName + " " + lastName;
    a4.href = 'studentDocuments.html?'+d.id+"|";
    a4.appendChild(spanName);

    // notfication badge
    const colRef = collection (db, "School",schoolId, "Student", d.id, 'FilledDocuments');
    const docsFilled = await getDocs(colRef);
    var numOfNewDocs = 0;
    if(docsFilled.docs.length > 0) {
      docsFilled.forEach( async (doc) => {
  //loop through documents of the student
      if(doc.data().Viewed == false){
        numOfNewDocs++;
      }
    });
  }

  const absenceColRef = collection (db, "School",schoolId, "Student", d.id, 'Absence');
  const absences = await getDocs(absenceColRef);
  if(absences.docs.length > 0) {
    absences.forEach( async (doc) => {
//loop through absences of the student and check if an excuse is uploaded
    if(doc.data().Viewed == false && (doc.data().excuse != "" || (doc.data().FileName != null && doc.data().FileName != ''))){
      numOfNewDocs++;
    }
  });
}

      if(numOfNewDocs >0){

    var spanNotfiy = document.createElement('span');
    spanNotfiy.className = "badge";
    spanNotfiy.innerHTML= ""+numOfNewDocs;
    a4.appendChild(spanNotfiy);
      }

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

//delete student
$(document).ready(function () {
  $(document).on('click', '#delete', function () {
    if($('input[name="chosenstudents[]"]:checked').length == 0){
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">ليتم حذف الطالب/الطلاب يجب النقر على مربع تحديد واحد أو أكثر  </p> </div>';
      setTimeout(() => {
        document.getElementById('alertContainer').innerHTML='';
        
      }, 9000);
      return;
    }
   var deleted = true;
    if(confirm("هل تأكد حذف الطالب/الطلاب وجميع البيانات المتعلقة به/بهم؟")){
      $(':checkbox:checked').each(async function(){
        $(".loader").show();

        var studentID = $(this).closest('tr').attr('id');
        const docRef = doc(db,studentID);
        const studentData = await getDoc(docRef);
        var parent = doc(db,"School",school, "Parent", studentData.data().ParentID.id);
        var parentData = await getDoc(parent);
        const oldClassRef = doc(db,"School", school,"Class", oldClass);


      if(parentData.data().Students.length == 1){

        /////New code  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
        $.post("http://localhost:8080/deleteUser",
        {
          uid: parent.id,
       },
       function (data, stat) {
         if(data.status == 'Successfull'){
           deleteDoc(parent).then(() => {
            deleted = true;
            updateDoc(oldClassRef, {
              Students: arrayRemove(docRef)
          });
       ;
           }).catch(error => {
            console.log(error);
            $(".loader").hide();
        
            document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
            setTimeout(() => {
              document.getElementById('alertContainer').innerHTML='';
              
            }, 9000);
            deleted = false;
            return;
          })
         }
         else{
          deleted = false;
          $(".loader").hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
          setTimeout(() => {
            document.getElementById('alertContainer').innerHTML='';
            
          }, 9000);
         }

       
       });///End of new code


     }else{
      await updateDoc(parent, {
        Students: arrayRemove(docRef)
    }).then(() => {
      deleted = true;
      updateDoc(oldClassRef, {
        Students: arrayRemove(docRef)
    });
 ;
    })
      .catch(error => {
        console.log(error);
        deleted = false;
        $(".loader").hide();
        document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
        setTimeout(() => {
          document.getElementById('alertContainer').innerHTML='';
          
        }, 9000);
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
          $(".loader").hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
          setTimeout(() => {
            document.getElementById('alertContainer').innerHTML='';
            
          }, 9000);
          return;
        })


   })

 if(deleted){
  $(".loader").hide();

  document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner">تم حذف الطالب/الطلاب</p> </div>';
  setTimeout(() => {
    document.getElementById('alertContainer').innerHTML='';
    
  }, 9000);
 }else{
  
 }
    }
  });
//delete teacher
  $(document).on('click', '.deletebtnTeacher', async function () {
    var teacherID = $(this).attr('id');
    const docRef = doc(db, teacherID);
    if(confirm("هل تأكد حذف المعلم وجميع البيانات المتعلقة به؟")){
      $(".loader").show();
      var deleted =true;
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

            /////New code  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
         $.post("http://localhost:8080/deleteUser",
         {
           uid: docRef.id,
        },
        function (data, stat) {
          if(data.status == 'Successfull'){
            deleteDoc(docRef).then(() => {
              $(".loader").hide();
              window.location.reload(true);
            })
              .catch(error => {
                deleted= false;
                console.log(error);
              })
          }
          else{
            $(".loader").hide();
            document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
            setTimeout(() => {
              document.getElementById('alertContainer').innerHTML='';
              
            }, 9000);
          }
        });///End of new code

         /* deleteDoc(docRef).then(() => {
            $(".loader").hide();
            alert("تم حذف المعلم");
            window.location.reload(true);
          })
            .catch(error => {
              deleted= false;
              console.log(error);
            })*/
          
        }
        else{
          $(".loader").hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
          setTimeout(() => {
            document.getElementById('alertContainer').innerHTML='';
            
          }, 9000);
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
      if(confirm(" هل أنت تأكد حذف الفصل")){
        $(".loader").show();
      deleteDoc(docRef).then(() =>{
        $(".loader").hide();
        window.location.reload(true);
      })
      .catch(error => {
        $(".loader").hide();
        console.log(error);
      })
      }
     }
     else{
 
      document.getElementById('alertContainerClass').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">هذا الفصل يحتوي على طلاب. ليتم حذف الفصل يجب ألا يحتوي على أي طالب</p> </div>';
      setTimeout(() => {
        document.getElementById('alertContainerClass').innerHTML='';
        
      }, 9000);
  }
  
  });
  // check Absence
  $(document).on('click', '#saveAttendence', async function () {
   var abenceTaken;
   var breakOut;
   var i=0;

    $('#schedule tr').each( async function() {
      
      var refre =  $(this).attr('id');
      var abcense = await getDoc(doc(db, refre+'/Absence/'+date));
        if (abcense.exists()) {
          abenceTaken = true;
          breakOut = true;
      
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">لقد تم نسجيل الحضور مسبقًا لهذا الفصل</p> </div>';
          setTimeout(() => {
            document.getElementById('alertContainer').innerHTML='';
            
          }, 5000);
          return false;
        }
        else{
          abenceTaken = false;
        }
   if(breakOut) {
                breakOut = false;
                return false;
            } 
      var status = $(this).find("td:first").attr('class');
      if(status == "abcenseBtn out"){

       await setDoc(doc(db, refre+'/Absence', date), {
          excuse: "", 
          FileName: '' 
     });
     
    // start send notification
    var stu = await getDoc(doc(db, refre));
    var pref = stu.data().ParentID
    var parentDoc = await getDoc(pref);
            //send the notfication
            $.post("http://localhost:8080/absence",
            {
              token: parentDoc.data().token,
              stuRef: refre,
           },
           function (data, stat) {

           });
      }
       i++;
      if(abenceTaken == false && i==1){
              
        document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner">تم نسجيل الحضور</p> </div>';
        setTimeout(() => {
          document.getElementById('alertContainer').innerHTML='';
          
        }, 5000);
      }
              });
          
              
             
             
    

  });

  //to change the absence button color 
  $(document).on('click', '.abcenseBtn', async function () {
    var abcenseBtn = $(this);
    if($(this).text() == "حاضر"){
      $(this).find('button').css({backgroundColor: "#fb8332"});
      $(this).find('button').text('غائب');
      $(this).removeClass('in').addClass('out');
    }
    else{
      $(this).find('button').css({backgroundColor: "#9efa00"});
      $(this).find('button').text('حاضر'); 
      $(this).removeClass('out').addClass('in');
    }
  } );
   
});


//trasfer student
$(document).ready(function () {

  $(document).on('change', '.transfer', async function () {
    var studentID = doc(db,$(this).closest('tr').attr('id'));
    
    var classId = $(this).val();
    const refrence =  doc(db,"School", school,"Class", classId);
    const oldClassRef = doc(db,"School", school,"Class", oldClass);
    if (confirm("هل تُأكد نقل الطالب إلى فصلٍ آخر؟")) {
      $(".loader").show();

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
      $(".loader").hide();
          $(this).closest('tr').remove();
        })
        .catch(error => {
          console.log(error);
          alert(error);
        })
    }
    else{
      $(".transfer option:selected").prop("selected", false);
$(".transfer option:first").prop("selected", "selected");
    }

  });
});


