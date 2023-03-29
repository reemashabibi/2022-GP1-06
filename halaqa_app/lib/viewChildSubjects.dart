import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewChildGrades.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'chatDetailPS.dart';

class viewChildSubjcets extends StatefulWidget {
  const viewChildSubjcets(
      {super.key,
      this.classRef,
      this.studentName,
      this.stRef,
      this.schoolID,
      this.classId});
  final classRef;
  final studentName;
  final stRef;
  final schoolID;
  final classId;

  @override
  State<viewChildSubjcets> createState() => _viewChildSubjcetsState();
}

class _viewChildSubjcetsState extends State<viewChildSubjcets> {
  var className = "";
  var level = "";
  late List _SubjectList;
  late List<Map<String, dynamic>> _SubjectsNameList;
  late List _SubjectsRefList;

  var x = 0;
  var v = 0;
  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _SubjectsNameList = [];
    //_SubjectList = [""];
    _SubjectsRefList = [""];
    x++;
  }

  // String studentId = "";

  void callChatDetailScreen(DocumentReference<Map<String, dynamic>> teacherId,
      String subjectId) async {
    print("??????????????????????????????????????");
    // print("^^^^^^^ ${widget.stRef.id}");
    print("In function Student Name: " "tst ${teacherId.id}");
    print(user!.uid);
    print(subjectId);
    print(widget.classId);
    // var dc =
    //     FirebaseFirestore.instance.doc("School/$schoolID/Parent/${user!.uid}");
    // dc.get().then((value) async {
    //   print(value.get("Students"));
    //   for (DocumentReference<Map<String, dynamic>> s in value.get("Students")) {
    //     print("STUDENT ID ${s.id}");
    //     studentId = s.id;
    //   }
    // });
    DocumentSnapshot teacherDs = await FirebaseFirestore.instance
        .doc("School/$schoolID/Teacher/${teacherId.id}")
        .get();
    print(teacherDs.data());
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChatdetailPS(
                  /////trasfer TeacherName, TeacherUid, StudentUid
                  // TeacherName: "Faisal naser",
                  // TeacherUid: "ctDtxUJlRqeAbHEnj0ayyHAF9Lb2",
                  // StudentUid: "koHNAlQnVjEmUklBkUtn",
                  TeacherName:
                      "${teacherDs.get("FirstName")} ${teacherDs.get("LastName")}",
                  TeacherUid: teacherId.id,
                  StudentUid: widget.stRef.id,
                  schoolId: schoolID,
                  subjectId: subjectId,
                  classID: widget.classId,
                )));
  }

  getSubjects() async {
    DocumentReference docRef = widget.classRef;
    var subRefs = await docRef.collection("Subject").get();
    if (subRefs.docs.length > 0) {
      await docRef.collection("Subject").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          _SubjectsNameList.add({
            "name": documentSnapshot.get('SubjectName'),
            "id": documentSnapshot.get("TeacherID"),
            "docId": documentSnapshot.id,
            "msg_count": documentSnapshot.get("msg_count")
          });
          _SubjectsRefList.add(documentSnapshot.reference);
        });
      });
    }
    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      setState(() {
        className = ds["LevelName"].toString() + "-" + ds['ClassName'];
      });

      setState(() {
        if (_SubjectsNameList.length > 1) {
          _SubjectsNameList.removeAt(0);
          _SubjectsRefList.removeAt(0);
        }
      });
      if (_SubjectsNameList[0] == "") {
        v++;
      }
    });
  }

  @override
  void initState() {
    schoolID = widget.schoolID;
    getSubjects();
    // getSchoolID();
    // getSchoolID();
    //remove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 54, 172, 172),
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School/$schoolID/Class')
              .doc(widget.classId)
              .collection("Subject")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }

            if (snapshot.hasData /*&& _SubjectsNameList[0] != ""*/) {
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
                          //    topLeft: Radius.circular(10),
                          ///    topRight: Radius.circular(10),
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
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20),
                    child: Text(
                      widget.studentName + "\n" + className,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    child: ListView(
                      // padding: const EdgeInsets.only(right: 40.0, left: 40.0),

                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(30.0, 20, 30.0, 10),
                      children: snapshot.data!.docs.map((e) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color.fromARGB(255, 239, 240, 240),
                            ),
                            // margin: EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Text("${e.get("SubjectName")}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          overflow: TextOverflow.visible),
                                      margin: EdgeInsets.all(4),
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0, 10.0, 0),
                                    ),
                                  ),
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(children: [
                                        SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: FittedBox(
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 54, 172, 172),
                                              onPressed: () {
                                                if (_SubjectsRefList[0] != "") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            viewChildGrades(
                                                              subRef:
                                                                  e.reference,
                                                              stRef:
                                                                  widget.stRef,
                                                            )),
                                                  );
                                                }
                                              },
                                              child: Image.asset(
                                                "images/gradesIcon.png",
                                                width: 36,
                                                height: 36,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text("الدرجات"),
                                      ]),

                                      const SizedBox(
                                        width: 15,
                                      ),
                                      if (e['TeacherID'] != null &&
                                          e['TeacherID'] != '')
                                        Stack(
                                          children: [
                                            Column(children: [
                                              SizedBox(
                                                width: 44,
                                                height: 44,
                                                child: FittedBox(
                                                  child: FloatingActionButton(
                                                    heroTag: null,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 54, 172, 172),
                                                    onPressed: () {
                                                      callChatDetailScreen(
                                                          e['TeacherID'], e.id
                                                          //     context ,
                                                          //     "faisal naser",
                                                          //     "ctDtxUJlRqeAbHEnj0ayyHAF9Lb2",

                                                          );
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
                                              SizedBox(height: 5),
                                              Text("المحادثات"),
                                            ]),
                                            e['msg_count'] == 0
                                                ? Container()
                                                : Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 14,
                                                      width: 14,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Center(
                                                          child: Text(
                                                        "${e['msg_count']}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 7),
                                                      )),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      //////does nit show?
                                    ],
                                  ))

                                  // color: Color.fromARGB(255, 222, 227, 234),
                                ]));
                      }).toList(),
                    ),
                  )
                ],
              )));
            }
            if (/*_SubjectsNameList.length == 0 &&*/ x == 0) {
              return const Center(child: Text(""));
            }
            if (/*_SubjectsNameList[0] == "" &&*/ v == 1) {
              return const Center(child: Text("لا يوجد مواد مسجلة"));
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
