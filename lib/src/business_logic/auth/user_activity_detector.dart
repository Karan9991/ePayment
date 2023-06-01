import 'package:e_payment/src/business_logic/auth/auto_logout.dart';
import 'package:e_payment/src/business_logic/auth/sign_in_provider.dart';
import 'package:e_payment/src/business_logic/auth/signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'one_session_login.dart';

class UserActivityDetector extends StatefulWidget {
   const UserActivityDetector({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<UserActivityDetector> createState() => _UserActivityDetectorState();
}

class _UserActivityDetectorState extends State<UserActivityDetector> {
  // Instance of Auto Logout Service, prefer using singleton
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance.currentUser;

    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);
    final AutoLogoutService autoLogoutService = AutoLogoutService(
        oneSession: oneSessionLogin,
        signin: signInProvider,
        signup: signupProvider,
    );

      if (auth != null) {
        autoLogoutService.startNewTimer();
      }

    // FocusScope.of(context).requestFocus(focusNode);
    return
     GestureDetector(
        // Important for detecting the clicks properly for clickable and non-clickable places.
        behavior: HitTestBehavior.deferToChild,
        onTapDown: autoLogoutService.trackUserActivity,
        child: widget.child,
      );
  }
}
