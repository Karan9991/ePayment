import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_payment/src/data/receipt_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'save_pdf_file.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class DownloadAndEmail extends ChangeNotifier {
  FirebaseAuth auth=FirebaseAuth.instance;
  PdfDocument pdfDocument = PdfDocument();
  ByteData? byteDataImage;
  File? pdfFile;
  String? platformResponse;


  Future<void> _convertImageToPDF(imageName) async {

    //Add the page
    PdfPage page = pdfDocument.pages.add();
    //Load the image
    final PdfImage pdfImage = PdfBitmap(await _readImageData(imageName));
    //draw image to the first page
     page.graphics.drawImage(
        pdfImage, Rect.fromLTWH(0, 0, page.size.width, page.size.height));
    notifyListeners();
  }

  _savePdfFile() async {
    List<int> bytes = await pdfDocument.save();
    final tempDir = await getTemporaryDirectory();

    String name = DateTime.now().toString().replaceAll(RegExp('[^A-Za-z0-9]'), '');


    final file = await File('${tempDir.path}/imageFinal.jpg-$name').create();
    pdfFile=file;
    pdfFile?.writeAsBytesSync(bytes);
    notifyListeners();


    pdfDocument.dispose();

    //Save the file
    await SaveFile().saveFile(bytes, 'receipts$name.pdf');
    pdfDocument = PdfDocument();
    notifyListeners();
  }

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = byteDataImage!;
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  _downloadReceiptsPhoto(photoLink) async {
    final response = await http.get(Uri.parse(photoLink));
    final tempDir = await getTemporaryDirectory();
    final fileTemp =
        await File('${tempDir.path}/imageOriginal.jpg-${DateTime.now()}')
            .create();
    fileTemp.writeAsBytesSync(response.bodyBytes);
    final bytes = await fileTemp.readAsBytes(); // Uint8List
    byteDataImage = bytes.buffer.asByteData(); // ByteData
    notifyListeners();
  }

  makeReceiptsPdf(List<Receipt> receiptsList, context) async {
    for (final e in receiptsList) {
      await _downloadReceiptsPhoto(e.finalReceiptPhoto);
      await _convertImageToPDF(e.refNo);
    }
    await _savePdfFile();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      "Receipts pdf downloaded successfully !\n Saved in: /storage/emulated/0/Documents",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Poppins",
      ),
    )));
  }
  Future<void> sendPdfToEmail(context,receiptsList) async {
    await makeReceiptsPdf(receiptsList, context);

    final Email email = Email(
      body: "Hello,\n "
          " We hope that you are doing great! "
          "Here are your receipts PDF.",

      subject: "Receipts PDF",
      recipients: [auth.currentUser!.email!],
      attachmentPaths: [pdfFile!.path],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }


  }
}
