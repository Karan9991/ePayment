import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';

import '../../business_logic/auth/phone_auth_provider.dart';

class EnterNewEmailScreen extends StatelessWidget {
  const EnterNewEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PhoneAuth phoneAuth = Provider.of<PhoneAuth>(context);


    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormTextField(
                  obscureText: false,
                  fieldTitle: "Your new email:",
                  fieldHintText: "Example@gmail.com",
                  onChanged: (newEmail) {
                    phoneAuth.getNewEmail(newEmail);
                  }),
              ConfirmActionButton(
                onPressed: () async {
                  HapticFeedback.vibrate();

                  await phoneAuth.resetEmailPressed(context);
                },
                buttonText: const Text(
                  "Proceed to change Email",style: TextStyle(fontFamily: "Poppins",),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
