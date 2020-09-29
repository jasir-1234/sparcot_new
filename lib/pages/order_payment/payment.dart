import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/utils/constants.dart';

import '../spashscreen.dart';
import 'onlinepayment.dart';

class PaymentPage extends StatefulWidget {
  final objFullOrder;
  final Discount;

  const PaymentPage(this.objFullOrder, this.Discount);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedRadioPayment;
  var objCreatePayment = {};
  int total = 0;
  double discamnt = 0;
  double payamnt = 0;

  @override
  void initState() {
    print("widget.Discounttttttttttttttttttttttttt");
    objCreatePayment = {
      'amount': widget.objFullOrder["dblTotalOrderAmount"],
      'customer_id': widget.objFullOrder["objAddress"]["strName"],
      'customer_email': "promotion.sparcot@gmail.com",
      'customer_phone': widget.objFullOrder["objAddress"]["strMobileNo"],
      'product_id': widget.objFullOrder["objAddress"]["strPinCode"],
      'description': widget.objFullOrder["objAddress"]["strCity"],
    };

    total = widget.objFullOrder['dblTotalOrderAmount'];
    print(total);
    discamnt =
        widget.Discount / 100 * widget.objFullOrder['dblTotalOrderAmount'];

    payamnt = widget.objFullOrder['dblTotalOrderAmount'] - discamnt;
    print(payamnt);
    super.initState();
    selectedRadioPayment = 0;
  }

  setSelectedRadioPayment(int val) {
    setState(() {
      selectedRadioPayment = val;
    });
  }

  Future<dynamic> createOrder() async {
    //get token from shared prefrence

    var objFullOrder = await widget.objFullOrder;
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    String url = baseUrl + strCommonPort + strCreateOrder;
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": strToken
        },
        body: await jsonEncode(
            <String, dynamic>{...objFullOrder, "strModePayment": "COD"}));
    var objResponse = await json.decode(response.body);
    //strOrderId = await objResponse["strOrderId"];
    print(objResponse);
    return objResponse;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 0.0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Amount to pay ',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'PURCHASED TOTAL : ' + "₹" + total.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'DISCOUNT : ' + widget.Discount.toString() + "%",
                    style: TextStyle(
                      fontSize: 16.0,
                      //  fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'DISCOUNT AMOUNT: ' + "₹" + discamnt.toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        //     fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'TOTAL : ' + "₹" + payamnt.toString(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  //   child: Text(
                  //      'Thanks for Purchasing',
                  //      style: TextStyle(fontSize: 15.0, color: Colors.black),
                  //    ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Choose your payment method',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: width - 40.0,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RadioListTile(
                    value: 1,
                    groupValue: selectedRadioPayment,
                    title: Text(
                      "Credit / Debit Card",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val) {
                      setSelectedRadioPayment(val);
                    },
                    activeColor: Colors.blue,
                    secondary: Image(
                      image: AssetImage(
                        'assets/payment_icon/card.png',
                      ),
                      height: 45.0,
                      width: 45.0,
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                ),
                Container(
                  width: width - 40.0,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: RadioListTile(
                    value: 2,
                    groupValue: selectedRadioPayment,
                    title: Text(
                      "Cash On Delivery",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val) {
                      setSelectedRadioPayment(val);
                    },
                    activeColor: Colors.blue,
                    secondary: Image(
                      image: AssetImage(
                        'assets/payment_icon/cash_on_delivery.png',
                      ),
                      height: 45.0,
                      width: 45.0,
                    ),
                  ),
                ),
                // Divider(
                //   height: 1.0,
                // ),
                // Container(
                //   width: width - 40.0,
                //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //   child: RadioListTile(
                //     value: 3,
                //     groupValue: selectedRadioPayment,
                //     title: Text(
                //       "PayPal",
                //       style: TextStyle(
                //           fontSize: 18.0, fontWeight: FontWeight.bold),
                //     ),
                //     onChanged: (val) {
                //       setSelectedRadioPayment(val);
                //     },
                //     activeColor: Colors.blue,
                //     secondary: Image(
                //       image: AssetImage(
                //         'assets/payment_icon/paypal.png',
                //       ),
                //       height: 40.0,
                //       width: 40.0,
                //     ),
                //   ),
                // ),
                // Divider(
                //   height: 1.0,
                // ),
                // Container(
                //   width: width - 40.0,
                //   margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //   child: RadioListTile(
                //     value: 4,
                //     groupValue: selectedRadioPayment,
                //     title: Text(
                //       "Google Wallet",
                //       style: TextStyle(
                //           fontSize: 18.0, fontWeight: FontWeight.bold),
                //     ),
                //     onChanged: (val) {
                //       setSelectedRadioPayment(val);
                //     },
                //     activeColor: Colors.blue,
                //     secondary: Image(
                //       image: AssetImage(
                //         'assets/payment_icon/google_wallet.png',
                //       ),
                //       height: 40.0,
                //       width: 40.0,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 40.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    onTap: () async {
                      print("selectedRadioPayment\n");
                      print(selectedRadioPayment);
                      if (selectedRadioPayment == 1) {
                        print("selectedRadioPayment\n");
                        print(selectedRadioPayment);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnlinePayment(
                                  objCreatePayment, widget.objFullOrder)),
                        );
                        // _showDialog(
                        //     "Sorry", "Only Cash On Delivery Available", 1000);
                      } else {
                        var objOrderResponse = await this.createOrder();
                        if (objOrderResponse["blnAPIStatus"].toString() ==
                            "true") {
                          _showDialog(
                              "ORDER PLACED",
                              "Your Payment Received.\n Order Id: " +
                                  objOrderResponse["strOrderId"],
                              2000);
                        } else {
                          _showDialog(
                              "ORDER FAILED",
                              objOrderResponse["arrErrors"][0] != null
                                  ? objOrderResponse["arrErrors"][0]
                                  : "Something Wrong",
                              2000);
                        }
                      }
                    },
                    child: Container(
                      width: width - 40.0,
                      padding: EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // user defined function for Logout Dialogue
  void _showDialog(strMessage, strDiscription, intDelay) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        color: Theme.of(context).primaryColorLight, width: 5.0),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  strMessage,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  strDiscription,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        if (intDelay == 1000) {
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        }
      });
    });
  }

//  _showProgress() {
//    return Expanded(
//      flex: 1,
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          SpinKitFoldingCube(
//            color: Theme.of(context).primaryColor,
//            size: 18.0,
//          ),
//          SizedBox(height: 5.0),
//          Text(
//            strProgressMessage,
//            style: TextStyle(
//                color: Colors.grey[700],
//                fontSize: 15.0,
//                fontWeight: FontWeight.normal),
//            textAlign: TextAlign.center,
//          ),
//        ],
//      ),
//    );
//  }
}
