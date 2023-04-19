import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halaqa_app/appBars.dart';
import 'package:halaqa_app/commissioner.dart';
import 'package:halaqa_app/forgot_pw_screen.dart';
import 'package:halaqa_app/teacherHP.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<LoginScreen> {
  bool _isObscure3 = true;
  bool visible = false;
  bool isT = false;
  String email = "";
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final _auth = FirebaseAuth.instance;

  var options = [
    'معلم',
    'ولي أمر',
    'مفوّض',
  ];
  var _currentItemSelected = "معلم";
  var role = "معلم"; //role
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(90)),
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(
                  colors: [
                    (Color.fromARGB(255, 199, 248, 248)),
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
                    margin: EdgeInsets.only(top: 150),
                    child: Image.asset(
                      "images/logo.png",
                      height: 106,
                      width: 500,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 195, 196, 197)),
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "", // Login text ??
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 188, 190, 190),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'البريد الإلكتروني',
                            icon: Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 78, 193, 225),
                            ),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 8.0,
                              top: 8.0,
                              right: 14.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              setState(() {
                                visible = false;
                              });
                              return "يرجى إدخال البريد إلكتروني";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              setState(() {
                                visible = false;
                              });
                              return ("الرجاء إدحال بريد إلكتروني صحيح");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscure3,
                          // textAlign: TextAlign.right ,
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
                            fillColor: Colors.white,
                            hintText: 'كلمة المرور',
                            icon: Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 78, 193, 225),
                            ),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                              left: 14.0,
                              bottom: 8.0,
                              top: 15.0,
                              right: 14.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),

                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              setState(() {
                                visible = false;
                              });
                              return "يرجى إدخال كلمة المرور";
                            }
                            if (!regex.hasMatch(value)) {
                              setState(() {
                                visible = false;
                              });
                              return ("لا يمكن لكلمة السر أن تكون أقل من ٦ أحرف أو أرقام");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DropdownButton<String>(
                          dropdownColor: Color.fromARGB(255, 233, 235, 236),
                          isDense: true,
                          isExpanded: false,
                          iconEnabledColor: Color.fromARGB(255, 74, 74, 74),
                          focusColor: Color.fromARGB(255, 83, 84, 84),
                          items: options.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 129, 129, 129),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected!;
                              role = newValueSelected; //role
                            });
                          },
                          value: _currentItemSelected,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Write Click Listener Code Here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visible = true;
                            });
                            signIn(
                                emailController.text, passwordController.text);
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
                            child: const Text(
                              "تسجيل الدخول",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                child: const CircularProgressIndicator(
                              color: Color.fromARGB(255, 160, 241, 250),
                            ))),
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

  Future<void> route(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    ///////// Getting SchoolID ////////
    ///***************////
    var schoolID = "x";
    User? user = FirebaseAuth.instance.currentUser;
    if (role == "معلم") {
      var col = FirebaseFirestore.instance
          .collectionGroup('Teacher')
          .where('Email', isEqualTo: user!.email);
      var snapshot = await col.get();
      for (var doc in snapshot.docs) {
        schoolID = doc.reference.parent.parent!.id;
        print(doc.reference.parent.parent?.id);
        //  break;
      }

      ///******* END *******////
      var kk = FirebaseFirestore.instance
          .collection('School/$schoolID/Teacher')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        print("TEACHER ID ## ${user.uid}");
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('Email') == user.email) {
            pref.setString("email", user.email!);
            pref.setString("type", 'T');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const teacherHP(),
              ),
            );
          }
        } else {
          Fluttertoast.showToast(
              msg: "لا يوجد معلّم بهذه البيانات",
              backgroundColor: Color.fromARGB(255, 221, 33, 30));
/*
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "لا يوجد معلّم بهذه البيانات يرجى التحقق من البيانات المدخلة",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              });
*/

          print('Document does not exist on the database');
          print(user!.uid);
          setState(() {
            visible = false;
          });
        }
      });
    } //end "Teacher"

    else if (role == "ولي أمر") {
      var schoolID = "x";
      User? user = FirebaseAuth.instance.currentUser;
      print("USER ~~~~~~~~~~~~~~~~~ ${user!.uid}");
      print("USER EMAIL ~~~~~~~~~~~~~~~~~ ${user.email}");

      if (role == "ولي أمر") {
        var col = FirebaseFirestore.instance
            .collectionGroup('Parent')
            .where('Email', isEqualTo: user.email);
        var snapshot = await col.get();
        for (var doc in snapshot.docs) {
          schoolID = doc.reference.parent.parent!.id;

          break;
        }
        var kk = FirebaseFirestore.instance
            .collection('School/$schoolID/Parent')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if (documentSnapshot.get('Email') == user.email) {
              pref.setString("email", user.email!);
              pref.setString("type", 'P');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => appBars(
                    schoolId: schoolID,
                    Index: 0,
                  ),
                ),
              );
            }
          } else {
            Fluttertoast.showToast(
                msg: "لا يوجد ولي أمر بهذه البيانات",
                backgroundColor: Color.fromARGB(255, 221, 33, 30));

/*            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "لا يوجد ولي أمر بهذه البيانات يرجى التحقق من البيانات المدخلة",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                });
       */
            print('Document does not exist on the database');
            print(user!.uid);
            setState(() {
              visible = false;
            });
          }
        });
      }
    } //end "Parent"

    else if (role == "مفوّض") {
      var schoolID = "x";
      User? user = FirebaseAuth.instance.currentUser;
      print("USER ~~~~~~~~~~~~~~~~~ ${user!.uid}");
      print("USER EMAIL ~~~~~~~~~~~~~~~~~ ${user.email}");
      if (role == "مفوّض") {
        var col = FirebaseFirestore.instance
            .collectionGroup('Commissioner')
            .where('Email', isEqualTo: user.email);
        var snapshot = await col.get();

        for (var doc in snapshot.docs) {
          schoolID = doc.reference.parent.parent!.id;

          break;
        }
        print('the commmmmm id $schoolID');
        var kk = FirebaseFirestore.instance
            .collection('School/$schoolID/Commissioner')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if (documentSnapshot.get('Email') == user.email) {
              pref.setString("email", user.email!);
              pref.setString("type", 'C');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const commissionerHP(),
                ),
              );
            }
          } else {
            Fluttertoast.showToast(
                msg: "لا يوجد مفوّض بهذه البيانات",
                backgroundColor: Color.fromARGB(255, 221, 33, 30));
/*
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "لا يوجد مفوّض بهذه البيانات يرجى التحقق من البيانات المدخلة",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                });
 */
            print('Document does not exist on the database');
            print(user!.uid);
            setState(() {
              visible = false;
            });
          }
        });
      }
    } //end "Com"
  } //end rout

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route(email);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          Fluttertoast.showToast(
              msg: "لم يتم العثور على مستخدم لهذا البريد الإلكتروني",
              backgroundColor: Color.fromARGB(255, 221, 33, 30));
/*
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "لم يتم العثور على مستخدم لهذا البريد الإلكتروني",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              });
  */
          setState(() {
            visible = false;
          });
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Fluttertoast.showToast(
              msg: "هناك خطأ في البريد الإلكتروني أو كلمة المرور",
              backgroundColor: Color.fromARGB(255, 221, 33, 30));
/*
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "هناك خطأ في البريد الإلكتروني أو كلمة المرور",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              });
              */
          setState(() {
            visible = false;
          });
        }
      }
    }
  } //end Sign
}
