import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:e_payment/src/business_logic/upload_user_data.dart';
import 'package:e_payment/src/data/lifetime_code_list.dart';
import 'package:e_payment/src/data/one_year_code_list.dart';
import 'package:e_payment/src/data/one_month_code.dart';

import '../../data/one_week_code.dart';


class SignupProvider extends ChangeNotifier {
  String userName = "";
  String userEmail = "";
  String _userPassword = "";
  String _userRePassword = "";
  String uid = "";
  String _subscriptionCode = "";
  String userSubscriptionStatus = "";
  bool isPasswordMatch = true;
  bool _isAllFieldsFilled = false;
  bool isLoading = false;
  String _signupError = '';
  DateTime? subscriptionDate;
  DateTime? subscriptionEndDate;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _setSubscriptionEndStartDates() async {
    if (_signupError == '') {
      DateTime dateNow = await NTP.now();
      subscriptionDate = dateNow;
      if (userSubscriptionStatus != "life time access" &&
          userSubscriptionStatus != "one month access"&& userSubscriptionStatus != "one week access") {
        subscriptionEndDate = DateTime(subscriptionDate!.year + 1,
            subscriptionDate!.month, subscriptionDate!.day);
      } else if (userSubscriptionStatus != "life time access" &&
          userSubscriptionStatus != "one year access" && userSubscriptionStatus != "one week access" &&
          userSubscriptionStatus == "one month access") {
        subscriptionEndDate = DateTime(subscriptionDate!.year,
            subscriptionDate!.month + 1, subscriptionDate!.day);
      }if (userSubscriptionStatus != "life time access" &&
          userSubscriptionStatus != "one year access" && userSubscriptionStatus == "one week access" &&
          userSubscriptionStatus != "one month access") {
        subscriptionEndDate = DateTime(subscriptionDate!.year,
            subscriptionDate!.month , subscriptionDate!.day+7);
      }
      else {
        subscriptionEndDate = DateTime(subscriptionDate!.year + 100,
            subscriptionDate!.month, subscriptionDate!.day);
      }

      notifyListeners();
    }
  }

  getFullName(String fullName) {
    if (fullName != "") {
      userName = fullName;
      notifyListeners();
    }
  }

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

  getRePassword(String rePassword) {
    if (rePassword != "") {
      _userRePassword = rePassword;
    }
    _checkPasswordMatch();
    notifyListeners();
  }

  _getSubscriptionCodeStatus(subscriptionCode) {
    if (lifeTimeCodeList.contains(subscriptionCode)) {
      userSubscriptionStatus = "life time access";
    } else if (oneYearCodeList.contains(subscriptionCode)) {
      userSubscriptionStatus = "one year access";
    } else if (oneMonthCodeList.contains(subscriptionCode)) {
      userSubscriptionStatus = "one month access";
    }  else if (weekCodeList.contains(subscriptionCode)) {
      userSubscriptionStatus = "one week access";
    }
    else {
      userSubscriptionStatus = "wrong code";
    }
    notifyListeners();
  }

  getSubscriptionCode(String code) {
    if (code != "") {
      _subscriptionCode = code;

      _getSubscriptionCodeStatus(_subscriptionCode);
    } else {
      userSubscriptionStatus = "Code field is empty ! ";
    }
    notifyListeners();
  }

  _setUserId() {
    if (_signupError == "") {
      uid = _auth.currentUser!.uid;
      notifyListeners();
    }
  }

  _checkPasswordMatch() {
    if (_userPassword != _userRePassword) {
      isPasswordMatch = false;
    } else {
      isPasswordMatch = true;
    }
  }

  _allFieldsFilled() {
    if (userName != "" &&
        userEmail != "" &&
        _userPassword != "" &&
        isPasswordMatch == true &&
        userSubscriptionStatus != "wrong code" &&
        userSubscriptionStatus != "Code field is empty ! ") {
      _isAllFieldsFilled = true;
    } else {
      _isAllFieldsFilled = false;
    }
    notifyListeners();
  }

  _signup() async {
    _signupError = '';
    _allFieldsFilled();
    isLoading = true;
    if (_isAllFieldsFilled == true) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: userEmail, password: _userPassword);

      } on FirebaseAuthException catch (e) {
        _signupError = e.message!;
      }
    } else {
      _signupError =
          '-Please make sure all fields are filled and has no error !';
    }
    _setUserId();
    await _setSubscriptionEndStartDates();

    isLoading = false;

    notifyListeners();
  }

  deleteUser() {
    _auth.currentUser?.delete();
  }

  signupPressed(context, deleteCode,loggedIn,sendSessionData) async {
    await _signup();

    if (_signupError == '' && _isAllFieldsFilled == true) {
      Navigator.pushNamed(context, '/phoneAuth');

      await deleteCode;
      loggedIn;
      await sendSessionData;

      await UploadUserData(
              uid: uid,
              userName: userName,
              userEmail: userEmail,
              userSubscriptionStatus: userSubscriptionStatus,
              subscriptionDate: subscriptionDate!,
              subscriptionEndDate: subscriptionEndDate)
          .createUserDataToFirestore();


    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(

          content: Text(
            _signupError,
            style: const TextStyle(color: Colors.white,fontFamily: "Poppins",),
          )));
    }

    notifyListeners();
  }
}
