import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testFireStore/models/user.dart';
import 'package:testFireStore/services/database.dart';
import 'package:testFireStore/shared/constants.dart';
import 'package:testFireStore/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserDataModel>(
        stream: DataBaseService(uId: user.uId).userData,
        builder: (context, snapshot) {
          UserDataModel userDataModel = snapshot.data;
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userDataModel.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userDataModel.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text("$sugar sugars"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _currentSugars = value;
                      });
                    },
                  ),
                  Slider(
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    activeColor: Colors
                        .brown[_currentStrength ?? userDataModel.strength],
                    inactiveColor: Colors
                        .brown[_currentStrength ?? userDataModel.strength],
                    value:
                        (_currentStrength ?? userDataModel.strength).toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _currentStrength = value.round();
                      });
                    },
                  ),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DataBaseService(uId: user.uId).updateUserData(
                              _currentSugars ?? snapshot.data.sugars,
                              _currentName ?? snapshot.data.name,
                              _currentStrength ?? snapshot.data.strength);
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
