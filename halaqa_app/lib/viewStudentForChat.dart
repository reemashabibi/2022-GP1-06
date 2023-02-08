import 'dart:developer';

import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/grades.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:halaqa_app/studentgrades.dart';
import 'package:flutter/material.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/TeacherEdit.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'chat_detail.dart';

class viewStudentsForChat extends StatefulWidget {
  const viewStudentsForChat({super.key, required this.ref, required this.schoolId, required this.subjectId});
  final DocumentReference ref;
  final String schoolId;
  final String subjectId;


  @override
  State<viewStudentsForChat> createState() => _viewStudentsForChatState();
}

class _viewStudentsForChatState extends State<viewStudentsForChat> {
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

  String? classId;

  getStudents() async {
    print("AA ${widget.ref.parent.parent!.path}");
    DocumentReference docRef = widget.ref.parent.parent as DocumentReference<Object?>;
         print("docref: ${widget.ref.parent.id}");
         ///classID
        print(docRef.id);
        classId = docRef.id;
        print(docRef);

    docRef.get().then((DocumentSnapshot ds) async {
      // use ds as a snapshot
      className = ds['ClassName'];
      levelName = ds['LevelName'];

      numOfStudents = ds['Students'].length;
      print("numOfStudents $numOfStudents");
      for (var i = 0; i < numOfStudents; i++) {
        DocumentReference docu = ds['Students'][i];
        var stName = await docu.get().then((value) {
          // print("DDDDDDDDDDD ${value.id}");
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

    ///show count of msg from inside teacher collection and inside of this subcollection subjects
    FirebaseFirestore.instance.collection('School/${widget.schoolId}/Teacher')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection("subjects")
        .doc(widget.subjectId).get().then((value) {
      setState(() {
        msgCount = value.get("msg_count");
        studentId = value.get("student_id");
      });
    });

  }


  TextEditingController controller = TextEditingController();

  TextField customTextFiled() {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8)
    );
    return TextField(
      controller: controller,
      maxLines: 10,
       minLines: 1,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        isDense: true,
        hintText: "أدخل النص"
      ),
    );
  }

  void callChatDetailScreen(BuildContext context ,String name,  uid,String classID,String subjectId){
    print("In function Student Name: $name");
    print(uid);
    print(classID);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Chatdetail(
              friendName: name,
              friendUid: uid,
              schoolId: widget.schoolId,
              classId: classID,
              subjectId: subjectId,
              ///after read msg update a variable
              msgCount: (s) {
                msgCount = s;
                // setState(() {
                //
                // });
              },
            )));
    setState(() {

    });

  }

  int count = 0;


  sendMsgAll() {
    return showDialog(context: context, builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        // height: 242,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.clear,color: Colors.black,))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: customTextFiled(),
              ),
              // const Spacer(),
              ElevatedButton(onPressed: () async{
                String classId = FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class/').doc(widget.ref.parent.parent!.id).id;
                // print("TEXT ${widget.ref}");
                QuerySnapshot qr = await FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student').where("ClassID",isEqualTo: FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class/').doc(widget.ref.parent.parent!.id)).get();



                if(controller.text.isNotEmpty) {
                  Navigator.pop(context);
                  FirebaseFirestore.instance.collection('School/${widget.schoolId}/Chats').get().then((value) async {
                    // for(var doc in value.docs) {
                      for (int i=0;i<qr.docs.length;i++) {
                        // print("SUBJECT ID ${widget.subjectId}_${qr.docs[i].id}_${FirebaseAuth.instance.currentUser?.uid}");
                        // print("## ${qr.docs[i].id}");
                        FirebaseFirestore.instance.collection('School/${widget.schoolId}/Chats').doc("${widget.subjectId}_${qr.docs[i].id}_${FirebaseAuth.instance.currentUser?.uid}").collection("messages").add({
                          'createdOn': FieldValue.serverTimestamp(),
                          'uid':FirebaseAuth.instance.currentUser?.uid,
                          'msg': "📢"+"\n"+"\n"+controller.text,
                        });
                      }

                      DocumentSnapshot dc = await FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class').doc(classId).collection("Subject").doc(widget.subjectId).get();
                      count = dc.get("msg_count") + 1;
                      print("COUNT MSG $count");
                      FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class').doc(classId).collection("Subject").doc(widget.subjectId).update({
                        "msg_count" : count
                      });
                      // FirebaseFirestore.instance.collection("sc")
                    // }

                  });

                }

                setState(() {

                });



              }, child: const Text("إرسال"))
            ],
          ),
        ),
      ),
    ));
  }

  Stream<QuerySnapshot<Object?>>? stream;
  int msgCount = 0;
  String? studentId;

  @override
  void initState() {
    print("<<<<<<<<<<object>>>>>>>>>> ${widget.subjectId} ${widget.schoolId}");
    getStudents();
    super.initState();
  }

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    // print("_+_++_+ ${FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class/').doc(widget.ref.parent.parent!.id)}");
    // DocumentReference ref = widget.ref;
    // DocumentReference str = ref.parent.parent as DocumentReference<Object?>;

    
      return StreamBuilder<DocumentSnapshot>(
          stream: widget.ref.parent.parent?.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
            if (snap.hasError) {
              return Center(
                  child: Text('Some error occurred ${snap.error}'));
            }

            //Check if data arrived
            if (x == 0) {
              getData();
            }

            if (snap.hasData && _StudenNameList[0] != "") {
              //Display the list
              //  print("in");
        return StreamBuilder <QuerySnapshot>(
          ///get schoolID
      stream : FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student').where("ClassID",isEqualTo: FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class/').doc(widget.ref.parent.parent!.id)).snapshots(),
      builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){

        if (snapshot.hasError){
          return const Center(child: Text("Something went wrong"),);
        }
       // if(snapshot.connectionState == ConnectionState.waiting ){
       //   return Center (child: Text("Loading"),);
      //  }
        if(snapshot.hasData){
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            controller.clear();
            sendMsgAll();
          },
          child: const Text("إرسال للكل",textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 68, 68, 68),
          ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                ///bad design
                largeTitle: Text( "${"أولياء أمور "+className} - $levelName",
                style: const TextStyle(
                    color: Color.fromARGB(255, 68, 68, 68),
                    fontSize: 25,
                   //fontWeight: FontWeight.bold
                   ),),
                ),

                SliverList(
                  delegate: SliverChildListDelegate (
                      snapshot.data!.docs.map((e) {
                       // print("+++999 9+9 ${e.id}");
                // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;


                 return CupertinoListTile(
                  onTap: () {
                    callChatDetailScreen(context ,e['FirstName'] + " " + e['LastName'], e.id,e["ClassID"].id,widget.subjectId);
                    },
                  title: Row(
                    children: [
                      if(e.id == studentId)
                      msgCount == 0 ? Container() : Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Text(msgCount.toString(),style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Text(e['FirstName'] + " " + e['LastName'],
                       style: const TextStyle(
                        color: Color.fromARGB(255, 1, 135, 173),
                        fontSize: 25,
                       ),
                      ),
                    ],
                  ),
                 );

               }).toList()
               )

               )
            ],
           ),
        ),
      );
        }
        return Container();
      });

            }
            // if (_StudenNameList.length == 0 && x == 0) {
            //   return const Center(child: Text("لم يتم تعيين أي فصل بعد."));
            // }
            // if (_StudenNameList[0] == "" && v == 1) {
            //   return const Center(child: Text("لم يتم تعيين أي طالب بالفصل بعد."));
            // }
            return const Center(child: CircularProgressIndicator());
          });
    
  }
}
