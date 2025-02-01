import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loka/controllers/root.page.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/views/apartement.view.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/authentifications/login.view.dart';
import 'package:loka/views/authentifications/register.view.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/views/journals/journal.item.view.dart';
import 'package:loka/views/welcome.view.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const EntryApp());
}

class EntryApp extends StatelessWidget {
  const EntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthProviders(
      key: Key("autht_provifrt_kjesbfnjlv"),
      auth: Auth(),
      child: MaterialApp(
        title: 'Loka',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        routes: {
          WelcomeView.routeName : (context) => const WelcomeView(),
          RegisterView.routeName : (context) => const RegisterView(),
          LoginView.routeName : (context) => const LoginView(),
          HomeView.routeName :  (context) => const HomeView(),
          RoutePage.routeName : (context) => const RoutePage(),
          JournalItem.routeName : (context) => const JournalItem(),
          ApartementView.routeName : (content) => const ApartementView(),
        },
        initialRoute: RoutePage.routeName,
      ),
    );
  }
}


