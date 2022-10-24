
  // Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
  import { collection, getDocs, addDoc, Timestamp, deleteDoc , getDoc, updateDoc  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
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
//global var

var principalId;
var classId;
var globalTeachers;

  export async function subjectTeacherForm(cid, pid){
    principalId = pid;
    const refrence = doc(db, "Class", cid);
    const q = query(collection(db, "Teacher_Class"), where("ClassID", "==", refrence ));
    
    //get all teacher documents that are in the school
    const srefrence = doc(db, "School", pid);
    const qteacher = query(collection(db, "Teacher"), where("SchoolID", "==", srefrence ));
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
}
var i=0;
  querySnapshot.forEach((subjectdoc) => {
    
  i++;
    var subject = subjectdoc.data().Subject;

    var tr = document.createElement('tr');
    tr.id = subjectdoc.id;
    

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
        const subjectdocRef = doc(db, "Teacher_Class", subjectdoc.id);

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
    input.name = 'chosen subjects';

    td.appendChild(input);

//end of check box

document.getElementById('content').appendChild(tr);
classId = cid;
  });

  $('.loader').hide();
  }





 

  $(document).ready(function() {
    $('#delete').click(function(){
         var arrId = [];
         if(confirm(" هل أنت متأكد من حذف هذه المواد وجميع البيانات المتعلقة بها؟")){
         $(':checkbox:checked').each(function(){
              var id = $(this).closest('tr').attr('id');
              arrId.push(id); 
              
              const docRef = doc(db, "Teacher_Class", id);

             deleteDoc(docRef)
             .then(() => {
                console.log("Entire Document has been deleted successfully.");
                $(this).closest('tr').remove();
                })
            .catch(error => {
                console.log(error);
            })
              
         })
         alert("لقد تم حذف المواد");
        }
          
      });

      $('#add').click(function(){
        $('.loader').show();
        var subjectName = document.getElementById('sname').value;
        const dbRef = collection(db, "Teacher_Class");
        const refrence = doc(db, "Class", classId) ;

  

        const data = {
          ClassID: refrence,
          Subject: subjectName,
          TeacherID: "" 
       };
       addDoc(dbRef, data)
        .then(docRef => {

          var docid = docRef.id;
          console.log(docRef.id);
          alert(" تمت إضافة المادة بنجاح");
          document.getElementById('sname').value= "";
          //add it to the table 
          
          //get all teacher documents that are in the school

      
          //put all teachers in array

        
      var i=0;

        i++;

      
          var tr = document.createElement('tr');
          tr.id = docid;
      
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
            td3.innerText = data.Subject;
            td3.contentEditable  = true;
            tr.appendChild(td3);
      
          //checkbox
      
          var td = document.createElement('td');
          tr.appendChild(td);
      
          var input = document.createElement('input');
          input.type = 'checkbox';
          input.value = data.Subject;
          input.name = 'chosen subjects';
      
          td.appendChild(input);
      
      //end of check box
      document.getElementById('content').appendChild(tr);     
      $('.loader').hide();
         })
       .catch(error => {
        console.log(error);
        alert("حصل خطأ أثناء الإضافة، الرجاء المحاولة لاحقًا");
       })
      
      });


        $(window).keydown(function(event){
          if(event.keyCode == 13) {
            alert("not submiting");
            event.preventDefault();
            return false;
          }
        });



        $("form").on("submit", function (e) {
          e.preventDefault();
          if(confirm(" هل أنت متأكد من حفظ جميع التعديلات؟")){
          $("#codexpl tbody tr").each(function () {
            var rowid = $(this).attr('id');
            var dropdowncell =  $(this).find("td:eq(0)");
            var subjectName = $(this).find("td:eq(1)").text().trim();
            var selectObject = dropdowncell.find("select"); //grab the <select> tag assuming that there will be only single select box within that <td> 
            var teacherValue = selectObject.val(); // get the selected teacher id from current <tr>

            var teacherRef ="";

            if(teacherValue != ""){
               teacherRef = doc(db, "Teacher", teacherValue);
            }

            const docRef = doc(db, "Teacher_Class", rowid);

            const classRef = doc(db, "Class", classId);
            

            const data = {
              ClassID: classRef,
              Subject: subjectName,
              TeacherID: teacherRef
            };

            setDoc(docRef, data)
             .then(docRef => {
              console.log("Entire Document has been updated successfully");
             })
             .catch(error => {
                console.log(error);
                alert("حصل خطأ، الرجاء المحاولة لاحقًا");
              })

        })
        alert("تم حفظ جميع التعديلات");
      }
        
          
          
        });


      
      
     
});



