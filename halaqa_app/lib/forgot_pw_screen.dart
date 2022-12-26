import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';



class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final TextEditingController emailController = new TextEditingController();
  bool visible = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset () async {
   try{
     await FirebaseAuth.instance
     .sendPasswordResetEmail(email: emailController.text.trim());
     showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور"),
        );
      }
     );
   }on FirebaseAuthException catch (e){
    print (e);
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
           content: Text("لم يتم العثور على مستخدم لهذا البريد الإلكتروني",
                  style: TextStyle(
            color: Colors.red,
          ),

               ),
        );
      }
      );
   }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 181, 245, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color.fromARGB(255, 255, 255, 255),
                gradient: LinearGradient(colors: [(Color.fromARGB(255, 208, 247, 247)), Color.fromARGB(255, 255, 255, 255)],
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
                        margin: EdgeInsets.only(top: 90),
                        child: Image.asset(
                          "images/logo.png",
                          height: 106,
                          width: 500,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20, top: 40),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "*يرجى إدخال بريدك الإلكتروني وسيتم إرسال رابط لإعادة تعيين كلمة المرور ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 117, 116, 116)
                          ),
                        ),
                      )
                    ],
                  )
              ),
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
                          //textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'البريد الإلكتروني',
                            icon: Icon(
                             Icons.email,
                             color:  Color.fromARGB(255, 78, 193, 225),
                             ),
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0, right: 14.0),
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
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),

              GestureDetector(
              onTap: () {
               setState(() {
                 visible = true;
                });
                Validate(emailController.text);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20, right: 20, top:20),
                padding: EdgeInsets.only(left: 20, right: 20),
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [(Color.fromARGB(255, 170, 243, 250)), Color.fromARGB(255, 195, 196, 196)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)
                    ),
                  ],
                ),
                child: Text(
                  " إعادة تعيين كلمة المرور",
                  style: TextStyle(
                    fontSize: 20,
                      color: Colors.white
                  ),
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
                           // )
                            )
                            ),
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


    void Validate(String email) async {
    if (_formkey.currentState!.validate()) {
      try {
      ///
      passwordReset();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          //showDialog
         showDialog(
           context: context,
           builder: (context) {
              return AlertDialog(
                 content: Text("لم يتم العثور على مستخدم لهذا البريد الإلكتروني"),
               );
            }
         );
        } else {
          //Nothing
        }
      }
    }
  }
}
