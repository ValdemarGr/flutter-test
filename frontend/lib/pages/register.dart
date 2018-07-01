
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'home.dart';
import 'register.dart';
import '../user/user.dart';
import '../user/auth.dart';

import '../globals.dart' as globals;

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var auth = new AuthService();
    bool usernameInUse = false;
    bool somethingWentWrong = false;

    User user = new User();

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Container(height: 180.0,),

            new Form(
              key: formKey,
              child: new Container(
                margin: EdgeInsets.only(left: 70.0, right: 70.0),
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      onSaved: (val) => user.username = val,
                      autovalidate: true,
                      validator: (str){
                        if (usernameInUse){
                          return 'Username is in use already!';
                        } else if (somethingWentWrong) {
                          return 'Something went wrong!';
                        }
                      },
                      decoration: new InputDecoration(
                        hintText: 'Username'
                      ),
                    ),

                    new TextFormField(
                      onSaved: (val) => user.password = val,
                      decoration: new InputDecoration(
                        hintText: 'Password'
                      ),
                    ),

                    new Container(
                      width: 140.0,
                      margin: EdgeInsets.only(top: 15.0) ,
                      child: new RaisedButton(
                        onPressed: () {
                          formKey.currentState.save();

                          user.password = auth.encrypt(user.password);

                          auth.register(user).then((response) {
                            if (response.body == 'Failed to register!') {
                              usernameInUse = true;
                              formKey.currentState.validate();
                            } else {
                              auth.login(user).then((loginResponse) {
                                user.token = loginResponse.body;
                                if (user.token == 'Bad login request.') {
                                  somethingWentWrong = true;
                                  formKey.currentState.validate();
                                } else {
                                  print(user.token);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                  );
                                }
                              });
                            }
                          });
                        },
                        padding: EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0
                        ),
                        color: Color.fromARGB(255, 38, 105, 214),
                        child: new Text(
                          'Register',
                          style: new TextStyle(
                            color: Color.fromARGB(255, 220, 220, 220),
                            fontSize: 26.0
                          )
                        ),
                      )
                    ),

                    new Container(height: 20.0),
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
