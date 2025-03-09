import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/welcome.view.dart';
import 'package:http/http.dart' as http;

class RoutePage extends StatefulWidget {
  static const routeName = '/first-page';
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

Future<UserAuthentificate?> _getUserAuthentificate(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  try {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final datas = {
      'uid': user?.uid ?? '',
    };

      // print('Header: ${headers}');

    final response = await http.post(
      Uri.parse('http://localhost:5050/api/users/authentificate'),
      headers: headers,
      body: jsonEncode(datas),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] != null) {
        return UserAuthentificate.fromJson(data['user']);
      }
    }
    return null;
  } catch (e) {
    print('Error occurred: $e');
    _handleAuthError(context);
    return null;
  }
}

void _handleAuthError(BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Une erreur est survenue. Veuillez vous reconnecter.')),
  );

  final auth = AuthProviders.of(context).auth;
  await auth.signOut(); // Déconnexion de Firebase
  Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProviders.of(context).auth;
    return StreamBuilder<User?>(
      stream: auth.onAuthStatusChanged,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder<UserAuthentificate?>(
              future: _getUserAuthentificate(context),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return _buildWaitingScreen(context);
                } else if (authSnapshot.hasError || authSnapshot.data == null) {
                  _handleAuthError(context); // Déconnecte et redirige
                  return _buildWaitingScreen(context);
                } else {
                  auth.userAuthentificate = authSnapshot.data!;
                  return HomeView();
                }
              },
            );
          }
          return WelcomeView();
        }
        return _buildWaitingScreen(context);
      },
    );
  }

  Widget _buildWaitingScreen(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset(
            "images/loka.png",
            width: MediaQuery.of(context).size.width / 3,
          ),
        ),
      ),
    );
  }
}
