import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparcotbtc/pages/login.dart';
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

//My Own Imports
import 'package:sparcotbtc/Animation/fadeIn.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _formvalidate = false;
  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
  final mobileController = TextEditingController();
  final whatsAppController = TextEditingController();
  final officeNoAppController = TextEditingController();
  final shopeController = TextEditingController();
  final gstController = TextEditingController();
  final pinCodeController = TextEditingController();
  final addressController = TextEditingController();

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _viewPassword1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void formValidate() {
    if (emailController.text.isEmpty)
      _formvalidate = false;
    else if (userController.text.length < 4)
      _formvalidate = false;
    else if (passwordController.text.length < 6)
      _formvalidate = false;
    else if (mobileController.text.length < 10)
      _formvalidate = false;
    else if (whatsAppController.text.length < 10)
      _formvalidate = false;
    else if (shopeController.text.length < 4)
      _formvalidate = false;
    else if (pinCodeController.text.length < 6)
      _formvalidate = false;
    else if (gstController.text.length < 14)
      _formvalidate = false;
    else
      _formvalidate = true;
  }

  createRetailer(objReqBody) async {
    //get token from shared prefrence
    final url = baseUrl + strOpenPort + strRegisterUser;
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{...objReqBody}));
    var objResponse = await json.decode(response.body);
    print("resposssssseeeeeeeeeeeee");
    print(objResponse);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      //for accepting only json response
      Fluttertoast.showToast(
          msg: "Retailer Registration Succesfully Completed!!\n Our  Executive will Call you",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,

          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
//      _showDialog(
//          "Success",
//          "Retailer Registration Succesfully Completed!!\n Our  Executive will Call you",
//          "Close");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      if (objResponse["errCommon"] != null) {
        var objErrors = {
          "KEY_DUPLICATE": "User name/Email/Mobile Number Duplicate"
        };
        objResponse["errCommon"][0]["strMessage"] == "KEY_DUPLICATE"
            ? _showDialog("Fail",
                objErrors[objResponse["errCommon"][0]["strMessage"]], "Rentry")
            : null;
      } else {
      var err=   objResponse["arrErrors"].toString();
      if(err=="[USER NAME ALREADY EXIST]"){
        err= "Username already exist ! ";
      }
      if(err=="[MOBILE NUMBER ALREADY EXIST]"){
        err= "Mobile number already exist ! ";
      }
      if(err!="[USER NAME ALREADY EXIST]" || err!="[MOBILE NUMBER ALREADY EXIST]")  {
          err = "Something went wrong !";
    }


        _showDialog("Fail", err, "Rentry");
      }
      print(objResponse["errCommon"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 70.0, right: 30.0, left: 30.0),
            child: FadeIn(
              1.0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      "Login",
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
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  ),
                  Text(
                    'Sign Up',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alatsi',
                    ),
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
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            errorText: emailController.text.isEmpty
                                ? 'Invalid Email Address'
                                : null,
                            hintText: 'Email Address',
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: userController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            errorText: userController.text.isEmpty
                                ? 'Invalid User Name'
                                : null,
                            hintText: 'Username',
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: mobileController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            errorText: mobileController.text.length != 10
                                ? 'Invalid Mobile Number'
                                : null,
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: whatsAppController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            errorText: whatsAppController.text.length != 10
                                ? 'Invalid WhatsApp  Number'
                                : null,
                            hintText: 'WhatsApp Number',
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: officeNoAppController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Office Number',
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: shopeController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Shope Name',
                            errorText: shopeController.text.isEmpty
                                ? 'Invalid Shope Name'
                                : null,
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: gstController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'GST',
                            errorText: gstController.text.length < 15
                                ? "Enter  15 digit valid GST Number"
                                : null,
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: pinCodeController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'PIN code',
                            errorText: pinCodeController.text.isEmpty
                                ? 'Invalid Pin Code'
                                : null,
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.4,
                        TextField(
                          controller: addressController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Address',
                            errorText: addressController.text.isEmpty
                                ? 'Invalid Address'
                                : null,
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            errorText: passwordController.text.length < 6
                                ? "Min  6 characters Required"
                                : null,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: _viewPassword,
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                          obscureText: _obscureText,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FadeIn(
                        1.8,
                        TextField(
                          controller: repasswordController,
                          decoration: InputDecoration(
                            hintText: 'Repeat Password',
                            errorText: repasswordController.text !=
                                    passwordController.text
                                ? 'Password Mismatch'
                                : null,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: _viewPassword1,
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          ),
                          obscureText: _obscureText1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
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
                                Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontFamily: 'Alatsi',
                                    color: Theme.of(context).primaryColor,
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
                      await this.formValidate();
                      if (_formvalidate) {
                        var objReqBody = await {
                          "strName": userController.text.toString().trim(),
                          "strMobileNo":
                              mobileController.text.toString().trim(),
                          "strEmail": emailController.text.toString().trim(),
                          "strPassword":
                              passwordController.text.toString().trim(),
                          "arrAddress": [
                            {
                              "strAddress":
                                  addressController.text.toString().trim(),
                              "strPinCode":
                                  pinCodeController.text.toString().trim()
                            }
                          ],
                          "strGSTNo": gstController.text.trim(),
                            "strType": "RETAILER",
                          "strShopName": shopeController.text.toString().trim(),
                          "strWhatsAppNumber": whatsAppController.text.trim(),
                          "strOfficeNumber": officeNoAppController.text.trim()
                        };
                        await this.createRetailer(objReqBody);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                FadeIn(
                  2.2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account?',
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
                          'Login',
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
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(strResult, strDetails, strButton) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            strResult,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(strDetails),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
//            FlatButton(
//              child: Text(
//                "Close",
//                style: TextStyle(
//                  color: Theme.of(context).primaryColor,
//                ),
//              ),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),

            FlatButton(
              child: Text(
                strButton,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () async {
                if (strButton != "Rentry")
                  Navigator.of(context).pop();
                else
                  Navigator.push(context, SlideLeftRoute(page: Login()));
              },
            ),
          ],
        );
      },
    );
  }
}
