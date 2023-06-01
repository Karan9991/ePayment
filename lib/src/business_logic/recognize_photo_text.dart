import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ntp/ntp.dart';
import 'package:e_payment/src/business_logic/image_provider.dart';
import 'package:intl/intl.dart';

class RecognizeText extends ChangeNotifier {
  final PhotoProvider photoProvider = PhotoProvider();
  InputImage? inputImage;
  String scannedText = '';
  String? refNo;
  int? amount;
  String? dateAndTime;
  String? receiptName;
  String? dateNow;

  getName(name) {
    receiptName = name;
    notifyListeners();
  }

  _setInputImage(photo) {
    inputImage = InputImage.fromFile(photo);
  }

  recognizingText(photo) async {
    var dateNowTemp = await NTP.now();
    DateFormat dateFormat = DateFormat("MM-dd-yyyy HH:mm");
    dateNow = dateFormat.format(dateNowTemp);
    _setInputImage(photo);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage!);
    await textRecognizer.close();
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText..${line.text}\n";
        if (line.text.contains("Ref No.") ||
            line.text.contains("Reference Number") ||
            line.text.contains("Reference Number:") ||
            line.text.contains("Ref No") ||
            line.text.contains("Ref No:") ||
            line.text.contains("Ref. No.") ||
            line.text.contains("Ref No.:")) {
          String? find;
          if (line.text.contains("Ref No.")) {
            find = "Ref No.";
            notifyListeners();
          }
          if (line.text.contains("Ref. No.")) {
            find = "null";
            notifyListeners();
          }
          if (line.text.contains("Reference Number")) {
            find = "Reference Number";
            notifyListeners();
          }
          if (line.text.contains("Reference Number:")) {
            find = "Reference Number:";
            notifyListeners();
          }
          if (line.text.contains("Ref No")) {
            find = "Ref No";
            notifyListeners();
          }
          if (line.text.contains("Ref No:")) {
            find = "Ref No:";
            notifyListeners();
          }
          if (line.text.contains("Ref No.:")) {
            find = "Ref No.:";
            notifyListeners();
          }

          String tempRefNo = line.text.replaceAll(find!, '');
          //balance is PHP0.47, Ref. No. 2009658108209
          if (line.text.contains("Ref. No.")) {
            var temp = "${line.text}.";

            const start = "Ref. No.";
            const end = ".";
            final startIndex = temp.indexOf(start);
            final endIndex = temp.indexOf(end, startIndex + start.length);
            return refNo = temp.substring(startIndex + start.length, endIndex).replaceAll( RegExp('[^A-Za-z0-9]'), '');
          } else {
            refNo = tempRefNo.replaceAll(RegExp('[^A-Za-z0-9]'), '');
            notifyListeners();
          }
        } else if (line.text.contains("00") &&
                line.text.contains(".") &&
                line.text.contains("P") ||
            line.text.contains("PHP") && line.text.contains("to")) {
          RegExp regex = RegExp(r'([.]*0+)(?!.*\d)');
          var tempTotalAmount = line.text
              .replaceAll(RegExp(r'[^0-9.]'), '')
              .replaceAll(regex, '')
              .replaceAll('.', '');
          amount = int.parse(tempTotalAmount);
        } else if (line.text.contains("PM") ||
            line.text.contains("AM") && line.text.contains(":")) {
          dateAndTime = line.text;
          if (line.text.contains("PM") && line.text.contains("on")) {
            var temp = line.text;
            const start = "on";
            const end = "PM";

            final startIndex = temp.indexOf(start);
            final endIndex = temp.indexOf(end, startIndex + start.length);

            dateAndTime =
                "${temp.substring(startIndex + start.length, endIndex)}PM";
            notifyListeners();
          }
          if (line.text.contains("AM") && line.text.contains("on")) {
            var temp = line.text;
            const start = "on";
            const end = "AM";

            final startIndex = temp.indexOf(start);
            final endIndex = temp.indexOf(end, startIndex + start.length);

            dateAndTime =
                "${temp.substring(startIndex + start.length, endIndex)}AM";
            notifyListeners();
          }
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }

  disposeRec() {
    inputImage = null;
    scannedText = "";
    refNo = null;
    amount = null;
    dateAndTime = null;
    receiptName = null;
    dateNow = null;
    notifyListeners();
  }
}
