
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
          new_op.innerHTML = doc.data().LevelName+"-"+doc.data().ClassName;
          new_op.setAttribute("id", doc.id);
          new_op.setAttribute("value", doc.id);
          document.getElementById("classes").appendChild(new_op);
        })
       $(".loader").hide();
       let mySelect = new vanillaSelectBox("#classes", {

        placeHolder: "--اختر الفصل--",
        translations: { 
          "all": "الكل", 
          "item": "item",
          "items": "items", 
          "selectAll": "اختيار الكل", 
          "clearAll": "ازالة الكل" 
        },
       });
      });
    
    });
  
  }

  export async function preFillData(email, docId) {
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email", "==", email)));
    snapshot.forEach(async d => {
    const data = await getDoc(d.ref.parent.parent);
    schoolID = data.id;
    const docRef = doc(db, "School",schoolID, "Documents",docId);

    try {
      const docSnap = await getDoc(docRef);
      if(docSnap.exists()) {
        document.getElementById("NewDocname").value = docSnap.data().DisplayName;
        var filepath = docSnap.data().FileName+"@"+docId;

        await getDownloadURL(ref(storage, filepath))
                        .then((url) => {
                            
                        // `url` is the download URL for the file
                        document.getElementById('docLink').innerHTML = '  <a style= "font-size: 18px;" href="'+url+'">'+docSnap.data().DisplayName+'</a> ';

                       })
                      .catch((error) => {
                         // Handle any errors
                         document.getElementById('docLink').innerHTML =  "تعذر تحميل الملف";
                        });
                    

        $(".loader").hide();
      } else {
          console.log("Document does not exist")
      }
  
  } catch(error) {
      console.log(error)
  }      
      
     
    
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
                    thSpan.innerHTML = " مستندات الفصل "+className;
                    
                   
                    var th2 =  document.createElement('th');
                    var thSpan2 =  document.createElement('span');
                    thSpan2.innerHTML = '<a href= "students.html?'+doc.id+'|'+schoolID+'">طلاب الصف</a>';
                    th2.style.textAlign = 'left';
                    th2.style.paddingLeft = '1%' ;
                    
                    th2.appendChild(thSpan2);
                    trHead.appendChild(th2);

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
                    var filepath = 'School Files/'+fileName+"@"+theDocOfClass.id;
                    var displayName = theDocOfClass.data().DisplayName;


                    

                    

                    var tr = document.createElement('tr');
                    
                    tableBody.appendChild(tr);

                     //delete button & edit button
                    var td = document.createElement('td');
                    td.className = 'deleteCell';
                
                    td.innerHTML = "<button class='btn btn-danger rounded-0 deletebtn' type='button' id='"+theDocOfClass.id+"'><i class='fa fa-trash'></i></button> <a class='btn d-inline w-100 d-sm-inline-inline btn-light' href = 'editDocument.html?"+theDocOfClass.id+"|'>تعديل المستند</a>";
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
                    th.colSpan= 2;
                    var thSpan =  document.createElement('span');
                    thSpan.innerHTML = " مستندات من ولي أمر الطالب "+stuName;
                    
                    var trHead2 = document.createElement('tr');//row for 2nd row titels
                    trHead2.style.fontWeight = 'bolder';
                    
                    
                    var th2 =  document.createElement('td');
                   
                    th2.innerHTML = "  اسم مستند ولي أمر الطالب ";

                    var th3 =  document.createElement('td');
               
                    th3.innerHTML = "  اسم المستند ";


                    th.appendChild(thSpan);
                    trHead.appendChild(th);
                    tableHead.appendChild(trHead);
                    
                    trHead2.appendChild(th2);
                    trHead2.appendChild(th3);

                   

                    table.appendChild(tableHead);
                    div6.appendChild(table);
                    var tableBody = document.createElement('tbody');
                    tableBody.appendChild(trHead2);
                    
                    var classDocsRef = [];
                if(docsFilled.docs.length > 0) {
                  var i = 0;
                    docsFilled.forEach( async (doc) => {
                //loop through documents of the class
            
                 // this code is to put the documents uploaded for the same file in one cell
                    var schoolFileRef= doc.data().DocumentID;
                    const schoolFileDocSnap = await getDoc(schoolFileRef);

 
                    if(classDocsRef.indexOf(schoolFileDocSnap.id)<0 || classDocsRef.length == 0)//check if id already in
                          classDocsRef.push(schoolFileDocSnap.id); 
                    else{
                     
                      var a_anotherdoclink = document.createElement('a');
                      a_anotherdoclink.className = 'tdContent';
                      getDownloadURL(ref(storage, "Parent Files/"+doc.data().FileName+"@"+doc.id))
                      .then((url) => {
                          
                      // `url` is the download URL for the file
                      a_anotherdoclink.innerHTML = "<br>"+doc.data().FileName;
                      a_anotherdoclink.href = url;
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
                       a_anotherdoclink.innerHTML = "تعذر تحميل الملف";
                      });
                      var cells = document.getElementById(classDocsRef.indexOf(schoolFileDocSnap.id)).getElementsByTagName('td');
                      cells[0].appendChild(a_anotherdoclink);
                      return;
    
                    }// end of it

// if it is for another document responce complete the code
                    var fileName = doc.data().FileName;
                    var filepath = "Parent Files/"+fileName+"@"+doc.id;

                    var schoolFilePath = 'School Files/'+schoolFileDocSnap.data().FileName+'@'+schoolFileDocSnap.id;


                    var tr = document.createElement('tr');
                    tableBody.appendChild(tr);
                    tr.id = i;
                    i++;
                    


                    // file 
                        var td2 = document.createElement('td');//Admin file cell
                        var td = document.createElement('td');//Parent file cell

                        tr.appendChild(td);
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
                    
                        td.appendChild(a);


                        //cell of School/Admin file
                        var a2 = document.createElement('a');
                        a2.className = 'tdContent';
                        getDownloadURL(ref(storage, schoolFilePath))
                        .then((url) => {
                            
                        // `url` is the download URL for the file
                        a2.innerHTML = schoolFileDocSnap.data().DisplayName;
                        a2.href = url;
                           
                       })
                      .catch((error) => {
                         // Handle any errors
                         console.log(error);
                         a2.innerHTML = "تعذر تحميل الملف";
                        });
                    
                        td2.appendChild(a2);
                       
                    })
                table.appendChild(tableBody);
              
             
            
        }//end of the parent filled documents

        //start of view student abcense excuse

        var absencediv2 = document.createElement('div');
        div2.className = "row";
        document.getElementById('allTabelsDiv').appendChild(absencediv2);

         var absencediv3 = document.createElement('div');
        div3.className = "col-lg-12";
        absencediv2.appendChild(absencediv3);

         var absencediv4 = document.createElement('div');
         absencediv4.className = "main-box no-header clearfix";
         absencediv3.appendChild(absencediv4);

         var absencediv5 = document.createElement('div');
         absencediv5.className = "main-box-body clearfix ";
         absencediv4.appendChild(absencediv5);

         var absencediv6 = document.createElement('div');
         absencediv6.className = "table-responsive";
         absencediv6.id = 'tableArea'
         absencediv5.appendChild(absencediv6);

        var absencetable = document.createElement('table');
        absencetable.ClassName = "table user-list";

               var absencetableHead = document.createElement('thead');
               var absencetrHead = document.createElement('tr');
               var absenceth =  document.createElement('th');
               absenceth.colSpan= 3;
               var absencethSpan =  document.createElement('span');
               absencethSpan.innerHTML = " غياب الطالب "+stuName;

               var absencetrHead2 = document.createElement('tr');//row for 2nd row titels
               absencetrHead2.style.fontWeight = 'bolder';

                     var absenceth2 =  document.createElement('td');
                     absenceth2.innerHTML = "  مستند عذر غياب";

                   var absenceth3 =  document.createElement('td');
                   absenceth3.innerHTML = " عذر كتابي ";

                    
                   var absenceth4 =  document.createElement('td');
                   absenceth4.innerHTML = "  تاريخ الغياب ";

                   absencetrHead2.appendChild(absenceth2);
                   absencetrHead2.appendChild(absenceth3);
                   absencetrHead2.appendChild(absenceth4);

                   absenceth.appendChild(absencethSpan);
                   absencetrHead.appendChild(absenceth);
                   absencetableHead.appendChild(absencetrHead);

              absencetable.appendChild(absencetableHead);
              absencediv6.appendChild(absencetable);
              var absencetableBody = document.createElement('tbody');
              absencetableBody.appendChild(absencetrHead2);
              const absenceCollection = collection (db, "School",schoolID, "Student", stu, 'Absence');

              const absensces = await getDocs(absenceCollection);

              if(absensces.docs.length > 0) {

                absensces.forEach( async (doc) => {

                  var fileName = doc.data().FileName;
                  var filepath = "Parent Files/"+fileName+stu+"@"+doc.id;


                  var tr = document.createElement('tr');
                  absencetableBody.appendChild(tr);
              
                
                  // absence row data 
                      var td3 = document.createElement('td');//date of absence  cell
                      var td2 = document.createElement('td');//excuse text cell
                      var td = document.createElement('td');//excuse file cell

                      tr.appendChild(td);
                      tr.appendChild(td2);
                      tr.appendChild(td3);

                      td3.innerHTML = doc.id;

                      if(fileName != null && fileName != ''){
                      var a = document.createElement('a');
                      a.className = 'tdContent';
                      getDownloadURL(ref(storage, filepath))
                      .then((url) => {
                          
                      // `url` is the download URL for the file
                      a.innerHTML = fileName;
                      a.href = url;
                         
                     })
                    .catch((error) => {
                       // Handle any errors
                       console.log(error);
                       a.innerHTML = "تعذر تحميل الملف";
                      });
                  
                      td.appendChild(a);
                    }
                    else{
                      td.innerHTML = "لم يتم ارفاق ملف";
                      td.style.color = 'red';
                    }
                    
                    
                    if(doc.data().excuse != "")
                    td2.innerHTML = doc.data().excuse;
                    else{
                    td2.innerHTML = "لم يتم ارفاق عذر كتابي";
                    td2.style.color = 'red';
                    }

                    if(doc.data().excuse != "" || (fileName != null && fileName != ''))
                    updateDoc(doc.ref, {Viewed: true})
                    .then(docRef => {
                    console.log("viewed");
                    })
                   .catch(error => {
                    console.log(error);
                     })


                  });
                  absencetable.appendChild(absencetableBody);

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
       const fileRef = ref(storage, 'School Files/'+fileName+"@"+docID);

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
$(document).on('submit', '.docForm', async function (e){

    const classDocForm = document.querySelector('.docForm');

    e.preventDefault()
    var selectedClasses = $('#classes').val();
    
    $('.loader').show();
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async docSnap => {
    const school = await getDoc(docSnap.ref.parent.parent);
    schoolID = school.id;

    var classesRef = [];
    for(var k=0; k<selectedClasses.length; k++){
       classesRef[k] = doc(db, 'School', schoolID, 'Class', selectedClasses[k] );
    }
    
    const DocsRef = collection(db, 'School', schoolID, 'Documents' );

    var file = document.getElementById("file").files[0];
    var format = /[@]/;
    if(format.test(file.name)){
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner">@ يجب أن لا يحتوي اسم الملف على الرمز </p> </div>';
      $(".loader").hide();
      return;
    }
    let allowParentUpload = true;
if(!classDocForm.allowReply.checked){
  allowParentUpload = false;
}
    var data = {
       Classes:  classesRef,
       FileName: file.name,
       DisplayName: classDocForm.Dname.value,
       AllowReply: allowParentUpload
     };
     
    await addDoc(DocsRef, data)
   .then(async docRef => {

    const storageRef = ref(storage, 'School Files/'+file.name+"@"+docRef.id);
 
     await uploadBytes(storageRef, file).then(async (snapshot) => {
      for(var k=0; k<selectedClasses.length; k++)
         await updateDoc(classesRef[k], {Documents: arrayUnion( doc(db, 'School', schoolID, 'Documents', docRef.id)) })
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
//edit uploaded document
$(document).on('click', '.changeDocSubmit',async function (e) {
  e.preventDefault();

  $('.loader').show();
  const DocForm = document.querySelector('.changeDocForm');
    const snapshot = await getDocs(query(collectionGroup(db, "Admin"), where("Email","==" ,email )));
    snapshot.forEach(async docSnap => {
    const school = await getDoc(docSnap.ref.parent.parent);
    schoolID = school.id;
    
    var data
    const docRef = doc(db, 'School', schoolID, 'Documents', $('.inputbox button').attr('id'));
    const documentDoc = await getDoc(docRef);
    if(document.getElementById("NewFile").files.length == 0){
       data = {
        DisplayName: DocForm.NewDocname.value,
      }
    }
      else{
        data = {
          DisplayName: DocForm.NewDocname.value,
          FileName: document.getElementById("NewFile").files[0].name
        }
        const storageRef = ref(storage, 'School Files/'+document.getElementById("NewFile").files[0].name+"@"+$('.inputbox button').attr('id'));
 
    await uploadBytes(storageRef, document.getElementById("NewFile").files[0]).then(async (snapshot) => {
      const fileRef = ref(storage, 'School Files/'+documentDoc.data().FileName+"@"+documentDoc.id);

      // Delete the file
      await deleteObject(fileRef).then(() => {
       // File deleted successfully
     }).catch((error) => {
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> حصل خطأ يرجى المحاولة لاحقًا </p> </div>';
      $('.loader').hide();

        return;
       });

    });
    }
    await updateDoc(docRef, data)
    .then(docRef => {
      document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert success">  <input type="checkbox" id="alert2"/> <label class="close" title="close" for="alert2"> <i class="icon-remove"></i>  </label>  <p class="inner"> تم التغيير بنجاح</p> </div>';
      $('.loader').hide();

   })
   .catch(error => {
    document.getElementById('alertContainer').innerHTML = '<div style="width: 500px; margin: 0 auto;"> <div class="alert error">  <input type="checkbox" id="alert1"/> <label class="close" title="close" for="alert1"> <i class="icon-remove"></i>  </label>  <p class="inner"> حصل خطأ يرجى المحاولة لاحقًا </p> </div>';
    $('.loader').hide();

   })
  

})
})


  });
  
  