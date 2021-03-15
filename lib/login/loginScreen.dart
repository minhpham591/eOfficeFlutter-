import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/dashboard/bottomNavigateBar.dart';
import 'package:EOfficeMobile/forgotPassword/forgotPassword.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

String _token;
String _device;
String _osVer;
String _appVer;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginRequestModel requestModel = new LoginRequestModel();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  void initPlatformState() async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    _device = androidInfo.model;
    if (androidInfo.version.sdkInt.toString() == '29') {
      _osVer = "Android 10";
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _appVer = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _token = token;
    });
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
          print(_appVer);
          print(_device);
          print(_osVer);
          if (!formKey.currentState.validate()) {
            return;
          } else {
            formKey.currentState.save();
            APIService apiService;
            apiService = new APIService();
            requestModel.token = _token;
            requestModel.appVer = _appVer;
            requestModel.device = _device;
            requestModel.osVer = _osVer;
            apiService.testUser();
            apiService.login(requestModel).then((value) {
              if (apiService.statusCode.toString() == "null") {
                if (value.token.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigateBar(value)),
                  );
                }
              } else {
                _showToast(context);
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
        key: _scaffoldKey,
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

  void _showToast(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
        content: const Text('Login failed!!! Please check email and password'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
