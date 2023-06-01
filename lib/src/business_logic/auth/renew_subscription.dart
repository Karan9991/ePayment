import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';
import 'package:e_payment/src/presentation/screen/receipt_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:e_payment/src/data/lifetime_code_list.dart';
import 'package:e_payment/src/data/one_year_code_list.dart';

import '../../data/one_month_code.dart';
import '../../data/one_week_code.dart';
import '../retrieve_user_data.dart';

class RenewSubscription extends ChangeNotifier {
  String userSubscriptionStatus = "";
  DateTime? newSubscriptionDate;
  DateTime? newSubscriptionEndDate;
  String? code;

  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCode(enteredCode) {
    if (enteredCode != "") {
      code = enteredCode;

      _getSubscriptionCodeStatus(code);
    } else {
      userSubscriptionStatus = "Code field is empty ! ";
    }
    notifyListeners();
  }
  _setSubscriptionEndStartDates() async {
    DateTime dateNow = await NTP.now();
    newSubscriptionDate = dateNow;
    if (userSubscriptionStatus != "life time access" &&
        userSubscriptionStatus != "one month access"&& userSubscriptionStatus != "one week access") {
      newSubscriptionEndDate = DateTime(newSubscriptionDate!.year + 1,
          newSubscriptionDate!.month, newSubscriptionDate!.day);
    } else if (userSubscriptionStatus != "life time access" &&
        userSubscriptionStatus != "one year access" &&userSubscriptionStatus != "one week access" &&
        userSubscriptionStatus == "one month access") {
      newSubscriptionEndDate = DateTime(newSubscriptionDate!.year,
          newSubscriptionDate!.month + 1, newSubscriptionDate!.day);
    } if (userSubscriptionStatus != "life time access" &&
        userSubscriptionStatus != "one year access" && userSubscriptionStatus == "one week access" &&
        userSubscriptionStatus != "one month access") {
      newSubscriptionEndDate = DateTime(newSubscriptionDate!.year,
          newSubscriptionDate!.month , newSubscriptionDate!.day+7);
    }
    else {
      newSubscriptionEndDate = DateTime(newSubscriptionDate!.year + 100,
          newSubscriptionDate!.month, newSubscriptionDate!.day);
    }

    notifyListeners();
  }
  _getSubscriptionCodeStatus(code) {
    if (lifeTimeCodeList.contains(code)) {
      userSubscriptionStatus = "life time access";
      notifyListeners();

    } else if (oneYearCodeList.contains(code)) {
      userSubscriptionStatus = "one year access";
      notifyListeners();

    } else if (oneMonthCodeList.contains(code)) {
      userSubscriptionStatus = "one month access";
      notifyListeners();

    }  else if (weekCodeList.contains(code)) {
      userSubscriptionStatus = "one week access";
      notifyListeners();

    } else {
      userSubscriptionStatus = "wrong code";
      notifyListeners();

    }
    notifyListeners();
  }



  _updateUserData() async {
    final usersRef = _db.collection("users").doc(_auth.currentUser!.uid);
    usersRef.update({
      "subscriptionEndDate": newSubscriptionEndDate,
      "userSubscriptionStatus": userSubscriptionStatus,
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));

    await RetrieveUserDataProvider().getUserDataFromFirestore();
  }

  renew(context, deleteCode) async {
    if (userSubscriptionStatus != "" &&
        userSubscriptionStatus != "wrong code") {
      _getSubscriptionCodeStatus(code);
      await _setSubscriptionEndStartDates();
      await _updateUserData();
      await deleteCode;
      notifyListeners();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Subscription Renewal Completed Successfully !",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
        ),
      )));
      Future.delayed(const Duration(seconds: 2));
      NavigateToScreen().navToScreen(context, const HomeScreen());
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please Add Valid Code !",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
        ),
      )));
    }
  }
}
