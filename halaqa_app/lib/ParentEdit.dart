import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/login_screen.dart';
import 'package:halaqa_app/parentHP.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String schoolId;
  const EditProfilePage({Key? key, required this.schoolId}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
//// Retreive
  Future<void> xx() async {
    User? user = FirebaseAuth.instance.currentUser;
    var collection =
        FirebaseFirestore.instance.collection('School/$schoolID/Parent');
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
  bool EmailUpdated = false;
  bool PassUpdated = false;
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController FNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  //// not text
  final _auth = FirebaseAuth.instance;
  bool showPassword = false;
  String? FirstName;
  String? LastName;
  String? Email;
  var Phone;
  var temp;
  String Pass = "********";
  String NewFname = "";

  ///come backkkkkkkkkkkkkkkkkkkkkkkkkkkkk
  String NewLname = "";
  String NewEmail = "";
  String NewPass = "";
  var NewPhone = "";

  ///check if any data has changed or not.
  checkChanges() {
    return ((FirstName != FNameController.text &&
            FNameController.text.isNotEmpty) ||
        (LastName != lNameController.text && lNameController.text.isNotEmpty) ||
        (Email != emailController.text && emailController.text.isNotEmpty) ||
        (Pass != passwordController.text &&
            passwordController.text.isNotEmpty) ||
        (Phone != PhoneController.text && PhoneController.text.isNotEmpty));
  } //end checkChanges

  void initState() {
    print("EDIT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    // GetNameandPic();
    /*futureMethod = */ getData();
    // PhoneController.value = temp ;
    //getSchoolID();
    super.initState();
    // controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 54, 172, 172),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => appBars(
                  schoolId: schoolID,
                  Index: 0,
                ),
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
                          // maxLength: 10,
                          onChanged: (newValue) {
                            NewPhone = newValue;
                          },
                          controller: PhoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: " رقم الجوال",
                            //hintText: "EnterF Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "  رقم الجوال مطلوب";
                            }
                            if (value.toString().length == 9) {
                              value = "0" + value;
                              print(value);
                            }
                            if (value.length > 10) {
                              return "   رقم الجوال يجب أن لا يزيد عن 10 أرقام";
                            }
                            if (value.length < 10) {
                              return "   رقم الجوال يجب أن لا يقل عن 10 أرقام";
                              ;
                            } else {
                              return null;
                            }
                          },
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
                          height: 20,
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
                              int.parse(PhoneController.text),
                            );
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
    print("USER ${user!.uid}");
    var col = await FirebaseFirestore.instance
        .collectionGroup('Parent')
        .where('Email', isEqualTo: user!.email);
    var snapshot = await col.get();
    for (var doc in snapshot.docs) {
      schoolID = doc.reference.parent.parent!.id;
      print("schoolID=" + '$schoolID');
      // break;// Prints document1, document2
    }
    Get();
  }

  Future<void> Get() async {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = await FirebaseFirestore.instance
        .collection('School/$schoolID/Parent')
        .doc(user?.uid)
        .get()
        .then((value) {
      FirstName = value.data()!['FirstName'];
      FNameController.text = value.data()!['FirstName'];
      LastName = value.data()!['LastName'];
      lNameController.text = value.data()!['LastName'];
      Email = value.data()!['Email'];
      emailController.text = value.data()!['Email'];
      Phone = value.data()!['Phonenumber'];
      temp = value.data()!['Phonenumber'];
      //  PhoneController.value = (""+ temp) as TextEditingValue ;
      //  PhoneController = Phone;
      //print (temp);

      PhoneController.text = temp.toString();
      PassController.text = "********";
    });
    setState(() {});
  }

  Future getData() async {
    await GetInfo();
  }

  // Future<void> getSchoolID() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   var col = FirebaseFirestore.instance
  //       .collectionGroup('Parent')
  //       .where('Email', isEqualTo: user!.email);
  //   var snapshot = await col.get();
  //   for (var doc in snapshot.docs) {
  //     schoolID = doc.reference.parent.parent!.id;
  //     break;
  //   }
  // }

  Future<void> method(
      String email, String pass, String fNm, String lN, int Ph) async {
    print("DATA $email, $fNm, $lN, $Ph");
    //  int Cp = Ph as int;
    if (_formkey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (email != FirebaseAuth.instance.currentUser?.email) {
        print("email updated");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("email", email);
        ////change
        ///
        // await user?.updateEmail(email);
        var Uid = FirebaseAuth.instance.currentUser?.uid;
        print(Uid);
        updateUser(Uid!, email);
        EmailUpdated = true;
      }
      if (NewPass != "") {
        ////change
        //   await user?.updatePassword(NewPass);
        var Uid = FirebaseAuth.instance.currentUser?.uid;
        print(Uid);
        print(email);
        print(NewPass);
        updateUserPass(Uid!, email, NewPass);
        PassUpdated = true;
        // print("pass updated");
      }

      var col = FirebaseFirestore.instance
          .collectionGroup('Parent')
          .where('Email', isEqualTo: email);
      var snapshot = await col.get();

      for (var doc in snapshot.docs) {
        schoolID = doc.reference.parent.parent!.id;
        break; // Prints document1, document2
      }
      await FirebaseFirestore.instance
          .collection('School/$schoolID/Parent')
          .doc(user!.uid)
          .update({
        'Email': email,
        'FirstName': fNm,
        'LastName': lN,
        'Phonenumber': Ph
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
