// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class InterstitialAdManager {
//   InterstitialAd? _interstitialAd;

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: 'ca-app-pub-4228375379782984/8399226313',
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
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
  
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
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
