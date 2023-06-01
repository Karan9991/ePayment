import 'package:flutter/material.dart';
class LoginSuccessWidget extends StatelessWidget {
  const LoginSuccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      title: const Text(
        "You Registered successfully !",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.green,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
          child: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child:const Icon(Icons.done_sharp,color: Colors.white,)),
          )
      ),
    );
  }
}