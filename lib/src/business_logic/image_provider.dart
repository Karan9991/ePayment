import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProvider extends ChangeNotifier {

  File? photo;

  Future pickPhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final photoTemp = File(image.path);
      photo = photoTemp;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takePhoto() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final photoTemp = File(image.path);
      photo = photoTemp;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to take image: $e');
    }
  }

  deletePhoto(){
    photo=null;
    notifyListeners();
  }
}
