import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../business_logic/signature_provider.dart';

class SignatureScreen extends StatelessWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignatureProvider signatureProvider =
        Provider.of<SignatureProvider>(context);
    // final isPortrait =
    //     MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
        title: const Text('Add Signature',style: TextStyle(fontFamily: "Poppins",),),
      ),
      body:Column(
        children: [
          Expanded(
            child: Signature(
              controller: signatureProvider.controller!,
              backgroundColor: Colors.white60,
            ),
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 254, 1),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        await signatureProvider.onConfirmPressed(context);
                      },
                      iconSize: 40,
                      color: Colors.green,
                      icon: const Icon(Icons.check)),
                  IconButton(
                      onPressed: () {
                        signatureProvider.controller!.clear();
                        Navigator.pop(context);
                      },
                      iconSize: 40,
                      color: Colors.red,
                      icon: const Icon(Icons.close)),
                ]),
          ),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onTap: () {
          //     final newOrientation =
          //         isPortrait ? Orientation.landscape : Orientation.portrait;
          //
          //     signatureProvider.controller!.clear();
          //
          //     signatureProvider.setOrientation(newOrientation);
          //   },
          //   child: Container(
          //     color: Colors.white,
          //     padding: const EdgeInsets.symmetric(vertical: 8),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           isPortrait
          //               ? Icons.screen_lock_portrait
          //               : Icons.screen_lock_landscape,
          //           size: 40,
          //         ),
          //         const SizedBox(
          //           width: 12,
          //         ),
          //         const Text(
          //           'Tap to change signature orientation',
          //           style: TextStyle(fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
