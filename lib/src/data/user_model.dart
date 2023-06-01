
class UserDataProvider {
  String? userName;
  String? userEmail;
  DateTime? subscriptionDate;
  DateTime? subscriptionEndDate;
  String? userSubscriptionStatus;

  fromFirestore(data) {
    userName = data!['name'];
    userEmail = data['userEmail'];
    userSubscriptionStatus = data!['userSubscriptionStatus'];
    subscriptionEndDate = data!['subscriptionEndDate'].toDate();
    subscriptionDate = data!['subscriptionDate'].toDate();
  }
}
