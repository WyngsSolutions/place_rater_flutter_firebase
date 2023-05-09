// ignore_for_file: prefer_final_fields, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, avoid_unnecessary_containers
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kv_review_app/handlers/my_controller.dart';
import 'package:kv_review_app/modlers/screen_loader.dart';
import 'dart:async';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  bool showLoading = true;
  //******* LOCATION *******\\
  Location location =  Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isPermissionGiven = false;
  bool isGPSOpen = false;
  Timer? _timer;
  //
  List reviewList = [];
  double userLatitude =0;
  double userLongitude = 0;
  late LatLng center;
  late GoogleMapController controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  //late BitmapDescriptor hospitalIcon;
  Map showRev = {};

  @override
  void initState() {
    super.initState();
    center = LatLng(userLatitude, userLongitude);
    switchOnLocationPressed();
  }

  Future<void> _onMapCreated(GoogleMapController cntlr) async {
    controller = cntlr;
    MarkerId markerId = MarkerId('user1');
    Marker marker = Marker(
      markerId: MarkerId("user1"),
      position: LatLng(userLatitude, userLongitude),
      // infoWindow: InfoWindow(
      //   title: "My Location",
      //   snippet: 'Here is my location'
      // ),
      draggable: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
    );
    _markers[markerId] = marker;

    //final Uint8List hospitalIcon = await getBytesFromAsset('assets/logo_hospital.png', 100);

    for(int i=0; i < reviewList.length; i++)
    {
      MarkerId markerId = MarkerId('$i');
      Marker marker = Marker(
        markerId: MarkerId("review$i"),
        position: LatLng(reviewList[i]['reviewLatitude'], reviewList[i]['reviewLongitude']),
        // infoWindow: InfoWindow(
        //   title: "${reviewList[i]['reviewName']}",
        //   snippet: '${reviewList[i]['reviewAddress']}'
        // ),
        draggable: false,
        onTap: (){
          setState(() {
            showRev = reviewList[i];
          });
        }
      );
      _markers[markerId] = marker;
    }
    
    setState(() {
      CameraPosition cPosition = CameraPosition(zoom: 12, target: LatLng(userLatitude, userLongitude),);
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      center = LatLng(userLatitude, userLongitude);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  void dispose() {
    if(_timer != null)
      _timer!.cancel();
    super.dispose();
  }

  //****************************** LOCATION RELATED ********************************/
  void switchOnLocationPressed()async{
    //Permission Check
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) 
    {
      _permissionGranted = await location.requestPermission();
      
      if (_permissionGranted == PermissionStatus.deniedForever) {
        MyController.showErrorAlert('You have disabled location use for the app so please go to application settings and allow location use to continue');
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (_permissionGranted == PermissionStatus.denied) {
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (_permissionGranted != PermissionStatus.granted) {
         setState(() {
          showLoading = true;
        });
        return;
      }
    }

    if (_permissionGranted == PermissionStatus.granted)
      isPermissionGiven = true;
    

    //Service Check
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled)
    {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        startTimer();
        setState(() {
          showLoading = false;
        });
        return;
      }
      else
      {
        isGPSOpen = true;
        setState(() {
          showLoading = true;
        });
      }
    }
    else
    {
      isGPSOpen = true;
    }


    if(isGPSOpen && isPermissionGiven)
    {
      if(_timer != null)
        _timer!.cancel();
  
      _locationData = await location.getLocation();
      print(_locationData.latitude);
      print(_locationData.longitude);
      setUpUserLocation(_locationData.latitude!, _locationData.longitude!);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer =  Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          checkForGPS();
        },
      ),
    );  
  }

  void checkForGPS()async{
     _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled)
    {
      isGPSOpen = true;
      switchOnLocationPressed();
    }
  }

  Future<void> setUpUserLocation(double latitude , double longitude) async {
    userLatitude = latitude;
    userLongitude = longitude;
    getAllReviews();
  }
  
  void getAllReviews()async{
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await MyController().getAllReviews();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      reviewList = result['ReviewList'];
      setState(() { 
        showLoading = false;
      });
    }
    else
      MyController.showErrorAlert(result['ErrorMessage']);
  }
  
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return  WillPopScope(
      onWillPop: () async {
        return false;
      },
      child : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Around Me',
            style: TextStyle(
              fontSize: fontSize*2.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
        body: (showLoading) ? Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ) : (userLatitude != 0) ? mapView() : Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.08),
                height: MediaQuery.of(context).size.height *60,
                width: MediaQuery.of(context).size.width *100,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Location Disabled", style: TextStyle(fontSize: 3 * fontSize, color: Colors.black, fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *0.05,
                    ),
                    Text(
                      "Place Rater will show you nearby reviews when we can detect your location", 
                      style: TextStyle(fontSize: 1.8 * fontSize, color: Colors.black54, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *0.05,
                    ),
                    Icon(Icons.location_on, size: MediaQuery.of(context).size.height *0.20, color: Colors.green,)
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width *0.70,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: switchOnLocationPressed,
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Text(
                            "ENABLE",
                            style: TextStyle(fontSize: 1.8 * fontSize, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mapView (){
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Stack(
      children: [
        Container(
          color: Colors.grey[300],
          child: GoogleMap(
            mapType: MapType.normal,
            //enable zoom gestures
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            onTap: (val){
              if(showRev.isNotEmpty)
              {
                setState(() {
                  showRev = {};
                });
              }
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 14.0,           
            ),
            onCameraMove: (val){
            },
            markers: Set<Marker>.of(_markers.values),
          ),
        ),

        if(showRev.isNotEmpty)
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: (){
              loadPostDetailScreen(showRev);
            },
            child: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.02),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.017),
              height: MediaQuery.of(context).size.height*0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.height*0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(showRev['reviewPicture']),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.017),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${showRev['reviewName']}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: fontSize*2.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF171B2E)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height *0.01,),
                          Text(
                            "${showRev['reviewAddress']}",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: fontSize*1.7,
                              color: Color(0XFF171B2E)
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        )
      ]
    );
  }
}