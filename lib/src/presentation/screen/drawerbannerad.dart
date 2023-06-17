import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdDWidget extends StatefulWidget {
  @override
  _BannerAdDWidgetState createState() => _BannerAdDWidgetState();
}

class _BannerAdDWidgetState extends State<BannerAdDWidget> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    final adSize = AdSize.mediumRectangle;
    final adUnitId =
        'ca-app-pub-9052462815392719/5572417269'; // Replace with your Ad Unit ID

    final adRequest = AdRequest();
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: adSize,
      request: adRequest,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Failed to load banner ad: $error');
        },
      ),
    );

    await _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isAdLoaded ? _bannerAd.size.height.toDouble() : 0,
      width: _isAdLoaded ? _bannerAd.size.width.toDouble() : 0,
      child: _isAdLoaded ? AdWidget(ad: _bannerAd) : SizedBox.shrink(),
    );
  }
}
