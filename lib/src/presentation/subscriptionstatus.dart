import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionStatusProvider {
  static Future<String?> getSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print("oooooooooooooooooooo");
    print(prefs.getString('subscriptionStatus'));

    return prefs.getString('subscriptionStatus');
  }
}
