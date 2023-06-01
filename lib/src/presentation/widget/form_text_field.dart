import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/obscure_text_changer.dart';

class FormTextField extends StatelessWidget {
  final String fieldTitle;
  final String fieldHintText;
  final bool obscureText;
  String errorText = "";
  Text? btnTitle ;
  bool isPassword;
  bool isPhoneNumField;
  dynamic autofillHints;
  dynamic onEditingComplete;
  final void Function(String)? onChanged;
   void Function()? sendOtpBtn;

  FormTextField({
    required this.obscureText,
    required this.fieldTitle,
    required this.fieldHintText,
    this.errorText = "",
    this.isPassword = false,
    this.isPhoneNumField = false,
    this.sendOtpBtn,
    this.btnTitle,
    required this.onChanged,
    this.autofillHints,
    this.onEditingComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ObscureTextState obscureTextState = Provider.of<ObscureTextState>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isPassword
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: const Color.fromRGBO(0, 0, 254, 1)
                                .withOpacity(0.2)),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: autofillHints,
                          onEditingComplete: onEditingComplete,
                          obscureText: obscureTextState.passwordObscureText,
                          onChanged: onChanged,
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: "Poppins",
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintText: fieldHintText,
                            errorText: errorText,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            obscureTextState.changeObscureState();
                          },
                          child: obscureTextState.passwordObscureText
                              ? const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.indigo,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.indigo,
                                  size: 30,
                                )),
                    )
                  ],
                )
              :isPhoneNumField?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: const Color.fromRGBO(0, 0, 254, 1)
                        .withOpacity(0.2)),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: autofillHints,
                  onEditingComplete: onEditingComplete,
                  obscureText: false,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: "Poppins",
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15),
                    hintText: fieldHintText,
                    errorText: errorText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: sendOtpBtn,
                    child:  btnTitle
                ),
              )
            ],
          ):
          Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color:
                          const Color.fromRGBO(0, 0, 254, 1).withOpacity(0.2)),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: autofillHints,
                    onEditingComplete: onEditingComplete,
                    obscureText: obscureText,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "Poppins",
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      hintText: fieldHintText,
                      errorText: errorText,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
