import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

Future detailApi(String orderid) async {
  String url = baseUrl + strCommonPort + strGetOrderDetails;
  SharedPreferences prefs;
  print("ooooooooooooooooooooooooooooooooord");
  print(orderid);
  prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "Authorization": prefs.getString("userToken")},
    body: jsonEncode(<String, String>{
      'strOrderId': orderid,
      "strUserType": strType,

    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}