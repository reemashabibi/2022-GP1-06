import 'dart:io' as io;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

//for file download
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class viewAbcense extends StatefulWidget {
  const viewAbcense({super.key, required this.ref});
  final DocumentReference ref;
  @override
  State<viewAbcense> createState() => _viewAbcense();
}

class documents {
  String docId;
  DocumentReference ref;
  documents(this.docId, this.ref);
}

class _viewAbcense extends State<viewAbcense> {
  List<documents> stuAbcenses = [];

  var x = 0;
  var v = 0;
  var schoolID = "xx";

  User? user = FirebaseAuth.instance.currentUser;

  getData() {
    stuAbcenses.add(documents("", widget.ref));
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

    var EventRefs = await widget.ref
        .collection("Absence")
        .where("excuse", isEqualTo: '')
        .where('FileName', isEqualTo: '')
        .get();
    if (EventRefs.docs.length > 0) {
      await widget.ref
          .collection("Absence")
          .where("excuse", isEqualTo: "")
          .where('FileName', isEqualTo: '')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) async {
          stuAbcenses.add(documents(
              documentSnapshot.reference.id, documentSnapshot.reference));
        });
      });
    }

    setState(() {
      if (stuAbcenses.length > 1) {
        stuAbcenses.removeAt(0);
      }
    });

    if (stuAbcenses[0].docId == "") {
      v++;
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

            if (snapshot.hasData && stuAbcenses[0].docId != "") {
              //  dataGet();
              // _SubjectList = snapshot.data!['Subjects'];

              return ListView.builder(
                itemCount: stuAbcenses.length,
                itemBuilder: (context, index) {
                  final abcenseDay = stuAbcenses[index];

                  return ListTile(
                    title: Text(" غياب في التاريخ: " + abcenseDay.docId),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.drive_file_rename_outline_outlined,
                        color: Color.fromARGB(255, 96, 184, 255),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Excuse(
                                    abcneseRef: abcenseDay.ref,
                                    stuRef: widget.ref,
                                  )),
                        );
                      },
                    ),
                  );
                },
              );
            } //end of documents list
            if (stuAbcenses.length == 0 && x == 0) {
              return Center(child: Text("لا يوجد غيابات لم يتم ارفاق اعذارها"));
            }
            if (stuAbcenses[0].docId == "" && v == 1) {
              return Center(child: Text("لا يوجد غيابات لم يتم ارفاق اعذارها"));
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

// this class is for the upload excuse widget
class Excuse extends StatefulWidget {
  const Excuse({super.key, required this.abcneseRef, required this.stuRef});
  final DocumentReference abcneseRef;
  final DocumentReference stuRef;
  @override
  State<Excuse> createState() => _Excuse();
}

class _Excuse extends State<Excuse> {
  final _formkey = GlobalKey<FormState>();
  String textExcuse = '';
  bool visible = false;
  PlatformFile? file;
  FocusNode focus = FocusNode(); //create focus node

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
                builder: (context) => viewAbcense(ref: widget.stuRef),
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
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    //      child: Text(
                    // "Edit profile",
                    //     style: TextStyle(
                    //   fontSize: 20,
                    //    color: Color.fromARGB(255, 49, 49, 49)
                    //    ),
                    // ),
                  )
                ],
              )),
            ),
            Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "ارفاق عذر غياب للتاريخ ${widget.abcneseRef.id}", //  text ??
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: 30,
                          ),
                        ),

//////////////////////// Inputs /////////////////////////

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // maxLength: 20,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          onChanged: (newText) {
                            textExcuse = newText;
                          },
                          decoration: InputDecoration(
                            hintText: "كتابة عذر الغياب هنا",
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: " عذر الغياب",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          // maxLines: 1,
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
                              Icons.download,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles();
                              setState(() {
                                file = result?.files.first;
                              });
                            },
                          ),
                        ),

                        if (file != null) //show file name
                          Container(
                              child: Container(
                            child: Center(
                              child: Text(file!.name),
                            ),
                          )),
                        SizedBox(
                          height: 20,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visible = true;
                              focus.unfocus(); //unfocus
                            });
                            chackData();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    (Color.fromARGB(255, 170, 243, 250)),
                                    Color.fromARGB(255, 195, 196, 196)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "ارسال",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                //  child: CircularProgressIndicator(
                                //  color: Color.fromARGB(255, 160, 241, 250),
                                //  )
                                )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future chackData() async {
    if (file == null && (textExcuse == '' || textExcuse.trim() == '')) {
      Widget backbutton = TextButton(
        child: Text("حسنًا"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(" لم تقم بتعبأة البيانات "),
        content:
            Text('لرفع عذر غياب يجب على الأقل تعبئة صندوق النص او رفع ملف'),
        actions: [backbutton],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      uploadData();
    }
  }

  UploadTask? uploadTask;

  Future<void> uploadData() async {
    if (_formkey.currentState!.validate()) {
      var studentId = widget.abcneseRef.parent.parent!.id;
      var day = widget.abcneseRef.id;

      await widget.abcneseRef.update({
        'excuse': textExcuse,
        'FileName': file?.name,
        'Viewed': false,
      }).then(((value) async {
        if (file != null) {
          final path = 'Parent Files/${file!.name}$studentId@$day';
          final filepath = io.File(file!.path!);

          final ref = FirebaseStorage.instance.ref().child(path);
          uploadTask = ref.putFile(filepath);
        }
      }));

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "تم رفع عذر الغياب بنجاح",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
              content: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 50.0,
              ),
              actions: [
                TextButton(
                  child: Text("حسنًا"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => viewAbcense(
                                ref: widget.stuRef,
                              )),
                    );
                  },
                )
              ],
            );
          });
      return;
    }
  }
}
