
import 'dart:io';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String mainUrl = "https://manmelap.in/getDetails.php";
  static String getIndividualUrl = "https://manmelap.in/getIndividualData.php";
  static String getUpdateUrl = "https://manmelap.in/updateData.php";
  static String setUpdateUrl = "https://manmelap.in/status_update.php";
  static String getListOfProductUrl = "https://manmelap.in/get_list_of_product.php";
  static String getSummaryUrl = "https://manmelap.in/getsummarydata.php";

  static Future<http.Response> getList() {

    return http.get(Uri.parse(mainUrl));

  }
  static Future<http.Response> getIndividualData(String c_id) {
    var data = {
      'c_id': c_id,
    };
    return http.post(Uri.parse(getIndividualUrl), body: data);

  }
  static Future<http.Response> getSummaryData() {

    return http.post(Uri.parse(getSummaryUrl));

  }
  static Future<http.Response> getUpdateData(String? c_id) {
    var data = {
      'c_id': c_id,
    };
    return http.post(Uri.parse(getUpdateUrl), body: data);

  }
  static Future<http.Response> setData(String? product_id,String? order_id,String? status) {
    var data = {
      'p_id': product_id,
      'o_id': order_id,
      'status': status,
    };
    return http.post(Uri.parse(setUpdateUrl), body: data);

  }
  static Future<http.Response> getProductList(String? order_id) {
    var data = {
      'o_id': order_id,

    };
    return http.post(Uri.parse(getListOfProductUrl), body: data);

  }
}
