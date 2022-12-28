import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/studentgrades.dart';

import 'grades.dart';

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

  var subName = "";
  getStudents() async {
    DocumentReference doc = await widget.ref;
    await widget.ref.get().then((value) async {
      setState(() {
        subName = value['SubjectName'];
      });
    });
    DocumentReference docRef =
        widget.ref.parent.parent as DocumentReference<Object?>;

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      className = ds['ClassName'];
      levelName = ds['LevelName'];

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
        backgroundColor: Color.fromARGB(255, 76, 170, 175),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => grades(
                  subRef: widget.ref,
                  subName: subName,
                ),
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
                  child: SingleChildScrollView(
                      child: new Column(
                children: [
                  new Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 40, 20.0, 20),
                    child: Text(
                      className + " / " + levelName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  new Container(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20),
                      shrinkWrap: true,
                      children: _StudenNameList.map((e) {
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color.fromARGB(255, 231, 231, 231),
                                border: Border.all(
                                  color: Color(0xffEEEEEE),
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      offset: Offset(2.0, 2.0))
                                ]),
                            child: Text(e,
                                textAlign: TextAlign.center,
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
              )));
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
