import 'package:flutter/material.dart';

class ForgotButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? title;

  const ForgotButton({
    required this.onPressed,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        minimumSize: const Size(0, 0),
      ),
      child: Text(
        title!,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
