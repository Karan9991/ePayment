import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// class InterstitialAdManager {
//   InterstitialAd? _interstitialAd;

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/1033173712',
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//           print('Interstitial ad failed to load: $error');
//         },
//       ),
//     );
//   }

//   void showInterstitialAd() {

//     if (_interstitialAd != null) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           _interstitialAd = null;
//           loadInterstitialAd(); // Load the next ad
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('Failed to show interstitial ad: $error');
//         },
//       );

//       _interstitialAd!.show();
//     } else {
//       print('Interstitial ad not ready');
//     }
//   }
// }

// class MyAd extends StatelessWidget {
//   final InterstitialAdManager _adManager = InterstitialAdManager();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Interstitial Ad Example'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             child: Text('Show Interstitial Ad'),
//             onPressed: () {
//               _adManager.showInterstitialAd();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9052462815392719/3848272055',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    try {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            _interstitialAd = null;
            loadInterstitialAd(); // Load the next ad
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            print('Failed to show interstitial ad: $error');
          },
        );

        _interstitialAd!.show();
      } else {
        print('Interstitial ad not ready');
        loadInterstitialAd(); // Load a new ad
      }
    } catch (e) {
      print("catch error $e");
    }
  }
}

class MyAd extends StatefulWidget {
  @override
  _MyAdState createState() => _MyAdState();
}

class _MyAdState extends State<MyAd> {
  InterstitialAdManager _adManager = InterstitialAdManager();

  @override
  void initState() {
    super.initState();
    _adManager.loadInterstitialAd(); // Load the initial ad
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Interstitial Ad Example'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Show Interstitial Ad'),
            onPressed: () {
              _adManager.showInterstitialAd();
            },
          ),
        ),
      ),
    );
  }
}
// class AdManager {
//   InterstitialAd? _interstitialAd;
//   bool _isInterstitialAdReady = false;

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/1033173712',
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//           _isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (error) {
//           print('InterstitialAd failed to load: $error');
//           _isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }

//   void showInterstitialAd({VoidCallback? onAdClosed}) {
//     // Show the interstitial ad
//     if (_isInterstitialAdReady) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           _isInterstitialAdReady = false;
//           loadInterstitialAd();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('InterstitialAd failed to show: $error');
//           _isInterstitialAdReady = false;
//           loadInterstitialAd();
//         },
//       );
//       _interstitialAd!.show();
//     } else {
//       print('InterstitialAd not ready.');
//     }
//     // Call the onAdClosed callback when the ad is closed
//     if (onAdClosed != null) {
//       onAdClosed();
//     }
//   }
  //   Future<void> showInterstitialAd() async {
  //   // Show the interstitial ad and wait for it to complete
  //   // You can use the ad plugin or package specific to your ad provider
  //   // and implement the logic to show the interstitial ad here.
  //   // Once the ad is complete, resolve the Future.
  //      if (_isInterstitialAdReady) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         _isInterstitialAdReady = false;
  //         loadInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         print('InterstitialAd failed to show: $error');
  //         _isInterstitialAdReady = false;
  //         loadInterstitialAd();
  //       },
  //     );
  //     _interstitialAd!.show();
  //   } else {
  //     print('InterstitialAd not ready.');
  //   }
  //   await Future.delayed(Duration(seconds: 3)); // Simulating ad completion delay
  //   // Complete the Future when the ad is finished
  //   return;
  // }

  // void showInterstitialAd() {
  //   if (_isInterstitialAdReady) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         _isInterstitialAdReady = false;
  //         loadInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         print('InterstitialAd failed to show: $error');
  //         _isInterstitialAdReady = false;
  //         loadInterstitialAd();
  //       },
  //     );
  //     _interstitialAd!.show();
  //   } else {
  //     print('InterstitialAd not ready.');
  //   }
  // }
//}


//working
