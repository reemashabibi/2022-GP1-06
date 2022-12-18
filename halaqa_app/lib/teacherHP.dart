import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';

class teacherHP extends StatefulWidget {
  const teacherHP({super.key});

  @override
  State<teacherHP> createState() => _teacherHPState();
}

class _teacherHPState extends State<teacherHP> {
  var className = "";
  var level = "";
  late List _SubjectList;
  late List _SubjectsNameList;
  late List _SubjectsRefList;
  late List _ClassNameList;
  late List _LevelNameList;
  var x = 0;
  var v = 0;

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _ClassNameList = ["يتم التحميل...."];
    _LevelNameList = ["يتم التحميل...."];
    _SubjectList = [""];
    _SubjectsNameList = [""];
    _SubjectsRefList = [""];
    x++;
  }

  getSubjects() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var col = FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .doc('School/' + '$schoolID' + '/Teacher/' + user!.uid);

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      numOfSubjects = ds['Subjects'].length;

      for (var i = 0; i < numOfSubjects; i++) {
        DocumentReference str = ds['Subjects'][i].parent.parent;

        var clsName = await str.get().then((value) {
          setState(() {
            _ClassNameList.add(value['ClassName']);

            _LevelNameList.add(value['Level'].toString());
          });
        });

        DocumentReference docu = ds['Subjects'][i];

        var subName = await docu.get().then((value) {
          setState(() {
            _SubjectsNameList.add(value['SubjectName']);

            _SubjectsRefList.add(docu);
          });
        });
      }
      setState(() {
        if (_SubjectsNameList.length > 1) {
          _SubjectsNameList.removeAt(0);
          _ClassNameList.removeAt(0);
          _LevelNameList.removeAt(0);
          _SubjectsRefList.removeAt(0);
        }
      });
      if (_SubjectsNameList[0] == "") {
        v++;
      }
    });
  }

  Future<void> getSchoolID() async {
    User? user = FirebaseAuth.instance.currentUser;
    var col = FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }
  }

  @override
  void initState() {
    getSubjects();
    getSchoolID();
    // getSchoolID();
    //remove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('School/' + '$schoolID' + '/Teacher/' + user!.uid);
    return Scaffold(
      //appBar: AppBar(title: const Text("Teacher")),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              //conformation message
              showAlertDialog(context);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //context,
              //MaterialPageRoute(
              // builder: (context) => EditProfilePage()
              // ),
              //  );
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.black,
            ),
          )
        ],
      ),

      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .doc('School/' + '$schoolID' + '/Teacher/' + user!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }

            if (snapshot.hasData && _SubjectsNameList[0] != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: ListView(
                children: _SubjectsNameList.map((e) {
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 247, 253),
                          border: Border.all(
                            color: Color.fromARGB(255, 130, 126, 126),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 123, 211, 217),
                            Color.fromARGB(255, 209, 213, 216)
                          ]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                offset: Offset(2.0, 2.0))
                          ]),
                      child: Text(
                          e +
                              "\nالفصل: " +
                              _ClassNameList[_SubjectsNameList.indexOf(e)] +
                              "\nالمرحلة: " +
                              _LevelNameList[_SubjectsNameList.indexOf(e)],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(13),
                      // color: Color.fromARGB(255, 222, 227, 234),
                    ),
                    onTap: () {
                      if (_SubjectsRefList[0] != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyWidget(
                                    ref: _SubjectsRefList[
                                        _SubjectsNameList.indexOf(e)],
                                  )),
                        );
                      }
                    },
                  );
                }).toList(),
              ));
            }
            if (_SubjectsNameList.length == 0 && x == 0) {
              return Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            if (_SubjectsNameList[0] == "" && v == 1) {
              return Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> logout(BuildContext context) async {
    showAlertDialog(BuildContext context) {}
    ;
  }

  Future<void> showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget continueButton = TextButton(
      //continueButton
      child: Text("نعم"),
      onPressed: () async {
        CircularProgressIndicator();
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
    );

    Widget cancelButton = TextButton(
      //cancelButton
      child: Text("إلغاء",
          style: TextStyle(
            color: Colors.red,
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text(
        "هل تأكد تسجيل الخروج؟",
        textAlign: TextAlign.center,
      ),
      actions: [continueButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } //end method

}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.ref});
  final DocumentReference ref;
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late List _StudentList;
  late List _StudenNameList;
  late List _StudentsRefList;
  var x = 0;
  var v = 0;

  var numOfStudents;

  getData() {
    _StudentList = [""];
    _StudentsRefList = [""];
    _StudenNameList = [""];
    x++;
  }

  getStudents() async {
    DocumentReference docRef =
        widget.ref.parent.parent as DocumentReference<Object?>;

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      numOfStudents = ds['Students'].length;
      for (var i = 0; i < numOfStudents; i++) {
        DocumentReference docu = ds['Students'][i];
        var stName = await docu.get().then((value) {
          setState(() {
            _StudenNameList.add(value['FirstName'] + " " + value['LastName']);
            _StudentsRefList.add(docu);
          });
        });
      }

      setState(() {
        if (_StudenNameList.length > 1) {
          _StudentList.removeAt(0);
          _StudenNameList.removeAt(0);
          _StudentsRefList.removeAt(0);
        }
      });
      if (_StudenNameList[0] == "") {
        v++;
      }
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    DocumentReference ref = widget.ref;

    DocumentReference str = ref.parent.parent as DocumentReference<Object?>;
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
                builder: (context) => teacherHP(),
              ),
            );
          },
        ),
        actions: [],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: widget.ref.parent.parent?.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }
            if (snapshot.hasData && _StudenNameList[0] != "") {
              //Display the list

              return Container(
                  child: ListView(
                children: _StudenNameList.map((e) {
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 247, 253),
                          border: Border.all(
                            color: Color.fromARGB(255, 130, 126, 126),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 123, 211, 217),
                            Color.fromARGB(255, 209, 213, 216)
                          ]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                offset: Offset(2.0, 2.0))
                          ]),
                      child: Text(e,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(15),
                      //   color: Color.fromARGB(255, 222, 227, 234),
                    ),
                    onTap: () {
                      if (_StudentsRefList[0] != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => studentGrades(
                                    stRef: _StudentsRefList[
                                        _StudenNameList.indexOf(e)],
                                    classRef: ref,
                                  )),
                        );
                      }
                    },
                  );
                }).toList(),
              ));
            }
            if (_StudenNameList.length == 0 && x == 0) {
              return Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            if (_StudenNameList[0] == "" && v == 1) {
              return Center(child: Text("لم يتم تعيين أي طالب بالفصل بعد."));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
