import 'package:flutter/material.dart';
import 'package:loka/views/registers/register.validate.view.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Register'), // Inscription
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
                          "Your information",
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "How can we call you?",
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(
                          controller: _firstName,
                          label: 'First name',
                          hint: 'John',
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your first name' : null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _lastName,
                          label: 'Last name',
                          hint: 'Doe',
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your last name' : null,
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 30),
                        _buildDividerWithOr(),
                        const SizedBox(height: 30),
                        _buildSocialButtons(),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _register_next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continue'),
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
  }) {
    return TextFormField(
      controller: controller,
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
        _buildSocialButtonWithIcon(Icons.facebook_rounded, Colors.blue),
        _buildSocialButtonWithIcon(Icons.apple_outlined, Colors.grey),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(50, 50),
      ),
      child: Image.asset(assetPath, width: 20),
    );
  }

  Widget _buildSocialButtonWithIcon(IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(50, 50),
      ),
      child: Icon(icon, color: color),
    );
  }

  void _register_next() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, RegisterValidateView.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the form correctly')),
      );
    }
  }
}
