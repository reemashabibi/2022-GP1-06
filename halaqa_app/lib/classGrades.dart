import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:http/http.dart';

class classGrades extends StatefulWidget {
  const classGrades({super.key, required this.subjectRef});

  final DocumentReference subjectRef;

  @override
  _classGradesState createState() => _classGradesState();
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

class _classGradesState extends State<classGrades> {
  final _formkey = GlobalKey<FormState>();
  List<assessment> assessmentsList = [];
  List<assessment> studentAssessmentsList = [];
  List<String> assessmentNamesList = [];
  List<int> unifiedGradesList = [];

  bool customized = false;
  bool uploadedUnifiedGrades = false;
  var subName = "";
  var numOfAssess = 6;
  var assessments;
  var studentAssessments;
  var assessments2;

  var gradeID;
  var x = 0;
  var y = 0;
  var w = 0;
  var numOfStudentsInClass = 0;

  late bool checked = false;
  late bool changed = false;
  getData() {
    assessmentsList.add(assessment("", 0));
    studentAssessmentsList.add(assessment("", 0));
    x++;
  }

  notCustomized() async {
    setState(() {
      // initially add standard customization for grades
      assessmentsList.add(assessment("درجة الحضور", 10));
      assessmentsList.add(assessment("درجة المشاركة", 10));
      assessmentsList.add(assessment("درجة الواجبات", 5));
      assessmentsList.add(assessment("درجة المشاريع", 15));
      assessmentsList.add(assessment("درجة الاختبار الشهري", 20));
      assessmentsList.add(assessment("درجة الاختبار النهائي", 40));
    });
    for (int i = 0; i < assessmentsList.length; i++) {
      studentAssessmentsList.add(assessment(assessmentsList[i].name,
          '-')); // students  get the assessment with initail grade zero
    }

    await widget.subjectRef.update({
      'customized': true,
    });
    assessmentsList.forEach((assessment) async {
      await widget.subjectRef.update(({
        'assessments': FieldValue.arrayUnion([
          {'name': assessment.name, 'grade': assessment.grade}
        ])
      }));
    });
  }

  checkCustomization() async {
    DocumentReference subjectRef =
        await widget.subjectRef.parent.parent as DocumentReference<Object?>;
    subjectRef.get().then((DocumentSnapshot ds) async {
      numOfStudentsInClass =
          ds['Students'].length; // get the number of Students in the Class
    });
    DocumentReference doc = await widget.subjectRef;
    await widget.subjectRef.get().then((value) async {
      setState(() {
        customized = value['customized'];
        subName = value['SubjectName'];
        try {
          uploadedUnifiedGrades = value['uploadedUnifiedGrades'];
        } catch (e) {
          uploadedUnifiedGrades = false;
        }
      });
      if (customized) {
        //if the grades are customized
        setState(() {
          numOfAssess = value['assessments'].length; // number of assessments
        });

        for (int i = 0; i < numOfAssess; i++) {
          Future<List<assessment>> getAssessment() async {
            setState(() {});
            final snapshots = await Future.wait(
                [doc.get().then((value) => value['assessments'][i])]);
            return snapshots
                .map((snapshot) => assessment(
                    snapshot['name'],
                    snapshot[
                        'grade'])) // get the name and the assigned grade for the assessments
                .toList();
          }

          assessments = await getAssessment();
          setState(() {
            assessmentsList.addAll(assessments); // add it to a List
          });

          if (y == 0) {
            setState(() {
              assessmentsList.removeAt(0); // remove initialization
              y++;
            });
          }

          // students  get the assessment with initail grade zero
        }
        if (uploadedUnifiedGrades) {
          subjectRef.get().then((DocumentSnapshot ds) async {
            DocumentReference studentRef = ds['Students'][0];
            var stRef = await studentRef
                .collection("Grades")
                .where('subjectID', isEqualTo: widget.subjectRef)
                .get();
            List<DocumentSnapshot> gradesList = stRef.docs;

            DocumentReference docu =
                await studentRef.collection("Grades").doc(gradesList[0].id);
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

/////////////////////////
            setState(() {
              print(studentAssessmentsList);
            });
          });
        } else {
          for (int i = 0; i < numOfAssess; i++) {
            studentAssessmentsList
                .add(assessment(assessmentsList[i].name, '-'));
          }
        }
        if (w == 0) {
          setState(() {
            studentAssessmentsList.removeAt(0); // remove initialization
            w++;
          });
        }
      } else {
        // if grades are not Customized
        if (y == 0) {
          setState(() {
            assessmentsList.removeAt(0); // remove initial value
            y++;
          });
        }
        notCustomized();
      }
    });
  }

  late var state;
  late var textGrade = '';
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
            // shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: () async {
              var f = false;
              if (_formkey.currentState!.validate()) {
                f = await confirmDeleltingStudentGrades();
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
        child: Builder(builder: (context) {
          //   print("studentAssessmentsList.lenght " +
          //   studentAssessmentsList.length.toString());

          if (x == 0) {
            getData();
          }
          if (assessmentsList.length == numOfAssess &&
              numOfStudentsInClass > 0 &&
              studentAssessmentsList.length == numOfAssess) {
            //  if (assessmentStudentGradesList.length == assessmentsList.length) {
            return ListView.builder(
              itemCount: assessmentsList.length,
              itemBuilder: (context, position) {
                state = studentAssessmentsList[position].grade;
                if (state.toString() == '-') {
                  textGrade = assessmentsList[position].grade.toString() +
                      "/" +
                      state.toString();
                } else {
                  textGrade = state.toString() +
                      "/" +
                      assessmentsList[position].grade.toString();
                }
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
                              onChanged: (newText) {
                                changed = true;
                                if (newText.isEmpty) {
                                  setState(() {
                                    state = "-";
                                    textGrade = state.toString() +
                                        "/" +
                                        assessmentsList[position]
                                            .grade
                                            .toString();
                                  });
                                  studentAssessmentsList[position].grade = "-";
                                } else {
                                  setState(() {
                                    state = double.parse(newText);
                                    textGrade = state.toString() +
                                        "/" +
                                        assessmentsList[position]
                                            .grade
                                            .toString();
                                  });
                                  studentAssessmentsList[position].grade =
                                      double.parse(newText);
                                }
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}')),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              //  initialValue: assessmentsList[position].name,

                              decoration: InputDecoration(
                                labelText: assessmentsList[position].name,
                                //hintText: "EnterF Name",
                                hintText: 'ادخل الرقم باللغة الإنجليزية',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  if (studentAssessmentsList[position].grade !=
                                      '-')
                                    state =
                                        studentAssessmentsList[position].grade;
                                  else {
                                    studentAssessmentsList[position].grade !=
                                        '-';
                                    state = '-';
                                  }
                                  textGrade = assessmentsList[position]
                                          .grade
                                          .toString() +
                                      "/" +
                                      state.toString();
                                }
                                if (!value!.isEmpty) if (double.parse(value) <
                                        0 ||
                                    double.parse(value) >
                                        double.parse(assessmentsList[position]
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
            //   } else {
            //   return Center(child: CircularProgressIndicator());
            //}
          } else if (numOfStudentsInClass == 0) {
            return Center(child: Text("لم يتم تعيين طلاب بالفصل بعد."));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  int numOfStudents = 0;

  Future<bool> conform() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("تأكيد حفظ درجات الطلاب؟"),
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

  updateDatabase() async {
    double totalGrades = 0;
    for (int i = 0; i < assessmentsList.length; i++) {
      if (studentAssessmentsList[i].grade != '-')
        totalGrades += double.parse(
            studentAssessmentsList[i].grade.toString()); // get the total grades
    }
    if (totalGrades <= 100) {
      DocumentReference subjectRef =
          await widget.subjectRef.parent.parent as DocumentReference<Object?>;
      subjectRef.get().then((DocumentSnapshot ds) async {
        widget.subjectRef.update({"uploadedUnifiedGrades": true});
        numOfStudents = ds['Students'].length;
        for (var i = 0; i < numOfStudents; i++) {
          DocumentReference docu = ds['Students'][i];
          var studentRef = await docu
              .collection("Grades")
              .where('subjectID', isEqualTo: widget.subjectRef)
              .get();
          if (studentRef.docs.length > 0) {
            // if student has a recorded grades
            await docu
                .collection("Grades")
                .where('subjectID', isEqualTo: widget.subjectRef)
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((documentSnapshot) {
                documentSnapshot.reference.update({
                  "assessments": studentAssessmentsList
                      .map<Map>((e) => e.toMap())
                      .toList(),
                });
              });
            });
          } else {
            // if student doesn't have a recorded grades then add
            docu.collection("Grades").add({
              "assessments":
                  studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
              "subjectID": widget.subjectRef,
            });
          }
        }
      });

      Fluttertoast.showToast(
          msg: "تم حفظ التعديلات بنجاح",
          backgroundColor: Color.fromARGB(255, 97, 200, 0));
    } else {
      Fluttertoast.showToast(
          msg: "لم تتم حفظ التغييرات، مجموع الدرجات أكبر من ١٠٠!",
          backgroundColor: Color.fromARGB(255, 221, 33, 30));
    }
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

  Future<bool> confirmDeleltingStudentGrades() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:
            const Text("هل تريد تأكيد عملية حفظ التعديلات لجميع طلاب الفصل؟"),
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
} //end class
