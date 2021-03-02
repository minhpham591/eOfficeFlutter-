import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/model/sign_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';

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
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  Future<SignResponseModel> addSign(Sign signModel) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contractsigns/addsign";
    var body = json.encode(signModel.toJson());
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "text/plain",
          "content-type": "application/json-patch+json"
        },
        body: body);
    print("status code for sign" + response.statusCode.toString());
    if (response.statusCode == 200) {
      return SignResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addSignToContract(SignToContract signModel) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/addsigntocontract";
    var body = json.encode(signModel.toJson());
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "text/plain",
          "content-type": "application/json-patch+json"
        },
        body: body);
    print("status code for sign to contract" + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("add sign successful");
    } else {
      throw Exception('Failed to load data');
    }
  }

  PainterController _controller;
  GlobalKey _globalKey = new GlobalKey();
  String base64;
  Sign signModel = Sign();
  SignToContract adSign = SignToContract();
  // Future<void> _capturePng() async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //         _globalKey.currentContext.findRenderObject();
  //     ui.Image image = await boundary.toImage(pixelRatio: 0.1);
  //     ByteData byteData = new ByteData(1000000000);
  //     byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData.buffer.asUint8List();
  //     base64 = base64Encode(pngBytes);
  //     print(base64);
  //     signModel.signEncode = base64;
  //     signModel.signerId = testvalue.id;
  //     addSign(signModel).then((value) => {
  //           adSign.signId = value.signID,
  //           adSign.contractId = contractId,
  //           addSignToContract(adSign),
  //         });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 0.3;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    actions = <Widget>[
      FlatButton(
        textColor: Colors.grey,
        onPressed: () {
          screenshotController
              .capture(pixelRatio: 1)
              .then((Uint8List image) async {
            image.buffer.asUint64List().toList();
            print(image.buffer.asUint64List().toList());
            // print(image.toList());
            base64 = base64Encode(image.buffer.asUint64List().toList());
            print(base64);
            signModel.signEncode = image.toString();
            signModel.signerId = testvalue.id;
            addSign(signModel).then((value) => {
                  adSign.signId = value.signID,
                  adSign.contractId = contractId,
                  addSignToContract(adSign),
                });
          });
        },
        child: Text("Sign"),
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
      FlatButton(
        textColor: Colors.grey,
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
        },
        child: Text("Re-sign"),
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
      FlatButton(
        textColor: Colors.grey,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel"),
        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
    ];
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          actions: actions,
        ),
        body: Center(
          // child: RepaintBoundary(
          //     key: _globalKey,

          child: new Container(
              height: 300,
              width: 300,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Screenshot(
                  controller: screenshotController,
                  child: new Painter(_controller))),
        ));
  }
}
