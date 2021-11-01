

import 'package:flutter/material.dart';

class SummaryModel{
  String? order_id;
  String? status;
  String? Address;
  String? PhoneNumber;
  List<ProductDetailsModel> product_details=[];

  SummaryModel({this.order_id,this.status="", this.Address="", this.PhoneNumber="",required this.product_details});

  SummaryModel.fromJson(Map<String, dynamic> json){
    order_id = json["order_id"];
    status = json["status"];
    Address = json['Address'];
    PhoneNumber = json['PhoneNumber'];
    product_details = [];
    json['product_details'].forEach((v) {
    product_details.add(new ProductDetailsModel.fromJson(v));
    });
  }


}

class ProductDetailsModel{
  String? pid;
  String? product_name;
  String? pro_qty;
  String? no_of_Box;
  String? status;
  bool? isSelected=false;
  Color? mycolor=Colors.red;
  ProductDetailsModel({this.pid,this.product_name="", this.pro_qty="", this.no_of_Box="",this.status,this.isSelected,this.mycolor});

  ProductDetailsModel.fromJson(Map<String, dynamic> json)
      : pid = json["pid"],
        product_name = json["product_name"],
        pro_qty = json["pro_qty"],
        no_of_Box = json["no_of_Box"],
        status = json["status"];
}