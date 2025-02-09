import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<User?> get onAuthStatusChanged;
  Future<void> sendCodeAndWaitResponse(BuildContext context, String phoneNumber, Country? country, void Function(String) isCodeSentUserFromFireBase);
  Future<void> loginWithPhoneAndCode(BuildContext context, String verificationId, String userCode);
  Future<void> signInWithGoogle(BuildContext context);
  Future<void> attemptLoginAndSendBackErrorMessage(BuildContext context, dynamic credential);
  Future<User?> currentUser();
  Future<void> signOut();
  bool get isNewUser;
  UserAuthentificate get userAuthentificate;
  set userAuthentificate(UserAuthentificate auth);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserAuthentificate _userAuthentificate = UserAuthentificate( coins:3500, typeUser: SettingsClass().typeUser[2], name: "Damien", email: "damienzipadonou@gmail.com", phoneNumber: "+40736141740", imgPath: "images/damien.jpeg");

  @override
  bool get isNewUser {
    return true; //ici a retourner avec l'api
  }

  @override
  UserAuthentificate get userAuthentificate {
    return _userAuthentificate; //ici a retourner avec l'api
  }

  set userAuthentificate(UserAuthentificate user) {
    _userAuthentificate = user;
  }

  @override
  Stream<User?> get onAuthStatusChanged {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<void> sendCodeAndWaitResponse(BuildContext context, String phoneNumber, Country? country, void Function(String) isCodeSentUserFromFireBase) async {
    String fullPhoneNumber = '${country?.dialcode ?? ''}$phoneNumber';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber:  fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        attemptLoginAndSendBackErrorMessage(context, credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Le numero de telephone est incorrect $fullPhoneNumber')),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        isCodeSentUserFromFireBase(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<void> loginWithPhoneAndCode(BuildContext context, String verificationId, String userCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userCode);
    attemptLoginAndSendBackErrorMessage(context, credential);
  }

  @override
  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
    Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  attemptLoginAndSendBackErrorMessage(context, credential);
}

  Future<void> attemptLoginAndSendBackErrorMessage(BuildContext context, dynamic credential) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user!=null){
        // this.
            Navigator.pushReplacementNamed(context, HomeView.routeName);
        }else{
          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Erreur de connexion ! Veuillliez réessayer')),
          );
        }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('The verification code is invalid. Please try again.')));
      } else if (e.code == 'user-disabled') {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('This user has been disabled. Please contact support.')));
      } else if (e.code == 'operation-not-allowed') {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('This operation is not allowed. Please enable it in the Firebase console.')));
      } else if (e.code == 'too-many-requests') {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Too many requests. Please try again later.')));
      } else { if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred during sign-in: ${e.message}')));
        }
      }
    }
  }
}