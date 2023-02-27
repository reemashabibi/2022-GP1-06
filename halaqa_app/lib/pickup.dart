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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

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
  TextEditingController dateInput = TextEditingController();
  //DateTime selectedDate = DateTime.now();
  var selectedDate;
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
        if (data == 'no' ||
            (doc["someone"] == "yes" &&
                doc["date"] == DateFormat(' MMM d').format(DateTime.now()))) {
          setState(() {
            if (data == 'no') {
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
        backgroundColor: const Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              if (_formVisible && _buttonVisible)
                SingleChildScrollView(
                  child: Form(
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
                              final regex = RegExp(
                                  r'^[\d\u0660-\u0669\u06F0-\u06F9]{10}$');
                              if (regex.hasMatch(value)) {
                                return 'يرجي التأكد من إدخال ١٠ أرقام فقط';
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
                              final regex = RegExp(
                                  r'^[\d\u0660-\u0669\u06F0-\u06F9]{10}$');
                              if (regex.hasMatch(value)) {
                                return 'يرجي التأكد من إدخال ١٠ أرقام فقط';
                              }

                              return null;
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Center(
                              child: DropdownButton<String>(
                                value: selectedDate,
                                hint: Text("Select a date"),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDate = value;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: "1",
                                    child: Text(
                                        "اليوم (${DateFormat('dd/MM/yyyy').format((DateTime.now()))})"),
                                  ),
                                  DropdownMenuItem(
                                    value: "2",
                                    child: Text(
                                        "غداً (${DateFormat('dd/MM/yyyy').format((DateTime.now().add(Duration(days: 1))))})"),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),
          _buttonVisible
              ? Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GestureDetector(
                    onTap: () async {
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
                          var dd;
                          DocumentReference docRef =
                              await FirebaseFirestore.instance.doc(i);
                          if (selectedDate == "1") {
                            dd = DateFormat(' MMM d').format((DateTime.now()));
                          } else {
                            dd = DateFormat(' MMM d').format(
                                (DateTime.now().add(Duration(days: 1))));
                          }
                          docRef.update({
                            "date": dd,
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
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 113, 194, 186),
                            Color.fromARGB(255, 54, 172, 172),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        //   borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'تأكيد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ))
              : Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(_textToShow),
                ),
        ],
      ),
    );
  }
}
