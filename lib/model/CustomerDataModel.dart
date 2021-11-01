class CustomerDataModel{
   String? customer_id;
   String? status;
   String? Address;
   String? Order_No;
   String? postalCode;
   String? PhoneNumber;
   String? mobileNumber;
   String? delivery_status;
   String? type_of_delivery;
   bool? onClick=false;


  CustomerDataModel({this.customer_id, this.status, this.Address="",this.Order_No,this.postalCode, this.PhoneNumber,this.mobileNumber,this.delivery_status,this.type_of_delivery,this.onClick});

  CustomerDataModel.fromJson(Map<String, dynamic> json)
      :  customer_id = json["customer_id"],
        status = json["status"],
        Address = json["Address"],
        Order_No = json["Order_No"],
        PhoneNumber = json["PhoneNumber"],
        mobileNumber = json["mobileNumber"],
        postalCode = json["postalCode"],
        type_of_delivery = json["type_of_delivery"],
        delivery_status= json["delivery_status"];

}