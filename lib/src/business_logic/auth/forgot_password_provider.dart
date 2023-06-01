import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _resetPasswordError = '';
  String _userEmail = '';
  bool isPressed=false;

  getEmail(String email) {
    if (email != "") {
      _userEmail = email;
      notifyListeners();
    }
  }

  Future _resetPassword() async {
  if(_userEmail!=''&& isPressed==false){
    try {
      await _auth.sendPasswordResetEmail(email: _userEmail);
    } on FirebaseAuthException catch (e) {
      _resetPasswordError = e.message!;
    }
  } else if(_userEmail=='') {
    _resetPasswordError='Please enter your email !';
  } else if(_userEmail!=''&& isPressed==true){
    _resetPasswordError='Please wait 20 seconds before trying again !';
  }
    notifyListeners();
  }

  resetButtonPressed(context) async{
    _resetPasswordError='';
    await _resetPassword();
    if(_resetPasswordError!=''){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            _resetPasswordError,
            style: const TextStyle(color: Colors.white,fontFamily: "Poppins",),
          )));
    }
    else
      {
        isPressed=true;
        Timer(const Duration(seconds: 20), () {
          isPressed=false;
          notifyListeners();

        });

      }
    notifyListeners();
  }
}
