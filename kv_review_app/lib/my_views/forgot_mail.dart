// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kv_review_app/handlers/my_controller.dart';

class ForgotEmail extends StatefulWidget {
  const ForgotEmail({super.key});

  @override
  State<ForgotEmail> createState() => _ForgotEmailState();
}

class _ForgotEmailState extends State<ForgotEmail> {
  
  TextEditingController email = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  Future<void> submitPressed() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await MyController().forgotPassword(email.text);
    EasyLoading.dismiss();
    if (result != null) 
      Get.back();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: Stack(
          children: [
            
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.07, left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
                    height: MediaQuery.of(context).size.height*0.06,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.height*0.03,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.height*0.03,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width*0.03),
                            child: Text(
                              'Forgot Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize*2.4
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width*0.03,
                          width: MediaQuery.of(context).size.width*0.03,
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      child: Image.asset(
                        'assets/images/applogo.png',
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.height*0.15,
                      ),
                    ),
                  ),
                ],
              )
            ),


            Container(
              child: Container(
                height: MediaQuery.of(context).size.height*0.65,
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.3),
                padding: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width *0.06, right: MediaQuery.of(context).size.width *0.06, bottom: MediaQuery.of(context).size.height *0.02),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    Container(
                      child: Center(
                        child: Text(
                          'Please enter the email address to get password reset instructions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize*2,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    //Email
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
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
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.06,
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
                            isCollapsed: true,
                            isDense: false,
                            border: InputBorder.none,
                            hintText: 'Enter email',
                            hintStyle: TextStyle(fontSize: fontSize*1.6, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                   
                    GestureDetector(
                      onTap: submitPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
                        height: MediaQuery.of(context).size.height*0.063,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: fontSize*1.6,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.06,
        color: Colors.transparent,
        child: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Go back to ',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: fontSize * 1.6),
              children: <TextSpan>[
                TextSpan(
                  text: ' Login ',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
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