import 'dart:ui';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
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
                Column(
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
                Column(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
