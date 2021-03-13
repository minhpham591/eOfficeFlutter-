import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/signScreen/signOTPInvoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:painter/painter.dart';

LoginResponseModel testvalue;
int contractId;
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);

class MySignScreen extends StatefulWidget {
  MySignScreen(LoginResponseModel _value, int contractID) {
    testvalue = _value;
    contractId = contractID;
  }
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<MySignScreen> {
  String verificationId;
  _verifyPhone(Uint8List png) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: testvalue.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          verificationId = verficationID;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => EnterOTPToSignInvoice(testvalue.phone,
                    verificationId, png, testvalue, contractId)),
            ModalRoute.withName('/'),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 120));
  }

  PainterController _controller;
  GlobalKey _globalKey = new GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 0.25);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      _verifyPhone(pngBytes);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 3;
    controller.drawColor = Colors.black;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    actions = <Widget>[
      IconButton(
        icon: Icon(Icons.add_box),
        color: Colors.grey,
        iconSize: 35,
        onPressed: () {
          if (!_controller.isEmpty) {
            _capturePng();
          } else {
            _showToast(context);
          }

          //_showToast(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.repeat_sharp),
        color: Colors.grey,
        iconSize: 35,
        onPressed: () {
          if (!_controller.isEmpty) {
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                content: new Text('Do you want to re-sign?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _controller.clear();
                      });
                    },
                    child: new Text('Yes'),
                  ),
                ],
              ),
            );
          }

          //_showToast(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.cancel),
        color: Colors.grey,
        iconSize: 35,
        onPressed: () {
          if (!_controller.isEmpty) {
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                content: new Text('Please clear your sign before cancel'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            Navigator.pop(context);
          }

          //_showToast(context);
        },
      ),
    ];
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        actions: actions,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Image.asset(
                  "assets/images/17.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Please write your signature",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Container(
                  height: 300,
                  width: 400,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: RepaintBoundary(
                      key: _globalKey,
                      // child: Screenshot(
                      //     controller: screenshotController,
                      child: new Painter(_controller))),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 15),
        content: const Text('You have not draw sign'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
