import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';

PictureRecorder recorder = new PictureRecorder();

class MySignScreen extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<MySignScreen> {
  List<Offset> _points = <Offset>[];
  List<int> _i = <int>[];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.grey,
            onPressed: () {
              _points.forEach((element) {
                print(element.hashCode);
                _i.add(element.hashCode);
              });
              //print(_points.hashCode);
              String encode = base64.encode(_i);
              //print(encode);
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
      body: new Container(
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
    );
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
