import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

Future verifyOtp(String name,String pass,String otp,String detail) async {
  String url = baseUrl + strOpenPort + strForgetPass;
  print("nameeeeeeeeeeeeeeeeeeeeeee");
print(name);
  print(pass);
  print(otp);
  print(detail);

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
    body: jsonEncode(<String, String>{
      'strStep': "VERIFY",
      "strType": strType,
      "strName": name,
      "strPassword":pass,
      "strOTP":otp,
      "strSessionId":detail
    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}
