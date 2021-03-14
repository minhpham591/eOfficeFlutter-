import 'dart:convert';
import 'dart:ui';

import 'package:EOfficeMobile/model/account_model.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:http/http.dart' as http;

LoginResponseModel value;
AccountRequestModel _accountRequestModel = new AccountRequestModel();

class ChangeProfile extends StatelessWidget {
  ChangeProfile(LoginResponseModel _value) {
    value = _value;
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String oldPassword;
  String newPassword;
  String newPasswordConfirm;

  Future<void> getContractByID(BuildContext context) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/accounts/${value.id}";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "text/plain",
        'Authorization': 'Bearer ${value.token}'
      },
    );
    if (response.statusCode == 200) {
      String pass =
          AccountResponseModel.fromJson(json.decode(response.body)).password;
      if (md5.convert(utf8.encode(oldPassword.trim())).toString() ==
          pass.toString()) {
        if (newPassword != newPasswordConfirm) {
          showAlertWrongConfirmPassword(context);
        } else {
          _accountRequestModel.id = value.id;
          _accountRequestModel.oldPassword = oldPassword;
          _accountRequestModel.newPassword = newPassword;
          updatePassword(_accountRequestModel, context);
        }
      } else {
        _showToast(context);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updatePassword(
      AccountRequestModel accountRequestModel, BuildContext context) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/accounts/changepassword";
    var body = json.encode(accountRequestModel.toJson());
    print(body);
    final response = await http.put(url,
        headers: <String, String>{
          "Accept": "*/*",
          "content-type": "application/json-patch+json",
          'Authorization': 'Bearer ${value.token}'
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      showAlertSuccessUpdatePassword(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
  );
  TextStyle style1 = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20,
      color: Colors.blue,
      fontWeight: FontWeight.bold);
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
        FlutterRestart.restartApp();
      },
    );
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
          if (!formKey.currentState.validate()) {
            return;
          } else {
            getContractByID(context);
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
      key: _scaffoldKey,
      body: Container(
        color: Color.fromRGBO(238, 237, 237, 0.5),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    "assets/images/3.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  child: Text(
                    'Change the password',
                    style: style1,
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Old Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (String value) {
                    oldPassword = value.trim();
                  },
                  onSaved: (String value) {
                    oldPassword = value.trim();
                  },
                ),
                SizedBox(height: 10),
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
                    if (value.trim().isEmpty) {
                      return 'Password is not empty';
                    } else if (!regexPassword.hasMatch(value.trim())) {
                      return 'Password is had more than 8 character, at least 1\n uppercase, not contain special character!!!';
                    } else {
                      newPassword = value.trim();
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    newPassword = value.trim();
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Confirm New Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Password is not empty';
                    } else if (!regexPassword.hasMatch(value.trim())) {
                      return 'Password is had more than 8 character, at least 1\n uppercase, not contain special character!!!';
                    } else {
                      newPasswordConfirm = value.trim();
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    newPasswordConfirm = value.trim();
                  },
                ),
                SizedBox(height: 10),
                nextButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        content: const Text('Old Password is wrong!!!'),
      ),
    );
  }
}
