import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/loading_state.dart';
import 'package:e_payment/src/business_logic/original_photo_url.dart';
import 'package:e_payment/src/business_logic/recognize_photo_text.dart';
import '../../business_logic/add_fee.dart';
import '../../business_logic/receipt_firestore.dart';
import '../../business_logic/final_receipt_details_to_photo.dart';
import '../../business_logic/image_provider.dart';
import '../../business_logic/signature_provider.dart';
import '../../business_logic/upload_receipt_photo.dart';

const TextStyle dataRecognizedStyle = TextStyle(
  color: Color.fromRGBO(7, 38, 85, 1),
  fontFamily: "Poppins",
);

class ConfirmingAllDetails extends StatelessWidget {
  const ConfirmingAllDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignatureProvider signatureProvider =
        Provider.of<SignatureProvider>(context);
    final RecognizeText recognizeText = Provider.of<RecognizeText>(context);
    final AddFee addFee = Provider.of<AddFee>(context);
    final ReceiptDetailsToPhoto receiptDetailsToPhoto =
        Provider.of<ReceiptDetailsToPhoto>(context);
    final UploadReceiptPhoto uploadReceiptPhoto =
        Provider.of<UploadReceiptPhoto>(context);
    ReceiptFirestore checkReceiptExistence =
        Provider.of<ReceiptFirestore>(context);
    OriginalPhotoUrl originalPhotoUrl = Provider.of<OriginalPhotoUrl>(context);
    ConfirmationLoadingState confirmationLoadingState =
        Provider.of<ConfirmationLoadingState>(context);
    final PhotoProvider photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
          centerTitle: true,
          title: const Text(
            'Confirming Details',
            style: TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        ),
        body:WillPopScope(
          onWillPop: () async {
            signatureProvider.deleteSignature();
            Navigator.pop(context);
            return true;
          },
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 555,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(0, 0, 254, 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Final Receipt",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      RepaintBoundary(
                        key: receiptDetailsToPhoto.globalKey,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            height: 450,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Ref NO. : ${recognizeText.refNo}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Text(
                                    "Amount : P ${recognizeText.amount}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Text(
                                    "Date : ${recognizeText.dateAndTime}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Text(
                                    "Receiving Date : ${recognizeText.dateNow}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Text(
                                    "Total Amount: P ${addFee.totalAmount}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Text(
                                    "Name: ${recognizeText.receiptName}",
                                    style: dataRecognizedStyle,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Signature:"),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image.memory(
                                            signatureProvider.signature!),
                                        // Image.file(signatureProvider
                                        //     .signatureImageFile!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ), //final receipt
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () async {
                    HapticFeedback.vibrate();
                    confirmationLoadingState.loading();
                    await uploadReceiptPhoto.uploadFile(photoProvider.photo!);
                    await originalPhotoUrl
                        .setOriginalPhotoLink(uploadReceiptPhoto.finalReceiptUrl);

                    await receiptDetailsToPhoto
                        .captureWidget(recognizeText.refNo);


                    await uploadReceiptPhoto.uploadFile(
                        receiptDetailsToPhoto.confirmedReceiptPhotoFile!);
                    checkReceiptExistence.createReceiptDataToFirestore(
                        "${recognizeText.refNo}", uploadReceiptPhoto.finalReceiptUrl,originalPhotoUrl.originalPhotoUrl);

                    if (!context.mounted) return;
                    confirmationLoadingState.notLoading();
                    Navigator.popAndPushNamed(context, '/shareAndPrint');
                  },
                  child: Center(
                    child: confirmationLoadingState.isLoading
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircularProgressIndicator(color: Colors.green),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Loading...",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: "Poppins",
                                ),
                              )
                            ],
                          )
                        : Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                      fontSize: 15),
                                ),
                              ],
                            ))),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    super.key,
    required this.recognizeText,
    required this.addFee,
    required this.signatureProvider,
  });

  final RecognizeText recognizeText;
  final AddFee addFee;
  final SignatureProvider signatureProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            height: 450,
                            width: 300,
                            decoration: BoxDecoration(
     color: Colors.white,
     borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     mainAxisAlignment:
         MainAxisAlignment.spaceEvenly,
     children: [
       Text(
         "Ref NO. : ${recognizeText.refNo}",
         style: dataRecognizedStyle,
       ),
       Text(
         "Amount : P ${recognizeText.amount}",
         style: dataRecognizedStyle,
       ),
       Text(
         "Date : ${recognizeText.dateAndTime}",
         style: dataRecognizedStyle,
       ),
       Text(
         "Receiving Date : ${recognizeText.dateNow}",
         style: dataRecognizedStyle,
       ),
       Text(
         "Total Amount: P ${addFee.totalAmount}",
         style: dataRecognizedStyle,
       ),
       Text(
         "Name: ${recognizeText.receiptName}",
         style: dataRecognizedStyle,
       ),
       Row(
         children: [
           const Text("Signature:"),
           const SizedBox(
             width: 50,
           ),
           SizedBox(
             height: 80,
             width: 80,
             child: Image.memory(
                 signatureProvider.signature!),
             // Image.file(signatureProvider
             //     .signatureImageFile!),
           ),
         ],
       ),
     ],
                              ),
                            ),
                          ), //final receipt
                        );
  }
}
