import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_payment/src/data/user_model.dart';

class RetrieveUserDataProvider extends ChangeNotifier {
  String? userName;
  String? userEmail;
  DateTime? subscriptionDate;
  DateTime subscriptionEndDate=DateTime(2020);
  String formattedSubscriptionEndDate="";
  String? userSubscriptionStatus;
  final UserDataProvider _userDataProvider = UserDataProvider();
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getUserDataFromFirestore() async {
    if (_auth.currentUser?.email != "admin@admin.com") {
      final docRef = _db.collection("users").doc(_auth.currentUser!.uid);
      await docRef.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          await _userDataProvider.fromFirestore(data);
          userName = _userDataProvider.userName;
          userEmail = _userDataProvider.userEmail;
          subscriptionDate = _userDataProvider.subscriptionDate;
          subscriptionEndDate = _userDataProvider.subscriptionEndDate!;
          userSubscriptionStatus = _userDataProvider.userSubscriptionStatus;

          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          formattedSubscriptionEndDate = formatter.format(subscriptionEndDate);
          notifyListeners();
        },
      );

    } else {
      return;
    }

    notifyListeners();
  }
}
