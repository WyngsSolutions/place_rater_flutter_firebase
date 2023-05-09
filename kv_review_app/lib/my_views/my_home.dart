// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kv_review_app/my_views/user_reviews.dart';

import 'map.dart';
import 'post_review.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
 
  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    if(index == 2)
      Get.to(CreatePost());
    else
    {
      setState(() {
        page = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: (page == 0) ? UserReviews() : (page == 1) ? MapScreen() : Container(),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: page,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey[300],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom:  MediaQuery.of(context).size.height * 0.007),
                child: Icon(Icons.home, size:  MediaQuery.of(context).size.height *0.03,)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom:  MediaQuery.of(context).size.height * 0.007),
                child: Icon(Icons.share_location_rounded, size:  MediaQuery.of(context).size.height *0.03,)
              ),
              label: 'Nearby'
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(bottom:  MediaQuery.of(context).size.height * 0.007),
                child: Icon(Icons.add, size:  MediaQuery.of(context).size.height *0.03,)
              ),
              label: 'Create'
            ),
          ],
        ),
      ),
    );
  }
}