import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// My Own Imports
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:sparcotbtc/pages/cart.dart';
import 'package:sparcotbtc/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int notification = 2;
  var data = null;
  var title = "";
  var descp = "";
  List length = [];
  @override
  void initState() {
    setState(() {});
    super.initState();
    this.getNotificationList();
  }
  Future<String> getNotificationList() async {
    //get token from shared prefrence
    var prefs = await SharedPreferences.getInstance();
    var strToken = prefs.getString('userToken') ?? "";
    String url = baseUrl + strAdminPort + strGetNotification;
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Content-Type": "application/json",
      "Authorization": strToken
    });
    var objResponse = json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      data = objResponse["arrList"];
    }

    data = objResponse["arrList"];
    length = objResponse["arrList"];

    print(data);
    print("dataaaaaaaaaaaaaaaaaaa");



    //for accepting only json response
    setState(() {});
    return "Success";
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Notifications'),
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Badge(
              badgeContent: Text('3'),
              badgeColor: Theme.of(context).primaryColorLight,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(context, SlideLeftRoute(page: CartPage()));
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF1F3F6),
      body: (length.length == 0)
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.bellSlash,
                  color: Colors.grey,
                  size: 60.0,
                ),
                SizedBox(height: 10.0,),
                Text('No Notifications',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                )
              ],
            ),
            )
          : ListView.builder(

        itemCount: data != null ? data.length : 0,
        itemBuilder:( context ,  index) {
          final item = data != null ? data[index] : null;
          var strDocId = item['strType'];
          title = item['tittle'];
          descp = item['body'];
          print(strDocId);
                return Container(
                  key: Key('$item'),
//                  onDismissed: (direction) {
//                    setState(() {
//                      data.removeAt(index);
//                      notification--;
//                    });
//
//                    // Then show a snackbar.
//                    Scaffold.of(context).showSnackBar(
//                        SnackBar(content: Text(title + " CLEARED")));
//                  },
//                  // Show a red background as the item is swiped away.
//                  background: Container(color: Colors.red),
                  child: Container(
                    child: Card(
                      elevation: 2.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              child: Icon(FontAwesomeIcons.bell,
                                size: 30.0,
                              ),
                              radius: 40.0,
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
                                   title,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0,
                                      right: 8.0,
                                      left: 8.0,
                                      bottom: 8.0),
                                  child: Text(
                                    descp,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      height: 1.6,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
