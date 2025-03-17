import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loka/controllers/apis.controller.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/controllers/root.page.controller.dart';
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
  List<bool> isOpenedOptionsPayment = List<bool>.filled(SettingsClass().payementMethods.length, true);

  bool imLoadingDatas = false;
  String newButtonTextContent = "+";
  String showIdCard = "";
  void initState() {
    super.initState();
    loadComboBoc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = AuthProviders.of(context).auth;
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
            onPressed: (){  Navigator.of(context).pop(); },
            icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ElevatedButton(
            onPressed: () => displayDialogNewPayementMode(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: SettingsClass().bottunColor,
                foregroundColor: Colors.white,
              ),
              onLongPress: () {
                setState(() { newButtonTextContent = newButtonTextContent == "+ Ajouter" ? "+" : "+ Ajouter"; });
              },
              child: Text(newButtonTextContent, style: TextStyle(fontFamily: "Figtree",fontSize: 14, fontWeight: FontWeight.w800),),
            ),
          ),
        ],
      ),
      body: imLoadingDatas ? Center(child: CircularProgressIndicator()) 
      : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "Options de recharge",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Liste des moyens de recharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: "Figtree"),),
                    const SizedBox(height: 20),
                    for (int i = 0; i < SettingsClass().payementMethods.length; i++)
                    Column(
                      children: [
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
                                Icon(isOpenedOptionsPayment[i] != null && isOpenedOptionsPayment[i] ? Icons.expand_less_sharp : Icons.expand_more_outlined,),
                              ],
                            ),
                          ],
                        ),
                        onTap: () { setState(() {
                          isOpenedOptionsPayment[i] = !isOpenedOptionsPayment[i];
                        }); 
                      },
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20),
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                  setState(() {
                                                    showIdCard = showIdCard == auth.userAuthentificate.mobils![j].id ? "" : auth.userAuthentificate.mobils![j].id;
                                                  });
                                                },
                                                onLongPress: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Suppression du moyen de payement : Mobil money (${auth.userAuthentificate.mobils![j].indicatif} ${auth.userAuthentificate.mobils![j].digits})'),
                                                        content: Text('Voulez-vous vraiment cet moyen de payement ?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Annuler'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _removeMobilServer(context, auth.userAuthentificate.mobils![j]);
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Supprimer'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(auth.userAuthentificate.mobils![j].digits),
                                              ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: Duration(milliseconds: 100),
                                            transitionBuilder: (Widget child, Animation<double> animation) {
                                              return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: Offset(1, 0),
                                                end: Offset(0, 0),
                                              ).animate(animation),
                                              child: child,
                                            );
                                          },
                                          child: showIdCard == auth.userAuthentificate.mobils![j].id
                                            ? InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Suppression du moyen de payement : Mobil money (${auth.userAuthentificate.mobils![j].indicatif} ${auth.userAuthentificate.mobils![j].digits})'),
                                                      content: Text('Voulez-vous vraiment cet moyen de payement ?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Annuler'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                                _removeMobilServer(context, auth.userAuthentificate.mobils![j]);
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Supprimer'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                            
                                              },
                                              child: Container(
                                                  key: ValueKey<String>(auth.userAuthentificate.mobils![j].id),
                                                  padding: EdgeInsets.only(left: 10),
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 20.0),
                                                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                                                  ),
                                              ),
                                            )
                                            : SizedBox.shrink(),
                                          ), //damien
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
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20),
                                    child: Container(
                                      padding: EdgeInsets.only(left:10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    showIdCard = showIdCard == auth.userAuthentificate.cards![j].id ? "" : auth.userAuthentificate.cards![j].id;
                                                  });
                                                },
                                                onLongPress: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Suppression du moyen de payement : Carte (${auth.userAuthentificate.cards![j].digits.split('').asMap().entries.map((entry) { int each = entry.key; String digit = entry.value; return each < 15 ? "*" : digit; }).join()})'),
                                                        content: Text('Voulez-vous vraiment cet moyen de payement ?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Annuler'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _removeCardServer(context, auth.userAuthentificate.cards![j]);
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Supprimer'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                auth.userAuthentificate.cards![j].digits.split('').asMap().entries.map((entry) {
                                                int each = entry.key;
                                                String digit = entry.value;
                                                return each < 15 ? "*" : digit;
                                                }).join(),
                                                ),
                                              ),
                                            ),
                                            AnimatedSwitcher(
                                              duration: Duration(milliseconds: 100),
                                              transitionBuilder: (Widget child, Animation<double> animation) {
                                                return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(1, 0),
                                                  end: Offset(0, 0),
                                                ).animate(animation),
                                                child: child,
                                              );
                                              },
                                              child: showIdCard == auth.userAuthentificate.cards![j].id
                                                ? InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                        title: Text('Suppression du moyen de payement : Carte (${auth.userAuthentificate.cards![j].digits.split('').asMap().entries.map((entry) { int each = entry.key; String digit = entry.value; return each < 15 ? "*" : digit; }).join()})'),
                                                        content: Text('Voulez-vous vraiment cet moyen de payement ?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Annuler'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                  _removeCardServer(context, auth.userAuthentificate.cards![j]);
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Supprimer'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                
                                                  },
                                                  child: Container(
                                                      key: ValueKey<String>(auth.userAuthentificate.cards![j].id),
                                                      padding: EdgeInsets.only(left: 10),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 20.0),
                                                        child: Icon(Icons.delete, color: Colors.white, size: 30),
                                                      ),
                                                  ),
                                                )
                                                : SizedBox.shrink(),
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
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  displayDialogNewPayementMode(context){
    int i = 0;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel, color: Colors.grey, size: 41),
                ),
                DropdownButton<int>(
                value: i,
                items: List.generate(
                  SettingsClass().payementMethods.length,
                  (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Text(SettingsClass().payementMethods[index].title),
                  ),
                ),
                onChanged: (int? newValue) {
                  setState(() {
                  i = newValue!;
                  });
                },
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
                  inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                    final text = newValue.text;
                    final newText = StringBuffer();
                    for (int i = 0; i < text.length; i++) {
                      if (i % 4 == 0 && i != 0) {
                      newText.write(' ');
                      }
                      newText.write(text[i]);
                    }
                    return TextEditingValue(
                      text: newText.toString(),
                      selection: TextSelection.collapsed(offset: newText.length),
                    );
                    },
                  ),
                  ],
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
                  if (value.replaceAll(' ', '').length != 16) {
                    return 'Le numero de carte doit contenir 16 chiffres.';
                  }
                  var allkO = true;
                  if (auth.userAuthentificate.cards == null) {
                    return null;
                  }
                  for (var item in auth.userAuthentificate.cards!) {
                    if (item.cvv == _cvv.text &&
                      item.digits == value &&
                      item.expiration == _expiratingMonth.text) {
                    allkO = false;
                    break;
                    }
                  }
                  if (!allkO) {
                    return 'Cette carte est deja enregistrer';
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
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                          primary: SettingsClass().bottunColor,
                          ),
                        ),
                        child: child!,
                        );
                      },
                      );
                      if (pickedDate != null) {
                      setState(() {
                        _expiratingMonth.text =
                          "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year.toString().substring(2)}";
                      });
                      }
                    },
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
                      var allkO = true;
                      if (auth.userAuthentificate.cards == null) {
                      return null;
                      }
                      for (var item in auth.userAuthentificate.cards!) {
                      if (item.cvv == _cvv.text &&
                        item.digits == _digitsCard.text &&
                        item.expiration == value) {
                        allkO = false;
                        break;
                      }
                      }
                      if (!allkO) {
                      return '';
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
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
                      if (value.length != 3) {
                      return 'Le CVV doit contenir 3 chiffres.';
                      }
                      var allkO = true;
                      if (auth.userAuthentificate.cards == null) {
                      return null;
                      }
                      for (var item in auth.userAuthentificate.cards!) {
                      if (item.cvv == value &&
                        item.digits == _digitsCard.text &&
                        item.expiration == _expiratingMonth.text) {
                        allkO = false;
                        break;
                      }
                      }
                      if (!allkO) {
                      return '';
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
              child: ElevatedButton(
                onPressed: () {
                if (_formKey.currentState!.validate()) {
                  UserAuthentificate user = auth.userAuthentificate;
                  if (i == 0) {
                  Mobil newMethod = Mobil(
                    digits: _phoneNumber.text,
                    id: (user.mobils == null ? 1 : user.mobils!.length + 1).toString(),
                    title: "Mobile",
                    indicatif: selectedCountry.dialcode,
                  );
                  setState(() {
                    _addMobilServer(context, newMethod);
                  });
                  } else {
                  CardModel newMethod = CardModel(
                    digits: _digitsCard.text,
                    id: (user.cards == null ? 1 : user.cards!.length + 1).toString(),
                    title: _cardName.text,
                    expiration: _expiratingMonth.text,
                    cvv: _cvv.text,
                  );
                  setState(() {
                    _addCardServer(context, newMethod);
                  });
                  }
                  Navigator.of(context).pop();
                }
                },
                style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: SettingsClass().bottunColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                ),
                child: Text(
                'Sauvegarder',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "Figtree"),
                ),
              ),
              ),
            ],
            ),
          ],
          ),
        );
        },
      );
      },
    );
  }

void loadComboBoc() async {
  final String response = await rootBundle.loadString('assets/countries.json');
  final List<dynamic> data = json.decode(response);
  setState(() {
    countries = data.map((countryData) => Country.fromJson(countryData)).toList();
    selectedCountry = countries.firstWhere(
      (country) => country.dialcode == ( auth.userAuthentificate.phoneNumber != null ? auth.userAuthentificate.phoneNumber?.indicatif : "+229"),
      orElse: () => countries[0],
    );
  });
  if (auth.userAuthentificate.phoneNumber == null){
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          String countryCode = placemarks.first.isoCountryCode!;
          setState(() {
            selectedCountry = countries.firstWhere(
              (country) => country.id == countryCode,
              orElse: () => countries[0],
            );
          });
        }
      }
    } catch (e) {
    }
  }
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
              keyboardType: TextInputType.number,
              inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  final text = newValue.text;
                  final newText = StringBuffer();
                  for (int i = 0; i < text.length; i++) {
                    if (i %3 == 0 && i != 0) {
                    newText.write(' ');
                    }
                    newText.write(text[i]);
                  }
                  return TextEditingValue(
                    text: newText.toString(),
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                  },
                ),
              ],
              decoration: InputDecoration(
                labelText: "Telephone",
                hintText: '9000000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                
              ),
              validator: (value) {
                if (value!.isEmpty) { return 'Entrer votre numero de telephone'; }
                if (value.length <10) { return 'Le nr. de telephone doit contenir au moins 8 chiffres.'; }
                var allkO = true;
                if (auth.userAuthentificate.mobils == null) { return null; }
                for (var  number in auth.userAuthentificate.mobils!){
                  if (number.digits == value && number.indicatif == selectedCountry.dialcode){
                    allkO = false;
                    break;
                  }
                }
                if (!allkO) { return 'Ce numero de telephone existe deja'; }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addMobilServer(BuildContext context, Mobil mobil) async {
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/add-mobil', {
        'uid': user?.uid ?? '',
        'mobil': mobil.toJson(),
      });

      if (response != null) {
        setState(() {
          if (response['user'] != null) {
            auth.userAuthentificate =  UserAuthentificate.fromJson(response['user']);
            imLoadingDatas = false;
            return;
          }
        _handleAuthError(context);
        });
      } 
      else { _handleAuthError(context); }
    } catch (e) {
      _handleAuthError(context);
    }
  }

  Future<void> _addCardServer(BuildContext context, CardModel card) async {
    setState(() { imLoadingDatas = true; });
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/add-card', {
        'uid': user?.uid ?? '',
        'card': card.toJson(),
      });

      if (response != null) {
        setState(() {
          if (response['user'] != null) {
            auth.userAuthentificate =  UserAuthentificate.fromJson(response['user']);
            imLoadingDatas = false;
            return;
          }
        _handleAuthError(context);
        });
      } 
      else { _handleAuthError(context); }
    } catch (e) {
      _handleAuthError(context);
    }
  }

Future<void> _removeCardServer(BuildContext context, CardModel card) async {
    setState(() { imLoadingDatas = true; });
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/remove-card', {
        'uid': user?.uid ?? '',
        'card': card.toJson(),
      });

      if (response != null) {
        setState(() {
          if (response['user'] != null) {
            auth.userAuthentificate =  UserAuthentificate.fromJson(response['user']);
            imLoadingDatas = false;
            return;
          }
        _handleAuthError(context);
        });
      } 
      else { _handleAuthError(context); }
    } catch (e) {
      _handleAuthError(context);
    }
  }

  Future<void> _removeMobilServer(BuildContext context, Mobil mobil) async {
    setState(() { imLoadingDatas = true; });
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/remove-mobil', {
        'uid': user?.uid ?? '',
        'mobil': mobil.toJson(),
      });

      if (response != null) {
        setState(() {
          if (response['user'] != null) {
            auth.userAuthentificate =  UserAuthentificate.fromJson(response['user']);
            imLoadingDatas = false;
            return;
          }
        _handleAuthError(context);
        });
      } 
      else { _handleAuthError(context); }
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