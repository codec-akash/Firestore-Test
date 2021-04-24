import 'package:flutter/material.dart';
import 'package:testFireStore/screens/authenticate/sign_in.dart';
import 'package:testFireStore/services/auth.dart';
import 'package:testFireStore/shared/constants.dart';
import 'package:testFireStore/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Register in lol"),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign in"),
            onPressed: () {
              widget.toggleView();
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => SignIn()));
            },
          )
        ],
      ),
      body: loading
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter an email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(labelText: 'password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password 6+ length';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Register"),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result =
                              await _authService.registerWithPhoneNumber(
                                  email, context, password);
                          // dynamic result = await _authService.registerWithEmail(
                          //     email, password);
                          if (result == null) {
                            setState(() {
                              error = 'provide email';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text("google"),
                      onPressed: () async {
                        dynamic result = await _authService.singInWithGoogle();
                      },
                    ),
                    SizedBox(height: 20),
                    Text(error, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
    );
  }
}
