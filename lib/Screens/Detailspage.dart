import 'dart:convert';
import 'dart:io';

import 'package:driver/Screens/DraggableFloatingActionButton.dart';
import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/Screens/LiveTrackingScreen.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:driver/commonFiles/HttpHelper.dart';
import 'package:driver/commonFiles/ProgressWidget.dart';
import 'package:driver/model/CustomerDataModel.dart';
import 'package:driver/model/ProductDataModel.dart';
import 'package:driver/model/ProductListModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class Detailspage extends StatefulWidget {
  int? id;

  Detailspage({this.id});

  @override
  _DetailspageState createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> with SingleTickerProviderStateMixin {
  // File image;
  // File notDeliveredImage;
  // File returnImage;
  // final picker = ImagePicker();
  TextEditingController notDeliveredControllar = TextEditingController();
  TextEditingController returnControllar = TextEditingController();
  TextEditingController notCollectedControllar = TextEditingController();

  String? _chosenValue;
  String? _chosenValueReturn;
  String? _chosenValueCollected;
  String? selectDeliveryStatus;
  String? productId;
  List<ProductListModel> p_id=[];
  List? arrayList;

  int deliveryStatus = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ProductDataModel> productlist = [];
  //bool onClick = false;
  List<Asset> images = [];
  List<Asset> notDeliveredImages = [];
  List<Asset> returnImages = [];
  List<Asset> collectedImages = [];
  List<Asset> exchangeImages = [];
  List<Asset> notCollectedImages = [];
 // List<int> p_id=[];
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );


  List<String> itemsNotDelivered = [
    'Please select value',
    'Customer Not Available',
    ' Item Damage',
    'Wrong item',
    'Others'
  ];
  List<String> itemsNotCollected = [
    'Please select value',
    'Customer Not Available',
    ' Item Damage',
    'Wrong item',
    'Others'
  ];
  List<String> itemsReturn = [
    'Please select value',
    ' Item Damage',
    'Wrong item',
    'Others'
  ];
  List<String> listDelivered = [
    'Collected',
    'Not Collected'
  ];
  List<String> listExchange = [
    'Exchanged',
    'Not Exchanged',
  ];
  List<String> listDelivered1 = [
    'Delivered',
    'Not Delivered',
    'Return',

  ];

  // bool valuesecond = false;
  // bool valueThird = false;
  bool selected = false;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  late Animation<Color> animation;
  AnimationController? controller;
  bool buttonToggle = true;
  bool isLoading=false;
  List<int> list=[];
  String? status,Order_No,Address,PhoneNumber,delivery_status,mobileNumber,postalCode,type_of_delivery;

  void animateColor() {
    if (buttonToggle) {
      controller!.forward();
    } else {
      controller!.reverse();
    }
    buttonToggle = !buttonToggle;
  }

  //int id;
  @override
  void initState() {
    super.initState();
    //data();

    getFrame();
    _controller.addListener(() => print('Value changed'));
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    // animation =
    //     ColorTween(begin: Colors.white, end: Colors.grey.withOpacity(0.1))
    //         .animate(controller!)
    //           ..addListener(() {
    //             setState(() {
    //               // The state that has changed here is the animation object’s value.
    //             });
    //           });
  }

  // data() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     id= prefs.getInt("id");
  //     print(id);
  //   });
  // }
  Future<void> pickImages() async {
    List<Asset> resultList =[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
      print(images);
    });
  }

  Future<void> pickImagesNotDeliveredData() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: notDeliveredImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      notDeliveredImages = resultList;
      print(notDeliveredImages);
    });
  }

  Future<void> pickImagesReturnData() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: returnImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      returnImages = resultList;
      print(returnImages);
    });
  }

  Future<void> pickImagesCollectedData() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: collectedImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      collectedImages = resultList;
      print(collectedImages);
    });
  }
  Future<void> pickImagesExchangeData() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: exchangeImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      exchangeImages = resultList;
      print(exchangeImages);
    });
  }

  Future<void> pickImagesNotCollectedData() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: notCollectedImages,
        materialOptions: MaterialOptions(
          actionBarTitle: "CFS.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      notCollectedImages = resultList;
      print(notCollectedImages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //     elevation: 0,
      //     leading: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.black,
      //         size: 17,
      //       ),
      //       onPressed: () {
      //         Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => LiveTrackingScreen(
      //                 )));
      //       },
      //     ),
      //     backgroundColor: Color(0xFFF5F5F5),
      //     title: Text(
      //       "Customer Details",
      //       style: TextStyle(fontSize: 17, color: Colors.black),
      //     )),
      body: ProgressWidget(
        isShow: isLoading,
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF5F5F5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 37,bottom: 15,right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LiveTrackingScreen(
                                                )));
                },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 17,
                              ),
                            ),
                            Text(
                              "Customer Details",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Visibility(child: Text("ferf",style: TextStyle(color: Color(0xFFF5F5F5)),),visible: true,)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 1),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topLeft,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black,
                                  child: Container(
                                    //height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 15, right: 15),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            type_of_delivery==null?SizedBox(
                                              height: 34,
                                            ):SizedBox(
                                              height: 25,
                                            ),
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: type_of_delivery!=null && type_of_delivery!=""?Container(
                                                    height: 25,
                                                    width:100 ,
                                                    decoration: (BoxDecoration(color: Color(0xFF0B8DCD),borderRadius: BorderRadius.circular(5))),
                                                    child: Center(child: Text(type_of_delivery!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white),))):Text(""),),
                                            Text(
                                              Order_No==null?"":Order_No!,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "27/08/2021",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height:13,
                                            ),
                                            Text(
                                              "Ethan Will",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              width: 250,
                                              child: Text(
                                                Address==null?"":Address!,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Text(postalCode==null?"":postalCode!),
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
                                            Text("M. $mobileNumber"),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  print("object");
                                                  //onClick = true;

                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("P. $PhoneNumber"),
                                                   Text(
                                                    "01:00 PM",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .lightblue),
                                                  )
                                                ],
                                              ),
                                            ),
                                         Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 1, width: MediaQuery.of(context).size.width,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                           SingleChildScrollView(
                                              child: ListView.builder(
                                                  itemCount:productlist.length,
                                                  shrinkWrap:true,
                                                  padding: const EdgeInsets.all(0),
                                                  physics:ScrollPhysics(),
                                                  itemBuilder: (BuildContext context,int index){
                                                  //  if(p_id.length!=null &&p_id.length!=0 )
                                                    //print(arrayList);
                                                    if(p_id.length!=null &&p_id.length!=0 )
                                                     // print();


                                                    return Container(
                                                      color: p_id.map((item) => item.product_id).contains(productlist[index].pid)==true?Colors.grey.withOpacity(0.3):Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 5,),
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
                                                                 Padding(
                                                                padding: const EdgeInsets.only(right: 15),
                                                                child: Container(
                                                                  height:20,width: 20,
                                                                  child:p_id.map((item) => item.product_id).contains(productlist[index].pid) == true?Column():
                                                                  Checkbox(
                                                                    value:  productlist[index].valuefirst,
                                                                    onChanged: (bool? value) {

                                                                      setState(() {
                                                                        productlist[index].valuefirst = value!;

                                                                        if(productlist[index].valuefirst==true){
                                                                            list.addAll([int.parse(productlist[index].pid!)]);
                                                                            productId=list.join(",");
                                                                            print(productId);
                                                                        }  else{
                                                                          list.remove(int.parse(productlist[index].pid!));
                                                                        }
                                                                        }

                                                                      );
                                                                      },
                                                                  ),
                                                                          )
                                                                        )
                                                            ],
                                                          ),
                                                          for(int i=0;i<p_id.length;i++)
                                                            if(p_id[i].product_id==productlist[index].pid)
                                                              p_id.length!=null &&  p_id.length!=0 && p_id.map((item) => item.product_id).contains(productlist[index].pid) == true?Text(p_id[i].status!):Container(),
                                                          SizedBox(
                                                            height: 8,
                                                          ),


                                                        ],
                                                      ),
                                                    );
                                                    return Container(
                                                      color: Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 5,),
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
                                                              Padding(
                                                                  padding: const EdgeInsets.only(right: 15),
                                                                  child: Container(
                                                                    height:20,width: 20,
                                                                    child:
                                                                    Checkbox(
                                                                      value:  productlist[index].valuefirst,
                                                                      onChanged: (bool? value) {

                                                                        setState(() {
                                                                          productlist[index].valuefirst = value!;

                                                                          if(productlist[index].valuefirst==true){
                                                                            list.addAll([int.parse(productlist[index].pid!)]);
                                                                            productId=list.join(",");
                                                                            print(productId);
                                                                          }  else{
                                                                            list.remove(int.parse(productlist[index].pid!));
                                                                          }
                                                                        }

                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          //p_id.length!=null &&  p_id.length!=0 && p_id[index].product_id==productlist[index].pid?Text(p_id[index].status):Container(),
                                                          SizedBox(
                                                            height: 8,
                                                          ),


                                                        ],
                                                      ),
                                                    );
                                                  })
                                          ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // onClick == true
                                            //     ? SingleChildScrollView(
                                            //   child: Column(
                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                            //     mainAxisAlignment: MainAxisAlignment.start,
                                            //     children: [
                                            //       SizedBox(
                                            //         height: 10,
                                            //       ),
                                            //       Container(
                                            //         height: 1,
                                            //         width:
                                            //         MediaQuery.of(context).size.width,
                                            //         color: Colors.grey
                                            //             .withOpacity(0.5),
                                            //       ),
                                            //       SizedBox(
                                            //         height: 10,
                                            //       ),
                                            //       Text(
                                            //         "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
                                            //         maxLines: 2,
                                            //         style: TextStyle(
                                            //             color:
                                            //             Color(0xFF777777)),
                                            //       ),
                                            //       SizedBox(
                                            //         height: 5,
                                            //       ),
                                            //       Row(
                                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //         children: [
                                            //           Text("No of boxes:"
                                            //               "4",
                                            //               style: TextStyle(
                                            //                   color:
                                            //                   Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                            //               )),
                                            //           Text("04 Qty",
                                            //               style: TextStyle(
                                            //                 color:
                                            //                 Color(0xFF433F3D),
                                            //               )),
                                            //           selectDeliveryStatus=="Delivered" || selectDeliveryStatus=="Return" || selectDeliveryStatus == "Exchange" ||selectDeliveryStatus == "Not Exchange"?
                                            //           Padding(
                                            //             padding: const EdgeInsets.only(right: 15),
                                            //             child: Container(
                                            //               height:20,width: 20,
                                            //               child: Checkbox(
                                            //                 value: this.valuefirst,
                                            //                 onChanged: (bool value) {
                                            //                   setState(() {
                                            //                     this.valuefirst = value;
                                            //                   });
                                            //                 },
                                            //               ),
                                            //             ),
                                            //           ):Container()
                                            //         ],
                                            //       ),
                                            //       SizedBox(
                                            //         height: 15,
                                            //       ),
                                            //       Text(
                                            //         "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
                                            //         maxLines: 2,
                                            //         style: TextStyle(
                                            //             color:
                                            //             Color(0xFF777777)),
                                            //       ),
                                            //       SizedBox(
                                            //         height: 5,
                                            //       ),
                                            //       Row(
                                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //         children: [
                                            //           Text("No of boxes:"
                                            //               "4",
                                            //               style: TextStyle(
                                            //                   color:
                                            //                   Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                            //               )),
                                            //           Text("04 Qty",
                                            //               style: TextStyle(
                                            //                 color:
                                            //                 Color(0xFF433F3D),
                                            //               )),
                                            //           selectDeliveryStatus=="Delivered" || selectDeliveryStatus=="Return" || selectDeliveryStatus == "Exchange" ||selectDeliveryStatus == "Not Exchange" ? Padding(
                                            //             padding: const EdgeInsets.only(right: 15),
                                            //             child: Container(
                                            //               height:20,width: 20,
                                            //               child: Checkbox(
                                            //                 value: this.valuesecond,
                                            //                 onChanged: (bool value) {
                                            //                   setState(() {
                                            //                     this.valuesecond = value;
                                            //                   });
                                            //                 },
                                            //               ),
                                            //             ),
                                            //           ):Container()
                                            //         ],
                                            //       ),
                                            //       SizedBox(
                                            //         height: 15,
                                            //       ),
                                            //       Text(
                                            //         "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
                                            //         maxLines: 2,
                                            //         style: TextStyle(
                                            //             color:
                                            //             Color(0xFF777777)),
                                            //       ),
                                            //       SizedBox(
                                            //         height: 5,
                                            //       ),
                                            //       Row(
                                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //         children: [
                                            //           Text("No of boxes:"
                                            //               "4",
                                            //               style: TextStyle(
                                            //                   color:
                                            //                   Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                            //               )),
                                            //           Text("04 Qty",
                                            //               style: TextStyle(
                                            //                 color:
                                            //                 Color(0xFF433F3D),
                                            //               )),
                                            //           selectDeliveryStatus=="Delivered" || selectDeliveryStatus=="Return" ||
                                            //               selectDeliveryStatus == "Exchange" ||selectDeliveryStatus == "Not Exchange"?
                                            //           Padding(
                                            //             padding: const EdgeInsets.only(right: 15),
                                            //             child: Container(
                                            //               height:20,width: 20,
                                            //               child: Checkbox(
                                            //                 value: this.valueThird,
                                            //                 onChanged: (bool value) {
                                            //                   setState(() {
                                            //                     this.valueThird = value;
                                            //                   });
                                            //                 },
                                            //               ),
                                            //             ),
                                            //           ):Container()
                                            //         ],
                                            //       ),
                                            //       SizedBox(
                                            //         height: 15,
                                            //       ),
                                            //       Align(
                                            //         alignment: Alignment.topRight,
                                            //         child: InkWell(
                                            //             onTap: () {
                                            //               setState(() {
                                            //                 onClick = false;
                                            //               });
                                            //             },
                                            //             child: Icon(Icons
                                            //                 .keyboard_arrow_up)),
                                            //       ),
                                            //       SizedBox(
                                            //         height: 15,
                                            //       ),
                                            //     ],
                                            //   ),
                                            // )
                                            //     : Container(),
                                            // SizedBox(
                                            //   height: 5,
                                            // ),
                                            // Container(
                                            //   height: 1,
                                            //   width:
                                            //   MediaQuery.of(context).size.width,
                                            //   color: Colors.grey.withOpacity(0.5),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  status=="Exchange"?"Exchange Status":"Delivery Status",
                                  style: TextStyle(color: AppColors.lightblue),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 1, right: 1),
                                //   child: InkWell(
                                //     onTap: (){
                                //       setState(() {
                                //         animateColor();
                                //       });
                                //     },
                                //     child: Column(
                                //       children: [
                                //         Container(
                                //           height: 50,
                                //           width: MediaQuery.of(context).size.width,
                                //           decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             borderRadius: BorderRadius.circular(10),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: Colors.grey.withOpacity(0.5),
                                //                 spreadRadius: 5,
                                //                 blurRadius: 7,
                                //                 offset: Offset(
                                //                     0, 3), // changes position of shadow
                                //               ),
                                //             ],
                                //           ),
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(left: 20,right: 20),
                                //             child: Column(
                                //               mainAxisAlignment: MainAxisAlignment.center,
                                //               children: [
                                //                 Center(
                                //                   child: Row(
                                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                     children: [
                                //                       Text("Please Select Delivery status"),
                                //                       Icon(Icons.keyboard_arrow_down)
                                //                     ],
                                //                   ),
                                //                 ),
                                //
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         buttonToggle==false?
                                //         AnimatedContainer(
                                //           duration: const Duration(seconds: 3),
                                //           curve: Curves.slowMiddle,
                                //           width: MediaQuery.of(context).size.width,
                                //           height: 120,
                                //           decoration: BoxDecoration(
                                //             color: Colors.white,
                                //             borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                                //             boxShadow: [
                                //               BoxShadow(
                                //                 color: Colors.grey.withOpacity(0.5),
                                //                 spreadRadius: 2,
                                //                 blurRadius: 2,
                                //                 // changes position of shadow
                                //               ),
                                //             ],
                                //           ),
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                //             child: Column(
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //               children: [
                                //                 Text("Delivered"),
                                //                 Text("Not Delivered"),
                                //                 Text("Return"),
                                //               ],
                                //             ),
                                //           ),
                                //
                                //         ):Container()
                                //       ],
                                //     ),
                                //   ),
                                // ),
              //               GestureDetector(
              //                 onTap: () {
              //                   setState(() {
              //                     selected = !selected;
              //                   });
              //                 },
              //   child: AnimatedContainer(
              //     width: selected ? 300.0 : 100.0,
              //     height: selected ? 100.0 : 200.0,
              //     color: selected ? Colors.red : Colors.blue,
              //
              //     alignment: selected ? Alignment.center : AlignmentDirectional.topCenter,
              //     duration: const Duration(seconds: 1),
              //     curve: Curves.fastOutSlowIn,
              //     child: const FlutterLogo(size: 75),
              //   ),
              // ),
              //               GestureDetector(
              //                 onTap: () {
              //                   setState(() {
              //                     selected = !selected;
              //                   });
              //                 },
              //                 child: AnimatedContainer(
              //                   width: MediaQuery.of(context).size.width,
              //                   height: selected?60:180,
              //                   duration: const Duration(seconds: 1),
              //                   curve: Curves.fastOutSlowIn,
              //                   padding: const EdgeInsets.only(left: 20, right: 20),
              //                   decoration: BoxDecoration(border: Border.all(color: Color(0xFFB9CCDD), width: 1),
              //                       borderRadius: BorderRadius.circular(13),color: Colors.white, boxShadow: [
              //                       BoxShadow(
              //                         color: Colors.grey.withOpacity(0.3),
              //                         offset: const Offset(
              //                           5.0,
              //                           5.0,
              //                         ),
              //                         blurRadius: 10.0,
              //
              //                       ), //BoxShadow
              //                       BoxShadow(
              //                         color: Colors.white,
              //                         offset: const Offset(0.0, 0.0),
              //                         blurRadius: 0.0,
              //                         spreadRadius: 0.0,
              //                       ), //BoxShadow
              //                     ],),
              //                   child: Padding(
              //                     padding: const EdgeInsets.only(top: 15),
              //                     child: Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       crossAxisAlignment: selected?CrossAxisAlignment.center:CrossAxisAlignment.start,
              //                       children: [
              //                         Text("Delivered"),
              //                         Icon(LineAwesomeIcons.angle_down)
              //
              //                       ],
              //                     ),
              //                   ),
              //
              //                 ),
              //               ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child:status=="Delivery"?
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFB9CCDD), width: 1),
                                        borderRadius: BorderRadius.circular(13)),
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      value: selectDeliveryStatus,
                                      isExpanded: true,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      underline: SizedBox(),
                                      items: listDelivered1.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),

                                      hint: Text(
                                        "Please select Delivery Status",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectDeliveryStatus = value;
                                          // if(selectDeliveryStatus == "Delivered" ||  selectDeliveryStatus == "Return" ){
                                          //   onClick=true;
                                          // }
                                        });
                                      },
                                    ),
                                  ) : status=="Collection"?
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(color:Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFB9CCDD), width: 1),
                                        borderRadius: BorderRadius.circular(13)),
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      value: selectDeliveryStatus,
                                      isExpanded: true,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      underline: SizedBox(),
                                      items: listDelivered.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),

                                      hint: Text(
                                        "Please select Delivery Status",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectDeliveryStatus = value;
                                        });
                                      },
                                    ),
                                  ):
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFB9CCDD), width: 1),
                                        borderRadius: BorderRadius.circular(13)),
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      value: selectDeliveryStatus,
                                      isExpanded: true,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      underline: SizedBox(),
                                      items: listExchange.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style:
                                                TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),

                                      hint: Text(
                                        "Please select Delivery Status",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectDeliveryStatus = value;
                                          // if(status=="Exchange"){
                                          //   if(value=="Delivered"){
                                          //     selectDeliveryStatus=="ExchangeDelivered";
                                          //   }else{
                                          //     selectDeliveryStatus=="ExchangeNotDelivered";
                                          //   }
                                          //
                                          // }
                                          // if( selectDeliveryStatus == "Exchange" || selectDeliveryStatus == "Not Exchange"){
                                          //   onClick=true;
                                          // }
                                        });
                                      },
                                    ),
                                  )

                                ),
                                selectDeliveryStatus == "Delivered"
                                    ? deliveryData()
                                    : Container(),
                                selectDeliveryStatus == "Not Delivered"
                                    ? notDeliveryData()
                                    : Container(),
                                selectDeliveryStatus == "Return"
                                    ? returnData()
                                    : Container(),
                                selectDeliveryStatus == "Collected"
                                    ? collectedData()
                                    : Container(),
                                selectDeliveryStatus == "Not Collected"
                                    ? notCollectedData()
                                    : Container(),
                                selectDeliveryStatus == "Exchanged"
                                    ? deliveryData()
                                    : Container(),
                                selectDeliveryStatus == "Not Exchanged"
                                    ? notCollectedData()
                                    : Container(),
                                // selectDeliveryStatus == "Exchange"
                                //     ? exchangeData()
                                //     : Container()
                              ],
                            ),
                           status=="Delivery"?
                           Positioned(
                              top: -0.10,
                              left: 20,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    height: 25,
                                    width: 120,
                                    decoration: (BoxDecoration(
                                        color: Color(0xFF0B8DCD),
                                        borderRadius:
                                        BorderRadius.circular(5))),
                                    child: Center(
                                        child: Text(
                                          status!.toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ))),
                              ),
                            ):status=="Exchange"?
                           Positioned(
                             top: -0.10,
                             left: 20,
                             child: Align(
                               alignment: Alignment.topLeft,
                               child: Container(
                                   height: 25,
                                   width: 120,
                                   decoration: (BoxDecoration(
                                       color: Color(0xFFFFBC70),
                                       borderRadius:
                                       BorderRadius.circular(5))),
                                   child: Center(
                                       child: Text(
                                         status!.toUpperCase(),
                                         style: TextStyle(color: Colors.black),
                                       ))),
                             ),
                           ):
                           Positioned(
                             top: -0.10,
                             left: 20,
                             child: Align(
                               alignment: Alignment.topLeft,
                               child: Container(
                                   height: 25,
                                   width: 120,
                                   decoration: (BoxDecoration(
                                       color: Color(0xFFFFC5FB),
                                       borderRadius:
                                       BorderRadius.circular(5))),
                                   child: Center(
                                       child: Text(
                                         status==null?"":status!.toUpperCase(),
                                         style: TextStyle(color: Colors.black),
                                       ))),
                             ),
                           )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
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
              initialOffset: const Offset(300, 32),
              //parentKey: _parentKey,
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
              },
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height/1,
            //     width: MediaQuery.of(context).size.width/1,
            //     child: MatrixGestureDetector(
            //       onMatrixUpdate: (m, tm, sm, rm) {
            //         notifier.value = m;
            //       },
            //       child: AnimatedBuilder(
            //         animation: notifier,
            //         builder: (ctx, child) {
            //           return Stack(
            //             children: [
            //               Container(
            //                 height: MediaQuery.of(context).size.width,
            //                 width: MediaQuery.of(context)
            //                     .size
            //                     .width,
            //               ),
            //               Positioned(
            //                 child: InkWell(
            //                   onTap:(){
            //                     Navigator.pushReplacement(
            //                         context, MaterialPageRoute(builder: (context) => GoogleMapScreen()));
            //                   },
            //                   child: Container(
            //                     height: 50,
            //                     width:50,
            //                     transform: notifier.value,
            //                     decoration: (BoxDecoration(color: Color(0xFFFFCE55),shape: BoxShape.circle)),
            //                     child: Center(child: Icon(LineAwesomeIcons.home,color: Colors.white,)),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      )
      // body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   color: AppColors.white,
      //   child: SingleChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 25,right: 25),
      //       child: Column(
      //         children: [
      //           Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(5.0),
      //             ),
      //             color: Colors.white,
      //             child: Padding(
      //               padding: const EdgeInsets.only(left: 15,right: 15),
      //               child: Column(
      //                 children: [
      //                   SizedBox(height: 20,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                     Text("Customer Name:",style: TextStyle(color: Colors.black.withOpacity(0.5)),),
      //                     Text("James Harry",style: TextStyle(color: Colors.black.withOpacity(0.7)),),
      //                   ],),
      //                   SizedBox(height: 10,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text("Product Name:",style: TextStyle(color: Colors.black.withOpacity(0.5)),),
      //                       Text("Chair",style: TextStyle(color: Colors.black.withOpacity(0.7)),),
      //                     ],),
      //                   SizedBox(height: 10,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text("Quantity:",style: TextStyle(color: Colors.black.withOpacity(0.5)),),
      //                       Text("3",style: TextStyle(color: Colors.black.withOpacity(0.7)),),
      //                     ],),
      //                   SizedBox(height: 10,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text("Product Details:",style: TextStyle(color: Colors.black.withOpacity(0.5)),),
      //                       Text("Furniture",style: TextStyle(color: Colors.black.withOpacity(0.7)),),
      //                     ],),
      //                   SizedBox(height: 10,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text("Customer Number:",style: TextStyle(color: Colors.black.withOpacity(0.5)),),
      //                       Text("0117-332-7800",style: TextStyle(color: Colors.black.withOpacity(0.7)),),
      //                     ],),
      //                   SizedBox(height: 10,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Expanded(
      //                           flex:5,
      //                           child: Text("Address:",style: TextStyle(color: Colors.black.withOpacity(0.5)),)),
      //                       Expanded(
      //                           flex: 4,
      //                           child: Text("Whitechapel, Stepney London, UK - 400706 ",style: TextStyle(color: Colors.black.withOpacity(0.7)),)),
      //                     ],),
      //                   SizedBox(height: 20,)
      //                 ],
      //               ),
      //             ),
      //           ),
      //           SizedBox(height: 20,),
      //           Card(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(5.0),
      //             ),
      //             color: Colors.white,
      //             child: Padding(
      //               padding: const EdgeInsets.only(left: 15,right: 15),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                  SizedBox(height: 20,),
      //                   Text("Delivery Completed?",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),),
      //                   SizedBox(height: 25,),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Expanded(
      //                         flex:3,
      //                         child: InkWell(
      //                           onTap:(){
      //                             setState(() {
      //                               deliveryStatus=1;
      //                             });
      //                           },
      //                           child: Container(
      //                             height:40,
      //                             decoration: BoxDecoration(color: deliveryStatus==1?AppColors.lightblue:Colors.white,
      //                                 border: Border.all(color:AppColors.lightblue),
      //
      //                                 borderRadius: BorderRadius.all(Radius.circular(5))),
      //                             child: Center(child: Text("Delivered",style: TextStyle(fontSize: 13,color:deliveryStatus==1? Colors.white:AppColors.lightblue),)),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 8,),
      //                       Expanded(
      //                         flex:3,
      //                         child: InkWell(
      //                           onTap:(){
      //                             setState(() {
      //                               deliveryStatus=2;
      //                             });
      //                           },
      //                           child: Container(
      //                             height:40,
      //                             decoration: BoxDecoration(color: deliveryStatus==2?AppColors.lightblue:Colors.white,
      //                                 border: Border.all(color:AppColors.lightblue),
      //
      //                                 borderRadius: BorderRadius.all(Radius.circular(5))),
      //                             child: Center(child: Text("Not-Delivered",style: TextStyle(fontSize: 13,color:deliveryStatus==2? Colors.white:AppColors.lightblue),)),
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 8,),
      //                       Expanded(
      //                         flex:3,
      //                         child:InkWell(
      //                           onTap:(){
      //                             setState(() {
      //                               deliveryStatus=3;
      //                             });
      //                           },
      //                           child: Container(
      //                             height:40,
      //                             decoration: BoxDecoration(color: deliveryStatus==3?AppColors.lightblue:Colors.white,
      //                                 border: Border.all(color:AppColors.lightblue),
      //
      //                                 borderRadius: BorderRadius.all(Radius.circular(5))),
      //                             child: Center(child: Text("Return",style: TextStyle(fontSize: 13,color:deliveryStatus==3? Colors.white:AppColors.lightblue),)),
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 50,),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           SizedBox(height: 20,),
      //           deliveryStatus==1?deliveryData():Container(),
      //           deliveryStatus==2?notDeliveryData():Container(),
      //           deliveryStatus==3?returnData():Container(),
      //           SizedBox(height: 30,),
      //
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget deliveryData() {
    // setState(() {
    //   onClick=true;
    // });
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(
                fontSize: 16, color: AppColors.lightblue.withOpacity(0.6)),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImages();
              // _showPicker(context);
              // setState(() {
              //   deliveryStatus = 1;
              // });
            },
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.lightblue,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          images.length != 0
              ? Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    physics: ScrollPhysics(),
                    children: List.generate(images.length, (index) {
                      Asset asset = images[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 100,
                            height: 100,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                LineAwesomeIcons.times_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Add signature",
            style: TextStyle(
                fontSize: 16, color: AppColors.lightblue.withOpacity(0.6)),
          ),
          SizedBox(
            height: 10,
          ),
          Signature(
            controller: _controller,
            height: 120,
            backgroundColor: Colors.white,
          ),
          // Container(
          //   height: 120,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //       border: Border.all(color: Color(0xFFB9CCDD)),
          //       borderRadius: BorderRadius.circular(6)),
          // ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async {
                   setState(() {
                     print(productlist.length);
                     if (images.length == 0) {
                       buildSnackbar("Please add Images");
                     }else {
                       storeSubmited(productId, Order_No);
                     }
                   });

                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );

  }

  void storeSubmited(String? product_id,String? order_id) async {

    setState(() {
      isLoading=true;
    });
    HttpHelper.setData(product_id,order_id,selectDeliveryStatus).then((response) async {
      print(response.body);

      setState(() {
        getListProduct(order_id);
        //List status=selectDeliveryStatus as List;

        productId="";
       images.clear();
       notDeliveredImages .clear();
       returnImages.clear();
       collectedImages.clear();
         exchangeImages.clear();
         notCollectedImages.clear();
         isLoading=false;
        _controller.clear();
        _chosenValue="Please select value";
        _chosenValueReturn="Please select value";
        _chosenValueCollected="Please select value";
        //selectDeliveryStatus="Please select value";

        list.clear();

      });



    });
  }
  void getListProduct(String? order_id){
    HttpHelper.getProductList(order_id).then((response) async {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      List data = user['data'];
      print(data) ;
      List<ProductListModel> tagObjs = data.map((tagJson) => ProductListModel.fromJson(tagJson)).toList();
      setState(() {
        arrayList=data;
        p_id=tagObjs;
        if(productlist.length==tagObjs.length){
          print("It is okay");
          getFrameUpdate();
        }else{
          print("It is  not okay");

        }
      });

      setState(() {
       // p_id =data;
       //  print("fwfsd$p_id");
       //  print("p_id$p_id");

      });
    });
  }

  // _imgFromCamera() async {
  //   if (deliveryStatus == 1) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.camera, imageQuality: 80);
  //     setState(() {
  //       image = File(pickedFile.path);
  //       print(image);
  //     });
  //   } else if (deliveryStatus == 2) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.camera, imageQuality: 80);
  //
  //     setState(() {
  //       notDeliveredImage = File(pickedFile.path);
  //     });
  //   } else if (deliveryStatus == 3) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.camera, imageQuality: 80);
  //
  //     setState(() {
  //       returnImage = File(pickedFile.path);
  //     });
  //   }
  // }
  //
  // _imgFromGallery() async {
  //   if (deliveryStatus == 1) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
  //     setState(() {
  //       image = File(pickedFile.path);
  //       print(image);
  //     });
  //   } else if (deliveryStatus == 2) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
  //
  //     setState(() {
  //       notDeliveredImage = File(pickedFile.path);
  //     });
  //   } else if (deliveryStatus == 3) {
  //     final pickedFile =
  //         await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
  //
  //     setState(() {
  //       returnImage = File(pickedFile.path);
  //     });
  //   }
  // }
  //
  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: new Wrap(
  //               children: <Widget>[
  //                 new ListTile(
  //                     leading: new Icon(Icons.photo_library),
  //                     title: new Text('Photo Library'),
  //                     onTap: () {
  //                       _imgFromGallery();
  //                       Navigator.of(context).pop();
  //                     }),
  //                 new ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     _imgFromCamera();
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget notDeliveryData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(fontSize: 16, color: AppColors.lightblue),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImagesNotDeliveredData();
              setState(() {
                deliveryStatus = 2;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              child: Icon(Icons.add_a_photo_outlined),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          notDeliveredImages.length != 0
              ? Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    physics: ScrollPhysics(),
                    children: List.generate(notDeliveredImages.length, (index) {
                      Asset asset = notDeliveredImages[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 100,
                            height: 100,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                notDeliveredImages.removeAt(index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                LineAwesomeIcons.times_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose reason",
                  style: TextStyle(fontSize: 16, color: AppColors.lightblue),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFd9e6ef), width: 1),
                      borderRadius: BorderRadius.circular(13)),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValue,
                    isExpanded: true,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    underline: SizedBox(),
                    items: itemsNotDelivered
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose your reason",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ),
                _chosenValue == "Others"
                    ? Container(
                        child: TextField(
                          controller: notDeliveredControllar,
                          decoration: InputDecoration(labelText: 'Please add Reason'),
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 3,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async{
                    setState(() {
                      if (notDeliveredImages.length == 0) {
                        buildSnackbar("Please add Images");
                      } else if (_chosenValue == null) {
                        buildSnackbar("Please add Reason");
                      }else if(_chosenValue== "Please select value"){
                        buildSnackbar("Please add  valid Reason");
                      }else if(_chosenValue=="Others") {
                        if(notDeliveredControllar.text.isEmpty) {
                          buildSnackbar("Please add your Other Reason");
                        }
                      }
                      else {
                        storeSubmited(productId, Order_No);

                      }
                    });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  buildSnackbar(String message) {
    //_scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("")));
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black));
  }

  Widget returnData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(fontSize: 16, color: AppColors.lightblue),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImagesReturnData();
              setState(() {
                deliveryStatus = 3;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              child: Icon(Icons.add_a_photo_outlined),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          returnImages.length != 0
              ? Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    physics: ScrollPhysics(),
                    children: List.generate(returnImages.length, (index) {
                      Asset asset = returnImages[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 100,
                            height: 100,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                returnImages.removeAt(index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                LineAwesomeIcons.times_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose reason",
                  style: TextStyle(fontSize: 16, color: AppColors.lightblue),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFd9e6ef), width: 1),
                      borderRadius: BorderRadius.circular(13)),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValueReturn,
                    isExpanded: true,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    underline: SizedBox(),
                    items: itemsReturn
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose your reason",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenValueReturn = value;
                      });
                    },
                  ),
                ),
                _chosenValueReturn == "Others"
                    ? Container(
                        child: TextField(
                          controller: returnControllar,
                          decoration:
                              InputDecoration(labelText: 'Please add Reason'),
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 5, // when user presses enter it will adapt to it
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async{
                    setState(() {
                      if (_chosenValueReturn == null) {
                        buildSnackbar("Please add Reason");
                      }else if(_chosenValueReturn== "Please select value"){
                        buildSnackbar("Please add  valid Reason");
                      }else if(_chosenValueReturn=="Others"){
                        if (returnControllar.text.isEmpty) {
                          buildSnackbar("Please add your Other Reason");
                        }
                      }else {
                        storeSubmited(productId, Order_No);

                      }
                    });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget collectedData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(fontSize: 16, color: AppColors.lightblue),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImagesCollectedData();
              setState(() {
                deliveryStatus = 3;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              child: Icon(Icons.add_a_photo_outlined),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          collectedImages.length != 0
              ? Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    physics: ScrollPhysics(),
                    children: List.generate(collectedImages.length, (index) {
                      Asset asset = collectedImages[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 100,
                            height: 100,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                collectedImages.removeAt(index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                LineAwesomeIcons.times_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async{
                    if (collectedImages.length == 0) {
                      buildSnackbar("Please add Images");
                    } else {
                      storeSubmited(productId, Order_No);
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
  Widget exchangeData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(fontSize: 16, color: AppColors.lightblue),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImagesExchangeData();
              setState(() {
                deliveryStatus = 3;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              child: Icon(Icons.add_a_photo_outlined),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          exchangeImages.length != 0
              ? Container(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 8,
              physics: ScrollPhysics(),
              children: List.generate(exchangeImages.length, (index) {
                Asset asset = exchangeImages[index];
                return Stack(
                  children: [
                    AssetThumb(
                      asset: asset,
                      width: 100,
                      height: 100,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          exchangeImages.removeAt(index);
                        });
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          LineAwesomeIcons.times_circle,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async{
                    setState(() {
                      if (exchangeImages.length == 0) {
                        buildSnackbar("Please add Images");
                      } else {
                        storeSubmited(productId, Order_No);


                      }
                    });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget notCollectedData() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add challan picture",
            style: TextStyle(fontSize: 16, color: AppColors.lightblue),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              pickImagesNotCollectedData();
              setState(() {
                deliveryStatus = 3;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              child: Icon(Icons.add_a_photo_outlined),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Color(0xFFd9e6ef),
                    width: 1,
                  )),
            ),
          ),
          notCollectedImages.length != 0
              ? Container(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    physics: ScrollPhysics(),
                    children: List.generate(notCollectedImages.length, (index) {
                      Asset asset = notCollectedImages[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: asset,
                            width: 100,
                            height: 100,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                notCollectedImages.removeAt(index);
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                LineAwesomeIcons.times_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose reason",
                  style: TextStyle(fontSize: 16, color: AppColors.lightblue),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFd9e6ef), width: 1),
                      borderRadius: BorderRadius.circular(13)),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: _chosenValueCollected,
                    isExpanded: true,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    underline: SizedBox(),
                    items: itemsNotCollected
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose your reason",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenValueCollected = value;
                      });
                    },
                  ),
                ),
                _chosenValueCollected == "Others"
                    ? Container(
                  child: TextField(
                    decoration:
                    InputDecoration(labelText: 'Please add Reason'),
                    controller: notCollectedControllar,
                    keyboardType: TextInputType.text,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines:
                    5, // when user presses enter it will adapt to it
                  ),
                )
                    : Container(),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: FlatButton(
                  onPressed: () async{
                    setState(() {
                      if (notCollectedImages.length == 0) {
                        buildSnackbar("Please add Images");
                      }else if (_chosenValueCollected == null) {
                        buildSnackbar("Please add Reason");
                      }else if(_chosenValueCollected== "Please select value"){
                        buildSnackbar("Please add  valid Reason");
                      }else if (_chosenValueCollected == "Others" && notCollectedControllar.text.isEmpty) {
                        buildSnackbar("Please add your Other Reason");
                      } else {
                        storeSubmited(productId, Order_No);

                      }
                    });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
  void getFrame() async {
    String idddd=widget.id.toString();
    setState(() {
      isLoading=true;
    });
    HttpHelper.getIndividualData(idddd).then((response) async {

      Map<String, dynamic> user = jsonDecode(response.body);
      var data = user['data'][0];
      var status=data["status"];
      var Order_No=data["Order_No"];
      var Address=data["Address"];
      var postalCode=data["postalCode"];
      var PhoneNumber=data["PhoneNumber"];
      var MobileNumber=data["mobileNumber"];
      var delivery_status=data["delivery_status"];
      var type_of_delivery=data["type_of_delivery"];
      var data1= data['product_details'] as List;

      List<ProductDataModel> tagObjs = data1.map((tagJson) => ProductDataModel.fromJson(tagJson)).toList();
      setState(() {
        isLoading=false;
                this.status=status;
                this.Order_No=Order_No;
                this.Address=Address;
                this.postalCode=postalCode;
                this.PhoneNumber =PhoneNumber;
                this.mobileNumber =MobileNumber;
                this.type_of_delivery =type_of_delivery;
                this.delivery_status=delivery_status;
                  productlist = tagObjs;
                  print(productlist.length);

      });

    });
  }
  void getFrameUpdate() async {
    String? idddd=widget.id.toString();
   // int finalid=widget.id;
    setState(() {
      isLoading=true;
    });
    HttpHelper.getUpdateData(idddd).then((response) async {

      Map<String, dynamic> user = jsonDecode(response.body);
      setState(() {
        isLoading=false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LiveTrackingScreen(id:widget.id)));


      });

    });
  }

}
// Widget returnData() {
//   return Padding(
//     padding: const EdgeInsets.only(left: 5, right: 5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 15,
//         ),
//         Text(
//           "Add challan picture",
//           style: TextStyle(fontSize: 16, color: AppColors.lightblue),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         InkWell(
//           onTap: () {
//            pickImagesReturnData();
//             setState(() {
//               deliveryStatus = 3;
//             });
//           },
//           child: Container(
//             width: 80,
//             height: 80,
//             child:  Icon(
//                     Icons.add_a_photo_outlined,
//                     color: AppColors.lightblue,
//                   ),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//                 border: Border.all(
//                   color: Color(0xFFd9e6ef),
//                   width: 1,
//                 )),
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//     returnImages.length!=null?
//     Container(
//       child: GridView.count(
//         crossAxisCount: 3,
//         crossAxisSpacing: 5,
//         physics:ScrollPhysics() ,
//         children: List.generate(returnImages.length, (index) {
//           Asset asset = returnImages[index];
//           return AssetThumb(
//             asset: asset,
//             width: 100,
//             height: 100,
//           );
//         }),
//       ),
//     ):Container(),
//         Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Choose reason",
//                 style: TextStyle(fontSize: 16, color: AppColors.lightblue),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFd9e6ef), width: 1),
//                     borderRadius: BorderRadius.circular(13)),
//                 child: DropdownButton<String>(
//                   focusColor: Colors.white,
//                   value: _chosenValueReturn,
//                   isExpanded: true,
//                   //elevation: 5,
//                   style: TextStyle(color: Colors.white),
//                   iconEnabledColor: Colors.black,
//                   underline: SizedBox(),
//                   items: itemsReturn
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(
//                         value,
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     );
//                   }).toList(),
//                   hint: Text(
//                     "Please choose your reason",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   onChanged: (String value) {
//                     setState(() {
//                       _chosenValueReturn = value;
//                     });
//                   },
//                 ),
//               ),
//               _chosenValueReturn == "Others"
//                   ? Container(
//                       child: TextField(
//                         decoration:
//                             InputDecoration(labelText: 'Please add Reason'),
//                         keyboardType: TextInputType.text,
//                         minLines:
//                             1, //Normal textInputField will be displayed
//                         maxLines:
//                             5, // when user presses enter it will adapt to it
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             height: 40,
//             width: 120,
//             decoration: BoxDecoration(
//                 color: AppColors.lightblue,
//                 borderRadius: BorderRadius.all(Radius.circular(50))),
//             child: FlatButton(
//                 onPressed: null,
//                 child: Text(
//                   "Submit",
//                   style: TextStyle(color: Colors.white),
//                 )),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         )
//       ],
//     ),
//   );
// }