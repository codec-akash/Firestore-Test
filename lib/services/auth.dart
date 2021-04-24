import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testFireStore/models/user.dart';
import 'package:testFireStore/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  UserModel _userFromFirebase(User userCredential) {
    return userCredential != null ? UserModel(uId: userCredential.uid) : null;
  }

  //Auth change user Stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map((event) => _userFromFirebase(event));
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      print("UserCredential user ${userCredential.user}");
      print("UserCredential $userCredential");

      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      await DataBaseService(uId: userCredential.user.uid)
          .updateUserData("0", "new Member", 100);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithPhoneNumber(
      String phoneNumber, BuildContext context, String password) async {
    TextEditingController _codeController = TextEditingController();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          if (userCredential.additionalUserInfo.isNewUser) {
            await DataBaseService(uId: userCredential.user.uid)
                .updateUserData("0", "new Member", 100);
          }
          if (userCredential.user != null) {
            return _userFromFirebase(userCredential.user);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  title: Text('Phone Verification'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                      child: Text("data"),
                      onPressed: () async {
                        AuthCredential authCredential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: _codeController.text.trim());

                        UserCredential userCredential =
                            await _auth.signInWithCredential(authCredential);
                        if (userCredential.user != null) {
                          Navigator.of(context).pop();
                        }

                        if (userCredential.additionalUserInfo.isNewUser) {
                          await DataBaseService(uId: userCredential.user.uid)
                              .updateUserData("0", "new Member", 100);
                        }

                        return _userFromFirebase(userCredential.user);
                      },
                    ),
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // ConfirmationResult confirmationResult =
      //     await _auth.signInWithPhoneNumber(phoneNumber);
      // print(confirmationResult);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future singInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(oAuthCredential);

      if (userCredential.additionalUserInfo.isNewUser) {
        await DataBaseService(uId: userCredential.user.uid)
            .updateUserData("0", "new Member", 100);
      }
      return _userFromFirebase(userCredential.user);
    } catch (e) {}
  }

  // signin with email and password
  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      userCredential.user.getIdToken().then((value) => print(value));
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
