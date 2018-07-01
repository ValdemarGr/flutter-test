import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        margin: EdgeInsets.only(top: 120.0),
        width: double.infinity,
        child: new Column(
          children: <Widget>[
            new FlutterLogo(
              size: 50.0
            )
          ],
        )
      )
    );
  }
}