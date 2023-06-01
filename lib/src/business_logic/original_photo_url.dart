import 'package:flutter/cupertino.dart';

class OriginalPhotoUrl extends ChangeNotifier{
  String? originalPhotoUrl;
  setOriginalPhotoLink(photoLink)async{
    originalPhotoUrl=await photoLink;
    notifyListeners();
  }
}
