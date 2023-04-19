import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:halaqa_app/viewStudentsForGrades.dart';

class studentGrades extends StatefulWidget {
  const studentGrades({super.key, required this.stRef, required this.classRef});
  final DocumentReference stRef;
  final DocumentReference classRef;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class assessment {
  String name;
  var grade;

  assessment(this.name, this.grade);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "name  $name  garde $grade";
  }
}

class _EditProfilePageState extends State<studentGrades> {
  bool _isObscure3 = true;
  bool visible = false;
  List<assessment> assessmentsList = [];
  List<assessment> studentAssessmentsList = [];
  List<String> assessmentNamesList = [];
  List<int> assessmentStudentGradesList = [];

  final _formkey = GlobalKey<FormState>();

  bool customized = false;
  var numOfAssess = 6;
  var assessments;
  var assessments2;
  var gradeID;
  var x = 0;
  var y = 0;
  var v = 0;

  getData() {
    studentAssessmentsList.add(assessment("", 0));
    assessmentsList.add(assessment("", 0));
    x++;
  }

  checkCustomization() async {
    DocumentReference doc = await widget.classRef;
    await widget.classRef.get().then((value) async {
      setState(() {
        customized = value['customized'];
      });

      if (customized) {
        setState(() {
          numOfAssess = value['assessments'].length;
        });

        for (int i = 0; i < numOfAssess; i++) {
          Future<List<assessment>> getAssessment() async {
            final snapshots = await Future.wait(
                [doc.get().then((value) => value['assessments'][i])]);
            return snapshots
                .map((snapshot) =>
                    assessment(snapshot['name'], snapshot['grade']))
                .toList();
          }

          assessments = await getAssessment();
          // assessments2 = await getData();
          setState(() {
            // studentAssessmentsList.addAll(assessments);
            assessmentsList.addAll(assessments);
          });
        }

        var stRef = await widget.stRef
            .collection("Grades")
            .where('subjectID', isEqualTo: widget.classRef)
            .get();

        if (y == 0) {
          setState(() {
            assessmentsList.removeAt(0);
            // studentAssessmentsList.removeAt(0);
            y++;
          });
        }
        if (stRef.docs.length > 0) {
          var stRef = await widget.stRef
              .collection("Grades")
              .where('subjectID', isEqualTo: widget.classRef)
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.map((DocumentSnapshot document) {
              setState(() {
                gradeID = document.id;
              });
            }).toList();
          });

          print("in if");
          DocumentReference docu =
              await widget.stRef.collection("Grades").doc(gradeID);
          for (int i = 0; i < numOfAssess; i++) {
            Future<List<assessment>> getAssess() async {
              final snapshots = await Future.wait(
                  [docu.get().then((value) => value['assessments'][i])]);
              return snapshots
                  .map((snapshot) =>
                      assessment(snapshot['name'], snapshot['grade']))
                  .toList();
            }

            assessments2 = await getAssess();
            setState(() {
              studentAssessmentsList.addAll(assessments2);
            });
          }
          if (v == 0) {
            //   assessmentsList.removeAt(0);
            setState(() {
              studentAssessmentsList.removeAt(0);
            });
            print("object");
            v++;
          }
        } else {
          setState(() {
            for (int i = 0; i < numOfAssess; i++) {
              studentAssessmentsList
                  .add(assessment(assessmentsList[i].name, '-'));
            }
          });
          if (v == 0) {
            setState(() {
              studentAssessmentsList.removeAt(0);
              v++;
            });
          }
          widget.stRef.collection("Grades").add({
            "assessments":
                studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
            "subjectID": widget.classRef,
          });
        }
      } //end if customized = true
      else {
        notCustomized();

        studentAssessmentsList.add(assessment(assessmentsList[0].name, '-'));
        studentAssessmentsList.add(assessment(assessmentsList[1].name, '-'));
        studentAssessmentsList.add(assessment(assessmentsList[2].name, '-'));
        studentAssessmentsList.add(assessment(assessmentsList[3].name, '-'));
        studentAssessmentsList.add(assessment(assessmentsList[4].name, '-'));
        studentAssessmentsList.add(assessment(assessmentsList[5].name, '-'));
        studentAssessmentsList.removeAt(0);

        widget.stRef.collection("Grades").add({
          "assessments":
              studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
          "subjectID": widget.classRef,
        });
      } //end if not customized
    });
  }

  notCustomized() async {
    setState(() {
      assessmentsList.add(assessment("درجة الحضور", 10));
      assessmentsList.add(assessment("درجة المشاركة", 10));
      assessmentsList.add(assessment("درجة الواجبات", 5));
      assessmentsList.add(assessment("درجة المشاريع", 15));
      assessmentsList.add(assessment("درجة الاختبار الشهري", 20));
      assessmentsList.add(assessment("درجة الاختبار النهائي", 40));
      assessmentsList.removeAt(0);
    });

    await widget.classRef.update({
      'customized': true,
    });

    assessmentsList.forEach((assessment) async {
      await widget.classRef.update(({
        'assessments': FieldValue.arrayUnion([
          {'name': assessment.name, 'grade': assessment.grade}
        ])
      }));
    });
  }

  late bool checked = false;
  late bool changed = false;
  late var state;
  var origGrade;
  late var textGrade = '';
  void initState() {
    checkCustomization();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(customized.toString());
    return Scaffold(
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SizedBox(
          height: 50,
          width: 250,
          child: FloatingActionButton.extended(
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
              if (_formkey.currentState!.validate()) {
                f = await confirm();
              }
              if (f) {
                checked = false;
                changed = false;
                updateDatabase();
              }
            },
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 54, 172, 172),
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewStudentsForGrades(
                    ref: widget.classRef,
                  ),
                ),
              );
            }),
        actions: [],
      ),
      body: Form(
          key: _formkey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              new Container(
                child: SingleChildScrollView(
                  child: Builder(builder: (context) {
                    if (x == 0) {
                      getData();
                    }

                    if (studentAssessmentsList.length == numOfAssess) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: assessmentsList.length,
                        itemBuilder: (context, position) {
                          origGrade = studentAssessmentsList[position].grade;
                          state = studentAssessmentsList[position].grade;
                          if (state.toString() == '-') {
                            textGrade =
                                assessmentsList[position].grade.toString() +
                                    "/" +
                                    state.toString();
                          } else {
                            textGrade = state.toString() +
                                "/" +
                                assessmentsList[position].grade.toString();
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 20, 20.0, 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: [
                                    new Flexible(
                                      child: TextFormField(
                                        onChanged: (newText) {
                                          changed = true;
                                          if (newText.isEmpty) {
                                            setState(() {
                                              state = "-";
                                              textGrade = origGrade.toString() +
                                                  "/" +
                                                  assessmentsList[position]
                                                      .grade
                                                      .toString();
                                            });
                                            studentAssessmentsList[position]
                                                .grade = "-";
                                          } else {
                                            setState(() {
                                              state = double.parse(newText);
                                              textGrade = state.toString() +
                                                  "/" +
                                                  assessmentsList[position]
                                                      .grade
                                                      .toString();
                                            });
                                            studentAssessmentsList[position]
                                                .grade = double.parse(newText);
                                          }
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: InputDecoration(
                                          labelText:
                                              assessmentsList[position].name,
                                          hintText:
                                              'ادخل الرقم باللغة الإنجليزية',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            if (studentAssessmentsList[position]
                                                    .grade !=
                                                '-')
                                              state = studentAssessmentsList[
                                                      position]
                                                  .grade;
                                            else {
                                              studentAssessmentsList[position]
                                                      .grade !=
                                                  '-';
                                              state = '-';
                                            }
                                            textGrade =
                                                assessmentsList[position]
                                                        .grade
                                                        .toString() +
                                                    "/" +
                                                    state.toString();
                                          }
                                          if (!value!.isEmpty) if (double.parse(
                                                      value) <
                                                  0 ||
                                              double.parse(value) >
                                                  double.parse(
                                                      assessmentsList[position]
                                                          .grade
                                                          .toString())) {
                                            return "يجب ان تكون حدود الدرجة من 0 الى " +
                                                assessmentsList[position]
                                                    .grade
                                                    .toString();
                                          } else {
                                            return null;
                                          }
                                        },
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 20,
                                ),
                                new Container(
                                    child: SingleChildScrollView(
                                  child: Text(
                                    textGrade,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 45, 44, 44),
                                      fontSize: 20,
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                ),
              ),
            ],
          ))),
    );
  }

  Future<bool> confirm() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("تأكيد حفظ درجات الطالب؟"),
        actions: [
          TextButton(
              child: Text("لا",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("نعم", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

  Future<bool> confirmBackArrow() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("لم يتم حفظ التعديلات؟ هل تريد حفظ التعديلات؟"),
        actions: [
          TextButton(
              child: Text("لا",
                  style: TextStyle(color: Color.fromARGB(255, 208, 16, 16))),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          TextButton(
              child: Text("نعم", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                checked = true;
                Navigator.pop(context, true);
              })
        ],
      ),
    );
  }

  updateDatabase() async {
    double totalGrades = 0;
    for (int i = 0; i < assessmentsList.length; i++) {
      if (studentAssessmentsList[i].grade != '-')
        totalGrades += double.parse(studentAssessmentsList[i].grade.toString());
    }
    if (totalGrades > 0) {
      await widget.classRef.update({"uploadedUnifiedGrades": false});

      var stRef = await widget.stRef
          .collection("Grades")
          .where('subjectID', isEqualTo: widget.classRef)
          .get();
      if (stRef.docs.length > 0) {
        await widget.stRef
            .collection("Grades")
            .where('subjectID', isEqualTo: widget.classRef)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((documentSnapshot) {
            assessmentsList.forEach((assessment) async {
              documentSnapshot.reference.update({
                'assessments':
                    studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
              });
            });
          });
        });
      } else {
        widget.stRef.collection("Grades").add({
          "assessments":
              studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
          "subjectID": widget.classRef,
        });
      }
      if (!checked) {
        Fluttertoast.showToast(
            msg: "تم حفظ التعديلات بنجاح",
            backgroundColor: Color.fromARGB(255, 97, 200, 0));
      }
    }
  }
} //end class