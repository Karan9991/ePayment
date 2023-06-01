import 'package:flutter/material.dart';

class NavigateBackButton extends StatelessWidget {
  final IconData? icon;
 final void Function()? onPressed;
   const NavigateBackButton({
    required this.icon,
     required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
          const Color.fromRGBO(0, 0, 254, 1).withOpacity(0.15),
        ),
        child: IconButton(
         onPressed: onPressed,
          icon:  Icon(
            icon,
            color: const Color.fromRGBO(0, 0, 254, 1),
          ),
          iconSize: 25,
        ),
      ),
    );
  }
}