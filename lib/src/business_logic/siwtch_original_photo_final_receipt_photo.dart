import 'package:flutter/cupertino.dart';

class SwitchReceiptPhoto extends ChangeNotifier {
  bool isOriginal = false;

  switchPhoto() {
    isOriginal ? isOriginal = false : isOriginal = true;

    notifyListeners();
  }
}
