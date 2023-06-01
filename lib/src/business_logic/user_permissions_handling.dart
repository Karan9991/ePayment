import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
class PermissionHandling extends ChangeNotifier{
  dynamic cameraStatus;
  dynamic storageStatus;
  getPermissionStatus()async{
    cameraStatus = await Permission.camera.status;
    storageStatus=await Permission.storage.status;
    notifyListeners();
  }

  grantCameraPermissions(){
    Permission.camera.request();
  }
  grantStoragePermissions(){
    Permission.storage.request();
  }
}