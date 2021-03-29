import 'dart:ui';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/notification/notificationAll.dart';
import 'package:EOfficeMobile/notification/notificationSign.dart';
import 'package:EOfficeMobile/notification/notificationView.dart';
import 'package:flutter/material.dart';

LoginResponseModel testvalue;

class MyNotification extends StatefulWidget {
  MyNotification(LoginResponseModel _value) {
    testvalue = _value;
  }
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class _DropDownButtonState extends State<MyNotification> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Notification",
            style: style,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'All',
                  style: style,
                ),
              ),
              Tab(
                child: Text(
                  'Sign',
                  style: style,
                ),
              ),
              Tab(
                child: Text(
                  'View',
                  style: style,
                ),
              ),
            ],
            indicatorWeight: 2,
            indicatorPadding: EdgeInsets.all(10.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: [
            StoreAllNotification(testvalue),
            StoreSignerNotification(testvalue),
            StoreViewerNotification(testvalue),
          ],
        ),
      ),
    );
  }
}
