import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';

class Filter extends StatefulWidget {
  final arrSelectedBrands, arrSelectedCategory;

  Filter(this.arrSelectedBrands, this.arrSelectedCategory);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool price1 = false,
      price2 = false,
      price3 = false,
      brand1 = false,
      brand2 = false,
      brand3 = false;
  bool occasion1 = false, occasion2 = false, occasion3 = false;
  var arrBrandList = [], arrCategoryList = [];
  var objMasters = null;

  var arrBrandCheckValue = null, arrCategoyCheckValue = null;

  @override
  void initState() {
    super.initState();
    this.getmasters();
  }

  Future<dynamic> getmasters() async {
    String url = baseUrl + strOpenPort + strGetMasterEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          "arrCollection": [
            {"strCollection": "cln_category"},
            {"strCollection": "cln_brand"}
          ]
        })); //for accepting only json response
    objMasters = await json.decode(response.body);
    setState(() {
      arrBrandList = objMasters["cln_brand"];
      arrCategoryList = objMasters["cln_category"];
    });
    return "Set";
  }

  @override
  Widget build(BuildContext context) {
    var arrSelectedBrands = widget.arrSelectedBrands,
        arrSelectedCategory = widget.arrSelectedCategory;
    List arrBrandCheckLists = List<Widget>(),
        arrCategoryCheckList = List<Widget>();
    double width = MediaQuery.of(context).size.width;
    if (arrBrandList.length != null) {
      for (var i = 0; i < arrBrandList.length; i++) {
        if (arrBrandCheckValue == null) {
          arrBrandCheckValue = List.filled(arrBrandList.length, false);
        }
        for (var p = 0; p < arrSelectedBrands.length; p++) {
          if (arrBrandList[i]["strName"] == arrSelectedBrands[p])
            arrBrandCheckValue[i] = true;
        }
        arrBrandCheckLists.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: arrBrandCheckValue[i],
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) {
                arrBrandCheckValue[i] = value;
                setState(() {
                  if (value) arrSelectedBrands.add(arrBrandList[i]["strName"]);
                  else  arrSelectedBrands.remove(arrBrandList[i]["strName"]);
                });
              },
            ),
            Text(arrBrandList[i]["strName"]),
          ],
        ));
      }
    }
    if (arrCategoryList.length != null) {
      for (var j = 0; j < arrCategoryList.length; j++) {
        if (arrCategoyCheckValue == null)
          arrCategoyCheckValue = List.filled(arrCategoryList.length, false);
        for (var k = 0; k < arrSelectedCategory.length; k++) {
          if (arrCategoryList[j]["strName"] == arrSelectedCategory[k])
            arrCategoyCheckValue[j] = true;
        }
        arrCategoryCheckList.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: arrCategoyCheckValue[j],
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) {
                arrCategoyCheckValue[j] = value;
                setState(() {
                  if (value)
                    arrSelectedCategory.add(arrCategoryList[j]["strName"]);
                  else {
                    arrSelectedCategory.remove(arrCategoryList[j]["strName"]);
//                    for(var a=0;a<arrSelectedCategory.length;a++){
//                      if(arrCategoryList[j]["strName"]){}
//                    }
                  }
                });
              },
            ),
            Text(arrCategoryList[j]["strName"]),
          ],
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                minWidth: ((width) / 2),
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              ButtonTheme(
                // minWidth: ((width - 60.0) / 2),
                minWidth: ((width) / 2),
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    'Apply',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WomensWear("Filter Products", {
                                "arrBrands": arrSelectedBrands,
                                "arrCategory": arrSelectedCategory
                              })),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
              child: Text(
                'Brand',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            ListView(
              shrinkWrap: true,
              children: arrBrandCheckLists,
                 physics: NeverScrollableScrollPhysics()
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              height: 1.0,
            ),
            ListView(shrinkWrap: true, children: arrCategoryCheckList, physics: NeverScrollableScrollPhysics())
          ],
        ),
      ),
    );
  }
}
