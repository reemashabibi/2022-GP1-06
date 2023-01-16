import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halaqa_app/viewEvents.dart';
//import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/viewChildSubjects.dart';
//import 'package:halaqa_app/viewDocuments.dart';
import 'package:halaqa_app/pickup.dart';

import 'ParentEdit.dart';
//import 'package:halaqa_app/viewAbcense.dart';

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

  late List _FNList;
  late List _LNList;
  late List ClassID;
  var x = 0;
  var v = 0;

  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _FNList = [""];
    _LNList = [""];
    ClassID = [""];
    x++;
  }

  getSubjects() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;
    print("EMAIL ## ${user!.email}");
    print("EMAIL ## ${user.uid}");

    var col = FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user.email);
    var snapshot = await col.get();
    print(snapshot.docs.length);
    for (var doc in snapshot.docs) {
      print("ZQQQWQW ${doc.reference.parent.parent!.id}");
      schoolID = doc.reference.parent.parent!.id;
      break;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .doc('School/$schoolID/Parent/${user.uid}');

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      print("ZZZZ ${ds.data()}");

      setState(() {
        numOfSubjects = ds['Students'].length;
        parentName = ds['FirstName'] + " " + ds['LastName'];
      });

      for (var i = 0; i < numOfSubjects; i++) {
        DocumentReference str = ds['Students'][i];

        var clsName = await str.get().then((value) {
          setState(() {
            _FNList.add(value['FirstName']);
            ClassID.add(value['ClassID']);
            _LNList.add(value['LastName']);
          });
        });
      }

      setState(() {
        if (_FNList.length > 1) {
          _FNList.removeAt(0);
          _LNList.removeAt(0);
          ClassID.removeAt(0);
        }
      });
      if (_FNList[0] == "") {
        v++;
      }
    });
  }

  Future<void> getSchoolID() async {
    User? user = FirebaseAuth.instance.currentUser;
    var col = FirebaseFirestore.instance
        .collectionGroup('Parent')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      print("!!!!!!!!!!!!!!! ${doc.reference.parent.parent!.id}");
      schoolID = doc.reference.parent.parent!.id;
      print("ZZZZZZZ $schoolID");
      break;
    }
    setState(() {

    });
  }

  getDataOfData() async{
   await getSchoolID();
    getSubjects();
  }

  @override
  void initState() {
    print("PPPPPPPARRRENT LOGIN +++++++++++++++++++++++++++++++++++++++");
    getDataOfData();
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
        title: const Text('حلقة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 18, 121),
            )),
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
              color: Color.fromARGB(255, 9, 18, 121),
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(schoolId: schoolID,)),
        );
           
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Color.fromARGB(255, 9, 18, 121),
            ),
            iconSize: 30,
          ),
        ],
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
          //currentIndex: 1, // Use this to update the Bar giving a position
          inactiveColor: const Color.fromARGB(255, 9, 18, 121),
          indicatorColor: const Color.fromARGB(255, 76, 170, 175),
          activeColor: const Color.fromARGB(255, 76, 170, 175),
          onTap: (index) {
            currentIndex:
            index;
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
      /* bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 76, 170, 175),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              iconSize: 35,
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset(
                "images/eventsIcon.png",
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
*/
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .doc('School/$schoolID/Parent/${user!.uid}')
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

            if (snapshot.hasData && _FNList[0] != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      parentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,

                        color: Color.fromARGB(255, 151, 142, 142),

                        //  color: Color.fromARGB(255, 80, 80, 80),
                        // fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                      //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      children: _FNList.map((e) {
                        return Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 245, 245, 245),
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
                                child: Text(
                                    e + " " + _LNList[_FNList.indexOf(e)],
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
                                          print(ClassID[_FNList.indexOf(e)].id);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    viewChildSubjcets(
                                                      classRef: ClassID[_FNList.indexOf(e)],
                                                      studentName: e + " " + _LNList[_FNList.indexOf(e)],
                                                      schoolID: schoolID,
                                                      classId: ClassID[_FNList.indexOf(e)].id,
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
                                  const SizedBox(
                                    width: 15,
                                  ),
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
                                        child: const Icon(
                                          Icons.folder,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
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
                                          "images/absenceIcon.png",
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        heroTag: null,
                                        backgroundColor:
                                            const Color.fromARGB(255, 199, 248, 248),
                                        onPressed: () {
                                          
                                           
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    pickup (
                                       //              stRef: studentRefList[
                                        //                  _FNList.indexOf(e)],
                                                    )),
                                          );
                                        
                                       
                                        },
                                        child: const Icon(
                                          Icons.airport_shuttle_rounded,
                                          color: Colors.black,
                                          size: 40,
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
                  ),
                ],
              )));
            }
            if (_FNList.length == 0 && x == 0) {
              return const Center(child: Text(""));
            }
            if (_FNList[0] == "" && v == 1) {
              return const Center(child: Text("لا يوجد طلاب تابعين لولي الآمر"));
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
