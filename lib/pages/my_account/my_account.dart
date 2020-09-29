import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparcotbtc/pages/faq_and_about_app/about_app.dart';
import 'package:sparcotbtc/pages/faq_and_about_app/faq.dart';

// My Own Imports
import 'package:sparcotbtc/pages/login.dart';
import 'package:sparcotbtc/pages/my_account/account_setting.dart';
import 'package:sparcotbtc/pages/my_orders.dart';
import 'package:sparcotbtc/pages/notifications.dart';
import 'package:sparcotbtc/pages/my_account/profile_address.dart';
import 'package:sparcotbtc/Animation/slide_left_rout.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var objUserDetails = null;

  @override
  void initState() {
    super.initState();
    this.getUserDetails();
    setState(() {});
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            width: width,
            height: 200.0,
            child: Stack(
              children: <Widget>[
//                Image(
//                  image: AssetImage('assets/user_profile/background.jpg'),
//                  width: width,
//                  height: 220.0,
//                  fit: BoxFit.cover,
//                ),
                Positioned(

                  right: ((width / 2) - 50.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 110.0,
                        width: 110.0,
                        alignment: Alignment.center,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(55.0),
//                          border: Border.all(color: Colors.white, width: 5.0),
//                        ),
//                        child: ClipRRect(
//                          borderRadius: new BorderRadius.circular(50.0),
//                          child: Image(
//                            image: objUserDetails != null
//                                ? NetworkImage(objUserDetails["strImageUrl"])
//                                : AssetImage('assets/Sparcot_icon.jpg'),
//                            height: 100.0,
//                            width: 100.0,
//                          ),
//                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          objUserDetails != null
                              ? objUserDetails["strName"]
                              : "",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          child: Text(
                            'Edit Profile',
                            style:
                            TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                SlideLeftRoute(page: Profile(objUserDetails)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: Notifications()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.bell,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: MyOrders()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.truck,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      child: Text(
                        'My Orders',
                        style:
                        TextStyle(fontSize: 20.0),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyOrders()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: Profile(objUserDetails)));
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.cogs,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      child: Text(
                        'Account Settings',
                        style:
                         TextStyle(fontSize: 20.0),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            SlideLeftRoute(page: Profile(objUserDetails)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: FaqPage()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.questionCircle,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'FAQ',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, SlideLeftRoute(page: AboutApp()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.info,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'About App',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30.0, left: 70.0),
            child: Divider(
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
