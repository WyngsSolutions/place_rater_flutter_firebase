// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sized_box_for_whitespace, avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kv_review_app/handlers/my_controller.dart';
import 'package:kv_review_app/modlers/app_constant.dart';
import 'package:kv_review_app/my_views/existing_user.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({ Key? key }) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  
  TextEditingController currentPassword = TextEditingController();   
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteAccount() async {
    if(currentPassword.text.isEmpty)
      MyController.showErrorAlert('Enter your current password');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      await deleteUser();
      EasyLoading.dismiss();
    }
  }

  Future deleteUser() async {
    try {
      User user = _auth.currentUser!;
      AuthCredential credentials = EmailAuthProvider.credential(email: AppConstants.user.email, password: currentPassword.text);
      print(user);
      UserCredential result = await user.reauthenticateWithCredential(credentials);
      await deleteuser(result.user!.uid);
      await result.user!.delete();
      Get.offAll(ExistingUser());
      MyController.showErrorAlert("Your account has been deleted");
      return true;
    } 
    on FirebaseAuthException catch (e) {
      if(e.code.toString() == "wrong-password")
        MyController.showErrorAlert('Your entered password is wrong');
    }
    catch(e){
      print(e.toString());
    }
  }
 
  Future deleteuser(String userId) {
    return userCollection.doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Delete Acount', style: TextStyle(color: Colors.white, fontSize: fontSize*2.2),),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top +  MediaQuery.of(context).size.height* 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06, top:  MediaQuery.of(context).size.width * 0.0),
              child: Text(
                'Enter your current password\nto delete account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: fontSize*2.2,
                  fontWeight: FontWeight.w500,
                  color: Colors.red
                ),
              ),
            ),

            
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06, right: MediaQuery.of(context).size.width * 0.06, top:  MediaQuery.of(context).size.width * 0.10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1
                )
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: fontSize * 1.8, color: Colors.black),
                  controller: currentPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    hintText: 'Current Password',
                    hintStyle: TextStyle(fontSize: fontSize * 1.8,),
                    fillColor: Colors.grey[100],
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: deleteAccount,
                child: Container(
                  margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.07),
                  height:  MediaQuery.of(context).size.height * 0.06,
                  width:  MediaQuery.of(context).size.width* 0.4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Delete',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize*2.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
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
}