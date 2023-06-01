import 'package:firebase_auth/firebase_auth.dart';

class SignOut{
  final _auth = FirebaseAuth.instance;
signOut(){
   _auth.signOut();
}
}