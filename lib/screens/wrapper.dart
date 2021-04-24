import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testFireStore/models/user.dart';

import 'package:testFireStore/screens/authenticate/authenticate.dart';
import 'package:testFireStore/screens/home/home.dart';
import 'package:testFireStore/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    // print("hello ${userData.uId}");
    if (userData == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
