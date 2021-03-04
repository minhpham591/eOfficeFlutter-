import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart' as dio;
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/model/sign_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:painter/painter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  SignInvoice signModel = SignInvoice();
  SignToContract adSign = SignToContract();
  Uint8List pngBytes;
  DateTime now = DateTime.now();
  Future<void> _createFileFromString(Uint8List png) async {
    String dir = (await getTemporaryDirectory()).path;
    String fullPath = '$dir/temp$now.png';
    print("local file full path $fullPath");
    File file = File(fullPath);
    await file.writeAsBytes(png);
    print(file.path);
    String fileName = basename(file.path);
    print(fileName);
    dio.FormData formData = dio.FormData.fromMap({
      "Id": 0,
      "SignerId": testvalue.id,
      "SignUrl":
          await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "DateCreate": now,
      "InvoiceId": contractId,
    });
    var response = await dio.Dio().post(
        "https://datnxeoffice.azurewebsites.net/api/contractsigns/addsign",
        data: formData);
    print(response.data['id']);
    adSign.signId = response.data['id'];
    adSign.contractId = contractId;
    addSignToContract(adSign);
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData.buffer.asUint8List();
      // base64 = base64Encode(pngBytes);
      // print(base64);
      print(contractId);
      _createFileFromString(pngBytes);
      // signModel.signEncode = pngBytes;
      //signModel.signerId = testvalue.id;
      // signModel.invoiceId = contractId;
      // addSign(signModel).then((value) => {
      //       adSign.signId = value.signID,
      //       adSign.invoiceId = contractId,
      //       addSignToContract(adSign),
      //     });
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
    controller.thickness = 1;
    controller.drawColor = Colors.black;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    actions = <Widget>[
      FlatButton(
        textColor: Colors.grey,
        onPressed: () {
          _capturePng();
          // screenshotController.capture(pixelRatio: 0.2).then((image) async {
          //   _imageFile = image;
          //   print(image.toList());
          //   base64 = base64Encode(_imageFile.toList());
          //   print(base64);
          //   signModel.signEncode = base64;
          //   signModel.signerId = testvalue.id;
          //   signModel.invoiceId = contractId;
          //   addSign(signModel).then((value) => {
          //         adSign.signId = value.signID,
          //         adSign.invoiceId = contractId,
          //         addSignToContract(adSign),
          //       });
          // });
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
        child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: RepaintBoundary(
                key: _globalKey,
                // child: Screenshot(
                //     controller: screenshotController,
                child: new Painter(_controller))),
      ),
    );
  }
}
