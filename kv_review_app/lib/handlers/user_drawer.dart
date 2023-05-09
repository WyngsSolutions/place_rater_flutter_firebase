// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kv_review_app/modlers/app_constant.dart';
import 'package:kv_review_app/modlers/user.dart';
import 'package:kv_review_app/my_views/register_user.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modlers/screen_loader.dart';
import '../modlers/stings.dart';
import '../my_views/delete_account.dart';
import '../my_views/my_reviews.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Container(
      width: MediaQuery.of(context).size.width*0.65,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02, left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.height*0.03),
            height: MediaQuery.of(context).size.height*0.22,
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    width: MediaQuery.of(context).size.height*0.08,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Text(
                        AppConstants.user.name[0].toUpperCase() + AppConstants.user.name[1].toUpperCase(),
                        style: TextStyle(
                          fontSize: fontSize*2.5,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                  child: Text(
                    AppConstants.user.name,
                    style: TextStyle(
                      fontSize: fontSize*1.7,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.005),
                  child: Text(
                    AppConstants.user.email,
                    style: TextStyle(
                      fontSize: fontSize*1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    onTap: (){
                      loadMyReviewsScreen();
                    },
                    leading: Icon(Icons.reviews),
                    title: Text(
                      'My Reviews',
                      style: TextStyle(
                        fontSize: fontSize*1.7
                      ),
                    ),
                  ),
                  // ListTile(
                  //   onTap: (){
                  //     launchUrl(Uri.parse('http://wyngslogistics.com/#/policy'));
                  //   },
                  //   leading: Icon(Icons.policy),
                  //   title: Text(
                  //     'Privacy Policy',
                  //     style: TextStyle(
                  //       fontSize: fontSize*1.7
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    onTap: (){
                      Share.share('Get Place Rater App\n${(Platform.isIOS) ? iosAppLink : androidAppLink}');
                    },
                    leading: Icon(Icons.share),
                    title: Text(
                      'Share App',
                      style: TextStyle(
                        fontSize: fontSize*1.7
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      Get.to(DeleteAccount());
                    },
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Delete account',
                      style: TextStyle(
                        fontSize: fontSize*1.7
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await MyUser.deleteUser();
                      Get.offAll(RegisterUser());
                    },
                    leading: Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: fontSize*1.7
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}