import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../spashscreen.dart';

class OnlinePayment extends StatefulWidget {
  final objCreatePayment;
  final objFullOrder;

  OnlinePayment(this.objCreatePayment, this.objFullOrder);

  @override
  _OnlinePaymentState createState() => _OnlinePaymentState();
}

class _OnlinePaymentState extends State<OnlinePayment> {
  var objResponse;
  var orderId;

  @override
  void initState() {
    setState(() {});
    super.initState();
    this.OnlinePayment();
  }

  OnlinePayment() async {
    String url = 'http://15.207.68.165:5000/create-order';
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{...widget.objCreatePayment}));
    objResponse = await json.decode(response.body);
    print(objResponse);
    orderId = objResponse["order_Id"];
    setState(() {});
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<dynamic> createOrder() async {
    //get token from shared prefrence
    var objFullOrder = await widget.objFullOrder;
    print(objFullOrder);
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    String url = baseUrl + strCommonPort + strCreateOrder;
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": strToken
        },
        body: await jsonEncode(<String, dynamic>{
          ...objFullOrder,
          "strModePayment": "ONLINE",
          "orderId": orderId
        }));
    var objResponse = await json.decode(response.body);
    print(objResponse);
    return objResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SPARCOT PAYMENT GATEWATAY')),
      body: objResponse != null
          ? WebView(
              initialUrl: objResponse["payment_links"]["mobile"],
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                //  _controller.complete(webViewController);
              },
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.startsWith('https://www.google.com/')) {
                  print('blocking navigation to $request}');
                  var objOrderResponse = await this.createOrder();
                  if (objOrderResponse["blnAPIStatus"].toString() == "true") {
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
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            )
          : Container(),
    );
  }

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
}

//for accepting only json response
