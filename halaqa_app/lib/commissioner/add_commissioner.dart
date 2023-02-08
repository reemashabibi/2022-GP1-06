import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class AddCommissioner extends StatefulWidget {
  final String schoolId;
  bool? isUpdate;
  DocumentSnapshot? snapshot;
  AddCommissioner({Key? key, required this.schoolId,this.isUpdate = false,this.snapshot}) : super(key: key);

  @override
  State<AddCommissioner> createState() => _AddCommissionerState();
}

class _AddCommissionerState extends State<AddCommissioner> {

  TextEditingController email = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Widget customTextFiled({required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
    required FormFieldValidator<String> validator,
    bool? enabled
  }) {

    return  Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          //hintText: "EnterF Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        enabled: enabled,
        validator: validator,
        keyboardType: textInputType,
      ),
    );
  }

  List<dynamic> students = [];
  List<String> studentsName = [];
  List<String> checkStudentId = [];
  var Uid ;


  getStudent() async{
    DocumentSnapshot dc = await FirebaseFirestore.instance.collection('School/${widget.schoolId}/Parent/').doc(FirebaseAuth.instance.currentUser!.uid).get();
    print("&*&*&* ${dc.id}");
    students = List.from(dc.get("Students"));
    for (var element in students) { //adding them in studentsName array
      DocumentSnapshot dc = await FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(element.id).get();
      studentsName.add("${dc.get("FirstName")} ${dc.get("LastName")}");
    }
    setState(() {

    });

    if (widget.isUpdate == true) {
      List list = widget.snapshot!.get("Students");
      email.text = widget.snapshot!.get("Email");
      fName.text = widget.snapshot!.get("FirstName");
      lName.text = widget.snapshot!.get("LastName");
      for (var element in list) {
        checkStudentId.add(element.id);
      }
      // print("CC $checkStudentId");
      setState(() {

      });


    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                     SizedBox(
                          height: 50,
                        ),
                customTextFiled(
                  hintText: "الاسم الاول",
                  controller: fName,
                  icon: Icons.person,
                  textInputType: TextInputType.text,
                  validator: (s) {
                      if (s!.isEmpty) {
                        return "الاسم الأول مطلوب";
                      }
                      return null;
                    }
                ),
                     SizedBox(
                          height: 10,
                        ),
                customTextFiled(
                    hintText: "الاسم الأخير",
                    controller: lName,
                    icon: Icons.person,
                    textInputType: TextInputType.text,
                    validator: (s) {
                      if (s!.isEmpty) {
                        return "الاسم الأخير مطلوب";
                      }
                      return null;
                    }
                ),
                     SizedBox(
                          height: 10,
                        ),
                customTextFiled(
                    hintText: "البريد إلكتروني",
                    controller: email,
                    icon: Icons.email,
                  //  enabled: widget.isUpdate == true ? false : true,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "البريد الالكتروني مطلوب";
                      }
                      if (!RegExp(r'^.+@[a-zA-Z0-9]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
                        return "أدخل بريدًا إلكترونيًا صالحًا";
                      }
                      return null;
                    }
                ),
              //   if (widget.isUpdate == false){},

                   Container(
                       child:LayoutBuilder(builder: (context, constraints) { 
                             if(widget.isUpdate == false){
                               return   Column( 
                                    children: [
                                     SizedBox(
                                    height: 10,
                                   ),

                         customTextFiled(
                             hintText: "كلمة المرور",
                             controller: password,
                             icon: Icons.lock,
                             textInputType: TextInputType.text,
                             validator: (value) {
                               if (value!.isEmpty) {
                                 return "كلمة المرور مطلوبة";
                               } else if (value.length < 6) {
                                 return ("لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام");
                               }
                               return null;
                             }
                         ),   
                       ],
                     );
                               //Text("Y is greater than or equal to 10");
                             }else{
                                 return Text("");
                             }  
                         })
                     ),
 
                     
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (c,i) {

                    var data = students[i];
                    print("@@ $checkStudentId");

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 7),
                      child: GestureDetector(
                        onTap: () {
                          // checkStudentId = data.id;
                          if (!checkStudentId.contains(data.id)) {
                            checkStudentId.add(data.id);
                          } else {
                            checkStudentId.remove(data.id);
                          }
                          setState(() {

                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(child: Text(studentsName[i].toString(),style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black
                              ),)),
                              Icon(
                                !checkStudentId.contains(students[i].id)  ? Icons.check_box_outline_blank : Icons.check_box,
                                color:!checkStudentId.contains(students[i].id)  ? Colors.black : Color.fromARGB(255, 116, 195, 255),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),


                GestureDetector(
                  onTap: () async{
                    if (formKey.currentState!.validate()) {
                      if (widget.isUpdate == true) {
                        if (checkStudentId.isEmpty){
                         Fluttertoast.showToast(msg: "فضلًا اختَر طالِب",backgroundColor: Color.fromARGB(255, 221, 33, 30) );
                        }
                        else{
                       // FirebaseApp app = await Firebase.initializeApp(name: 'secondary', options: Firebase.app().options);
                        FirebaseFirestore.instance.collection("School/${widget.schoolId}/Commissioner/").doc(widget.snapshot!.id).update({
                          "FirstName" : fName.text,
                          "LastName" : lName.text,
                          "Email" : email.text,
                         // "Password": password.text,
                          // "Students" :  FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId)
                          "Students" :  List.generate(checkStudentId.length, (index) => FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId[index]))
                        });

                        for (var element in checkStudentId) {
                          FirebaseFirestore.instance.collection("School/${widget.schoolId}/Student/").doc(element).update({
                            "CommissionerId" : FieldValue.arrayUnion([FirebaseFirestore.instance.collection('School/${widget.schoolId}/Commissioner/').doc(widget.snapshot!.id)])
                          });
                           Uid = widget.snapshot!.id;
                           print("Com ID:");
                           print(Uid);
                        }
                        print("Com ID 2222222222:");
                           print(Uid);
                      //    updateUser(Uid, email.text );
                          updateUser(Uid, email.text ).then((data) async {
                         //   print(Uid.runtimeType);
                            print("Printingggg");
                            var responseData = json.decode(data.body);
                         //  var responseData= await json.decode(json.encode(data.body)); 
                          // responseData = responseData[0]; 
                           print(responseData);

                            if(responseData["status"] == "Successfull" ){
                             Fluttertoast.showToast(msg: "تم تحديث  معلومات المفوض" ,backgroundColor: Color.fromARGB(255, 97, 200, 0));
                            }

                         else 
                            if(responseData["status"] == "used"){
                            print ("email already in use");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("البريد الإلكتروني مستخدم من قبل",
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                            );
  
                            }
                          }).catchError((e) {
                            print("EERRROR ${e.toString()}");
                            ///
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(e.toString(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                            );
                            ///
                          });
                          
                      //  Fluttertoast.showToast(msg: "تم تحديث  معلومات المفوض" ,backgroundColor: Color.fromARGB(255, 97, 200, 0));
                      }
                      
                      } //end if the widget is update


                      else {///if the widget is add
                        if (checkStudentId.isEmpty) {
                          Fluttertoast.showToast(msg: "فضلًا اختَر طالِب",backgroundColor: Color.fromARGB(255, 221, 33, 30) );
                        } else {
                          //// Node.js
                           createUser(email.text, password.text).then((data) async {
                            var responseData = json.decode(data.body);
                            print(responseData);
                            if(responseData["status"] == "Successfull" ){
                            print (responseData["uid"]);
                            var COMuid = responseData["uid"];
                                FirebaseFirestore.instance.collection("School/${widget.schoolId}/Commissioner/").doc(COMuid).set({
                              "FirstName" : fName.text,
                              "LastName" : lName.text,
                              "Email" : email.text,
                              "ParentId" : FirebaseAuth.instance.currentUser!.uid,
                              //"Password" : password.text,
                              // "Students" :  FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId)
                              "Students" :  List.generate(checkStudentId.length, (index) => FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId[index]))
                            });
                            for (var element in checkStudentId) {
                              FirebaseFirestore.instance.collection("School/${widget.schoolId}/Student/").doc(element).update({
                                "CommissionerId" : FieldValue.arrayUnion([FirebaseFirestore.instance.collection('School/${widget.schoolId}/Commissioner/').doc(COMuid)])
                              });
                            }
                         Fluttertoast.showToast(msg: "تمت إضافةالمفوّض بنجاح",backgroundColor: Color.fromARGB(255, 97, 200, 0));
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text).then((value) {
                              ////
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text("تم إرسال بريدًا إلكترونيًا لإعادة تعيين كلمة المرور",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    );
                                  }
                              );
                              ///Delete Later
                            });
                           
                            fName.clear();
                            lName.clear();
                            email.clear();
                            password.clear();
                            checkStudentId = [];
                            setState(() {

                            });
                            }///end line 258

                         else 
                            if(responseData["status"] == "used"){
                            print ("email already in use");
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("البريد الإلكتروني مستخدم من قبل",
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                            );
                            fName.clear();
                            lName.clear();
                            email.clear();
                            password.clear();
                            checkStudentId = [];
                            setState(() {

                            });
                            }
                          }).catchError((e) {
                            print("EERRROR ${e.toString()}");
                            ///
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(e.toString(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                            );
                            ///
                          });
                        }
                        
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top:20,bottom: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [(Color.fromARGB(255, 170, 243, 250)), Color.fromARGB(255, 195, 196, 196)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)
                        ),
                      ],
                    ),
                    child: const Text(
                      "حفظ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<http.Response> updateUser(String email, String pass) async {
  //Andorid??
  return http.post(
        Uri.parse("http://127.0.0.1:8080/updateUser"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
            'email': email,
            'pass': pass
        })
     
    );     
}

Future<http.Response> createUser(String email, String pass) async {
  //Andorid??
  return http.post(
        Uri.parse("http://127.0.0.1:8080/addUser"),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
            'email': email,
            'pass': pass
        })
     
    );     
}



}
