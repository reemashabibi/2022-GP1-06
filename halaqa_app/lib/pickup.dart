import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewChildGrades.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter/src/rendering/box.dart';

class pickup extends StatefulWidget {
  const pickup({this.stRef});
  final stRef;
  State<pickup> createState() => _pick();
}

class _pick extends State<pickup> {
  var x = 0;
  var name = "";
  var phone = "";
  var nid = "";
  var i = '';
  final _formKey = GlobalKey<FormState>();
  //var schoolID = "xx";
  bool _buttonVisible = true;
  String _textToShow = "";
  bool _formVisible = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    i = widget.stRef.path;
    DocumentReference docRef =
        FirebaseFirestore.instance.doc(widget.stRef.path);
    docRef.get().then(
      (DocumentSnapshot doc) {
        var data = doc["picked"];
        print(data);
        if (data == 'no') {
          setState(() {
            if (doc["someone"] == "no") {
              _textToShow = "تم إبلاغ المدرسة بقدومك ";
              _buttonVisible = false;
            } else {
              _textToShow = "تم إبلاغ المدرسة بقدوم " + doc["fullname"];
              _buttonVisible = false;
            }
          });
        } else {
          _buttonVisible = true;
        }
        // ...
      },
    );

    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              new Container(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'اصطحاب الطلاب',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  if (_buttonVisible)
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        'اختر مستلم الطالب لليوم :',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    )
                  else
                    Container(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                children: [
                  _buttonVisible
                      ? Radio(
                          value: 1,
                          groupValue: x,
                          onChanged: (value) {
                            setState(() {
                              x = value!;
                              _formVisible = false;
                            });
                          },
                        )
                      : Container(),
                  _buttonVisible ? Text('أنا') : Container(),
                  SizedBox(height: 10),
                ],
              ),
              Row(
                children: [
                  _buttonVisible
                      ? Radio(
                          value: 2,
                          groupValue: x,
                          onChanged: (value) {
                            setState(() {
                              x = value!;
                            });
                            setState(() {
                              _formVisible = true;
                            });
                          },
                        )
                      : Container(),
                  _buttonVisible ? Text('شخص آخر') : Container(),
                ],
              ),
              _formVisible && _buttonVisible
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: " ادخل اسم الموكل كاملاً",
                              ),
                              validator: (value) {
                                name = value!;
                                if (value == "") {
                                  return ' يرجى إدخال اسم الموكل';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "ادخل رقم جوال الموكل",
                              ),
                              validator: (value) {
                                phone = value!;
                                if (value == "") {
                                  return ' يرجى إدخال رقم جوال الموكل';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "ادخل رقم هوية الموكل",
                              ),
                              validator: (value) {
                                nid = value!;
                                if (value == "") {
                                  return ' يرجى إدخال رقم هوية الموكل';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    )

                  // child: Text ('iiii' ) ,

                  // Form fields here

                  /*  
  onChanged: (text) {
    print('First text field: $text');
    name = text;
  },

*/

                  : Container(),
            ],
          ),
          _buttonVisible
              ? Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                    child: Text('تأكيد'),
                    onPressed: () async {
                      if (x == 1) {
                        i = widget.stRef.path;
                        //var jsonObject = i.toJson();
                        print(i);
                        DocumentReference docRef =
                            await FirebaseFirestore.instance.doc(i);
                        docRef.update({
                          "picked": "no",
                          "time": FieldValue.serverTimestamp()
                        });
                        setState(() {
                          _buttonVisible = false;
                          _textToShow = "تم إبلاغ المدرسة بقدومك ";
                        });
                      } else if (x == 2) {
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          print("2");
                          i = widget.stRef.path;
                          //var jsonObject = i.toJson();
                          print(i);
                          DocumentReference docRef =
                              await FirebaseFirestore.instance.doc(i);
                          docRef.update({
                            "picked": "no",
                            "time": FieldValue.serverTimestamp(),
                            "someone": "yes",
                            "fullname": name,
                            "nid": nid,
                            "phone": phone,
                          });
                          setState(() {
                            _buttonVisible = false;
                            _textToShow = "تم إبلاغ المدرسة بقدوم " + name;
                          });
                        }
                      } else if (x == 0) {
                        AlertDialog(
                          title: Text("Sample Alert Dialog"),
                        );
                      }

                      Future.delayed(Duration(minutes: 15), () {
                        setState(() {
                          _textToShow = "";
                          _buttonVisible = true;
                        });
                      });
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(_textToShow),
                ),
        ],
      ),
    );
  }
}
