//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
        actions: [
          IconButton(
            onPressed: () {
              //conformation message
              showAlertDialog(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //context,
              //MaterialPageRoute(
              // builder: (context) => EditProfilePage()
              // ),
              //  );
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
            icon: Icon(
              Icons.account_circle_rounded,
            ),
          )
        ],
      ),
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
