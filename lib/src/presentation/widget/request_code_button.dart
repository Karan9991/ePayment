import 'package:flutter/material.dart';

class RequestCodeWidget extends StatelessWidget {
  final void Function()? onTap;

  const RequestCodeWidget({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You can request activation code from",
            style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              "Here",
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 254, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
