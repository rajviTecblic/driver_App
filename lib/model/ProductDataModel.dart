

class ProductDataModel{
  String? pid;
  String? product_name;
  String? pro_qty;
  String? no_of_Box;
  String? status;
  bool? valuefirst = false;




  ProductDataModel({this.pid,this.product_name, this.pro_qty, this.no_of_Box,this.valuefirst,this.status});

  ProductDataModel.fromJson(Map<String, dynamic> json)
      : pid = json["pid"],
        product_name = json["product_name"],
        status = json["status"],
        pro_qty = json["pro_qty"],
        no_of_Box = json["no_of_Box"];
}