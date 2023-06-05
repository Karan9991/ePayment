import 'package:cloud_firestore/cloud_firestore.dart';

class UserSubscriptionService {
  Future<String> getUserSubscriptionStatus(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final documentSnapshot = snapshot as DocumentSnapshot; // Cast to DocumentSnapshot
    final userSubscriptionStatus = documentSnapshot.get('userSubscriptionStatus') as String?;
    return userSubscriptionStatus ?? '';
  }
}

void main() async {
  final userSubscriptionService = UserSubscriptionService();
  final uid = 'your_user_id_here';
  
  final subscriptionStatus = await userSubscriptionService.getUserSubscriptionStatus(uid);
  print('User Subscription Status: $subscriptionStatus');
}
