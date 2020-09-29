// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utils/constants.dart';
//
// Future paymentApi(String orderid) async {
//   String url = baseUrl + strCommonPort + strGetOrderDetails;
//   SharedPreferences prefs;
//   print("paymnet is successfull");
//   print(orderid);
//   prefs = await SharedPreferences.getInstance();
//   final response = await http.post(
//     url,
//     headers: {
//       "Content-Type": "application/json",
//       "Authorization": prefs.getString("userToken")
//     },
//     body: jsonEncode(<String, String>{
//       'amount': amount,
//       'Customer': customer_id,
//       'Customer_email': customer_email,
//       'Customer_phone': customer_phone,
//       'product_id': cart_id,
//       'description': description,
//     }),
//   );
//   var convertDataToJson = json.decode(response.body);
//   return convertDataToJson;
// }
