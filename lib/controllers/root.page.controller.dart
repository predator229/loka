import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/profil.view.dart';
import 'package:loka/views/welcome.view.dart';
import 'package:http/http.dart' as http;

class RoutePage extends StatefulWidget {
  static const routeName = '/first-page';
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

Future<dynamic> getUserAuthentificate(BuildContext context) async {
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
    final response = await http.post(
      // Uri.parse('https://backend-loka-production.up.railway.app/api/users/authentificate'),
      Uri.parse('http://localhost:5050/api/users/authentificate'),
      headers: headers,
      body: jsonEncode(datas),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] != null) {
        return {
          "user": UserAuthentificate.fromJson(data['user']),
          "typesApartments": data['typeApartment'] != null && (data['typeApartment'] as List).isNotEmpty ? (data['typeApartment'] as List).map((i) => TypeApartment.fromJson(i)).toList() : [], 
        };
      }
    }
    return null;
  } catch (e) {
    _handleAuthError(context);
    return null;
  }
}

Future<dynamic> getDefaultParams(BuildContext context) async {
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
    final response = await http.post(
      // Uri.parse('https://backend-loka-production.up.railway.app/api/settings/get-default-params'),
      Uri.parse('http://localhost:5050/api/settings/get-default-params'),
      headers: headers,
      body: jsonEncode(datas),
    );
      print('headers : ${headers}');
      print('datas : ${datas}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] != null) {
        return {
          "roomsTypes": data['roomsTypes'] != null && (data['roomsTypes'] as List).isNotEmpty ? (data['roomsTypes'] as List).map((i) => RoomType.fromJson(i)).toList() : [], 
          "equipementsType": data['equipementsType'] != null && (data['equipementsType'] as List).isNotEmpty ? (data['equipementsType'] as List).map((i) => EquimentType.fromJson(i)).toList() : [], 
          "typesApartments": data['typesApartments'] != null && (data['typesApartments'] as List).isNotEmpty ? (data['typesApartments'] as List).map((i) => TypeApartment.fromJson(i)).toList() : [], 
          "couverturesChambre": data['couverturesChambre'] != null && (data['couverturesChambre'] as List).isNotEmpty ? (data['couverturesChambre'] as List).map((i) => CouvertureChambre.fromJson(i)).toList() : [], 
        };
      }
    }
    return null;
  } catch (e) {
    _handleAuthError(context);
    return null;
  }
}

Future<void> _handleAuthError(BuildContext context) async {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Une erreur est survenue. Veuillez vous reconnecter.')),
    );

    final auth = AuthProviders.of(context).auth;
    await auth.signOut(); // Déconnexion de Firebase
    Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
  });

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
            return FutureBuilder<dynamic>(
              future: getUserAuthentificate(context),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return _buildWaitingScreen(context);
                } else if (authSnapshot.hasError || authSnapshot.data == null) {
                  _handleAuthError(context); // Déconnecte et redirige
                  return _buildWaitingScreen(context);
                } else {
                  auth.userAuthentificate = authSnapshot.data!["user"];
                  if (auth.userAuthentificate != null){
                    return StreamBuilder<User?>(
                      stream: auth.onAuthStatusChanged,
                      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          if (snapshot.hasData) {
                            return FutureBuilder<dynamic>(
                              future: getDefaultParams(context),
                              builder: (context, settingsSnapshot) {
                                if (settingsSnapshot.connectionState == ConnectionState.waiting) {
                                  return _buildWaitingScreen(context);
                                } else if (settingsSnapshot.hasError || settingsSnapshot.data == null) {
                                  // _handleAuthError(context);
                                  print("problem");
                                  return _buildWaitingScreen(context);
                                } else {
                                  auth.couverturesChambres = settingsSnapshot.data!["couverturesChambre"];
                                  auth.equipementsType = settingsSnapshot.data!["equipementsType"];
                                  auth.typesApartments = settingsSnapshot.data!["typesApartments"];
                                  auth.roomsType = settingsSnapshot.data!["roomsTypes"];
                                  
                                  return auth.userAuthentificate.phoneNumber != null ? HomeView() : ProfilView();
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
                  return auth.userAuthentificate.phoneNumber != null ? HomeView() : ProfilView();
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
