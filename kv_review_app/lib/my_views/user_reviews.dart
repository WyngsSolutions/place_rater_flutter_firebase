// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kv_review_app/handlers/my_controller.dart';
import 'package:kv_review_app/handlers/user_drawer.dart';

import '../modlers/screen_loader.dart';

class UserReviews extends StatefulWidget {
  const UserReviews({super.key});

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {

  TextEditingController search = TextEditingController();
  late ScrollController scrollController;
  int selectedCategory = -1;
  List totalreviews = [];
  List filteredReviews = [];

  @override
  void initState() {
    super.initState();
    getAllReviews();
  }

  Future<void> getAllReviews() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await MyController().getAllReviews();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      totalreviews = result['ReviewList'];
      filteredReviews = List.from(totalreviews);
    }
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
        title: Text(
          "Home",
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize*2.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      drawer: UserDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *0.09,
              child: Container(
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height *0.02, left: MediaQuery.of(context).size.width *0.05, right: MediaQuery.of(context).size.width *0.05, bottom: MediaQuery.of(context).size.height *0.01),
                height: MediaQuery.of(context).size.height *0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green,
                    width: 0.3
                  )
                ),
                child: Center(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: fontSize*1.8),
                    onChanged: (val){
                      setState(() {
                        filteredReviews = totalreviews.where((element) => element['reviewName'].toString().toLowerCase().contains(val.toLowerCase())).toList();
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      hintStyle: TextStyle(fontSize: fontSize*1.8),
                      isCollapsed: true,
                      isDense: false,
                      prefixIcon: Container(
                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.035, MediaQuery.of(context).size.width *0.03, MediaQuery.of(context).size.width *0.02, MediaQuery.of(context).size.width *0.03),
                        height: MediaQuery.of(context).size.height *0.03,
                        width: MediaQuery.of(context).size.height *0.03,
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02),
                child : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, i){
                      return listCells(filteredReviews[i], i);
                    },
                  ),
                ),
              ),
            )
          ],
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