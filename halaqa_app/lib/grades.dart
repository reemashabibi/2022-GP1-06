import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:halaqa_app/teacherHP.dart';

class grades extends StatefulWidget {
  const grades({super.key, required this.subRef});
  final DocumentReference subRef;

  @override
  State<grades> createState() => _gradesState();
}

class _gradesState extends State<grades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 76, 170, 175),
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
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Container(
                child: Text("class"),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 50, // <-- SEE HERE
              ),
              new Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  child: SizedBox.fromSize(
                    size: Size(200, 170), // button width and height
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

                              Text("ادخال درجة طالب"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 50, // <-- SEE HERE
              ),
              new Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  child: SizedBox.fromSize(
                    size: Size(200, 170), // button width and height
                    child: ClipOval(
                      child: Material(
                        // color:
                        //   Color.fromARGB(255, 212, 210, 207), // button color
                        child: InkWell(
                          splashColor: Color.fromARGB(
                              255, 149, 215, 215), // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/studentsIcon.png",
                                width: 130,
                                height: 100,
                                scale: 0.8,
                                fit: BoxFit.fitHeight,
                              ),

                              Text("ادخال درجة جميع طلاب الفصل"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}

class viewStudentsForGrades extends StatefulWidget {
  const viewStudentsForGrades({super.key, required this.ref});
  final DocumentReference ref;

  @override
  State<viewStudentsForGrades> createState() => _viewStudentsForGradesState();
}

class _viewStudentsForGradesState extends State<viewStudentsForGrades> {
  late List _StudentList;
  late List _StudenNameList;
  late List _StudentsRefList;
  var x = 0;
  var v = 0;
  var className;
  var levelName;

  var numOfStudents;

  getData() {
    _StudentList = [""];
    _StudentsRefList = [""];
    _StudenNameList = [""];
    x++;
  }

  getStudents() async {
    DocumentReference docRef =
        widget.ref.parent.parent as DocumentReference<Object?>;

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      className = ds['ClassName'];
      levelName = ds['Level'];

      numOfStudents = ds['Students'].length;
      for (var i = 0; i < numOfStudents; i++) {
        DocumentReference docu = ds['Students'][i];
        var stName = await docu.get().then((value) {
          setState(() {
            _StudenNameList.add(value['FirstName'] + " " + value['LastName']);
            _StudentsRefList.add(docu);
          });
        });
      }

      setState(() {
        if (_StudenNameList.length > 1) {
          _StudentList.removeAt(0);
          _StudenNameList.removeAt(0);
          _StudentsRefList.removeAt(0);
        }
      });
      if (_StudenNameList[0] == "") {
        v++;
      }
    });
  }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    DocumentReference ref = widget.ref;

    DocumentReference str = ref.parent.parent as DocumentReference<Object?>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 76, 170, 175),
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
      body: StreamBuilder<DocumentSnapshot>(
          stream: widget.ref.parent.parent?.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }
            if (snapshot.hasData && _StudenNameList[0] != "") {
              //Display the list

              return Container(
                  child: new Column(
                children: [
                  new Container(
                    child: Text(
                      className + " " + levelName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  new Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: _StudenNameList.map((e) {
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 244, 247, 253),
                                border: Border.all(
                                  color: Color(0xffEEEEEE),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    (Color.fromARGB(255, 170, 243, 250)),
                                    Color.fromARGB(255, 195, 196, 196)
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      offset: Offset(2.0, 2.0))
                                ]),
                            child: Text(e,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(15),
                            //   color: Color.fromARGB(255, 222, 227, 234),
                          ),
                          onTap: () {
                            if (_StudentsRefList[0] != "") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => studentGrades(
                                          stRef: _StudentsRefList[
                                              _StudenNameList.indexOf(e)],
                                          classRef: ref,
                                        )),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  )
                ],
              ));
            }
            if (_StudenNameList.length == 0 && x == 0) {
              return Center(child: Text("لم يتم تعيين أي فصل بعد."));
            }
            if (_StudenNameList[0] == "" && v == 1) {
              return Center(child: Text("لم يتم تعيين أي طالب بالفصل بعد."));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
