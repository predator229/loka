import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/user.register.class.dart';

class Auth {
  final FirebaseAuth  _firebase = FirebaseAuth.instance;

//LOGIN
//email and  password
  Future <void> loginWithEmailAndPassword ({
    required String email,
    required String password,
  }) async {
    await _firebase.signInWithEmailAndPassword(email: email, password: password);
  }

//phone number
  Future <void> signInWithPhoneNumber ({
    required String phoneNumber,
    required Country? country,
  }) async {
    await _firebase.signInWithPhoneNumber(country != null ? country.dial_code+phoneNumber : phoneNumber);
  }

// REGISTER
//email and  password
  Future <void> registerWithEmailAndPassword ({
    required UserRegisterClass userToCreate,
    required BuildContext context,
  }) async {
    if (userToCreate.password == null || userToCreate.password == '') { 
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
     }
    await _firebase.createUserWithEmailAndPassword(email: userToCreate.email, password: userToCreate.password ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yep created'),
      ),
    );
  }

  //verification phoneNumber
  Future <void> loginPhoneNumber ({
    required String phoneNumber,
  }) async {
    await _firebase.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) { },
      verificationFailed: (FirebaseAuthException authException) { },
      codeSent: (String verificationId, int? resendToken) { },
      codeAutoRetrievalTimeout: (String verificationId) { },
    );
  }

  //SIGN OUT
  Future <void> signOut () async {
    await _firebase.signOut();
  }
}