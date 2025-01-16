import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/controllers/tools.controller.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/views/home.view.dart';
import 'package:loka/views/authentifications/register.view.dart';

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

  late Future<Widget> _countryPicker;
  late UserCredential _userCredential;
  Country selectedCountry = Country(id: "BJ", name: "Benin", dialcode: "229", emoji: "🇧🇯", code: "BJ");

  @override
  void initState() {
    super.initState();
    _countryPicker = ToolsController().buildComboNumber(phoneNumber: _phoneNumber, selectedCountry: selectedCountry);
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
                          FutureBuilder<Widget>(
                            future: _countryPicker,
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
                            onPressed: _lauchPhoneCodeAuthentification,
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
                          ToolsController().buildSocialButtons(),
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
                          child: Text('Inscrivez vous ici ', style: TextStyle(color: SettingsClass().color )),
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

}
