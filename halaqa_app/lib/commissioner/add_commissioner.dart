import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
  String? checkStudentId;


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
      print(students);
      email.text = widget.snapshot!.get("Email");
      fName.text = widget.snapshot!.get("FirstName");
      lName.text = widget.snapshot!.get("LastName");
      for (var element in students) {
        DocumentSnapshot dc = await FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(element.id).get();
        if (widget.snapshot!.get("Students").id == element.id) {
          checkStudentId = element.id;
        }
      }
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
                        return "اسم العائلة مطلوب";
                      }
                      return null;
                    }
                ),
                     SizedBox(
                          height: 10,
                        ),
                customTextFiled(
                    hintText: "بريد إلكتروني",
                    controller: email,
                    icon: Icons.email,
                    enabled: widget.isUpdate == true ? false : true,
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
                if (widget.isUpdate == false)
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
                          checkStudentId = data.id;
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
                                checkStudentId != students[i].id ? Icons.check_box_outline_blank : Icons.check_box,
                                color:checkStudentId != students[i].id  ? Colors.black : Colors.blueAccent,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),


                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (widget.isUpdate == true) {
                        ///change the path to what i sent you 
                        FirebaseFirestore.instance.collection("School/${widget.schoolId}/Commissioner/").doc(widget.snapshot!.id).update({
                          "FirstName" : fName.text,
                          "LastName" : lName.text,
                          "Students" :  FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId)
                        });
                        FirebaseFirestore.instance.collection("School/${widget.schoolId}/Student/").doc(checkStudentId).update({
                          "CommissionerId" : FirebaseFirestore.instance.collection('School/${widget.schoolId}/Commissioner/').doc(widget.snapshot!.id)
                        });

                        for(int i=0;i<students.length;i++) {
                         if (students[i].id != checkStudentId) {
                           FirebaseFirestore.instance.collection("School/${widget.schoolId}/Student/").doc(students[i].id).update({
                             "CommissionerId" : null
                           });
                         }
                        }

                        Fluttertoast.showToast(msg: "تم تحديث  معلومات المفوض");
                      } else {
                        if (checkStudentId == null) {
                          Fluttertoast.showToast(msg: "Please select student");
                        } else {
                          //// becouse this method let the new user sign-in automatcly please use Nofe.js for flutter i sent the simmiler files to the group
                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value) async {
                            ////chane the path please
                            FirebaseFirestore.instance.collection("School/${widget.schoolId}/Commissioner/").doc(value.user!.uid).set({
                              "FirstName" : fName.text,
                              "LastName" : lName.text,
                              "Email" : email.text,
                              "Students" :  FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student/').doc(checkStudentId)
                            });
                            FirebaseFirestore.instance.collection("School/${widget.schoolId}/Student/").doc(checkStudentId).update({
                              "CommissionerId" : FirebaseFirestore.instance.collection('School/${widget.schoolId}/Commissioner/').doc(value.user!.uid)
                            });
                            Fluttertoast.showToast(msg: "تمت إضافةالمفوض بنجاح");
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
                              ///
                            });
                            fName.clear();
                            lName.clear();
                            email.clear();
                            password.clear();
                            checkStudentId = null;
                            setState(() {

                            });
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
                      "إضافة مفوض",
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
}
