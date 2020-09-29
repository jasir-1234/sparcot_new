import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

import 'order_payment/order_details_tracking.dart';
import 'order_payment/tracking_page.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  var cartItemList = null;
  var arrProducts = null;




  @override
  void initState() {
    super.initState();
    this.getOrderList();
    setState(() {});
  }

  Future<String> getOrderList() async {
    //get token from shared prefrence
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    String url = baseUrl + strCommonPort + strGetOrder;
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Content-Type": "application/json",
      "Authorization": strToken


    });
    var objResponse = json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      cartItemList = objResponse["arrList"];
    }
          print("heyyyyyyyyyyyyyy");
    print(cartItemList);

    for ( arrProducts in cartItemList) {
      arrProducts = arrProducts['arrProducts'];
      print("urlllllllllllllllll");

      print(arrProducts);

    }




    //for accepting only json response
    setState(() {});
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width * 0.7;
    double height = MediaQuery
        .of(context)
        .size
        .height;

    Container _checkStatus(status) {
      // status 1 => Out for Delivery
      // status 2 => Shipped
      // status 3 => Delivered

      if (status == "CONFIRM") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Confirmed',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "PENDING") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Order Pending',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "SHIPPED") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Shipped',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "DELIVERED") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Delivered',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "CANCEL") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Canceled',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "RETURNED") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Returned',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      } else if (status == "REFUNDED") {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0)),
          ),
          child: Text(
            'Refunded',
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        titleSpacing: 0.0,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),

      body: ListView.builder(

        itemCount: cartItemList != null ? cartItemList.length : 0,

        itemBuilder: (context, index) {
          final item = cartItemList != null ? cartItemList[index] : null;
  //      final imgItem = arrProducts != null ? arrProducts[index] : null;
          var strDocId = item['strOrderId'];
   //      var imgUrl = imgItem['strImageUrl'];
         print("tapeddddddddddddddddddd");
          print(strDocId);
          return Container(

              child: InkWell(
                onTap: () {

                print("tapeddddddddddddddddddd");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  TrackingPage(strOrderId: strDocId)),
                );
//                MaterialPageRoute(
//                  builder: (context) =>  TrackingPage(strOrderId: strDocId));

//                Navigator.of(context).push(PageRouteBuilder(
//                    pageBuilder: (_, __, ___) => new TrackingPage()));
             //   Navigator.push(context, SlideLeftRoute(page: TrackingPage()));
              },
                child: Card(
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _checkStatus(item['strOrderStatus']),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: (height / 40.0), bottom: (height / 40.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 120.0,
                                        height: ((height - 200.0) / 4.0),
                                        alignment: Alignment.center,
                                        child: Image(
                                          image: item["arrProducts"][0]
                                          ["strImageUrl"] !=
                                              null
                                              ? NetworkImage(
                                              item["arrProducts"][0]
                                              ["strImageUrl"])
                                              : AssetImage(
                                              "assets/payment_icon/cash_on_delivery.png"),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    width: (width - 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(
                                          '${item['strOrderId']}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Price:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              '₹${item['dblTotalOrderAmount']}',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: 'No of Products:  ',
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.grey),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                      '  ${item['arrProducts']
                                                          .length}',
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.blue)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              )
            // height: (height / 4.5),
          );
        },
      ),
    );
  }
}
