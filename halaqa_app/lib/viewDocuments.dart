import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

//for file download
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class viewDocuments extends StatefulWidget {
  const viewDocuments({super.key, required this.ref, required this.studentRef});
  final DocumentReference ref;
  final DocumentReference studentRef;
  @override
  State<viewDocuments> createState() => _viewDocuments();
}

class documents {
  String displayName;
  String fileName;
  String docId;

  documents(this.displayName, this.fileName, this.docId);
}

class _viewDocuments extends State<viewDocuments> {
  List<documents> docInfoList = [];
  List docList = <String>[];

  var x = 0;
  var v = 0;
  var schoolID = "xx";

  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    docInfoList.add(documents("", "", ""));
    docList.add("start");
    x++;
  }

  getSubjects() async {
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

    var EventRefs = await docRef
        .collection("Documents")
        .where("Class", isEqualTo: widget.ref)
        .get();
    if (EventRefs.docs.length > 0) {
      await docRef
          .collection("Documents")
          .where("Class", isEqualTo: widget.ref)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          docInfoList.add(documents(documentSnapshot['DisplayName'],
              documentSnapshot['FileName'], documentSnapshot.reference.id));
        });
      });
    }

    setState(() {
      if (docInfoList.length > 1) {
        docInfoList.removeAt(0);
      }
    });
    for (int i = 0; i < docInfoList.length; i++) {
      docList.add(
          await getdoc(docInfoList[i].fileName + "@" + docInfoList[i].docId));
    }

    setState(() {
      if (docList.length > 1) {
        docList.removeAt(0);
      }
    });
    if (docInfoList[0].displayName == "") {
      v++;
    }
  }

  Future<String?> getdoc(img) async {
    if (img == "") {
      return "";
    }
    try {
      var downloadURL =
          await FirebaseStorage.instance.ref().child(img).getDownloadURL();

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
                docInfoList[0].displayName != "" &&
                docList[0] != "start") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return ListView.builder(
                itemBuilder: (context, index) {
                  final file = docInfoList[index];

                  return ListTile(
                    title: Text(file.displayName),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        var url = docList[index];

                        // requests permission for downloading the file
                        bool hasPermission = await _requestWritePermission();
                        if (!hasPermission) return;

                        // gets the directory where we will download the file.
                        var dir = await getApplicationDocumentsDirectory();

                        // You should put the name you want for the file here.
                        // Take in account the extension.
                        String fileName = docInfoList[index].fileName;

                        // downloads the file
                        Dio dio = Dio();
                        await dio.download(url, "${dir.path}/$fileName");

                        // opens the file
                        OpenFile.open("${dir.path}/$fileName");
                      },
                    ),
                  );
                },
              );
            } //end of documents list
            if (docInfoList.length == 0 && x == 0) {
              return Center(child: Text("لا يوجد مستندات بالوقت الحالي"));
            }
            if (docInfoList[0].displayName == "" && v == 1) {
              return Center(child: Text("لايوجد مستدنات بالوقت الحالي"));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
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
