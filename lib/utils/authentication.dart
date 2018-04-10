library authentication;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final Authentication authentication = new Authentication._private();

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
String userID;


class Authentication{
  Authentication._private();

  Future<FirebaseUser> signInWithGoogle() async {
    // Attempt to get the currently authenticated user
    GoogleSignInAccount currentUser = googleSignIn.currentUser;
    if (currentUser == null) {
      // Attempt to sign in without user interaction
      currentUser = await googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      // Force the user to interactively sign in
      currentUser = await googleSignIn.signIn();
    }

    final GoogleSignInAuthentication gAuth = await currentUser.authentication;

    // Authenticate with firebase
    final FirebaseUser user = await auth.signInWithGoogle(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    assert(user != null);
    assert(!user.isAnonymous);

    userID = user.uid;

    return user;
  }
}
