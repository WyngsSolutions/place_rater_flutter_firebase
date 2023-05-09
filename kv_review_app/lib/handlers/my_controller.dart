// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kv_review_app/modlers/user.dart';
import 'package:path/path.dart';
import '../modlers/app_constant.dart';

class MyController{

  final firestoreInstance = FirebaseFirestore.instance;

  //SIGN UP
  Future signUpUser(String userName, String email, String password) async {
    try {
      if(userName.isEmpty)
        showErrorAlert('Please enter username');
      else if(email.isEmpty)
        showErrorAlert('Please enter email address');
      else if(!GetUtils.isEmail(email))
        showErrorAlert('Please enter a valid email address');
      else if(password.isEmpty)
        showErrorAlert('Please enter password');
      else
      {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        MyUser newUser = MyUser(
          userId: userCredential.user!.uid,
          email: email,
          name: userName,
        );
        dynamic resultUser = await newUser.signUpUser(newUser);
        if (resultUser != null) 
        {
          AppConstants.user = resultUser;
          await AppConstants.user.saveUserDetails();
          return resultUser;
        } 
        else 
        {
          showErrorAlert('User cannot signup at this time. Try again later');
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        finalResponse['ErrorMessage'] = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        finalResponse['ErrorMessage'] = "Wrong password provided for that user";
      }
      showErrorAlert(finalResponse['ErrorMessage']);
      return null;
    } catch (e) {
      print(e.toString());
      showErrorAlert("Please try again later");
      return null;
    }
  }

  //SIGN IN
  Future signInUser(String email, String password) async {
    try {
      if(email.isEmpty)
        showErrorAlert('Please enter email address');
      else if(!GetUtils.isEmail(email))
        showErrorAlert('Please enter a valid email address');
      else if(password.isEmpty)
        showErrorAlert('Please enter password');
      else
      {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        MyUser newUser = MyUser(
          userId: userCredential.user!.uid,
          email: email,
          name: '',
        );
        dynamic resultUser = await MyUser.getLoggedInUserDetail(newUser);
        if (resultUser != null) 
        {
          AppConstants.user = resultUser;
          await AppConstants.user.saveUserDetails();
          return resultUser;
        } 
        else 
        {
          showErrorAlert('User cannot signin at this time. Try again later');
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        finalResponse['ErrorMessage'] = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        finalResponse['ErrorMessage'] ="The account already exists for that email";
      } else {
        finalResponse['ErrorMessage'] = e.code;
      }
      showErrorAlert(finalResponse['ErrorMessage']);
      return null;
    } catch (e) {
      print(e.toString());
      showErrorAlert("Please try again later");
      return null;
    }
  }
  
  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      if(email.isEmpty)
        showErrorAlert('Please enter email address');
      else if(!GetUtils.isEmail(email))
        showErrorAlert('Please enter a valid email address');
      else
      {
        String result = "";
        await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email).then((_) async {
          result = "Success";
        }).catchError((error) {
          result = error.toString();
          print("Failed emailed : $error");
        });

        if (result == "Success")
        {
          showErrorAlert('We have emailed you password reset email. Please use it to change your password.\nThanks');
          return true;
        }
        else 
        {
          showErrorAlert("Please try again later");
          return null;
        } 
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.code;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      showErrorAlert("Please try again later");
      return null;
    }
  }

  static void showErrorAlert(String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: const Text('Place Rater'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }
  

  Future getAllReviews() async {
    try {
      List reviewList = [];
      dynamic result = await firestoreInstance.collection("reviews")
      //.where('userId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map rev = result.data();
          rev['reviewId'] = result.id;
          reviewList.add(rev);
        });
        return true;
      });

      if (result)
      {
        reviewList.sort((b, a) => a['reviewAddedDate'].toDate().compareTo(b['reviewAddedDate'].toDate()));

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['ReviewList'] = reviewList;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addReview(String reviewCategory, String petName, String rating, String petPrice, String petDescription, String reviewAddress, File prodPicture, LatLng reviewCoordinates) async {
    try {
      String revImage1FirebasePath  = await uploadFile(prodPicture);
      //
      dynamic result = await FirebaseFirestore.instance.collection("reviews").
      add({
        'reviewCategory' :  reviewCategory,
        'reviewName' : petName,
        'reviewDescription': petDescription,
        'reviewPrice': petPrice,
        'reviewRating' : rating,
        'reviewAddress': reviewAddress,
        'reviewPicture': revImage1FirebasePath,
        'reviewLatitude': reviewCoordinates.latitude,
        'reviewLongitude': reviewCoordinates.longitude,
        'reviewOwnerName': AppConstants.user.name,
        'reviewOwnerId': AppConstants.user.userId,
        'reviewOwnerPhoto': AppConstants.user.userProfilePicture,
        'reviewAddedDate' : FieldValue.serverTimestamp()
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future<String> uploadFile(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(image.path);
    final firebaseStorage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot = await firebaseStorage.ref().child("pet_pictures").child(fileName).putFile(File(image.path));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future editReview(Map reviewData, String reviewCategory, String petName, String petPrice, String petDescription, String reviewAddress, File? reviewPicture, LatLng reviewCoordinates) async {
    try {
      //RESIZE IMAGES IF BIGGER THEN 1MB
      String revImage1FirebasePath = reviewData['reviewPicture'];
      if(reviewPicture != null)
      {
        revImage1FirebasePath  = await uploadFile(reviewPicture);
      }
      //
      dynamic result = await FirebaseFirestore.instance.collection("reviews")
      .doc(reviewData['reviewId'])
      .update({
        'reviewCategory' : reviewCategory,
        'reviewName' : petName,
        'reviewDescription': petDescription,
        'reviewPrice': petPrice,
        'reviewAddress': reviewAddress,
        'reviewPicture': revImage1FirebasePath,
        'reviewLatitude': reviewCoordinates.latitude,
        'reviewLongitude': reviewCoordinates.longitude,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllMyReviews() async {
    try {
      List reviewList = [];
      dynamic result = await firestoreInstance.collection("reviews")
      .where('reviewOwnerId', isEqualTo: AppConstants.user.userId)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map rev = result.data();
          rev['reviewId'] = result.id;
          reviewList.add(rev);
        });
        return true;
      });

      if (result)
      {
        reviewList.sort((b, a) => a['reviewAddedDate'].toDate().compareTo(b['reviewAddedDate'].toDate()));

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['ReviewList'] = reviewList;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }


  Future reportPet(Map pet, String reportReaon) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_pets").add({
        'petId': pet['postId'],
        'productName':pet['petName'],
        'productOwnerId' : pet['petOwnerId'],
        'productOwnerName' : pet['petOwnerName'],
        'reportedById': AppConstants.user.userId,
        'reportedByEmail': AppConstants.user.email,
        'reportedReason': reportReaon,
        'reportedProductTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future updatePostCommentCount(Map postDetails) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("posts")
      .doc(postDetails['postId'])
      .update({
        'commentsCount': (postDetails['commentsCount'] + 1),
      }).then((_) async {
        print("success!");
        await AppConstants.user.saveUserDetails();
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editPostRequest(Map postDetails, String description) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("posts")
      .doc(postDetails['postId'])
      .update({
        'description': description,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteMyPost(Map postDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("reviews").
        doc(postDetail['reviewId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  Future deleteReminder(Map reminderDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("reminders").
        doc(reminderDetail['reminderId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

 
  ///COMMENTS EVENTS
  Future getAllPetComments(List allComments, Map petDetail) async {
    try {
      dynamic result = await firestoreInstance.collection("post_comments")
      .where('postId', isEqualTo: petDetail['postId'])
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['commentId'] = result.id;
          allComments.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allComments.sort((a, b) => a['commentAddedTime'].toDate().compareTo(b['commentAddedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPetComment(Map petDetail, String postComment) async {
    try {   
      dynamic result = await firestoreInstance.collection("post_comments").add({
        'postId': petDetail['postId'],
        'postDescription': petDetail['petName'],
        'userComment' : postComment,
        'userEmail': AppConstants.user.email,
        'userId': AppConstants.user.userId,
        'userImage': AppConstants.user.userProfilePicture,
        'userName': AppConstants.user.name,
        'commentAddedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        //updatePostCommentCount(petDetail);
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future reportComment(Map commentDetail, String reportReaon) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_posts").add({
        'postId': commentDetail['postId'],
        'postDescription': commentDetail['description'],
        'userEmail' : commentDetail['email'],
        'userId': commentDetail['userId'],
        'userName': commentDetail['name'],
        'reportedById': AppConstants.user.userId,
        'reportedByEmail': AppConstants.user.email,
        'reportedReason': reportReaon,
        'reportedCommentTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPostRatingForUser(Map postDetail, double rating ,String review, Map userDetail) async {
    try {   
      dynamic result = await firestoreInstance.collection("user_post_reviews").add({
        'postId': postDetail['postId'],
        'postDescription': postDetail['description'],
        'userComment' : userDetail['userComment'],
        'userEmail': userDetail['userEmail'],
        'userId': userDetail['userId'],
        'userName': userDetail['userName'],
        'reviewAddedTime' : FieldValue.serverTimestamp(),
        'rating' : rating,
        'review' : review,
        'reviewAddedByName' : AppConstants.user.name
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future<dynamic> updateProfileInfo(String userName, String photoUrl) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(AppConstants.user.userId)
    .update({
      'name': userName,
      'userProfilePicture': photoUrl,
     }).then((_) async {
      print("success!");
      AppConstants.user.name = userName;
      AppConstants.user.userProfilePicture = photoUrl;
      await AppConstants.user.saveUserDetails();
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      return finalResponse;
    }).catchError((error) {
      print("Failed to update: $error");
      return setUpFailure();
    });
  }
  
  //
  Future reportReview(Map reportedReview, String reportReason) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_posts").add({
        'reportedReviewId': reportedReview['reviewId'],
        'reportedUserEmail' : reportedReview['reviewName'],
        'reportedById': AppConstants.user.userId,
        'reportedByEmail': AppConstants.user.email,
        'reportedReason': reportReason,
        'reportedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
 
  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
}