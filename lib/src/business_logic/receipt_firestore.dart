import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../data/receipt_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class ReceiptFirestore extends ChangeNotifier {
  bool isExist = true;
  final _db = FirebaseFirestore.instance;
  String? existReceiptPhotoLink;
  String? existOriginalReceiptPhotoLink;
  Stream<DocumentSnapshot>? qSnapShot;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? existReceiptPhotoFile;
  File? existOriginalReceiptPhotoFile;

  createReceiptDataToFirestore(refNo, finalReceiptPhotoLink, originalReceiptPhotoLink) async {
    final receipts = _db.collection("receipts ${_auth.currentUser!.uid}");
    final receipt = <String, dynamic>{
      "refNo": refNo,
      "FinalReceiptPhotoLink": finalReceiptPhotoLink,
      "OriginalReceiptPhotoLink": originalReceiptPhotoLink,
      "createdAt": Timestamp.now(),
    };
    await receipts.doc(refNo).set(receipt);
  }

  getReceiptDataFromFirestore(refNo) async {
    final docRef =
        _db.collection("receipts ${_auth.currentUser!.uid}").doc(refNo);

    await docRef.get().then(
      (DocumentSnapshot doc) async {
        if (doc.exists) {
          isExist = true;
          var data =  doc.data() as Map<String, dynamic>;
          existReceiptPhotoLink = data["FinalReceiptPhotoLink"];
          existOriginalReceiptPhotoLink = data["OriginalReceiptPhotoLink"];

          notifyListeners();
        } else {
          isExist = false;

          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  Stream<List<Receipt>> getReceiptsList() {

    return _db
        .collection("receipts ${_auth.currentUser!.uid}").orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapShot) =>
            snapShot.docs.map((doc) => Receipt.fromJson(doc.data())).toList());

  }

  downloadReceiptsPhoto(photoLink, bool isOriginal)async{
    final response = await http.get(Uri.parse(photoLink));

        final tempDir = await getTemporaryDirectory();


    if(isOriginal==true){
      final file = await File('${tempDir.path}/imageFinal.jpg-${DateTime.now()}').create();
      existReceiptPhotoFile=file;
      existReceiptPhotoFile?.writeAsBytesSync(response.bodyBytes);
      notifyListeners();
    }else{
      final file = await File('${tempDir.path}/imageOriginal.jpg-${DateTime.now()}').create();
      existOriginalReceiptPhotoFile=file;
    existOriginalReceiptPhotoFile?.writeAsBytesSync(response.bodyBytes); // ByteData

    notifyListeners();}

notifyListeners();
  }
}
