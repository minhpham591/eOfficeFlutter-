import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/dashboard/bottomNavigateBar.dart';
import 'package:EOfficeMobile/dashboard/dashboard.dart';
import 'package:EOfficeMobile/forgotPassword/forgotPassword.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EOffice',
      home: MyHomePage(),
    );
  }
}

showAlertLoginSuccess(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Continue"),
    color: Colors.blue[900],
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
    content: Text("login successfully!"),
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

class MyHomePage extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginRequestModel requestModel;

  @override
  Widget build(BuildContext context) {
    requestModel = new LoginRequestModel();
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      cursorColor: Colors.grey[600],
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username is not empty';
        }
        return null;
      },
      onSaved: (input) => requestModel.userName = input,
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      cursorColor: Colors.grey[600],
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is not empty';
        }
        return null;
      },
      onSaved: (input) => requestModel.password = input,
    );
    final loginButton = Material(
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
            formKey.currentState.save();
            APIService apiService = new APIService();
            apiService.login(requestModel).then((value) {
              if (value.token.isNotEmpty) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => bottomNavigateBar()),
                  ModalRoute.withName('/'),
                );
              } else {
                print(value.error);
              }
            });
          }
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final forgotButton = Material(
      elevation: 0,
      color: Color.fromRGBO(238, 237, 237, 0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => forgotPassword()),
            ModalRoute.withName('/'),
          );
        },
        child: Text(
          "Forgot your password",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.blue[900], fontWeight: FontWeight.bold),
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
                  SizedBox(height: 45),
                  emailField,
                  SizedBox(height: 15),
                  passwordField,
                  SizedBox(height: 15),
                  loginButton,
                  SizedBox(height: 20),
                  forgotButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
