import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sparcotbtc/Animation/fadeIn.dart';
import 'package:sparcotbtc/Animation/slide_left_rout.dart';
import 'package:sparcotbtc/pages/login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sparcotbtc/utils/constants.dart';

class OTPRegister extends StatefulWidget {
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<OTPRegister> {
  String phoneNo;
  String smsOTP;
  String strRegError = null;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

// Initially password is obscure
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _formvalidate = false;
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
  final mobileController = TextEditingController(text: "+91");
  var blnProgressBar = false;
  String strProgressMessage = "";

  // Toggles the password show status
  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void formValidate() {
    if (userController.text.length < 4)
      _formvalidate = false;
    else if (passwordController.text.length < 6)
      _formvalidate = false;
    else if (mobileController.text.length < 12)
      _formvalidate = false;
    else
      _formvalidate = true;
  }

  createRetailer(objReqBody) async {
    //get token from shared prefrence
    final url = baseUrl + strOpenPort + strRegisterUser;
    var response = await http.post(Uri.encodeFull(url),
        headers: {"Content-Type": "application/json", "strAppInfo": strAppInfo},
        body: jsonEncode(<String, dynamic>{...objReqBody}));
    var objResponse = await json.decode(response.body);
    if (objResponse["blnAPIStatus"].toString() == "true") {
      //for accepting only json response
      strProgressMessage = "OTP Signup Succesfully Completed!!\n Pllease LogIn";
      setState(() {});
//      _showDialog("Success",
//          "OTP Signup Succesfully Completed!!\n Pllease LogIn", "Close");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      if (objResponse["errCommon"] != null) {
        var objErrors = {"KEY_DUPLICATE": "User name/Mobile Number Duplicate"};
        setState(() {
          strRegError = objErrors["KEY_DUPLICATE"];
          strProgressMessage = "User name/Mobile Number Duplicate";
        });
//        objResponse["errCommon"][0]["strMessage"] == "KEY_DUPLICATE"
//            ? _showDialog("Fail",
//                objErrors[objResponse["errCommon"][0]["strMessage"]], "Rentry")
//            : null;
      } else {
        strProgressMessage = "Fail To Register\n Please Try Again";
        //_showDialog("Fail", "Somthin Went Wrong \n Please Try Again", "Rentry");
      }
      setState(() {});
    }
  }

  Future<void> verifyPhone() async {
    setState(() {
      strRegError = "Verify....";
    });
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) async {
        await this.formValidate();
        if (_formvalidate) {
          var objReqBody = await {
            "strName": userController.text.toString().trim(),
            "strMobileNo": mobileController.text.toString().trim(),
            "strPassword": passwordController.text.toString().trim(),
            "arrAddress": [],
            "strType": "CUSTOMER"
          };
          await this.createRetailer(objReqBody);
        }
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (strRegError != null
                    ? Text(
                        strRegError,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container()),
                SizedBox(height: 15.0)
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              new GestureDetector(
                onTap: () async {
                  _auth.currentUser().then((user) {
                    strProgressMessage = "VERIFY";
                    setState(() {});
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.push(context, SlideLeftRoute(page: Login()));
//                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: Text("VERIFY"),
              )
//              InkWell(
//                  child: Container(
//                    height: 45.0,
//                    child: Material(
//                      borderRadius: BorderRadius.circular(20.0),
//                      shadowColor: Colors.grey[300],
//                      color: Colors.white,
//                      borderOnForeground: false,
//                      elevation: 5.0,
//                      child: GestureDetector(
//                        child: Center(
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              blnProgressBar
//                                  ? _showProgress()
//                                  : Icon(
//                                      Icons.check,
//                                      color: Theme.of(context).primaryColor,
//                                    ),
//                              SizedBox(
//                                width: 5.0,
//                              ),
//                              blnProgressBar
//                                  ? Container()
//                                  : Text(
//                                      "VERIFY",
//                                      style: TextStyle(
//                                        fontFamily: 'Alatsi',
//                                        color: Theme.of(context).primaryColor,
//                                        fontSize: 16.0,
//                                        fontWeight: FontWeight.bold,
//                                      ),
//                                    ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  onTap: () async {
//                    _auth.currentUser().then((user) {
//                      strProgressMessage = "VERIFY...";
//                      setState(() {});
//                      if (user != null) {
//                        Navigator.of(context).pop();
//                        Navigator.push(context, SlideLeftRoute(page: Login()));
////                      Navigator.of(context).pushReplacementNamed('/homepage');
//                      } else {
//                        Navigator.of(context).pop();
//                      }
//                    });
//                  }),
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
//      Navigator.of(context).pop();
//      Navigator.of(context).pushReplacementNamed('/homepage');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
          strProgressMessage = "Invalid Code";
        });
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          strProgressMessage = error.message;
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN UP"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 50.0, left: 50.0),
        child: Center(
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
                height: 8.0,
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
                height: 8.0,
              ),
              FadeIn(
                1.4,
                TextField(
                  controller: mobileController,
                  onChanged: (value) {
                    setState(() {});
                    this.phoneNo = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
                    errorText: mobileController.text.length < 12
                        ? 'Invalid Mobile Number'
                        : null,
                    contentPadding:
                        const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
//              SizedBox(
//                height: 10.0,
//              ),
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
                height: 8.0,
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
                                    "SEND OTP",
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
                        blnProgressBar = true;
                        strProgressMessage = "WAITING....";
                        setState(() {});
                        await this.formValidate();
                        if (_formvalidate) verifyPhone();
                      })),
              blnProgressBar ? _showProgress() : Container(),
            ],
          ),
        ),
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

  _showProgress() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFoldingCube(
            color: Theme.of(context).primaryColor,
            size: 18.0,
          ),
          SizedBox(height: 5.0),
          Text(
            strProgressMessage,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15.0,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
