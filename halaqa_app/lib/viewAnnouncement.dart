import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/grades.dart';
import 'package:full_screen_network_image/full_screen_network_image.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:halaqa_app/viewAnnouncement.dart';
import 'package:intl/intl.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class viewAnnouncement extends StatefulWidget {
  const viewAnnouncement({super.key});

  @override
  State<viewAnnouncement> createState() => _viewAnnouncementState();
}

class announcements {
  String content;
  String title;
  DateTime time;

  announcements(this.content, this.title, this.time);

  @override
  String toString() {
    // TODO: implement toString
    return "content  $content    title   $title";
  }
}

class _viewAnnouncementState extends State<viewAnnouncement> {
  List<announcements> announcementsList = [];
  List imageList = <String>[];

  var x = 0;
  var v = 0;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    announcementsList.add(announcements("", "", DateTime.now()));
    x++;
  }

  getAnnouncements() async {
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

    DocumentReference docRef =
        await FirebaseFirestore.instance.doc('School/' + '$schoolID');

    var EventRefs = await docRef.collection("Announcement").get();
    if (EventRefs.docs.length > 0) {
      await docRef.collection("Announcement").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          announcementsList.add(announcements(documentSnapshot['content'],
              documentSnapshot['title'], documentSnapshot['time'].toDate()));
        });
      });
    }

    setState(() {
      if (announcementsList.length > 1) {
        announcementsList.removeAt(0);
      }
      announcementsList.sort((a, b) {
        return a.time.compareTo(b.time);
      });
    });

    setState(() {
      if (imageList.length > 1) {
        imageList.removeAt(0);
      }
    });
    if (announcementsList[0].content == "") {
      v++;
    }
  }

  @override
  void initState() {
    getAnnouncements();

    super.initState();
  }

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    parentHP(),
    viewAnnouncement(),
  ];

  @override
  Widget build(BuildContext context) {
    // print('School/' + '$schoolID' + '/Teacher/' + user!.uid);
    return Scaffold(
      //appBar: AppBar(title: const Text("Teacher")),

      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('School/$schoolID/Announcement')
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

            if (snapshot.hasData && announcementsList[0].content != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return Container(
                  child: SingleChildScrollView(
                      child: new Column(
                children: [
                  new Container(
                    height: 120,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      color: Color.fromARGB(255, 255, 255, 255),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 76, 170, 175),
                          Color.fromARGB(255, 255, 255, 255)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      "الإعلانات",
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
                      children: announcementsList.map((e) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 251, 250, 250),
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
                                alignment: Alignment.topLeft,
                                child: Text(
                                    DateFormat('MMM d, h:mm a').format(e.time),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(2),
                              ),
                              new Container(
                                child: Text(e.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(2),
                              ),
                              new Container(
                                child: Text(e.content,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(2),
                              ),
                            ]));
                      }).toList(),
                    ),
                  )
                ],
              )));
            }
            if (announcementsList.length == 0 && x == 0) {
              return Center(child: Text("لا توجد إعلانات بالوقت الحالي"));
            }
            if (announcementsList[0].content == "" && v == 1) {
              return Center(child: Text("لا توجد إعلانات بالوقت الحالي"));
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