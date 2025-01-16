import 'package:flutter/material.dart';
import 'package:loka/controllers/tools.controller.dart';
import 'package:loka/models/settings.class.dart';
import 'package:loka/models/user.register.class.dart';
import 'package:loka/views/login.view.dart';

class RegisterView extends StatefulWidget {
  static const routeName = '/register';
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

  late UserRegisterClass user;

  var step = 1;
  var steps = [1,2,3];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
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
            title: const Text('Register'),
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
                              "Your information (1/3)",
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "How can we call you?",
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildTextField(
                              controller: _firstName,
                              label: 'First name',
                              hint: 'John',
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Please enter your first name' : null,
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
                              controller: _lastName,
                              label: 'Last name',
                              hint: 'Doe',
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Please enter your last name' : null,
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
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
                            const SizedBox(height: 30),
                            ToolsController().buildDividerWithOr(),
                            const SizedBox(height: 30),
                            ToolsController().buildSocialButtons(),
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
                        ),
                        child: const Text('Continue'),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Already have an account  ?', style: TextStyle(color: Colors.grey),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, LoginView.routeName);
                              },
                              child: Text(' Login here ', style: TextStyle(color: SettingsClass().color)),
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
              onPressed: decreaseStep(),
            ),
            title: const Text('Register'),
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
                              "Set Up password (2/3)",
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Enter a strong password to secure your account",
                              style: TextStyle(fontWeight: FontWeight.w100),
                            ),
                            const SizedBox(height: 30),
                            ToolsController().buildTextField(
                              controller: _passwordController,
                              label: 'Enter your password',
                              hint: 'Enter password',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter';
                                }
                                if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                                  return 'Password must contain at least one lowercase letter';
                                }
                                if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                                  return 'Password must contain at least one number';
                                }
                                if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                                  return 'Password must contain at least one special character';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            ToolsController().buildTextField(
                              controller: _passwordConfirmController,
                              label: 'Confirm your password',
                              hint: '',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'The passwords do not match';
                                }
                                return null;
                              },
                            ),
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
                        ),
                        child: const Text('Continue'),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Already have an account  ?', style: TextStyle(color: Colors.grey),),
                            TextButton(
                              onPressed: decreaseStep(),
                              child: Text(' Login here ', style: TextStyle(color: SettingsClass().color)),
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
      // case 3 : toReturn = 

    }

    return toReturn;
    
  }

  // Helper Methods

  void _registerNext() {
    // switch view with effect in fcuntion of current step 1->2 2->3 3->register and if all the things are ok
    // return;
    if (_formKey.currentState!.validate()) {
      if (step < 3 ){ setState(() { step++; }); }
      else{ 
        // user.password = _passwordController.text;
        // Navigator.pushNamed(context, RegisterValidateView.routeName, arguments: user);
        // here we just create the auth object with everything and send it to firebase and ....
       }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form correctly')),
      );
    }
  }
  
  decreaseStep() {
    if (step > 1){ setState(() { step--; }); }
    else{ Navigator.pop(context); }
  }


}
