import 'package:shared_preferences/shared_preferences.dart';
import 'package:weei/Helper/Texts.dart';

///sahrepref const
final VDO = "userCountry";

final NAME = "weeiUser";
final NUMBER = "weeiNumber";
final UNAME = "weeiUsername";
final BIO = "weeiBio";
final IMG = "weeiImg";
final EMAIL = "weeiEmail";
final UID = "weeiUid";
final FCM = "weeiFcmToken";
final SHOWBADGE = "weeiShowBadge";
final SHOWUPDATE = "weeiShowUpdate";
final NOTI = "weeiShowNotifications";
final LASTROOM = "weeiLastRoom";

final CURRENTCHATNME = "weeiCurrentChatPerson";
final CURRENTLYINCHAT = "weeiCurrentlyInChat";

final STORAGE = "weeiStorage";
final SHOWAD = "weeiShowAd";
final CURRENTVERSION = "weeiCurrentVersion";
final APLOGY = "apologyShown";

final STARTALERTSHOW = "startAlert";
final STARTALERTDISSMISS = "startAlertDissmiss";
final STARTALERT_TXT = "startAlertText";
final STARTALERT_TITLE = "startAlertTile";

final MANDATORY = "weeiMANDI";
final BUILDVERSION = "weeiBUILId";
final UPDATETEXT = "weeiUpadteText";
final COUNTER = "weeiCOUNTER";
final URLSTORAGE = "weeiOpnUrlHistory";

var ABOUT= "about";
var PRIVACYPOLICY= "privacy";
var TERMSAND= "trems";
var loginBtTp= "loginTaap";

Future setSharedPrefrence(key, data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}

Future getSharedPrefrence(key) async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getString(key);

  return value;
}
Future clearSharedPrefrence() async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.clear();

  return value;
}
Future rmvSharedPrefrence(key) async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.remove(key);


}


Future saveAll(name,number,email,profile,uid,username,bio) async {


  var nm = await setSharedPrefrence(NAME, name);
  var num = await setSharedPrefrence(NUMBER, number);
  var em = await setSharedPrefrence(EMAIL, email);
  var img = await setSharedPrefrence(IMG, profile==null?PROFILEB64:profile);
  var uId = await setSharedPrefrence(UID, uid);
  var uname = await setSharedPrefrence(UNAME, username);
  var bi = await setSharedPrefrence(BIO, bio);

}



