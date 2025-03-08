import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loka/controllers/root.page.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/add.coins.view.dart';
import 'package:loka/views/apartement.view.dart';
import 'package:loka/views/filter.view.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/authentifications/login.view.dart';
import 'package:loka/views/authentifications/register.view.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/views/journals/journal.item.view.dart';
import 'package:loka/views/mymoins.view.dart';
import 'package:loka/views/payement.method.view.dart';
import 'package:loka/views/profil.view.dart';
import 'package:loka/views/welcome.view.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WaitingLoadingView());

  await Future.wait([
    Future.delayed(const Duration(seconds: 4)),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    initializeDateFormatting('fr_FR', null),
  ]);

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
          FilterView.routeName : (content) => const FilterView(),
          ProfilView.routeName : (content) => const ProfilView(),
          MyCoinsView.routeName : (content) => const MyCoinsView(),
          AddCoinView.routeAddCoinView : (content) => const AddCoinView(),
          PayementMethodView.routeName : (content) => const PayementMethodView(),
        },
        initialRoute: RoutePage.routeName,
      ),
    );
  }
}

class WaitingLoadingView extends StatefulWidget {
  const WaitingLoadingView({super.key});

  @override
  _WaitingLoadingViewState createState() => _WaitingLoadingViewState();
}

class _WaitingLoadingViewState extends State<WaitingLoadingView> with TickerProviderStateMixin {
  late AnimationController _containerController;
  late Animation<Offset> _containerOffsetAnimation;
  late AnimationController _leftImageController;
  late Animation<Offset> _leftImageOffsetAnimation;
  late AnimationController _rightImageController;
  late Animation<Offset> _rightImageOffsetAnimation;
  late AnimationController _bottomImageController;
  late Animation<Offset> _bottomImageOffsetAnimation;

  bool _showLeftImage = false;
  bool _showRightImage = false;
  bool _showBottomImage = false;

  @override
  void initState() {
    super.initState();

    _containerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _containerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.easeOut,
    ));

    _leftImageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _leftImageOffsetAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _leftImageController,
      curve: Curves.easeOut,
    ));

    _rightImageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rightImageOffsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _rightImageController,
      curve: Curves.easeOut,
    ));

    _bottomImageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bottomImageOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bottomImageController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _containerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _showLeftImage = true;
    });
    await _leftImageController.forward();
    setState(() {
      _showRightImage = true;
    });
    await _rightImageController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _showBottomImage = true;
    });
    await _bottomImageController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    _leftImageController.dispose();
    _rightImageController.dispose();
    _bottomImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loka',
      home: Scaffold(
        body: SlideTransition(
          position: _containerOffsetAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 8, 131, 120),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_showLeftImage)
                            SlideTransition(
                              position: _leftImageOffsetAnimation,
                              child: Image.asset("images/icon_loka/oval.png", width: 120, height: 120),
                            ),
                          if (_showRightImage)
                            SlideTransition(
                              position: _rightImageOffsetAnimation,
                              child: Image.asset("images/icon_loka/centered.png", width: 30, height: 30),
                            ),
                        ],
                      ),
                       if (_showBottomImage)
                        SlideTransition(
                          position: _bottomImageOffsetAnimation,
                          child: Image.asset("images/icon_loka/name.png", width: 100, height: 100),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


