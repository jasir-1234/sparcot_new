import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparcotbtc/pages/cart.dart';
import 'package:sparcotbtc/pages/faq_and_about_app/about_app.dart';
import 'package:sparcotbtc/pages/faq_and_about_app/faq.dart';

// My Own Imports
import 'package:sparcotbtc/pages/login.dart';
import 'package:sparcotbtc/pages/my_account/my_account.dart';
import 'package:sparcotbtc/pages/my_orders.dart';
import 'package:sparcotbtc/pages/notifications.dart';
import 'package:sparcotbtc/pages/category/top_offers_pages/women_wears.dart';
import 'package:sparcotbtc/pages/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget  {

  @override
  _DrawState createState() => _DrawState();
}
class _DrawState extends State<MainDrawer> {


 var  btChckLogin = "Login";
  @override
  void initState() {

    this.getCheckLogin();

    setState(() {});
  }

  Future<String> getCheckLogin() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userToken") != null) {
      btChckLogin = "Logout";
      print(btChckLogin);
      setState(() {});
    }


  }
  @override
  Widget build(BuildContext context) {
    var objCondition = {

      "intPageNo":0,
      "intLimit":50

    };

    var objHom = {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["HOME UTILITIES"]
    };

    var objBaby =  {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["BABY CARE"]
    };

    var objFoot = {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["FOOTCARE"]
    };

    var objKitchen = {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["KITCHEN COLLECTIONS"]
    };

    var objTool = {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["POWER TOOLS"]
    };

    var objClean = {
      "intPageNo":0,
      "intLimit":50,
      "arrCategory": ["CLEANING SOLUTIONS"]
    };


    // Logout AlertDialog Start Here
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              "Confirm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Are you Sure you want to Logout?"),
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

              FlatButton(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
          }
          else{
            SharedPreferences prefs =
            await SharedPreferences.getInstance();
            prefs.setString("userName", null);
            prefs.setString("userNumber", null);
            prefs.setString("userId", null);
            prefs.setString("userToken", null);
            SystemNavigator.pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );

          }

                },
              ),
            ],
          );
        },
      );
    }
    // Logout AlertDialog Ends Here

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/sparcot_nav.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.local_offer,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Top Offers',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Top Offers', objCondition)),
                );

              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'My Orders',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: ()async {

                SharedPreferences prefs;
                prefs = await SharedPreferences.getInstance();
                if (prefs.getString("userToken") == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  print('true');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyOrders()),
                  );
                }
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => MyOrders()),
//                );
              },
            ),
            InkWell(
              child: Container (
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'My Cart',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {

                SharedPreferences prefs;
                prefs = await SharedPreferences.getInstance();
                if (prefs.getString("userToken") == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  print('true');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                }

              },
            ),
//            InkWell(
//              child: Container(
//                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
//                child: Row(
//                  children: <Widget>[
//                    Icon(
//                      Icons.favorite,
//                      color: Colors.grey[700],
//                      size: 20.0,
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Text(
//                      'My Wishlist',
//                      style: TextStyle(
//                        color: Colors.grey[700],
//                        fontSize: 15.0,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => WishlistPage()),
//                );
//              },
//            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'My Account',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                SharedPreferences prefs;
                prefs = await SharedPreferences.getInstance();
                if (prefs.getString("userToken") == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  print('true');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAccount()),
                  );
                }
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => MyAccount()),
//                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.notifications,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'My Notification',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {

                SharedPreferences prefs;
                prefs = await SharedPreferences.getInstance();
                if (prefs.getString("userToken") == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                } else {
                  print('true');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                }

              },
            ),
            Divider(
              color: Colors.grey,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.devices,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Home Utilities',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WomensWear(
                          'Home Utilities', objHom )),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.wc,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Baby Care',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Baby Toys', objBaby )),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.format_paint,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Foot Care',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Foot Care', objFoot )),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.tv,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Kitchen Collection',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Kitchen Collection', objKitchen )),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.stay_current_portrait,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Power Tool',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Power Tool', objTool )),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.book,
                      color: Colors.grey[700],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Cleaning Solutions',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WomensWear('Cleaning Solutions', objClean )),
                );
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Text(
                  'FAQ',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaqPage()),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Text(
                  'About App',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutApp()),
                );
              },
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 15.0),
                child: Text(
                  btChckLogin.toString(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15.0,
                  ),
                ),
              ),
              onTap: () {

                _showDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}
