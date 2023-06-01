import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';
import'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class SaveFile extends ChangeNotifier{
  File? file;
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Documents");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {

    final String directory = await getExternalDocumentPath();
    return directory;
  }
   Future<void> saveFile(List<int> bytes, String fileName) async {
     final path= await _localPath;
    //Create an empty file to write PDF data
     file = File('$path/$fileName');
    //Write PDF data
    await file!.writeAsBytes(bytes, flush: true);

    notifyListeners();
  }
}
