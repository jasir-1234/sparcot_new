import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future searchProduct(String search) async {
  String url = baseUrl + strOpenPort + strProductListEndPoint;
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "strAppInfo" : strAppInfo},
    body: jsonEncode(<String, String>{
      'strSearch': search
    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson["arrList"];
}