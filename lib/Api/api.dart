import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future loginUser(String email, String password,String strFirbaseToken) async {
  String url = baseUrl + strOpenPort + strLoginEndPoint;

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
    body: jsonEncode(<String, String>{
      'strName': email,
      'strPassword': password,
      "strType": strType,
      "strFirbaseToken": strFirbaseToken
    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}
