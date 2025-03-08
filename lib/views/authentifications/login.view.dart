import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/controllers/auth.provider.controller.dart';
import 'package:loka/controllers/tools.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/authentifications/register.view.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneNumber = TextEditingController();
  int? selectedOption = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late BaseAuth auth;
  late Country selectedCountry;
  List<Country> countries = [];

  final List<TextEditingController> _codes = List<TextEditingController>.generate(6, (index) => TextEditingController());
  final List<bool> isField = List<bool>.filled(6, false);

  var step = 1;
  var verificationId = "";
  var steps = [1,2];

  @override
  initState() {
    super.initState();
    loadComboBoc();
  }

  @override
  void dispose() {
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    auth = AuthProviders.of(context).auth;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRegisterForm1();
  }

  Scaffold _buildRegisterForm1() {
    Scaffold toReturn = Scaffold();
    switch (step) {
      case 1 : toReturn = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset("images/loka.png", width: 104),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('Skip', style: TextStyle(fontFamily: "Figtree",color: Colors.grey, )),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              "Connexion",
                              style: TextStyle(fontFamily: "Figtree",fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            FutureBuilder<Widget>(
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
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _registerNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SettingsClass().bottunColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                              ),
                              child: const Text('Je me connecte'),
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildDividerWithOr(),
                            const SizedBox(height: 30),
                            const SizedBox(height: 30),
                            buildSocialButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Pas de compte ? ',),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterView.routeName);
                            },
                            child: Text('Inscrivez vous ici ', style: TextStyle(fontFamily: "Figtree",color: SettingsClass().color )),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      break;
      case 2 : toReturn = 
      Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: decreaseStep,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vérification de compte",
                    style: TextStyle(fontFamily: "Figtree",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Entrer le code sms envoyé au ${selectedCountry.dialcode + _phoneNumber.text} :",
                    style: TextStyle(fontFamily: "Figtree",fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 52,
                        height: 52,
                        child: TextFormField( //damien
                          controller: _codes[index],
                          onChanged: (value) {
                              setState(() { isField[index] = value.isNotEmpty; });
                            
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
 
inputFormatters: [ FilteringTextInputFormatter.digitsOnly, ],

                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: "Figtree",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: isField[index] ? SettingsClass().color : SettingsClass().noProgressBGC,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sms non reçu ? ",
                          style: TextStyle(fontFamily: "Figtree",color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          // Action pour renvoyer le code
                        },
                        child: const Text(
                          "Renvoyer le code",
                          style: TextStyle(fontFamily: "Figtree",
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _registerNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: SettingsClass().bottunColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                      ), 
                      child: const Text( "Continuer", style: TextStyle(fontFamily: "Figtree",fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
      break;
    }
    return toReturn;
  }

  Widget buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSocialButton('images/icons/google.png'),
      ],
    );
  }
  Widget _buildSocialButton(String assetPath) {
    return Expanded(
      child: ElevatedButton(
          onPressed: (){ auth.signInWithGoogle(context); },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(50, 50),
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(assetPath, width: 20),
              Text("Se connecter par Google"),
            ],
          ),
        ),
    );
  }

  void _registerNext() async {
    if (_formKey.currentState!.validate()) {
      if (step == 1){
        if (selectedCountry == null){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez sélectionner votre pays')),
          );
          return;
        }
        await auth.sendCodeAndWaitResponse(context, _phoneNumber.text, selectedCountry!, isCodeSentUserFromFireBase);
      }
      if (step == 2){
        var fullcode = '';
        for (var i = 0; i < _codes.length; i++){
          var _codeController = _codes[i].text;
          if (_codeController.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veuillez entrer tous les codes')),
            );
            return;
          }
          fullcode = fullcode + _codeController;
        }
        await auth.loginWithPhoneAndCode(context, verificationId, fullcode);
      }
       
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remplisser tous les champs correctement')),
      );
    }
  }
  void decreaseStep() {
    if (step > 1) {
      setState(() => step--);
    } else {
      Navigator.pop(context);
    }
  }

  void isCodeSentUserFromFireBase (String code){
    setState(() { 
      verificationId = code;
      step = 2;
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

