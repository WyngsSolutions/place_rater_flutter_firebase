// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kv_review_app/modlers/user.dart';
import 'package:kv_review_app/my_views/register_user.dart';

import 'screen_loader.dart';

class AppConstants {
  static final AppConstants _singleton =  AppConstants._internal();
   static late MyUser user;

  factory AppConstants() {
    return _singleton;
  }

  AppConstants._internal();

  static Future<void> checkUserSaved() async {
    user = await MyUser.savedUserDetail();  
    Timer(Duration(seconds: 1), () {
      if(user.email.isEmpty)
        loadRegisterScreen();
      else
        loadHomeScreen();
    });
  }
}

void setupLoader() {
  EasyLoading.instance
  ..displayDuration = const Duration(milliseconds: 2000)
  ..indicatorType = EasyLoadingIndicatorType.circle
  ..loadingStyle = EasyLoadingStyle.custom
  ..indicatorSize = 45.0
  ..radius = 10.0
  ..progressColor = Colors.white
  ..backgroundColor = Colors.green
  ..indicatorColor = Colors.white
  ..textColor = Colors.white
  ..textStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
  ..maskColor = Colors.blue.withOpacity(0.5)
  ..userInteractions = false
  ..dismissOnTap = false
  ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    double opacity = controller.value;
    return Opacity(
      opacity: opacity,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}