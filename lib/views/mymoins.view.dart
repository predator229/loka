import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/add.coins.view.dart';

class MyCoinsView extends StatefulWidget {
  static const String routeName = '/my-coins';
  const MyCoinsView({super.key});

  @override
  State<MyCoinsView> createState() => _MyCoinsViewState();
}

class _MyCoinsViewState extends State<MyCoinsView> with SingleTickerProviderStateMixin{

  late BaseAuth auth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _phoneNumber = TextEditingController();
  late Country selectedCountry;
  List<Country> countries = [];
  int? selectedOption = 1;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = AuthProviders.of(context).auth;
      _nameController.text = auth.userAuthentificate.name ?? "";
      _surnameController.text = auth.userAuthentificate.surname ?? "";
      _emailController.text = auth.userAuthentificate.email ?? "";
      _phoneNumber.text = auth.userAuthentificate.phoneNumber ?? "";
    });
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
        title: Text("Mes pièces", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height: (MediaQuery.of(context).size.width / 3 > 158 ? 158 : MediaQuery.of(context).size.width / 3) +50,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment(-0.951, 0.309,),
                        end: Alignment(0.9, 0.951),
                        colors: [
                          Color.fromARGB(255,255,248,220),
                          Color.fromARGB(120,232,194,40),
                        ],
                        stops: [0.0326, 0.9153],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Solde actuel", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                              Row(
                                children: [
                                  Text("${auth.userAuthentificate.coins}", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, fontFamily: "Figtree"),),
                                  SizedBox(width: 10),
                                  Image.asset("images/coin.png", width: 40),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: ElevatedButton(
                                  onPressed: (){
                                     Navigator.of(context).pushNamed(AddCoinView.routeAddCoinView);
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SettingsClass().bottunColor,
                                    foregroundColor: Colors.white,
                                    // shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, size: 24, color: Colors.white,),
                                      Text(
                                        "Recharger mes pièces", 
                                        style: TextStyle(
                                          fontSize: 15, 
                                          fontWeight: FontWeight.w600, 
                                          fontFamily: "Figtree",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: Text(
                          "Moyen de recharge",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Figtree",
                          ),
                        ),
                      ),
                      for (var item in SettingsClass().payementMethods)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                          child: _buildItemList (item),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList (PayementMethod profil) {
    return 
    InkWell(
      onTap: () { 
        if (profil.routeName != null) { Navigator.of(context).pushNamed(profil.routeName!); }
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                if (profil.icon != null)
                Icon(profil.icon, size: 24,),
                if (profil.assetPath != null)
                Image.asset(profil.assetPath!, width: 24),
                SizedBox(width: 20),
                Text(profil.title, style: TextStyle(fontFamily: "Figtree",fontWeight: FontWeight.w500, fontSize: 16),),
              ],
            ),
            Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
    );
  }

}