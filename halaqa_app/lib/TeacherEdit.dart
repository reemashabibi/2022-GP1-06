import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
//// Retreive
  Future<void> xx() async {
    User? user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance
        .collection('School/' + schoolID + '/Teacher');
    collection.doc(user!.uid).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        // You can then retrieve the value from the Map like this:
        FirstName = data['FirstName'];
        LastName = data['LastName'];
        Email = data['Email'];
      }
    });
  }

  String schoolID = "xx";
  bool _isObscure3 = true;
  bool visible = false;
  bool EmailUpdated = false;
  bool PassUpdated = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController FNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  TextEditingController officeHoursController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showPassword = false;
  String? FirstName;
  String? LastName;
  String? Email;
  String? OH;
  String Pass = "********";
  String NewFname = "";

  ///come backkkkkkkkkkkkkkkkkkkkkkkkkkkkk
  String NewLname = "";
  String NewEmail = "";
  String NewPass = "";
  String NewOH = "";

  ///check if any data has changed or not.
  checkChanges() {
    return ((FirstName != FNameController.text &&
            FNameController.text.isNotEmpty) ||
        (LastName != lNameController.text && lNameController.text.isNotEmpty) ||
        (Email != emailController.text && emailController.text.isNotEmpty) ||
        (Pass != passwordController.text &&
            passwordController.text.isNotEmpty) ||
        (OH != officeHoursController.text));
  } //end checkChanges

  void initState() {
    // GetNameandPic();
    /*futureMethod = */ getData();
    //getSchoolID();
    super.initState();
    // controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                builder: (context) => teacherHP(),
              ),
            );
          },
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(
                  colors: [
                    (Color.fromARGB(255, 208, 247, 247)),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, left: 20),
                    alignment: Alignment.bottomLeft,
                    //      child: Text(
                    // "Edit profile",
                    //     style: TextStyle(
                    //   fontSize: 20,
                    //    color: Color.fromARGB(255, 49, 49, 49)
                    //    ),
                    // ),
                  )
                ],
              )),
            ),
            Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "معلومات الحساب ", //  text ??
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 80, 80, 80),
                            fontSize: 30,
                          ),
                        ),

//////////////////////// Inputs /////////////////////////
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLength: 20,
                          onChanged: (newText) {
                            NewFname = newText;
                          },
                          controller: FNameController,
                          decoration: InputDecoration(
                            labelText: "الاسم الأول",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "الاسم الأول مطلوب";
                            }
                            if (value.length > 20) {
                              return "الاسم يجب أن لا يزيد عن 20 حرف";
                            }
                            if (value.length <= 2) {
                              return "الاسم يجب أن لا يقل عن 2 حرف";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLength: 20,
                          onChanged: (newText) {
                            NewLname = newText;
                          },
                          controller: lNameController,
                          decoration: InputDecoration(
                            labelText: "الاسم الأخير",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "الاسم الأخير مطلوب";
                            }
                            if (value.length > 20) {
                              return "الاسم يجب أن لا يزيد عن 20 حرف";
                            }
                            if (value.length <= 2) {
                              return "الاسم يجب أن لا يقل عن 2 حرف";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // maxLength: 20,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          onChanged: (newText) {
                            NewOH = newText;
                          },
                          controller: officeHoursController,
                          decoration: InputDecoration(
                            hintText: "الإثنين - 11:00صباحًا - 1:00مساءً",
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "الساعات المكتبية",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          // maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        new Container(
                            child: new Column(
                          children: <Widget>[
                            new Align(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                " *سيؤدي إعادة تعيين البريد الإلكتروني إلى تسجيل خروجك ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )),

                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          // maxLength: 20,
                          onChanged: (newText) {
                            NewEmail = newText;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "البريد الإلكتروني",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "يرجى إدخال بريد إلكتروني";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("الرجاء إدحال بريد إلكتروني صحيح");
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        new Container(
                            child: new Column(
                          children: <Widget>[
                            new Align(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                " *سيؤدي إعادة تعيين كلمة المرور إلى تسجيل خروجك ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          maxLength: 20,
                          onChanged: (newText) {
                            NewPass = newText;
                          },
                          controller: PassController,
                          obscureText: _isObscure3,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
                            filled: true,
                            labelText: "كلمة المرور",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "يرجى إدخال كلمة المرور";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام");
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visible = true;
                            });
                            //signIn(emailController.text, passwordController.text);
                            // showAlertDialog(context);
                            method(
                                emailController.text,
                                passwordController.text,
                                FNameController.text,
                                lNameController.text,
                                officeHoursController.text);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    (Color.fromARGB(255, 170, 243, 250)),
                                    Color.fromARGB(255, 195, 196, 196)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "حفظ ",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                //  child: CircularProgressIndicator(
                                //  color: Color.fromARGB(255, 160, 241, 250),
                                //  )
                                )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> GetInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    var col = await FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      print(doc.reference.parent.parent?.id);
      schoolID = doc.reference.parent.parent!.id;
      print("schoolID=" + '$schoolID');
    }
    Get();
  }

  Future<void> Get() async {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = await FirebaseFirestore.instance
        .collection('School/' + '$schoolID' + '/Teacher')
        .doc(user?.uid)
        .get()
        .then((value) {
      FirstName = value.data()!['FirstName'];
      FNameController.text = value.data()!['FirstName'];
      LastName = value.data()!['LastName'];
      lNameController.text = value.data()!['LastName'];
      OH = value.data()!['OfficeHours'];
      officeHoursController.text = value.data()!['OfficeHours'];
      Email = value.data()!['Email'];
      emailController.text = value.data()!['Email'];
      PassController.text = "********";
    });
    setState(() {});
  }

  Future getData() async {
    await GetInfo();
  }

  Future<void> getSchoolID() async {
    User? user = FirebaseAuth.instance.currentUser;
    var col = FirebaseFirestore.instance
        .collectionGroup('Teacher')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      break;
    }
  }

  Future<void> method(
      String email, String pass, String fNm, String lN, String OH) async {
    if (_formkey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (email != FirebaseAuth.instance.currentUser?.email) {
        print("email updated");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("email", email);
        /////chenged
        //await user?.updateEmail(email);
        var Uid = FirebaseAuth.instance.currentUser?.uid;
        print(Uid);
        updateUser(Uid!, email);
        EmailUpdated = true;
      }
      if (NewPass != "") {
        /////changed
        //  await user?.updatePassword(NewPass);
        var Uid = FirebaseAuth.instance.currentUser?.uid;
        print(Uid);
        updateUserPass(Uid!, email, NewPass);
        PassUpdated = true;
        print("pass updated");
      }

      getSchoolID();
      var col = FirebaseFirestore.instance
          .collectionGroup('Teacher')
          .where('Email', isEqualTo: email);
      print("in3");
      var snapshot = await col.get();
      print("in4");
      for (var doc in snapshot.docs) {
        schoolID = doc.reference.parent.parent!.id;
        break; // Prints document1, document2
      }

      await FirebaseFirestore.instance
          .collection('School/' + '$schoolID' + '/Teacher')
          .doc(user!.uid)
          .update({
        'Email': email,
        'FirstName': fNm,
        'LastName': lN,
        'OfficeHours': OH,
      });

      Fluttertoast.showToast(
          msg: "تم حفظ التعديلات بنجاح",
          backgroundColor: Color.fromARGB(255, 97, 200, 0));

      Future.delayed(Duration(seconds: 3), () async {
        // print("Executed after 5 seconds");
        if (EmailUpdated || PassUpdated) {
          CircularProgressIndicator();
          await FirebaseAuth.instance.signOut();
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove("email");
          pref.remove('type');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else
          return;
      });
    }
  }

  Future<http.Response> updateUser(String uid, String email) async {
    //Andorid??
    return http.post(
        Uri.parse(
            "https://us-central1-halaqa-89b43.cloudfunctions.net/method/updateUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'uid': uid, 'email': email.toLowerCase()}));
  }

  Future<http.Response> updateUserPass(
      String uid, String email, String pass) async {
    //Andorid??
    return http.post(
        Uri.parse(
            "https://us-central1-halaqa-89b43.cloudfunctions.net/method/updateUserPass"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'email': email.toLowerCase(),
          'pass': pass
        }));
  }
} //end class
