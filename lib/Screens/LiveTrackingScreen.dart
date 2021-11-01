import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:driver/Screens/Detailspage.dart';
import 'package:driver/Screens/DraggableFloatingActionButton.dart';
import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/Screens/ListDelivery.dart';
import 'package:driver/Screens/ListDeliveryData.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:driver/commonFiles/HttpHelper.dart';
import 'package:driver/commonFiles/ProgressWidget.dart';
import 'package:driver/model/CustomerDataModel.dart';
import 'package:driver/model/MapListModel.dart';
import 'package:driver/model/ProductDataModel.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveTrackingScreen extends StatefulWidget {
  int? id;

  LiveTrackingScreen({this.id});

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}
enum NumberType { PhoneNumber, MobileNumber,  }
class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool onClick = false;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  // int id=1;
  bool movable = false;
  bool isLoading = false;
  int changeIndex = 0;
  List<CustomerDataModel> list = [];
  List<ProductDataModel> productlist =[];
  final Set<Polyline> _polyline = {};
  LocationPermission? permission;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.5031092, -0.1306184),
    zoom: 6.0,
  );
  final GlobalKey _parentKey = GlobalKey();
  Map<MarkerId, Marker> markers = {};
  List<LatLng> latlng =[];
  Position? position;
  LatLng? m1;
  LatLng? currentLatLong;
  String? number;
  NumberType _site = NumberType.PhoneNumber;
  List<MapListModel> petData = [
    MapListModel("1", "London", "", "Greater London", "	England",
        "United Kingdom", "PL15"),
    MapListModel("3", "Delancey", "Guernsey Channel Islands",
        "Guernsey Channel Islands", "	England", "United Kingdom", "GY2"),
    //  MapListModel("2","Trewen","Cornwall","Cornwall","	England","United Kingdom","EC1A"),
    //  MapListModel("4","St Sampsons","","	Guernsey Channel Islands","	England","United Kingdom","GY2"),
    // MapListModel("5","Aigburth","","Merseyside","	England","United Kingdom","L17"),
    //  MapListModel("6","Aintree","Merseyside ","Cornwall","	England","United Kingdom","	L10"),
  ];
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
  void initState() {
    // TODO: implement initState
    super.initState();

    getFrameList();
    data();
  }

  data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //id= prefs.getInt("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListDeliveryData()));
        return true;
      },
      child: Scaffold(
          body: ProgressWidget(
        isShow: isLoading,
        child: Stack(
          //alignment: Alignment.centerLeft,
          children: [
            Stack(
              //alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  polylines: _polyline,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,

                  // zoomControlsEnabled: false,
                  // zoomGesturesEnabled: false,
                  onTap: (_) {},
                  mapType: MapType.normal,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  markers: Set.of(markers.values),
                  onMapCreated: (GoogleMapController controler) async {
                    _controller.complete(controler);
                    permission = await Geolocator.checkPermission();
                    position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      currentLatLong =
                          LatLng(position!.latitude, position!.longitude);
                    }
                    if (list.length != 0) {
                      for (int i = 0; i < petData.length; i++) {
                        var address =
                            "${petData[i].Address1},${petData[i].Address2},${petData[i].city},${petData[i].state},${petData[i].Country},${petData[i].Pincode}";
                        // var addresses =
                        //     await Geocoder.local.findAddressesFromQuery(address);
                        // print(address);
                        // var first = addresses.first;
                        // String longitude = "${first.coordinates.longitude}";
                        // String latitude = "${first.coordinates.latitude}";
                        // print(
                        //     "${first.coordinates.latitude},${first.coordinates.longitude}");
                        // m1 = LatLng(
                        //     double.parse(latitude), double.parse(longitude));
                        Position position = await _getGeoLocationPosition();
                        m1 = LatLng(position.latitude,position.longitude);
                        MarkerId markerId1 = MarkerId("$i");
                        final Uint8List markerIcon = await getBytesFromAsset(
                            'assets/images/location.png', 30);
                        Marker marker1 = Marker(
                            markerId: MarkerId("$i"),
                            position: m1!,
                            icon: BitmapDescriptor.fromBytes(markerIcon),
                            infoWindow: InfoWindow(
                                title: "CFS16729${petData[i].id}",

                                snippet: "Postcode:${petData[i].Pincode}"));
                        setState(() {
                          Timer(Duration(seconds: 2), () {
                            setState(() {
                              markers[markerId1] = marker1;
                            });
                          });
                          latlng.add(m1!);

                        });

                      }
                    }
                    Timer(Duration(seconds: 2), () {
                      setState(() {
                        _polyline.add(Polyline(
                          width: 2,
                          polylineId: PolylineId('line1'),
                          visible: true,
                          //latlng is List<LatLng>
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
                        padding: const EdgeInsets.only(right: 25,left: 25,bottom: 25),
                        child: CarouselSlider.builder(
                          itemCount: list.length,
                          itemBuilder: ((BuildContext context, int i, int pageViewIndex){
                            return  SingleChildScrollView(
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child:list.length!=0?
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            if(list[i].delivery_status=="1"){

                                            }else{
                                              setTimer(int.parse(list[i].customer_id!));
                                            }

                                          });
                                        },
                                        child: Container(
                                          //height:onClick==true?455: 350,
                                          width: MediaQuery.of(context).size.width,
                                          decoration:BoxDecoration(color:list[i].delivery_status=="1"?Colors.grey.withOpacity(0.4):Colors.white,
                                              borderRadius: BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15,right: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(height: 2,),
                                                Align(
                                                    alignment: Alignment.topRight,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        list[i].type_of_delivery!=null && list[i].type_of_delivery!=""?Container(
                                                            height: 25,
                                                            width:100 ,
                                                            decoration: (BoxDecoration(color: Color(0xFF0B8DCD),borderRadius: BorderRadius.circular(5))),
                                                            child: Center(child: Text(list[i].type_of_delivery!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white),))):Text(""),
                                                        //Text(list[i].type_of_delivery==null?"":list[i].type_of_delivery,style: TextStyle(fontWeight: FontWeight.bold),),
                                                        SizedBox(width: 5,),
                                                        list[i].delivery_status=="1"?
                                                        Image.asset("assets/images/check.png",height: 25,width: 25,):Container(),
                                                        SizedBox(width: 15,),
                                                        Text("${i+1}/${list.length}",style: TextStyle(color: Colors.black,fontSize: 17),),
                                                      ],
                                                    )),
                                                SizedBox(height: 2,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(list[i].Order_No!,style: TextStyle(fontSize: 17),),
                                                        Text("27/08/2021",style: TextStyle(fontSize: 14),),
                                                      ],
                                                    ),

                                                    Container(
                                                      height: 29,width: 29,
                                                      decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFF4EC0E8)),
                                                      child: InkWell(
                                                          onTap: (){
                                                            setState(() {
                                                              showDialog(context: context, builder: (context) =>  SimpleDialog(
                                                                contentPadding: EdgeInsets.all(0),

                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),side: BorderSide(color: Color(0xFFD9E6EF),width: 2)),
                                                                children: <Widget>[
                                                                  StatefulBuilder(builder: (context,setState){
                                                                    return   Column(
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height: 170,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                                                            child: Column(
                                                                              children: [
                                                                                Text("Select MobileNumber",style: TextStyle(fontSize: 18),),
                                                                                ListTile(
                                                                                    title: Text("${list[i].mobileNumber}"),
                                                                                    leading: Radio(value: NumberType.MobileNumber, groupValue: _site,
                                                                                      onChanged: (NumberType? value) {
                                                                                        setState(() {
                                                                                          number=list[i].mobileNumber!;
                                                                                          _site = value!;
                                                                                        });
                                                                                      },
                                                                                    )
                                                                                ),
                                                                                ListTile(
                                                                                    title: Text("${list[i].PhoneNumber}"),
                                                                                    leading:Radio(value: NumberType.PhoneNumber, groupValue: _site,
                                                                                      onChanged: (NumberType? value) {
                                                                                        setState(() {
                                                                                          number=list[i].PhoneNumber!;
                                                                                          _site = value!;
                                                                                        });
                                                                                      },
                                                                                    )
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              child: InkWell(
                                                                                onTap: (){
                                                                                  launch("tel://$number");
                                                                                  Navigator.of(context, rootNavigator: true).pop('dialog');

                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                    BorderRadius.only(bottomLeft: Radius.circular(6)),
                                                                                    color: AppColors.lightblue,
                                                                                  ),
                                                                                  height: 55,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "SUBMIT",
                                                                                      textAlign: TextAlign.center,
                                                                                      style:TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }),

                                                                ],
                                                              ));


                                                            });
                                                          },
                                                          child: Icon(LineAwesomeIcons.phone,color: Colors.white,size: 16,)),
                                                    )
                                                  ],
                                                ),

                                                SizedBox(height: 10,),
                                                Text("Ethan Will",style: TextStyle(fontSize: 14),),
                                                //SizedBox(height: 2,),
                                                Container(
                                                  //height:MediaQuery.of(context).size.height/20,
                                                  width:200,
                                                  child: Text(list[i].Address!,
                                                    maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14),),
                                                ),
                                                Text(list[i].postalCode!),
                                                SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex:4,
                                                        child: Text("Delivery Instruction: ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                                                    Expanded(
                                                        flex:6,
                                                        child: Text("Leave order at front door of house",style: TextStyle(fontSize: 14),)),
                                                  ],

                                                ),
                                                //s SizedBox(height: 5,),
                                                SizedBox(height: 2,),
                                                Text("M. ${list[i].mobileNumber}"),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      print("object");
                                                      onClick=true;
                                                      getProductList(list[i].customer_id!);
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("P. ${list[i].PhoneNumber}"),
                                                      onClick==false?Icon(Icons.keyboard_arrow_down):Text("01:00 PM",style: TextStyle(color: AppColors.lightblue),)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 3,),
                                                onClick==true? Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: Container(
                                                    height: 1, width: MediaQuery.of(context).size.width,
                                                    color: Colors.grey.withOpacity(0.5),
                                                  ),
                                                ):Container(),
                                                onClick == true
                                                    ? SingleChildScrollView(
                                                    child: ListView.builder(
                                                        itemCount:productlist.length,
                                                        shrinkWrap:true,
                                                        padding: const EdgeInsets.all(0),
                                                        physics:ScrollPhysics(),
                                                        itemBuilder: (BuildContext context,int index){
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                productlist[index].product_name!,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color:
                                                                    Color(0xFF777777)),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text("No of boxes:${productlist[index].no_of_Box}",
                                                                      style: TextStyle(
                                                                          color:
                                                                          Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                                      )),
                                                                  Text("${productlist[index].pro_qty} Qty",
                                                                      style: TextStyle(
                                                                        color:
                                                                        Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                                      )),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              //Text(productlist[index].status!),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              // Text(
                                                              //   "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
                                                              //   maxLines: 2,
                                                              //   style: TextStyle(
                                                              //       color:
                                                              //       Color(0xFF777777)),
                                                              // ),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                              // Row(
                                                              //   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                              //   children: [
                                                              //     Text("No of boxes:"
                                                              //         "4",
                                                              //         style: TextStyle(
                                                              //             color:
                                                              //             Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                              //         )),
                                                              //     Text("04 Qty",
                                                              //         style: TextStyle(
                                                              //           color:
                                                              //           Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                              //         )),
                                                              //   ],
                                                              // ),
                                                              // SizedBox(
                                                              //   height: 8,
                                                              // ),
                                                              // Text(
                                                              //   "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
                                                              //   maxLines: 2,
                                                              //   style: TextStyle(
                                                              //       color:
                                                              //       Color(0xFF777777)),
                                                              // ),
                                                              // SizedBox(
                                                              //   height: 5,
                                                              // ),
                                                              // Row(
                                                              //   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                              //   children: [
                                                              //     Text("No of boxes:"
                                                              //         "4",
                                                              //         style: TextStyle(
                                                              //             color:
                                                              //             Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                              //         )),
                                                              //     Text("04 Qty",
                                                              //         style: TextStyle(
                                                              //           color:
                                                              //           Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                              //         )),
                                                              //   ],
                                                              // ),

                                                            ],
                                                          );
                                                        })
                                                )
                                                    : Container(),
                                                onClick==true?
                                                Column(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              onClick = false;
                                                            });
                                                          },
                                                          child: Icon(Icons
                                                              .keyboard_arrow_up)),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ):Container()
                                              ],
                                            ),
                                          ),
                                        )
                                      ):Container()
                                  ),
                                  list.length!=0?
                                  Positioned(
                                    top: -0.30,
                                    left: 20,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          height: 25,
                                          width: 120,
                                          decoration: (BoxDecoration(color:list[i].status=="Delivery"? Color(0xFF0B8DCD):list[i].status=="Collection"?Color(0xFFFFC5FB):Color(0xFFFFBC70),borderRadius: BorderRadius.circular(5))),
                                          child: Center(child: Text(list[i].status!.toUpperCase(),style: TextStyle(color:list[i].status=="Delivery"? Colors.white:Colors.black),))
                                      ),
                                    ),
                                  ):Container()


                                ],
                              ),
                            );
                          }
                          ), options: CarouselOptions(
                          disableCenter: true,
                          height:onClick==true ?510:280,
                          initialPage:widget.id==null?0: widget.id!,
                            onPageChanged: ( index,reason){
                              setState(() {
                                changeIndex=index;
                              });

                            },
                            reverse: false,autoPlay: false,enlargeCenterPage: true, viewportFraction: 1.0,),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8,top: 42,left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                //Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListDeliveryData()));
                              });
                            },
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Icon(LineAwesomeIcons.arrow_left,size: 25,color: Colors.black,)),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap:(){

                                    showDialog(context: context, builder: (context) =>  SimpleDialog(
                                      contentPadding: EdgeInsets.all(0),

                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),side: BorderSide(color: Color(0xFFD9E6EF),width: 2)),
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 140,
                                              width: MediaQuery.of(context).size.width,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                                child: TextWidget(text: "Are you sure you want to exit trip ?",color:Colors.black,fontSize: 18,),
                                                //child: Text("Are you sure you want to exit trip ?",style: TextStyle(fontSize: 18),),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).pop();

                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(bottomLeft: Radius.circular(6)),
                                                        color: AppColors.lightblue,
                                                      ),
                                                      height: 55,
                                                      child: Center(
                                                        child: Text(
                                                          "NO",
                                                          textAlign: TextAlign.center,
                                                          style:TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 2,),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap:(){
                                                      Navigator.pop(context);
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListDelivery()));

                                                       },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(bottomRight: Radius.circular(6)),
                                                        color: AppColors.lightblue,
                                                      ),
                                                      height: 55,
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Text(
                                                            "YES",
                                                            textAlign: TextAlign.center,
                                                            style:TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));

                                  },
                                  child: Container(
                                    height: 40,width: 40,
                                    decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Color(0xFFd9e6ef)),shape: BoxShape.circle),
                                    child: Icon(LineAwesomeIcons.square_1,color: Color(0xFFCE312D),),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  height: 32,
                                  width:110,
                                  decoration: (BoxDecoration(color: AppColors.lightblue,borderRadius: BorderRadius.circular(5))),
                                  child: InkWell(
                                    onTap: (){
                                      launch("tel://01162963800");
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(LineAwesomeIcons.phone,color: Colors.white,),
                                        SizedBox(width: 3,),
                                        Text("Support",style: TextStyle(color: Colors.white),)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
            DraggableFloatingActionButton(
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color(0xFFFFCE55),
                  ),
                  child:  Center(child: Icon(LineAwesomeIcons.home,color: Colors.white,)),
                ),
              ),
              initialOffset: const Offset(230, 42),
              //parentKey: _parentKey,
              // onPressed: () {
              //   Navigator.pushReplacement(
              //       context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
              // },
            ),
                // Container(
                //   height: MediaQuery.of(context).size.height,
                //   width: MediaQuery.of(context).size.width,
                //   //alignment: Alignment.centerRight,
                //   child: MatrixGestureDetector(
                //     onMatrixUpdate: (m, tm, sm, rm) {
                //       notifier.value = m;
                //     },
                //     child: AnimatedBuilder(
                //       animation: notifier,
                //       builder: (ctx, child) {
                //         return Stack(
                //           children: [
                //             Container(
                //               height: MediaQuery.of(context).size.width,
                //               width: MediaQuery.of(context)
                //                   .size
                //                   .width,
                //             ),
                //             Positioned(
                //               child: InkWell(
                //                 onTap: (){
                //                   Navigator.pushReplacement(
                //                       context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                //                 },
                //                 child: Container(
                //                   height: 50,
                //                   width:50,
                //                   transform: notifier.value,
                //                   decoration: (BoxDecoration(color: Color(0xFFFFCE55),shape: BoxShape.circle)),
                //                   child: Center(child: Icon(LineAwesomeIcons.home,color: Colors.white,)),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         );
                //       },
                //     ),
                //   ),
                // ),



              ],
            ),
          )
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  void getProductList(String id) async {
    setState(() {
      isLoading = true;
    });
    HttpHelper.getIndividualData(id).then((response) async {
      print(response.body);
      // setLoading(true);
      Map<String, dynamic> user = jsonDecode(response.body);
      var data = user['data'][0]['product_details'] as List;


      List<ProductDataModel> tagObjs = data.map((tagJson) => ProductDataModel.fromJson(tagJson)).toList();
      setState(() {
        print(tagObjs);
        isLoading = false;
        productlist = tagObjs;
      });

    });
  }

  void getFrameList() async {
    setState(() {
      isLoading = true;
    });
    String user_type = "1";
    HttpHelper.getList().then((response) async {
      //print(response.body);
      // setLoading(true);
      Map<String, dynamic> user = jsonDecode(response.body);
      var data = user['data'] as List;
      print("data");
      List<CustomerDataModel> tagObjs =
          data.map((tagJson) => CustomerDataModel.fromJson(tagJson)).toList();
      setState(() {
        print(tagObjs);
        isLoading = false;
        list = tagObjs;
      });
    });
  }

  setTimer(int index) {
    print(index);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Detailspage(
                  id: index,
                )));
  }
}
//     :Container(
//   height: 450,
//   width: MediaQuery.of(context).size.width,
//   child: ListView.builder(
//     itemCount: list.length,
//     shrinkWrap: true,
//     //scrollDirection: Axis.horizontal,
//     itemBuilder: ((BuildContext context, int i){
//       return  Stack(
//         alignment: Alignment.topLeft,
//         children: [
//           InkWell(
//             onTap:(){
//               setState(() {
//                 if(list[i].delivery_status=="1"){
//
//                 }else{
//                   setTimer(int.parse(list[i].customer_id));
//                 }
//
//               });
//             },
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               elevation: 20,
//               shadowColor: Colors.black,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 15,right: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(height: 28,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(list[i].Order_No,style: TextStyle(fontSize: 17),),
//                         Container(
//                           height: 29,width: 29,
//                           decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFF4EC0E8)),
//                           child: InkWell(
//                               onTap: (){
//                                 setState(() {
//                                   launch("tel://7567074977");
//                                 });
//                               },
//                               child: Icon(LineAwesomeIcons.phone,color: Colors.white,size: 16,)),
//                         )
//                       ],
//                     ),
//                     Text("27/08/2021",style: TextStyle(fontSize: 14),),
//                     SizedBox(height: 6,),
//                     Text("Ethan Will",style: TextStyle(fontSize: 14),),
//                     SizedBox(height: 7,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                             width: 190,
//                             child: Text(list[i].Address,
//                               maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15),)),
//                         Container(height: 25,width: 25,decoration: BoxDecoration(shape:BoxShape.circle,color:Colors.lightGreen ),
//                           child: Center(child: Text(list[i].customer_id,style: TextStyle(color: Colors.white,fontSize: 19),)),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     InkWell(
//                       onTap: (){
//                         setState(() {
//                           print("object");
//                           onClick=true;
//                         });
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("P. ${list[i].PhoneNumber}"),
//                           onClick==false?Icon(Icons.keyboard_arrow_down):Text("01:00 PM",style: TextStyle(color: AppColors.lightblue),)
//                         ],
//                       ),
//                     ),
//                     onClick == true
//                         ? SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             height: 1,
//                             width:
//                             MediaQuery.of(context)
//                                 .size
//                                 .width,
//                             color: Colors.grey
//                                 .withOpacity(0.5),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
//                             maxLines: 2,
//                             style: TextStyle(
//                                 color:
//                                 Color(0xFF777777)),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("No of boxes:"
//                                   "4",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 15,
//                                   )),
//                               Text("04 Qty",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
//                             maxLines: 2,
//                             style: TextStyle(
//                                 color:
//                                 Color(0xFF777777)),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("No of boxes:"
//                                   "4",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 15,
//                                   )),
//                               Text("04 Qty",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
//                             maxLines: 2,
//                             style: TextStyle(
//                                 color:
//                                 Color(0xFF777777)),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Row(
//                             mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("No of boxes:"
//                                   "4",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 15,
//                                   )),
//                               Text("04 Qty",
//                                   style: TextStyle(
//                                     color:
//                                     Color(0xFF433F3D),fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     onClick = false;
//                                   });
//                                 },
//                                 child: Icon(Icons
//                                     .keyboard_arrow_up)),
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                         ],
//                       ),
//                     )
//                         : Container(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: -0.10,
//             left: 20,
//             child: Align(
//               alignment: Alignment.topLeft,
//               child:  Container(
//                   height: 25,
//                   width: 120,
//                   decoration: (BoxDecoration(color:list[i].status=="Delivery"? Color(0xFF0B8DCD):list[i].status=="Collection"?Color(0xFFFFC5FB):Color(0xFFFFBC70),borderRadius: BorderRadius.circular(5))),
//                   child: Center(child: Text(list[i].status.toUpperCase(),style: TextStyle(color:list[i].status=="Delivery"? Colors.white:Colors.black),))
//               ),
//             ),
//           )
//
//         ],
//       );
//     }
//     ),
//   ),
// )