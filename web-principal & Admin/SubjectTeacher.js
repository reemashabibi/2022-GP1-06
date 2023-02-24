
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { collection, getDocs, addDoc, Timestamp, deleteDoc , getDoc, updateDoc, arrayRemove, arrayUnion   } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  //import { get, ref } from "https://www.gstatic.com/firebasejs/9.12.1//firebase-database.js"
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

//global var

var principalId;
var classId;
var globalTeachers;
var currentSubjects =[];
  export async function subjectTeacherForm(cid, sid){
    const classrefrence = doc(db, "School", sid, "Class", cid);
    const classData = await getDoc(classrefrence);
    var titleName= document.createTextNode(classData.data().LevelName+"-"+classData.data().ClassName);
    document.getElementById('title').appendChild(titleName);
    const q = collection(classrefrence, "Subject");
    principalId = sid;
    //get all teacher documents that are in the school
    const qteacher = collection(doc(db, "School", sid), "Teacher");
    const tacherQuerySnapshot = await getDocs(qteacher);

    //put all teachers in array
    let teachers = [];

    tacherQuerySnapshot.forEach((doc) =>{
    
      var firstName = doc.data().FirstName;
      var lastName = doc.data().LastName;
      var id = doc.id;
      teachers.push(id);
      teachers.push(firstName);
      teachers.push(lastName);
      
    });
    globalTeachers = teachers;

  

  const querySnapshot = await getDocs(q);

  if(querySnapshot.empty){
    alert('لا توجد مواد');
    $(".loader").hide();
}
var i=0;
  querySnapshot.forEach((subjectdoc) => {
    
  i++;
    var subject = subjectdoc.data().SubjectName;
currentSubjects.push(subject);
    var tr = document.createElement('tr');
    tr.id = subjectdoc.ref.path;
    

    //teacher drop down
    var td2 = document.createElement('td');
    tr.appendChild(td2);
   

    var dropdown = document.createElement("select");
    dropdown.name= "teacherAssign";
    dropdown.className="assign";
    td2.appendChild(dropdown);
    
    //first option
    var optionDefault = document.createElement("option");
    dropdown.appendChild(optionDefault);

    var teacherNotDeleted = false;
    if(subjectdoc.data().TeacherID != ""){
      for(var i=0; i<teachers.length;i++){
        if(teachers[i] == subjectdoc.data().TeacherID.id ){
          teacherNotDeleted = true;
          break;
      }

      }
      if(!teacherNotDeleted){
        const subjectdocRef = doc(db,subjectdoc.ref.path);

      const data = {
        TeacherID: ""
         };

       updateDoc(subjectdocRef, data)
           .then(subjectdocRef => {
             console.log("A New Document Field has been added to an existing document");
             optionDefault.innerHTML= "--لم يتم تعيين معلم--";
        optionDefault.value = "";
           })
        .catch(error => {
         console.log(error);
})
      }

    }
    if(subjectdoc.data().TeacherID == "" ){
        optionDefault.innerHTML= "--لم يتم تعيين معلم--";
        optionDefault.value = "";

    }
    else{
      
        for(var i=0; i<teachers.length;i++){
           
            if(teachers[i] == subjectdoc.data().TeacherID.id ){
                optionDefault.value = teachers[i];
                optionDefault.innerHTML = teachers[++i]+" "+teachers[++i];
                
            }
               
            else{
                i+=2 
            }
             
        }
       
    }
  
    
    for(var i=0; i<teachers.length;i++){
      if(subjectdoc.data().TeacherID != "" && teachers[i] == subjectdoc.data().TeacherID.id ){
        i+=2 
        
    }
       
    else{
      var option = document.createElement("option");
      option.value = teachers[i];
   option.innerHTML = teachers[++i]+" "+teachers[++i];
 
   dropdown.appendChild(option);
    }
     
      
      }

      //end of select teacher

      var td3 = document.createElement('td');
      tr.appendChild(td3);
     
      td3.innerText = subject+" ";
     
      tr.appendChild(td3);

    //checkbox

    var td = document.createElement('td');
    tr.appendChild(td);

    var input = document.createElement('input');
    input.type = 'checkbox';
    input.value = subject;
    input.name = 'chosensubjects[]';

    td.appendChild(input);

//end of check box

document.getElementById('content').appendChild(tr);
classId = cid;
  });

  }

  $('.loader').hide();




 

  $(document).ready(function() {
    

    $('#delete').click(function(){
         var arrId = [];
         var deleted = false;
        if($('input[name="chosensubjects[]"]:checked').length == 0){
          alert("ليتم حذف المواد/المادة يجب النقر على مربع تحديد واحد أو أكثر ");
          return;
        }
         if(confirm(" هل أنت متأكد من حذف هذه المواد/المادة وجميع البيانات المتعلقة بها؟")){
         $(':checkbox:checked').each(async function(){
              var id = $(this).closest('tr').attr('id');
              arrId.push(id); 
              
              const docRef = doc(db, id);
              const teachercol = collection(doc(db, "School", principalId), "Teacher");
              var teacher = await getDocs(query(teachercol, where("Subjects", "array-contains", docRef)));
              teacher.forEach( (subjectdoc) => {
                updateDoc(subjectdoc.ref, {
                  Subjects: arrayRemove(docRef)
              });
              });
           
             deleteDoc(docRef)
             .then(() => {
                console.log("Entire Document has been deleted successfully.");
                $(this).closest('tr').remove();
                deleted = true;
                })
            .catch(error => {
                console.log(error);
                deleted = false
            })

            const index = currentSubjects.indexOf($(this).val());
            if (index > -1) { // only splice array when item is found
              currentSubjects.splice(index, 1); // 2nd parameter means remove one item only
              } 

         })
if(deleted){
  alert("لقد تم حذف المواد");
}

        }
          
      });
var currentSubjectsWithoutSomeChar =[];
for (var l=0; l<currentSubjects.length; l++){
 //var str = currentSubjects[l].slice(2);
 currentSubjectsWithoutSomeChar.push(currentSubjects[l]);
}
console.log(currentSubjectsWithoutSomeChar);
      $('#add').click(function(){
        $('.loader').show();
        var subjectName = document.getElementById('sname').value;
        if(subjectName == ""){

          $('.loader').hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">لإضافة مادة يجب أن يتم تعبأة حقل اسم المادة</p> </div>';
          setTimeout(() => {
          
            // 👇️ replace element from DOM
            document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
      
          }, 5000);
        }
        else if(currentSubjects.indexOf(subjectName) !== -1 || currentSubjectsWithoutSomeChar.indexOf(subjectName) !== -1){

          $('.loader').hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">تمت إضافة هذه المادة مسبقًا للفصل</p> </div>';
          setTimeout(() => {
          
            // 👇️ replace element from DOM
            document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
      
          }, 5000);
          document.getElementById('sname').value="";
          
        }
        else{
        const dbRef = collection(doc(db,"School",principalId,"Class",classId), "Subject");

  

        const data = {
          SubjectName: subjectName,
          TeacherID: "",
          msg_count:0, 
          customized: false 
       };
       addDoc(dbRef, data)
        .then(docRef => {
          currentSubjects.push(subjectName);
          $('.loader').hide();
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> تمت إضافة المادة بنجاح</p> </div>';
          setTimeout(() => {
          
            // 👇️ replace element from DOM
            document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
      
          }, 5000);
          document.getElementById('sname').value= "";
          //add it to the table 
          
          //get all teacher documents that are in the school

      
          //put all teachers in array

        
      var i=0;

        i++;

      
          var tr = document.createElement('tr');
          tr.id ="School/"+principalId+"/Class/"+classId+"/Subject/"+docRef.id;
      
          //teacher drop down
          var td2 = document.createElement('td');
          tr.appendChild(td2);
          
      
          var dropdown = document.createElement("select");
          dropdown.name= "teacherAssign";
          dropdown.className="assign";
          td2.appendChild(dropdown);
          
          //first option
          var optionDefault = document.createElement("option");
          dropdown.appendChild(optionDefault);
      
              optionDefault.innerHTML= "--لم يتم تعيين معلم--";
              optionDefault.value = "";
              
          

          for(var i=0; i<globalTeachers.length;i++){
            var option = document.createElement("option");
                 option.value = globalTeachers[i];
              option.innerHTML = globalTeachers[++i]+" "+globalTeachers[++i];
            
              dropdown.appendChild(option);
            
            }
      
            //end of select teacher
      
            var td3 = document.createElement('td');
            tr.appendChild(td3);
            var label = document.createElement('h4');
            td3.innerText = data.SubjectName;
            td3.contentEditable  = true;
            tr.appendChild(td3);
      
          //checkbox
      
          var td = document.createElement('td');
          tr.appendChild(td);
      
          var input = document.createElement('input');
          input.type = 'checkbox';
          input.value = data.SubjectName;
          input.name = 'chosensubjects[]';
      
          td.appendChild(input);
      
      //end of check box
      document.getElementById('content').appendChild(tr);     
      $('.loader').hide();
         })
       .catch(error => {
        console.log(error);
        $('.loader').hide();
        document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ أثناء الإضافة، الرجاء المحاولة لاحقًا</p> </div>';
        setTimeout(() => {
        
          // 👇️ replace element from DOM
          document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
    
        }, 5000);
        $('.loader').hide();
       })
      
  }});


        $(window).keydown(function(event){
          if(event.keyCode == 13) {
            event.preventDefault();
            return false;
          }
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

            var teacherRef ="";

            if(teacherValue != ""){
               teacherRef = doc(db,"School",principalId, "Teacher", teacherValue);
            }

            const docRef = doc(db, rowid);
            

            const data = {
              SubjectName: subjectName,
              TeacherID: teacherRef,
              msg_count:0, 
          customized: false
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
         
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">تم حفظ جميع التعديلات</p> </div>';
          setTimeout(() => {
          
            // 👇️ replace element from DOM
            document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
      
          }, 5000);
        }
        else{
          document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">حصل خطأ، الرجاء المحاولة لاحقًا</p> </div>';
          setTimeout(() => {
          
            // 👇️ replace element from DOM
            document.getElementById('alertContainer').innerHTML = '<span style="color: rgb(157, 48, 48);" class="req">جميع الحقول مطلوبة*</span>';
      
          }, 5000);
        }
      }
        
          
          
        });


      
      
     
});



