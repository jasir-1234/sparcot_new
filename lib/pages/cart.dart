import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// My Own Imports
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:sparcotbtc/Api/CartQtyApi.dart';
import 'package:sparcotbtc/pages/home.dart';
import 'package:sparcotbtc/pages/order_payment/delivery_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var cartItemList = [];
  var arrSchema = [];
  int cartItem = 0;
  int cartTotal = 0;
  var objOrder = null;
  var objUserDetails = null;
  var itemCount = 0;
  var offercount = 0 ;
  var scheme =[];
  int Discount = 0;
  var firstSchm = "";
  var qtyController = new TextEditingController();

  @override
  void initState() {
    setState(() {});
    super.initState();
    this.getCartList();
  }

  Future<String> getCartList() async {
    //get token from shared prefrence
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    String url = baseUrl + strCommonPort + strGetCart;
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Content-Type": "application/json",
      "Authorization": strToken
    });
    var objResponse = json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      cartItemList = objResponse["arrList"];
      Discount = objResponse["dblDiscount"];

      print(objResponse);



      cartItem = cartItemList.length;


    }
    print("caaaaaaaaaaaaaart");
    print(Discount);
    print("aaaaaaaaaaaaaaaaaaaaaaaaah");
    print(strToken);
    for (var i = 0; i < cartItemList.length; i++) {
      cartTotal = cartTotal +
          (int.parse(cartItemList[i]["dblRetailerPrice"].toString()) *
              int.parse(cartItemList[i]["dblQty"].toString()));
    }
    //for accepting only json response
    setState(() {});
    return "Success";
  }

  Future<String> getUserDetails() async {
    //get token from shared prefrence
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    var strDocId = prefs.getString('userId') ?? "";
    String url = baseUrl + strCommonPort + strGetUserDetails;
    var response = await http.post(Uri.encodeFull(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": strToken
        },
        body: jsonEncode(<String, String>{
          'strDocId': strDocId,
          "strType": strType,
          "strTargetType": "COMMON"
        }));
    print("aaaaaaaaaaaaaaaaaaaaaaaaah");
    print(strType);
    var objResponse = await json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      objUserDetails = await objResponse["arrList"][0];
      setState(() {});
    }

    //for accepting only json response
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double widthFull = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // No Item in Cart AlertDialog Start Here
    void _showDialog(strTittle) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(strTittle),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    // No Item in Cart AlertDialog Ends Here

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),

      bottomNavigationBar: Material(
        elevation: 5.0,

        child: Container(

          color: Colors.white,
          width: widthFull,


          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,


            children: <Widget>[
              Container(
                width: ((widthFull) / 2),
                height: 50.0,
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
                          text: ' ₹$cartTotal',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
     //             TextSpan(
//                          text:  "Discount amount is \n" + Discount.toString(),
//                          style: TextStyle(
//                              fontSize: 18.0,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.blue))
//
                    ],
                  ),
                ),
              ),

//              Container(
//                width: ((widthFull) / 4),
//                height: 50.0,
//                alignment: Alignment.center,
//                child: RichText(
//                  text: TextSpan(
//                    text: 'Total: ',
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 15.0,
//                        color: Colors.black),
//                    children: <TextSpan>[
//                      TextSpan(
//                          text: ' ₹$cartTotal',
//                          style: TextStyle(
//                              fontSize: 18.0,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.blue)),
//                    ],
//                  ),
//                ),
//              ),
              ButtonTheme(
                minWidth: ((widthFull) / 2),
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    'Pay Now',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  onPressed: () async {
                    var arrProducts = [];
                    for (var i = 0; i < cartItemList.length; i++) {
                      var objProduct = cartItemList[i];
                      print("objProduct.......");
                      print(objProduct);
                      if (int.parse(objProduct["dblTotalStock"].toString()) >
                          0) {
                        await arrProducts.add({
                          "strName": objProduct["strName"],
                          "strImageUrl": objProduct["strImageUrl"],
                          "strProductId": objProduct["_id"],
                          "strCreatedTime": new DateTime.now().toString(),
                          "dblQty": objProduct["dblQty"],
                          "dblRetailerPrice": objProduct["dblRetailerPrice"],
                          "strSize": objProduct["strSize"] != null
                              ? objProduct["strSize"]
                              : null,
                          "strColor": objProduct["strColor"] != null
                              ? objProduct["strColor"]
                              : null
                        });
                      }
                    }
                    print("arrProducts....");
                    print(arrProducts);
                    await this.getUserDetails();
                    (cartTotal == 0)
                        ? _showDialog("No Item in Cart")
                        : Navigator.push(
                            context,
                            SlideLeftRoute(
                                page: Delivery({
                              "strOrderFrom": "CART",
                              "arrProducts": arrProducts,
                              "dblTotalOrderAmount": cartTotal
                            }, objUserDetails,Discount)));
                  },
                  color: (cartTotal == 0)
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: (cartItem == 0)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.shoppingBasket,
                    color: Colors.grey,
                    size: 60.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'No Item in Cart',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: cartItemList.length,
              itemBuilder: (context, index) {
                final item = cartItemList[index];
                arrSchema = item["arrScheme"];
                offercount = item["dblOfferQty"];
//                if(qtyController.text.isEmpty){
//                 // qtyController.text = item["dblOfferQty"].toString();
//                }

                print("kkkkkkkkkkkkkkkkkkkkkkkk");
                if(arrSchema.isNotEmpty){
                  var i = arrSchema[0]['intBuyNo'];
                  firstSchm= i ;
                  print(arrSchema);
                }

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(5.0)),
                        ),
                        child: item["dblTotalStock"] != null
                            ? Text(
                                (int.parse(item["dblTotalStock"].toString()) -
                                            int.parse(
                                                item["dblQty"].toString())) <
                                        10
                                    ? "Only " +
                                        item["dblTotalStock"].toString() +
                                        " Lefts"
                                    : "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              )
                            : Container(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          setState(() {
                            cartItemList.removeAt(index);
                            cartItem--;
                            cartTotal = cartTotal -
                                (int.parse(item["dblRetailerPrice"].toString()));
                          });

                          // Then show a snackbar.
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Item Removed")));
                        },
                      ),
                    ),
                  ],
                  child: Container(
                    height: (height /3.2),
                    child: Card(

                        elevation: 3.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 120.0,
                                  height: ((height - 200.0) / 4.0),
                                  child: Image(
                                    image: NetworkImage(item['strImageUrl']),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 4.0,
                            ),
                            Container(

                              height: double.infinity,
                              width: (width - 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    '${item['strName']}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        width: 2.0,
                                      ),
                                      Text(
                                        '₹${item['dblRetailerPrice'].toString()}',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                        ),
                                      ),

                                      item['dblQty']!=0? new  IconButton(icon: new Icon(Icons.remove),onPressed: () async {


                                        if(item['dblQty'] <= 1){

                                        }else{
                                          item['dblQty']-- ;
                                          var id = item['strCartDocId'].toString();
                                          var qty = item['dblQty'].toString();


                                          var rsp = await qtyUpdate( id,qty,offercount.toString());
                                          print("staaaaaaaaaaaaaaaatus");
                                          print(rsp);


                                            for (var value in arrSchema) {
                                              final name = value['intBuyNo'];
                                              print("scheeeeeeeeeeem");
                                              print(name);
                                              if (int.parse(item['dblQty'].toString()) >=  int.parse(value['intBuyNo'])) {

                                                offercount = int.parse(value['intGetNo']) ;

                                                var rysp = await qtyUpdate( id,qty.toString(),offercount.toString());
                                                print("staaaaaaaaaaaa7777aaaatus");
                                                print(rysp);

                                              }
                                              if(int.parse(firstSchm.toString()) > int.parse(item['dblQty'].toString())){
                                                offercount = 0;
                                                var rysp = await qtyUpdate( id,qty.toString(),offercount.toString());
                                                print("staaaaaaaaaaaa7777aaaatus");
                                                print(rysp);

                                              }

                                            }

                                          print("oooooooooooooofr");
                                          print(offercount);
                                          cartTotal=0;
                                          for (var i = 0; i < cartItemList.length; i++) {
                                            cartTotal = cartTotal +
                                                (int.parse(cartItemList[i]["dblRetailerPrice"].toString()) *
                                                    int.parse(cartItemList[i]["dblQty"].toString()));
                                          }

                                          setState(() {

                                          });
                                        }


                                      },):new Container(),


                                      new Text(item['dblQty'].toString()),
                                      new IconButton(icon: new Icon(Icons.add),onPressed:() async {

                                        item['dblQty']++ ;
                                        var id = item['strCartDocId'].toString();
                                        var qty = int.parse(item['dblQty'].toString())  ;

                                        var rsp = await qtyUpdate( id,qty.toString(),offercount.toString());
                                        print("staaaaaaaaaaaaaaaatus");
                                        print(rsp);
                                        cartTotal=0;
                                        print(arrSchema);
                                      //  final qt = item['dblQty'] ;
                                        for (var value in arrSchema) {
                                          final name = value['intBuyNo'];
                                          print("scheeeeeeeeeeem");
                                          print(name);
                                            if (int.parse(item['dblQty'].toString()) >=  int.parse(value['intBuyNo'])) {
                                               offercount = int.parse(value['intGetNo']) ;

                                               var rysp = await qtyUpdate( id,qty.toString(),offercount.toString());
                                               print("staaaaaaaaaaaa7777aaaatus");
                                               print(rysp);

                                            }

                                        }

                                        print("oooooooooooooofr");
                                        print(offercount);

                                        for (var i = 0; i < cartItemList.length; i++) {
                                          cartTotal = cartTotal +
                                              (int.parse(cartItemList[i]["dblRetailerPrice"].toString()) *
                                                  int.parse(cartItemList[i]["dblQty"].toString()));
                                        }

                                        setState(() {
                                        });

                                      },


                                            )],
                                  ),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  item['strSize'] != "null"
                                      ? RichText(
                                          text: TextSpan(
                                            text: 'Size:  ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  ${item['strSize']}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.blue)),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  item['strColor'] != "null"
                                      ? RichText(
                                          text: TextSpan(
                                            text: 'Color:  ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  ${item['strColor']}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: item["strColorCode"] !=
                                                                  null &&
                                                              item["strColorCode"]
                                                                      .length >=
                                                                  5
                                                          ? new Color(int.parse("0x" +
                                                              item["strColorCode"]
                                                                  .toString()
                                                                  .toUpperCase()))
                                                          : Colors.blue)),
                                            ],
                                          ),
                                        )
                                      : Container(),
//                                  SizedBox(
//                                    height: 2.0,
//                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            text: 'Qty:  ',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  ${item['dblQty']}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.blue)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.0,
                                        ),
                                        InkWell(
                                          child: Container(
                                            color: Colors.grey,
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onTap: () async {
                                            var blnAPIstatus = await this
                                                .deleteCart(item["strCartDocId"]);
                                            setState(() {
                                              if (blnAPIstatus != null &&
                                                  blnAPIstatus == true) {
                                                cartItemList.removeAt(index);
                                                cartItem--;
                                                cartTotal = cartTotal -
                                                    (int.parse(
                                                        item["dblRetailerPrice"]
                                                            .toString()));
                                              }
                                            });
                                            if (blnAPIstatus != null && blnAPIstatus == true) {
                                              // Then show a snackbar.
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Item Removed")));
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text("Failed")));
                                            }
                                          },
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            text: 'Offer Qty:  ',
                                            style: TextStyle(

                                                fontSize: 15.0,
                                                color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(

                                                text: item["dblOfferQty"].toString()
                                                ,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.blue)),
                                            ],
                                          ),

                                        ),
//                                        Container(
//                                          width: 50, // do it in both Container
//                                          child: TextField(
//                                              controller: qtyController
//                                          ),
//                                        ),

                                      ]),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                );
              },

            ),

    );

  }

  Future<bool> deleteCart(strCartId) async {
    //get token from shared prefrence
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    final url = Uri.parse(baseUrl + strCommonPort + strDeleteCart);
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Content-Type": "application/json",
      "Authorization": strToken
    });
    request.body = jsonEncode({
      'arrCartId': [strCartId]
    });
    final response = await request.send();
    var objRes = await (response.stream.bytesToString());
    var convertDataToJson = await jsonDecode(objRes);
    if (convertDataToJson["blnAPIStatus"].toString() == "true") {
      return true;
    } else {
      return false;
    }
  }
}
