import 'dart:ui';
import 'package:EOfficeMobile/dashboard/dashboard.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/notification/notification.dart';
import 'package:EOfficeMobile/profile/profile.dart';
import 'package:flutter/material.dart';

class MyNavigateBar extends StatelessWidget {
  final LoginResponseModel value;
  MyNavigateBar(this.value);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigateBar(value),
    );
  }
}

LoginResponseModel testValue = null;

class BottomNavigateBar extends StatefulWidget {
  // bottomNavigateBar({Key key}) : super(key: key);
  LoginResponseModel value;
  BottomNavigateBar(LoginResponseModel _value) {
    value = _value;
    testValue = _value;
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
    dashboard(),
    Text(
      'DOCUMENTS',
      style: optionStyle,
    ),
    MyNotification(),
    Profile(
      value: testValue,
    ),
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
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.insert_drive_file_rounded,
              ),
              label: 'Document',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_rounded,
              ),
              label: 'Notification',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_rounded,
              ),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.black87,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
