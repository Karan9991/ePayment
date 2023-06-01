import 'package:flutter/material.dart';
class FloatingBtn extends StatelessWidget {
  final void Function()? onTap;
  final Icon? icon;
  const FloatingBtn({
    this.onTap,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color:const Color.fromRGBO(0, 0, 254, 1).withOpacity(0.3) ,
                border: Border.all(
                    color:const Color.fromRGBO(0, 0, 254, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            child: icon,

          ),
        ),
      ),
    );
  }
}
