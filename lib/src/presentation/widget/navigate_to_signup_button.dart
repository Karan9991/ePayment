import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/presentation/screen/signup_screen.dart';

import '../../business_logic/auth/code_handling.dart';

class NavigateToSignupButton extends StatelessWidget {
  const NavigateToSignupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CodeHandling codeHandling = Provider.of<CodeHandling>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Doesn't have an account ? ",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SignupScreen()));
              await codeHandling
                  .getLifeTimeCodeFromFirebase();
              await codeHandling.getOneYearCodeFromFirebase();
              await codeHandling.getOneMonthCodeFromFirebase();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(0, 0, 254, 1),
              minimumSize: const Size(0, 0),
            ),
            child: const Text(
              "Sign up",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )
      ],
    );
  }
}
