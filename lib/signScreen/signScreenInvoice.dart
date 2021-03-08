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
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> addSignToContract(SignToInvoice signModel) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/addsigntoinvoice";
    var body = json.encode(signModel.toJson());
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "text/plain",
          "content-type": "application/json-patch+json",
          'Authorization': 'Bearer ${testvalue.token}'
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
  SignToInvoice adSign = SignToInvoice();
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
    dio.Dio d = new dio.Dio();

    d.options.headers["Authorization"] = "Bearer ${testvalue.token}";
    var response = await d.post(
        "https://datnxeoffice.azurewebsites.net/api/invoicesigns/addinvoicesign",
        data: formData);
    print(response.data['id']);
    print(response.data);
    adSign.invoiceId = contractId;
    adSign.signId = response.data['id'];
    addSignToContract(adSign);
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 0.25);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData.buffer.asUint8List();

      _createFileFromString(pngBytes);
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
      FlatButton(
        textColor: Colors.grey,
        onPressed: () {
          _capturePng();
          //_showToast(context);
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
        duration: const Duration(minutes: 1, seconds: 30),
        content: const Text('Sign successfully'),
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
