import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:driver/Screens/Detailspage.dart';
import 'package:driver/Screens/DraggableFloatingActionButton.dart';
import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/Screens/ListDelivery.dart';
import 'package:driver/Screens/LiveTrackingScreen.dart';
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

class ListDeliveryData extends StatefulWidget {

  ListDeliveryData();

  @override
  _ListDeliveryDataState createState() => _ListDeliveryDataState();
}

class _ListDeliveryDataState extends State<ListDeliveryData> {
  Completer<GoogleMapController> _controller = Completer();
  bool onClick=false;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  // int id=1;
  bool movable=false;
  bool isLoading =false;
  int changeIndex=0;
  List<CustomerDataModel> list = [];
  List<ProductDataModel> productlist = [];
  final Set<Polyline>_polyline={};
  LocationPermission? permission;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.5031092,-0.1306184),
    zoom: 6.0,
  );
  Map<MarkerId,Marker> markers = {};
  List<LatLng> latlng =[];
  Position? position;
  LatLng? m1;
  LatLng? currentLatLong;
  List<MapListModel> petData =[
    MapListModel("1","London","","Greater London","	England","United Kingdom","PL15"),
    MapListModel("3","Delancey","Guernsey Channel Islands","Guernsey Channel Islands","	England","United Kingdom","GY2"),
    //  MapListModel("2","Trewen","Cornwall","Cornwall","	England","United Kingdom","EC1A"),
    //  MapListModel("4","St Sampsons","","	Guernsey Channel Islands","	England","United Kingdom","GY2"),
    // MapListModel("5","Aigburth","","Merseyside","	England","United Kingdom","L17"),
    //  MapListModel("6","Aintree","Merseyside ","Cornwall","	England","United Kingdom","	L10"),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFrameList();
    data();
  }
  data() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //id= prefs.getInt("id");
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
        return true;
      },
      child: Scaffold(
          body: ProgressWidget(
            isShow: isLoading,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset("assets/images/zoom.png",fit: BoxFit.cover,height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,),
                    // GoogleMap(
                    //   initialCameraPosition: _kGooglePlex,
                    //   polylines: _polyline,
                    //   myLocationEnabled: true,
                    //   myLocationButtonEnabled: false,
                    //   zoomControlsEnabled: false,
                    //   zoomGesturesEnabled: false,
                    //   onTap: (_){
                    //   },
                    //   mapType: MapType.normal,
                    //   compassEnabled: true,
                    //   rotateGesturesEnabled: true,
                    //   markers: Set.of(markers.values),
                    //
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20,left: 20,top:60),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: list.length,
                        //itemExtent: 208.0,
                        physics:ScrollPhysics() ,
                        itemBuilder: ((BuildContext context, int i){
                          return  Column(
                            children: [
                              Stack(
                               //  clipBehavior: Clip.none,
                                alignment: Alignment.topLeft,
                                children: [
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        // if(list[i].delivery_status=="1"){
                                        //
                                        // }else{
                                        //   setTimer(int.parse(list[i].customer_id));
                                        // }

                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      elevation: 8,
                                      shadowColor: Colors.black,
                                      child: Container(
                                        //height:list[i].onClick==true?390:170,
                                        decoration:BoxDecoration(color:Colors.white,
                                            borderRadius: BorderRadius.circular(5.0)),
                                        child: Container(
                                          color:list[i].delivery_status=="1"?Colors.grey.withOpacity(0.4):Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15,right: 15),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      list[i].type_of_delivery!=null && list[i].type_of_delivery!=""?Container(
                                                          height: 25,
                                                          width:100 ,
                                                          decoration: (BoxDecoration(color: Color(0xFF0B8DCD),borderRadius: BorderRadius.circular(5))),
                                                          child: Center(child: Text(list[i].type_of_delivery!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white),))):Text(""),
                                                      SizedBox(width: 10,),
                                                      list[i].delivery_status=="1"?
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10),
                                                        child: Align(
                                                            alignment:Alignment.topRight,
                                                            child: Image.asset("assets/images/check.png",height: 30,width: 30,)),
                                                      ):Container(),
                                                    ],
                                                  ),

                                                  list[i].delivery_status=="1"?Container():  SizedBox(height: 26,),
                                                  Text(list[i].Order_No!,style: TextStyle(fontSize: 17),),
                                                  Text("27/08/2021",style: TextStyle(fontSize: 14),),
                                                  SizedBox(height: 6,),
                                                  Text("Ethan Will",style: TextStyle(fontSize: 14,color: Color(0xFF433F3D)),),
                                                  SizedBox(height: 2,),
                                                  Container(
                                                    width:220,
                                                    child: Text(list[i].Address!,
                                                      maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14),),
                                                  ),
                                                  Text(list[i].postalCode!,style: TextStyle(fontSize: 14),),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                          flex:4,
                                                          child: Text("Delivery Instruction: ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                                                      Expanded(
                                                          flex:6,
                                                          child: Text("Leave order at front door of house ",style: TextStyle(fontSize: 14),)),
                                                    ],

                                                  ),
                                                  SizedBox(height: 2,),
                                                  Text("M. ${list[i].mobileNumber}"),

                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        print("object");
                                                        list[i].onClick=true;
                                                        getProductList(list[i].customer_id!);
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("P. ${list[i].PhoneNumber}"),
                                                        list[i].onClick==false?Icon(Icons.keyboard_arrow_down):Text("01:00 PM",style: TextStyle(color: AppColors.lightblue),)
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                    height: 1, width: MediaQuery.of(context).size.width,
                                                    color: Colors.grey.withOpacity(0.5),
                                                  ),
                                                  list[i].onClick == true
                                                      ? SingleChildScrollView(
                                                    child: ListView.builder(
                                                        itemCount:productlist.length,
                                                        shrinkWrap:true,
                                                        physics:ScrollPhysics(),
                                                        itemBuilder: (BuildContext context,int index){
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),

                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            productlist[index].product_name!,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                color:
                                                                Color(0xFF777777)),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
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
                                                            height: 3,
                                                          ),
                                                          Text(productlist[index].status!=null?productlist[index].status!:""),
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
                                                  list[i].onClick==true?
                                                 Column(
                                                   children: [
                                                     Align(
                                                       alignment: Alignment.topRight,
                                                       child: InkWell(
                                                           onTap: () {
                                                             setState(() {
                                                               list[i].onClick = false;
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
                                                  //SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -0.20,
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
                                  )
                                  // Positioned(
                                  //   top: -0.20,
                                  //   left: 20,
                                  //   child: Align(
                                  //     alignment: Alignment.topLeft,
                                  //     child: Container(
                                  //         height: 25,
                                  //         width:120 ,
                                  //         decoration: (BoxDecoration(color:list[i].status=="Delivered"? Color(0xFF0B8DCD):list[i].status=="PickUp"?Color(0xFFFFC5FB):Color(0xFFFFBC70),borderRadius: BorderRadius.circular(5))),
                                  //         child: Center(child: Text(list[i].status.toUpperCase(),style: TextStyle(color:list[i].status=="Delivered"? Colors.white:Colors.black),))
                                  //
                                  //     ),
                                  //   ),
                                  // )

                                ],
                              ),
                              SizedBox(height: 20,)
                            ],
                          );
                        }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8,top: 38,left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                //Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
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
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LiveTrackingScreen()));

                                    // showDialog(context: context, builder: (context)=>
                                    //     AlertDialog(
                                    //   title:Container(
                                    //     height: 114,width: 190,
                                    //     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    //     child: Text( "Are you sure you want to exit trip ?")),
                                    //   actions: [
                                    //     FlatButton(onPressed: ()=>Navigator.pop(context,false), child: Text("No")),
                                    //     FlatButton(onPressed: () {
                                    //       Navigator.pushReplacement(context,
                                    //           MaterialPageRoute(builder: (context) => ListDelivery()));
                                    //     }, child: Text("Yes")),
                                    //   ],
                                    // ));
                                  },
                                  child: Container(
                            height: 40,width: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFFFFCE55)),
                            child: Icon(LineAwesomeIcons.play,color: Colors.white,),
                          ),
                                ),
                                SizedBox(height: 20,),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DraggableFloatingActionButton(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
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
                      ),
                      initialOffset: const Offset(250, 32),
                      //parentKey: _parentKey,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
                      },
                    ),
                  ],
                ),




              ],
            ),
          )
      ),
    );
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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
      List<CustomerDataModel> tagObjs = data.map((tagJson) => CustomerDataModel.fromJson(tagJson)).toList();
      setState(() {
        print(tagObjs);
        isLoading = false;
        list = tagObjs;
      });

    });
  }
  void getProductList(String id) async {
    HttpHelper.getIndividualData(id).then((response) async {
      //print(response.body);
      // setLoading(true);
      Map<String, dynamic> user = jsonDecode(response.body);
      var data = user['data'][0]['product_details'] as List;
      print("data");

      List<ProductDataModel> tagObjs = data.map((tagJson) => ProductDataModel.fromJson(tagJson)).toList();
      setState(() {
        print(tagObjs);
        isLoading = false;
        productlist = tagObjs;
      });

    });
  }
  setTimer(int index){
    print(index);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Detailspage(id: index,)));

  }
}
