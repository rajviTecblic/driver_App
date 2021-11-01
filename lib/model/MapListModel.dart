class MapListModel{
  final String id;
  final String Address1;
  final String Address2;
  final String city;
  final String state;
  final String Country;
  final String Pincode;

  MapListModel(this.id, this.Address1, this.Address2, this.city,this.state,this.Country,this.Pincode);

  // factory MapListModel.fromJson(Map<String, dynamic> json) {
  //   return MapListModel(
  //     id: json['id'],
  //     Address1: json['Address1'],
  //     Address2: json['Address2'],
  //     city: json['city'],
  //     state: json['state'],
  //     Country: json['Country'],
  //     Pincode: json['Pincode'],
  //   );
  // }
}