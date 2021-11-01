import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:driver/Screens/Detailspage.dart';
import 'package:driver/Screens/ListDelivery.dart';
import 'package:driver/Screens/ListDeliveryData.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:driver/Screens/LiveTrackingScreen.dart';
import 'package:driver/model/MapListModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class GoogleMapScreen extends StatefulWidget {

  String? warehouse;

  GoogleMapScreen({this.warehouse});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Polyline>_polyline={};
  LocationPermission? permission;
  Position? position;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? m1;
  LatLng? currentLatLong;
  Map<MarkerId,Marker> markers = {};
  List<LatLng> latlng = [];
  List<MapListModel> petData =[
    MapListModel("1","London","","Greater London","	England","United Kingdom","PL15"),
    MapListModel("3","Delancey","Guernsey Channel Islands","Guernsey Channel Islands","	England","United Kingdom","GY2"),
    MapListModel("2","Trewen","Cornwall","Cornwall","	England","United Kingdom","EC1A"),

    //MapListModel("4","St Sampsons","","	Guernsey Channel Islands","	England","United Kingdom","GY2"),
    MapListModel("5","Aigburth","","Merseyside","	England","United Kingdom","L17"),
    MapListModel("6","Aintree","Merseyside ","Cornwall","	England","United Kingdom","	L10"),
  ];
  final CameraPosition _kGooglePlex =
  CameraPosition(
    target: LatLng(51.5031092,-0.1306184),
    zoom: 6.0,
  );
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            polylines: _polyline,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // zoomControlsEnabled: false,
            // zoomGesturesEnabled: true,
            onTap: (_){
            },
            mapType: MapType.normal,
            //compassEnabled: true,
            //rotateGesturesEnabled: true,
            markers: Set.of(markers.values),

            onMapCreated: (GoogleMapController controler) async{
              _controller.complete(controler);
              permission = await Geolocator.checkPermission();
              position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              if(permission == LocationPermission.denied){
                permission = await Geolocator.requestPermission();
                currentLatLong=LatLng(position!.latitude,position!.longitude);
              }
              if(petData.length!=0){
                for(int i=0;i<petData.length;i++){
                  var address="${petData[i].Address1},${petData[i].Address2},${petData[i].city},${petData[i].state},${petData[i].Country},${petData[i].Pincode}";
                    var api="https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyAfkO4U-af6YFL0yHLlVOMUTl907pRaMbE";
                    print(api);
                  //String location ='Null, Press Button';

                  //location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                  // var addresses = await Geocoder.local.findAddressesFromQuery(address);
                  // print(address);
                  // var first = addresses.first;
                  // String longitude="${first.coordinates.longitude}";
                  // String latitude="${first.coordinates.latitude}";
                 // print("${first.coordinates.latitude},${first.coordinates.longitude}");
                  Position position = await _getGeoLocationPosition();
                  m1 = LatLng(position.latitude,position.longitude);
                  MarkerId markerId1 = MarkerId("$i");
                  final Uint8List markerIcon = await getBytesFromAsset('assets/images/location.png', 30);
                  Marker marker1=Marker(markerId: MarkerId("$i"),
                      position: m1!,
                      icon:BitmapDescriptor.fromBytes(markerIcon),
                      infoWindow: InfoWindow(
                          title: "CFS16729${petData[i].id}",onTap: (){
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LocationDetails(id: petData[i].id,)),
                        // );
                        /*scaffoldKey.currentState.showBottomSheet<void>((BuildContext context){
                                return Container(
                                  child:
                                  getBottomSheet("17.4435, 78.3772",context),
                                  height: 250,
                                  color: Colors.transparent,
                                );
                              });*/
                      },snippet: "PostCode:${petData[i].Pincode}"
                      ));
                  setState(() {

                    Timer(Duration(seconds:2),(){
                      setState(() {
                        markers[markerId1]=marker1;
                      });
                    });

                    latlng.add(m1!);
                    // latlng.add(m2);
                    // latlng.add(m3);
                    // latlng.add(m4);
                    // latlng.add(m5);
                    // latlng.add(m6);
                    // latlng.add(m7);
                    // latlng.add(m8);


                  });
                  // m2 = LatLng(23.014510,72.591760);
                  // m3 = LatLng(23.012930,72.555790);
                  // m4 =LatLng(23.063240,72.544456);
                  // m5 = LatLng(23.035080,72.527640);
                  // m6 = LatLng(23.02238,72.52572);
                  // m7 = LatLng(23.01251, 72.51347);
                  // m8 = LatLng(23.00476,72.50459);
                }
              }
              Timer(Duration(seconds:4),(){
                setState(() {
                  _polyline.add(Polyline(
                    width: 2,
                    polylineId: PolylineId('line1'),
                    visible: true,
                    points: latlng,
                    color: AppColors.lightblue,
                  ));
                });
              });

            },

          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 20,
                        shadowColor: Colors.black,
                        child: Container(
                          height: 70,width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(LineAwesomeIcons.truck,color: AppColors.lightblue,),
                                    SizedBox(width: 10,),
                                    Text("H01T2345",style: TextStyle(fontSize: 16),)
                                  ],
                                ),

                                InkWell(
                                  onTap: (){
                                    if(widget.warehouse==null){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => ListDeliveryData()));
                                    }else{
                                      final snackBar = SnackBar(content: Text('You have completed assigned delivery for the Day '));
                                      Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                                      // _scaffoldKey.currentState.showSnackBar(snackBar);

                                    }

                                  },
                                  child: Container(
                                    height: 40,width: 40,
                                    decoration: BoxDecoration(shape: BoxShape.circle,color:widget.warehouse==null? Color(0xFFFFCE55):Colors.grey),
                                    child: Icon(LineAwesomeIcons.play,color: Colors.white,),
                                  ),
                                )
                              ],
                            ),
                          ),

                        ),
                      ),
                      // Positioned(
                      //  // bottom:65,
                      //   left: 20,
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Container(
                      //       height: 25,
                      //       width:120 ,
                      //       decoration: (BoxDecoration(color: Color(0xFF0B8DCD),borderRadius: BorderRadius.circular(5))),
                      //       child: Center(child: Text("Two man".toUpperCase(),style: TextStyle(color: Colors.white),)),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),


                ],
              ),
            ),
          ),


        ],
      )
    );
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  // Future getDataFromAPI() async{
  //   final response =
  //   await http.get(Uri.parse('http://192.168.1.21/googleMap/getLocation.php'));
  //
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //
  //     Map<String, dynamic> user = jsonDecode(response.body);
  //     var apoData = user['data'] as List;
  //     List<MapListModel> tagObjs = apoData.map((tagJson) => MapListModel.fromJson(tagJson)).toList();
  //     setState(() {
  //       petData=tagObjs;
  //     });
  //
  //
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }
}
