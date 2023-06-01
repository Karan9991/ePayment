import 'package:flutter/cupertino.dart';

class ObscureTextState extends ChangeNotifier {
  bool passwordObscureText = true;

  changeObscureState() {
    if(passwordObscureText==true){
      passwordObscureText=false;
    }else{
      passwordObscureText=true;
    }
    notifyListeners();
  }
}
