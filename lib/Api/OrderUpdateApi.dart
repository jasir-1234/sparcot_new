import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future statusUpdate(String orderId, String status) async {
  String url = baseUrl + strCommonPort + strUpdateOrder;
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "Authorization": prefs.getString("userToken")},
    body: jsonEncode(<String, String>{
      'strOrderId': orderId,
      'strOrderStatus': status,

    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}