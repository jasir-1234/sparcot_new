import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sparcotbtc/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var objModuleSettings = null;
  var objMasters = null;
  var arrBabyCare = null;
  var arrKicten = null;
  var arrFoodCare = null;
  var arrBannerImages = null;

  @override
  void initState() {
    this.getBabyCare({
      "intLimit": 4,
      "intPageNo": 0,
      "arrCategory": ["BABY CARE"]
    });
    this.getKichen({
      "intLimit": 4,
      "intPageNo": 0,
      "arrCategory": ["KITCHEN COLLECTIONS"]
    });
    this.getFoodCare({
      "intLimit": 4,
      "intPageNo": 0,
      "arrCategory": ["CLEANING SOLUTIONS"]
    });
    this.getmasters();
    this.getModuleSettings();
    _function();
    super.initState();
  }

  Future<Null> getBabyCare(objCinditions) async {
    String url = baseUrl + strOpenPort + strProductListEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          ...objCinditions
        })); //for accepting only json response
    var convertDataToJson = await json.decode(response.body);
    arrBabyCare = await convertDataToJson['arrList'];
  }

  Future<Null> getmasters() async {
    String url = baseUrl + strOpenPort + strGetMasterEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          "arrCollection": [
            {"strCollection": "cln_category", "intLimit": 10},
            {"strCollection": "cln_brand", "intLimit": 10}
          ]
        })); //for accepting only json response
    objMasters = await json.decode(response.body);
  }

  Future<Null> getKichen(objCinditions) async {
    String url = baseUrl + strOpenPort + strProductListEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          ...objCinditions
        })); //for accepting only json response
    var convertDataToJson = await json.decode(response.body);
    arrKicten = await convertDataToJson['arrList'];
  }

  Future<Null> getFoodCare(objCinditions) async {
    String url = baseUrl + strOpenPort + strProductListEndPoint;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{
          ...objCinditions
        })); //for accepting only json response
    var convertDataToJson = await json.decode(response.body);
    arrFoodCare = await convertDataToJson['arrList'];
  }

  Future<Null> getModuleSettings() async {
    String url = baseUrl + strOpenPort + strModuleSettings;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, String>{
          "strModule": "mdl_sparco_home"
        })); //for accepting only json response
    objModuleSettings = await json.decode(response.body);
    if (objModuleSettings != null) {
      if (objModuleSettings["arrBanners"] != null) {
        arrBannerImages = [];
        for (var i = 0; i < objModuleSettings["arrBanners"].length; i++) {
          await arrBannerImages.add(
              NetworkImage(objModuleSettings["arrBanners"][i]["strImageUrl"]));
        }
      }
    }
    setState(() {

    });
  }

  SharedPreferences prefs;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userToken") != null) {
      if (objModuleSettings != null &&
          objMasters != null &&
          arrBabyCare != null &&
          arrKicten != null &&
          arrBannerImages != null &&
          arrFoodCare != null) {
        if (prefs.getString("userToken") != null) {
          print("lllllllllllllllllllll");
          print(arrFoodCare);
          new Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(objModuleSettings, objMasters,
                      arrBabyCare, arrKicten, arrFoodCare, arrBannerImages)),
            );
          });


        } else {
          print('true');
          print("lllllllllllllllllllll");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } else {
        new Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(objModuleSettings, objMasters,
                    arrBabyCare, arrKicten, arrFoodCare, arrBannerImages)),
          );
        });
      }

    }

    else {
      print('true');
      print("lllllllllllllllllllll");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage(
                          'assets/Sparcot_icon.jpg',
                        ),
                        width: 65.0,
                        height: 65.0,
                      ),
//                      CircleAvatar(
////                        backgroundColor: Colors.white,
//                        radius: 50.0,
//                        child: Image(
//                          image: AssetImage(
//                            'assets/Sparcot_icon.jpg',
//                          ),
//                          width: 65.0,
//                          height: 65.0,
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(top: 10.0),
//                      ),
                      Text(
                        "Sparcot",
                        style: TextStyle(
                            fontFamily: 'Pacifico',
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitFoldingCube(
                      color: Theme.of(context).primaryColor,
                      size: 35.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Experience \n The Quality',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
