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
  late Future<List<events>> _images;

  var schoolID = "xx";
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<events>> getEvents() async {
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
    var futures = <Future>[];
    DocumentReference docRef =
        await FirebaseFirestore.instance.doc('School/' + '$schoolID');

    var EventRefs = await docRef.collection("Event").get();
    if (EventRefs.docs.length > 0) {
      await docRef.collection("Event").get().then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          if (documentSnapshot['image'] == "") {
            eventList.add(events(
                documentSnapshot['content'],
                documentSnapshot['image'],
                documentSnapshot['title'],
                documentSnapshot['time'].toDate()));
          } else {
            futures.add(FirebaseStorage.instance
                .ref()
                .child("images/")
                .child(documentSnapshot['image'])
                .getDownloadURL()
                .then((url) {
              eventList.add(events(
                  documentSnapshot['content'],
                  url,
                  documentSnapshot['title'],
                  documentSnapshot['time'].toDate()));
            }));
          }
        });
      });
      await Future.wait(futures);
    }

    setState(() {
      eventList.sort((a, b) {
        // print(b.time.compareTo(a.time));
        return b.time.compareTo(a.time);
      });
    });

    return eventList;
  }

  @override
  void initState() {
    _images = getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _images,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && eventList.isEmpty) {
          return Text("لا توجد أحداث بعد");
          //
        }
        if (snapshot.hasData) {
          return Container(
              child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                    child: SingleChildScrollView(
                  child: new Container(
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
                )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          eventList.clear();
                          //  print("object")
                          //  imageList.clear();

                          await getEvents();
                        },
                        child: Container(
                            height: 550,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 239, 240, 240),
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            DateFormat('MMM d, h:mm a')
                                                .format(eventList[index].time),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        margin: EdgeInsets.all(4),
                                        padding: EdgeInsets.all(2),
                                      ),
                                      Container(
                                        child: Text(eventList[index].title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      new Container(
                                        child: Text(eventList[index].content,
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
                                              image: NetworkImage(
                                                  eventList[index].image ?? ""),
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
                                      ))
                                    ]));
                              },
                            ))))
              ],
            ),
          ));
        } else if (snapshot.hasError) {
          return Text("لاتوجد احداث بعد.");
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }

//end method

}
