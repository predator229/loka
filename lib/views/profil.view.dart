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

class ProfilView extends StatefulWidget {
  static const String routeName = '/profil';

  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> with SingleTickerProviderStateMixin{

  late BaseAuth auth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _phoneNumber = TextEditingController();
  late Country selectedCountry;
  List<Country> countries = [];
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  bool imLoadingDatas = false;
  bool imstachhere = false;

  @override
  void initState() {
    super.initState();
    loadComboBoc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = AuthProviders.of(context).auth;
      _nameController.text = auth.userAuthentificate.name ?? "";
      _surnameController.text = auth.userAuthentificate.surname ?? "";
      _emailController.text = auth.userAuthentificate.email ?? "";
      _phoneNumber.text = (auth.userAuthentificate.phoneNumber != null ? auth.userAuthentificate.phoneNumber?.digits :  "")!;
      imstachhere = auth.userAuthentificate.phoneNumber == null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = AuthProviders.of(context).auth;
    loadComboBoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes informations personnelles", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
      ),
      body: imLoadingDatas ? Center(child: CircularProgressIndicator()) : ( Form( key: _formKey, child: MediaQuery.of(context).orientation == Orientation.portrait ? _buildFormPortrait() : SafeArea(child: _buildFormPortraitLandScape()))),
    );
  }

  Column _buildFormPortrait(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  children: [
                  Container(
                      width: (MediaQuery.of(context).size.width / 3 > 158 ? 158 : MediaQuery.of(context).size.width/3)+50,
                      height: (MediaQuery.of(context).size.width / 3 > 158 ? 158 : MediaQuery.of(context).size.width / 3) +50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 6,
                          color: Color.fromARGB(255, 226, 226, 226), // border: 8.06px solid rgba(226, 226, 226, 1)
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              auth.userAuthentificate.imgPath ??  "https://ui-avatars.com/api/?name=${auth.userAuthentificate.name}+${auth.userAuthentificate.surname}&background=random",
                              width: (MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width/ 3) +50,
                              height: (MediaQuery.of(context).size.width / 3 > 140 ? 140 : MediaQuery.of(context).size.width/ 3) +50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 0,
                            left: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SettingsClass().bottunColor,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ],
          ),
          if (imstachhere)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Completer votre numro de telephone pour pouvoir utiliser la plateforme'),
            ),

          Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _surnameController,
                            decoration: InputDecoration(
                              labelText: "Prenoms",
                              hintText: 'Doe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer vos prenoms';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Nom",
                              hintText: 'John',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email (pas obligatoire)",
                              hintText: 'John',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _editProfilPicture(context);
                                  } else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Remplisser tous les champs obligatoires')),
                                    );
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
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  } 

  Widget _buildFormPortraitLandScape(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width/4,
                  height: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 5,
                      color: Color.fromARGB(255, 226, 226, 226),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Image.network(
                          auth.userAuthentificate.imgPath ??  "https://ui-avatars.com/api/?name=${auth.userAuthentificate.name}+${auth.userAuthentificate.surname}&background=random",
                          width: MediaQuery.of(context).size.width/4,
                          height: MediaQuery.of(context).size.width/4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 0,
                        left: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: SettingsClass().bottunColor,
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              if (imstachhere)
              Text("Completer votre numro de telephone pour pouvoir utiliser la plateforme)")
              ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _surnameController,
                            decoration: InputDecoration(
                              labelText: "Prenoms",
                              hintText: 'Doe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer vos prenoms';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Nom",
                              hintText: 'John',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email (pas obligatoire)",
                              hintText: 'John',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
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
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () { 
                          if (_formKey.currentState!.validate()) {
                            _editProfilPicture(context);
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Remplisser tous les champs obligatoires')),
                            );
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
            ),
          ],
        ),
        ),
      ],
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
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editProfilPicture(BuildContext context) async {
    setState(() { imLoadingDatas = true ; });
    try {
      ApiController api = ApiController();
      final user = FirebaseAuth.instance.currentUser;

      dynamic response = await api.post('users/edit-profil', {
        'uid': user?.uid ?? '',
        'name': _nameController.text,
        'surname': _surnameController.text,
        'thephone': _phoneNumber.text,
        'country': selectedCountry.dialcode,
      });



    setState(() { imLoadingDatas = false ; });


    if (response == null) {
      _handleAuthError(context);
      return;
    }

    if (response['error'] != null && response['error'] != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Une erreur est survenue.')),
      );
      return;
    }

    if (response['user'] != null) {
      setState(() {
        auth.userAuthentificate = UserAuthentificate.fromJson(response['user']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modificationn effectuee avec success !.')),
        );
        if (imstachhere ){
          Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
        }
      });
      return;
    }
      SnackBar(content: Text('Réponse inattendue du serveur. Veuillez vous reconnectez !'));
  } catch (e) {
    _handleAuthError(context);  } finally {
  }
    _handleAuthError(context);
  }

  void _handleAuthError(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Une erreur est survenue. Veuillez vous reconnecter.')),
    );
    final auth = AuthProviders.of(context).auth;
    await auth.signOut(); // Déconnexion de Firebase
    Navigator.of(context).pushReplacementNamed(RoutePage.routeName);
  }

  //profil-edit
}