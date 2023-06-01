import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OneSessionLogin extends ChangeNotifier {
  bool isLoggedIn=false;
  final _db = FirebaseFirestore.instance;

  loggedIn() {
    isLoggedIn = true;
    notifyListeners();
  }
  notLoggedIn(){
    isLoggedIn = false;
    notifyListeners();
  }

  sendSessionData(email) async {
    final usersSessions = _db.collection("usersSessions");
    final session = <String, dynamic>{
      "isLoggedIn": isLoggedIn,
    };
    await usersSessions.doc(email.toLowerCase()).set(session);
  }

  getSessionData(email) async {
    try{
      final docRef = _db.collection("usersSessions").doc(email.toLowerCase());
    await docRef.get().then(
          (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        isLoggedIn = data['isLoggedIn'];
        notifyListeners();
      },
    );
    notifyListeners();
    }catch(e){
    isLoggedIn=false;
   await sendSessionData(email.toLowerCase());
    notifyListeners();
  }
  }
}
