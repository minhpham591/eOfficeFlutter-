import 'dart:ui';

import 'package:EOfficeMobile/forgotPassword/enterOTPForgotPasswordd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<ForgotPassword> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone;
  String verificationId;
  String errorMessage = '';
  RegExp regexPhone = new RegExp(r'(^(?:[+0]9)?[0-9]{10,10}$)');
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          verificationId = verficationID;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EnterOTPForgotPassword(phone, verificationId)),
            ModalRoute.withName('/'),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  // set up the AlertDialog

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
            _verifyPhone();
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
