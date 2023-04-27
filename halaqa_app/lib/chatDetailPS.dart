// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:halaqa_app/global_fun.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

////need techerID, teacherName,  it's childID
class ChatdetailPS extends StatefulWidget {
  final TeacherUid;
  final TeacherName;
  final StudentUid;
  final schoolId;
  final subjectId;
  final classID;
  @override
  const ChatdetailPS(
      {Key? key,
      required this.TeacherUid,
      required this.TeacherName,
      required this.StudentUid,
      this.schoolId,
      this.subjectId,
      this.classID})
      : super(key: key);

  State<ChatdetailPS> createState() =>
      _ChatdetailPSState(TeacherUid, TeacherName, StudentUid);
}

class _ChatdetailPSState extends State<ChatdetailPS> {
  late CollectionReference chats;
  final TeacherUid;
  final TeacherName;
  final StudentUid;
  get currentuserUserId => StudentUid;
  var chatDocID;
  var _textController = new TextEditingController();
  var schoolID;

  _ChatdetailPSState(this.TeacherUid, this.TeacherName, this.StudentUid);
  @override
  int count = 0;

  void sendMessage(String msg) {
    if (msg == "")
      return;
    else {
      // print("Chat DocumentID:");
      print(chatDocID);
      chats.doc(chatDocID).collection('messages').add({
        'createdOn': FieldValue.serverTimestamp(),
        'uid': currentuserUserId,
        'msg': msg,
      }).then(((value) async {
        print('sent');
        _textController.text = "";

        //New ***************************************************** if new it does not add feilds
        DocumentSnapshot dc = await FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Chats')
            .doc(chatDocID)
            .get();
        print('hhhhhhhhhhhhhhhhhhhhhhhhhffffff');
        try {
          count = dc.get("To_Teacher_msg_count") + 1;
        } catch (e) {}
        print("COUNT MSG $count");
        await FirebaseFirestore.instance //code change
            .collection('School/${widget.schoolId}/Chats')
            .doc(chatDocID)
            .set({
          "To_Teacher_msg_count": count,
          'SubjectID': widget.subjectId,
          'StudentID': currentuserUserId
        }, SetOptions(merge: true));

/*
        ///while we send a message from parent side we need to set subcollection because we have 3 student and we send msg to partucular
        DocumentSnapshot dc = await FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Teacher')
            .doc(widget.TeacherUid)
            .collection("subjects")
            .doc(widget.subjectId)
            .get();
        count = dc.get("msg_count") + 1;
        FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Teacher')
            .doc(widget.TeacherUid)
            .collection("subjects")
            .doc(widget.subjectId)
            .set({"msg_count": count, "student_id": widget.StudentUid});
            */

        /*  int hasChatOpen = 0;
        var chatDoc = FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Teacher')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("subjects")
            .doc(widget.subjectId)
            .get()
            .then((value) => hasChatOpen = value.get('msg_count'));*/

        //   if (hasChatOpen != 0) {
        //send notification

        var senderName = '';
        var recepientToken = '';

        var studentName = '';
        //get the sender student name
        FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Student')
            .doc(widget.StudentUid)
            .get()
            .then(
          (DocumentSnapshot doc) {
            senderName += " (${doc['FirstName']} ${doc['LastName']}) ولي أمر";
            // ...
          },
          onError: (e) => print("Error getting document: $e"),
        );

        //get the recepient token
        FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Teacher')
            .doc(TeacherUid)
            .get()
            .then(
          (DocumentSnapshot doc) {
            if (doc['token'] != null) {
              //code change
              recepientToken = doc['token'];
              http.post(
                Uri.parse(
                    'https://us-central1-halaqa-89b43.cloudfunctions.net/method/chat'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'name': senderName,
                  'content': msg,
                  'token': recepientToken,
                  'data':
                      '$StudentUid~$studentName~$schoolID~${widget.classID}~${widget.subjectId}'
                }),
              );
              // ...
            }
          },
          onError: (e) => recepientToken = '',
        );

        //end notification
        // }
      }));
      setState(() {});
    }
  }

  Future<void> getSchoolID() async {
    print("!!!! ${widget.schoolId}");
    chats = FirebaseFirestore.instance
        .collection('School/${widget.schoolId}/Chats');
    User? user = FirebaseAuth.instance.currentUser;
    var col = FirebaseFirestore.instance
        .collectionGroup('Parent')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }
    setState(() {});
  }

  bool isSender(String freind) {
    return freind == currentuserUserId;
  }

  Alignment getAlignment(freind) {
    if (freind == currentuserUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  readMsg() {
    FirebaseFirestore.instance
        .collection('School/${widget.schoolId}/Chats')
        .doc(chatDocID)
        .update({"To_Student_msg_count": 0});
  }

  getOfficeHours() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('School/${widget.schoolId}/Teacher')
        .doc("${widget.TeacherUid}")
        .get();
  }

  void initState() {
    super.initState();
    getSchoolID();
    print("{{{{{{{{{{{{object}}}}}}}}}}}} ${widget.TeacherUid}");
    chats = FirebaseFirestore.instance
        .collection('School/${widget.schoolId}/Chats');

    // chats.where('users',isEqualTo: {currentuserUserId : null, TeacherUid:null})
    //   .limit(1)
    //   .get()
    //   .then(
    //    (QuerySnapshot querySnapshot){
    //      /// We have chat between these two users
    //      if (querySnapshot.docs.isNotEmpty){
    //         chatDocID = querySnapshot.docs.single.id;
    //       print("DocumentID: ${querySnapshot.docs.single.id}");
    //       setState(() {
    //
    //       });
    //      }else{
    //        ///Adding a Map
    //        chats.add({
    //          'users':{ currentuserUserId : null, TeacherUid : null,}
    //        }).then((value) {
    //          print("&&&&& $value");
    //         //in case we do not have a document created between these two user we create one
    //         //and wait for the call back to assaign the dicumentId to chatDocID
    //         setState(() {
    //           //subjectid/senderid/receiverid
    //           // chatDocID = value.id;
    //           chatDocID = "${widget.subjectId}_${currentuserUserId}_${widget.TeacherUid}";
    //         });
    //        });
    //      }
    //    },
    //    );
    chatDocID = "${widget.subjectId}_${currentuserUserId}_${widget.TeacherUid}";
    readMsg();
  }

  ///end initState

  showDataCalender() {
    return showDialog(
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('School/${widget.schoolId}/Teacher')
                    .doc("${widget.TeacherUid}")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("جار التحميل...");
                  }

                  return Container(
                    // height: 150,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                          Text(
                            " الساعات المكتبية",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data!.get("OfficeHours"),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        ////get schoolID
        stream: FirebaseFirestore.instance
            .collection('School/${widget.schoolId}/Chats')
            .doc(chatDocID)
            .collection('messages')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.hasData) {
            readMsg();
            //= document.data()!;
            //initState () ;
            // super.initState();
            // print("snapshot hasData");
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                previousPageTitle: "رجوع",

                ///add parent Name or TeacherOH
                middle: Text(
                  TeacherName,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 99, 99, 99),
                    fontSize: 23,
                    //fontWeight: FontWeight.bold
                  ),
                ),
                trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDataCalender();
                    },
                    child: const Icon(
                      Icons.calendar_month,
                      color: Color.fromARGB(255, 11, 129, 239),
                      size: 20,
                    )),
              ),
              child: SafeArea(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    reverse: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      var data = document;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ChatBubble(
                            clipper: ChatBubbleClipper5(
                              // nipSize: 0,
                              radius: 0,
                              type: BubbleType.sendBubble,
                            ),
                            alignment: getAlignment(data['uid'].toString()),
                            margin: const EdgeInsets.only(top: 20),
                            backGroundColor: isSender(data['uid'].toString())
                                ? const Color.fromARGB(255, 184, 215, 249)
                                : const Color.fromARGB(237, 205, 203, 203),
                            child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(data['msg'],
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            overflow: TextOverflow.clip),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : "${GlobalFun.realDate(data['createdOn'].toDate().toString().substring(0, 10))} ${GlobalFun.realTime(data['createdOn'])}",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 10,
                                              //  fontWeight:  ,
                                              color: isSender(
                                                      data['uid'].toString())
                                                  ? const Color.fromARGB(
                                                      255, 132, 131, 131)
                                                  : const Color.fromARGB(
                                                      255, 132, 131, 131)))
                                    ],
                                  )
                                ]))),
                      );
                    }).toList(),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 241, 241),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: CupertinoTextField(
                                minLines: 2,
                                maxLines: 20,
                                controller: _textController)),
                        CupertinoButton(
                          onPressed: () => sendMessage(_textController.text),
                          child: const Icon(Icons.send_sharp),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            );
          }
          return Container();
        });
  }
}
