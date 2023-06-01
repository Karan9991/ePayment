
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/receipt_firestore.dart';
import 'package:e_payment/src/business_logic/siwtch_original_photo_final_receipt_photo.dart';
import '../../business_logic/date_picker_provider.dart';
import '../../business_logic/download_and_send_email_provider.dart';
import '../../business_logic/history_search_and_filter.dart';
import '../../business_logic/loading_state.dart';
import '../../data/receipt_model.dart';
import '../widget/floating_action_btn.dart';

class ReceiptsHistoryScreen extends StatelessWidget {
  const ReceiptsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReceiptFirestore checkReceiptExistence =
        Provider.of<ReceiptFirestore>(context);


    return StreamProvider<List<Receipt>>(
      create: (BuildContext context) => checkReceiptExistence.getReceiptsList(),
      initialData: const [],
      child: const ReceiptsList(),
    );
  }
}

class ReceiptsList extends StatelessWidget {
  const ReceiptsList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Receipt> receipts = Provider.of<List<Receipt>>(context);
    final SwitchReceiptPhoto switchReceiptPhoto =
        Provider.of<SwitchReceiptPhoto>(context);
    final HistoryPageSearch historyPageSearch =
        Provider.of<HistoryPageSearch>(context);
    final DatePickerProvider datePickerProvider =
        Provider.of<DatePickerProvider>(context);
    final DownloadAndEmail downloadAndEmail =
        Provider.of<DownloadAndEmail>(context);
    final DownloadPdfLoadingState downloadPdfLoadingState =
        Provider.of<DownloadPdfLoadingState>(context);
    final SendEmailLoadingState sendEmailLoadingState =
        Provider.of<SendEmailLoadingState>(context);

    return WillPopScope(
      onWillPop: () async {
        historyPageSearch.returnToStreamList();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Receipts History',
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.access_time),
              )
            ],
          ),
        ),
        body:  Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                onChanged: (kWord) {
                                  historyPageSearch.changed();
                                  historyPageSearch.getReceipts(receipts);
                                  historyPageSearch.searchReceipts(kWord);
                                },
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Poppins",
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "Search by reference number",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.black26,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                HapticFeedback.vibrate();

                                historyPageSearch.clearResult();
                                historyPageSearch.changed();
                                historyPageSearch.getReceipts(receipts);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Choose date range ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(7, 38, 85, 1),
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      content: SizedBox(
                                          height: 320,
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Center(
                                                      child: TextField(
                                                    controller:
                                                        datePickerProvider
                                                            .dateInputStart,
                                                    //editing controller of this TextField
                                                    decoration:
                                                        const InputDecoration(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            //icon of text field
                                                            labelText:
                                                                "Start Date" //label text of field
                                                            ),
                                                    readOnly: true,
                                                    //set it true, so that user will not able to edit text
                                                    onTap: () async {
                                                      datePickerProvider
                                                          .pickStartDate(
                                                              context);
                                                    },
                                                  ))),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Center(
                                                      child: TextField(
                                                    controller:
                                                        datePickerProvider
                                                            .dateInputEnd,
                                                    //editing controller of this TextField
                                                    decoration:
                                                        const InputDecoration(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            labelText:
                                                                "End Date"),
                                                    readOnly: true,
                                                    onTap: () async {
                                                      datePickerProvider
                                                          .pickEndDate(context);
                                                    },
                                                  ))),
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.vibrate();

                                                  historyPageSearch
                                                      .filterReceipts(
                                                          datePickerProvider
                                                              .startDate!,
                                                          datePickerProvider
                                                              .endDate!,
                                                          context);
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Container(
                                                      height: 50,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              0, 0, 254, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: const Center(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Confirm range",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      ))),
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.calendar_month,
                                color: Color.fromRGBO(0, 0, 254, 1),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: historyPageSearch.isStreamList
                          ? receipts.length
                          : historyPageSearch.searchedReceiptsList.length,
                      itemBuilder: (_, int index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                switchReceiptPhoto.isOriginal
                                    ? historyPageSearch.isStreamList
                                        ? receipts[index].originalReceiptPhoto!
                                        : historyPageSearch
                                            .searchedReceiptsList[index]
                                            .originalReceiptPhoto!
                                    : historyPageSearch.isStreamList
                                        ? receipts[index].finalReceiptPhoto!
                                        : historyPageSearch
                                            .searchedReceiptsList[index]
                                            .finalReceiptPhoto!,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          const Color.fromRGBO(0, 0, 254, 1),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.vibrate();

                                    switchReceiptPhoto.switchPhoto();
                                  },
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0, 0, 254, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                              ),
                            ],
                          ),
                          // Image.network(receipts[index].photo!),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    downloadPdfLoadingState.isLoading
                        ? Container()
                        : FloatingBtn(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              downloadPdfLoadingState.loading();
                              await downloadAndEmail.makeReceiptsPdf(
                                  historyPageSearch.isStreamList
                                      ? receipts
                                      : historyPageSearch.searchedReceiptsList,
                                  context);
                              downloadPdfLoadingState.notLoading();
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Color.fromRGBO(0, 0, 254, 1),
                            ),
                          ),
                    sendEmailLoadingState.isLoading
                        ? Container()
                        : FloatingBtn(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              sendEmailLoadingState.loading();
                              await downloadAndEmail.sendPdfToEmail(
                                  context,
                                  historyPageSearch.isStreamList
                                      ? receipts
                                      : historyPageSearch.searchedReceiptsList);
                              sendEmailLoadingState.notLoading();
                            },
                            icon: const Icon(
                              Icons.email,
                              color: Color.fromRGBO(0, 0, 254, 1),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
