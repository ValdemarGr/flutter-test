import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'home.dart';
import '../user/user.dart';
import '../user/auth.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final User user = new User();
    var auth = new AuthService(endpoint: 'http://8d7b345f.ngrok.io/succeed');
    bool correctUsername = true;
    bool correctPassword = true;

    return new Scaffold(
      backgroundColor: Colors.white,

      body: new Container(
          child: new ListView(
            children: <Widget>[
              new Container(height: 100.0),

              new Image.asset(
                'lib/assets/logo.png',
                height: 150.0,
                width: 150.0,
              ),

              new Form(
                key: formKey,
                child: new Container(
                  margin: EdgeInsets.only(left: 70.0, right: 70.0),
                  child: Column(
                    children: <Widget>[
                        new TextFormField(
                          autovalidate: true,
                          validator: (str){
                            if (!correctUsername){
                              return 'Please enter the correct username';
                            }
                          },
                          onSaved: (value) => user.username = value,
                          decoration: new InputDecoration(
                            hintText: 'Username',
                          ),
                        ),
                        new TextFormField(
                          autovalidate: true,
                          validator: (str){
                            if (!correctPassword){
                              return 'Please enter the correct password';
                            }
                          },
                          onSaved: (value) => user.password = value,
                          obscureText: true,
                          autocorrect: false,
                          decoration: new InputDecoration(
                            hintText: 'Password',
                          ),
                        ),

                      new Container(
                        width: 140.0,
                        margin: EdgeInsets.only(top: 15.0) ,
                        child: new RaisedButton(
                          onPressed: () {
                            formKey.currentState.save();

                            user.password = auth.encrypt(user.password);
                            print('asking');
                            auth.authenticate(user).then((response) {
                              user.token = response.body;
                              if (user.token != '') {
                                print('failed');
                                correctUsername = false;
                                correctPassword = false;
                                formKey.currentState.validate();
                              } else {
                                print(user.token);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              }
                            });
                          },
                          padding: EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0
                          ),
                          color: Color.fromARGB(255, 132, 0, 0),
                          child: new Text(
                            'Login',
                            style: new TextStyle(
                              color: Color.fromARGB(255, 160, 160, 160),
                              fontSize: 26.0
                            )
                          ),
                        )
                      ),

                      new Container(height: 20.0),
                    ],
                  ),
                )
              )

          ],
        ),
      )
    );
  }
}