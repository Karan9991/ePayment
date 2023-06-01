import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/auth/forgot_password_provider.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResetPasswordProvider resetPasswordProvider =
        Provider.of<ResetPasswordProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormTextField(
                  obscureText: false,
                  fieldTitle: "Your email:",
                  fieldHintText: "Example@gmail.com",
                  onChanged: (email) {
                    resetPasswordProvider.getEmail(email);
                  }),
              ConfirmActionButton(

                  onPressed: () async {
                    HapticFeedback.vibrate();

                    await resetPasswordProvider.resetButtonPressed(context);
                },
                buttonText: resetPasswordProvider.isPressed
                    ? const Text("Please wait 20 seconds before sending again",

                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 14,fontFamily: "Poppins",))
                    : const Text(
                        "Send re-set password link",style: TextStyle(fontFamily: "Poppins",),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
