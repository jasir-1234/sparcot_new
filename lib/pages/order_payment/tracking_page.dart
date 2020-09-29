import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/Api/OrderUpdateApi.dart';
import 'package:sparcotbtc/pages/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparcotbtc/Api/ProductDetailApi.dart';
import 'package:http/http.dart' as http;
import 'package:sparcotbtc/pages/home.dart';
import 'package:sparcotbtc/utils/constants.dart';

class TrackingPage extends StatefulWidget {
  final String strOrderId;

  TrackingPage({Key key, @required this.strOrderId}) : super(key: key);
  @override
  _TrackingPageState createState() => _TrackingPageState(strOrderId);
}



class _TrackingPageState extends State<TrackingPage> {

  String strOrderId;

  var arrProductDetails = null;
  var data = null;
  var blnAPIstatus=false;

  var total = "";
  var orderId ="";
  var orderTime ="";
  var orderStatus ="";
  var btStatus = "CANCEL";
  final String  url = baseUrl + strCommonPort + strGetOrderDetails;


  var btText = "CANCEL ORDER";
  int  CON  = 0xFFBDBDBD ;
  int  CONTEXT  = 0xFFBDBDBD ;
  int  SHIP  = 0xFFBDBDBD ;
  int  SHIPTEXT  = 0xFFBDBDBD ;
  int  DELIV  = 0xFFBDBDBD ;
  int  DELIVTEXT  = 0xFFBDBDBD ;

  /// array to show similar products in bottom
  List arrSimilarProduct = [];



  _TrackingPageState(this.strOrderId);

  @override
  void initState() {
    setState(() {
    });
    super.initState();

    this.getSimilarProdData();

  }
  Future<String>getSimilarProdData() async{
    arrProductDetails = await  detailApi(strOrderId);
    blnAPIstatus= await true;

    print(strOrderId);
    print(arrProductDetails);

    data = arrProductDetails["arrProducts"];

    total = arrProductDetails["dblTotalOrderAmount"].toString();
    orderId = arrProductDetails["strOrderId"].toString();
    orderTime = arrProductDetails["strCreatedTime"].toString();
    orderStatus = arrProductDetails["strOrderStatus"].toString();
    print(orderStatus);
    print(data);

    if(orderStatus == "PENDING"){

    }
    if(orderStatus == "CONFIRM"){


      CON  = 0xFF001149 ;
      CONTEXT  = 0xFF000000 ;

      setState(() {

      });
    }
    if(orderStatus == "SHIPPED"){

      btText = "RETURN ORDER" ;
      btStatus = "RETURNED";
      CON  = 0xFF001149 ;
      CONTEXT  = 0xFF000000 ;
      SHIP  = 0xFF001149 ;
      SHIPTEXT  = 0xFF000000 ;


      setState(() {

      });
    }
    if(orderStatus == "DELIVERED"){

      print("staaaaaaaaaaaaaaat");

      btText = "RETURN ORDER" ;


      CON  = 0xFF001149 ;
      CONTEXT  = 0xFF000000 ;
      SHIP  = 0xFF001149 ;
      SHIPTEXT  = 0xFF000000 ;
      DELIV  = 0xFF001149 ;
      DELIVTEXT  = 0xFF000000 ;

      setState(() {

      });


    }






    print(data);
    setState((){});

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


    double widthFull = MediaQuery.of(context).size.width;

    return Container(

      decoration: BoxDecoration(
          color: Colors.grey[100],
          image: DecorationImage(
              image: AssetImage('assets/Group 444.png'), fit: BoxFit.contain)),
      child: Container(
        color:Colors.white54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.grey),
            title: Text(
              'Order Details',
              style: TextStyle(
                color: darkGrey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),


            leading: SizedBox(),
            actions: <Widget>[CloseButton()],
          ),
          body: SingleChildScrollView(
            child: LayoutBuilder(
              builder:(_,constraints)=> Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[


                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("ORDER ID : "+ orderId,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text("ORDER TIME : "+ orderTime,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ],
                    ),

                    // hereee
                  ),
                  Container(

                    padding: EdgeInsets.all(10.0),

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[



                        FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,

                          onPressed: () async {
                            var rsp = await statusUpdate(
                                orderId, btStatus);
                            print("staaaaaaaaaaaaaaaatus");
                            if(rsp['strMessage'] == "Success"){
                              Fluttertoast.showToast(
                                  msg: "ORDER "+ btStatus,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,

                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 12.0
                              );

                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "ORDER "+ btStatus +" FAILED",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,

                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 12.0
                              );

                            }

                            print(rsp);
                          },
                          child: new Text(btText),

                        )



                      ],
                    ),

                    // hereee
                  ),
                  Container(


                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundColor:  Theme.of(context).primaryColor,
                            child: Text(
                              "1",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white
                              ),
                            ),
                            radius: 14.0,
                          ),
                        ),
                        Container(
                          width: width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "PENDING",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(


                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundColor:  Color(CON),
                            child: Text(
                              "2",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white
                              ),
                            ),
                            radius: 14.0,
                          ),
                        ),
                        Container(
                          width: width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "CONFIRMED",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(CONTEXT)
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  Container(


                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundColor:  Color(SHIP),
                            child: Text(
                              "3",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white
                              ),
                            ),
                            radius: 14.0,
                          ),
                        ),
                        Container(
                          width: width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SHIPPED",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(SHIPTEXT)
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(


                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            backgroundColor:  Color(DELIV),
                            child: Text(
                              "4",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white
                              ),
                            ),
                            radius: 14.0,
                          ),
                        ),
                        Container(
                          width: width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "DELIVERD",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(DELIVTEXT)
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                  ),

                  SizedBox(
                    height: 20.0,
                  ),


                  Container(
                    height: 200,
                    child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: data != null ? data.length : 0,
                      itemBuilder: (context, index) {
                        final item = data != null ? data[index] : null;
                        return Container(
                            child: InkWell(
                              onTap: () {
                                print("object\n\n\n\nn\n.........");
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => new TrackingPage()));
                                //   Navigator.push(context, SlideLeftRoute(page: TrackingPage()));
                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: Stack(
                                    children: <Widget>[

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

                                                        image: ["strImageUrl"] !=
                                                            null
                                                            ? NetworkImage(
                                                            item
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
                                                        '${item['strName']}',
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

                                                            '₹${item['dblRetailerPrice']}',
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
                                                                    '  ${arrProductDetails['arrProducts']
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
                  ),

                  Container(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: ((widthFull) / 2),
                          height: 40.0,
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: 'Total: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' ₹$total',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: ((widthFull) / 2),
                          height: 50.0,
                          child: RaisedButton(
                            child: Text(
                              'GO BACK ',
                              style: TextStyle(color: Colors.white, fontSize: 15.0),
                            ),
                            onPressed: ()  {
                              Navigator.pop(context);

                              print("arrProducts....");

                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}




