import 'package:flutter/material.dart';


class ConfirmActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final Text buttonText;

  const ConfirmActionButton({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
        backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      child:  buttonText,
    );
  }
}
