
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Auth/CreateAccount.dart';
import 'package:weei/Screens/Auth/Data/checkUser.dart';
import 'package:weei/Screens/Auth/Data/getUserData.dart';
import 'package:weei/Screens/Auth/EnterNumberScreen.dart';
import 'package:weei/Screens/Auth/EnterOTP.dart';
import 'package:weei/Screens/Main_Widgets/BottomNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController phoneNumber = TextEditingController();
TextEditingController otpCode = TextEditingController();


final GoogleSignIn _googleSignIn = GoogleSignIn();


bool isLoading = false;

String? verificationId;
var ctx;
var number;
var code;
var rplc;
var otpSentListener;


Future phoneSignIn({  phoneNumber,contxt,cod,replace,listener}) async {
  // otpSentListener.addListener((){listener.text= otpSentListener.text;});

  ctx =contxt;
  number =phoneNumber;
  code =cod;
  rplc =replace;
  otpSentListener =listener;
  await _auth.verifyPhoneNumber(
      phoneNumber:"+"+ code+phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout


  );

  return verificationId;
}

_onVerificationCompleted(PhoneAuthCredential authCredential) async {
  otpSentListener.setLang("false");

  print("verification completed ${authCredential.smsCode}");
  User? user = FirebaseAuth.instance.currentUser;

  otpCode.text = authCredential.smsCode!;

  if (authCredential.smsCode != null) {
    try{
      UserCredential credential =
      await user!.linkWithCredential(authCredential);
    }on FirebaseAuthException catch(e){
      if(e.code == 'provider-already-linked'){
        await _auth.signInWithCredential(authCredential);
      }
    }

    isLoading = false;

    // Navigator.pushNamedAndRemoveUntil(
    //     context, Constants.homeNavigate, (route) => false);
  }
}

_onVerificationFailed(FirebaseAuthException exception) {
  // otpSentListener.text=="FAILED";
  otpSentListener.setLang("false");

  showToastSuccess(exception.message.toString());
  if (exception.code == 'invalid-phone-number') {

  }
}

_onCodeSent(String verificationId, int? forceResendingToken) {
  otpSentListener.setLang("false");
  verificationId = verificationId;
  print(forceResendingToken);
  print(verificationId);
  print("code sent");


  if(rplc==true){

    Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(builder: (context) => EnterOTP(verificationId:verificationId  ,number: number,code: code,)),
    );
  }else{
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (context) => EnterOTP(verificationId:verificationId  ,number: number,code: code,)),
    );
  }


}

_onCodeTimeout(String timeout) {
  otpSentListener.setLang("false");

  // showToastSuccess(timeout.toString());

  // otpSentListener.text=="TIMEOUT";
  return null;
}

void showMessage(String errorMessage ,context) {
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(builderContext).pop();
              },
            )
          ],
        );
      }).then((value) {

    isLoading = false;

  });
}

Future verfyOtp(verification_Id,code,context,number)async {
  var rslt =false;
  try {


    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verification_Id.toString(), smsCode: code))
        .then((value) async {
      if (value.user != null) {


        rslt = true;
        var rsp = await checkIfUserExists( value.user?.uid);

        if(rsp==true){

          var rsp =await getFromUsers();
          if(rsp!=0){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          }else{
            rslt = false;
            showToastSuccess("Unable to fetch details! , Close the app and reopen");
          }

        }else{
          rslt = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateAccount(number:number ,)),
          );
        }

      }else{
        showToastSuccess("Verification failed");
        rslt = false;
      }
    }).catchError((error) {
      //  dismissProgress();
      rslt=false;
      showToastSuccess("Verification failed");
    });
  } catch (e) {
    rslt = false;
    showToastSuccess("Verification failed");
  }

}

Future getFirebaseUser(context) async {
  var _firebaseUser = await FirebaseAuth.instance.currentUser;



  if (_firebaseUser != null) {
    final User user = _firebaseUser;
    final uid = user.uid;


    var rsp =await getFromUsers();

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => EnterNumber()),
    // );
    if(rsp!=0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }else{

    }


  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EnterNumber()),
    );
  }

  print(_firebaseUser);

}


getInitainlData(path) async {
  await _firestore
      .collection('Updater').doc(path.toString()).get().then((DocumentSnapshot documentSnapshot) async{
    // var doc =await _firestore.collection('Updater').doc(path).get().then((snapshot) async{
    // var rsp = await databaseReference.child('Updater').child(path).once().then(( snapshot) async {





    var   currentVersion=  documentSnapshot.get('currentVersion').toString();
    var   mandatory=documentSnapshot.get('mandatory').toString();
    var storage=documentSnapshot.get('storage').toString();
    var txt=documentSnapshot.get('text').toString();
    var build=documentSnapshot.get('buildVersion').toString();
    var trems=documentSnapshot.get('terms').toString();
    var privacy=documentSnapshot.get('privacy').toString();
    var about=documentSnapshot.get('about').toString();
    var adShow=documentSnapshot.get('Ad').toString();

    var startAlert=documentSnapshot.get('startAlert').toString();
    var startAlertDissmiss=documentSnapshot.get('startAlertDissmiss').toString();
    var startAlertText=documentSnapshot.get('startAlertText').toString();
    var startAlertTile=documentSnapshot.get('startAlertTile').toString();

    print("storageee");
    print(build);

    // _firestore.collection('Updater').doc('ios').set(
    //     {
    //
    //       "currentVersion":currentVersion,
    //       "mandatory":mandatory,
    //       "storage":storage,
    //       "text":txt,
    //       "buildVersion":build,
    //       "terms":trems,
    //       "privacy":privacy,
    //       "about":about,
    //       "adShow":adShow,
    //
    //     }
    //
    // );


    var setCurrentVersion =await setSharedPrefrence(CURRENTVERSION, currentVersion);
    var setMandatory =await setSharedPrefrence(MANDATORY, mandatory);
    var setStorage =await setSharedPrefrence(STORAGE, storage);
    var setText =await setSharedPrefrence(UPDATETEXT, txt);
    var setbuild =await setSharedPrefrence(BUILDVERSION, build);

    var trem =await setSharedPrefrence(TERMSAND, trems);
    var privac =await setSharedPrefrence(PRIVACYPOLICY, privacy);
    var abou =await setSharedPrefrence(ABOUT, about);
    var showAd =await setSharedPrefrence(SHOWAD, adShow);


    await setSharedPrefrence(STARTALERTSHOW, startAlert);
    await setSharedPrefrence(STARTALERTDISSMISS, startAlertDissmiss);
    await setSharedPrefrence(STARTALERT_TXT, startAlertText);
    await setSharedPrefrence(STARTALERT_TITLE, startAlertTile);


    // ignore: void_checks
  });



}



///google signin
Future signInWithGoogle(context) async {

  GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount!.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  var authResult = await _auth.signInWithCredential(credential);
  var _user = authResult.user;
  // assert(_user!.isAnonymous);


  assert(await _user?.getIdToken() != null);
  var currentUser = await _auth.currentUser;
  assert(_user!.uid == currentUser?.uid);

  print("User Name: ${_user!.displayName}");
  print("User Email ${_user!.email}");
  showToastSuccess("Signing-in please wait");
  var rsp = await checkIfUserExists( currentUser?.uid);

  if(rsp==true){

    var rsp =await getFromUsers();
    if(rsp!=0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }else{
      showToastSuccess("Unable to fetch details! , Close the app and reopen");
    }

  }else{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount(number:null ,email: _user!.email,)),
    );
  }
}

