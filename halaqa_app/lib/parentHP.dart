import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/viewChildSubjects.dart';
import 'package:halaqa_app/viewDocuments.dart';
import 'package:halaqa_app/viewAbcense.dart';
import 'package:halaqa_app/viewAnnouncement.dart';
import 'package:halaqa_app/pickup.dart';

import 'ParentEdit.dart';

class parentHP extends StatefulWidget {
  const parentHP({
    super.key,
  });

  @override
  State<parentHP> createState() => _parentHPState();
}

class _parentHPState extends State<parentHP> {
  var className = "";
  var level = "";
  late List studentRefList;
  late List _FNList;
  late List _LNList;
  late List ClassID;
  var x = 0;
  var v = 0;
  bool isExpanded = false;

  bool refreshed = false;

  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _FNList = [""];
    _LNList = [""];
    ClassID = [""];
    studentRefList = [""];
    x++;
  }

  getStudents() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var col = FirebaseFirestore.instance
        .collectionGroup('Parent')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .doc('School/' + '$schoolID' + '/Parent/' + user.uid);

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      numOfSubjects = ds['Students'].length;
      setState(() {
        parentName = ds['FirstName'] + " " + ds['LastName'];
      });

      for (var i = 0; i < numOfSubjects; i++) {
        DocumentReference str = ds['Students'][i];

        var clsName = await str.get().then((value) {
          setState(() {
            _FNList.add(value['FirstName']);
            ClassID.add(value['ClassID']);
            _LNList.add(value['LastName']);
            studentRefList.add(str);
          });
        });
      }

      setState(() {
        if (_FNList.length > 1 && !refreshed) {
          refreshed = true;
          _FNList.removeAt(0);
          _LNList.removeAt(0);
          ClassID.removeAt(0);
          studentRefList.removeAt(0);
        }
      });
      if (_FNList[0] == "") {
        v++;
      }
    });
  }

  @override
  void initState() {
    getStudents();

    super.initState();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            if (snapshot.hasData && refreshed) {
              return Container(
                  child: SingleChildScrollView(
                      child: new Column(
                children: [
                  new Container(
                    //   height: double.infinity,
                    width: MediaQuery.of(context).size.width,
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
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      parentName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  new Container(
                    child: RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        _FNList.clear();
                        _LNList.clear();
                        studentRefList.clear();
                        ClassID.clear();
                        await getStudents();
                      },
                      child: Container(
                        height: 550,
                        child: ListView(
                          //  physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),

                          //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                          children: _FNList.map((e) {
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
                                  Icons.person,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                title:
                                    Text(e + " " + _LNList[_FNList.indexOf(e)],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.black,
                                        )),
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
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(25),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                            Color.fromARGB(255,
                                                                44, 155, 144),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        viewChildSubjcets(
                                                                          classRef:
                                                                              ClassID[_FNList.indexOf(e)],
                                                                          studentName: e +
                                                                              " " +
                                                                              _LNList[_FNList.indexOf(e)],
                                                                          stRef:
                                                                              studentRefList[_FNList.indexOf(e)],
                                                                          schoolID:
                                                                              schoolID,
                                                                          classId:
                                                                              ClassID[_FNList.indexOf(e)].id,
                                                                        )),
                                                          );
                                                        },
                                                        child: Image.asset(
                                                          "images/subjectsIcon.png",
                                                          width: 55,
                                                          height: 55,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("المقررات"),
                                                ],
                                              ),
                                              Column(children: [
                                                SizedBox(
                                                  width: 44,
                                                  height: 44,
                                                  child: FittedBox(
                                                    child: FloatingActionButton(
                                                      heroTag: null,
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              40, 158, 127),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => viewDocuments(
                                                                  ref: ClassID[
                                                                      _FNList
                                                                          .indexOf(
                                                                              e)],
                                                                  studentRef: studentRefList[
                                                                      _FNList.indexOf(
                                                                          e)])),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.folder,
                                                        color: Colors.black,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("الملفات"),
                                              ]),
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
                                                            Color.fromARGB(255,
                                                                31, 146, 139),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        viewAbcense(
                                                                          ref: studentRefList[
                                                                              _FNList.indexOf(e)],
                                                                        )),
                                                          );
                                                        },
                                                        child: Image.asset(
                                                          "images/absenceIcon.png",
                                                          width: 44,
                                                          height: 44,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("الحضور"),
                                                ],
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
                                                            Color.fromARGB(255,
                                                                54, 172, 172),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        pickup(
                                                                          stRef:
                                                                              studentRefList[_FNList.indexOf(e)],
                                                                        )),
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .airport_shuttle_rounded,
                                                          color: Colors.black,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("الاصطحاب"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              )));
            }
            if (_FNList.length == 0 && x == 0) {
              return Center(child: Text(""));
            }
            if (_FNList[0] == "" && v == 1) {
              return Center(child: Text("لا يوجد طلاب تابعين لولي الآمر"));
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
        print(alert);
        return alert;
      },
    );
  } //end method

}
