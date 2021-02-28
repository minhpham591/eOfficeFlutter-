import 'dart:ui';

import 'package:EOfficeMobile/forgotPassword/enterNewPassword.dart';
import 'package:EOfficeMobile/forgotPassword/enterOTPForgotPasswordd.dart';
import 'package:base32/base32.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<ForgotPassword> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone;
  String smsOTP;
  String verificationId;
  int otp;
  int forceCode;
  int date;
  String errorMessage = '';
  RegExp regexPhone = new RegExp(r'(^(?:[+0]9)?[0-9]{10,10}$)');
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      this.forceCode = forceCodeResend;
      this.date = DateTime.now().millisecondsSinceEpoch;
      // Sign the user in (or link) with the credential
      otp = OTP.generateTOTPCode(base32.encodeString(verificationId), date);
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phone, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),

          // Sign the user in (or link) with the credential

          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EnterNewPassword()),
              ModalRoute.withName('/'),
            );
          },
          verificationFailed: (Exception exceptio) {
            print(exceptio);
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
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  print(smsOTP);
                  print(verificationId);
                  print(otp);
                },
              )
            ],
          );
        });
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  showAlertPhoneSuccess(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Continue"),
      color: Colors.blue[900],
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => EnterOTPForgotPassword(phone)),
          ModalRoute.withName('/'),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text("Phone number is correct!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Please enter Phone number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (String value) {
        value = value.trim();
        if (value.isEmpty) {
          return 'Please enter phone number';
        } else if (!regexPhone.hasMatch(value)) {
          return 'Phone number is not correct';
        } else {
          phone = "+84" + value.substring(1);
        }
        return null;
      },
    );
    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          if (!formKey.currentState.validate()) {
            return;
          } else {
            //showAlertPhoneSuccess(context);
            verifyPhone();
            print(phone);
          }
        },
        child: Text(
          "Send OTP",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromRGBO(238, 237, 237, 0.5),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 110,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 30),
                  // userNameField,
                  // SizedBox(height: 15),
                  phoneField,
                  SizedBox(height: 15),
                  nextButton,
                  SizedBox(height: 15),
                  SizedBox(
                    height: 15,
                    child: Text(
                      "-------------step 1 of 3-------------",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Text(
                      "If you do not see an email with a code in your mail, check your SPAM folder",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
