// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:halaqa_app/global_fun.dart';
import 'package:intl/intl.dart';


class Chatdetail extends StatefulWidget {
  final  friendUid;
  final  friendName;
  final String schoolId;
  final String classId;
  final String subjectId;
  @override
  const Chatdetail({Key? key, required this.friendUid, required this.friendName, required this.schoolId, required this.classId, required this.subjectId}) : super (key:key);

  State<Chatdetail> createState() => _ChatdetailState(friendUid, friendName);
}

class _ChatdetailState extends State<Chatdetail> {
  //Get schoolID ??
  late CollectionReference chats;
  final friendUid;
  final friendName;
  final currentuserUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocID;
  var _textController = new TextEditingController();
  var schoolID;

  _ChatdetailState(this.friendUid, this.friendName);
  @override

  int count = 1;


  void sendMessage(String msg) {
     if (msg == "")
      return;

     else{
     // print("Chat DocumentID:");
    //  print(chatDocID.id);
      chats.doc(chatDocID).collection('messages').add({
        'createdOn': FieldValue.serverTimestamp(),
        'uid':currentuserUserId,
        'msg': msg,
      }).then(((value) {
        print('sent');
        _textController.clear();
        FirebaseFirestore.instance.collection('School/${widget.schoolId}/Class').doc(widget.classId).collection("Subject").doc(widget.subjectId).update({
          "msg_count" : count++
        });
      } ));
      setState(() {

      });
     }
  }

  bool isSender(String freind){
    return freind == currentuserUserId;
  }

Alignment getAlignment (freind){
  if (freind == currentuserUserId ){
    return Alignment.topRight;
  }
  return Alignment.topLeft;
}

String? classId;

  readMsg() {
    FirebaseFirestore.instance.collection('School/${widget.schoolId}/Student').doc("${widget.friendUid}").update({
      "msg_count" : 0
    });
  }


   void initState ()  {
   super.initState();
   print("CCCCCCCCCCCHHHHHHHHHHHHHHAAAAAAAAAAAAAAATTTTTTTTTTTTTTTTTTT ${widget.schoolId}, ${widget.friendUid}, ${widget.subjectId}");
   chats = FirebaseFirestore.instance.collection('School/${widget.schoolId}/Chats');
  
     chats.where('users',isEqualTo: {currentuserUserId : null, friendUid:null})
     .limit(1)
     .get()
     .then(
      (QuerySnapshot querySnapshot){
        // print("#################### ");
        /// We have chat between these two users
        if (querySnapshot.docs.isNotEmpty){
          // print("!!!!!!!!!!! ${querySnapshot.docs.single.id}");

           // chatDocID = querySnapshot.docs.single.id;
           chatDocID = querySnapshot.docs.single.id;
           // print("CHAT DOC ID $chatDocID");
         // print("DocumentID: ${querySnapshot.docs.single.id}");
         setState(() {});
        }else{
          ///Adding a Map
          chats.add({
            'users':{ currentuserUserId : null, friendUid : null,} 
          }).then((value) {
           //in case we do not have a document created between these two user we create one
           //and wait for the call back to assaign the dicumentId to chatDocID
           chatDocID = value.id;
          });
        }
      },   
      ) .catchError((error){});
   readMsg();
     
  }///end initState



  Widget build(BuildContext context) {
   return StreamBuilder <QuerySnapshot>(
    ////get schoolID
    stream: FirebaseFirestore.instance.collection('School/${widget.schoolId}/Chats')
    .doc(chatDocID)
    .collection('messages')
    .orderBy('createdOn', descending: true)
    .snapshots(),
    builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
        if (snapshot.hasError){
          return Center(child: Text("Something went wrong"),);
        }

        if(snapshot.hasData){
         var  data ;
         //= document.data()!; 
        //initState () ;
       // super.initState();
         // print("snapshot hasData");
      return CupertinoPageScaffold( 
        navigationBar: CupertinoNavigationBar(previousPageTitle: "رجوع",
        ///add parent Name or TeacherOH
        middle: Text(friendName,
        style: TextStyle(
                  color: Color.fromARGB(255, 99, 99, 99),
                  fontSize: 23,
                 //fontWeight: FontWeight.bold
                 ),),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: (){}, 
          child: Text("")
        ),
        ) ,
        child: SafeArea(
          child: Column(children: [
            Expanded(
              child: Container(            
                child: ListView(
                reverse: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                   data = document.data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ChatBubble(
                      clipper: ChatBubbleClipper5(
                       // nipSize: 0,
                        radius:0,
                        type:BubbleType.sendBubble,
                        ),
                        alignment: getAlignment(data['uid'].toString()),
                        margin: EdgeInsets.only(top:20),
                        backGroundColor: isSender(data['uid'].toString()) 
                        ? Color.fromARGB(255, 184, 215, 249)
                        : Color.fromARGB(237, 205, 203, 203),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width *0.5,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: 
                                MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(data['msg'],
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: isSender(
                                        data['uid'].toString())
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color.fromARGB(255, 255, 255, 255)),
                                 overflow: TextOverflow.clip
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data['createdOn']== null
                                    ? DateTime.now().toString()
                                    :"${GlobalFun.realDate(data['createdOn'].toDate().toString().substring(0,10))} ${GlobalFun.realTime(data['createdOn'])}",
                                   style: TextStyle(
                                    decoration: TextDecoration.none,
                                  fontSize: 10,
                                //  fontWeight:  ,
                                  color: isSender(data['uid'].toString())
                                  ?Color.fromARGB(255, 132, 131, 131)
                                  :Color.fromARGB(255, 132, 131, 131)
                                  ))
                                ],
                              )
                            ]
                          )
                        )
                    ),
                  );
                }).toList(),
            ),
              )),
            Container(
               decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 240, 240),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  child: CupertinoTextField(
                  minLines: 2,
                  maxLines: 20,
                  controller: _textController                  
                    )),
                CupertinoButton(
          onPressed: () => sendMessage(_textController.text), 
          child: Icon(Icons.send_sharp),
        ),
              ],),
            )
            
          ],)
          ),
      );
        }
        return Container();
      });
   
  }
  
}