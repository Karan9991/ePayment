import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class UploadReceiptPhoto extends ChangeNotifier{

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

String finalReceiptUrl="";

   uploadFile(File photo) async{

       final fileName = basename(photo.path);
       final destination = 'receipts/$fileName';

       try {

         UploadTask reference = storage.ref(destination)
             .child('file/').putFile(photo);

         finalReceiptUrl = await (await reference).ref.getDownloadURL();
         notifyListeners();

       } catch (e) {
         print('error occurred');
       }

   }

}
