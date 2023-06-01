import 'package:flutter/cupertino.dart';

class AddFee extends ChangeNotifier {
  int? amount;
  double? totalAmount = 0;
  double? fee;
  int? addedFee;
  int? percentageOfFee;
  int? deductFee;

  final List<String> items = [
    'Add Fee',
    'Percentage Fee',
    'Deduct Fee'
  ];
  String selectedOption = "Deduct Fee";

  setDeductedFee(dedFee) {
    deductFee = dedFee;
    notifyListeners();
  }

  setPercentageOfFee(percentageOfTheFee) {
    percentageOfFee = percentageOfTheFee;
    notifyListeners();
  }

  setAddedFee(theAddedFee) {
    addedFee = theAddedFee;
    notifyListeners();
  }

  selectOption(option) {
    selectedOption = option;
    notifyListeners();
  }

  setAmount(recognizedAmount) {
    amount = recognizedAmount;
    notifyListeners();
  }

  manuallyAddFee() {
    fee = addedFee?.toDouble();
    totalAmount = (amount! + fee!);
    notifyListeners();
  }

  percentageFee() {
    fee = ((percentageOfFee! / 100) * amount!);
    totalAmount = (amount! + fee!);
    notifyListeners();
  }

  deductingFee() {
    totalAmount = amount! - deductFee!.toDouble();
    notifyListeners();
  }

  // specialCaseFee() {
  //   if (amount! >= 1 && amount! <= 300) {
  //     fee = 10;
  //     totalAmount = (amount! + fee!);
  //   } else if (amount! > 300 && amount! <= 2000) {
  //     fee = 15;
  //     totalAmount = (amount! + fee!);
  //   } else if (amount! > 2000) {
  //     fee = 30;
  //     int diff = 1000;
  //     var cond = amount! - 2000;
  //     for (diff; diff < cond; diff = diff + 1000) {
  //       fee = fee! + 15;
  //     }
  //     totalAmount = (amount! + fee!);
  //   }
  //   notifyListeners();
  // }

  disposeFee() {
    amount=null;
    totalAmount = 0;
    fee=null;
    addedFee=null;
    percentageOfFee=null;
    deductFee=null;
    notifyListeners();
  }
}
