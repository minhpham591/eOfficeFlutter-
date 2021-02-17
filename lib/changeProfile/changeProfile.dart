import 'dart:ui';
import 'package:EOfficeMobile/profile/profile.dart';
import 'package:flutter/material.dart';

class ChangeProfile extends StatelessWidget {
  String oldPassword;
  String newPassword;
  String newPasswordConfirm;
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
          ModalRoute.withName('/MyApp'),
        );
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
            if (newPassword != newPasswordConfirm) {
              showAlertWrongConfirmPassword(context);
            } else {
              showAlertSuccessUpdatePassword(context);
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
                  onSaved: (String value) {
                    oldPassword = value;
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
                    value = value.trim();
                    if (value.isEmpty) {
                      return 'Password is not empty';
                    } else if (!regexPassword.hasMatch(value)) {
                      return 'Password is had more than 8 character, at least 1\n uppercase, not contain special character!!!';
                    } else {
                      newPassword = value;
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    newPassword = value;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
