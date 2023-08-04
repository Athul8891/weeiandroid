import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:weei/Helper/sharedPref.dart';

import 'dart:io' show Platform;

import 'package:weei/Screens/Admob/AdManger.dart';
class BannerAdsMusStr extends StatefulWidget {

  final androidID;
  final iosId;



  BannerAdsMusStr({this.androidID,this.iosId});
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<BannerAdsMusStr> {
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

  void showAds() async{
 var shw = await getSharedPrefrence(SHOWAD);

    if(shw=="false"){

      return;
    }
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
        // ? (widget.androidID==null?LYBRARYADANDROID:widget.androidID)
            ? ANDROIDAUDSTR
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


    return _bannerAdIsLoaded==true?Container(

      height: bannerAd?.size.height.toDouble(),
      width: bannerAd?.size.width.toDouble(),
      child: AdWidget(ad: bannerAd!)
      ,
    ):SizedBox(height: 0.1,


    );
  }


}
