import 'package:EOfficeMobile/forgotPassword/enterNewPassword.dart';
import 'package:EOfficeMobile/forgotPassword/enterOTPResendForgotPasswordd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class EnterOTPForgotPassword extends StatelessWidget {
  String phone;
  String verificationId;
  int countResend;
  EnterOTPForgotPassword(
      String _phone, String _vertificationId, int _countResend) {
    phone = _phone;
    verificationId = _vertificationId;
    countResend = _countResend;
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String pin = null;
  RegExp regexPin = new RegExp(r'(^(?:[+0]9)?[0-9]{6,6}$)');
  _verifyPhone(BuildContext context, String phone, String verificationId,
      int countResend) async {
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
                builder: (context) => EnterOTPResendForgotPassword(
                    phone, verificationId, countResend)),
            ModalRoute.withName('/'),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 120));
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
          try {
            FirebaseAuth.instance
                .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: pin))
                .then((value) async {
              if (value.user != null) {
                print(value.user.email.toString());
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EnterNewPassword(value.user.email.toString())),
                    (route) => false);
              }
            });
          } catch (FirebaseAuthException) {
            _showToast(context);
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
    final resendButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          if (countResend <= 3) {
            countResend++;
            _verifyPhone(context, phone, verificationId, countResend);
          }
        },
        child: Text(
          "Resend $countResend /3",
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
                SizedBox(height: 30),
                OTPtextField,
                SizedBox(height: 25),
                nextButton,
                SizedBox(height: 5),
                resendButton,
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
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 45),
        content: const Text('OTP is wrong!!!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        action: SnackBarAction(
            label: "",
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
