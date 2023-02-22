import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';
import 'package:halaqa_app/viewStudentForChat.dart';
import 'package:http/http.dart';

class teacherHP extends StatefulWidget {
  const teacherHP({super.key});

  @override
  State<teacherHP> createState() => _teacherHPState();
}

class subject {
  String subjectName;
  DocumentReference? subjectRef;
  String className;
  String LevelName;
  String subjectId;

  subject(this.subjectName, this.subjectRef, this.className, this.LevelName,
      this.subjectId);
/*
  @override
  String toString() {
    // TODO: implement toString
    return "content  $content  image $image   title   $title";
  }*/
}

class _teacherHPState extends State<teacherHP> {
  var className = "";
  List<subject> subjectsList = [];
  late List _SubjectsRefList;
  bool isExpanded = false;

  var x = 0;
  var v = 0;
  var teacherName = "";
  var refreshed = false;

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    subjectsList.add(subject("", null, "", "", ""));

    _SubjectsRefList = [""];
    // _SubjectsIdsList = [""];
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

    DocumentReference docRef =
        FirebaseFirestore.instance.doc('School/$schoolID/Teacher/${user.uid}');

    docRef.get().then((DocumentSnapshot ds) async {
      print("MMM ${ds.id}");
      print("MMM ${ds.data()}");
      // use ds as a snapshot

      numOfSubjects = ds['Subjects'].length;
      setState(() {
        teacherName = ds['FirstName'] + " " + ds['LastName'];
      });

      for (var i = 0; i < numOfSubjects; i++) {
        DocumentReference docu = ds['Subjects'][i];

        DocumentReference str = ds['Subjects'][i].parent.parent;
        print("ZZZZZZZZ ${ds['Subjects'][i].parent.parent.id}");
        // var classRef = await docRef.collection("Announcement").get();

        var clsName = await str.get().then((value) {
          setState(() {
            var subName = docu.get().then((valueIn) {
              //   _ClassNameList.add(value['ClassName']);
              subjectsList.add(subject(valueIn['SubjectName'], docu,
                  value['ClassName'], value['LevelName'], valueIn.id));
            });
          });
        });

        var subName = await docu.get().then((value) {
          setState(() {
            print("SUBJECT ID ${value.id}");

            _SubjectsRefList.add(docu);
          });
        });
      }
      setState(() {
        if (_SubjectsRefList.length > 1 && !refreshed) {
          subjectsList.removeAt(0);
          _SubjectsRefList.removeAt(0);
          refreshed = true;
        }
      });
      if (_SubjectsRefList[0] == "") {
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
        title: Image.asset(
          "images/logo.png",
          scale: 9,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              //conformation message
              showAlertDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
        ],
      ),

      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .doc('School/$schoolID/Teacher/${user!.uid}')
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // print("DAT A ${snapshot.data!.data()}");
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }

            if (snapshot.hasData && refreshed) {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      textAlign: TextAlign.center,
                      teacherName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                      child: RefreshIndicator(
                          color: Colors.black,
                          onRefresh: () async {
                            subjectsList.clear();
                            _SubjectsRefList.clear();
                            await getSubjects();
                          },
                          child: Container(
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                              children: subjectsList.map((e) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Color.fromARGB(255, 239, 240, 240),
                                  ),
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(15),
                                  child: GroovinExpansionTile(
                                    defaultTrailingIconColor:
                                        Color.fromARGB(255, 82, 169, 151),
                                    leading: Icon(
                                      Icons.book,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    title: Text(
                                        e.subjectName +
                                            "\nالفصل: " +
                                            e.className +
                                            "\nالمرحلة: " +
                                            e.LevelName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    onExpansionChanged: (value) {
                                      setState(() => isExpanded = value);
                                    },
                                    inkwellRadius: !isExpanded
                                        ? const BorderRadius.all(
                                            Radius.circular(8.0))
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        ),
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 20, 20.0, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 44,
                                                        height: 44,
                                                        child: FittedBox(
                                                          child:
                                                              FloatingActionButton(
                                                            heroTag: null,
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    54,
                                                                    172,
                                                                    172),
                                                            onPressed: () {
                                                              if (_SubjectsRefList[
                                                                      0] !=
                                                                  "") {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              viewStudents(
                                                                                ref: _SubjectsRefList[subjectsList.indexOf(e)],
                                                                              )),
                                                                );
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              "images/studentsIcon.png",
                                                              width: 44,
                                                              height: 44,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5.5,
                                                      ),
                                                      Text("الطلاب"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 40,
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 44,
                                                        height: 44,
                                                        child: FittedBox(
                                                          child:
                                                              FloatingActionButton(
                                                            heroTag: null,
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    54,
                                                                    172,
                                                                    172),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            grades(
                                                                              subRef: _SubjectsRefList[subjectsList.indexOf(e)],
                                                                              subName: e.subjectName,
                                                                            )),
                                                              );
                                                            },
                                                            child: Image.asset(
                                                              "images/gradesIcon.png",
                                                              width: 44,
                                                              height: 44,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5.5,
                                                      ),
                                                      Text("الدرجات"),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 40,
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 44,
                                                        height: 44,
                                                        child: FittedBox(
                                                          child:
                                                              FloatingActionButton(
                                                            heroTag: null,
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    54,
                                                                    172,
                                                                    172),
                                                            onPressed: () {
                                                              print("SUBJECT ID " +
                                                                  e.subjectId);
                                                              print(
                                                                  "ID############$schoolID, ${e.subjectId}");

                                                              if (_SubjectsRefList[
                                                                      0] !=
                                                                  "") {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              viewStudentsForChat(
                                                                                ref: _SubjectsRefList[subjectsList.indexOf(e)],
                                                                                schoolId: schoolID,
                                                                                subjectId: e.subjectId,
                                                                              )),
                                                                );
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              "images/chatIcon.png",
                                                              width: 44,
                                                              height: 44,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5.5,
                                                      ),
                                                      Text("المحادثات"),
                                                    ],
                                                  ),
                                                ],
                                              ))

                                          // color: Color.fromARGB(255, 222, 227, 234),
                                        ]),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )))
                ],
              )));
            }
            if (subjectsList.length == 0 && x == 0) {
              return const Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            if (_SubjectsRefList[0] == "" && v == 1) {
              return const Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            return const Center(child: CircularProgressIndicator());
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
      child: const Text("نعم"),
      onPressed: () async {
        const CircularProgressIndicator();
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
      child: const Text("إلغاء",
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
      content: const Text(
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

class viewStudents extends StatefulWidget {
  const viewStudents({super.key, required this.ref});
  final DocumentReference ref;
  @override
  State<viewStudents> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<viewStudents> {
  late List _StudentList;
  late List _StudenNameList;
  late List _StudentsRefList;
  var x = 0;
  var v = 0;
  var className;
  var levelName;

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
      className = ds['ClassName'];
      levelName = ds['LevelName'];

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
        backgroundColor: Color.fromARGB(255, 54, 172, 172),
        elevation: 1,
        actions: const [],
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
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      className + " / " + levelName.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(10.0, 20, 10.0, 20),
                      shrinkWrap: true,
                      children: _StudenNameList.map((e) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color.fromARGB(255, 239, 240, 240),
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          child: Text(e,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),

                          //   color: Color.fromARGB(255, 222, 227, 234),
                        );
                      }).toList(),
                    ),
                  )
                ],
              )));
            }
            if (_StudenNameList.length == 0 && x == 0) {
              return const Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            if (_StudenNameList[0] == "" && v == 1) {
              return const Center(
                  child: Text("لم يتم تعيين أي طالب بالفصل بعد."));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
