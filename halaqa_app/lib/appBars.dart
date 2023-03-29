import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:halaqa_app/ParentEdit.dart';
import 'package:halaqa_app/commissioner.dart';
import 'package:halaqa_app/commissioner/commisioner_list.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/viewAnnouncement.dart';
import 'package:halaqa_app/viewEvents.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'login_screen.dart';

//void main() => runApp(const bottomNavBar());

class appBars extends StatelessWidget {
  final schoolId;
  const appBars({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidget(
        schID: schoolId,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final schID;
  const MyStatefulWidget({super.key, required this.schID});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static String schID = "xx";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    parentHP(),
    viewAnnouncement(),
    CommissionerList(
      schoolID: schID,
    ),
    viewEvents(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    schID = widget.schID;
    //getSchoolId();

    super.initState();
  }

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
            icon: Icon(
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
                          schoolId: widget.schID,
                        )),
              );
            },
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        inactiveColor: Colors.black,
        indicatorColor: Color.fromARGB(255, 76, 170, 175),
        activeColor: Color.fromARGB(255, 76, 170, 175),
        items: [
          TitledNavigationBarItem(
              title: Text('الصفحة الرئيسية',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.home)),
          TitledNavigationBarItem(
            title: Text('الإعلانات',
                style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.announcement),
          ),
          TitledNavigationBarItem(
            title: Text('المفوّضين',
                style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.drive_eta_rounded),
          ),
          TitledNavigationBarItem(
            title:
                Text('الأحداث', style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.calendar_today),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
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
  }

  /*Future<void> getSchoolId() async {
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
  } */ //end method

}
