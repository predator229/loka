import 'package:flutter/material.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';

class ProfilView extends StatefulWidget {
  static const String routeName = '/profil';
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> with SingleTickerProviderStateMixin{

  late BaseAuth auth;

  @override
  void initState() {
    super.initState();
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes informations personnelles", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 3 > 158 ? 158 : MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3 > 158 ? 158 : MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 6,
                            color: Color.fromARGB(255, 226, 226, 226), // border: 8.06px solid rgba(226, 226, 226, 1)
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            auth.userAuthentificate.imgPath ??  "images/damien.jpeg",
                            width: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}