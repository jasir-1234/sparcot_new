import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sparcotbtc/Api/ForgetPassApi.dart';
import 'package:sparcotbtc/Api/VerfiyOtpApi.dart';
import 'package:sparcotbtc/pages/forgetpass_otpreg.dart';
import 'package:sparcotbtc/pages/signup.dart';
import 'package:sparcotbtc/pages/login.dart';

//My Own Imports
import 'package:sparcotbtc/Animation/fadeIn.dart';

import 'otp_register.dart';

class ForgotPasswordOtp extends StatefulWidget {


  final String usrName;
  final String mobNum;
  final String strDetail;

  ForgotPasswordOtp({Key key, this.usrName, this.mobNum,this.strDetail}) : super(key: key);
  @override
  _ForgotPasswordStatee createState() => _ForgotPasswordStatee();
}

class _ForgotPasswordStatee extends State<ForgotPasswordOtp> {
  bool _obscureText = true;
  bool _formvalidate = false;
  final otpController = TextEditingController();
  final pwdController = TextEditingController();



  void _viewPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void formValidate() {
    if (pwdController.text.length < 6)
      _formvalidate = false;

    else
      _formvalidate = true;
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
                  Text(
                    "Confirm Otp",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
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

                SizedBox(height: 30.0),
                Text(
                  'An OTP have been sent to ' + widget.mobNum.toString(),
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15.0,
                    fontFamily: 'Alatsi',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FadeIn(
                  1.4,
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(

                      hintText: 'ENTER OTP',
                      contentPadding:
                      const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),

                FadeIn(
                  1.4,
                  TextField(
                    controller: pwdController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      errorText: pwdController.text.length < 6
                          ? "Min  6 characters Required"
                          : null,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: _viewPassword,
                      ),
                      hintText: 'NEW PASSWORD',
                      contentPadding:
                      const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    ),
                  ),
                ),

                SizedBox(height: 50.0),
                FadeIn(
                  1.6,
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
                                  "SUBMIT",
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
                      if(otpController.text.toString().isNotEmpty &&  pwdController.text.toString().isNotEmpty){
                        var rsp = await verifyOtp(
                            widget.usrName.toString(), pwdController.text.toString(), otpController.text.toString(),widget.strDetail.toString());
                        var status = rsp['blnAPIStatus'];
                        print("staaaaaaaaaaaaaaat");
                        print(widget.strDetail.toString());
                        print(rsp);
                        if(status.toString().trim() == "true"){
                          Fluttertoast.showToast(
                              msg: "Password Changed!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,

                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 12.0
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );

                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Password Resetting Failed!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,

                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 12.0
                          );
                        }

                      }else{
                        Fluttertoast.showToast(
                            msg: "Invalid Feilds!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,

                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 12.0
                        );
                      }

                    },
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                FadeIn(
                  1.8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Go To',
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
}
