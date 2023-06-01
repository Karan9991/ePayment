import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../business_logic/receipt_firestore.dart';
import '../../business_logic/share_provider.dart';
import '../../business_logic/siwtch_original_photo_final_receipt_photo.dart';
class ExistReceiptAlertWidget extends StatelessWidget {
  const ExistReceiptAlertWidget({
    super.key,
    required this.switchReceiptPhoto,
    required this.receiptFirestore,
  });

  final SwitchReceiptPhoto switchReceiptPhoto;
  final ReceiptFirestore receiptFirestore;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Receipt already exist! ",
        style: TextStyle(
          color: Colors.red,
          fontFamily: "Poppins",
        ),
      ),
      content: SizedBox(
        height: 420,
        child: Column(
          children: [
            Image.network(
              switchReceiptPhoto.isOriginal?receiptFirestore.existOriginalReceiptPhotoLink!
                  :receiptFirestore.existReceiptPhotoLink!,
              height: 300,
              fit: BoxFit.contain,
              frameBuilder:
                  (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                        child:
                        CircularProgressIndicator(
                          color: Colors.red,
                        )),
                  );
                }
                return image;
              },
              loadingBuilder: (BuildContext context,
                  Widget image,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null)
                  return image;
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress
                          .expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          loadingProgress
                              .expectedTotalBytes!
                          : null,
                      color: Colors.red,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) =>
              const Text(
                "Check Internet connection",
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async{

                    // NavigateToScreen()
                    //     .navToScreen(context, const PrintExistReceiptScreen());
                    await  GallerySaver.saveImage(receiptFirestore.existReceiptPhotoFile!.path);
                    //
                    //  await SaverGallery.saveFile(file: receiptFirestore.existReceiptPhotoFile!.path,
                    //      androidExistNotSave: true,
                    //      name: 'receipt${DateTime.now()}.jpg',androidRelativePath: "Photos");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(

                        content: Text(
                          "Receipt Saved Successfully in Gallery !",
                          style: TextStyle(color: Colors.white,fontFamily: "Poppins",),
                        )));

                  },
                  child: const Icon(
                    Icons.download_for_offline_outlined,
                    size: 50,
                    color:
                    Color.fromRGBO(7, 38, 85, 1),
                  ),
                ),//save btn
                GestureDetector(
                  onTap: () async {
                    await ShareReceipt(
                        file: receiptFirestore
                            .existReceiptPhotoFile!)
                        .share();
                  },
                  child: const Icon(
                    Icons.share,
                    size: 50,
                    color:
                    Color.fromRGBO(7, 38, 85, 1),
                  ),
                ),//share btn
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () async {
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
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}