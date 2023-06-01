import 'package:cloud_firestore/cloud_firestore.dart';

class UploadUserData {
  final _db = FirebaseFirestore.instance;
  final String userName;
  final String userEmail;
  final String userSubscriptionStatus;
  final String uid;
  final DateTime? subscriptionDate;
  final DateTime? subscriptionEndDate;

  UploadUserData({
    required this.userName,
    required this.userEmail,
    required this.userSubscriptionStatus,
    required this.subscriptionDate,
    required this.subscriptionEndDate,
    required this.uid,
  });

  createUserDataToFirestore() async {
    final users = _db.collection("users");
    final user = <String, dynamic>{
      "uId":uid,
      "name": userName,
      "userEmail": userEmail,
      "userSubscriptionStatus": userSubscriptionStatus,
      "subscriptionDate": subscriptionDate,
      "subscriptionEndDate": subscriptionEndDate,
    };
    await users.doc(uid).set(user);
  }
}
