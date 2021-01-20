import 'package:EOfficeMobile/forgotPassword.dart';
import 'package:EOfficeMobile/restartApp.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

void main() {
  runApp(RestarApp(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EOffice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EOffice Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String userName;
  String password;
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      obscureText: false,
      style: style,
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
      onSaved: (String value) {
        userName = value;
      },
    );
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
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
      onSaved: (String value) {
        password = value;
      },
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => forgotPassword()),
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
