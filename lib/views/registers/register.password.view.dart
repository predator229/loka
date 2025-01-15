import 'package:flutter/material.dart';
import 'package:loka/models/user.register.class.dart';
import 'package:loka/views/login.view.dart';
import 'package:loka/views/registers/register.validate.view.dart';

class RegisterPasswordView extends StatefulWidget {
  static const routeName = '/register-password';
  const RegisterPasswordView({super.key});

  @override
  State<RegisterPasswordView> createState() => _RegisterPasswordViewState();
}

class _RegisterPasswordViewState extends State<RegisterPasswordView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserRegisterClass user;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
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
                        _buildProgressIndicator(),
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
                        _buildTextField(
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
                        _buildTextField(
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
                      backgroundColor: Colors.green,
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
                          child: const Text(' Login here ', style: TextStyle(color: Colors.green)),
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
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    bool obscureText = false,
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

  void _registerNext() {
    if (_formKey.currentState!.validate()) {
      user.password = _passwordController.text;
      Navigator.pushNamed(context, RegisterValidateView.routeName, arguments: user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form correctly')),
      );
    }
  }
}
