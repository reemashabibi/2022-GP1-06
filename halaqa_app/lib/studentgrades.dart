import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/teacherHP.dart';

class studentGrades extends StatefulWidget {
  const studentGrades({super.key, required this.stRef, required this.classRef});
  final DocumentReference stRef;
  final DocumentReference classRef;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<studentGrades> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();

  late int newAttendGrade = 0;
  late int newMidGrade = 0;
  late int newFinGrade = 0;
  late int newLabGrade = 0;

  late int newProjGrade = 0;
  late int newHWGrade = 0;
  late int newPartGrade = 0;

  late String fName = "";
  late String lName = "";

  initialValueForm() async {
    await widget.stRef.get().then((value) {
      setState(() {
        fName = value['FirstName'];
        lName = value['LastName'];
      });
    });
    var stRef = await widget.stRef
        .collection("Grades")
        .where('subjectID', isEqualTo: widget.classRef)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        setState(() {
          newAttendGrade = value['attendance'];
          newMidGrade = value['midterm'];
          newFinGrade = value['finalExam'];
          newLabGrade = value['lab'];
          newProjGrade = value['project'];
          newPartGrade = value['participation'];
          newHWGrade = value['homework'];
        });
      });
    });
  }

  void initState() {
    initialValueForm();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 76, 170, 175),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => grades(
                  subRef: widget.classRef,
                ),
              ),
            );
          },
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(
                  colors: [
                    (Color.fromARGB(255, 208, 247, 247)),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    //    child: Text(
                    // "Edit profile",
                    //    style: TextStyle(
                    //      fontSize: 20,
                    //       color: Color.fromARGB(255, 49, 49, 49)
                    //    ),
                    // ),
                  )
                ],
              )),
            ),
            Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          fName + " " + lName, //  text ??
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: 30,
                          ),
                        ),

//////////////////////// Inputs /////////////////////////
                        SizedBox(
                          height: 35,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          // maxLength: 20,
                          onChanged: (newText) {
                            newAttendGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newAttendGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة الحضور",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          //  maxLength: 20,
                          onChanged: (newText) {
                            newPartGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newPartGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة المشاركة",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,

                          // maxLength: 20,
                          onChanged: (newText) {
                            newProjGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newProjGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة المشاريع",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,

                          // maxLength: 20,
                          onChanged: (newText) {
                            newHWGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newHWGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة الواجبات",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          //   maxLength: 20,
                          onChanged: (newText) {
                            newMidGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newMidGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة الاختبار الشهري ",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          //  maxLength: 20,
                          onChanged: (newText) {
                            newLabGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newLabGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة الاختبار العملي",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 10) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ١٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          //  maxLength: 20,
                          onChanged: (newText) {
                            newFinGrade = int.parse(newText);
                          },
                          controller: TextEditingController(
                              text: newFinGrade.toString()),
                          decoration: InputDecoration(
                            labelText: "درجة الاختبار النهائي ",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "أدخل الدرجة";
                            }
                            if (!isNumeric(value)) {
                              return "الرجاء إدخال رقم باللغة الإنجليزية";
                            }
                            if (int.parse(value) < 0 || int.parse(value) > 40) {
                              return "يجب ان تكون حدود الدرجة من ٠ الى ٤٠";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        GestureDetector(
                          onTap: () async {
                            print(newAttendGrade);
                            setState(() {
                              visible = true;
                            });
                            //signIn(emailController.text, passwordController.text);
                            var f = false;
                            if (_formkey.currentState!.validate()) {
                              f = await conform();
                            }

                            if (f) {
                              saveChanges(
                                  newAttendGrade,
                                  newPartGrade,
                                  newProjGrade,
                                  newMidGrade,
                                  newLabGrade,
                                  newFinGrade,
                                  newHWGrade);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    (Color.fromARGB(255, 170, 243, 250)),
                                    Color.fromARGB(255, 195, 196, 196)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "حفظ ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print(newAttendGrade);
                            setState(() {
                              visible = true;
                            });
                            //signIn(emailController.text, passwordController.text);
                            // showAlertDialog(context);
                            var f = false;
                            if (_formkey.currentState!.validate()) {
                              f = await conformClass();
                            }

                            if (f) {
                              saveChangesForClass(
                                  newAttendGrade,
                                  newPartGrade,
                                  newProjGrade,
                                  newMidGrade,
                                  newLabGrade,
                                  newFinGrade,
                                  newHWGrade);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    (Color.fromARGB(255, 170, 243, 250)),
                                    Color.fromARGB(255, 195, 196, 196)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "حفظ الدرجة لجميع طلاب الفصل",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                //    child: CircularProgressIndicator(
                                //  color: Color.fromARGB(255, 160, 241, 250),
                                //  )
                                )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  int numOfStudents = 0;
  saveChangesForClass(newAttendGrade, newPartGrade, newProjGrade, newMidGrade,
      newLabGrade, newFinGrade, newHWGrade) async {
    if (_formkey.currentState!.validate()) {
      DocumentReference classRef =
          await widget.classRef.parent.parent as DocumentReference<Object?>;
      classRef.get().then((DocumentSnapshot ds) async {
        numOfStudents = ds['Students'].length;
        for (var i = 0; i < numOfStudents; i++) {
          DocumentReference docu = ds['Students'][i];
          var studentRef = await docu
              .collection("Grades")
              .where('subjectID', isEqualTo: widget.classRef)
              .get();
          if (studentRef.docs.length > 0) {
            await docu
                .collection("Grades")
                .where('subjectID', isEqualTo: widget.classRef)
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((documentSnapshot) {
                documentSnapshot.reference.update({
                  'attendance': newAttendGrade,
                  'midterm': newMidGrade,
                  'finalExam': newFinGrade,
                  'lab': newLabGrade,
                  'project': newProjGrade,
                  'participation': newPartGrade,
                  'homework': newHWGrade,
                  "subjectID": widget.classRef
                });
              });
            });
          } else {
            docu.collection("Grades").add({
              'attendance': newAttendGrade,
              'midterm': newMidGrade,
              'finalExam': newFinGrade,
              'lab': newLabGrade,
              'project': newProjGrade,
              'participation': newPartGrade,
              'homework': newHWGrade,
              "subjectID": widget.classRef
            });
          }
        }
      });

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "تم حفظ التعديلات بنجاح",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            );
          });
    }
  }

  saveChanges(newAttendGrade, newPartGrade, newProjGrade, newMidGrade,
      newLabGrade, newFinGrade, newHWGrade) async {
    /* bool flag = false;
    if (_formkey.currentState!.validate()) {
      flag = showAlertDialog(context);
      print("in if 1");
    }*/
    if (_formkey.currentState!.validate()) {
      print("in if 2");
      var stRef = await widget.stRef
          .collection("Grades")
          .where('subjectID', isEqualTo: widget.classRef)
          .get();
      if (stRef.docs.length > 0) {
        await widget.stRef
            .collection("Grades")
            .where('subjectID', isEqualTo: widget.classRef)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            documentSnapshot.reference.update({
              'attendance': newAttendGrade,
              'midterm': newMidGrade,
              'finalExam': newFinGrade,
              'lab': newLabGrade,
              'project': newProjGrade,
              'participation': newPartGrade,
              'homework': newHWGrade,
              "subjectID": widget.classRef
            });
          });
        });
      } else {
        await widget.stRef.collection("Grades").add({
          'attendance': newAttendGrade,
          'midterm': newMidGrade,
          'finalExam': newFinGrade,
          'lab': newLabGrade,
          'project': newProjGrade,
          'participation': newPartGrade,
          'homework': newHWGrade,
          "subjectID": widget.classRef
        });
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "تم حفظ التعديلات بنجاح",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "لم تتم حفظ التعديلات",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            );
          });
    }
  }

  Future<bool> conform() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("تأكيد حفظ درجات الطالب؟"),
        actions: [
          TextButton(
              child: Text("لا",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("نعم", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

  Future<bool> conformClass() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("تأكيد حفظ ومطابقة الدرجات لجميع طلاب الفصل؟"),
        actions: [
          TextButton(
              child: Text("لا",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("نعم", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }
} //end class
