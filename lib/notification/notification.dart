import 'dart:ui';
import 'package:flutter/material.dart';

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Your create',
                ),
                Tab(
                  text: 'Your assign',
                ),
                Tab(text: 'Signed'),
              ],
            ),
            title: Text('Notification'),
          ),
          body: TabBarView(
            children: [
              Text('Create'),
              Text('Assign'),
              Text('Signed'),
            ],
          ),
        ),
      ),
    );
  }
}
