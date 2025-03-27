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
  UserAuthentificate get userAuthentificate;
  List<TypeApartment> get typesApartments;
  List<ApartmentCard> get apartmentCard;
  set apartmentCard(List<ApartmentCard> auth);
  set typesApartments(List<TypeApartment> auth);
  set userAuthentificate(UserAuthentificate auth);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserAuthentificate _userAuthentificate = UserAuthentificate(id:'2', coins:3500, typeUser: SettingsClass().typeUser[2], name: "notgooduser", email: "notgooduser@gmail.com",  new_user: 0, phoneNumber: null, imgPath: "images/damien.jpeg");
  List<TypeApartment> _typesApartments = SettingsClass().typesApartments;
  List<ApartmentCard> _apartmentCard = [];

  @override
  List<ApartmentCard> get apartmentCard { return _apartmentCard; }
  set apartmentCard(List<ApartmentCard> value) { _apartmentCard = value; }

@override
  List<TypeApartment> get typesApartments { return _typesApartments; }
  set typesApartments(List<TypeApartment> value) { _typesApartments = value; }


  @override
  UserAuthentificate get userAuthentificate { return _userAuthentificate; }
  set userAuthentificate(UserAuthentificate user) { _userAuthentificate = user; }

  @override
  Stream<User?> get onAuthStatusChanged {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<void> sendCodeAndWaitResponse(BuildContext context, String phoneNumber, Country? country, void Function(String) isCodeSentUserFromFireBase) async {
    String fullPhoneNumber = '${country?.dialcode ?? ''} $phoneNumber';
    print(fullPhoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber, //fullPhoneNumber.replaceAll(' ', '')
      verificationCompleted: (PhoneAuthCredential credential) async {
        attemptLoginAndSendBackErrorMessage(context, credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Le numero de telephone est incorrect $fullPhoneNumber')),
          );
        }else{
          print(e.code);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur de connection de merce ${e.code}')),
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