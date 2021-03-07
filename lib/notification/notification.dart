import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyNotification extends StatefulWidget {
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

int _value = 1;
int _value1 = 1;

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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: Column(
                    children: [
                      DropdownButton(
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text('All'),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text('Contract'),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text('Invoice'),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          })
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: Column(
                    children: [
                      DropdownButton(
                          value: _value1,
                          items: [
                            DropdownMenuItem(
                              child: Text('All'),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text('Signed'),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text('Not signed yet'),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value1 = value;
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(),
          ],
        ),
      ),
    );
  }
}
