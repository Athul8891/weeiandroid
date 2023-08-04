
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/sharedPref.dart';

Future<void> signOut()async  {
  await FirebaseAuth.instance.signOut();

 // clearSharedPrefrence();
}