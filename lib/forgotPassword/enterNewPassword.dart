import 'dart:convert';

import 'package:EOfficeMobile/main.dart';
import 'package:flutter/material.dart';
import 'package:EOfficeMobile/model/account_model.dart';
import 'package:http/http.dart' as http;

String _email;
ForgotPasswordRequestModel _accountRequestModel =
    new ForgotPasswordRequestModel();
String newPassword;
String newPasswordConfirm;

class EnterNewPassword extends StatelessWidget {
  EnterNewPassword(String email) {
    _email = email;
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RegExp regexPassword =
      new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  showAlertWrongConfirmPassword(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      color: Colors.red,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Wrong"),
      content: Text("Password confirm is not correct!!!"),
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

  showAlertSuccessUpdatePassword(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      color: Colors.blue[900],
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
          ModalRoute.withName('/MyApp'),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Changed Password Successfully"),
      content: Text("Your new password is update"),
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

  Future<void> updatePassword(ForgotPasswordRequestModel accountRequestModel,
      BuildContext context) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/accounts/forgotpassword";
    var body = json.encode(accountRequestModel.toJson());
    print(body);
    final response = await http.put(url,
        headers: <String, String>{
          "Accept": "*/*",
          "content-type": "application/json-patch+json",
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      showAlertSuccessUpdatePassword(context);
    } else {
      showAlertSuccessUpdatePassword(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          _accountRequestModel.email = _email;

          if (!formKey.currentState.validate()) {
            return;
          } else {
            if (newPassword != newPasswordConfirm) {
              showAlertWrongConfirmPassword(context);
            } else {
              updatePassword(_accountRequestModel, context);
            }
          }
        },
        child: Text(
          "Update",
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
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    style: style,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "New Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (String value) {
                      value = value.trim();
                      if (value.isEmpty) {
                        return 'Password is not empty';
                      } else if (!regexPassword.hasMatch(value)) {
                        return 'Password is had more than 8 character, at least 1\n uppercase, not contain special character!!!';
                      } else {
                        newPassword = value;
                        _accountRequestModel.newPassword = value;
                      }
                    },
                    onSaved: (String value) {
                      newPassword = value;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    style: style,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Confirm New Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    validator: (String value) {
                      value = value.trim();
                      if (value.isEmpty) {
                        return 'Password is not empty';
                      } else if (!regexPassword.hasMatch(value)) {
                        return 'Password is had more than 8 character, at least 1\n uppercase, not contain special character!!!';
                      } else {
                        newPasswordConfirm = value;
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      newPasswordConfirm = value;
                    },
                  ),
                  SizedBox(height: 10),
                  nextButton,
                  SizedBox(
                    height: 14,
                    child: Text(
                      "-------------step 3 of 3-------------",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                    child: Text(
                      "If you change your password by mistake - return to the",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Material(
                    elevation: 0,
                    color: Color.fromRGBO(238, 237, 237, 0),
                    child: MaterialButton(
                      height: 2,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          ModalRoute.withName('/MyApp'),
                        );
                      },
                      child: Text(
                        "main page",
                        textAlign: TextAlign.center,
                      ),
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
