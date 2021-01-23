import 'dart:ui';

import 'package:EOfficeMobile/enterOTPForgotPasswordd.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatelessWidget {
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
          MaterialPageRoute(builder: (context) => enterOTPForgotPassword()),
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
        if (value.isEmpty) {
          return 'Please enter phone number';
        } else if (!regexPhone.hasMatch(value)) {
          return 'Phone number is not correct';
        }
        return null;
      },
      onSaved: (String value) {
        phone = value;
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
                  SizedBox(height: 45),
                  phoneField,
                  SizedBox(height: 25),
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
