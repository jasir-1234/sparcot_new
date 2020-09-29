import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparcotbtc/pages/product/product.dart';
import 'package:sparcotbtc/utils/constants.dart';

class SimilarProductsGridView extends StatefulWidget {
  final objCondition;

  SimilarProductsGridView(this.objCondition);

  @override
  _SimilarProductsGridViewState createState() =>
      _SimilarProductsGridViewState();
}

class _SimilarProductsGridViewState extends State<SimilarProductsGridView> {
  var arrProductList = [];

  @override
  void initState() {
    setState(() {});
    super.initState();
    this.getProductList();
  }

  Future<String> getProductList() async {
    String url = baseUrl + strOpenPort + strProductListEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          ...widget.objCondition
        })); //for accepting only json response
    var convertDataToJson = json.decode(response.body);
    setState(() {
      arrProductList = convertDataToJson['arrList'];
    });
    return "Success";
  }

  Hero getStructuredGridCell(var objProduct) {
    double height = MediaQuery.of(context).size.height;
    return Hero(
      tag: '${objProduct["strName"]}',
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
              Container(
                // height: 185.0,
                height: 185.0,

                child: Image(
                  image: NetworkImage(objProduct["strImageUrl"]),
                  fit: BoxFit.fitWidth,
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
                          "₹${objProduct["dblRetailerPrice"].toString()}",
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
                                  ((int.parse(objProduct["dblRetailerPrice"]
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 2,
      childAspectRatio: ((width) / (height - 150.0)),
      children: List.generate(arrProductList.length, (index) {
        return getStructuredGridCell(arrProductList[index]);
      }),
    );
  }
}
