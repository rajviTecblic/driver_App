import 'dart:convert';

import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:driver/commonFiles/HttpHelper.dart';
import 'package:driver/commonFiles/ProgressWidget.dart';
import 'package:driver/model/DeliveryDataModel.dart';
import 'package:driver/model/SummaryModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
enum warehouseType { Warehouse1, Warehouse2, Warehouse3 }

class ListDelivery extends StatefulWidget {
  const ListDelivery({Key? key}) : super(key: key);

  @override
  _ListDeliveryState createState() => _ListDeliveryState();
}

class _ListDeliveryState extends State<ListDelivery>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool selectedItem=false;
  bool isLoading=false;
  bool isChecked=false;
  List<SummaryModel> summaryList = [];
  warehouseType _site = warehouseType.Warehouse1;
  String? warehouseString;
  var unsuccessfulList=[];
  var preunsuccessfulList=[];
  List<String> items=['Warehouse1',
    'Warehouse2',
    'Warehouse3'];
  // List<DeliveryDataModel> deliveryList = [
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  //   DeliveryDataModel(
  //       customerName: "Robert Jame",
  //       customerMobile: "456709",
  //       productName: "Rauch Rivera Wardrobe",
  //       productQuantity: "3",
  //       city: "London",isSelected: false),
  // ];
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Successful'),
    Tab(text: 'Unsuccessful'),
  ];

  @override
  void initState() {
    super.initState();
    getFrame();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 17,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Color(0xFFF5F5F5),
          title: Text(
            "Summary",
            style: TextStyle(fontSize: 17, color: Colors.black),
          )),
      // body: Container(
      //   color: AppColors.white,
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   child: ListView.builder(
      //       shrinkWrap: true,
      //       itemCount: deliveryList.length,
      //       itemBuilder: (context,index){
      //     return Padding(
      //       padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      //       child: Card(
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(deliveryList[index].customerName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
      //                   Text(deliveryList[index].city,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
      //                 ],
      //               ),
      //               SizedBox(height: 5,),
      //               Text(deliveryList[index].customerMobile,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
      //               SizedBox(height: 5,),
      //               Text("Product name: ${deliveryList[index].productName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
      //               SizedBox(height: 5,),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text("Quantity: ${deliveryList[index].productQuantity}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
      //                   Text("Successful",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.green),),
      //                 ],
      //               ),
      //               SizedBox(height: 20,),
      //             ],
      //           ),
      //         ),
      //       ),
      //     );
      //   }),
      // ),
      body: ProgressWidget(
        isShow: isLoading,
        child: Container(
          color: Color(0xFFF5F5F5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 100),
                  child: TabBar(
                    controller: _tabController,
                    tabs: myTabs,
                    labelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Container(
                  //height: MediaQuery.of(context).size.height / 1.4,
                  child: TabBarView(controller: _tabController, children: [
                    successfulData(),
                    unSuccessfulData(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget successfulData() {
    return ListView.builder(
    itemCount: summaryList.length,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
          child:ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              for(var i = 0; i < summaryList[index].product_details.length; i++)
                summaryList[index].product_details[i].status=="Delivered" ||
                    summaryList[index].product_details[i].status=="Exchanged" ||
                    summaryList[index].product_details[i].status=="Collected"?
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Color(0xFF06ad84).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16,right: 16,top: 22,bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(summaryList[index].order_id!,style: TextStyle(color: Colors.black,fontSize: 18),),
                                    Text(summaryList[index].product_details[i].status!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                  ],
                                ),
                                Text(summaryList[index].PhoneNumber!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                Text("28/07/2021, 07:41 AM",style: TextStyle(color: Colors.black,fontSize: 14),),
                                SizedBox(height: 12,),
                                Text("Product name:",style: TextStyle(color: Color(0xFF777777),fontSize: 16),),
                                Text(summaryList[index].product_details[i].product_name!,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("No of Boxes:${summaryList[index].product_details[i].no_of_Box}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                    Text("${summaryList[index].product_details[i].pro_qty} Qty",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Text("Location:",style: TextStyle(color: Color(0xFF777777),fontSize: 16),),
                                Text(summaryList[index].Address!,style: TextStyle(color: Colors.black,fontSize: 16),),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                    Positioned(
                      top: -10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 18,width: 70,
                            decoration: BoxDecoration(color: Color(0xFF06ad84),borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Text("SUCCESS",style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      ),
                    ),

                  ],
                ):Container()

            ],
          )
        );
      },
    );
  }

  Widget unSuccessfulData() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,

              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  for(var index = 0; index < summaryList.length; index++){
                    for(var i = 0; i < summaryList[index].product_details.length; i++){
                      if(isChecked==true){
                        summaryList[index].product_details[i].isSelected=true;
                        unsuccessfulList.add(summaryList[index].product_details[i].pid);
                        if(!preunsuccessfulList.contains(summaryList[index].product_details[i].pid)){


                          preunsuccessfulList.add(summaryList[index].product_details[i].pid);
                          print(unsuccessfulList);
                          print("dcd$preunsuccessfulList");
                        }


                      }else{
                        summaryList[index].product_details[i].isSelected=false;
                        unsuccessfulList.remove(summaryList[index].product_details[i].pid);
                        preunsuccessfulList.remove(summaryList[index].product_details[i].pid);
                      }
                    }


                  }
                });
              },
            ),
            Text("Select all",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          ],
        ),
       // SizedBox(height: 20,),
        Expanded(
          flex: 11,
          child: ListView.builder(
            itemCount: summaryList.length,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {

              for(var i = 0; i < summaryList[index].product_details.length; i++){
                if(summaryList[index].product_details[i].status=="Not Delivered" ||
                    summaryList[index].product_details[i].status=="Not Exchanged" ||
                    summaryList[index].product_details[i].status=="Not Collected" ||
                    summaryList[index].product_details[i].status=="Return" ||
                    summaryList[index].product_details[i].status=="Not deliverd"){
                    if(!preunsuccessfulList.contains(summaryList[index].product_details[i].pid)){
                      preunsuccessfulList.add(summaryList[index].product_details[i].pid);
                      print(preunsuccessfulList);
                      // setState(() {
                      //   if(isChecked==false){
                      //     preunsuccessfulList.add(summaryList[index].product_details[i].pid);
                      //     print(preunsuccessfulList);
                      //   }else if(isChecked==true){
                      //     preunsuccessfulList.remove(summaryList[index].product_details[i].pid);
                      //   }
                      // });

                    }

                }
              }

              return Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                child:ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  children: [
                    for(var i = 0; i < summaryList[index].product_details.length; i++)
                      summaryList[index].product_details[i].status=="Not Delivered" ||
                          summaryList[index].product_details[i].status=="Not Exchanged" ||
                          summaryList[index].product_details[i].status=="Not Collected" ||
                          summaryList[index].product_details[i].status=="Return" ||
                          summaryList[index].product_details[i].status=="Not deliverd"?

                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topLeft,
                        children: [
                          InkWell(
                            onTap: (){


                              setState(() {
                                if (summaryList[index].product_details[i].isSelected!) {
                                  summaryList[index].product_details[i].isSelected=false;
                                  summaryList[index].product_details[i].mycolor=Colors.red;
                                  unsuccessfulList.remove(int.parse(summaryList[index].product_details[i].pid!));




                                  selectedItem = false;
                                }
                                else {
                                  summaryList[index].product_details[i].isSelected=true;
                                  summaryList[index].product_details[i].mycolor=Colors.blue;
                                  if(!unsuccessfulList.contains(summaryList[index].product_details[i].pid)){
                                    unsuccessfulList.add(summaryList[index].product_details[i].pid);
                                    print(unsuccessfulList);

                                  }


                                  //mycolor=Colors.grey[300];
                                  selectedItem = true;
                                }
                              });

                            },
                            child: Column(
                              children: [
                                Container(

                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: summaryList[index].product_details[i].isSelected==false?Color(0xFFd21629).withOpacity(0.1):AppColors.lightblue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16,right: 16,top: 22,bottom: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        summaryList[index].product_details[i].isSelected==true? Align(
                                            alignment:Alignment.topRight,
                                            child: Icon(LineAwesomeIcons.check_circle,color: AppColors.lightblue,)):Container(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(summaryList[index].order_id!,style: TextStyle(color: Colors.black,fontSize: 18),),
                                            Text(summaryList[index].product_details[i].status!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                          ],
                                        ),
                                        Text(summaryList[index].PhoneNumber!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                        Text("28/07/2021, 07:41 AM",style: TextStyle(color: Colors.black,fontSize: 14),),
                                        SizedBox(height: 12,),
                                        Text("Product name:",style: TextStyle(color: Color(0xFF777777),fontSize: 16),),
                                        Text(summaryList[index].product_details[i].product_name!,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("No of Boxes:${summaryList[index].product_details[i].no_of_Box}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                            Text("${summaryList[index].product_details[i].pro_qty} Qty",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Text("Location:",style: TextStyle(color: Color(0xFF777777),fontSize: 16),),
                                        Text(summaryList[index].Address!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                        // Checkbox(
                                        //   value:  summaryList[index].isSelected,
                                        //   onChanged: (bool value) {
                                        //     setState(() {
                                        //       print(summaryList[index].order_id);
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),

                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  height: 18,width: 70,
                                  decoration: BoxDecoration(color: Color(0xFFd21629),borderRadius: BorderRadius.circular(5)),
                                  child: Center(child: Text("PENDING",style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ):Container()
                  ],
                )
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: compareArrays(preunsuccessfulList,unsuccessfulList)?AppColors.lightblue:Colors.grey),
            child: FlatButton(
              onPressed: (){
                // unsuccessfulList.where((item){
                //   preunsuccessfulList.contains(item.id);
                // });

                if(compareArrays(preunsuccessfulList,unsuccessfulList)){

                    showDialog(context: context, builder: (context) =>  SimpleDialog(
                      contentPadding: EdgeInsets.all(0),

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),side: BorderSide(color: Color(0xFFD9E6EF),width: 2)),
                      children: <Widget>[
                        StatefulBuilder(builder: (context,setState){
                          return   Column(
                            children: <Widget>[
                              SizedBox(
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                  child: Column(
                                    children: [
                                      Text("Please Select Warehouse",style: TextStyle(fontSize: 18),),
                                      ListTile(
                                        title: Text("Warehouser1"),
                                        leading: Radio(
                                          value: warehouseType.Warehouse1,
                                          groupValue: _site,
                                          onChanged: (warehouseType? value) {
                                            setState(() {
                                              _site = value!;
                                              warehouseString=warehouseType.Warehouse1.toString();
                                              print(warehouseString);
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text("Warehouser2"),
                                        leading: Radio(
                                          value: warehouseType.Warehouse2,
                                          groupValue: _site,
                                          onChanged: (warehouseType? value) {
                                            setState(() {
                                              _site = value!;
                                              warehouseString=warehouseType.Warehouse1.toString();
                                              print(warehouseString);
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text("Warehouser3"),
                                        leading: Radio(
                                          value: warehouseType.Warehouse3,
                                          groupValue: _site,
                                          onChanged: (warehouseType? value) {
                                            setState(() {
                                              _site = value!;
                                              warehouseString=warehouseType.Warehouse1.toString();
                                              print(warehouseString);
                                            });
                                          },
                                        ),
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
                                        if(warehouseString==null){
                                          warehouseString=warehouseType.Warehouse1.toString();
                                          print(warehouseString);
                                        }else{
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => GoogleMapScreen(warehouse: warehouseString,)));
                                        }

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
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) =>
                    //         StatefulBuilder(builder: (context,setState){
                    //           return   Dialog(
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(4.0)
                    //               ),
                    //               child: Stack(
                    //                 overflow: Overflow.visible,
                    //                 alignment: Alignment.topCenter,
                    //                 children: [
                    //                   Container(
                    //                     height: 220,
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
                    //                       child: Column(
                    //                         children: [
                    //                           Text('Please select Warehouse', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    //                           SizedBox(height: 5,),
                    //                           DropdownButton<String>(
                    //                             focusColor:Colors.white,
                    //                             value: _chosenValue,
                    //                             //elevation: 5,
                    //                             style: TextStyle(color: Colors.white),
                    //                             iconEnabledColor:Colors.black,
                    //                             underline: SizedBox(),
                    //                             items: items.map<DropdownMenuItem<String>>((String value) {
                    //                               return DropdownMenuItem<String>(
                    //                                 value: value,
                    //                                 child: Text(value,style:TextStyle(color:Colors.black),),
                    //                               );
                    //                             }).toList(),
                    //                             hint:Text(
                    //                               "Please Select Warehouse",
                    //                               style: TextStyle(
                    //                                   color: Colors.black,
                    //                                   fontSize: 14,
                    //                                   fontWeight: FontWeight.w500),
                    //                             ),
                    //                             onChanged: (String value) {
                    //                               setState(() =>_chosenValue = value);
                    //                               // setState(() {
                    //                               //
                    //                               // });
                    //                             },
                    //                           ),
                    //                           SizedBox(height: 10,),
                    //                           RaisedButton(onPressed: () {
                    //                             Navigator.pushReplacement(
                    //                               context,
                    //                               MaterialPageRoute(builder: (context) => GoogleMapScreen()),
                    //                             );
                    //                           },
                    //                             color: Color(0xFFce312d),
                    //                             child: Text('Submit', style: TextStyle(color: Colors.white),),
                    //                           )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                       top: -40,
                    //                       child: CircleAvatar(
                    //                         backgroundColor: Color(0xFFce312d),
                    //                         radius: 40,
                    //                         child: Icon(Icons.camera, color: Colors.white, size: 40,),
                    //                       )
                    //                   ),
                    //                 ],
                    //               )
                    //           );
                    //         })
                    //
                    // );

                }else{
                  print("error---------------------");
                  final snackBar = SnackBar(content: Text('Please Select all Unsuccessfull Delivery'));
                  Scaffold.of(context).showSnackBar(SnackBar(content: snackBar));
                 // _scaffoldKey.currentState.showSnackBar(snackBar);
                }

              },
              child: Text(
                "RETURN TO WAREHOUSE",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
  bool compareArrays(List array1, List array2) {

    if (array1.length == array2.length) {
      return array1.every( (value) => array2.contains(value) );
    } else {
      return false;
    }
  }
  void getFrame() async {
    setState(() {
      isLoading=true;
    });
    HttpHelper.getSummaryData().then((response) async {

      Map<String, dynamic> user = jsonDecode(response.body);
      var data = user['data'] as List;
      print("data");

      List<SummaryModel> tagObjs = data.map((tagJson) => SummaryModel.fromJson(tagJson)).toList();
      setState(() {

        isLoading=false;
        summaryList=tagObjs;

      });

    });
  }
}
