
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthDataApiI {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> registerWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<void> addUserData(User user, Map<String, dynamic> data);
}

@LazySingleton(as: AuthDataApiI)
class AuthDataApi implements AuthDataApiI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred.user;
  }

  @override
  Future<User?> registerWithEmail(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final snapshot = await userDoc.get();
      if (!snapshot.exists) {
        await userDoc.set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'avatarUrl': googleUser.photoUrl,
        });
      }
    }

    return user;
  }


  @override
  Future<User?> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final userCred = await _auth.signInWithCredential(oauthCredential);
    return userCred.user;
  }

  @override
  Future<void> addUserData(User user, Map<String, dynamic> data) async {
    await _firestore.collection('user').doc(user.uid).set(data);
  }
}
