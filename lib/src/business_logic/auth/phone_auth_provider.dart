import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';

import '../../presentation/widget/login_success_alert.dart';
import '../navigate_to_screen.dart';

class PhoneAuth extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userNumber = '';
  String receivedID = "";
  String newEmail = "";
  String otpCode = "";
  String errorMessage = "";
  bool otpVisibility = false;
  bool isSendPressed = false;
  PhoneAuthCredential? credential;

  getPhoneNum(uNum) {
    userNumber = "+63$uNum";
    notifyListeners();
  }

  getOtpCode(otp) {
    otpCode = otp;
    notifyListeners();
  }

  getNewEmail(nEmail) {
    newEmail = nEmail;
    notifyListeners();
  }

  verifyUserPhoneNumber(context) {
    if (userNumber != '' && userNumber.length == 13 && isSendPressed == false) {
      auth.verifyPhoneNumber(
        phoneNumber: userNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          NavigateToScreen().navToScreen(context, const HomeScreen());

        },
        verificationFailed: (FirebaseAuthException e) {
          errorMessage = e.message!;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Create a PhoneAuthCredential with the code
          otpVisibility = true;
          receivedID = verificationId;

          // Sign the user in (or link) with the credential

          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
      );
    } else if (userNumber == '' || userNumber.length !=13) {
      errorMessage = "-Please enter a valid phone number ! \n -Make sure there is no leading '0' ";

    } else if (userNumber != '' && isSendPressed == true) {
      errorMessage = '"Please wait 50 seconds before send again !"';
    }
    notifyListeners();
  }

  Future<void> verifyOTPCode(context, screen, isReset) async {
    credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: otpCode,
    );

    if (isReset == true) {
      try{
        await auth.signInWithCredential(credential!);

      }
      catch(e){
        errorMessage=e.toString();
        notifyListeners();
      }

    } else {
      try{
        await auth.currentUser?.updatePhoneNumber(credential!);
      }catch(e){
        errorMessage=e.toString();
        notifyListeners();
      }

    }

    if (auth.currentUser?.phoneNumber != null) {
      NavigateToScreen().navToScreen(context, screen);
      showDialog(
          context: context, builder: (context) {

        return  const LoginSuccessWidget();
      }
      );
    } else {
      errorMessage = "Please enter a valid phone number and try again !";
      notifyListeners();
    }
  }

  resetEmail(context) async {
    if (newEmail != '' && isSendPressed == false) {
      try {
        await auth.currentUser?.updateEmail(newEmail);
        NavigateToScreen().navToScreen(context, const HomeScreen());

      } catch (e) {
        errorMessage = e.toString();
        notifyListeners();
      }
    } else if (newEmail == '') {
      errorMessage = "Please enter an email !";
    }
    notifyListeners();
  }

  sendOTPPressed(context) async {
    errorMessage = "";
    await verifyUserPhoneNumber(context);
    if (errorMessage != '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
        ),
      )));
    } else {
      isSendPressed = true;
      Timer(const Duration(seconds: 50), () {
        isSendPressed = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  resetEmailPressed(context) async {
    errorMessage = "";
    await resetEmail(context);
    if (errorMessage != '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
        ),
      )));
    }
    notifyListeners();
  }
}
