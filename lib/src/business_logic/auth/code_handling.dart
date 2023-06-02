import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_payment/src/data/free_code_list.dart';
import 'package:e_payment/src/data/one_week_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:e_payment/src/data/lifetime_code_list.dart';
import 'package:e_payment/src/data/one_month_code.dart';
import 'package:e_payment/src/data/one_year_code_list.dart';

class CodeHandling extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  String? code;
  String retrievedLifeTimeCode = "";
  String retrievedOneYearCode = "";
  String retrievedMonthCode = "";
  String retrievedWeekCode = "";
  String retrievedFreeCode = "";

  getCode(enteredCode) {
    code = enteredCode;
    notifyListeners();
  }

  addLifeTimeCodeToFirebase() async {
    final codes = _db.collection("codes");
    final codeValue = <String, dynamic>{
      "code": code,
    };
    await codes.doc("LifeTimeAccess").set(codeValue);
  }

  addWeekCodeToFirebase() async {
    final codes = _db.collection("codes");
    final codeValue = <String, dynamic>{
      "code": code,
    };
    await codes.doc("OneWeekAccess").set(codeValue);
  }

  addOneYearCodeToFirebase() async {
    final codes = _db.collection("codes");
    final codeValue = <String, dynamic>{
      "code": code,
    };
    await codes.doc("OneYearAccess").set(codeValue);
  }

  addOneMonthCodeToFirebase() async {
    final codes = _db.collection("codes");
    final codeValue = <String, dynamic>{
      "code": code,
    };
    await codes.doc("OneMonthAccess").set(codeValue);
  }

  addFreeLicenseCodeToFirebase() async {
    final codes = _db.collection("codes");
    final codeValue = <String, dynamic>{
      "code": code,
    };
    await codes.doc("FreeLicenseAccess").set(codeValue);
  }

  getLifeTimeCodeFromFirebase() async {
    final docRef = _db.collection("codes").doc("LifeTimeAccess");
    await docRef.get().then(
      (DocumentSnapshot doc) async {
        var data = doc.data() as Map<String, dynamic>;
        retrievedLifeTimeCode = data["code"];
        lifeTimeCodeList.add(retrievedLifeTimeCode);
        notifyListeners();
      },
    );
  }

  getOneWeekCodeFromFirebase() async {
    final docRef = _db.collection("codes").doc("OneWeekAccess");
    await docRef.get().then(
      (DocumentSnapshot doc) async {
        var data = doc.data() as Map<String, dynamic>;
        retrievedWeekCode = data["code"];
        weekCodeList.add(retrievedWeekCode);
        notifyListeners();
      },
    );
  }

  getOneYearCodeFromFirebase() async {
    final docRef = _db.collection("codes").doc("OneYearAccess");
    await docRef.get().then(
      (DocumentSnapshot doc) async {
        var data = doc.data() as Map<String, dynamic>;
        retrievedOneYearCode = data["code"];
        oneYearCodeList.add(retrievedOneYearCode);
        notifyListeners();
      },
    );
  }

  getOneMonthCodeFromFirebase() async {
    final docRef = _db.collection("codes").doc("OneMonthAccess");
    await docRef.get().then(
      (DocumentSnapshot doc) async {
        var data = doc.data() as Map<String, dynamic>;
        retrievedMonthCode = data["code"];
        oneMonthCodeList.add(retrievedMonthCode);
        notifyListeners();
      },
    );
  }

  getFreeLicenseCodeFromFirebase() async {
    final docRef = _db.collection("codes").doc("FreeLicenseAccess");
    await docRef.get().then(
      (DocumentSnapshot doc) async {
        var data = doc.data() as Map<String, dynamic>;
        retrievedFreeCode = data["code"];
        freeCodeList.add(retrievedFreeCode);
        notifyListeners();
      },
    );
  }

  deleteCode() async {
    code = "'''''''''''%^!ضًٌَُ@!.*'";
    await addOneYearCodeToFirebase();
    await addLifeTimeCodeToFirebase();
    await addOneMonthCodeToFirebase();
    await addWeekCodeToFirebase();
    await addFreeLicenseCodeToFirebase();

    notifyListeners();
  }
}
