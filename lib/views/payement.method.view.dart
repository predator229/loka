import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';

class PayementMethodView extends StatefulWidget {
  static const String routeName = '/payement-method-view';
  const PayementMethodView({super.key});

  @override
  State<PayementMethodView> createState() => _PayementMethodViewState();
}

class _PayementMethodViewState extends State<PayementMethodView> {
  
    late BaseAuth auth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Country selectedCountry;
  List<Country> countries = [];
  final _phoneNumber = TextEditingController();
  final _digitsCard = TextEditingController();
  final _expiratingMonth = TextEditingController();
  final _cvv = TextEditingController();
  final _cardName = TextEditingController();
  List<bool> isOpenedOptionsPayment = List<bool>.filled(SettingsClass().payementMethods.length, false);

  void initState() {
    super.initState();
    loadComboBoc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }
  
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
    loadComboBoc();
  }


  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  leading: 
                  SettingsClass().payementMethods[i].assetPath != null ? Image.asset(SettingsClass().payementMethods[i].assetPath!, width: 30) : (SettingsClass().payementMethods[i].icon != null ? Icon(SettingsClass().payementMethods[i].icon,) : Icon(Icons.arrow_forward_ios_sharp, color: Colors.blue)),
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
                          Icon(isOpenedOptionsPayment[i] != null && isOpenedOptionsPayment[i] ? Icons.expand_less_sharp : Icons.expand_more_outlined,),
                        ],
                      ),
                      if (isOpenedOptionsPayment[i])
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
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                                      IconButton(
                                        onPressed: (){},
                                        icon: Icon(Icons.edit, color: Colors.grey),
                                      ),
                                    ],
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
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(auth.userAuthentificate.cards![j].digits),
                                      IconButton(
                                        onPressed: (){},
                                        icon: Icon(Icons.edit, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => displayDialogNewPayementMode(context, i), // Utilisation d'une fonction anonyme
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SettingsClass().bottunColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("+", style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w600),),
                                ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                  onTap: () { setState(() {
                    isOpenedOptionsPayment[i] = !isOpenedOptionsPayment[i];
                  }); 
                },
                ),
            ],
          ),
      ),
    );
  }

  displayDialogNewPayementMode(context, i){
    var item = SettingsClass().payementMethods[i];
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
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: (){ Navigator.of(context).pop(); },
                      icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
                    ),
                    Text(i == 0 ? "Ajout de numero de telephone" :
                      "Ajout de carte",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (i == 0)
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: FutureBuilder<Widget>(
                      future: _buildFuturePhoneNumber(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return snapshot.data!;
                        }
                      },
                    ),
                  ),
                ),
                if (i != 0)
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _digitsCard,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Numero de carte",
                            hintText: '1234 5678 9012 3456',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entrer votre numero de carte';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _expiratingMonth,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Date d'expiration",
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Entrer la date d\'expiration';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _cvv,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "CVV",
                                  hintText: '123',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Entrer le CVV';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _cardName,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Nom de la carte",
                            hintText: 'John Doe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Donner un nom a cette carte';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child:  
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                UserAuthentificate user = auth.userAuthentificate;
                                if (i == 0){
                                  Mobil newMethod = Mobil(digits: _phoneNumber.text, id: (user.mobils == null ? 1 : user.mobils!.length+1), title: "Mobile", indicatif: selectedCountry.dialcode);
                                  setState(() {
                                    if (user.mobils == null) { user.mobils = [newMethod]; } 
                                    else { user.mobils!.add(newMethod); }
                                    auth.userAuthentificate = user;
                                  });
                                }else{
                                  CardModel newMethod = CardModel(digits: _digitsCard.text, id: (user.cards == null ? 1 : user.cards!.length+1), title: _cardName.text, expiration: _expiratingMonth.text, cvv: _cvv.text);
                                  setState(() {
                                    if (user.cards == null) { user.cards = [newMethod];} 
                                    else { user.cards!.add(newMethod); }
                                    auth.userAuthentificate = user;
                                  });
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: SettingsClass().bottunColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                            ),
                            child: Text('Sauvegarder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "Figtree"), ),
                          ),
                      ),
                    ],
                  ),
              ],
            ),
          );
      });
  }

void loadComboBoc() async {
  final String response = await rootBundle.loadString('assets/countries.json');
  final List<dynamic> data = json.decode(response);
  setState(() {
    countries = data.map((countryData) => Country.fromJson(countryData)).toList();
    selectedCountry = countries.firstWhere(
      (country) => country.id == "BJ",
      orElse: () => countries[0],
    );
  });
}

  Future<Widget> _buildFuturePhoneNumber() async {  
  if (countries.isEmpty) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: DropdownButton<Country>(
              value: selectedCountry,
              onChanged: (Country? newValue) {
                setState(() {
                  selectedCountry = newValue!;
                });
              },
              isExpanded: true,
              iconSize: 24,
              items: countries.map((Country country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        country.emoji,
                        style: TextStyle(fontFamily: "Figtree",fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${country.name}(${country.dialcode})',
                          style: TextStyle(fontFamily: "Figtree",fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IntrinsicHeight(
            child: TextFormField(
              controller: _phoneNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Telephone",
                hintText: '7000000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Entrer votre numero de telephone';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }


}