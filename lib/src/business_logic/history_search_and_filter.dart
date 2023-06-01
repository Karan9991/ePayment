import 'package:flutter/material.dart';

import '../data/receipt_model.dart';

class HistoryPageSearch extends ChangeNotifier {
  List<Receipt> searchedReceiptsList = [];
  List<Receipt> result = [];
  List<Receipt> defaultList = [];
  bool isStreamList = true;

  changed() {
    isStreamList = false;
    notifyListeners();
  }

  returnToStreamList() {
    isStreamList = true;
    notifyListeners();
  }

  getReceipts(receipts) {
    searchedReceiptsList = receipts;
    defaultList = receipts;
    notifyListeners();
  }

  searchReceipts(String keyWord) {
    for (final e in searchedReceiptsList) {
      if (e.refNo == keyWord) {
        result.add(e);
        return searchedReceiptsList = result;
      } else if (keyWord == "" || e.refNo != keyWord) {
        result.clear();
        searchedReceiptsList = defaultList;
        notifyListeners();
      }
      notifyListeners();
    }
    notifyListeners();
  }

  filterReceipts(DateTime startDate, DateTime endDate, context) {
    endDate = endDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    for (final e in searchedReceiptsList) {

      if (e.createdAt!.isBefore(endDate) && e.createdAt!.isAfter(startDate)) {
        result.add(e);
        searchedReceiptsList = result;
        notifyListeners();
      }
      notifyListeners();
    }
    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "There is no receipts in this period of time !",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
        ),
      )));
    }
    notifyListeners();
  }

  clearResult() {
    result.clear();
    notifyListeners();
  }
}
