import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class viewChildSubjcets extends StatefulWidget {
  const viewChildSubjcets({super.key, this.classRef, this.studentName});
  final classRef;
  final studentName;

  @override
  State<viewChildSubjcets> createState() => _viewChildSubjcetsState();
}

class _viewChildSubjcetsState extends State<viewChildSubjcets> {
  var className = "";
  var level = "";
  late List _SubjectList;
  late List _SubjectsNameList;
  late List _SubjectsRefList;

  var x = 0;
  var v = 0;
  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _SubjectsNameList = [""];
    //_SubjectList = [""];
    // _SubjectsRefList = [""];
    x++;
  }

  getSubjects() async {
    DocumentReference docRef = widget.classRef;
    var subRefs = await docRef.collection("Subject").get();
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
    });
  }

  @override
  void initState() {
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
        backgroundColor: Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => parentHP(),
              ),
            );
          },
        ),
        actions: [],
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
            if (index == 1) {}
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

            //Check if data arrived
            if (x == 0) {
              getData();
            }

            if (snapshot.hasData && _SubjectsNameList[0] != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: SingleChildScrollView(
                      child: new Column(
                children: [
                  new Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      widget.studentName + "\n" + className,
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
                      padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                      //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      children: _SubjectsNameList.map((e) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.all(10),
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
                                child: Text(e,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(2),
                              ),
                              new Container(
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
                                            Color.fromARGB(255, 199, 248, 248),
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
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        heroTag: null,
                                        backgroundColor:
                                            Color.fromARGB(255, 199, 248, 248),
                                        onPressed: () {
                                          /*
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => grades(
                                                      subRef: _SubjectsRefList[
                                                          _SubjectsNameList
                                                              .indexOf(e)],
                                                    )),
                                          );
                                        */
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
              return Center(child: Text(""));
            }
            if (_SubjectsNameList[0] == "" && v == 1) {
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
