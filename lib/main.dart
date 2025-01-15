import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/login.view.dart';
import 'package:loka/views/registers/register.password.view.dart';
import 'package:loka/views/registers/register.validate.view.dart';
import 'package:loka/views/registers/register.view.dart';
import 'package:loka/views/welcome.view.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const EntryApp());
}

class EntryApp extends StatefulWidget {
  const EntryApp({super.key});

  @override
  State<EntryApp> createState() => _EntryAppState();
}

class _EntryAppState extends State<EntryApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loka',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routes: {
        WelcomeView.routeName : (context) => const WelcomeView(),
        RegisterView.routeName : (context) => const RegisterView(),
        RegisterValidateView.routeName : (context) => const RegisterValidateView(),
        LoginView.routeName : (context) => const LoginView(),
        RegisterPasswordView.routeName :  (context) => const RegisterPasswordView(),
        HomeView.routeName :  (context) => const HomeView(),
      },
      initialRoute: WelcomeView.routeName,
    );
  }
}


