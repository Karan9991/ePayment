import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/business_logic/auth/sign_in_provider.dart';
import 'package:e_payment/src/presentation/screen/forgot_password_screen.dart';
import 'package:e_payment/src/presentation/screen/forgot_email_screen.dart';
import 'package:e_payment/src/presentation/widget/forgot_button.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';
import 'package:e_payment/src/presentation/widget/navigate_to_signup_button.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';

import '../../business_logic/auth/one_session_login.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Sign in to your account",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset("assets/images/appIcon.png")),
                      ),
                      Expanded(
                        flex: 1,
                        child: AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormTextField(
                                obscureText: false,
                                autofillHints: const [AutofillHints.email],
                                onEditingComplete: () =>
                                    TextInput.finishAutofillContext(),
                                fieldTitle: "Your e-mail:",
                                fieldHintText: "Example@gmail.com",
                                onChanged: (email) {
                                  
                                  signInProvider.getEmail(email);
                                },
                              ),
                              FormTextField(
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                onEditingComplete: () =>
                                    TextInput.finishAutofillContext(),
                                fieldTitle: "Your password:",
                                fieldHintText: "Enter your password",
                                isPassword: true,
                                onChanged: (password) {
                                  signInProvider.getPassword(password);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !signInProvider.isLoading
                                ? ConfirmActionButton(
                                    onPressed: () async {
                                      HapticFeedback.vibrate();

                                      await oneSessionLogin.getSessionData(
                                          signInProvider.userEmail);
                                      if (!context.mounted) return;
                                      await signInProvider.signInPressed(
                                        context,
                                        oneSessionLogin.isLoggedIn,
                                      );
                                      if(signInProvider.loggedIn==true){
                                        oneSessionLogin.loggedIn();
                                        await oneSessionLogin.sendSessionData(signInProvider.userEmail);
                                      }
                                    },
                                    buttonText: const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(0, 0, 254, 1),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            const NavigateToSignupButton(),
                            ForgotButton(
                              onPressed: () {
                                NavigateToScreen().navToScreen(
                                    context, const ForgotPasswordScreen());
                              },
                              title: 'Forgot Password ?',
                            ),
                            ForgotButton(
                              onPressed: () {
                                NavigateToScreen()
                                    .navToScreen(context, const ResetEmail());
                              },
                              title: 'Forgot Email ?',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
