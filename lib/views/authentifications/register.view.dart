import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loka/controllers/tools.controller.dart';
import 'package:loka/models/auth.class.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/models/user.register.class.dart';
import 'package:loka/views/home.view.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final List<TextEditingController> _codes = List<TextEditingController>.generate(6, (index) => TextEditingController());
  final List<bool> isField = List<bool>.filled(6, false);

  late Future<Widget> _countryPicker;
  late UserCredential _userCredential;
  Country selectedCountry = Country(id: "BJ", name: "Benin", dialcode: "229", emoji: "🇧🇯", code: "BJ");

  var step = 1;
  var steps = [1,2,3,4];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _countryPicker = ToolsController().buildComboNumber(phoneNumber: _phoneNumber, selectedCountry: selectedCountry);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

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
              onPressed: decreaseStep,
            ),
            title: const Text('Inscription'),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ToolsController().buildProgressIndicator(nbr: step, withPadding: false),
                            const SizedBox(height: 30),
                            const Text(
                              "Vos informations",
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Comment vous appelez-vous ?",
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildTextField(
                              controller: _firstName,
                              label: 'Nom',
                              hint: 'John',
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Entrer votre nom' : null,
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
                              controller: _lastName,
                              label: 'Prenoms',
                              hint: 'Doe',
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Entrer vos prenoms' : null,
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
                              controller: _email,
                              label: 'Email',
                              hint: 'example@example.com',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer votre addresse email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'L\'email n\'est pas valide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildDividerWithOr(),
                            const SizedBox(height: 30),
                            ToolsController().buildSocialButtons(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _registerNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SettingsClass().color,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                        ),
                        child: const Text('Continuer'),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Vous avez deja un compte  ?'),
                            TextButton(
                              onPressed: (){ Navigator.of(context).pop(); }, //damien
                              child: Text(' Connectez-vous ici ', style: TextStyle(color: SettingsClass().color)),
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
      case 2 : toReturn = Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: decreaseStep,
            ),
            title: const Text('Inscription'),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              ToolsController().buildProgressIndicator(nbr: step, withPadding: false),
                            const SizedBox(height: 30),
                            const Text(
                              "Mot de passe",
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Entrer un mot de passe solide pour renforcer la sécurité de votre compte",
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildTextField(
                              controller: _passwordController,
                              label: 'Mot de passe',
                              hint: 'Entrer votre mot de passe',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer votre mot de passe';
                                }
                                if (value.length < 8) {
                                  return 'Votre mot de passe doit contenir au moins 8 caractères';
                                }
                                if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                                  return 'Votre mot de passe doit contenir au moins une majuscule';
                                }
                                if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                                  return 'Votre mot de passe doit contenir au moins une minuscule';
                                }
                                if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                                  return 'Votre mot de passe doit contenir au moins un chiffre';
                                }
                                if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                                  return 'Votre mot de passe doit conternir au moins un caractere special';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
                              controller: _passwordConfirmController,
                              label: 'Confirmer votre mot de passe',
                              hint: '',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer le meme mot de passe';
                                }
                                if (value != _passwordController.text) {
                                  return 'Les mots de passe ne sont pas identiques';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _registerNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SettingsClass().color,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                        ),
                        child: const Text('Continuer'),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Vous avez deja un compte ?'),
                            TextButton(
                              onPressed: (){ Navigator.of(context).pop(); }, //damien
                              child: Text(' Connectez-vous ici ', style: TextStyle(color: SettingsClass().color)),
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
      case 3 : toReturn = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: decreaseStep,
          ),
          title: const Text('Inscription'),
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
                          ToolsController().buildProgressIndicator(nbr: 3),
                          const SizedBox(height: 30),
                          const Text(
                            "Numéro de téléphone",
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Le numéro de téléphone sera utilisé pour vous connecter",
                            style: TextStyle(fontWeight: FontWeight.w100),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.asset("images/icons/phone_number.png", fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 30),
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
                        "En sélectionnant, vous acceptez les conditions générales d’utilisations et les politiques de Loka",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _registerNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SettingsClass().bottunColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10), ), 
                      ),
                      child: const Text('Créer mon compte'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      break;

      case 4: toReturn = Scaffold(
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
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Entrer le code sms envoyé au ${selectedCountry.dialcode + _phoneNumber.text} :",
                    style: TextStyle(fontSize: 16),
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
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                          style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          // Action pour renvoyer le code
                        },
                        child: const Text(
                          "Renvoyer le code",
                          style: TextStyle(
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
                      child: const Text( "Continuer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  // Helper Methods

  void _registerNext() async {
    if (_formKey.currentState!.validate()) {
      if (step < 3 ){ setState(() { step +=1; }); }
      else{ 
        if (step == 3){
          if (selectedCountry == null){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veuillez sélectionner votre pays')),
            );
            return;
          }
          _userCredential = await Auth().registerWithEmailAndPassword(userToCreate:  UserRegisterClass(email: _email.text, firstName: _firstName.text, lastName: _lastName.text, password: _passwordConfirmController.text, phoneNumber: selectedCountry!.dialcode+_phoneNumber.text));
          if (_userCredential != null) {
            setState(() { step = 4; });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erreur de connexion')),
            );
          }
        }
        if (step == 4){
          for (var i = 0; i < _codes.length; i++){
            var _codeController = _codes[i].text;
            if (_codeController.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veuillez entrer tous les codes')),
              );
              return;
            }
          }
            _userCredential = await Auth().registerWithEmailAndPassword(userToCreate:  UserRegisterClass(email: _email.text, firstName: _firstName.text, lastName: _lastName.text, password: _passwordConfirmController.text, phoneNumber: selectedCountry!.dialcode+_phoneNumber.text));
          // if (_userCredential != null){
          //   Navigator.of(context).pushReplacementNamed(HomeView.routeName);
          // }

          // if (selectedCountry == null){
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Veuillez sélectionner votre pays')),
          //   );
          //   return;
          // }
          // _userCredential = await Auth().registerWithEmailAndPassword(userToCreate:  UserRegisterClass(email: _email.text, firstName: _firstName.text, lastName: _lastName.text, password: _passwordConfirmController.text, phoneNumber: selectedCountry!.dialcode+_phoneNumber.text));
          // if (_userCredential != null){
          //   Navigator.of(context).pushReplacementNamed(HomeView.routeName);
          // }
        }
        // Navigate to SMS verification after successful registration
        // Navigator.pushNamed(context, RegisterValidateView.routeName, arguments: user);
        // here we just create the auth object with everything and send it to firebase and ....
       }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form correctly')),
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


}
