import 'dart:ui';

import 'package:flutter/material.dart';

class MyNotification extends StatefulWidget {
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue);

class _DropDownButtonState extends State<MyNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 40,
              child: Text(
                'Activity Log',
                style: style,
                textAlign: TextAlign.start,
              ),
            ),
            SingleChildScrollView(),
          ],
        ),
      ),
    );
  }
}
