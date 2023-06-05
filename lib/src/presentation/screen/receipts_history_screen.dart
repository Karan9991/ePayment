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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ReceiptsHistoryScreen extends StatelessWidget {
//   const ReceiptsHistoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ReceiptFirestore checkReceiptExistence =
//         Provider.of<ReceiptFirestore>(context);

//     return StreamProvider<List<Receipt>>(
//       create: (BuildContext context) => checkReceiptExistence.getReceiptsList(),
//       initialData: const [],
//       child: const ReceiptsList(),
//     );
//   }
// }
// class ReceiptsHistoryScreen extends StatelessWidget {
//   const ReceiptsHistoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ReceiptFirestore checkReceiptExistence =
//         Provider.of<ReceiptFirestore>(context);

//     return StreamProvider<List<Receipt>>(
//       create: (BuildContext context) => checkReceiptExistence.getReceiptsList(),
//       initialData: const [],
//       child: Consumer<Map<String, dynamic>>(
//         builder: (context, userData, _) {
//           String userSubscriptionStatus = userData['userSubscriptionStatus'] ??
//               ''; // Retrieve userSubscriptionStatus from userData

//           return ReceiptsList(
//             userSubscriptionStatus: userSubscriptionStatus,
//           );
//         },
//       ),
//     );
//   }
// }
class ReceiptsHistoryScreen extends StatelessWidget {
  const ReceiptsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> storeUserSubscriptionStatus(
        String userSubscriptionStatus) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userSubscriptionStatus', userSubscriptionStatus);
    }

    ReceiptFirestore checkReceiptExistence =
        Provider.of<ReceiptFirestore>(context);
    // Get the current user ID using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? ''; // User ID or an empty string if user is null
    print("user id $uid");
    return FutureBuilder<Map<String, dynamic>>(
      future:
          getUserDataFromFirestore(uid), // Pass the user's UID to the function

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the data, you can show a loading indicator or placeholder
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any potential error while retrieving user data
          return Text('Error: ${snapshot.error}');
        } else {
          // User data has been successfully retrieved
          Map<String, dynamic> userData = snapshot.data ?? {};

          // Extract the user subscription status from the retrieved data
          String userSubscriptionStatus =
              userData['userSubscriptionStatus'] ?? '';
          storeUserSubscriptionStatus(userSubscriptionStatus);

          print("subscription status $userSubscriptionStatus");
          print("uuuuuuuuuser data  $userData");

          // Check the user subscription status and disable search bar and download button if necessary
          //   bool userSubscriptionStatuss = userSubscriptionStatus != 'free license code';

          return StreamProvider<List<Receipt>>(
            create: (BuildContext context) =>
                checkReceiptExistence.getReceiptsList(),
            initialData: const [],
            child: ReceiptsList(
              userSubscriptionStatus: userSubscriptionStatus,
            ),
          );
        }
      },
    );
  }
}

Future<Map<String, dynamic>> getUserDataFromFirestore(String uid) async {
  final _db = FirebaseFirestore.instance;

  final users = _db.collection("users");
  final userDoc = await users.doc(uid).get();

  if (userDoc.exists) {
    final userData = userDoc.data();
    return userData as Map<String, dynamic>;
  } else {
    return {}; // Return an empty map if the document doesn't exist
  }
}

class ReceiptsList extends StatelessWidget {
  //const ReceiptsList({super.key});
  final String userSubscriptionStatus;

  const ReceiptsList({Key? key, required this.userSubscriptionStatus})
      : super(key: key);

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

    bool isSubscriptionFree = userSubscriptionStatus == '' ||
        userSubscriptionStatus == 'free code access';

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
        body: Stack(
          children: [
            Column(
              children: [
                if (!isSubscriptionFree)
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
                                                        const EdgeInsets.all(
                                                            15),
                                                    height:
                                                        MediaQuery.of(context)
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
                                                        const EdgeInsets.all(
                                                            15),
                                                    height:
                                                        MediaQuery.of(context)
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
                                                            .pickEndDate(
                                                                context);
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
            if (!isSubscriptionFree)
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
                                        : historyPageSearch
                                            .searchedReceiptsList,
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
                                        : historyPageSearch
                                            .searchedReceiptsList);
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

// class ReceiptsHistoryScreen extends StatelessWidget {
//   const ReceiptsHistoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ReceiptFirestore checkReceiptExistence =
//         Provider.of<ReceiptFirestore>(context);


//     return StreamProvider<List<Receipt>>(
//       create: (BuildContext context) => checkReceiptExistence.getReceiptsList(),
//       initialData: const [],
//       child: const ReceiptsList(),
//     );
//   }
// }

// Future<Map<String, dynamic>> getUserDataFromFirestore(String uid) async {
//     final _db = FirebaseFirestore.instance;

//   final users = _db.collection("users");
//   final userDoc = await users.doc(uid).get();

//   if (userDoc.exists) {
//     final userData = userDoc.data();
//     return userData as Map<String, dynamic>;
//   } else {
//     return {}; // Return an empty map if the document doesn't exist
//   }
// }


// class ReceiptsList extends StatelessWidget {
//   const ReceiptsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<Receipt> receipts = Provider.of<List<Receipt>>(context);
//     final SwitchReceiptPhoto switchReceiptPhoto =
//         Provider.of<SwitchReceiptPhoto>(context);
//     final HistoryPageSearch historyPageSearch =
//         Provider.of<HistoryPageSearch>(context);
//     final DatePickerProvider datePickerProvider =
//         Provider.of<DatePickerProvider>(context);
//     final DownloadAndEmail downloadAndEmail =
//         Provider.of<DownloadAndEmail>(context);
//     final DownloadPdfLoadingState downloadPdfLoadingState =
//         Provider.of<DownloadPdfLoadingState>(context);
//     final SendEmailLoadingState sendEmailLoadingState =
//         Provider.of<SendEmailLoadingState>(context);

//     return WillPopScope(
//       onWillPop: () async {
//         historyPageSearch.returnToStreamList();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white70,
//         appBar: AppBar(
//           backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
//           title: const Row(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Receipts History',
//                   style: TextStyle(
//                     fontFamily: "Poppins",
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Icon(Icons.access_time),
//               )
//             ],
//           ),
//         ),
//         body:  Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(10),
//                           bottomLeft: Radius.circular(10))),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: SizedBox(
//                             height: 50,
//                             width: MediaQuery.of(context).size.width,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextField(
//                                 keyboardType: TextInputType.text,
//                                 obscureText: false,
//                                 onChanged: (kWord) {
//                                   historyPageSearch.changed();
//                                   historyPageSearch.getReceipts(receipts);
//                                   historyPageSearch.searchReceipts(kWord);
//                                 },
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   fontFamily: "Poppins",
//                                 ),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 15),
//                                   hintText: "Search by reference number",
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.search,
//                             color: Colors.black26,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                               onTap: () {
//                                 HapticFeedback.vibrate();

//                                 historyPageSearch.clearResult();
//                                 historyPageSearch.changed();
//                                 historyPageSearch.getReceipts(receipts);
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: const Text(
//                                         "Choose date range ",
//                                         style: TextStyle(
//                                           color: Color.fromRGBO(7, 38, 85, 1),
//                                           fontFamily: "Poppins",
//                                         ),
//                                       ),
//                                       content: SizedBox(
//                                           height: 320,
//                                           child: Column(
//                                             children: [
//                                               Container(
//                                                   padding:
//                                                       const EdgeInsets.all(15),
//                                                   height: MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       3,
//                                                   child: Center(
//                                                       child: TextField(
//                                                     controller:
//                                                         datePickerProvider
//                                                             .dateInputStart,
//                                                     //editing controller of this TextField
//                                                     decoration:
//                                                         const InputDecoration(
//                                                             icon: Icon(Icons
//                                                                 .calendar_today),
//                                                             //icon of text field
//                                                             labelText:
//                                                                 "Start Date" //label text of field
//                                                             ),
//                                                     readOnly: true,
//                                                     //set it true, so that user will not able to edit text
//                                                     onTap: () async {
//                                                       datePickerProvider
//                                                           .pickStartDate(
//                                                               context);
//                                                     },
//                                                   ))),
//                                               Container(
//                                                   padding:
//                                                       const EdgeInsets.all(15),
//                                                   height: MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       3,
//                                                   child: Center(
//                                                       child: TextField(
//                                                     controller:
//                                                         datePickerProvider
//                                                             .dateInputEnd,
//                                                     //editing controller of this TextField
//                                                     decoration:
//                                                         const InputDecoration(
//                                                             icon: Icon(Icons
//                                                                 .calendar_today),
//                                                             labelText:
//                                                                 "End Date"),
//                                                     readOnly: true,
//                                                     onTap: () async {
//                                                       datePickerProvider
//                                                           .pickEndDate(context);
//                                                     },
//                                                   ))),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   HapticFeedback.vibrate();

//                                                   historyPageSearch
//                                                       .filterReceipts(
//                                                           datePickerProvider
//                                                               .startDate!,
//                                                           datePickerProvider
//                                                               .endDate!,
//                                                           context);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: Center(
//                                                   child: Container(
//                                                       height: 50,
//                                                       width: 150,
//                                                       decoration: BoxDecoration(
//                                                           color: const Color
//                                                                   .fromRGBO(
//                                                               0, 0, 254, 1),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10)),
//                                                       child: const Center(
//                                                           child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Text(
//                                                             "Confirm range",
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 fontSize: 15),
//                                                           ),
//                                                         ],
//                                                       ))),
//                                                 ),
//                                               )
//                                             ],
//                                           )),
//                                     );
//                                   },
//                                 );
//                               },
//                               child: const Icon(
//                                 Icons.calendar_month,
//                                 color: Color.fromRGBO(0, 0, 254, 1),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     child: ListView.builder(
//                       itemCount: historyPageSearch.isStreamList
//                           ? receipts.length
//                           : historyPageSearch.searchedReceiptsList.length,
//                       itemBuilder: (_, int index) => Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: ListTile(
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.network(
//                                 switchReceiptPhoto.isOriginal
//                                     ? historyPageSearch.isStreamList
//                                         ? receipts[index].originalReceiptPhoto!
//                                         : historyPageSearch
//                                             .searchedReceiptsList[index]
//                                             .originalReceiptPhoto!
//                                     : historyPageSearch.isStreamList
//                                         ? receipts[index].finalReceiptPhoto!
//                                         : historyPageSearch
//                                             .searchedReceiptsList[index]
//                                             .finalReceiptPhoto!,
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (BuildContext context,
//                                     Widget child,
//                                     ImageChunkEvent? loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       backgroundColor:
//                                           const Color.fromRGBO(0, 0, 254, 1),
//                                       value:
//                                           loadingProgress.expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes!
//                                               : null,
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8.0),
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     HapticFeedback.vibrate();

//                                     switchReceiptPhoto.switchPhoto();
//                                   },
//                                   child: Center(
//                                     child: Container(
//                                       height: 50,
//                                       width: 200,
//                                       decoration: BoxDecoration(
//                                           color: const Color.fromRGBO(
//                                               0, 0, 254, 1),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Center(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               switchReceiptPhoto.isOriginal
//                                                   ? "Switch to final receipt"
//                                                   : "Switch to original receipt",
//                                               style: const TextStyle(
//                                                   fontFamily: "Poppins",
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 13),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Image.network(receipts[index].photo!),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 10.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     downloadPdfLoadingState.isLoading
//                         ? Container()
//                         : FloatingBtn(
//                             onTap: () async {
//                               HapticFeedback.vibrate();
//                               downloadPdfLoadingState.loading();
//                               await downloadAndEmail.makeReceiptsPdf(
//                                   historyPageSearch.isStreamList
//                                       ? receipts
//                                       : historyPageSearch.searchedReceiptsList,
//                                   context);
//                               downloadPdfLoadingState.notLoading();
//                             },
//                             icon: const Icon(
//                               Icons.download,
//                               color: Color.fromRGBO(0, 0, 254, 1),
//                             ),
//                           ),
//                     sendEmailLoadingState.isLoading
//                         ? Container()
//                         : FloatingBtn(
//                             onTap: () async {
//                               HapticFeedback.vibrate();
//                               sendEmailLoadingState.loading();
//                               await downloadAndEmail.sendPdfToEmail(
//                                   context,
//                                   historyPageSearch.isStreamList
//                                       ? receipts
//                                       : historyPageSearch.searchedReceiptsList);
//                               sendEmailLoadingState.notLoading();
//                             },
//                             icon: const Icon(
//                               Icons.email,
//                               color: Color.fromRGBO(0, 0, 254, 1),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
