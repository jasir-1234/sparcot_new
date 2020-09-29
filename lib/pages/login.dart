import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/Animation/fadeIn.dart';
import 'package:sparcotbtc/Api/api.dart';
import 'package:sparcotbtc/pages/forgot_password.dart';
import 'package:sparcotbtc/pages/signup.dart';

import 'spashscreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Initially password is obscure
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var blnProgressBar = false;
  String strProgressMessage = "";

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0, right: 30.0, left: 30.0),
              child: FadeIn(
                1.0,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alatsi',
                      ),
                    ),
                    InkWell(
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alatsi',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 50.0, left: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeIn(
                    1.2,
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage('assets/Sparcot_icon.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeIn(
                          1.4,
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Username or Email Address',
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.6,
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: _viewPassword,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                            ),
                            obscureText: _obscureText,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FadeIn(
                          1.8,
                          Container(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Alatsi',
                                  fontSize: 15.0,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0),
                  FadeIn(
                    2.0,
                    InkWell(
                        child: Container(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.grey[300],
                            color: Colors.white,
                            borderOnForeground: false,
                            elevation: 5.0,
                            child: GestureDetector(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    blnProgressBar
                                        ? _showProgress()
                                        : Icon(
                                            Icons.check,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    blnProgressBar
                                        ? Container()
                                        : Text(
                                            "LOG IN",
                                            style: TextStyle(
                                              fontFamily: 'Alatsi',
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          var email = emailController.text;
                          var password = passwordController.text;
                          final FirebaseMessaging _fcm = FirebaseMessaging();
                          String strFirbaseToken = await _fcm.getToken();
                          if (emailController.text.toString().isEmpty ||
                              passwordController.text.toString().isEmpty) {
                          } else {
                            strProgressMessage = "LOADING...";
                            blnProgressBar = true;
                            setState(() {});
                            var rsp = await loginUser(
                                email, password, strFirbaseToken);
                            var status = rsp['blnAPIStatus'];
                            print(rsp);
                            if (status.toString().trim() == "true") {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("userName", rsp['strName']);
                              prefs.setString("userNumber", rsp['strMobileNo']);
                              prefs.setString("userId", rsp['_id']);
                              prefs.setString("userToken", rsp['strToken']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()),
                              );
                            } else {
                              strProgressMessage = "";
                              blnProgressBar = false;
                              if (rsp["arrErrors"].toString() ==
                                  "[INVALID_USER_NAME]") {
                                print("fail");
                                Fluttertoast.showToast(
                                    msg: "Invalid Username !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }

                              if (rsp["arrErrors"].toString() ==
                                  "[CREDENTIAL_INVALID]") {
                                print("fail");
                                Fluttertoast.showToast(
                                    msg: "Invalid Password !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                              if (rsp["arrErrors"].toString() ==
                                  "[INVALID_USER_TYPE]") {
                                print("fail");
                                Fluttertoast.showToast(
                                    msg: "Invalid User !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }

                              setState(() {});
                            }
                          }
                          ;
                        }),
                  ),

                  FadeIn(
                    2.2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t Have an Account?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                            fontFamily: 'Alatsi',
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 18.0,
                              fontFamily: 'Alatsi',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
//                SizedBox(
////                  height: 15.0,
////                ),
////                FadeIn(2.4, Text(
////                  "Continue with",
////                  style: TextStyle(
////                    color: Colors.grey,
////                    fontSize: 18.0,
////                    fontFamily: 'Alatsi',
////                    fontWeight: FontWeight.bold,
////                  ),
////                ),
////            ),
//                SizedBox(
//                  height: 15.0,
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    FadeIn(2.6, InkWell(
//                      child: Container(
//                        width: 60.0,
//                        height: 60.0,
//                        decoration: new BoxDecoration(
//                          color: Theme.of(context).primaryColor,
//                          image: new DecorationImage(
//                            image: new AssetImage('assets/google_plus.png'),
//                            fit: BoxFit.cover,
//                          ),
//                          borderRadius:
//                              new BorderRadius.all(new Radius.circular(30.0)),
//                          border: new Border.all(width: 0.0),
//                        ),
//                      ),
//                      onTap: () {},
//                    ),
//                ),
//                    SizedBox(
//                      width: 18.0,
//                    ),
//                    FadeIn(2.8, InkWell(
//                      child: Container(
//                        width: 60.0,
//                        height: 60.0,
//                        decoration: new BoxDecoration(
//                          color: const Color(0xff7c94b6),
//                          image: new DecorationImage(
//                            image: new AssetImage('assets/fb.png'),
//                            fit: BoxFit.cover,
//                          ),
//                          borderRadius:
//                              new BorderRadius.all(new Radius.circular(30.0)),
//                          border: new Border.all(width: 0.0),
//                        ),
//                      ),
//                      onTap: () {},
//                    ),
//                ),
//                  ],
//                ),
//                SizedBox(
//                  height: 15.0,
//                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showProgress() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFoldingCube(
            color: Theme.of(context).primaryColor,
            size: 20.0,
          ),
          SizedBox(height: 10.0),
          Text(
            strProgressMessage,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10.0,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // user defined function for Logout Dialogue
  void _showDialog(strMessage, strDiscription, intDelay) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        color: Theme.of(context).primaryColorLight, width: 5.0),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  strMessage,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  strDiscription,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {});
    });
  }
}
