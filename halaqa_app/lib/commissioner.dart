import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class commissionerHP extends StatefulWidget {
  const commissionerHP({super.key});
  @override
  State<commissionerHP> createState() => _commissionerHPState();
}

class students {
  late String name;
  late DocumentReference? stRef = null;
  bool buttonVisible = true;

  students(this.name, this.stRef, this.buttonVisible);
}

class _commissionerHPState extends State<commissionerHP> {
  var x = 0;
  var v = 0;

  String _textToShow = "";
  var schoolID = "xx";
  var studentsRefs;
  var studentsNum = 0;
  bool isChecked = false;
  String comName = "";

  late List<students> studentName = [];
  getData() {
    studentName.add(students("", null, true));
    x++;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getStudents() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var col = FirebaseFirestore.instance
        .collectionGroup('Commissioner')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();

    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .doc('School/' + schoolID + '/Commissioner/' + user!.uid);

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      studentsNum = ds['Students'].length;
      v++;
      for (var i = 0; i < studentsNum; i++) {
        DocumentReference str = ds['Students'][i];
        comName = ds['FirstName'] + " " + ds['LastName'];

        var stName = await str.get().then((value) {
          setState(() {
            if (value["picked"] == "no") {
              studentName.add(students(
                  value["FirstName"] + " " + value["LastName"],
                  ds['Students'][i],
                  false));
              _textToShow = "تم إبلاغ المدرسة بقدومك ";
            } else {
              studentName.add(students(
                  value["FirstName"] + " " + value["LastName"],
                  ds['Students'][i],
                  true));
            }
          });
        });
      }
      setState(() {
        if (studentName.length > 1) {
          studentName.removeAt(0);
        }
      });
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
        ],
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

            if (snapshot.hasData && studentName[0].name != "") {
              return Container(
                  child: Container(

                      // padding: const EdgeInsets.fromLTRB(0.0, , 10.0, 0),
                      child: SingleChildScrollView(
                          // ignore: unnecessary_new
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
                      "قائمة الطلاب للاصطحاب:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  new Container(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      children: studentName.map((e) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: new Row(
                                // mainAxisAlignment:
                                //   MainAxisAlignment.spaceBetween,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  Container(
                                    // alignment: Alignment.centerRight,
                                    child: Text(e.name,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),

                                    margin: EdgeInsets.all(4),
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0, 10.0, 0),
                                    // padding: EdgeInsets.all(),
                                  ),
                                  Spacer(),
                                  e.buttonVisible
                                      ? GestureDetector(
                                          onTap: () {
                                            DocumentReference<Object?>? docRef =
                                                e.stRef;
                                            docRef?.update({
                                              "picked": "no",
                                              "time":
                                                  FieldValue.serverTimestamp()
                                            });
                                            // studentName[i].isChecked = false;

                                            setState(() {
                                              e.buttonVisible = false;
                                              _textToShow =
                                                  "تم إبلاغ المدرسة بقدومك ";
                                            });

                                            Future.delayed(
                                                Duration(minutes: 15), () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          commissionerHP()));
                                            });
                                          },
                                          child: Container(
                                            width: 130,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 113, 194, 186),
                                                  Color.fromARGB(
                                                      255, 54, 172, 172),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              //   borderRadius: BorderRadius.circular(100),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(5, 5),
                                                  blurRadius: 10,
                                                )
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                'ابلاغ المدرسة',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(_textToShow),

                                  //SizedBox(width: 100),
                                  //  Spacer(),

                                  // color: Color.fromARGB(255, 222, 227, 234),
                                ]));
                      }).toList(),
                    ),
                  ),
                ],
              ))));
            }
            if (studentName[0].name == "" && x == 1 && v == 0) {
              return Center(child: CircularProgressIndicator());
            }
            if (studentsNum == 0 && v == 1) {
              return Center(child: Text("لا يوجد طلاب تابعين"));
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget continueButton = TextButton(
      //continueButton
      child: Text("نعم"),
      onPressed: () async {
        CircularProgressIndicator();
        await FirebaseAuth.instance.signOut();
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.remove("email");
        pref.remove('type');
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
  }
}
