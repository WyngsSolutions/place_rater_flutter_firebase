// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kv_review_app/modlers/screen_loader.dart';
import '../handlers/my_controller.dart';

class ExistingUser extends StatefulWidget {
  const ExistingUser({super.key});

  @override
  State<ExistingUser> createState() => _ExistingUserState();
}

class _ExistingUserState extends State<ExistingUser> {
  
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signInUser() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await MyController().signInUser(email.text, password.text,);
    EasyLoading.dismiss();
    if (result != null) 
      loadHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            
            Center(
              child: Container(
                child: Image.asset(
                  'assets/images/applogo.png',
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.height*0.15,
                ),
              ),
            ),

            Container(
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize*2.8
                ),
              ),
            ),

            Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.02),
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.035, left: MediaQuery.of(context).size.width*0.06, right: MediaQuery.of(context).size.width*0.06, bottom: MediaQuery.of(context).size.height*0.02),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [                    

            
                  //Email
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: fontSize*1.6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(fontSize: fontSize*1.6),
                        controller: email,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (val){
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter email',
                          hintStyle: TextStyle(fontSize: fontSize*1.6, color: Colors.grey),
                          isCollapsed: true,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),

                  //Password
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: fontSize*1.6,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(fontSize: fontSize*1.6),
                        controller: password,
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (val){
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter password',
                          hintStyle: TextStyle(fontSize: fontSize*1.6, color: Colors.grey),
                          isCollapsed: true,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
                    child: GestureDetector(
                      onTap: (){
                        loadForgotPasswordScreen();
                      },
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: fontSize * 1.6,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: signInUser,
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.04),
                      height: MediaQuery.of(context).size.height*0.063,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: fontSize*1.6,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                  ),
                ]
              )
            ) 
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        color: Colors.transparent,
        child: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'New user?',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize * 1.6),
              children: <TextSpan>[
                TextSpan(
                  text: ' Sign Up ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize *1.6,
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                      Get.back();
                    }
                  )
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}