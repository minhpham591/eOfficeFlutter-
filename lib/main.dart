import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/dashboard/bottomNavigateBar.dart';
import 'package:EOfficeMobile/forgotPassword/forgotPassword.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
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

showAlertLoginFail(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Close"),
    color: Colors.blue[900],
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Failed"),
    content: Text("Your username or password is wrong!!!"),
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
            APIService apiService = APIService();
            apiService.login(requestModel).then((value) {
              if (value.token.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyNavigateBar(value)),
                );
              } else if (value == null) {
                showAlertLoginFail(context);
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
            MaterialPageRoute(builder: (context) => ForgotPassword()),
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
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}
