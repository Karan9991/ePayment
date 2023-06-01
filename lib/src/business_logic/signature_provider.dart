import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import '../presentation/screen/confirming_all_details_screen.dart';

class SignatureProvider extends ChangeNotifier {
  SignatureController? controller =
      SignatureController(penStrokeWidth: 4, penColor: Colors.black);
  Uint8List? signature;
  File? signatureImageFile;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  onConfirmPressed(context) async {
    if (controller!.isNotEmpty) {
      await _exportSignature();
      notifyListeners();
      if (!context.mounted) return;

      NavigateToScreen().navToScreen(context,  const ConfirmingAllDetails());
      controller!.clear();


    }
    notifyListeners();
  }

  void setOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    notifyListeners();
  }

  _exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: controller!.points,
    );

    signature = await exportController.toPngBytes();

    Uint8List imageInUnit8List = signature!;// store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    signatureImageFile = await File('${tempDir.path}/image.jpg').create();
    signatureImageFile?.writeAsBytesSync(imageInUnit8List);


    exportController.dispose();

  }
  deleteSignature(){
    signatureImageFile?.delete();
    controller!.clear();
    notifyListeners();
  }
}
