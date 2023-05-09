import 'package:get/get.dart';
import 'package:kv_review_app/my_views/existing_user.dart';
import 'package:kv_review_app/my_views/forgot_mail.dart';
import '../my_views/my_home.dart';
import '../my_views/my_reviews.dart';
import '../my_views/post_detail.dart';
import '../my_views/register_user.dart';

void loadRegisterScreen(){
  Get.offAll(const RegisterUser());
}

void loadSignInScreen(){
  Get.offAll(const ExistingUser());
}

void loadHomeScreen(){
  Get.offAll(const MyHome());
}

void loadForgotPasswordScreen(){
  Get.to(const ForgotEmail());
}

void loadMyReviewsScreen(){
  Get.to(const MyReviews());
}

void loadPostDetailScreen(Map data){
  Get.to(PostDetail(postDetail: data));
}