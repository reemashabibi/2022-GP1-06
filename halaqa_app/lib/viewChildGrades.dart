import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class viewChildGrades extends StatefulWidget {
  const viewChildGrades({
    super.key,
    required this.subRef,
    required this.stRef,
  });
  final DocumentReference subRef;
  final DocumentReference stRef;

  @override
  State<viewChildGrades> createState() => _viewChildGradesState();
}

class assessment {
  String name;
  int grade;

  assessment(this.name, this.grade);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "name  $name  garde $grade";
  }
}

class _viewChildGradesState extends State<viewChildGrades> {
  var subjectName = "";
  var level = "";
  late var gradeID;
  bool customized = false;
  var numOfAssess = 0;
  var assessments2;
  var assessments;
  List<assessment> studentAssessmentsList = [];
  List<assessment> assessmentsList = [];

  var x = 0;
  var v = 0;
  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    studentAssessmentsList.add(assessment("", 0));
    assessmentsList.add(assessment("", 0));
    x++;
  }

  getAssessments() async {
    DocumentReference docRef = widget.subRef;
    var subRefs = await docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      setState(() {
        subjectName = ds['SubjectName'];
        customized = ds['customized'];
        if (customized) {
          numOfAssess = ds['assessments'].length;
        }
      });
    });

    var stRef = await widget.stRef
        .collection("Grades")
        .where('subjectID', isEqualTo: widget.subRef)
        .get();
    print("stRef.docs.length     " + stRef.docs.length.toString());
    if (stRef.docs.length > 0) {
      for (int i = 0; i < numOfAssess; i++) {
        Future<List<assessment>> getAssessment() async {
          setState(() {});
          final snapshots = await Future.wait(
              [docRef.get().then((value) => value['assessments'][i])]);
          return snapshots
              .map(
                  (snapshot) => assessment(snapshot['name'], snapshot['grade']))
              .toList();
        }

        assessments = await getAssessment();
        // assessments2 = await getData();
        setState(() {
          // studentAssessmentsList.addAll(assessments);
          assessmentsList.addAll(assessments);
        });
      }

      // if student grades are assigned
      var stRef = await widget.stRef
          .collection("Grades")
          .where('subjectID', isEqualTo: widget.subRef)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.map((DocumentSnapshot document) {
          setState(() {
            gradeID = document.id;
          });
        }).toList();
      });

      print("in if");
      DocumentReference docu =
          await widget.stRef.collection("Grades").doc(gradeID);
      print(gradeID);

      for (int i = 0; i < numOfAssess; i++) {
        Future<List<assessment>> getAssess() async {
          final snapshots = await Future.wait(
              [docu.get().then((value) => value['assessments'][i])]);
          return snapshots
              .map(
                  (snapshot) => assessment(snapshot['name'], snapshot['grade']))
              .toList();
        }

        assessments2 = await getAssess();
        setState(() {
          studentAssessmentsList.addAll(assessments2);
        });

        if (v == 0) {
          setState(() {
            assessmentsList.removeAt(0);
            studentAssessmentsList.removeAt(0);
            v++;
          });
        }
      }
    }

/*
    if (subRefs.docs.length > 0) {
      await await docRef.collection("Subject").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          _SubjectsNameList.add(documentSnapshot['SubjectName']);
        });
      });
    }
    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      setState(() {
        className = ds['ClassName'] + " / " + ds["LevelName"].toString();
      });

      setState(() {
        if (_SubjectsNameList.length > 1) {
          _SubjectsNameList.removeAt(0);
        }
      });
      if (_SubjectsNameList[0] == "") {
        v++;
      }
    });*/
  }

  @override
  void initState() {
    getAssessments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
          currentIndex: 2, // Use this to update the Bar giving a position
          inactiveColor: Color.fromARGB(255, 9, 18, 121),
          indicatorColor: Color.fromARGB(255, 76, 170, 175),
          activeColor: Color.fromARGB(255, 76, 170, 175),
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => parentHP(),
                ),
              );
            }
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewEvents(),
                ),
              );
            }
          },
          items: [
            TitledNavigationBarItem(
                title: Text('الصفحة الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.home)),
            TitledNavigationBarItem(
              title: Text('الأحداث',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.calendar_today),
            ), /*
            TitledNavigationBarItem(
              title: Text('Events'),
              icon: Image.asset(
                "images/eventsIcon.png",
                width: 20,
                height: 20,
                //fit: BoxFit.cover,
              ),
            ),*/
          ]),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .doc('School/' + '$schoolID' + '/Parent/' + user!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }
            print("object");
            //Check if data arrived
            if (x == 0) {
              getData();
            }
            print("assessmentsList.name    " + assessmentsList[0].name);
            if (studentAssessmentsList[0].name != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: SingleChildScrollView(
                      child: new Column(
                children: [
                  new Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      subjectName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  new Container(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 60.0, left: 60.0),
                      children: studentAssessmentsList.map((e) {
                        return Container(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 20, 20.0, 5),
                            margin: EdgeInsets.only(bottom: 30),
                            // padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 231, 231, 231),
                                border: Border.all(
                                  color: Color.fromARGB(255, 130, 126, 126),
                                  width: 2.5,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      offset: Offset(2.0, 2.0))
                                ]),
                            child: new Column(children: [
                              new Container(
                                child: Text(e.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.all(4),
                                //  padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 5),
                                padding: EdgeInsets.all(2),
                              ),
                              new Container(
                                child: SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: FittedBox(
                                    child: FloatingActionButton.extended(
                                      shape: new CircleBorder(),
                                      heroTag: null,
                                      backgroundColor:
                                          Color.fromARGB(255, 199, 248, 248),
                                      onPressed: () {},
                                      label: Text(
                                          studentAssessmentsList[
                                                      studentAssessmentsList
                                                          .indexOf(e)]
                                                  .grade
                                                  .toString() +
                                              "/" +
                                              assessmentsList[
                                                      studentAssessmentsList
                                                          .indexOf(e)]
                                                  .grade
                                                  .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            fontSize: 10,
                                          )),
                                    ),
                                  ),
                                ),
                              )

                              // color: Color.fromARGB(255, 222, 227, 234),
                            ]));
                      }).toList(),
                    ),
                  )
                ],
              )));
            }
            if (studentAssessmentsList.length == 0 && x == 0) {
              return Center(child: Text(""));
            }
            if (studentAssessmentsList[0] == "" && v == 1) {
              return Center(child: Text("لا يوجد مواد مسجلة"));
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
