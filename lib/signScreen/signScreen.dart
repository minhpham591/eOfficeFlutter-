import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';

//PictureRecorder recorder = new PictureRecorder();

class MySignScreen extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<MySignScreen> {
  List<Offset> _points = <Offset>[];
  GlobalKey _globalKey = new GlobalKey();
  var base64;
  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      base64 = base64Encode(pngBytes);
      print(base64);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(''),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.grey,
              onPressed: () {
                _capturePng();
              },
              child: Text("Sign"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
            FlatButton(
              textColor: Colors.grey,
              onPressed: () {
                if (_points.isNotEmpty) {
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
                              _points.clear();
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
                // showDialog(
                //   context: context,
                //   builder: (context) => new AlertDialog(
                //     content: new Text('Do you want to cancel sign?'),
                //     actions: <Widget>[
                //       new FlatButton(
                //         onPressed: () => Navigator.of(context).pop(false),
                //         child: new Text('No'),
                //       ),
                //       new FlatButton(
                //         onPressed: () => Navigator.of(context).pop(true),
                //         child: new Text('Yes'),
                //       ),
                //     ],
                //   ),
                // );
                Navigator.pop(context);
              },
              child: Text("Cancel"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: RepaintBoundary(
          key: _globalKey,
          child: new Container(
            height: 150,
            width: 150,
            child: new GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  RenderBox object = context.findRenderObject();
                  Offset _localPosition =
                      object.globalToLocal(details.globalPosition);
                  _points = new List.from(_points)..add(_localPosition);
                });
              },
              onPanEnd: (DragEndDetails details) => _points.add(null),
              child: new CustomPaint(
                  painter: new Signature(points: _points), size: Size.infinite),
            ),
          ),
        ));
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
