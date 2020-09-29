import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

Future updateUser(String pin, String name,String house,String area,String city ) async {
  String url = baseUrl + strOpenPort + strRegisterUser;
  SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "Authorization": prefs.getString("userToken")},
    body: jsonEncode(<String, dynamic>{
      '_id':prefs.getString("userId"),
      'strName': name,
      'strPinCode': pin,
      'strType': strType,
      'strOperationType' : 'UPDATE',
      'arrAddress': [{
          'strHouse': house,
          'strArea': area,
          'strCity': city
        }]


    }),
  );
  var convertDataToJson = json.decode(response.body);
  return convertDataToJson;
}
