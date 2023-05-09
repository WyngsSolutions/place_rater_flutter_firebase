// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kv_review_app/modlers/screen_loader.dart';
import 'package:kv_review_app/my_views/existing_user.dart';
import '../handlers/my_controller.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
 
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signUpPressed() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await MyController().signUpUser(username.text, email.text, password.text,);
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
                'Create an Account',
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

            
                  Container(
                    child: Text(
                      'Username',
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
                    //height: SizeConfig.blockSizeVertical*6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(fontSize: fontSize*1.6),
                        controller: username,
                        onChanged: (val){
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Enter username',
                          hintStyle: TextStyle(fontSize: fontSize*1.6, color: Colors.green),
                        ),
                      ),
                    ),
                  ),

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

                  GestureDetector(
                    onTap: signUpPressed,
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.04),
                      height: MediaQuery.of(context).size.height*0.063,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Create Account',
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
              text: 'Have an account?',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize * 1.6),
              children: <TextSpan>[
                TextSpan(
                  text: ' Login ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize *1.6,
                  ),
                  recognizer: TapGestureRecognizer()
                  ..onTap = () {
                      Get.to(const ExistingUser());
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