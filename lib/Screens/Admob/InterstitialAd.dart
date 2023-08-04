import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/AdManger.dart';

InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;
 int maxFailedLoadAttempts = 3;

void createInterstitialAd()async {

  var shw = await getSharedPrefrence(SHOWAD);

  if(shw=="false"){

    return;
  }


  InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? INRERSTITALADADANDROID
          : INRERSTITALADADIOS,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
          // showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ));
}

void showInterstitialAd() async{

  var shw = await getSharedPrefrence(SHOWAD);

  if(shw=="false"){

    return;
  }

  if (_interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
     createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
     createInterstitialAd();
    },
  );
  _interstitialAd!.show();
  _interstitialAd = null;
  maxFailedLoadAttempts=0;
  _numInterstitialLoadAttempts =0;
}