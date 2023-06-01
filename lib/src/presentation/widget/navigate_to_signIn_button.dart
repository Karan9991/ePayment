import 'package:flutter/material.dart';
import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';

class NavigateToSignInButton extends StatelessWidget {
  const NavigateToSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Do you have an account ? ",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                      const SignInScreen()));
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(0, 0, 254, 1),
              minimumSize: const Size(0, 0),
            ),
            child: const Text(
              "Sign in",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
