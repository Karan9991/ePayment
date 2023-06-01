
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_payment/src/business_logic/auth/code_handling.dart';
import 'package:e_payment/src/business_logic/request_activation_code.dart';
import 'package:e_payment/src/business_logic/auth/signup_provider.dart';
import 'package:e_payment/src/presentation/widget/back_button.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';
import 'package:e_payment/src/presentation/widget/navigate_to_signIn_button.dart';
import 'package:e_payment/src/presentation/widget/request_code_button.dart';
import 'package:provider/provider.dart';
import '../../business_logic/auth/one_session_login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);
    CodeHandling codeHandling = Provider.of<CodeHandling>(context);
    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);

    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NavigateBackButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign-Up",
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormTextField(
                              fieldTitle: "Your full name:",
                              fieldHintText: "Enter your full name",
                              obscureText: false,
                              onChanged: (fullName) {
                                signupProvider.getFullName(fullName);
                              },
                            ),
                            FormTextField(
                              fieldTitle: "Your email:",
                              fieldHintText: "Example@gmail.com",
                              obscureText: false,
                              onChanged: (email) {
                                signupProvider.getEmail(email);
                              },
                            ),
                            FormTextField(
                              fieldTitle: "Enter password:",
                              fieldHintText: "Password",
                              obscureText: true,
                              isPassword: true,
                              onChanged: (password) {
                                signupProvider.getPassword(password);
                              },
                            ),
                            FormTextField(
                              fieldTitle: "Re-enter password:",
                              fieldHintText: "Retype your password",
                              obscureText: true,
                              isPassword: true,
                              onChanged: (rePassword) {
                                signupProvider.getRePassword(rePassword);
                              },
                              errorText: signupProvider.isPasswordMatch
                                  ? ''
                                  : "Passwords doesn't match",
                            ),
                            // otp
                            FormTextField(
                              fieldTitle: "Enter your subscription code:",
                              fieldHintText: "Code",
                              obscureText: false,
                              onChanged: (code) async {
                                await codeHandling.getLifeTimeCodeFromFirebase();
                                await codeHandling.getOneYearCodeFromFirebase();
                                await codeHandling.getOneWeekCodeFromFirebase();
                                await codeHandling.getOneMonthCodeFromFirebase();
                                signupProvider.getSubscriptionCode(code);
                              },
                              errorText: signupProvider.userSubscriptionStatus,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RequestCodeWidget(
                              onTap: () {
                                RequestCode().launchInBrowser(Uri.parse(
                                    "https://www.facebook.com/eNegosyoOfficial"));
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !signupProvider.isLoading
                                ?
                            ConfirmActionButton(
                              onPressed: () async {
                                HapticFeedback.vibrate();

                                await signupProvider.signupPressed(
                                    context, codeHandling.deleteCode(),
                                    oneSessionLogin.loggedIn(),
                                    oneSessionLogin.sendSessionData(
                                        signupProvider.userEmail),);



                              },
                              buttonText: const Text(
                                'Sign up',
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
                            const NavigateToSignInButton(),
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
