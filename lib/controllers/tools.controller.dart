import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loka/models/country.class.dart';
import 'package:loka/models/settings.class.dart';

class ToolsController {
  
  Widget buildProgressIndicator({required int nbr, int max_=3, withPadding=true}) {
    List<Widget> toReturn = [];
    for (int i = 0; i < nbr; i++) { toReturn.add(_oneProgressContainer(color : SettingsClass().progressBGC, withPadding : withPadding)); }
    if (nbr < max_) {
      for (int i=0; i<max_-nbr; i++) { toReturn.add(_oneProgressContainer(color : SettingsClass().noProgressBGC, withPadding : withPadding)); }
    }
    return Row( children:  toReturn );
  }

  Widget _oneProgressContainer({required Color color, withPadding=true}) {
   return Expanded(
    child: withPadding ? Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
       height: 5,
       decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
       ),
      ),
    ) : 
    Container(
       height: 5,
       decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
       ),
      ),
   );
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
            onPressed: (){},
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
    Widget buildTextField({
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

  Widget buildDividerWithOr({String text=""}) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text( text ?? 'OR'),
        ),
        Expanded(
          child: Container(height: 1, color: Colors.grey),
        ),
      ],
    );
  }

Future<Widget> buildComboNumber({required TextEditingController phoneNumber, required Country? selectedCountry}) async {  
  final String response = await rootBundle.loadString('assets/countries.json');
  final List<dynamic> data = json.decode(response);
  List<Country> countries = data.map((countryData) => Country.fromJson(countryData)).toList();

  String? myCountrieCode = _getMyCode();

  selectedCountry = myCountrieCode != '' ? countries.firstWhere(
      (country) => country.id == myCountrieCode,
      orElse: () => countries[0],
    ) : null;

  return 
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        flex: 1,
        child: Center(
          child: countries.isEmpty
              ? CircularProgressIndicator()
              : DropdownButton<Country>(
                  value: selectedCountry,
                  onChanged: (Country? newValue) {
                    selectedCountry = newValue;
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
            controller: phoneNumber,
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

   String _getMyCode () {
     return "BJ";

    // LocationPermission permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    //   throw Exception('Permission denied');
    // }
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // String countryCode = placemarks[0].isoCountryCode ?? '';
    //  myCountrieCode = countryCode; print(countryCode); });
  }

}
