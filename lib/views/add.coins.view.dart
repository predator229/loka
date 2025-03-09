import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/controllers/apis.controller.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/controllers/root.page.controller.dart';
import 'package:loka/controllers/tools.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/payement.method.view.dart';

class AddCoinView extends StatefulWidget {
  static const String routeAddCoinView = '/AddCoinView';
  const AddCoinView({super.key});

  @override
  State<AddCoinView> createState() => _AddCoinViewState();
}

class _AddCoinViewState extends State<AddCoinView> {

  bool imLoadingDatas = false;

  final inMinZone = 0.0;
  final inMaxZone = 300.0;
  int? currentSliderValue;
  bool showSomeOnly = true;

  List<dynamic> coinsL = [
    {
      "iconWidget": Stack(
        children: [
          Image.asset("images/coin.png", width: 60),
        ],
      ),
      "nbr": 500,
      "price": 2000,
      "monnaie": "FCFA",
    },
    {
      "iconWidget": Stack(
        children: [
          Image.asset("images/coin.png", width: 60),
          Positioned(
            top: 30,
            child: Image.asset("images/coin.png", width: 30),
          ),
        ],
      ),
      "nbr": 3500,
      "price": 5000,
      "monnaie": "FCFA",
    },
    {
      "iconWidget": Stack(
        children: [
          Image.asset("images/coin.png", width: 60),
          Positioned(
            top: 30,
            child: Image.asset("images/coin.png", width: 30),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: Image.asset("images/coin.png", width: 30),
          ),
        ],
      ),
      "nbr": 5000,
      "price": 10000,
      "monnaie": "FCFA",
    }
  ];

  final TextEditingController _nbrChambreController = TextEditingController();
  late BaseAuth auth;
  int currentStep = 0;
  double evoluatingWidth =  0.0;
  late Timer _timer;

  @override
  void initState() {
    _nbrChambreController.text = "100";
      evoluatingWidth = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = AuthProviders.of(context).auth;
      // _phoneNumber.text = "";
        // _startProgressAnimation();
    });

  }

  void _startProgressAnimation() {
    final maxSize = MediaQuery.of(context).size.width - 50;
    const increment = 20.0;
    const duration = Duration(milliseconds: 500);

    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        evoluatingWidth += increment;
        if (evoluatingWidth >= maxSize) {
          evoluatingWidth = maxSize;
          if (currentStep == 2){
            _timer.cancel();
            Navigator.of(context).pushReplacementNamed(HomeView.routeName);
          }
          if (currentStep == 1){
            auth.userAuthentificate.coins = auth.userAuthentificate.coins + double.parse(_nbrChambreController.text);
            currentStep = 2;
          }
          evoluatingWidth = 0.0;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
  }

  @override
  Widget build(BuildContext context) {
    return whoIhaveToReturn();
  }

  Widget whoIhaveToReturn () {
    var toReturn = Container();
    switch (currentStep)  {
      case 1:
      case 2:
        return firstConnection();
    }
    return NotPaidYet();
  }

    Widget firstConnection() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset( currentStep == 2 ?  "images/preocced.gif" : "images/process_payement.png", width: 400),
                  Column(
                    children: [
                      Text(
                        currentStep == 1 ? "Veuillez patienter" :"Recharge effectuée !",
                        style: TextStyle(fontFamily: "Figtree",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 11, 11, 11)),
                      ),
                      if (currentStep == 2)
                      Wrap(
                          spacing: 10.0,
                          runSpacing: 20.0,
                          alignment: WrapAlignment.start,
                        children: [
                          Text(
                            "${_nbrChambreController.text} pièces ",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 32, color: SettingsClass().color),
                          ),
                          Text(
                            "reçu !",
                            style: TextStyle(fontFamily: "Figtree",
                                fontSize: 32,
                                color: const Color.fromARGB(255, 11, 11, 11),
                                fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  if (currentStep == 2)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 5,
                    width: evoluatingWidth,
                    decoration: BoxDecoration(
                      color: SettingsClass().color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (currentStep == 2)
                  ElevatedButton(
                    onPressed: () {
                      setState(() { Navigator.of(context).pushReplacementNamed(HomeView.routeName); });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SettingsClass().bottunColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Aller à l\'accueil'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Scaffold NotPaidYet (){
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color:  Color.fromARGB(39, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: (){ Navigator.of(context).pop(); },
            icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ajouter des pièces", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, fontFamily: "Figtree"),),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          Container(
                            height: 48,
                            width: 61,
                            decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(8),
                              color:   Color.fromARGB(255, 237, 237, 237), //
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() { 
                                  var val = _isNumeric(_nbrChambreController.text) ? double.parse(_nbrChambreController.text) - 1 : 1;
                                  _nbrChambreController.text =  (val < 0 ? 0 : val).toString(); 
                                });
                              },
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontFamily: "Figtree",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                height: 48,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _nbrChambreController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "2",
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8.0), // Ajuste l'espacement à droite
                                      child: Image.asset("images/coin.png", width: 40, height: 40),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: "Figtree",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 61,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(255, 237, 237, 237),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() { _nbrChambreController.text = (_isNumeric(_nbrChambreController.text) ? double.parse(_nbrChambreController.text) + 1 : 1).toString(); });
                              },
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontFamily: "Figtree",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ToolsController().buildDividerWithOr(text: "ou"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choisissez le nombre de pièces à recharger", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree", color: Color.fromARGB(255, 84, 84, 84)),),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var i=0; i < coinsL.length; i++)
                            buildSomething(i,coinsL[i]),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet( 
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: imLoadingDatas ?
                                        Center(child: CircularProgressIndicator()) 
                                         :
                                         ListView(
                                          children: [
                                            Text(
                                              "Recharger par",
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text("Selectionnez le moyen de recharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                                            const SizedBox(height: 20),
                                            for (int i = 0; i < SettingsClass().payementMethods.length; i++)
                                              ListTile(
                                                leading:  SettingsClass().payementMethods[i].assetPath != null ? Image.asset(SettingsClass().payementMethods[i].assetPath!, width: 30) : (SettingsClass().payementMethods[i].icon != null ? Icon(SettingsClass().payementMethods[i].icon,) : Icon(Icons.arrow_forward_ios_sharp, color: Colors.blue)),
                                                title: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(SettingsClass().payementMethods[i].title),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        if (i == 0 && auth.userAuthentificate.mobils != null)
                                                        for ( int j=0; j< auth.userAuthentificate.mobils!.length; j++)
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.max,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(auth.userAuthentificate.mobils![j].digits),
                                                                      Checkbox(
                                                                        value: auth.userAuthentificate.selectedPayementMethod != null && auth.userAuthentificate.selectedPayementMethod!.mobil != null && auth.userAuthentificate.selectedPayementMethod!.mobil!.id == auth.userAuthentificate.mobils![j].id,
                                                                        onChanged: (bool? value) {
                                                                            SelectedPayement selectedPayement = SelectedPayement( id: auth.userAuthentificate.mobils![j].id, mobil: auth.userAuthentificate.mobils![j],);
                                                                            _selectedPayementMethod(context, selectedPayement);
                                                                            Navigator.pop(context);
                                                                        },
                                                                        activeColor: SettingsClass().bottunColor,
                                                                        side: BorderSide(width: 2),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (i != 0 && auth.userAuthentificate.cards != null)
                                                        for ( int j=0; j< auth.userAuthentificate.cards!.length; j++)
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.max,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left:10),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        auth.userAuthentificate.cards![j].digits.split('').asMap().entries.map((entry) {
                                                                          int each = entry.key;
                                                                          String digit = entry.value;
                                                                          return each < 15 ? "*" : digit;
                                                                        }).join(),
                                                                      ),
                                                                      Checkbox(
                                                                        value: auth.userAuthentificate.selectedPayementMethod != null && auth.userAuthentificate.selectedPayementMethod!.card != null && auth.userAuthentificate.selectedPayementMethod!.card!.id == auth.userAuthentificate.cards![j].id,
                                                                        onChanged: (bool? value) {
                                                                          SelectedPayement selectedPayement = SelectedPayement(id: auth.userAuthentificate.cards![j].id, card: auth.userAuthentificate.cards![j],);
                                                                          _selectedPayementMethod(context, selectedPayement);
                                                                          Navigator.pop(context);
                                                                        },
                                                                        activeColor: SettingsClass().bottunColor,
                                                                        side: BorderSide(width: 2),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                                onTap: () { setState(() {
                                                  // isOpenedOptionsPayment[i] = !isOpenedOptionsPayment[i];
                                                }); 
                                              },
                                              ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).pushNamed(PayementMethodView.routeName);
                                              },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: SettingsClass().bottunColor,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ),
                                                ),
                                                child: const Text("Ajouter un nouveau moyen de payement", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w600),),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                ),
                              );
                          });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (auth.userAuthentificate.selectedPayementMethod != null &&  auth.userAuthentificate.selectedPayementMethod!.mobil != null)
                            Text('${auth.userAuthentificate.selectedPayementMethod!.mobil!.indicatif} ${auth.userAuthentificate.selectedPayementMethod!.mobil!.digits}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                          if (auth.userAuthentificate.selectedPayementMethod != null &&  auth.userAuthentificate.selectedPayementMethod!.card != null)
                            Text(
                              auth.userAuthentificate.selectedPayementMethod!.card!.digits.split('').asMap().entries.map((entry) {
                                int each = entry.key;
                                String digit = entry.value;
                                return each < 15 ? "*" : digit;
                              }).join(),
                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                          if (auth.userAuthentificate.selectedPayementMethod == null)
                            Text("Choississez votre moyen de recharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Icon(Icons.keyboard_arrow_right_sharp,)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (){
                                if (auth.userAuthentificate.selectedPayementMethod == null){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez choisir un moyen de payement")));
                                  return;
                                }
                                setState(() { currentStep = 1; });
                                _startProgressAnimation();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: SettingsClass().bottunColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                              ),
                              child: const Text("Recharger", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w600),),
                            ),
                          ),                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _isNumeric(String str) {
    if (str.isEmpty) {
      return false;
    }
    final number = num.tryParse(str);
    return number != null;
  }

  Widget buildSomething (int i, item) {
    return 
    InkWell(
      onTap: () {
        setState(() { 
          currentSliderValue = i; 
          _nbrChambreController.text = item["nbr"].toString();
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 3 -  (currentSliderValue != null && currentSliderValue == i ? 10 : 30),
          height: 136 + (currentSliderValue != null && currentSliderValue == i ? 20 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: currentSliderValue != null && currentSliderValue == i ?  Color.fromARGB(255, 255, 247, 213) : Color.fromARGB(255, 253, 250, 237), // border: 1px solid rgba(246, 182, 71, 1)
            border: Border.all(color: currentSliderValue != null && currentSliderValue == i ? Color.fromARGB(255, 246, 186, 71) : Colors.transparent ) ,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item["iconWidget"],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${item['nbr']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "Figtree"),),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset("images/coin.png", width: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${item["price"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("${item["monnaie"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
  Future<void> _selectedPayementMethod(BuildContext context, SelectedPayement selectedPayement) async {
    setState(() { imLoadingDatas = true; });
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/select-payement-method', {
        'uid': user?.uid ?? '',
        'selectedPayement': selectedPayement.toJson(),
      });

      if (response != null) {
        setState(() {
          imLoadingDatas = false;
          if (response['user'] != null) {
            auth.userAuthentificate = UserAuthentificate.fromJson(response['user']);
            return;
          }
          _handleAuthError(context);
        });
      } else {
        _handleAuthError(context);
      }
    } catch (e) {
      _handleAuthError(context);
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
}

