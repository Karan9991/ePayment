
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class ReceiptDetailsToPhoto extends ChangeNotifier {
   GlobalKey globalKey = GlobalKey();
  Uint8List? confirmedReceiptPhoto;
  File? confirmedReceiptPhotoFile;

   // savePhoto(Uint8List? capturedPhoto)async{
   //   confirmedReceiptPhoto=capturedPhoto;
   //   Uint8List imageInUnit8List = confirmedReceiptPhoto!;// store unit8List image here ;
   //   final tempDir = await getTemporaryDirectory();
   //   confirmedReceiptPhotoFile = await File('${tempDir.path}/FinalReceiptDetailsWithRefNo:${DateTime.now()}.jpg').create();
   //   confirmedReceiptPhotoFile?.writeAsBytesSync(imageInUnit8List);
   //   notifyListeners();
   // }

  captureWidget(refNo) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 1.0);

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    confirmedReceiptPhoto = byteData?.buffer.asUint8List();

    Uint8List imageInUnit8List = confirmedReceiptPhoto!;// store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    confirmedReceiptPhotoFile = await File('${tempDir.path}/FinalReceiptDetailsWithRefNo:$refNo${DateTime.now()}.jpg').create();
    confirmedReceiptPhotoFile?.writeAsBytesSync(imageInUnit8List);

    notifyListeners();
  }

}
