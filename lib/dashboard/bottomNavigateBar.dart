import 'dart:ui';

import 'package:EOfficeMobile/dashboard/dashboard.dart';
import 'package:EOfficeMobile/document/storeDocument.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/notification/notification.dart';
import 'package:EOfficeMobile/profile/profile.dart';
import 'package:EOfficeMobile/search/search.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

LoginResponseModel testValue;
String device;

class BottomNavigateBar extends StatefulWidget {
  // bottomNavigateBar({Key key}) : super(key: key);

  BottomNavigateBar(LoginResponseModel _value, String _device) {
    testValue = _value;
    device = _device;
  }

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<BottomNavigateBar> {
  _MyStatefulWidgetState() : super();
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    dashboard(testValue),
    StoreDocument(testValue),
    Search(testValue),
    MyNotification(testValue),
    Profile(testValue, device),
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insert_drive_file_rounded,
            ),
            label: 'Document',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              size: 35,
            ),
            label: 'Search',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            // icon: Icon(
            //   Icons.notifications_rounded,
            // ),
            icon: Badge(
              child: Icon(Icons.notifications_rounded),
              badgeContent: Text(
                '1',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
            label: 'Notification',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
            ),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
