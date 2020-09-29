import 'package:flutter/material.dart';

// My Own Imports
import 'package:sparcotbtc/pages/order_payment/payment.dart';
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Delivery extends StatefulWidget {
  final objOrder;
  final objUserDetails;
  final Discount;
//final totalAmnt;
  Delivery(this.objOrder, this.objUserDetails,this.Discount);

  @override
  _DeliveryState createState() => _DeliveryState(objUserDetails);
}

class _DeliveryState extends State<Delivery> {
  final objUserDetails;
  var objPinCode = null;
  final _controllerPinCode = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerHouseArea = TextEditingController();
  final _controllerHouseNo = TextEditingController();
  final _controllerMobileNo = TextEditingController();
  final _controllerCity = TextEditingController();

  _DeliveryState(this.objUserDetails);

  @override
  void initState() {
    super.initState();
    var objAddress =
        objUserDetails != null && objUserDetails["arrAddress"].length != 0
            ? objUserDetails["arrAddress"][0]
            : null;
    _controllerPinCode.text =
        objAddress != null ? objAddress["strPinCode"] : "";
    _controllerName.text =
        objUserDetails != null ? objUserDetails["strName"] : "";
    _controllerHouseNo.text =
        objAddress != null ? objAddress["strHouseNo"] : "";
    _controllerHouseArea.text =
        objAddress != null ? objAddress["strHouseArea"] : "";
    _controllerMobileNo.text =
        objUserDetails != null ? objUserDetails["strMobileNo"] : "";
    _controllerCity.text = objAddress != null ? objAddress["strCity"] : "";
    objAddress != null ? this.getPinCode(objAddress["strPinCode"]) : "";
  }

  Future getPinCode(strValue) async {
    var arrList = [];
    //get token from shared prefrence
    String url = baseUrl + strOpenPort + strAutoComplete;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, String>{
          "strCollection": "cln_post_pin_codes",
          "strValue": strValue
        }));
    var objResponse = await json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      objPinCode = await objResponse["arrList"].length != 0
          ? objResponse["arrList"][0]
          : null;
      //for accepting only json response
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 0.0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Where are your Ordered Item Shipped?',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                      height: 1.6),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerPinCode,
                    onChanged: (text) {
                      if (text.length == 6) {
                        this.getPinCode(text);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Pin Code',
                      errorText: _controllerPinCode.text.isEmpty
                          ? 'Invalid PinCode'
                          : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: Text(
                      'District : ' +
                          (objPinCode != null
                              ? objPinCode["strDistrict"].toString()
                              : ""),
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alatsi',
                          height: 1.6)),
                ),
                SizedBox(
                  width: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: Text(
                      'State :' +
                          (objPinCode != null
                              ? objPinCode["strState"].toString()
                              : ""),
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alatsi',
                          height: 1.6)),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerName,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      errorText: _controllerName.text.isEmpty
                          ? 'EMPTY NAME!'
                          : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerMobileNo,
                    decoration: InputDecoration(
                      labelText: 'Mobile No',
                      errorText: _controllerName.text.isEmpty
                        ? 'EMTY MOBILE NO !'
                        : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerHouseNo,
                    decoration: InputDecoration(
                      labelText: 'House Name,Building Name,House No',
                      errorText: _controllerHouseNo.text.isEmpty
                          ? 'Feild Empty !'
                          : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerHouseArea,
                    decoration: InputDecoration(
                      labelText: 'Area,Colony,Streat',
                      errorText: _controllerHouseArea.text.isEmpty
                          ? 'Feild Empty !'
                          : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  width: width - 40.0,
                  child: TextField(
                    controller: _controllerCity,
                    decoration: InputDecoration(
                      labelText: 'City',
                      errorText: _controllerCity.text.isEmpty
                          ? 'Feild Empty !'
                          : null,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    onTap: () async {
                      if( _controllerPinCode.text.isNotEmpty && _controllerName.text.isNotEmpty && _controllerHouseNo.text.isNotEmpty &&
                          _controllerHouseNo.text.isNotEmpty &&_controllerMobileNo.text.isNotEmpty &&_controllerCity.text.isNotEmpty
                          ){
                        var objFullOrder = await {
                          ...widget.objOrder,
                          "objAddress": {
                            "strPinCode": _controllerPinCode.text,
                            "strName": _controllerName.text,
                            "strHouseNo": _controllerHouseNo.text,
                            "strHouseArea": _controllerHouseNo.text,
                            "strMobileNo": _controllerMobileNo.text,
                            "strCity": _controllerCity.text,
                            "strDistrict": (objPinCode != null
                                ? objPinCode["strDistrict"].toString()
                                : ""),
                            "strState": (objPinCode != null
                                ? objPinCode["strState"].toString()
                                : "")
                          }
                        };
                        Navigator.push(
                            context, SlideLeftRoute(page: PaymentPage(objFullOrder,widget.Discount)));
                      }
                      else{

                        Fluttertoast.showToast(
                            msg: "Invalid Feilds! Please Complete!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,

                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 12.0
                        );
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
                        'Go to Payment',
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
}
