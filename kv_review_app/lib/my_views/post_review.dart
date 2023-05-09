// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, sort_child_properties_last
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kv_review_app/handlers/my_controller.dart';
import 'package:kv_review_app/my_views/my_home.dart';
import 'set_review_location.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  TextEditingController name = TextEditingController();
  String? selectedRating;
  String? selectedPrice;
  TextEditingController address = TextEditingController();
  LatLng? productCoordinates;
  TextEditingController additionalNotes= TextEditingController();
  //PHOTO
  XFile? image;
  String imagePath = "";
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    setState(() {
      if(pickedFile != null)
      {
        image = pickedFile;
        imagePath = pickedFile.path;
      }
    });
  }

  void postReview() async {
    if(name.text.isEmpty)
      MyController.showErrorAlert('Please enter review name');
    else if(selectedPrice == null)
      MyController.showErrorAlert('Please enter review price level');
    else if(address.text.isEmpty)
      MyController.showErrorAlert('Please enter address');
    else if(image == null)
      MyController.showErrorAlert('Please select review image');
    else if(productCoordinates == null)
    {
      dynamic resultCoordinates = await Get.to(SetProductLocation());
      if(resultCoordinates == null)
        return;
      else
      {
        productCoordinates = resultCoordinates;
        EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
        dynamic result = await MyController().addReview('1', name.text, selectedRating!, selectedPrice!, additionalNotes.text, address.text, File(image!.path), productCoordinates!);
        EasyLoading.dismiss();
        if (result['Status'] == "Success") 
        {
          Get.offAll(MyHome());
          MyController.showErrorAlert('Your review has been posted successfully');
        }
        else
        {
          MyController.showErrorAlert(result['ErrorMessage']);
        }
      }
    }
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
          'Post Review',
          style: TextStyle(
            fontSize: fontSize*2.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(onPressed: getImage, icon: Icon(Icons.add_a_photo))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // Container(
              //   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
              //   child: Text(
              //     'Category',
              //     style: TextStyle(
              //       fontSize: fontSize*1.6,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.2),
              //   child: Wrap(
              //     direction: Axis.horizontal,
              //     alignment: WrapAlignment.start,
              //     spacing: 10,
              //     runSpacing: 10,
              //     children: [
              //       for(int index=0; index < categoriesList.length; index++)
              //       GestureDetector(
              //         onTap: (){
              //           setState(() {
              //             selectedCategory = index;
              //           });
              //         },
              //         child: Container(
              //             height: SizeConfig.blockSizeVertical*4,
              //             padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
              //             margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1),
              //             decoration: BoxDecoration(
              //               color: (selectedCategory == index) ? Constants.appThemeColor : Colors.white,
              //               borderRadius: BorderRadius.circular(50),
              //                border: Border.all(
              //                 color: Constants.appThemeColor,
              //                 width: 1
              //               )
              //             ),
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Text(
              //                   "${categoriesList[index]}",
              //                   style: TextStyle(
              //                     fontSize: fontSize*1.4,
              //                     fontWeight: FontWeight.bold,
              //                     color: (selectedCategory == index) ? Colors.white : Constants.appThemeColor
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),                
              //     ],
              //   ),
              // ),

              //Name
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: fontSize*1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                padding: EdgeInsets.symmetric(horizontal: 20),
                //height: SizeConfig.blockSizeVertical*6,
                decoration: BoxDecoration(
                  color:Color(0XFFF4F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xffEDEDFB),
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(fontSize: fontSize*1.6),
                    //controller: name,
                    textAlignVertical: TextAlignVertical.center,
                    controller: name,
                    onChanged: (val){
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter name',
                      hintStyle: TextStyle(fontSize: fontSize*1.6,),
                      suffixIcon: Container(
                        margin: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width *0.03, vertical: MediaQuery.of(context).size.height*0.02),
                        height:MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.height*0.02,
                      ), 
                    ),
                  ),
                ),
              ),

              //Name
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: fontSize*1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height* 0.01),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height*0.005),
                //height: SizeConfig.blockSizeVertical*6,
                decoration: BoxDecoration(
                  color:Color(0XFFF4F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xffEDEDFB),
                    width: 1
                  )
                ),
                child: Center(
                  child : DropdownButton<String>(
                    hint: Text('Rating'),
                    style: TextStyle(fontSize: fontSize*1.6),
                    value: selectedRating,
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedRating = newValue;
                      });
                    },
                    items: ['5 Star', '4 Star', '3 Star', '2 Star', '1 Star'].map((location) {
                      return DropdownMenuItem<String>(
                        child: Text(location, style: TextStyle(fontSize: fontSize*1.6, color: Colors.black),),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),


              //Prices
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  'Prices',
                  style: TextStyle(
                    fontSize: fontSize*1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height*0.005),
                //height: SizeConfig.blockSizeVertical*6,
                decoration: BoxDecoration(
                  color:Color(0XFFF4F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xffEDEDFB),
                    width: 1
                  )
                ),
                child: Center(
                  child : DropdownButton<String>(
                    hint: Text('Price'),
                    style: TextStyle(fontSize: fontSize*1.6),
                    value: selectedPrice,
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPrice = newValue;
                      });
                    },
                    items: ['Expensive', 'Average', 'Cheap'].map((location) {
                      return DropdownMenuItem<String>(
                        child: Text(location, style: TextStyle(fontSize: fontSize*1.6, color: Colors.black),),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),

              //Name
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: fontSize*1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color:Color(0XFFF4F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(0xffEDEDFB),
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(fontSize: fontSize*1.6),
                    controller: address,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (val){
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter address',
                      hintStyle: TextStyle(fontSize: fontSize*1.6, color: Color(0XFF9A97AD)),
                      suffixIcon: Container(
                        margin: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width *0.03, vertical: MediaQuery.of(context).size.height*0.02),
                        height: MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.height*0.02,
                      ), 
                    ),
                  ),
                ),
              ),

              //Name
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Text(
                  'Additional information/Comments',
                  style: TextStyle(
                    fontSize: fontSize*1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                padding: EdgeInsets.symmetric(horizontal: 20),
                //height: SizeConfig.blockSizeVertical*6,
                decoration: BoxDecoration(
                  color:Color(0XFFF4F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xffEDEDFB),
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(fontSize: fontSize*1.6),
                    controller: additionalNotes,
                    textAlignVertical: TextAlignVertical.center,
                    minLines: 6,
                    maxLines: 6,
                    onChanged: (val){
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter comments',
                      hintStyle: TextStyle(fontSize: fontSize*1.6, color: Color(0XFF9A97AD)),
                      suffixIcon: Container(
                        margin: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width *0.03, vertical: MediaQuery.of(context).size.height *0.02),
                        height: MediaQuery.of(context).size.height *0.02,
                        width: MediaQuery.of(context).size.height* 0.02,
                      ), 
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: postReview,
        child: Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *0.03, left: MediaQuery.of(context).size.width *0.05, right: MediaQuery.of(context).size.width *0.05, top: MediaQuery.of(context).size.width *0.02),
          height: MediaQuery.of(context).size.height*0.063,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Post Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize*1.6,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
      ),
    );
  }
}