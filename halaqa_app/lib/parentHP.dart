import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:halaqa_app/commissioner/add_commissioner.dart';
import 'package:halaqa_app/commissioner/commisioner_list.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/viewChildSubjects.dart';
import 'package:halaqa_app/viewDocuments.dart';
import 'package:halaqa_app/pickup.dart';
import 'package:halaqa_app/chatDetailPS.dart';
import 'ParentEdit.dart';
import 'package:halaqa_app/viewAbcense.dart';
import 'package:halaqa_app/viewDocuments.dart';
import 'package:halaqa_app/viewAbcense.dart';
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
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
        .doc('School/$schoolID/Parent/${user.uid}');

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
    //getStudents();

    requestPremission();
    getToken();
    initInfo();

    super.initState();
  }

//method to set the setting of the notification in foregroud
  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('images/logo.png');
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
                builder: (context) => viewEvents(),
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
                builder: (context) => viewEvents(),
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

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('dbfood', 'dbfood',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
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
        } else if (info[0] == 'event') {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => viewEvents(),
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
              builder: (context) => viewEvents(),
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

  String studentClassesToBeNotifiedOfDocument = '';

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
                          offset: Offset(0, 3), // changes position of shadow
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
                                                                54, 172, 172),
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
                                                              54, 172, 172),
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
                                                studentClassesToBeNotifiedOfDocument
                                                        .contains(ClassID[
                                                                _FNList.indexOf(
                                                                    e)]
                                                            .id)
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 14,
                                                          width: 14,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle),
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
                                                            Color.fromARGB(255,
                                                                54, 172, 172),
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
