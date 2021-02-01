import 'package:EOfficeMobile/main.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';

showAlertDialogLogout(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Profile extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  final LoginResponseModel value;
  Profile({this.value});

  @override
  Widget build(BuildContext context) {
    print(value.name);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(height: 100, color: Colors.blue),
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.avatar),
                      radius: 80,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_mail_rounded, color: Colors.black),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("    " + value.email,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_phone_rounded, color: Colors.black),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("    " + value.phone,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, color: Colors.black),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("    " + value.token,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue[900],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {},
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue[900],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {
                    showAlertDialogLogout(context);
                  },
                  child: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
