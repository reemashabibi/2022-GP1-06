import 'dart:async';
import 'package:flutter/material.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/commissioner.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    if (email != null) {
      var type = prefs.getString("type");
      if (type == 'T') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => teacherHP()));
      } else if (type == 'P') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => appBars(
                schoolId: prefs.getString('school'),
                Index: 0,
              ),
            ));
      } else if (type == 'C') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => commissionerHP()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(colors: [
                  (Color.fromARGB(255, 255, 255, 255)),
                  Color.fromARGB(255, 255, 255, 255)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Center(
            child: Container(
              child: Image.asset("images/logo.png"),
            ),
          )
        ],
      ),
    );
  }
}
