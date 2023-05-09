// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modlers/stings.dart';

class SetProductLocation extends StatefulWidget {
  const SetProductLocation({ Key? key }) : super(key: key);

  @override
  State<SetProductLocation> createState() => _SetProductLocationState();
}

class _SetProductLocationState extends State<SetProductLocation> {

  late LatLng center;
  late GoogleMapController controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  late LatLng prodLatLon; 

  @override
  void initState() {
    super.initState();
    prodLatLon = LatLng(latitude, longitude);
    center = LatLng(latitude, longitude);
  }

  void _onMapCreated(GoogleMapController cntlr)
  {
    controller = cntlr;
    MarkerId markerId = MarkerId('1');
    Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: "My Location",
        snippet: ''
      ),
      draggable: false,
    );
    _markers[markerId] = marker;
    
    setState(() {
      CameraPosition cPosition = CameraPosition(zoom: 12, target: LatLng(latitude, longitude),);
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    });
  }

  
  void setLocationPressed() async {
    prodLatLon = LatLng(latitude , longitude);
    Get.back(result : prodLatLon);
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [    
            
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                'Set location',
                style: TextStyle(
                  color: Colors.black,
                  fontSize : fontSize * 2.5,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025, left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.height*0.05),
              child: Text(
                'Please set the location for the review place so users should be able to know',
                style: TextStyle(
                  color: Colors.black,
                  fontSize : fontSize * 1.6,
                ),
              ),
            ),  

            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                    color: Colors.grey[300],
                    child: GoogleMap(
                        mapType: MapType.normal,
                        //enable zoom gestures
                        zoomGesturesEnabled: true,
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 14.0,           
                      ),
                      onCameraMove: (val){
                        //selectedOffer = null;
                        if(_markers.isNotEmpty)
                        {
                          MarkerId markerId = MarkerId('1');
                          Marker marker = _markers[markerId]!;
                          Marker updatedMarker = marker.copyWith(
                            positionParam: val.target
                          );
                          setState(() {
                            _markers[markerId] = updatedMarker;
                            latitude = updatedMarker.position.latitude;
                            longitude = updatedMarker.position.longitude;
                          });
                        }
                      },
                      markers: Set<Marker>.of(_markers.values),
                    ),
                  ),


                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: setLocationPressed,
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05, left: MediaQuery.of(context).size.width * 0.07, right: MediaQuery.of(context).size.width * 0.07),
                        height: MediaQuery.of(context).size.height *0.06,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(
                          child: Text(
                            'Set location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 2.1,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
            
          ]
        )
      )
    );
  }
}