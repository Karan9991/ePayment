import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/add_fee.dart';
import 'package:e_payment/src/business_logic/final_receipt_details_to_photo.dart';
import 'package:e_payment/src/business_logic/image_provider.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/business_logic/recognize_photo_text.dart';
import 'package:e_payment/src/business_logic/share_provider.dart';
import 'package:e_payment/src/business_logic/siwtch_original_photo_final_receipt_photo.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';
import 'package:e_payment/src/presentation/widget/back_button.dart';
import '../../business_logic/loading_state.dart';
import 'package:gallery_saver/gallery_saver.dart';



class ShareAndPrintScreen extends StatelessWidget {
  const ShareAndPrintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReceiptDetailsToPhoto receiptDetailsToPhoto =
    Provider.of<ReceiptDetailsToPhoto>(context);
    final SwitchReceiptPhoto switchReceiptPhoto =
    Provider.of<SwitchReceiptPhoto>(context);
    final PhotoProvider photoProvider = Provider.of<PhotoProvider>(context);
    ConfirmationLoadingState confirmationLoadingState=Provider.of<ConfirmationLoadingState>(context);
    ConfirmingPhotoLoadingState confirmingPhotoLoadingState=Provider.of<ConfirmingPhotoLoadingState>(context);
    final RecognizeText recognizeText = Provider.of<RecognizeText>(context);
    final AddFee addFee = Provider.of<AddFee>(context);


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body:SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,40,0,0),
                      child: NavigateBackButton(icon: Icons.home, onPressed: () {
                        confirmationLoadingState.notLoading();
                        confirmingPhotoLoadingState.notLoading();
                        recognizeText.disposeRec();
                        addFee.disposeFee();
                        NavigateToScreen().navToScreen(
                            context, const HomeScreen());
                      },),
                    )),
                switchReceiptPhoto.isOriginal
                    ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                      height:530,
                      width: 400,
                      child: Image.file(photoProvider.photo!)),
                    )
                    : Image.file(
                    receiptDetailsToPhoto.confirmedReceiptPhotoFile!),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.vibrate();

                          // NavigateToScreen()
                          //     .navToScreen(context, const PrintScreen());
                         await GallerySaver.saveImage( switchReceiptPhoto.isOriginal
                              ?photoProvider.photo!.path:receiptDetailsToPhoto.confirmedReceiptPhotoFile!.path
                          );
                         // await SaverGallery.saveFile(file: switchReceiptPhoto.isOriginal
                         //     ?photoProvider.photo!.path:receiptDetailsToPhoto.confirmedReceiptPhotoFile!.path,
                         //     androidExistNotSave: true, name: 'receipt${DateTime.now()}.jpg',androidRelativePath: "Photos");




                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(

                             content: Text(
                               "Receipt Saved Successfully in Gallery !",
                               style: TextStyle(color: Colors.white,fontFamily: "Poppins",),
                             )));


                        },
                        child: const Icon(
                          Icons.download_for_offline_outlined,
                          size: 50,
                          color: Color.fromRGBO(7, 38, 85, 1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.vibrate();

                          await ShareReceipt(
                              file: switchReceiptPhoto.isOriginal
                                  ? photoProvider.photo!
                                  : receiptDetailsToPhoto
                                  .confirmedReceiptPhotoFile!)
                              .share();
                        },
                        child: const Icon(
                          Icons.share,
                          size: 50,
                          color: Color.fromRGBO(7, 38, 85, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    HapticFeedback.vibrate();

                    switchReceiptPhoto.switchPhoto();
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 254, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              switchReceiptPhoto.isOriginal
                                  ? "Switch to final receipt"
                                  : "Switch to original receipt",
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
