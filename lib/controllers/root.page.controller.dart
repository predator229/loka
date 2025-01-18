import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/welcome.view.dart';

class RoutePage extends StatefulWidget {
  static const routeName = '/first-page';
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProviders.of(context).auth;
    return StreamBuilder<User?>(
      stream: auth.onAuthStatusChanged,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot){
        // if (snapshot.connectionState == ConnectionState.waiting)
        if(snapshot.connectionState == ConnectionState.active){
          return snapshot.hasData ? HomeView() : WelcomeView();
        }
        return _buildWaitingScreen(context); 
      },
    );
  }

  Widget _buildWaitingScreen(BuildContext context){
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset("images/loka.png", width: MediaQuery.of(context).size.width/3),
        ),
      ),
    );
  }
}