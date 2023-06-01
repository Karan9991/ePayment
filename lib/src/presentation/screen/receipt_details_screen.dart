
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/add_fee.dart';
import 'package:e_payment/src/business_logic/receipt_firestore.dart';
import 'package:e_payment/src/business_logic/siwtch_original_photo_final_receipt_photo.dart';
import 'package:e_payment/src/presentation/screen/signature_screen.dart';
import '../../business_logic/loading_state.dart';
import '../../business_logic/navigate_to_screen.dart';
import '../../business_logic/recognize_photo_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../widget/exist_receipt_alert_widget.dart';

const TextStyle dataRecognizedStyle = TextStyle(
  color: Color.fromRGBO(7, 38, 85, 1),
);

class ReceiptDetailsScreen extends StatelessWidget {
  const ReceiptDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecognizeText recognizeText = Provider.of<RecognizeText>(context);
    final AddFee addFee = Provider.of<AddFee>(context);

    ConfirmingPhotoLoadingState confirmingPhotoLoadingState =
    Provider.of<ConfirmingPhotoLoadingState>(context);
    AddSignatureLoadingState addSignatureLoadingState =
    Provider.of<AddSignatureLoadingState>(context);
    final ReceiptFirestore receiptFirestore =
    Provider.of<ReceiptFirestore>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
        title: const Text(
          'Data Recognized',
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          confirmingPhotoLoadingState.notLoading();
          recognizeText.disposeRec();
          addFee.disposeFee();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    height: 500,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(0, 0, 254, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Data Recognized From Receipt",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins",
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
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
                                  recognizeText.refNo == null ||     recognizeText.refNo == ""
                                      ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (refNo) {
                                            recognizeText.refNo = refNo;
                                            // int.parse(refNo);
                                          },
                                          decoration:
                                          const InputDecoration(
                                            labelText:
                                            "Enter Reference Number Here",
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  7, 38, 85, 1),
                                            ),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10),
                                            hintText:
                                            "Enter Reference Number",
                                            hintStyle: TextStyle(
                                                color: Colors.black12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) //RefNo
                                      : Text(
                                    "Ref NO. : ${recognizeText.refNo}",
                                    style: dataRecognizedStyle,
                                  ),
                                  recognizeText.amount == null
                                      ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (amount) {
                                            recognizeText.amount =
                                                int.parse(amount);
                                          },
                                          decoration:
                                          const InputDecoration(
                                            labelText: "Enter Amount",
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  7, 38, 85, 1),
                                            ),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10),
                                            hintText: "Enter Amount Here",
                                            hintStyle: TextStyle(
                                                color: Colors.black12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) //amount
                                      : Text(
                                    "Amount : P${recognizeText.amount}",
                                    style: dataRecognizedStyle,
                                  ),
                                  recognizeText.dateAndTime == null ||recognizeText.dateAndTime  == ""
                                      ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (dateAndTime) {
                                            recognizeText.dateAndTime =
                                                dateAndTime;
                                          },
                                          decoration:
                                          const InputDecoration(
                                            labelText:
                                            "Enter Date And Time",
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  7, 38, 85, 1),
                                            ),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10),
                                            hintText:
                                            "Enter Date And Time Here",
                                            hintStyle: TextStyle(
                                                color: Colors.black12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) //dateAndTime
                                      : Text(
                                    "Receipt Date : ${recognizeText
                                        .dateAndTime}",
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (name) {
                                            recognizeText.getName(name);
                                          },
                                          decoration: const InputDecoration(
                                            labelText: "Enter Name Here",
                                            labelStyle: TextStyle(
                                              color:
                                              Color.fromRGBO(7, 38, 85, 1),
                                            ),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10),
                                            hintText: "Enter name",
                                            hintStyle: TextStyle(
                                                color: Colors.black12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        isExpanded: true,
                                        hint: Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .arrow_drop_down_circle_outlined,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                addFee.selectedOption,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Poppins",
                                                  color: Color.fromRGBO(
                                                      0, 0, 254, 1),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        items: addFee.items
                                            .map((item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ))
                                            .toList(),
                                        value: addFee.selectedOption,
                                        onChanged: (option) {
                                          addFee.selectOption(option);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: Colors.white,
                                        iconDisabledColor: Colors.grey,
                                        buttonHeight: 50,
                                        buttonWidth: 300,
                                        buttonPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        buttonDecoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: const Color.fromRGBO(
                                              0, 0, 254, 1),
                                        ),
                                        buttonElevation: 2,
                                        itemHeight: 40,
                                        itemPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        dropdownMaxHeight: 200,
                                        dropdownWidth: 250,
                                        dropdownPadding: null,
                                        dropdownDecoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                          color: const Color.fromRGBO(
                                              0, 0, 254, 1),
                                        ),
                                        dropdownElevation: 8,
                                        scrollbarRadius:
                                        const Radius.circular(40),
                                        scrollbarThickness: 6,
                                        scrollbarAlwaysShow: true,
                                        offset: const Offset(-20, 0),
                                      ),
                                    ),
                                  ),
                                  addFee.selectedOption == "Add Fee"
                                      ? TextField(
                                    onChanged: (addedFee) {
                                      int tempAddedFee;
                                      if (addedFee != '') {
                                        tempAddedFee =
                                            int.parse(addedFee);
                                      } else {
                                        tempAddedFee = 0;
                                      }

                                      addFee.setAddedFee(tempAddedFee);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Enter Fee Value",
                                      labelStyle: TextStyle(
                                        color:
                                        Color.fromRGBO(7, 38, 85, 1),
                                      ),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 10),
                                      hintText: "Enter Fee Value Here",
                                      hintStyle: TextStyle(
                                          color: Colors.black12,
                                          fontSize: 13),
                                    ),
                                  )
                                      : addFee.selectedOption ==
                                      "Percentage Fee"
                                      ? TextField(
                                    onChanged: (percentageOfFee) {
                                      var tempPercentageOfFee =
                                      int.parse(percentageOfFee);
                                      addFee.setPercentageOfFee(
                                          tempPercentageOfFee);
                                    },
                                    keyboardType:
                                    TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText:
                                      "Percentage Of Fee %",
                                      labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              7, 38, 85, 1),
                                          fontSize: 13),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 10),
                                      hintText:
                                      "Enter Percentage Of Fee Here",
                                      hintStyle: TextStyle(
                                          color: Colors.black12),
                                    ),
                                  )
                                      : TextField(
                                    onChanged: (deductFee) {
                                      var deductedFee =
                                      int.parse(deductFee);
                                      addFee.setDeductedFee(
                                          deductedFee);
                                    },
                                    keyboardType:
                                    TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Deduct value",
                                      labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              7, 38, 85, 1),
                                          fontSize: 13),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 10),
                                      hintText:
                                      "Enter Deducted value Here",
                                      hintStyle: TextStyle(
                                          color: Colors.black12),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.vibrate();

                                      addFee.setAmount(recognizeText.amount);

                                      if (addFee.selectedOption ==
                                          "Add Fee") {
                                        addFee.manuallyAddFee();
                                      } else if (addFee.selectedOption ==
                                          "Percentage Fee") {
                                        addFee.percentageFee();
                                      } else if (addFee.selectedOption ==
                                          "Deduct Fee") {
                                        addFee.deductingFee();
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 0, 254, 1),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: const Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Calculate",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                addSignatureLoadingState.isLoading
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
                    : GestureDetector(
                  onTap: () async {
                    HapticFeedback.vibrate();

                    addSignatureLoadingState.loading();
                    if (recognizeText.receiptName != null &&
                        addFee.totalAmount != 0.0) {
                      await receiptFirestore.getReceiptDataFromFirestore(
                          recognizeText.refNo);
                      if (receiptFirestore.isExist != true) {
                        if (!context.mounted) return;
                        NavigateToScreen().navToScreen(
                            context, const SignatureScreen());
                      } else {
                        await receiptFirestore.downloadReceiptsPhoto(
                            receiptFirestore
                                .existOriginalReceiptPhotoLink!,
                            true);
                        await receiptFirestore.downloadReceiptsPhoto(
                            receiptFirestore.existReceiptPhotoLink!,
                            false);

                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) {
                            final SwitchReceiptPhoto
                            switchAlertReceiptPhoto =
                            Provider.of<SwitchReceiptPhoto>(context);
                            final ReceiptFirestore receiptAlertFirestore =
                            Provider.of<ReceiptFirestore>(context);
                            return ExistReceiptAlertWidget(
                                switchReceiptPhoto:
                                switchAlertReceiptPhoto,
                                receiptFirestore: receiptAlertFirestore);
                          },
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                "Please add 'Name' & 'Fee' ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              backgroundColor:
                              Color.fromRGBO(0, 0, 254, 1)));
                    }
                    addSignatureLoadingState.notLoading();
                  },
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 254, 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Signature",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// const Color.fromRGBO(
//                                               0, 0, 254, 1),
