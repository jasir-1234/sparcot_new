import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:sparcotbtc/pages/cart.dart';
import 'package:sparcotbtc/pages/category/top_offers_pages/filter_row.dart';
import 'package:sparcotbtc/pages/product/product.dart';
import 'package:sparcotbtc/utils/constants.dart';

import '../../login.dart';

class WomensWear extends StatefulWidget {
  final title;
  final objCondition;

  WomensWear(this.title, this.objCondition);

  @override
  _WomensWearState createState() => _WomensWearState();
}

class _WomensWearState extends State<WomensWear> {
  var progress = true;

  List arrProductLists = new List();
  int intLimit = 50;
  int intTotalCount = 0;
  int intPageNo = 0;
  List arrGridItem = new List<Widget>();

  @override
  void initState() {
    super.initState();
    this.getProductList(widget.objCondition);
  }

  getProductList(objCondition) async {
    progress = true;
    String url = baseUrl + strOpenPort + strProductListEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          ...objCondition,
          ...{"intLimit": intLimit, "intPageNo": intPageNo}
        }));
    var convertDataToJson = await json.decode(response.body);
    intTotalCount = int.parse(convertDataToJson["intTotalCount"].toString());
    arrProductLists = convertDataToJson['arrList'];
    progress = false;
    setState(() {});
    return arrProductLists;
  }

  Widget getStructuredGridCell(var objProduct) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: InkWell(
        child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Hero(
                tag: '${objProduct["strName"]}',
                child: Container(
                  // height: 185.0,
                  height: ((height - 150.0) / 2.95),
                  margin: EdgeInsets.all(6.0),
                  child: objProduct["strImageUrl"] != null
                      ? Image(
                          image: NetworkImage(objProduct["strImageUrl"]),
                          fit: BoxFit.fitWidth,
                        )
                      : Container(),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 6.0, left: 6.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      objProduct["strName"],
                      style: TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "₹${objProduct["dblSellingPrice"].toString()}",
                          style: TextStyle(fontSize: 16.0),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 7.0,
                        ),
                        Text(
                          "₹${objProduct["dblMRP"].toString()}",
                          style: TextStyle(
                              fontSize: 13.0,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      (100 -
                                  ((int.parse(objProduct["dblSellingPrice"]
                                              .toString()) /
                                          int.parse(objProduct["dblMRP"]
                                              .toString())) *
                                      100))
                              .round()
                              .toString() +
                          "%  Discount",
                      style: TextStyle(
                          color: const Color(0xFF67A86B), fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductPage(
                        strDocId: objProduct["_id"],
                      )));
        },
      ),
    );
  }

  Widget getGridView(arrList, width, height) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: GridView.count(
          shrinkWrap: true,
          primary: false,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 2,
          childAspectRatio: ((width) / (height - 150.0)),
          children: List.generate(arrProductLists.length, (index) {
            return getStructuredGridCell(arrProductLists[index]);
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    arrGridItem.add(getGridView(arrProductLists, width, height));
    var arrSelectedBrands = widget.objCondition["arrBrands"] != null
            ? widget.objCondition["arrBrands"]
            : [],
        arrSelectedCategory = widget.objCondition["arrCategory"] != null
            ? widget.objCondition["arrCategory"]
            : [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Badge(
              // badgeContent: Text('3'),
              badgeColor: Theme.of(context).primaryColorLight,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              SharedPreferences prefs;
              prefs = await SharedPreferences.getInstance();
              if (prefs.getString("userToken") == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              } else {
                Navigator.push(context, SlideLeftRoute(page: CartPage()));
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF1F3F6),
      body: new ListView(shrinkWrap: true, children: <Widget>[
        FilterRow(arrSelectedBrands, arrSelectedCategory),
        Divider(
          height: 1.0,
        ),
        (progress)
            ? Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 35.0,
                ),
              )
            : (arrProductLists.length != 0
                ? Center(
                    child: Stack(
                        children: arrGridItem.length != 0
                            ? arrGridItem
                            : [Container()]))
                : Center(
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
                          height: 10.0,
                        ),
                        Text(
                          'No Products Founds',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FlatButton(
                          child: Text(
                            'Go Back',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  )),
        arrProductLists.length != 0
            ? ((progress)
                ? Center(
                    child: SpinKitFoldingCube(
                      color: Theme.of(context).primaryColor,
                      size: 25.0,
                    ),
                  )
                : InkWell(
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Text(
                        (intTotalCount >= ((intPageNo + 1) * intLimit))
                            ? 'Load More'
                            : 'No More Item',
                        style: TextStyle(color: Colors.blue, fontSize: 15.0),
                      ),
                      alignment: Alignment.center,
                    )),
                    onTap: () async {
                      if (intTotalCount >= ((intPageNo + 1) * intLimit)) {
                        progress = true;
                        intPageNo = (intPageNo + 1);
                        this.getProductList(widget.objCondition);
                      } else {}
                    },
                  ))
            : Container()
      ]),
    );
  }
}
