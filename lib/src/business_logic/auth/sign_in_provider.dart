import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';

class SignInProvider with ChangeNotifier {
  String userEmail = "";
  String _userPassword = "";
  String _signInError = '';
  bool _isAllFieldsFilled = false;
  bool isLoading = false;
  bool loggedIn=false;
  final _auth = FirebaseAuth.instance;


  getEmail(String email) {
    if (email != "") {
      userEmail = email;
      notifyListeners();
    }
  }

  getPassword(String password) {
    if (password != "") {
      _userPassword = password;
      notifyListeners();
    }
  }

  allFieldsFilled() {
    if (userEmail != "" && _userPassword != "") {
      _isAllFieldsFilled = true;
    } else {
      _isAllFieldsFilled = false;
    }
    notifyListeners();
  }

  signIn() async {
    _signInError = '';
    allFieldsFilled();
    isLoading = true;
    if (_isAllFieldsFilled == true) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: userEmail, password: _userPassword);
        loggedIn=true;
notifyListeners();

      } on FirebaseAuthException catch (e) {
        _signInError = e.message!;
        loggedIn=false;
        notifyListeners();
      }
    } else {
      _signInError =
          '-Please make sure all fields are filled and has no error !';
    }

    isLoading = false;

    notifyListeners();
  }

  signInPressed(context,bool isLoggedIn) async {

    if(isLoggedIn==true){
      _signInError='User already logged-in on another device';
      notifyListeners();
    }else{
      await signIn();

    }


    if (!context.mounted) return;
    if (_signInError == '' && _isAllFieldsFilled == true) {
      NavigateToScreen().navToScreen(context, const HomeScreen());
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(

          content: Text(
            _signInError,
            style: const TextStyle(color: Colors.white,fontFamily: "Poppins",),
          )));
    }
  }
}
