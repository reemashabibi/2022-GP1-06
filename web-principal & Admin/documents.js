
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-analytics.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { collection, getDocs, addDoc, Timestamp, deleteDoc, getDoc, collectionGroup, arrayUnion,setDoc, updateDoc, doc, arrayRemove } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { query, orderBy, limit, where, onSnapshot } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-firestore.js";
import { getAuth, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-auth.js";
import { getStorage, ref, uploadBytes, getDownloadURL,deleteObject  } from "https://www.gstatic.com/firebasejs/9.12.1/firebase-storage.js";
// import firebase from "https://www.gstatic.com/firebasejs/9.12.1/firebase-app.js";
//import "https://www.gstatic.com/firebasejs/9.12.1/firebase-database.js";
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

// Initialize Cloud Storage and get a reference to the service
const storage = getStorage(app);




//Add class
var uid;
var email;
const auth = getAuth();

onAuthStateChanged(auth, (user) => {
    if (user) {
      // User is signed in, see docs for a list of available properties
      // https://firebase.google.com/docs/reference/js/firebase.User
       uid = user.uid;
        email = user.email
        
    } else {
      // User is signed out
      // ...
    }
  });
   
  let schoolID;



  export async function fillData(email) {
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email", "==", email)));
    snapshot.forEach(async doc => {
    const data = await getDoc(doc.ref.parent.parent);
    schoolID = data.id;
    const colRefClass = collection (db, "School",schoolID, "Class");
    getDocs(colRefClass) 
      .then(snapshot => {
        
        snapshot.docs.forEach(doc => {
          const new_op = document.createElement("option");
          new_op.innerHTML = doc.data().Level+ " :المرحلة"+" / "+ doc.data().ClassName + " :فصل";
          new_op.setAttribute("id", doc.id);
          new_op.setAttribute("value", doc.id);
          document.getElementById("classes").appendChild(new_op);
        })
       $(".loader").hide();
      });
    
    });
  
  }





export async function viewDocuments(){
    $('.loader').show();
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async Snap => {
    const school = await getDoc(Snap.ref.parent.parent);
    schoolID = school.id;
    
  
    
    const colRef = collection (db, "School",schoolID, "Class");

        const docsSnap = await getDocs(colRef);
        
        if(docsSnap.docs.length > 0) {
            var i=0;
           docsSnap.forEach( async (doc) => {
              var classDocs = doc.data().Documents;
              var className = doc.data().LevelName+"-"+doc.data().ClassName;


              
              var div2 = document.createElement('div');
              div2.className = "row";
              document.getElementById('allTabelsDiv').appendChild(div2);

              var div3 = document.createElement('div');
              div3.className = "col-lg-12";
              div2.appendChild(div3);

              var div4 = document.createElement('div');
              div4.className = "main-box no-header clearfix";
              div3.appendChild(div4);

              var div5 = document.createElement('div');
              div5.className = "main-box-body clearfix ";
              div4.appendChild(div5);

              var div6 = document.createElement('div');
              div6.className = "table-responsive";
              div6.id = 'tableArea'+i
              div5.appendChild(div6);

              var table = document.createElement('table');
                    table.ClassName = "table user-list";

                    var tableHead = document.createElement('thead');
                    var trHead = document.createElement('tr');
                    var th =  document.createElement('th');
                    var thSpan =  document.createElement('span');
                    thSpan.innerHTML = className;
                    th.colSpan = '2';

                    th.appendChild(thSpan);
                    trHead.appendChild(th);
                    tableHead.appendChild(trHead);
                    table.appendChild(tableHead);
                    div6.appendChild(table);
                    var tableBody

              if (classDocs.length >0 && classDocs[0] != "") {
                tableBody = document.createElement('tbody');
                //loop through documents of the class
                for(var j=0; j<classDocs.length;j++){
                    var ADocument = classDocs[j];
                  
                    const theDocOfClass = await getDoc(ADocument);
            
                    
                    var fileName = theDocOfClass.data().FileName;
                    var filepath = fileName+"@"+theDocOfClass.id;
                    var displayName = theDocOfClass.data().DisplayName;


                    

                    

                    var tr = document.createElement('tr');
                    
                    tableBody.appendChild(tr);

                     //delete button
                    var td = document.createElement('td');
                    td.className = 'deleteCell';
                    td.innerHTML = "<button class='btn btn-danger rounded-0 deletebtn' type='button' id='"+theDocOfClass.id+"'><i class='fa fa-trash'></i></button>";
                    tr.appendChild(td);
                    

                    // file 
                        var td2 = document.createElement('td');
                        tr.appendChild(td2);
                        
          
                        var a = document.createElement('a');
                        a.className = 'tdContent';
                       await getDownloadURL(ref(storage, filepath))
                        .then((url) => {
                            
                        // `url` is the download URL for the file
                        a.innerHTML = displayName;
                        a.href = url;
                       })
                      .catch((error) => {
                         // Handle any errors
                         a.innerHTML = "تعذر تحميل الملف";
                        });
                    
                        td2.appendChild(a);
                       

                }
                table.appendChild(tableBody);
              }
              i++;
           })

        }
   
 

   
    $('.loader').hide();
});
  }
  


  export async function viewStudentDocuments(stu){
    $('.loader').show();
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async Snap => {
    const school = await getDoc(Snap.ref.parent.parent);
    schoolID = school.id;
    
    const stuRef = doc (db, "School",schoolID, "Student", stu);

        const docsSnap = await getDoc(stuRef);
          
        const colRef = collection (db, "School",schoolID, "Student", stu, 'FilledDocuments');

        const docsFilled = await getDocs(colRef);


              var stuName = docsSnap.data().FirstName+" "+docsSnap.data().LastName;
              
              var div2 = document.createElement('div');
              div2.className = "row";
              document.getElementById('allTabelsDiv').appendChild(div2);

              var div3 = document.createElement('div');
              div3.className = "col-lg-12";
              div2.appendChild(div3);

              var div4 = document.createElement('div');
              div4.className = "main-box no-header clearfix";
              div3.appendChild(div4);

              var div5 = document.createElement('div');
              div5.className = "main-box-body clearfix ";
              div4.appendChild(div5);

              var div6 = document.createElement('div');
              div6.className = "table-responsive";
              div6.id = 'tableArea'
              div5.appendChild(div6);

              var table = document.createElement('table');
                    table.ClassName = "table user-list";

                    var tableHead = document.createElement('thead');
                    var trHead = document.createElement('tr');
                    var th =  document.createElement('th');
                    var thSpan =  document.createElement('span');
                    thSpan.innerHTML = " مستندات من ولي أمر الطالب "+stuName;
                    

                    th.appendChild(thSpan);
                    trHead.appendChild(th);
                    tableHead.appendChild(trHead);
                    table.appendChild(tableHead);
                    div6.appendChild(table);
                    var tableBody = document.createElement('tbody');
    
                if(docsFilled.docs.length > 0) {
                    docsFilled.forEach( async (doc) => {
                //loop through documents of the class
            
                   
                    var fileName = doc.data().FileName;
                    var filepath = fileName+"@"+doc.id;


                    var tr = document.createElement('tr');
                    tableBody.appendChild(tr);


                    // file 
                        var td2 = document.createElement('td');
                        tr.appendChild(td2);
          
                        var a = document.createElement('a');
                        a.className = 'tdContent';
                        getDownloadURL(ref(storage, filepath))
                        .then((url) => {
                            
                        // `url` is the download URL for the file
                        a.innerHTML = fileName;
                        a.href = url;
                        updateDoc(doc.ref, {Viewed: true})
                          .then(docRef => {
                          console.log("viewed");
                          })
                         .catch(error => {
                          console.log(error);
                           })
                           
                       })
                      .catch((error) => {
                         // Handle any errors
                         console.log(error);
                         a.innerHTML = "تعذر تحميل الملف";
                        });
                    
                        td2.appendChild(a);
                       
                    })
                table.appendChild(tableBody);
              
             
            
        }

        
   
 

   
    $('.loader').hide();
});
  }



  $(document).ready(function () {
    //delete document
    $(document).on('click', '.deletebtn', async function () {
      var docID = $(this).attr('id');
      const docRef = doc(db, 'School', schoolID, 'Documents', docID);
      var documentDoc = await getDoc(docRef);
      var classesRef = documentDoc.data().Classes;
        //get file name
        var fileName = $(this).closest('tr').find(".tdContent").html();

        if(confirm(" هل أنت تأكد حذف المستند؟")){
          $(".loader").show();
       await deleteDoc(docRef).then(async () =>{
            for(var r=0; r<classesRef.length; r++){
            await updateDoc(classesRef[r], {
                Documents: arrayRemove(docRef)
            });
        }
        // Create a reference to the file to delete
       const fileRef = ref(storage, fileName+"@"+docID);

       // Delete the file
       await deleteObject(fileRef).then(() => {
        // File deleted successfully
      }).catch((error) => {
      // Uh-oh, an error occurred!
        });

          $(".loader").hide();
          $(this).closest('tr').remove();
        })
        .catch(error => {
          $(".loader").hide();
          console.log(error);
        })
        }
       
    
    });
//add new document
$(document).on('submit', 'form', async function (e){

    const classDocForm = document.querySelector('.classForm');

    e.preventDefault()
    var selectedClass = document.getElementById("classes");
    var selectedClassIn = selectedClass[selectedClass.selectedIndex].value;
    if (selectedClassIn == "non") {
      document.getElementById('alertContainer').innerHTML='<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> يرجى اختيار فصل  </p> </div>';
      document.querySelector('.add').non.focus();
      return;
    }

    $('.loader').show();
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async docSnap => {
    const school = await getDoc(docSnap.ref.parent.parent);
    schoolID = school.id;
    
    const classRef = doc(db, 'School', schoolID, 'Class', classDocForm.classes.value );
    const DocsRef = collection(db, 'School', schoolID, 'Documents' );

    var file = document.getElementById("file").files[0];
    var format = /[@]/;
    if(format.test(file.name)){
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">@ يجب أن لا يحتوي اسم الملف على الرمز </p> </div>';
      $(".loader").hide();
      return;
    }

    var data = {
       Classes:  arrayUnion(classRef),
       FileName: file.name,
       DisplayName: classDocForm.Dname.value
    
     };
     
    await addDoc(DocsRef, data)
   .then(docRef => {

    const storageRef = ref(storage, file.name+"@"+docRef.id);
 
    uploadBytes(storageRef, file).then(async (snapshot) => {
        
      await  updateDoc(classRef, {Documents: arrayUnion( doc(db, 'School', schoolID, 'Documents', docRef.id)) })
        .catch(error => {
          $(".loader").hide();
            console.log(error);
        })
   
    });
    $(".loader").hide();
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner"> تمت الإضافة بنجاح</p> </div>';
})
   .catch(error => {
    $(".loader").hide();
    console.log(error);
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> حصل خطأ يرجى المحاولة لاحقًا </p> </div>';

  })

      
      })
});
$(document).on('click', 'changeNameSubmit',async function () {
  $('.loader').show();
  const DocForm = document.querySelector('.newDocNameForm');
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async docSnap => {
    const school = await getDoc(docSnap.ref.parent.parent);
    schoolID = school.id;
    
    const docRef = doc(db, 'School', schoolID, 'Documents', $('.inputbox input').attr('id'));

    await updateDoc(docRef, {DisplayName: DocForm.NewDocname.value})
    .then(docRef => {
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner"> تم التغيير بنجاح</p> </div>';

   })
   .catch(error => {
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> حصل خطأ يرجى المحاولة لاحقًا </p> </div>';

   })


})
})


  });
  
  