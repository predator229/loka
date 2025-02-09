import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
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
  int? selectedOption = 1;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComboBoc();
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
    loadComboBoc();
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
                            child: Image.asset(
                              auth.userAuthentificate.imgPath ??  "images/damien.jpeg",
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
                    child: Form(
                      key: _formKey,
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
                                  onPressed: () {},
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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