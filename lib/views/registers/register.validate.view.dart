import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/user.register.class.dart';

class RegisterValidateView extends StatefulWidget {
  static const routeName = '/register-phonenumber';
  const RegisterValidateView({super.key});

  @override
  State<RegisterValidateView> createState() => _RegisterValidateViewState();
}

class _RegisterValidateViewState extends State<RegisterValidateView> {
  final TextEditingController _phoneNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserRegisterClass user;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is UserRegisterClass) {
      user = args;
    } else {
      Navigator.of(context).pop();
    }
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
        title: const Text('Register'),
      ),
      resizeToAvoidBottomInset: true,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressIndicator(),
                        const SizedBox(height: 30),
                        const Text(
                          "Phone Number (3/3)",
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Please fill your phone number below.",
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                        const Text(
                          "The phone number will be used for the login.",
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.asset("images/icons/phone_number.png", fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 30),
                        _buildComboNumber(),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "When creating the account, you accept the conditions of use and the privacy policy of Loka.",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _registerNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('CREATE MY ACCOUNT'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

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
                  iconSize: 24, // Ajuste la taille de l'icône si nécessaire
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
                              country.dial_code,
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
      Expanded(
        child: IntrinsicHeight(
          child: TextFormField(
            controller: _phoneNumber,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
        ),
      ),
    ],
  );
}

  void _registerNext() {
    final phone = _phoneNumber.text;
    if (_formKey.currentState!.validate() && phone.isNotEmpty) {
      // Navigator.pushNamed(context, '/register/next');
      Auth().registerWithEmailAndPassword(userToCreate:  user, context: context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the form correctly'),
        ),
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
      _selectedCountry = results.isNotEmpty && myCountrieCode != null && myCountrieCode != '' ? results.firstWhere((country) => country.id == myCountrieCode) : null;
   });
  }
  Future <void> _getMyCode () async{
    setState(() { myCountrieCode = "BJ"; });

  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     throw Exception('Permission denied');
  //   }
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   String countryCode = placemarks[0].isoCountryCode ?? '';
  //   setState(() { myCountrieCode = countryCode; });
  }
}
