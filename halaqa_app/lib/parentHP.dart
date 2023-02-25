import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        if (_FNList.length > 1) {
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
    //  getSubjects();

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
              counter++;
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
    await getSubjects();
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

  int counter = 0;

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
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                          schoolId: schoolID,
                        )),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
        ],
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
          //currentIndex: 1, // Use this to update the Bar giving a position
          inactiveColor: Colors.black,
          indicatorColor: const Color.fromARGB(255, 76, 170, 175),
          activeColor: const Color.fromARGB(255, 76, 170, 175),
          onTap: (index) {
            // currentIndex:index;
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const viewEvents(),
                ),
              );
            } else if (index == 2) {
              print("!@)!@_)_@!");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommissionerList(
                    schoolId: schoolID,
                  ),
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
            ),
            TitledNavigationBarItem(
              title: const Text('مفوض',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.person),
            ),
            /*
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),

                    //padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    children: _FNList.map((e) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color.fromARGB(255, 251, 250, 250),
                              border: Border.all(
                                color: const Color.fromARGB(255, 130, 126, 126),
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    offset: Offset(2.0, 2.0))
                              ]),
                          child: Column(children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(2),
                              child: Text(e + " " + _LNList[_FNList.indexOf(e)],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: const Color.fromARGB(
                                          255, 199, 248, 248),
                                      onPressed: () {
                                        print(
                                            "(((((((((object))))))))) ${studentRefList[_FNList.indexOf(e)]}");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  viewChildSubjcets(
                                                    classRef: ClassID[
                                                        _FNList.indexOf(e)],
                                                    studentName: e +
                                                        " " +
                                                        _LNList[
                                                            _FNList.indexOf(e)],
                                                    stRef: studentRefList[
                                                        _FNList.indexOf(e)],
                                                    schoolID: schoolID,
                                                    classId: ClassID[
                                                            _FNList.indexOf(e)]
                                                        .id,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 199, 248, 248),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  viewDocuments(
                                                      ref: ClassID[
                                                          _FNList.indexOf(e)],
                                                      studentRef:
                                                          studentRefList[
                                                              _FNList.indexOf(
                                                                  e)])),
                                        );
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 199, 248, 248),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => viewAbcense(
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
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      backgroundColor: const Color.fromARGB(
                                          255, 199, 248, 248),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
//<<<<<<< HEAD
                                              //  builder: (context) =>
                                              //      pickup (
                                              //              stRef: studentRefList[
                                              //                  _FNList.indexOf(e)],
//=======
                                              builder: (context) => pickup(
                                                    stRef: studentRefList[
                                                        _FNList.indexOf(e)],
//>>>>>>> fdf9783d9b953822719c83b387f1785f4ca05dfc
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
                            )

                            // color: Color.fromARGB(255, 222, 227, 234),
                          ]));
                    }).toList(),
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
