import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/commissioner/add_commissioner.dart';
import 'package:halaqa_app/commissioner/commisioner_list.dart';
import 'package:halaqa_app/viewAnnouncement.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/viewChildSubjects.dart';
import 'package:halaqa_app/viewDocuments.dart';
import 'package:halaqa_app/pickup.dart';
import 'package:halaqa_app/chatDetailPS.dart';
import 'ParentEdit.dart';
import 'package:halaqa_app/viewAbcense.dart';

class parentHP extends StatefulWidget {
  const parentHP({
    super.key,
  });

  @override
  State<parentHP> createState() => _parentHPState();
}

class _parentHPState extends State<parentHP> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var className = "";
  var level = "";
  late List studentRefList;
  late List _FNList;
  late List _LNList;
  late List ClassID;
  late List viewedLastDocument;
  late List viewedLastAbsence;
  late List chatMsgCount;
  var x = 0;
  var v = 0;
  bool isExpanded = false;

  bool refreshed = false;

  var parentName = "";

  var numOfSubjects;
  var schoolID = "xx";

  String studentClassesToBeNotifiedOfDocument = ''; //for document notification
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    _FNList = [""];
    _LNList = [""];
    ClassID = [""];
    studentRefList = [""];
    viewedLastDocument = [false];
    viewedLastAbsence = [false];
    chatMsgCount = [0];

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
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("school", schoolID);

      break;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .doc('School/$schoolID/Parent/${user.uid}');

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      numOfSubjects = ds['Students'].length;
      setState(() {
        parentName = ds['FirstName'] + " " + ds['LastName'];
      });

      for (var i = 0; i < numOfSubjects; i++) {
        DocumentReference str = ds['Students'][i];
        var msg_count_sum;
        try {
          // here is change
          final querySnapshot = await FirebaseFirestore.instance
              .collection('School/$schoolID/Chats')
              .where('StudentID', isEqualTo: ds['Students'][i].id)
              .get();

          msg_count_sum = 0;
          for (var docSnapshot in querySnapshot.docs) {
            msg_count_sum += docSnapshot.get('To_Student_msg_count');
          }
        } catch (e) {
          //here is change
          print('Error completing: $e');
        }
        var clsName = await str.get().then((value) {
          setState(() {
            _FNList.add(value['FirstName']);
            ClassID.add(value['ClassID']);
            _LNList.add(value['LastName']);
            viewedLastAbsence.add(value['viewedLastAbsence']);
            viewedLastDocument.add(value['viewedLastDocument']);
            studentRefList.add(str);
            chatMsgCount.add(msg_count_sum);
          });
        });
      }

      setState(() {
        if (_FNList.length > 1 && !refreshed) {
          refreshed = true;
          _FNList.removeAt(0);
          _LNList.removeAt(0);
          ClassID.removeAt(0);
          viewedLastAbsence.removeAt(0);
          viewedLastDocument.removeAt(0);
          studentRefList.removeAt(0);
          chatMsgCount.removeAt(0);
          print('chatMsgCount///////// $chatMsgCount');
        }
      });
      if (_FNList[0] == "") {
        v++;
      }
    });
  }

  @override
  void initState() {
    //getStudents();

    requestPremission();
    getToken();
    initInfo();
    super.initState();
  }

//method to set the setting of the notification in foregroud
  initInfo() {
    var androidInitialize = const AndroidInitializationSettings('ic_launcher');
    var IOSInitialize = const IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: IOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
          List<String> info = payload.split("~");
          print(info[0]);
          if (info[0] == 'document') {
            setState(() {
              studentClassesToBeNotifiedOfDocument = info[1];
            });
          } else if (info[0] == 'event') {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => appBars(
                  schoolId: schoolID,
                  Index: 3,
                ),
              ),
            );
          } else if (info[0] == 'absence') {
            DocumentReference sturef = FirebaseFirestore.instance.doc(info[1]);
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => viewAbcense(
                        ref: sturef,
                      )),
            );
          } else if (info[0] == 'announcment') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => appBars(
                  schoolId: schoolID,
                  Index: 1,
                ),
              ),
            );
          } else if (info[0] == 'chat') {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => ChatdetailPS(
                        TeacherName: info[1],
                        TeacherUid: info[2],
                        StudentUid: info[3],
                        schoolId: info[4],
                        subjectId: info[5],
                        classID: info[6],
                      )),
            );
          }
        } else {}
      } catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');
      List<String> info = message.data['type'].split("~");
      if (info[0] == 'document') {
        setState(() {
          studentClassesToBeNotifiedOfDocument = info[1];
        });
      }

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('dbfood', 'dbfood',
              importance: Importance.max,
              icon: "ic_launcher",
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: true);
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const IOSNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true));

      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['type']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      var payload = message.data['type'];
      if (payload != null && payload.isNotEmpty) {
        List<String> info = payload.split("~");
        print(info[0]);
        if (info[0] == 'document') {
          setState(() {
            studentClassesToBeNotifiedOfDocument = info[1];
          });
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => appBars(
                schoolId: schoolID,
                Index: 0,
              ),
            ),
          );
        } else if (info[0] == 'event') {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => appBars(
                schoolId: schoolID,
                Index: 3,
              ),
            ),
          );
        } else if (info[0] == 'absence') {
          DocumentReference sturef = FirebaseFirestore.instance.doc(info[1]);
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => viewAbcense(
                      ref: sturef,
                    )),
          );
        } else if (info[0] == 'announcment') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => appBars(
                schoolId: schoolID,
                Index: 1,
              ),
            ),
          );
        } else if (info[0] == 'chat') {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => ChatdetailPS(
                      TeacherName: info[1],
                      TeacherUid: info[2],
                      StudentUid: info[3],
                      schoolId: info[4],
                      subjectId: info[5],
                      classID: info[6],
                    )),
          );
        }
      } else {}
    });
  }

//method to get token for notification
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      saveToken(token!); //to firestore
    });
  }

//save token to the user document
  void saveToken(String token) async {
    await getStudents();
    FirebaseFirestore.instance
        .doc('School/' + '$schoolID' + '/Parent/' + user!.uid)
        .update({'token': token});
  }

  //method to request premission to send notification
  void requestPremission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted notfication');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional');
    } else {
      print('user declined notification');
    }
  }

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
              return RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () async {
                    _FNList.clear();
                    _LNList.clear();
                    studentRefList.clear();
                    ClassID.clear();
                    viewedLastAbsence.clear();
                    viewedLastDocument.clear();
                    chatMsgCount.clear();

                    await getStudents();
                  },
                  child: Column(
                    children: [
                      new Container(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                        child: Text(
                          textAlign: TextAlign.center,
                          parentName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      new Container(
                        height: 500,
                        child: Container(
                          height: 550,
                          child: ListView(
                            //  physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                            children: _FNList.map((e) {
                              return Stack(
                                children: [
                                  Container(
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
                                      title: Text(
                                          e + " " + _LNList[_FNList.indexOf(e)],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 23,
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
                                                padding:
                                                    const EdgeInsets.all(25),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Stack(children: [
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
                                                                    Color.fromARGB(
                                                                        255,
                                                                        54,
                                                                        172,
                                                                        172),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            viewChildSubjcets(
                                                                              classRef: ClassID[_FNList.indexOf(e)],
                                                                              studentName: e + " " + _LNList[_FNList.indexOf(e)],
                                                                              stRef: studentRefList[_FNList.indexOf(e)],
                                                                              schoolID: schoolID,
                                                                              classId: ClassID[_FNList.indexOf(e)].id,
                                                                            )),
                                                                  );
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  "images/subjectsIcon.png",
                                                                  width: 55,
                                                                  height: 55,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                      chatMsgCount[_FNList
                                                                  .indexOf(e)] >
                                                              0
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Center(
                                                                  child: Text(
                                                                    chatMsgCount[
                                                                            _FNList.indexOf(e)]
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                                    ]),
                                                    Stack(children: [
                                                      Column(children: [
                                                        SizedBox(
                                                          width: 44,
                                                          height: 44,
                                                          child: FittedBox(
                                                            child:
                                                                FloatingActionButton(
                                                              heroTag: null,
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          54,
                                                                          172,
                                                                          172),
                                                              onPressed: () {
                                                                setState(() {
                                                                  studentClassesToBeNotifiedOfDocument =
                                                                      '';
                                                                });
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => viewDocuments(
                                                                          ref: ClassID[_FNList.indexOf(
                                                                              e)],
                                                                          studentRef:
                                                                              studentRefList[_FNList.indexOf(e)])),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons.folder,
                                                                color: Colors
                                                                    .black,
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
                                                      !viewedLastDocument[
                                                              _FNList.indexOf(
                                                                  e)] /////come back !!!!!!!!!!!!
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Center(),
                                                              ),
                                                            )
                                                          : Container()
                                                    ]),
                                                    Stack(children: [
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
                                                                    Color.fromARGB(
                                                                        255,
                                                                        54,
                                                                        172,
                                                                        172),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            viewAbcense(
                                                                              ref: studentRefList[_FNList.indexOf(e)],
                                                                            )),
                                                                  );
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  "images/absenceIcon.png",
                                                                  width: 44,
                                                                  height: 44,
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                      !viewedLastAbsence[
                                                              _FNList.indexOf(
                                                                  e)] /////come back !!!!!!!!!!!!
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Center(),
                                                              ),
                                                            )
                                                          : Container()
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
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          54,
                                                                          172,
                                                                          172),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              pickup(
                                                                                stRef: studentRefList[_FNList.indexOf(e)],
                                                                              )),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .airport_shuttle_rounded,
                                                                color: Colors
                                                                    .black,
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
                                  ),
                                  if (!viewedLastAbsence[_FNList.indexOf(e)] ||
                                      !viewedLastDocument[_FNList.indexOf(e)] ||
                                      chatMsgCount[_FNList.indexOf(e)] >
                                          0) /////come back !!!!!!!!!!!!
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        height: 14,
                                        width: 14,
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                        child: Center(),
                                      ),
                                    )
                                  else
                                    Container()
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ));
            }
            if (_FNList.length == 0 && x == 0) {
              return const Center(child: Text(""));
            }
            if (_FNList[0] == "" && v == 1) {
              return const Center(
                  child: Text("لا يوجد طلاب تابعين لولي الآمر"));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

//end method

}
