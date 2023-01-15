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
  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    eventList.add(events("", "", "", DateTime.now()));
    imageList.add("start");
    x++;
  }

  getSubjects() async {
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
              documentSnapshot['Time'].toDate()));
        });
      });
    }

    setState(() {
      if (eventList.length > 1) {
        eventList.removeAt(0);
      }
      eventList.sort((a, b) {
        return a.time.compareTo(b.time);
      });
    });
    for (int i = 0; i < eventList.length; i++) {
      imageList.add(await getImage(eventList[i].image));
    }

    setState(() {
      if (imageList.length > 1) {
        imageList.removeAt(0);
      }
    });
    if (eventList[0].content == "") {
      v++;
    }
  }

  Future<void> getSchoolID() async {
    User? user = FirebaseAuth.instance.currentUser;
    var col = FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }
  }

  Future<String?> getImage(img) async {
    if (img == "") {
      return "";
    }
    try {
      var downloadURL = await FirebaseStorage.instance
          .ref()
          .child("images/")
          .child(img)
          .getDownloadURL();

      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // getSchoolID();
    getSubjects();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('School/' + '$schoolID' + '/Teacher/' + user!.uid);
    return Scaffold(
      //appBar: AppBar(title: const Text("Teacher")),
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
          currentIndex: 1, // Use this to update the Bar giving a position
          inactiveColor: Color.fromARGB(255, 9, 18, 121),
          indicatorColor: Color.fromARGB(255, 76, 170, 175),
          activeColor: Color.fromARGB(255, 76, 170, 175),
          onTap: (index) {
            setState(() {
              currentIndex:
              index;
            });
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

            if (snapshot.hasData &&
                eventList[0].content != "" &&
                imageList[0] != "start") {
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
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                      //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      children: eventList.map((e) {
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
                              new Container(
                                  child: FullScreenWidget(
                                child: InteractiveViewer(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          imageList[eventList.indexOf(e)] ??
                                              ""),
                                      fit: BoxFit.contain,
                                      imageErrorBuilder: (BuildContext context,
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
                    ),
                  )
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
