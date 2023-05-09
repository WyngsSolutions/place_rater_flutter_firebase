// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kv_review_app/handlers/my_controller.dart';

import '../modlers/screen_loader.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({Key? key}) : super(key: key);

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
 
  List reviewList = [];

  @override
  void initState() {
    super.initState();
    getAllReviews();
  }

  Future<void> getAllReviews() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await MyController().getAllMyReviews();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
      reviewList = result['ReviewList'];
    else
      MyController.showErrorAlert(result['ErrorMessage']);

    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          'My Reviews',
          style: TextStyle(
            fontSize: fontSize*2.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
        child : MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reviewList.length,
            itemBuilder: (context, i){
              return listCells(reviewList[i], i);
            },
          ),
        ),
      ),
    );
  }

  Widget listCells(Map data, int index){
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return GestureDetector(
      onTap: (){
        loadPostDetailScreen(data);
      },
      child: Container(
        margin: EdgeInsets.only(top:(index==0) ? 0 :  MediaQuery.of(context).size.height*0.014, left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05),
        height: MediaQuery.of(context).size.height * 0.10,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.01, vertical: MediaQuery.of(context).size.height*0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.green,
            width: 0.3
          )
        ),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.height*0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(data['reviewPicture']),
                  fit: BoxFit.cover
                )
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03, top:  MediaQuery.of(context).size.width * 0.015),
                      child: Text(
                        data['reviewName'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize*1.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03, top:  MediaQuery.of(context).size.width * 0.015),
                    //   child: Text(
                    //     data['reviewRating'],
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: fontSize*1.5,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.black
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, right: MediaQuery.of(context).size.width * 0.03, top:  MediaQuery.of(context).size.width * 0.015),
                      child: Text(
                        data['reviewAddress'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize*1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.green,
              size: MediaQuery.of(context).size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}