const uid=auth.currentUser.uid;// "kfGIwTyclpNernBQqSpQhkclzhh1";
       
        



       
        
        const schoolName=document.getElementById("snameInp");
        const FirstName=document.getElementById("fnameInp");
        const LastName=document.getElementById("lnameInp");
        const Email=document.getElementById("emailInp");
        const Password=document.getElementById("passInp");
        


        document.onload(fillData(uid));
        async function fillData(uid){
        alert("docRef");
        docRef= doc(db,"School",uid);
        await getDoc(docRef)
        .then((doc)=>{
            console.log(doc.data(), doc.id);
            document.getElementById("snameInp").value=doc.data().SchoolName;
            FirstName.value=doc.data().PrincipalFirstName;
            LastName.value=doc.data().PrincipalLastName;
            Email.value=doc.data().Email;
            //Password.value=user.Password;

        });
        }
        const save = document.getElementById("subButton");
        save.addEventListener('click', async (e) => {
      e.preventDefault();
      const docRef= doc(db,"School",uid);
      
        updateProfile(auth.currentUser, {
          Email:Email.value , Password:Password.value
         }).then(() => {
            updateDoc(docRef,{
        SchoolName:document.getElementById("snameInp").value,
        PrincipalFirstName: FirstName.value,
        PrincipalLastName:LastName.value,
        Email: Email.value,
      })
  
         });
      
    
    
    })