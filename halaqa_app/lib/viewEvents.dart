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

class viewEvents extends StatefulWidget {
  const viewEvents({super.key});

  @override
  State<viewEvents> createState() => _viewEventsState();
}

class events {
  String content;
  String image;
  String title;
  DateTime time;

  events(this.content, this.image, this.title, this.time);

  @override
  String toString() {
    // TODO: implement toString
    return "content  $content  image $image   title   $title";
  }
}

class _viewEventsState extends State<viewEvents> {
  List<events> eventList = [];
  List imageList = <String>[];

  var x = 0;
  var v = 0;
  bool ImageRefreshed = false;
  bool refreshed = false;
  bool refreshedIm = false;
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    eventList.add(events("", "", "", DateTime.now()));
    imageList.add("start");
    x++;
  }

  getEvents() async {
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

    var EventRefs = await docRef.collection("Event").get();
    if (EventRefs.docs.length > 0) {
      await docRef.collection("Event").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          eventList.add(events(
              documentSnapshot['content'],
              documentSnapshot['image'],
              documentSnapshot['title'],
              documentSnapshot['time'].toDate()));
        });
      });
    }

    setState(() {
      if (eventList.length > 1 && !refreshed) {
        eventList.removeAt(0);
        refreshed = true;
      }
      eventList.sort((a, b) {
        // print(b.time.compareTo(a.time));
        return b.time.compareTo(a.time);
      });
    });

    for (int i = 0; i < eventList.length; i++) {
      //if()
      //print(eventList[i].title);
      if (eventList[i].image == "") {
        imageList.add("");
      } else {
        var downloadURL = await FirebaseStorage.instance
            .ref()
            .child("images/")
            .child(eventList[i].image)
            .getDownloadURL();
        imageList.add(downloadURL);
      }

      //imageList.add(await getImage(eventList[i].image));

      if (ImageRefreshed) {
        // print(i);
        imageList.removeAt(0);
      }
    }

    setState(() {
      if (imageList.length > 1 && !refreshedIm && !ImageRefreshed) {
        imageList.removeAt(0);
        refreshedIm = true;
      }
    });
    if (eventList[0].content == "") {
      v++;
    }
  }

  @override
  void initState() {
    // getSchoolID();
    getEvents();

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
              .collection('School/$schoolID/Event')
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

            if (snapshot.hasData && refreshed && imageList[0] != "start") {
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
                      "الأحداث",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  new Container(
                    child: RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        eventList.clear();
                        //  print("object")
                        //  imageList.clear();
                        ImageRefreshed = true;
                        await getEvents();
                      },
                      child: Container(
                          height: 550,
                          child: ListView(
                            //  physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                            children: eventList.map((e) {
                              return Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 251, 250, 250),
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 130, 126, 126),
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
                                          DateFormat('MMM d, h:mm a')
                                              .format(e.time),
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
                                    new Container(
                                        child: FullScreenWidget(
                                      child: InteractiveViewer(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                            image: NetworkImage(imageList[
                                                    eventList.indexOf(e)] ??
                                                ""),
                                            fit: BoxFit.contain,
                                            imageErrorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                              return const Text('');
                                            },
                                            placeholder:
                                                AssetImage("images/logo.png"),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ]));
                            }).toList(),
                          )),
                    ),
                  ),
                ],
              )));
            }
            if (eventList.length == 0 && x == 0) {
              return Center(child: Text("لا توجد أحداث بالوقت الحالي"));
            }
            if (eventList[0].content == "" && v == 1) {
              return Center(child: Text("لا توجد أحداث بالوقت الحالي"));
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
