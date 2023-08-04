import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io' show Platform;

import 'package:weei/Screens/Admob/AdManger.dart';
class SqureBannerAds extends StatefulWidget {

  final androidID;
  final iosId;



  SqureBannerAds({this.androidID,this.iosId});
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SqureBannerAds> {
  BannerAd? bannerAd;
  bool _bannerAdIsLoaded = false;




  @override
  void initState() {
      super.initState();
       this.showAds();

  }



  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();

  }

  void showAds(){

    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? LYBRARYADANDROID
            : LYBRARYIOSID,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        ),
        request: AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {


    return _bannerAdIsLoaded==true?AspectRatio(

      aspectRatio: 16/9,
      //child: AdWidget(ad: bannerAd!)
      child: AdWidget(ad: bannerAd!)
      ,
    ):AspectRatio(

      aspectRatio: 16/9,
      //child: AdWidget(ad: bannerAd!)
      child: Container()
      ,
    );
  }


}
