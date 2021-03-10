import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/signScreen/signOTPContract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:painter/painter.dart';

LoginResponseModel testvalue;
int contractId;

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
                builder: (context) => EnterOTPToSignContract(testvalue.phone,
                    verificationId, png, testvalue, contractId)),
            ModalRoute.withName('/'),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 120));
  }

  PainterController _controller;
  GlobalKey _globalKey = new GlobalKey();

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
          _capturePng();

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
          Navigator.pop(context);

          //_showToast(context);
        },
      ),
    ];
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        actions: actions,
      ),
      body: Center(
        child: Container(
            height: 300,
            width: 400,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: RepaintBoundary(
                key: _globalKey,
                // child: Screenshot(
                //     controller: screenshotController,
                child: new Painter(_controller))),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(minutes: 1, seconds: 30),
        content: const Text('Sign successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
