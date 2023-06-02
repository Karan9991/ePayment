import 'package:e_payment/src/presentation/screen/update_email.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:e_payment/src/presentation/screen/edit_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/auth/code_handling.dart';
import 'package:e_payment/src/business_logic/auth/sign_out.dart';
import 'package:e_payment/src/business_logic/auth/subscription_handle.dart';
import 'package:e_payment/src/business_logic/image_provider.dart';
import 'package:e_payment/src/business_logic/loading_state.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/business_logic/request_activation_code.dart';
import 'package:e_payment/src/presentation/screen/receipts_history_screen.dart';
import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/rounded_button.dart';
import '../../business_logic/auth/one_session_login.dart';
import '../../business_logic/auth/sign_in_provider.dart';
import '../../business_logic/auth/signup_provider.dart';
import '../../business_logic/recognize_photo_text.dart';
import '../../business_logic/retrieve_user_data.dart';
import 'package:e_payment/src/presentation/widget/form_text_field.dart';

class EditEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void getVerificationLink(BuildContext context) async {
    final auth = FirebaseAuth.instance;

    String newEmail = emailController.text.trim();
    if (newEmail.isNotEmpty) {
      try {
        //  final User? currentUser = auth.currentUser;
        // Send verification email to the new email address

        await auth.currentUser!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Email verification sent. Please check your email.")),
        );

        // Show a success message or navigate back

        // Wait for the user to verify the new email address
        // await auth.currentUser!.reload();

        // Navigate back or show a success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Email updated successfully.")),
        // );
        //   Navigator.pop(context); // Navigate back
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error $e")),
        );
        print(e.toString());
      }
    }
  }

  void updateEmaill(BuildContext context) async {
    final auth = FirebaseAuth.instance;

    String newEmail = emailController.text.trim();
    if (newEmail.isNotEmpty) {
      try {
        final User? currentUser = auth.currentUser;
        if (currentUser != null && currentUser.emailVerified) {
          // Send verification email to the new email address
          await auth.currentUser!.updateEmail(newEmail);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email Updated")),
          );
        } else {
          // await auth.currentUser!.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Email not Verified. Please verify your email.")),
          );
        }
        // Show a success message or navigate back

        // Wait for the user to verify the new email address
        // await auth.currentUser!.reload();

        // Navigate back or show a success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Email updated successfully.")),
        // );
        //   Navigator.pop(context); // Navigate back
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error $e")),
        );
        print(e.toString());
      }
    }
  }

  void _logout(BuildContext context) async {
    print("logout");
    final auth = FirebaseAuth.instance;

    RetrieveUserDataProvider retrieveUserDataProvider =
        Provider.of<RetrieveUserDataProvider>(context);
    retrieveUserDataProvider.getUserDataFromFirestore();
    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);

    HapticFeedback.vibrate();
    SignOut().signOut();
    NavigateToScreen().navToScreen(context, const SignInScreen());
    oneSessionLogin.notLoggedIn();
    oneSessionLogin.sendSessionData(auth.currentUser!.email);
    if (signInProvider.userEmail != "") {
      oneSessionLogin.notLoggedIn();
      return await oneSessionLogin.sendSessionData(signInProvider.userEmail);
    } else {
      oneSessionLogin.notLoggedIn();
      await oneSessionLogin.sendSessionData(signupProvider.userEmail);
    }
  }

  void updateEmail(BuildContext context) async {
    final auth = FirebaseAuth.instance;

    // RetrieveUserDataProvider retrieveUserDataProvider =
    //     Provider.of<RetrieveUserDataProvider>(context);
    // retrieveUserDataProvider.getUserDataFromFirestore();
    // OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);
    // SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    // SignupProvider signupProvider = Provider.of<SignupProvider>(context);

    String newEmail = emailController.text.trim();

    if (newEmail.isNotEmpty) {
      try {
        await auth.currentUser!.updateEmail(newEmail);

        // Send verification email to the new email address
        await auth.currentUser!.sendEmailVerification();

        // Show a success message or navigate back to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Email updated successfully. Please check your Email for verify")),
        );
        print("logout");
        // final auth = FirebaseAuth.instance;

        //  HapticFeedback.vibrate();
        //SignOut().signOut();
        //  NavigateToScreen().navToScreen(context, const SignInScreen());
        // oneSessionLogin.notLoggedIn();
        // oneSessionLogin.sendSessionData(auth.currentUser!.email);
        // if (signInProvider.userEmail != "") {
        //   oneSessionLogin.notLoggedIn();
        //   return await oneSessionLogin
        //       .sendSessionData(signInProvider.userEmail);
        // } else {
        //   oneSessionLogin.notLoggedIn();
        //   await oneSessionLogin.sendSessionData(signupProvider.userEmail);
        // }
        // _logout(context);
        // Navigator.pop(context); // Navigate back
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error $e")),
        );
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    RetrieveUserDataProvider retrieveUserDataProvider =
        Provider.of<RetrieveUserDataProvider>(context);
    retrieveUserDataProvider.getUserDataFromFirestore();
    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Email"),
        backgroundColor: Color.fromRGBO(0, 0, 254, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormTextField(
              obscureText: false,
              autofillHints: const [AutofillHints.email],
              onEditingComplete: () => TextInput.finishAutofillContext(),
              fieldTitle: "Your New E-Mail:",
              fieldHintText: "Example@gmail.com",
              onChanged: (email) {
                emailController.text = email;
              },
            ),

            SizedBox(height: 16.0),
            ConfirmActionButton(
              onPressed: () async {
                String newEmail = emailController.text.trim();
                if (newEmail.isNotEmpty) {
                  try {
                    await auth.currentUser!.updateEmail(newEmail);
                    await auth.currentUser!.sendEmailVerification();
                    oneSessionLogin.notLoggedIn();
                    oneSessionLogin.sendSessionData(auth.currentUser!.email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Email Updated. Please check your email to verify")),
                    );
                    NavigateToScreen()
                        .navToScreen(context, const SignInScreen());
                  } catch (e) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error $e")),
                    );
                    print(e.toString());
                  }
                }
              },
              buttonText: const Text(
                'Update Email',
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // HapticFeedback.vibrate();
            //     // SignOut().signOut();
            //     // // Navigator.push(
            //     // //   context,
            //     // //   MaterialPageRoute(builder: (context) => SignInScreen()),
            //     // // );
            //     // NavigateToScreen().navToScreen(context,  UpdateEmailScreen());
            //     // oneSessionLogin.notLoggedIn();
            //     // oneSessionLogin.sendSessionData(auth.currentUser!.email);
            //     // if (signInProvider.userEmail != "") {
            //     //   oneSessionLogin.notLoggedIn();
            //     //   await oneSessionLogin
            //     //       .sendSessionData(signInProvider.userEmail);
            //     // } else {
            //     //   oneSessionLogin.notLoggedIn();
            //     //   await oneSessionLogin
            //     //       .sendSessionData(signupProvider.userEmail);
            //     // }
            //     String newEmail = emailController.text.trim();
            //     if (newEmail.isNotEmpty) {
            //       try {
            //         //final User? currentUser = auth.currentUser;
            //         //  if (currentUser != null && currentUser.emailVerified) {
            //         // Send verification email to the new email address
            //         await auth.currentUser!.updateEmail(newEmail);
            //         await auth.currentUser!.sendEmailVerification();

            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //               content: Text(
            //                   "Email Updated. Please check your email to verify")),
            //         );
            //         NavigateToScreen()
            //             .navToScreen(context, const SignInScreen());
            //         // HapticFeedback.vibrate();
            //         // SignOut().signOut();
            //         // // Navigator.push(
            //         // //   context,
            //         // //   MaterialPageRoute(builder: (context) => SignInScreen()),
            //         // // );
            //         // NavigateToScreen()
            //         //      .navToScreen(context, const SignInScreen());
            //         // oneSessionLogin.notLoggedIn();
            //         // oneSessionLogin.sendSessionData(auth.currentUser!.email);
            //         // if (signInProvider.userEmail != "") {
            //         //   oneSessionLogin.notLoggedIn();
            //         //   await oneSessionLogin
            //         //       .sendSessionData(signInProvider.userEmail);
            //         // } else {
            //         //   oneSessionLogin.notLoggedIn();
            //         //   await oneSessionLogin
            //         //       .sendSessionData(signupProvider.userEmail);
            //         // }
            //         // } else {
            //         //   // await auth.currentUser!.sendEmailVerification();
            //         //   ScaffoldMessenger.of(context).showSnackBar(
            //         //     SnackBar(
            //         //         content: Text("Email not Verified. Please verify your email.")),
            //         //   );
            //         // }
            //         // Show a success message or navigate back

            //         // Wait for the user to verify the new email address
            //         // await auth.currentUser!.reload();

            //         // Navigate back or show a success message
            //         // ScaffoldMessenger.of(context).showSnackBar(
            //         //   SnackBar(content: Text("Email updated successfully.")),
            //         // );
            //         //   Navigator.pop(context); // Navigate back
            //       } catch (e) {
            //         // Show an error message
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text("Error $e")),
            //         );
            //         print(e.toString());
            //       }
            //     }
            //     //updateEmail(context);
            //   },
            //   child: Text("Update Email"),
            // ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () => updateEmail(context),
            //   child: Text("Update Emaill"),
            // ),
          ],
        ),
      ),
    );
  }
}

    //  Container(
    //           padding: const EdgeInsets.all(16.0),
    //           decoration: BoxDecoration(
    //             color: Colors.grey[200],
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Text(
    //             "vvv ${auth.currentUser!.email}",
    //             style: const TextStyle(
    //               fontFamily: "Poppins",
    //               fontWeight: FontWeight.bold,
    //               fontSize: 14,
    //               color: Colors.black,
    //             ),
    //           ),
    //         ),


    //  TextField(
    //           controller: emailController,
    //           decoration: InputDecoration(labelText: "New Email"),
    //         ),

        // TextField(
            //   controller: emailController,
            //   decoration: InputDecoration(labelText: "Enter New Email"),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   child: Text(
            //     "vvv ${auth.currentUser!.email}",
            //     style: const TextStyle(
            //       fontFamily: "Poppins",
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),