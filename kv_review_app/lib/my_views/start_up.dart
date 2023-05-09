import 'package:flutter/material.dart';
import 'package:kv_review_app/modlers/app_constant.dart';

class StartUp extends StatefulWidget {
  const StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppConstants.checkUserSaved();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Colors.green,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(50),
          child: Center(
            child : Image.asset(
              'assets/images/applogo.png',
              height: MediaQuery.of(context).size.width *70,
              width: MediaQuery.of(context).size.width*70,
            ),
          ),
        ),
      ),
    );
  }
}