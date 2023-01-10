import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halaqa_app/customizeGrades.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:halaqa_app/classGrades.dart';
import 'package:halaqa_app/viewStudentsForGrades.dart';

class grades extends StatefulWidget {
  const grades({super.key, required this.subRef, required this.subName});
  final DocumentReference subRef;
  final String subName;

  @override
  State<grades> createState() => _gradesState();
}

class _gradesState extends State<grades> {
  var className = "";
  var level = "";

  getClassName() async {
    DocumentReference doc =
        await widget.subRef.parent.parent as DocumentReference<Object?>;

    await doc.get().then((DocumentSnapshot ds) async {
      setState(() {
        className = ds['ClassName'];
        level = ds['LevelName'].toString();
      });
    });
    // print(className);
  }

  @override
  void initState() {
    getClassName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => teacherHP(),
                ),
              );
            },
          ),
          actions: [],
        ),
        body: Container(
            child: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Container(
                height: 150,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  color: Color.fromARGB(255, 255, 255, 255),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 76, 170, 175),
                      Color.fromARGB(255, 255, 255, 255)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  className + " / " + level + "\n" + widget.subName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 80, 80, 80),
                    fontSize: 30,
                  ),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 20, // <-- SEE HERE
              ),
              new Container(
                  // physics: const NeverScrollableScrollPhysics(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(width: 5, color: Colors.black),
                  ),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height
                    child: ClipOval(
                      child: Material(
                        // color:
                        //   Color.fromARGB(255, 212, 210, 207), // button color
                        child: InkWell(
                          splashColor: Color.fromARGB(
                              255, 149, 215, 215), // splash color
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => customizeGrades(
                                        subjectRef: widget.subRef,
                                      )),
                            );
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/editIcon.png",
                                width: 130,
                                height: 100,
                                scale: 0.8,
                                fit: BoxFit.fitHeight,
                              ),

                              Text(
                                "توزيع درجات المادة",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                  fontSize: 18,
                                ),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 20, // <-- SEE HERE
              ),
              new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(width: 5, color: Colors.black),
                  ),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height
                    child: ClipOval(
                      child: Material(
                        // color:
                        //   Color.fromARGB(255, 212, 210, 207), // button color
                        child: InkWell(
                          splashColor: Color.fromARGB(
                              255, 149, 215, 215), // splash color
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => viewStudentsForGrades(
                                        ref: widget.subRef,
                                      )),
                            );
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/studentIcon.png",
                                width: 130,
                                height: 100,
                                scale: 0.8,
                                fit: BoxFit.fitHeight,
                              ),

                              Text(
                                "ادخال درجة طالب",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                  fontSize: 18,
                                ),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 20, // <-- SEE HERE
              ),
              new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(width: 5, color: Colors.black),
                  ),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height
                    child: ClipOval(
                      child: Material(
                        color: Colors.white,
                        //  , // button color
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      classGrades(subjectRef: widget.subRef)),
                            );
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/studentsIcon.png",
                                width: 130,
                                height: 100,
                                //   scale: 0.8,
                                fit: BoxFit.fitHeight,
                              ),

                              Text(
                                "ادخال درجة موحدة \n لجميع طلاب الفصل",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                  fontSize: 16,
                                ),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        )));
  }
}
