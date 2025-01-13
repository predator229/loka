import 'package:flutter/material.dart';

class RegisterValidateView extends StatefulWidget {
  static const routeName = '/register-validate';
  const RegisterValidateView({super.key});

  @override
  State<RegisterValidateView> createState() => _RegisterValidateViewState();
}

class _RegisterValidateViewState extends State<RegisterValidateView> {
  final TextEditingController _phoneNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Phone Number",
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
                          child: Image.asset("images/icons/phone_number.avif", fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    "images/flags/benin.png",
                                    width: 30,
                                  ),
                                  const Text("+229", style: TextStyle(fontWeight: FontWeight.bold)),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
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
                          ],
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

  void _registerNext() {
    final phone = _phoneNumber.text;
    if (_formKey.currentState!.validate() && phone.isNotEmpty) {
      // Navigator.pushNamed(context, '/register/next');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the form correctly'),
        ),
      );
    }
  }
}
