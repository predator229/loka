import 'package:flutter/material.dart';
import 'package:loka/views/login.view.dart';
import 'package:loka/views/registers/register.view.dart';

class WelcomeView extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox (
              height: MediaQuery.of(context).size.height * 0.5,
              child: Flexible(
                child: PageView(
                  children: [
                    Image.asset('images/wlc_/welcome2.png', fit: BoxFit.cover),
                    Image.asset('images/wlc_/welcome1.png', fit: BoxFit.cover),
                    Image.asset('images/wlc_/welcome3.png', fit: BoxFit.cover),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Welcome to ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text('Loka', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('All the best apartment offers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterView.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text('Register'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Already have an account  ?', style: TextStyle(color: Colors.grey),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginView.routeName);
                          },
                          child: const Text(' Login here ', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                    // AboutListTile(
                    //   icon: const Icon(Icons.info),
                    //   applicationName: 'Loka',
                    //   applicationVersion: '1.0.0',
                    //   applicationIcon: const Icon(Icons.ac_unit),
                    //   applicationLegalese: '© 2025 Loka. All rights reserved.',
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}