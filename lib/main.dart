import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testFireStore/models/user.dart';
import 'package:testFireStore/screens/wrapper.dart';
import 'package:testFireStore/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _initialized
        ? MultiProvider(
            providers: [
              StreamProvider<UserModel>.value(
                value: AuthService().user,
              ),
              // StreamProvider.value(value: ,)
            ],
            child: MaterialApp(
              home: Wrapper(),
            ),
          )
        : Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: CircularProgressIndicator(),
          );
  }
}
