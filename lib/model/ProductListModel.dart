

class ProductListModel{
  String? product_id;
  String? order_id;
  String? status;





  ProductListModel({this.product_id,this.order_id="", this.status=""});

  ProductListModel.fromJson(Map<String, dynamic> json)
      : product_id = json["product_id"],
        order_id = json["order_id"],
        status = json["status"];
}