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
          backgroundColor: Color.fromARGB(255, 54, 172, 172),
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
                height: 120,
                width: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20),
                child: Text(
                  widget.subName + "\n" + className + " / " + level,
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
                height: 10, // <-- SEE HERE
              ),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 239, 240, 240),
                  ),
                  margin: EdgeInsets.fromLTRB(8.0, 20, 8.0, 10),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height

                    child: InkWell(
                      splashColor:
                          Color.fromARGB(255, 149, 215, 215), // splash color
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
                  )),
              SizedBox(
                height: 10, // <-- SEE HERE
              ),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 239, 240, 240),
                  ),
                  margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 10),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height
                    // button width and height

                    // color:
                    //   Color.fromARGB(255, 212, 210, 207), // button color
                    child: InkWell(
                      splashColor:
                          Color.fromARGB(255, 149, 215, 215), // splash color
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
                  )),
              SizedBox(
                height: 10, // <-- SEE HERE
              ),
              new Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 239, 240, 240),
                  ),
                  margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 10),
                  child: SizedBox.fromSize(
                    size: Size(250, 170), // button width and height

                    //  , // button color
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => classGrades(
                                    subjectRef: widget.subRef,
                                  )),
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
                  )),
            ],
          ),
        )));
  }
}
