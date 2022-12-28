import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  int? grade;

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
            setState(() {});
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
          print(gradeID);

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

            if (y == 0) {
              setState(() {
                assessmentsList.removeAt(0);
                studentAssessmentsList.removeAt(0);
                y++;
              });
            }
          }
        } else {
          if (y == 0) {
            setState(() {
              assessmentsList.removeAt(0);
              studentAssessmentsList.removeAt(0);
              y++;
            });
          }

          setState(() {
            studentAssessmentsList.add(assessment(assessmentsList[0].name, 0));
            studentAssessmentsList.add(assessment(assessmentsList[1].name, 0));
            studentAssessmentsList.add(assessment(assessmentsList[2].name, 0));
            studentAssessmentsList.add(assessment(assessmentsList[3].name, 0));
            studentAssessmentsList.add(assessment(assessmentsList[4].name, 0));
            studentAssessmentsList.add(assessment(assessmentsList[5].name, 0));
          });

          widget.stRef.collection("Grades").add({
            "assessments":
                studentAssessmentsList.map<Map>((e) => e.toMap()).toList(),
            "subjectID": widget.classRef,
          });
        }
      } //end if customized = true
      else {
        notCustomized();

        studentAssessmentsList.add(assessment(assessmentsList[0].name, 0));
        studentAssessmentsList.add(assessment(assessmentsList[1].name, 0));
        studentAssessmentsList.add(assessment(assessmentsList[2].name, 0));
        studentAssessmentsList.add(assessment(assessmentsList[3].name, 0));
        studentAssessmentsList.add(assessment(assessmentsList[4].name, 0));
        studentAssessmentsList.add(assessment(assessmentsList[5].name, 0));

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
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: () async {
              var f = false;
              if (_formkey.currentState!.validate()) {
                f = await conform();
              }
              if (f) {
                updateDatabase();
              }
            },
          ),
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => viewStudentsForGrades(
                  ref: widget.classRef,
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
          print("studentAssessmentsList.lenght " +
              studentAssessmentsList.length.toString());
          print("assessmentsList.lenght " + assessmentsList.length.toString());
          if (x == 0) {
            getData();
          }
          if (studentAssessmentsList.length == numOfAssess) {
            //  if (assessmentStudentGradesList.length == assessmentsList.length) {
            return ListView.builder(
              itemCount: assessmentsList.length,
              itemBuilder: (context, position) {
                return Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: [
                          new Flexible(
                            child: TextFormField(
                              onChanged: (newText) {
                                studentAssessmentsList[position].grade =
                                    int.parse(newText);
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              //  initialValue: assessmentsList[position].name,
                              controller: TextEditingController(
                                  text: studentAssessmentsList[position]
                                      .grade
                                      .toString()),

                              decoration: InputDecoration(
                                labelText: assessmentsList[position].name,
                                //hintText: "EnterF Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "ادخل درجة المتطلب";
                                }
                                if (int.parse(value) < 0 ||
                                    int.parse(value) >
                                        int.parse(assessmentsList[position]
                                            .grade
                                            .toString())) {
                                  return "يجب ان تكون حدود الدرجة من ٠ الى " +
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
                    ],
                  ),
                );
              },
            );
            //   } else {
            //   return Center(child: CircularProgressIndicator());
            //}
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  Future<bool> conform() async {
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

  updateDatabase() async {
    int totalGrades = 0;
    for (int i = 0; i < assessmentsList.length; i++) {
      totalGrades += int.parse(studentAssessmentsList[i].grade.toString());
    }
    if (totalGrades < 100) {
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
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "تم حفظ التعديلات بنجاح",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "لم تتم حفظ التغييرات، مجموع الدرجات أكبر من ١٠٠!",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            );
          });
    }
  }
} //end class
