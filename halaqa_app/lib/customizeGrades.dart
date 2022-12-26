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

  checkCustomization() async {
    await widget.subjectRef.get().then((value) {
      setState(() {
        customized = value['customized'];
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

  @override
  void initState() {
    //assessmentsList.add(assessment('', 0));
    checkCustomization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton(
          heroTag: "btn1",
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            _addNewAssessment();
          },
        ),
        FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: Colors.green,
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
          onPressed: () async {
            if (assessmentsList.length != 0) {
              updateDatabase();
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => grades(
                  subRef: widget.subjectRef,
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
          /*
            print("List : ${.toString()}");
            _studentMap = _studentList.asMap();
            print("MAP : ${_studentMap.toString()}");*/

          return ListView.builder(
            itemCount: assessmentsList.length,
            itemBuilder: (context, position) {
              print('Item Position $position');
              print(assessmentsList[position].name);
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
                            keyboardType: TextInputType.number,
                            //  initialValue: assessmentsList[position].name,
                            controller: TextEditingController(
                                text: assessmentsList[position].name),

                            // maxLength: 20,
                            onChanged: (newText) {
                              assessmentsList[position].name = newText;
                              ;
                            },

                            decoration: InputDecoration(
                              labelText: "اسم المتطلب",
                              //hintText: "EnterF Name",
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
                        new Flexible(
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // maxLength: 20,
                            onChanged: (newText) {
                              assessmentsList[position].grade =
                                  int.parse(newText);
                            },
                            //initialValue:
                            //assessmentsList[position].grade.toString(),
                            controller: TextEditingController(
                                text:
                                    assessmentsList[position].grade.toString()),
                            decoration: InputDecoration(
                              labelText: "درجة المتطلب",
                              //hintText: "EnterF Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "أدخل درجة المتطلب";
                              }
                              if (int.parse(value) == 0) {
                                return "لايمكن للدرجة أن تساوي صفر";
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
                      onPressed: () {
                        setState(() {
                          assessmentsList.removeAt(position);
                          updateDatabase();

                          //numOfAssess--;

                          //  updateDatabase();
                        });
                      },
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  updateDatabase() async {
    if (_formkey.currentState!.validate()) {
      int totalGrades = 0;
      for (int i = 0; i < assessmentsList.length; i++) {
        totalGrades += assessmentsList[i].grade!;
      }
      if (totalGrades <= 100 && assessmentsList.length > 0) {
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
                  "تم حفظ التغييرات",
                  style: TextStyle(
                      // color: Colors.red,
                      ),
                ),
              );
            });
      } else if (assessmentsList.length == 0) {
        deleteOne();
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
  }

  deleteOne() async {
    print("in delete");
    await widget.subjectRef.update({
      'customized': false,
    });

    await widget.subjectRef.update({'assessments': FieldValue.delete()});

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "تم حفظ التغييرات",
              style: TextStyle(
                  // color: Colors.red,
                  ),
            ),
          );
        });
  }
}
