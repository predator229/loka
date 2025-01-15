import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/registers/register.view.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final _phoneNumber = TextEditingController();
  int? selectedOption = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Country> _countries = [];
  Country? _selectedCountry;
  String? myCountrieCode;
  
  @override
  void initState() {
    super.initState();
    _getMyCode();
    _loadCountries();

  }
  @override
  void dispose() {
    _phoneNumber.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Text('Skip', style: TextStyle(color: Colors.grey, )),
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
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() { selectedOption = value; });
                                },
                                focusNode: FocusNode(),
                                autofocus: true,
                              ),
                              Flexible(child: Text("Connecter vous en utilisant votre email et mot de passe",style: TextStyle(fontWeight: FontWeight.w100),)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() { selectedOption = value; });
                                },
                                focusNode: FocusNode(),
                              ),
                              Flexible(child: Text("Connecter vous en utilisant votre numero de telephone",style: TextStyle(fontWeight: FontWeight.w100),)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Container(height: 1, color: Colors.grey),
                          const SizedBox(height: 30),
                          if (selectedOption == 1)
                          _buildEmailPassword(),
                          if (selectedOption == 2)
                          _buildComboNumber(),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _lauchPhoneCodeAuthentification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Je me connecte'),
                          ),
                          const SizedBox(height: 30),
                          _buildDividerWithOr(),
                          const SizedBox(height: 30),
                          const SizedBox(height: 30),
                          _buildSocialButtons(),
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
                        Text('Pas de compte ? ', style: TextStyle(color: Colors.grey),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterView.routeName);
                          },
                          child: const Text(' Inscrivez vous ici ', style: TextStyle(color: Colors.green)),
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
  }

  // Helper Methods
Widget _buildComboNumber() {
  return Row(
    children: [
      // Conteneur pour le DropdownButton
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Center(
          child: _countries.isEmpty
              ? CircularProgressIndicator()
              : DropdownButton<Country>(
                  value: _selectedCountry,
                  onChanged: (Country? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                    });
                  },
                  isExpanded: true,
                  iconSize: 24,
                  items: _countries.map((Country country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            country.emoji,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${country.name}(${country.dial_code})',
                              // '${country.dial_code}(${country.name})',
                              style: TextStyle(fontSize: 16),
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
      SizedBox(width: 10),
      // Conteneur pour le TextFormField
      Expanded(
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

  Widget _buildDividerWithOr() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: Colors.grey),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('OR'),
        ),
        Expanded(
          child: Container(height: 1, color: Colors.grey),
        ),
      ],
    );
  }
  Widget _buildSocialButtons() {
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
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(50, 50),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildEmailPassword (){
    return Column(
      children: [
        _buildTextField(
            controller: _email,
            label: 'Email',
            hint: 'example@example.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildTextField(
              controller: _passwordController,
              label: 'Mot de passe',
              hint: '',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrer votre mot';
                }
                if (value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }
                if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins une majuscule';
                }
                if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins une minuscule';
                }
                if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins un chiffre';
                }
                if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins un caractere special';
                }
                return null;
              },
            ),
      ],
    );
  }
  void _lauchPhoneCodeAuthentification() {
    if (_formKey.currentState!.validate()) {
      if (selectedOption == 1){
        // Auth().loginWithEmailAndPassword(email: _email.text, password: _passwordController.text); 
        // HomeView
        Navigator.of(context).pushReplacementNamed(HomeView.routeName);
      }else{
        //login with phone number
        // Auth().signInWithPhoneNumber(country: _selectedCountry, phoneNumber: _phoneNumber.text);
      }
      // Navigator.pushNamed(context, RegisterValidateView.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form correctly')),
      );
    }
  }

    Future<void> _loadCountries() async {
    final String response = await rootBundle.loadString('assets/countries.json');
    final List<dynamic> data = json.decode(response);
    final results = data.map((countryData) => Country.fromJson(countryData)).toList();
    setState(() {
      _countries = results;
      if (myCountrieCode == null) {
        _getMyCode();
      }
      if (myCountrieCode != null && myCountrieCode != '') {
      _selectedCountry = results.firstWhere(
        (country) => country.id == myCountrieCode,
        orElse: () => results[0],
      );
    } else {
      _selectedCountry = results.isNotEmpty ? results[0] : null;
    }
   });
  }
  Future <void> _getMyCode () async{
    setState(() { myCountrieCode = "BJ"; });

    // LocationPermission permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    //   throw Exception('Permission denied');
    // }
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // String countryCode = placemarks[0].isoCountryCode ?? '';
    // setState(() { myCountrieCode = countryCode; print(countryCode); });
  }
}
