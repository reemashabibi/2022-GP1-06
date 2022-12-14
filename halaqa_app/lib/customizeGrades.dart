import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halaqa_app/grades.dart';

class customizeGrades extends StatefulWidget {
  static final String tag = 'single-list-use';
  final DocumentReference subjectRef;

  const customizeGrades({super.key, required this.subjectRef});
  @override
  _customizeGradesState createState() => _customizeGradesState();
}

class assessment {
  String name;
  int grade;

  assessment(this.name, this.grade);

  @override
  String toString() {
    // TODO: implement toString
    return "name  $name  garde $grade";
  }
}

bool customized = false;

class _customizeGradesState extends State<customizeGrades> {
  final _formkey = GlobalKey<FormState>();
  List<assessment> assessmentsList = [];
  Map<int, assessment> assessmentsMap = {};
  var numOfAssess = 0;

  var x = 0;
  var subName = "";

  checkCustomization() async {
    await widget.subjectRef.get().then((value) {
      setState(() {
        customized = value['customized'];
        subName = value['SubjectName'];
        if (customized) {
          numOfAssess = value['assessments'].length;
          //assessmentsList.addAll(value['assessments']);
        }
      });
    });
    var assessments;

    if (customized) {
      DocumentReference doc = widget.subjectRef;
      for (int i = 0; i < numOfAssess; i++) {
        Future<List<assessment>> getAssessment() async {
          final snapshots = await Future.wait(
              [doc.get().then((value) => value['assessments'][i])]);
          return snapshots
              .map(
                  (snapshot) => assessment(snapshot['name'], snapshot['grade']))
              .toList();
        }

        assessments = await getAssessment();
        setState(() {
          assessmentsList.addAll(assessments);
        });
      }
      for (int i = 0; i < assessmentsList.length; i++) {
        state += assessmentsList[i].grade!;
      }
    } else {
      setState(() {
        assessmentsList.add(assessment("???????? ????????????", 10));
        assessmentsList.add(assessment("???????? ????????????????", 10));
        assessmentsList.add(assessment("???????? ????????????????", 5));
        assessmentsList.add(assessment("???????? ????????????????", 15));
        assessmentsList.add(assessment("???????? ???????????????? ????????????", 20));
        assessmentsList.add(assessment("???????? ???????????????? ??????????????", 40));
      });
      DocumentReference doc = widget.subjectRef;
      for (int i = 0; i < numOfAssess; i++) {
        Future<List<assessment>> getAssessment() async {
          final snapshots = await Future.wait(
              [doc.get().then((value) => value['assessments'][i])]);
          return snapshots
              .map(
                  (snapshot) => assessment(snapshot['name'], snapshot['grade']))
              .toList();
        }

        assessments = await getAssessment();
        setState(() {
          assessmentsList.addAll(assessments);
        });
      }
      for (int i = 0; i < assessmentsList.length; i++) {
        state += assessmentsList[i].grade;
      }
    }
  }

  returnNumOfAssess() {
    return assessmentsList.length;
  }

  void _addNewAssessment() {
    setState(() {
      assessmentsList.add(assessment('', 0));
      numOfAssess = assessmentsList.length;
    });
  }

  late int state = 0;
  @override
  void initState() {
    state = 0;
    checkCustomization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton.extended(
          heroTag: null,
          label: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text('??????????')
            ],
          ),
          onPressed: () {
            _addNewAssessment();
          },
        ),
        FloatingActionButton.extended(
          heroTag: null,
          backgroundColor: Colors.green,
          label: Row(
            children: [
              Icon(
                Icons.done,
                color: Colors.white,
              ),
              Text('??????')
            ],
          ),
          onPressed: () async {
            var f = false;
            f = await conform();
            if (f) {
              if (assessmentsList.length != 0) {
                updateDatabase();
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "???? ?????? ?????????? ???? ??????????!",
                          style: TextStyle(
                              // color: Colors.red,
                              ),
                        ),
                      );
                    });
              }
            }
          },
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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
                builder: (context) => grades(
                  subRef: widget.subjectRef,
                  subName: subName,
                ),
              ),
            );
          },
        ),
        actions: [],
      ),
      body: Form(
          key: _formkey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              new Container(child: SingleChildScrollView(
                child: Builder(builder: (context) {
                  /*
            print("List : ${.toString()}");
            _studentMap = _studentList.asMap();
            print("MAP : ${_studentMap.toString()}");*/

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: assessmentsList.length,
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: [
                                new Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: assessmentsList[position].name),
                                    onChanged: (newText) {
                                      assessmentsList[position].name = newText;
                                      ;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "?????? ??????????????",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "???????? ?????? ??????????????";
                                      } else {
                                        return null;
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                                new Flexible(
                                  child: TextFormField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (newText) {
                                      setState(() {
                                        state = state -
                                            assessmentsList[position].grade;
                                        state += int.parse(newText);
                                      });

                                      assessmentsList[position].grade =
                                          int.parse(newText);
                                    },
                                    controller: TextEditingController(
                                        text: assessmentsList[position]
                                            .grade
                                            .toString()),
                                    decoration: InputDecoration(
                                      labelText: "???????? ??????????????",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "???????? ???????? ??????????????";
                                      }
                                      if (int.parse(value) == 0) {
                                        return "???????????? ???????????? ???? ?????????? ??????";
                                      } else {
                                        return null;
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                var f = false;
                                f = await conformDelete();
                                if (f) {
                                  setState(() {
                                    state =
                                        state - assessmentsList[position].grade;
                                    assessmentsList.removeAt(position);
                                    delete();
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              )), /*
              new Container(
                  child: SingleChildScrollView(
                child: Text(
                  "TOTAL GARDE: " + state.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 45, 44, 44),
                    fontSize: 30,
                  ),
                ),
              )),*/
            ],
          ))),
    );
  }

  updateDatabase() async {
    if (_formkey.currentState!.validate()) {
      int totalGrades = 0;
      for (int i = 0; i < assessmentsList.length; i++) {
        totalGrades += assessmentsList[i].grade!;
      }
      if (totalGrades == 100 && assessmentsList.length > 0) {
        print("totalGrades " + totalGrades.toString());
        await widget.subjectRef.update({
          'customized': true,
        });
        assessmentsList.forEach((assessment) async {
          await widget.subjectRef.update({'assessments': FieldValue.delete()});

          await widget.subjectRef.update(({
            'assessments': FieldValue.arrayUnion([
              {'name': assessment.name, 'grade': assessment.grade}
            ])
          }));
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "???? ?????? ??????????????????",
                  style: TextStyle(
                      // color: Colors.red,
                      ),
                ),
              );
            });

        var numOfStudents;

        DocumentReference docRef =
            widget.subjectRef.parent.parent as DocumentReference<Object?>;

        docRef.get().then((DocumentSnapshot ds) async {
          // use ds as a snapshot

          numOfStudents = ds['Students'].length;
          for (var i = 0; i < numOfStudents; i++) {
            DocumentReference docu = ds['Students'][i];
            var stRef = await docu
                .collection("Grades")
                .where('subjectID', isEqualTo: widget.subjectRef)
                .get();
            if (stRef.docs.length > 0) {
              var stRef = await docu
                  .collection("Grades")
                  .where('subjectID', isEqualTo: widget.subjectRef)
                  .get()
                  .then((querySnapshot) {
                querySnapshot.docs.map((DocumentSnapshot document) {
                  setState(() {
                    document.reference.delete();
                    // gradeID = document.id;
                  });
                }).toList();
              });
            }
          }
        });
      } else if (assessmentsList.length == 0) {
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "???? ?????? ?????? ???????????????????? ?????????? ?????????????? ???? ?????????? ??????!",
                  style: TextStyle(),
                ),
              );
            });
      }
    }
  }

  delete() async {
    if (assessmentsList.length > 0) {
      await widget.subjectRef.update({
        'customized': true,
      });
      assessmentsList.forEach((assessment) async {
        await widget.subjectRef.update({'assessments': FieldValue.delete()});

        await widget.subjectRef.update(({
          'assessments': FieldValue.arrayUnion([
            {'name': assessment.name, 'grade': assessment.grade}
          ])
        }));
      });
    }

    if (assessmentsList.length == 0) {
      print("in delete");
      await widget.subjectRef.update({
        'customized': false,
      });

      await widget.subjectRef.update({'assessments': FieldValue.delete()});
    }
    var numOfStudents;

    DocumentReference docRef =
        widget.subjectRef.parent.parent as DocumentReference<Object?>;

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot

      numOfStudents = ds['Students'].length;
      for (var i = 0; i < numOfStudents; i++) {
        DocumentReference docu = ds['Students'][i];
        var stRef = await docu
            .collection("Grades")
            .where('subjectID', isEqualTo: widget.subjectRef)
            .get();
        if (stRef.docs.length > 0) {
          var stRef = await docu
              .collection("Grades")
              .where('subjectID', isEqualTo: widget.subjectRef)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.map((DocumentSnapshot document) {
              setState(() {
                document.reference.delete();
                // gradeID = document.id;
              });
            }).toList();
          });
        }
      }
    });
  }

  Future<bool> conformDelete() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("???? ???????? ?????????? ?????????? ?????? ????????????????"),
        actions: [
          TextButton(
              child: Text("????",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("??????", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

  Future<bool> conform() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("???? ???????? ?????????? ?????????? ?????? ????????????????????"),
        actions: [
          TextButton(
              child: Text("????",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("??????", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }
}
