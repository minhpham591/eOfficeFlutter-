import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:EOfficeMobile/forgotPassword/enterOTPForgotPasswordd.dart';
import 'package:flutter/material.dart';

void otp() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: '+84355324555',
    codeSent: (String verificationId, int resendToken) async {
      // Update the UI - wait for the user to enter the SMS code
      String smsCode = 'xxxx';

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(phoneAuthCredential);
    },
  );
}

class ForgotPassword extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phone;
  RegExp regexPhone = new RegExp(r'(^(?:[+0]9)?[0-9]{10,10}$)');

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
        otp();
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
    // final userNameField = TextFormField(
    //   obscureText: false,
    //   style: style,
    //   decoration: InputDecoration(
    //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       hintText: "Please enter Username",
    //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    //   validator: (String value) {
    //     value = value.trim();
    //     if (value.isEmpty) {
    //       return 'Please enter Username';
    //     }
    //     return null;
    //   },
    //   onSaved: (String value) {
    //     phone = value;
    //   },
    // );
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
            showAlertPhoneSuccess(context);
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
      // appBar: AppBar(
      //   title: Text("Forgot Password"),
      //   backgroundColor: Colors.blue[900],
      // ),
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