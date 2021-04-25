import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testFireStore/models/brew.dart';
import 'package:testFireStore/screens/clgApp/home/clg_home.dart';
import 'package:testFireStore/screens/home/brew_list.dart';
import 'package:testFireStore/screens/home/settings_form.dart';
import 'package:testFireStore/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:testFireStore/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DataBaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text("Brew Crew"),
          elevation: 0.0,
          actions: [
            FlatButton.icon(
              onPressed: () async {
                await _authService.signout();
              },
              icon: Icon(Icons.person),
              label: Text('Logout'),
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text("Settings"),
              onPressed: () {
                _showSettings();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("YO"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ClgHome(),
            ));
          },
        ),
        body: BrewList(),
      ),
    );
  }
}
