
import 'package:e_payment/src/business_logic/auth/user_activity_detector.dart';
import 'package:e_payment/src/business_logic/global_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/providers_list.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';
import 'package:e_payment/src/presentation/screen/phone_auth_screen.dart';
import 'package:e_payment/src/presentation/screen/share_and_print_screen.dart';

import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() async {
  WidgetsBinding widgetsBinding =WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: providers,
      child: UserActivityDetector(
        child: MaterialApp(
          navigatorKey: GlobalContextService.navigatorKey,
          debugShowCheckedModeBanner: true,
            theme: ThemeData.light(),
            home:  FirebaseAuth.instance.currentUser == null ? const SignInScreen(): const HomeScreen(),
          routes: {

            '/phoneAuth': (context) =>  PhoneAuthScreen(),
            '/shareAndPrint': (context) => const ShareAndPrintScreen(),
          },
        ),
      ),
    ),
  );
}
