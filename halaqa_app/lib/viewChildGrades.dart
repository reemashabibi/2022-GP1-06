import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:halaqa_app/chatDetailPS.dart';
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
  var totalGrade = 0;
  List<assessment> studentAssessmentsList = [];
  List<assessment> assessmentsList = [];

  var x = 0;
  var v = 0;
  bool noGrades = false;
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

      DocumentReference docu =
          await widget.stRef.collection("Grades").doc(gradeID);

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
          if (v == 0) {
            setState(() {
              assessmentsList.removeAt(0);
              studentAssessmentsList.removeAt(0);
              v++;
            });
          }

          totalGrade += studentAssessmentsList[i].grade;
        });
      }
    }
    noGrades = true;
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
        backgroundColor: Color.fromARGB(255, 54, 172, 172),
        elevation: 1,
      ),
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
            //Check if data arrived
            if (x == 0) {
              getData();
            }

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
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 30.0, left: 30.0),
                      children: studentAssessmentsList.map((e) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(255, 239, 240, 240),
                            ),
                            // margin: EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(e.name,
                                        //    textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),

                                    // padding: EdgeInsets.all(),
                                  ),
                                  //SizedBox(width: 100),
                                  //  Spacer(),
                                  new Container(
                                    child: SizedBox(
                                      width: 80,
                                      height: 30,
                                      child: FittedBox(
                                        child: FloatingActionButton.extended(
                                          //   shape: new CircleBorder(),
                                          heroTag: null,
                                          backgroundColor: Color.fromARGB(
                                              255, 199, 248, 248),
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
                                                color: Color.fromARGB(
                                                    255, 80, 80, 80),
                                                fontSize: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                  )

                                  // color: Color.fromARGB(255, 222, 227, 234),
                                ]));
                      }).toList(),
                    ),
                  ),
                  new Container(
                    child: SizedBox(
                      width: 130,
                      height: 100,
                      child: FittedBox(
                        child: FloatingActionButton.extended(
                          //  shape: new CircleBorder(),
                          heroTag: null,
                          backgroundColor: Color.fromARGB(255, 199, 248, 248),
                          onPressed: () {},
                          label: Text(totalGrade.toString() + "/" + "100",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 80, 80, 80),
                                fontSize: 15,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              )));
            }
            if (studentAssessmentsList.length == 0 && x == 0) {
              return Center(child: Text(""));
            }
            if (noGrades) {
              return Center(child: Text("لم يتم اصدار الدرجات بعد."));
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
