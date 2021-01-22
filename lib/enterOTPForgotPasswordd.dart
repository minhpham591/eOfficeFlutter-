import 'package:EOfficeMobile/enterNewPassword.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:form_validator/form_validator.dart';

class enterOTPForgotPassword extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String pin = null;
  RegExp regexPin = new RegExp(r'(^(?:[+0]9)?[0-9]{6,6}$)');
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Wrong"),
      content: Text("OTP is WRONG!!!!"),
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
        if (pin == null) {
          style:
          TextStyle(backgroundColor: Colors.red);
        } else if (!regexPin.hasMatch(pin)) {
          style:
          TextStyle(backgroundColor: Colors.red);
        }
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
          if (pin == null) {
            //showAlertDialog(context);
          } else if (!regexPin.hasMatch(pin)) {
            //showAlertDialog(context);
          } else {
            print("pass");
            pin = null;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => enterNewPassword()),
            );
          }
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
}
