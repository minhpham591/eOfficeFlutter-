import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class EnterOTPToSignInvoice extends StatelessWidget {
  String phone;
  String verificationId;
  EnterOTPToSignInvoice(String _phone, String _vertificationId) {
    phone = _phone;
    verificationId = _vertificationId;
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String pin = null;
  RegExp regexPin = new RegExp(r'(^(?:[+0]9)?[0-9]{6,6}$)');

  @override
  Widget build(BuildContext context) {
    final OTPtextField = OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 50,
      style: TextStyle(fontSize: 14),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (value) {
        pin = value;
      },
      onChanged: (value) {
        pin = value;
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
          FirebaseAuth.instance
              .signInWithCredential(PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: pin))
              .then((value) async {
            if (value.user != null) {
              Navigator.pop(context);
            } else {
              _showToast(context);
            }
          });
        },
        child: Text(
          "Verifying",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Forgot Password"),
      //   backgroundColor: Colors.blue[900],
      // ),
      body: Center(
        child: Container(
          color: Color.fromRGBO(238, 237, 237, 0.5),
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Confirm OTP",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 45),
                OTPtextField,
                SizedBox(height: 25),
                nextButton,
                SizedBox(height: 15),
                SizedBox(
                  height: 15,
                  child: Text(
                    "-------------step 2 of 3-------------",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: Text(
                    "If you do not see a letter with a code in your mail, please check your SPAM folder or SEND OTP AGAIN?",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 45),
        content: const Text('OTP is wrong!!!'),
        action: SnackBarAction(
            label: "",
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
