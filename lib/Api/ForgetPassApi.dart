import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future forgetPass(String name) async {
  String url = baseUrl + strOpenPort + strForgetPass;

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
    body: jsonEncode(<String, String>{
      'strStep': "FORGOT",
      "strType": strType,
      "strName": name
    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}
