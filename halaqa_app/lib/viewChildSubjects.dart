import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:halaqa_app/chatDetailPS.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class viewChildSubjcets extends StatefulWidget {
  const viewChildSubjcets({super.key, this.classRef, this.studentName, this.schoolID, this.classId,});
  final classRef;
  final studentName;
  final schoolID;
  final classId;

  @override
  State<viewChildSubjcets> createState() => _viewChildSubjcetsState();
}

class _viewChildSubjcetsState extends State<viewChildSubjcets> {
  var className = "";
  var level = "";
  late List _SubjectList;
  ///create map of list because i need teacher id
  late List<Map<String,dynamic>> _SubjectsNameList;
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
    // _SubjectsRefList = [""];
    x++;
  }

  String studentId = "";

  void callChatDetailScreen(DocumentReference<Map<String, dynamic>> teacherId,String subjectId)async{
    print("In function Student Name: "+ "tst ${teacherId.id}");
    print(user!.uid);
    print(subjectId);
    print(widget.classId);
    var dc = FirebaseFirestore.instance.doc("School/$schoolID/Parent/${user!.uid}");
    dc.get().then((value)async{
      print(value.get("Students"));
      for (DocumentReference<Map<String, dynamic>> s in value.get("Students")) {
        print("STUDENT ID ${s.id}");
        studentId = s.id;
      }
    });
    DocumentSnapshot teacherDs = await FirebaseFirestore.instance.doc("School/$schoolID/Teacher/${teacherId.id}").get();
    print(teacherDs.data());
     Navigator.push(
        context,
        CupertinoPageRoute(
        builder: (context) => ChatdetailPS(
          /////trasfer TeacherName, TeacherUid, StudentUid
         // TeacherName: "Faisal naser",
         // TeacherUid: "ctDtxUJlRqeAbHEnj0ayyHAF9Lb2",
         // StudentUid: "koHNAlQnVjEmUklBkUtn",
          TeacherName: "${teacherDs.get("FirstName")} ${teacherDs.get("LastName")}",
          TeacherUid: teacherId.id,
          StudentUid: studentId,
          schoolId: schoolID,
          subjectId: subjectId,
          classID: widget.classId,
          )));
  }


getTeacher() async {

}

  getSubjects() async {
    DocumentReference docRef = widget.classRef;
    var subRefs = await docRef.collection("Subject").get();
    if (subRefs.docs.length > 0) {
      await docRef.collection("Subject").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {

          // DocumentReference<Map<String, dynamic>> id = documentSnapshot.get("TeacherID");
          // print("SUBJECT ^^^ ${documentSnapshot.get("msg_count")}");
          _SubjectsNameList.add({
            "name" : documentSnapshot.get('SubjectName'),
            "id" : documentSnapshot.get("TeacherID"),
            "docId" : documentSnapshot.id,
            "msg_count" : documentSnapshot.get("msg_count")
          });
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
    });
    // print("ZZZZZZZZZZZZZZ $_SubjectsNameList");
  }

  @override
  void initState() {
    schoolID = widget.schoolID;
    // print("SCHOOL ID $schoolID, ${user!.uid}");
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
        backgroundColor: const Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => parentHP(),
            //   ),
            // );
          },
        ),
        actions: [],
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
          currentIndex: 2, // Use this to update the Bar giving a position
          inactiveColor: const Color.fromARGB(255, 9, 18, 121),
          indicatorColor: const Color.fromARGB(255, 76, 170, 175),
          activeColor: const Color.fromARGB(255, 76, 170, 175),
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const parentHP(),
                ),
              );
            }
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const viewEvents(),
                ),
              );
            }
          },
          items: [
            TitledNavigationBarItem(
                title: const Text('الصفحة الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.home)),
            TitledNavigationBarItem(
              title: const Text('الأحداث',
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School/$schoolID/Class').doc(widget.classId).collection("Subject").snapshots(),
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
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      widget.studentName + "\n" + className,
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                      children: snapshot.data!.docs.map((e) {

                        return Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 231, 231, 231),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 130, 126, 126),
                                  width: 2.5,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      offset: Offset(2.0, 2.0))
                                ]),
                            child: Column(children: [
                              Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(2),
                                child: Text("${e.get("SubjectName")}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        heroTag: null,
                                        backgroundColor:
                                            const Color.fromARGB(255, 199, 248, 248),
                                        onPressed: () {
                                          /*
                                          if (_SubjectsRefList[0] != "") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      viewStudents(
                                                        ref: _SubjectsRefList[
                                                            _SubjectsNameList
                                                                .indexOf(e)],
                                                      )),
                                            );
                                          }
                                      */
                                        },
                                        child: Image.asset(
                                          "images/gradeIcon.png",
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: FittedBox(
                                          child: FloatingActionButton(
                                            heroTag: null,
                                            backgroundColor:
                                                const Color.fromARGB(255, 199, 248, 248),
                                            onPressed: () {
                                            //  getTeacher();
                                              callChatDetailScreen(
                                                  e['TeacherID'],
                                                  e.id
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
                                      e['msg_count'] == 0 ? Container() : Positioned(
                                        child: Container(
                                        height: 14,
                                        width: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle
                                        ),
                                        child: Center(child: Text("${e['msg_count']}",style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 7
                                        ),)),
                                      ))
                                    ],
                                  ),
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
            if (_SubjectsNameList.length == 0 && x == 0) {
              return const Center(child: Text(""));
            }
            if (/*_SubjectsNameList[0] == "" && */v == 1) {
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
