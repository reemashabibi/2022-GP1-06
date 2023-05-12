import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/commissioner/add_commissioner.dart';
import 'package:http/http.dart' as http;

class CommissionerList extends StatefulWidget {
  final schoolID;
  const CommissionerList({Key? key, required this.schoolID}) : super(key: key);

  @override
  State<CommissionerList> createState() => _CommissionerListState();
}

class _CommissionerListState extends State<CommissionerList> {
  var schoolID = "xx";

  @override
  void initState() {
    // getSchoolId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          backgroundColor: Color.fromARGB(255, 76, 170, 175),
          label: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text('إضافة')
            ],
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddCommissioner(schoolId: widget.schoolID),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('School/${widget.schoolID}/Commissioner/')
              .where("ParentId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text(" لا يوجد مفوّض بعد"),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, i) {
                      var data = snapshot.data!.docs[i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 239, 240, 240),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 3),
                                    blurRadius: 8,
                                    color: Colors.grey.withOpacity(0.2))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "الاسم : ${data.get("FirstName")} ${data.get("LastName")}",
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          //  Text("Email : ${data.get("Email")}"),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCommissioner(
                                                    schoolId: widget.schoolID,
                                                    isUpdate: true,
                                                    snapshot: data,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                              size: 18,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.clear,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  )),
                                                            ],
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8.0),
                                                            child: Text(
                                                              "هل أنت متأكد من حذف هذا المفوّض؟",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                //  fontWeight: FontWeight.w600
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "إلغاء",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            //  fontWeight: FontWeight.w600
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    List list =
                                                                        data.get(
                                                                            "Students");
                                                                    for (var element
                                                                        in list) {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "School/${widget.schoolID}/Student/")
                                                                          .doc(element
                                                                              .id
                                                                              .toString())
                                                                          .update({
                                                                        "CommissionerId":
                                                                            FieldValue.arrayRemove([
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('School/${widget.schoolID}/Commissioner/')
                                                                              .doc(data.id)
                                                                        ])
                                                                      });
                                                                    }
                                                                    print(data
                                                                        .id);
                                                                    deletUser(
                                                                        data.id);
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "School/${widget.schoolID}/Commissioner/")
                                                                        .doc(data
                                                                            .id)
                                                                        .delete();
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "تم حذف المفوّض بنجاح",
                                                                        backgroundColor:
                                                                            Colors.green);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "حذف",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Color.fromARGB(255, 255, 0, 0),
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 18,
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
          },
        ));
  }

  Future<http.Response> deletUser(String uid) {
    return http.post(
      ///Android??
      Uri.parse(
          "https://us-central1-halaqa-89b43.cloudfunctions.net/method/deleteUser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
      }),
    );
    print("done deleting");
  }

  Future<void> getSchoolId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var col = FirebaseFirestore.instance
        .collectionGroup('Parent')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }
  }
}
