import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:driver/commonFiles/AppColors.dart';
import 'package:driver/commonFiles/HttpHelper.dart';
import 'package:driver/model/CustomerDataModel.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ShadowScreen extends StatefulWidget {
  @override
  _ShadowScreenState createState() => _ShadowScreenState();
}

class _ShadowScreenState extends State<ShadowScreen> {

  List<CustomerDataModel?> list = [];
  bool onClick = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFrameList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CarouselSlider.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context,int i,int pageViewIndex){
        return Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 30,top: 50),
              child: Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.all(30),
               // height:onClick==true?455: 240,
                width:double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), //border corner radius
                  boxShadow:[
                    BoxShadow(
                      color: Color(0xFF003145).withOpacity(0.1),
                      blurRadius: 30, // blur radius
                      offset: Offset(0, 10),

                    ),
                    //you can set more BoxShadow() here
                  ],
                ),
                child:
                    Container(
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          InkWell(
                            onTap:(){
                              setState(() {
                                if(list[i]!.delivery_status=="1"){

                                }else{
                                  //setTimer(int.parse(list[i].customer_id));
                                }

                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15,right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 5,),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text("${i+1}/${list.length}",style: TextStyle(color: Colors.black,fontSize: 17),)),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(list[i]!.Order_No!,style: TextStyle(fontSize: 17),),
                                          Text("27/08/2021",style: TextStyle(fontSize: 14),),
                                        ],
                                      ),
                                      Container(
                                        height: 29,width: 29,
                                        decoration: BoxDecoration(shape: BoxShape.circle,color: Color(0xFF4EC0E8)),
                                        child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                //launch("tel://7567074977");
                                              });
                                            },
                                            child: Icon(LineAwesomeIcons.phone,color: Colors.white,size: 16,)),
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 13,),
                                  Text("Ethan Will",style: TextStyle(fontSize: 14),),
                                  //SizedBox(height: 2,),
                                  Text(list[i]!.Address!,
                                    maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14),),
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
                                  //s SizedBox(height: 5,),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        print("object");
                                        onClick=true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("P. ${list[i]!.PhoneNumber}"),
                                        onClick==false?Icon(Icons.keyboard_arrow_down):Text("01:00 PM",style: TextStyle(color: AppColors.lightblue),)
                                      ],
                                    ),
                                  ),

                                  onClick == true
                                      ? SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 1,
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                          color: Colors.grey
                                              .withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
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
                                            Text("No of boxes:"
                                                "4",
                                                style: TextStyle(
                                                    color:
                                                    Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                )),
                                            Text("04 Qty",
                                                style: TextStyle(
                                                  color:
                                                  Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
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
                                            Text("No of boxes:"
                                                "4",
                                                style: TextStyle(
                                                    color:
                                                    Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                )),
                                            Text("04 Qty",
                                                style: TextStyle(
                                                  color:
                                                  Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "4Kids 3ft Storage Bed with Opalino Handles Light Oak and White High Gloss",
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
                                            Text("No of boxes:"
                                                "4",
                                                style: TextStyle(
                                                    color:
                                                    Color(0xFF433F3D),fontWeight: FontWeight.bold,fontSize: 16
                                                )),
                                            Text("04 Qty",
                                                style: TextStyle(
                                                  color:
                                                  Color(0xFF433F3D),fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
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
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),



                        ],
                      ),
                    )

                  ),
                ),


            Positioned(
              top: 40,
              left: 50,
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
                          "Delivery",
                          style: TextStyle(color: Colors.white),
                        ))),
              ),
            )
          ],
        );
      }, options: CarouselOptions(
        // initialPage:widget.id==null?0: widget.id,
          onPageChanged: ( index,reason){
            setState(() {
              //changeIndex=index;
            });
          },
          reverse: false,autoPlay: false,enlargeCenterPage: true, viewportFraction: 1.0,height:onClick==true?475:250 ),)
    );
  }
  void getFrameList() async {
    setState(() {
      //isLoading = true;
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
        //isLoading = false;
        list = tagObjs;
      });
    });
  }
}
