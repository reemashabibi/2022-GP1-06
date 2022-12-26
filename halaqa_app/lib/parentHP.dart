import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';

class parentHP extends StatefulWidget {
  const parentHP({super.key});

  @override
  State<parentHP> createState() => _parentHPState();
}

class _parentHPState extends State<parentHP> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parent"),
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
          //    Navigator.of(context).push(
            //   // MaterialPageRoute(
                   // builder: (context) => const EditProfilePage()),
            //  );
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