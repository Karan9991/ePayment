
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';

import '../../business_logic/auth/code_handling.dart';
import '../../business_logic/auth/renew_subscription.dart';
import '../../business_logic/request_activation_code.dart';
import '../widget/request_code_button.dart';

class SubscriptionEndedScreen extends StatelessWidget {
  const SubscriptionEndedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RenewSubscription renewSubscription =
        Provider.of<RenewSubscription>(context);
    CodeHandling codeHandling =Provider.of<CodeHandling>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Subscription Has Been Ended !",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FormTextField(
                obscureText: false,
                fieldTitle: "Code:",
                fieldHintText: "Add Code Here",
                onChanged: (code)  async {
                  await codeHandling.getLifeTimeCodeFromFirebase();
                  await codeHandling.getOneYearCodeFromFirebase();
                  await codeHandling.getOneWeekCodeFromFirebase();
                  await codeHandling.getOneMonthCodeFromFirebase();
                  renewSubscription.getCode(code);
                },
                errorText: renewSubscription.userSubscriptionStatus,
              ),
              ConfirmActionButton(
                onPressed: () async {
                  HapticFeedback.vibrate();

                  await renewSubscription.renew(context, codeHandling.deleteCode());
                },
                buttonText: const Text(
                  "Re-New Subscription",
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: RequestCodeWidget(
            onTap: () {
              RequestCode().launchInBrowser(Uri.parse( "https://www.facebook.com/eNegosyoOfficial"));

            },
          ),
        )],
          ),
        ),
      ),
    );
  }
}
