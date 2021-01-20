import 'package:EOfficeMobile/main.dart';
import 'package:EOfficeMobile/restartApp.dart';
import 'package:flutter/material.dart';

class enterNewPassword extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String newPassword;
  String newPasswordConfirm;
  @override
  Widget build(BuildContext context) {
    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {},
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
                TextFormField(
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "New Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Password is not empty';
                    }
                    return null;
                  },
                  onSaved: (String value) {},
                ),
                SizedBox(height: 25),
                TextFormField(
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Confirm New Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Password is not empty';
                    }
                    return null;
                  },
                  onSaved: (String value) {},
                ),
                SizedBox(height: 25),
                nextButton,
                SizedBox(height: 15),
                SizedBox(
                  height: 15,
                  child: Text(
                    "-------------step 3 of 3-------------",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: Text(
                    "If you change your password by mistake - return to the",
                    textAlign: TextAlign.center,
                  ),
                ),
                Material(
                  elevation: 0,
                  color: Color.fromRGBO(238, 237, 237, 0),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      RestarApp.restartApp(context);
                    },
                    child: Text(
                      "MAIN PAGE",
                      textAlign: TextAlign.center,
                    ),
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
