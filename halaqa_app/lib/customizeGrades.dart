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
  int? grade;

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

  final nameController = TextEditingController();
  final gradeController = TextEditingController();

  @override
  void initState() {
    //assessmentsList.add(assessment('', 0));
    checkCustomization();
    super.initState();
  }

  var grade = 0;
  late bool changed = false;
  late bool Added = false;
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
              Text('إضافة')
            ],
          ),
          onPressed: () {
            _addNewAssessment();
            Added = true;
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
              Text('حفظ')
            ],
          ),
          onPressed: () async {
            var f = false;
            f = await confirmDeleltingStudentGrades();
            if (f) {
              if (assessmentsList.length != 0) {
                checked = false;
                changed = false;
                updateDatabase();
                Added = false;
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "لم يتم اضافة اي متطلب!",
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 76, 170, 175),
          ),
          onPressed: () async {
            int totalGrades = 0;
            for (int i = 0; i < assessmentsList.length; i++) {
              totalGrades += assessmentsList[i].grade!;
            }
            if (changed) {
              showDialog(
                context: context,
                builder: (dialogContex) => AlertDialog(
                  content: Text("لم يتم حفظ التعديلات؟ هل تريد حفظ التعديلات؟"),
                  actions: [
                    TextButton(
                        child: Text("لا",
                            style: TextStyle(
                                color: Color.fromARGB(255, 208, 16, 16))),
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
                          //  Navigator.pop(context, );
                        }),
                    TextButton(
                        child: Text("نعم",
                            style: TextStyle(
                                color: Color.fromARGB(255, 83, 158, 229))),
                        onPressed: () async {
                          if (await confirmDeleltingStudentGrades()) {
                            Navigator.pop(dialogContex);
                            bool accepted = await updateDatabase();
                            if (accepted) {
                              print("accep");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (contextt) => grades(
                                    subRef: widget.subjectRef,
                                    subName: subName,
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                            //   Navigator.pop(context);

                          }
                          //Navigator.pop(context);
                        })
                  ],
                ),
              );
            } else if (Added) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text("لم يتم حفظ التعديلات؟ هل تريد حفظ التعديلات؟"),
                  actions: [
                    TextButton(
                        child: Text("لا",
                            style: TextStyle(
                                color: Color.fromARGB(255, 208, 16, 16))),
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
                          //  Navigator.pop(context, );
                        }),
                    TextButton(
                        child: Text("نعم",
                            style: TextStyle(
                                color: Color.fromARGB(255, 83, 158, 229))),
                        onPressed: () {
                          updateDatabase();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => grades(
                                subRef: widget.subjectRef,
                                subName: subName,
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => grades(
                    subRef: widget.subjectRef,
                    subName: subName,
                  ),
                ),
              );
            }
          },
        ),
        actions: [],
      ),
      body: Form(
          key: _formkey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              // ignore: unnecessary_new
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
                      /*gradeController.text =
                          assessmentsList[position].grade.toString();*/
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
                                    //  keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: assessmentsList[position].name),
                                    onChanged: (newText) {
                                      changed = true;
                                      assessmentsList[position].name = newText;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "اسم المتطلب",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "ادخل اسم المتطلب";
                                      } else {
                                        return null;
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                ),
                                // ignore: unnecessary_new
                                new Flexible(
                                    child: Focus(
                                  child: TextFormField(
                                    //   keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      // for below version 2 use this
// for version 2 and greater youcan also use this
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: TextEditingController(
                                        text: assessmentsList[position]
                                            .grade
                                            .toString()),
                                    onChanged: (newText) {
                                      //  gradeController.clear();
                                      changed = true;
                                      //grade = int.parse(newText);

                                      assessmentsList[position].grade =
                                          int.parse(newText);
                                      print(newText);
                                    },
                                    decoration: InputDecoration(
                                      labelText: "درجة المتطلب",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "أدخل درجة المتطلب";
                                      }
                                      if (int.parse(value) == 0) {
                                        return "لا يمكن للدرجة أن تساوي  صفر";
                                      } else {
                                        return null;
                                      }
                                    },
                                    maxLines: 1,
                                  ),
                                )),
                              ],
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                var f = false;
                                f = await confirmDelete();
                                if (f) {
                                  setState(() {
                                    assessmentsList.removeAt(position);
                                    delete();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              )),
            ],
          ))),
    );
  }

  Future<bool> updateDatabase() async {
    if (_formkey.currentState!.validate()) {
      int totalGrades = 0;
      for (int i = 0; i < assessmentsList.length; i++) {
        totalGrades += assessmentsList[i].grade!;
      }
      if (totalGrades == 100 &&
          assessmentsList.length > 0 &&
          totalGrades != 0) {
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
        // delete();
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
        if (!checked) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "تم حفظ التعديلات",
                    style: TextStyle(
                        // color: Colors.red,
                        ),
                  ),
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "لم تتم حفظ التغييرات، مجموع الدرجات لا يساوي ١٠٠!",
                  style: TextStyle(
                      // color: Colors.red,
                      ),
                ),
              );
            });
        return false;
      }
    }
    return false;
  }

  delete() async {
    int totalGrades = 0;
    for (int i = 0; i < assessmentsList.length; i++) {
      totalGrades += assessmentsList[i].grade!;
    }
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

    await widget.subjectRef.update({'assessments': FieldValue.delete()});
  }

  var checked = false;
  Future<bool> confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("هل تريد تأكيد عملية حذف المتطلب؟"),
        content: const Text(
            'تنبيه!\nعند تأكيد عملية الحذف سيتم حذف جميع درجات الطلاب اللتي تم رصدها مسبقاً.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("لا",
                style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("نعم", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Future<bool> confirmDeleltingStudentGrades() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("هل تريد تأكيد عملية حفظ التعديلات؟"),
        content: const Text(
            'تنبيه!\nعند تأكيد عملية الحفظ سيتم حذف جميع درجات الطلاب اللتي تم رصدها مسبقاً.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("لا",
                style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
          ),
          TextButton(
            onPressed: (() {
              checked = true;
              Navigator.pop(context, true);
            }),
            child: Text("نعم", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
