import 'package:flutter/cupertino.dart';
import 'package:ntp/ntp.dart';
import 'package:e_payment/src/business_logic/auth/code_handling.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/business_logic/retrieve_user_data.dart';
import 'package:e_payment/src/presentation/screen/receipt_details_screen.dart';
import 'package:e_payment/src/presentation/screen/subscription_ended_screen.dart';

class SubscriptionHandle extends ChangeNotifier {
  bool? isSubscriptionStillValid;
  final RetrieveUserDataProvider retrieveUserDataProvider =
      RetrieveUserDataProvider();

  detectSubscriptionState(context) async {
    await retrieveUserDataProvider
        .getUserDataFromFirestore();
    DateTime dateNow = await NTP.now();
    isSubscriptionStillValid =
        dateNow.isBefore(retrieveUserDataProvider.subscriptionEndDate);
    if (!context.mounted) return;
    if (isSubscriptionStillValid == true) {
      NavigateToScreen().navToScreen(context, const ReceiptDetailsScreen());
    } else {
      await CodeHandling().getLifeTimeCodeFromFirebase();
      await CodeHandling().getOneYearCodeFromFirebase();
      await CodeHandling().getOneMonthCodeFromFirebase();
      await CodeHandling().getOneWeekCodeFromFirebase();
      NavigateToScreen().navToScreen(context, const SubscriptionEndedScreen());
    }
    notifyListeners();
  }

}
