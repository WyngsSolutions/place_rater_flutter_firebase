// ignore_for_file: avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_constant.dart';

class MyUser{

  String userId = "";
  String email = "";
  String name = "";
  String userProfilePicture = "";

  MyUser({this.userId = "", this.name = "", this.email = "", this.userProfilePicture = "",});

  factory MyUser.fromJson(dynamic json) {
    MyUser user = MyUser(
      userId: json['userId'],
      name : json['name'],
      email : json['email'],
      userProfilePicture : json['userProfilePicture'],
    );
    return user;
  }

  Future saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("userProfilePicture", userProfilePicture);
  }

  static Future<MyUser> savedUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyUser user = MyUser();
    user.userId = prefs.getString("userId") ?? "";
    user.name = prefs.getString("name") ?? "";
    user.email =  prefs.getString("email") ?? "";
    user.userProfilePicture =  prefs.getString("userProfilePicture") ?? "";
    return user;
  }

  static Future deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  ///*********FIRESTORE METHODS***********\\\\
  Future<dynamic> signUpUser(MyUser user) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(user.userId).set({
      'userId': user.userId,
      'name': user.name,
      'userProfilePicture' : user.userProfilePicture,
      'email' : user.email,
      'oneSignalUserId' : '',  
    }).then((_) async {
      print("success!");
      return user;
    }).catchError((error) {
      print("Failed to add user: $error");
      return MyUser();
    });
  }

  static Future<dynamic> getLoggedInUserDetail(MyUser user) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance
    .collection("users")
    .doc(user.userId)
    .get()
    .then((value) async {
      if(value.exists)
      {
        print(value.data()!);
        MyUser userTemp = MyUser.fromJson(value.data());
        userTemp.userId = user.userId;
        //await userTemp.saveUserDetails();
        return userTemp;
      }
      else
      {
        //Signup google/facebook user as first time login
        MyUser userTemp = await MyUser().signUpUser(user);
        return userTemp;
      }
    }).catchError((error) {
      print("Failed to add user: $error");
      return MyUser();
    });
  }

  static Future<dynamic> getUserDetailByUserId(String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance
    .collection("users")
    .where('userId', isEqualTo: userId)
    .get()
    .then((value) async {
      MyUser userTemp = MyUser.fromJson(value.docs[0].data());
      userTemp.userId = userId;
      return userTemp;
    }).catchError((error) {
      print("Failed to add user: $error");
      return MyUser();
    });
  }

  static Future<dynamic> updateUserProfile(String userName, String profilePictureUrl, List categories) async {
    try{
      final firestoreInstance = FirebaseFirestore.instance;
      return await firestoreInstance.collection("users").doc(AppConstants.user.userId).update({
        'userName': userName,
        'userProfilePicture' : profilePictureUrl,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
    }
    catch(e){
      return false;
    }
  }
}
