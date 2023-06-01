import 'dart:async';
import 'package:e_payment/src/business_logic/auth/sign_out.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../global_context.dart';

class AutoLogoutService {
  static Timer? _timer;
  static const autoLogoutTimer = 15;
  var oneSession;
  var signup;
  var signin;
  var auth= FirebaseAuth.instance;
AutoLogoutService({ required this.oneSession, required this.signup,
  required this.signin,
});
  /// Resets the existing timer and starts a new timer
  startNewTimer() {
    stopTimer();
    if (auth.currentUser!=null) {
       _timer = Timer.periodic(const Duration(minutes: autoLogoutTimer), (_) {
        timedOut();
      });
    }
  }

  /// Stops the existing timer if it exists
  void stopTimer() {
    if (_timer != null || (_timer?.isActive != null && _timer!.isActive)) {
      _timer?.cancel();
    }
  }

  /// Track user activity and reset timer
  void trackUserActivity([_]) async {
    print('User Activity Detected!');
    if (auth.currentUser!=null && _timer != null) {

       startNewTimer();
    }
  }

  /// Called if the user is inactive for a period of time and opens a dialog
  Future<void> timedOut() async {

    stopTimer();
    if (auth.currentUser!=null) {
      SignOut().signOut();
      NavigateToScreen().navToScreen(GlobalContextService.navigatorKey.currentContext, const SignInScreen());

      oneSession.notLoggedIn();
     oneSession
          .sendSessionData(auth.currentUser!.email);
      if (signin.userEmail != "") {
        oneSession.notLoggedIn();
         await oneSession
            .sendSessionData(signin.userEmail);


      } else {
        oneSession.notLoggedIn();
        await oneSession
            .sendSessionData(signup.userEmail);

      }

    }
  }
}