import 'dart:ui';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';

class profile extends StatelessWidget {
  final LoginResponseModel value;
  //profile({Key key, this.value}) : super(key: key);
  profile({this.value});
  @override
  Widget build(BuildContext context) {
    print(profile().value);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 250,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(),
              SizedBox(
                height: 40,
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
