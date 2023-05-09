// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kv_review_app/handlers/my_controller.dart';

class PostDetail extends StatefulWidget {

  final Map postDetail;
  const PostDetail({super.key, required this.postDetail});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  List reviewImages =[];
  late LatLng center;
  late GoogleMapController controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    reviewImages = [widget.postDetail['reviewPicture']];
    center = LatLng(0, 0);
  }

  Future<void> _onMapCreated(GoogleMapController cntlr) async {
    controller = cntlr;
    MarkerId markerId = MarkerId('user1');
    Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(widget.postDetail['reviewLatitude'], widget.postDetail['reviewLongitude']),
      infoWindow: InfoWindow(
        title: "${widget.postDetail['reviewName']}",
        snippet: '${widget.postDetail['reviewAddress']}'
      ),
      draggable: false,
    );
    _markers[markerId] = marker;
    
    setState(() {
      CameraPosition cPosition = CameraPosition(zoom: 13, target: LatLng(widget.postDetail['reviewLatitude'], widget.postDetail['reviewLongitude']),);
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      center = LatLng(widget.postDetail['reviewLatitude'], widget.postDetail['reviewLongitude']);
    });
  }


  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.009;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          'Post Detail',
          style: TextStyle(
            fontSize: fontSize*2.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          GestureDetector(
            onTap: showReportView,
            child: Container(
              height: MediaQuery.of(context).size.height *0.045,
              width: MediaQuery.of(context).size.height *0.045,
              margin: EdgeInsets.only(right: MediaQuery.of(context).size.width *0.04,),
              padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.005),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.report,
                color: Colors.green,
                size: MediaQuery.of(context).size.height *0.025,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Container(
            height: MediaQuery.of(context).size.height*0.35,
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.postDetail['reviewPicture']),
                fit: BoxFit.cover
              )
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.05, vertical: MediaQuery.of(context).size.height *0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               Text(
                "${widget.postDetail['reviewName']}",
                style: TextStyle(
                  fontSize: fontSize*2.2,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF171B2E),
                  height: 1.3
                ),
              ),
      
                Container(
                  child: Text(
                    '${widget.postDetail['reviewPrice']} - ${widget.postDetail['reviewRating']}',
                    style: TextStyle(
                      fontSize: fontSize*1.9,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF171B2E)
                    ),
                  ),
                ),
      
              
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.02),
                  child: Text(
                    "Reviewer Comments",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: fontSize*2,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF171B2E)
                    ),
                  ),
                ),                  
                Container(
                  child: Text(
                    (widget.postDetail['reviewDescription'].isEmpty) ? "NA" : "${widget.postDetail['reviewDescription']}",
                    style: TextStyle(
                      fontSize: fontSize*1.7,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF171B2E)
                    ),
                  ),
                ),
      
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.02),
                  child: Text(
                    "Address",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: fontSize*2,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF171B2E)
                    ),
                  ),
                ),                  
                Container(
                  child: Text(
                    "${widget.postDetail['reviewAddress']}",
                    style: TextStyle(
                      fontSize: fontSize*1.7,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF171B2E)
                    ),
                  ),
                ),
      
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height* 0.02),
                  width: MediaQuery.of(context).size.width*1,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)
                    ),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      //enable zoom gestures
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 13.0,           
                      ),
                      onCameraMove: (val){
                      },
                      markers: Set<Marker>.of(_markers.values),
                    ),
                  ),
                ],
              ),
            )  
          ],
        ),
      ),
    );
  }

  ///******* UTIL METHOD ****************///
  void showReportView()async
  {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return Container(
          padding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width *0.07, vertical:  MediaQuery.of(context).size.height *0.03),
          height: MediaQuery.of(context).size.height*0.52,
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Review To Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize * 2.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height *0.02),
                child: Text(
                  'Let the admin know what\'s wrong with this review. Your details will be kept anonymous for this report',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: fontSize * 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.back();
                  MyController().reportReview(widget.postDetail, 'Spam');
                  MyController.showErrorAlert('You have reported the review to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.025),
                  height: MediaQuery.of(context).size.height*0.055,
                  width:  MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Spam',
                      style: TextStyle(
                        fontSize: fontSize * 2,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  MyController().reportReview(widget.postDetail, 'Harassment');
                  MyController.showErrorAlert('You have reported the review to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.025),
                  height: MediaQuery.of(context).size.height*0.055,
                  width:  MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Harassment',
                      style: TextStyle(
                        fontSize: fontSize * 2,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  MyController().reportReview(widget.postDetail, 'Hate Speech');
                  MyController.showErrorAlert('You have reported the review to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.025),
                  height: MediaQuery.of(context).size.height*0.055,
                  width:  MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Hate Speech',
                      style: TextStyle(
                        fontSize: fontSize * 2,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  MyController().reportReview(widget.postDetail, 'Other');
                  MyController.showErrorAlert('You have reported the review to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height*0.025),
                  height: MediaQuery.of(context).size.height*0.055,
                  width:  MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Other',
                      style: TextStyle(
                        fontSize: fontSize * 2,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}