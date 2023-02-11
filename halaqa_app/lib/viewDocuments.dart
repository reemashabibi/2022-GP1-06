import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

//for file download
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool parentCanUpload;

  documents(this.displayName, this.fileName, this.docId, this.parentCanUpload);
}

class _viewDocuments extends State<viewDocuments> {
  List<documents> docInfoList =
      []; // list of document information from firestore
  List docList = <String>[]; //the url of the documents

  var x = 0;
  var v = 0;
  var schoolID = "xx";

  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    docInfoList.add(documents("", "", "", true));
    docList.add("start");
    x++;
  }

  getDocs() async {
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
        .where("Classes", arrayContains: widget.ref)
        .get();
    if (EventRefs.docs.length > 0) {
      await docRef
          .collection("Documents")
          .where("Classes", arrayContains: widget.ref)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          docInfoList.add(documents(
              documentSnapshot['DisplayName'],
              documentSnapshot['FileName'],
              documentSnapshot.reference.id,
              documentSnapshot['AllowReply']));
        });
      });
    }

    setState(() {
      if (docInfoList.length > 1) {
        docInfoList.removeAt(0);
      }
    });
    for (int i = 0; i < docInfoList.length; i++) {
      docList.add(await getdoc("School Files/" +
          docInfoList[i].fileName +
          "@" +
          docInfoList[i].docId)); // method to bring the url
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

  Future<String?> getdoc(path) async {
    if (path == "") {
      return "";
    }
    try {
      var downloadURL =
          await FirebaseStorage.instance.ref().child(path).getDownloadURL();

      return downloadURL;
    } catch (e) {
      return 'null';
    }
  }

  @override
  void initState() {
    getDocs();

    super.initState();
  }

  Map<int, double> downloadProgress = {};

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => appBars(),
              ),
            );
          },
        ),
        actions: [],
      ),

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
                itemCount: docInfoList.length,
                itemBuilder: (context, index) {
                  final file = docInfoList[index];
                  double? progress = downloadProgress[index];

                  return ListTile(
                    title: Text(file.displayName),
                    subtitle: progress != null
                        ? LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.black,
                          )
                        : null,
                    trailing: Wrap(spacing: 12, children: [
                      IconButton(
                        icon: const Icon(
                          Icons.file_download_outlined,
                          color: Color.fromARGB(255, 96, 184, 255),
                        ),
                        onPressed: () async {
                          // press to download file
                          var url = docList[index];

                          // requests permission for downloading the file
                          bool hasPermission = await _requestWritePermission();
                          if (!hasPermission) return;

                          // gets the directory where we will download the file.
                          var dir = await getExternalStorageDirectory();

                          // You should put the name you want for the file here.
                          // Take in account the extension.
                          if (dir != null) {
                            String fileName = docInfoList[index].fileName;
                            String savePath = "${dir.path}/$fileName";
                            print(savePath);

                            if (url != 'null')
                              // downloads the file
                              try {
                                await Dio().download(url, savePath,
                                    onReceiveProgress: (received, total) {
                                  if (total != -1) {
                                    print((received / total * 100)
                                            .toStringAsFixed(0) +
                                        "%");
                                    //you can build progressbar feature too
                                    double progress = received / total;

                                    setState(() {
                                      downloadProgress[index] = progress;
                                    });
                                  }
                                });
                                print("File is saved to download folder.");
                                // opens the file
                                OpenFile.open("${dir.path}/$fileName");
                              } on DioError catch (e) {
                                print(e.message);
                              }
                          }
                        },
                      ),
                      file.parentCanUpload
                          ? //can parent upload file?
                          IconButton(
                              icon: const Icon(
                                Icons.upload_file_rounded,
                                color: Color.fromARGB(255, 96, 184, 255),
                              ),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadDocument(
                                      docId: docInfoList[index].docId,
                                      stuRef: widget.studentRef,
                                      schoolID: schoolID,
                                      classRef: widget.ref,
                                      fileDisplayName:
                                          docInfoList[index].displayName),
                                ),
                              ),
                            )
                          : Text('') //if cant dont show icon upload
                    ]),
                  );
                },
              );
            } //end of documents list
            if (docInfoList.length == 0 && x == 0) {
              return Center(child: Text("لا يوجد مستندات بالوقت الحالي"));
            }
            if (docInfoList[0].displayName == "" && v == 1) {
              return Center(child: Text("لايوجد مستندات بالوقت الحالي"));
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

  Future<void> showAlertDialoglog(BuildContext context) async {
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

// this class is for the upload document widget
class UploadDocument extends StatefulWidget {
  const UploadDocument(
      {super.key,
      required this.docId,
      required this.stuRef,
      required this.schoolID,
      required this.classRef,
      required this.fileDisplayName});
  final String docId;
  final DocumentReference stuRef;
  final String schoolID;
  final String fileDisplayName;
  final DocumentReference classRef;
  @override
  State<UploadDocument> createState() => _UploadDocument();
}

class _UploadDocument extends State<UploadDocument> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  List docInfoList =
      <documents>[]; // list of the uploaded parent document name from firestore
  List docList = <String>[]; //the url of the documents

  var x = 0;
  var v = 0;
  var schoolID = "xx";

  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    docInfoList.add(documents("", "", "", true));
    docList.add("start");
    x++;
  }

  getDocs() async {
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
        .doc('School/$schoolID/Documents/${widget.docId}');

    var filledDocs = await widget.stuRef
        .collection('FilledDocuments')
        .where('DocumentID', isEqualTo: docRef)
        .get();

    if (filledDocs.docs.length > 0) {
      await widget.stuRef
          .collection('FilledDocuments')
          .where('DocumentID', isEqualTo: docRef)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          docInfoList.add(documents('', documentSnapshot['FileName'],
              documentSnapshot.reference.id, true));
        });
      });
    }

    setState(() {
      if (docInfoList.length > 1) {
        docInfoList.removeAt(0);
      }
    });
    for (int i = 0; i < docInfoList.length; i++) {
      docList.add(await getdoc("Parent Files/" +
          docInfoList[i].fileName +
          "@" +
          docInfoList[i].docId)); // method to bring the url
    }

    setState(() {
      if (docList.length > 1) {
        docList.removeAt(0);
      }
    });
    if (docInfoList[0].fileName == "") {
      v++;
    }
  }

  Future<String?> getdoc(path) async {
    if (path == "") {
      return "";
    }
    try {
      var downloadURL =
          await FirebaseStorage.instance.ref().child(path).getDownloadURL();

      return downloadURL;
    } catch (e) {
      return 'null';
    }
  }

  @override
  void initState() {
    getDocs();

    super.initState();
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => viewDocuments(
                  ref: widget.classRef,
                  studentRef: widget.stuRef,
                ),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(
                  colors: [
                    (Color.fromARGB(255, 208, 247, 247)),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ارفاق ملف ل${widget.fileDisplayName}", //  text ??
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 80, 80, 80),
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Text(
                                "الملفات المرفقة مسبقًا",
                                style: TextStyle(fontSize: 20),
                              ),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .doc('School/' +
                                          '$schoolID' +
                                          '/Parent/' +
                                          user!.uid)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Some error occurred ${snapshot.error}'));
                                    }

                                    //Check if data arrived
                                    if (x == 0) {
                                      getData();
                                    }

                                    if (snapshot.hasData &&
                                        docInfoList[0].fileName != "" &&
                                        docList[0] != "start") {
                                      //  dataGet();
                                      // _SubjectList = snapshot.data!['Subjects'];

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: docInfoList.length,
                                          itemBuilder: (context, index) {
                                            final file = docInfoList[index];
                                            return ListTile(
                                              title: Center(
                                                  child: InkWell(
                                                onTap: () => launchUrl(
                                                    Uri.parse(docList[index])),
                                                child: Text(
                                                  file.fileName,
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue),
                                                ),
                                              )),
                                            );
                                          });
                                    } else {
                                      print("it is empty${widget.docId}");
                                      return Center(child: Text('---'));
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(4.0),
                        child: ElevatedButton.icon(
                          label: Text(
                            "إرفاق ملف",
                            style: TextStyle(fontSize: 20),
                          ),
                          icon: Icon(
                            Icons.file_upload_outlined,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            selectFile(widget.docId, schoolID);
                          },
                        ),
                      ),
                      isloading
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 160, 241, 250),
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectFile(String docId, String schoolID) async {
    final result = await FilePicker.platform.pickFiles();

    setState(() {
      pickedFile = result?.files.first;
    });
    showAlertFileConfirem(context, docId, schoolID);
  }

  var fileURL; //the uploaded file by parent
  Future<void> showAlertFileConfirem(
      BuildContext context, String docId, String schoolID) async {
// start of show uploaded file url
    Widget backbutton = TextButton(
      child: Text("حسنًا"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alertSuccesfull = AlertDialog(
      title: Text("  تم رفع الملف بنجاح "),
      content: InkWell(
        onTap: () => launchUrl(Uri.parse(fileURL)),
        child: Text(
          'اضغط هنا لمشاهدة الملف',
          style: TextStyle(
              decoration: TextDecoration.underline, color: Colors.blue),
        ),
      ),
      actions: [backbutton],
    );
    //end of show uploaded file url

    // set up the buttons

    Widget continueButton = TextButton(
      //continueButton
      child: Text("نعم"),
      onPressed: () async {
        //upload the file
        Navigator.of(context).pop();
        widget.stuRef.collection("FilledDocuments").add({
          "FileName": pickedFile!.name,
          "DocumentID": FirebaseFirestore.instance
              .doc('School/$schoolID/Documents/$docId'),
          'Viewed': false
        }).then((documentSnapshot) async {
          final path =
              'Parent Files/${pickedFile!.name}@${documentSnapshot.id}';
          final file = io.File(pickedFile!.path!);

          final ref = FirebaseStorage.instance.ref().child(path);
          uploadTask = ref.putFile(file);
          setState(() {
            isloading = !isloading;
          });

          final snapshot = await uploadTask!.whenComplete(() => {});

          fileURL = await snapshot.ref.getDownloadURL();

          setState(() {
            isloading = !isloading;
          });
          showDialog(context: context, builder: (_) => alertSuccesfull);
        });
      }, //end of onPressed yes
    );

    Widget cancelButton = TextButton(
      //cancelButton
      child: Text("إلغاء",
          style: TextStyle(
            color: Colors.red,
          )),
      onPressed: () {
        Navigator.of(context).pop();
      }, //end of inpressed no
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),

      content: Text(
        " هل تأكد رفع الملف؟ ${pickedFile!.name}",
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

}//end of class
