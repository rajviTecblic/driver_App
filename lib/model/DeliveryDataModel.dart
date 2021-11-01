
import 'package:flutter/material.dart';

class DeliveryDataModel{
  String? id;
  String customerName;
  String customerMobile;
  String productName;
  String productQuantity;
  String city;
  bool isSelected=false;
  Color mycolor=Colors.red;

  DeliveryDataModel({this.id="",this.customerName="", this.customerMobile="", this.productName="",
    this.productQuantity="", this.city="",this.isSelected=false,this.mycolor=Colors.white});

  DeliveryDataModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        customerName = json["customerName"],
        customerMobile = json["customerMobile"],
        productName = json["productName"],
        productQuantity = json["productQuantity"],
        city = json["city"];
}