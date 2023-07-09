import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    child: Image.asset('assets/images/image2.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Add your phone number. We'll send you a verification code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.purple,
                    controller: phoneController,
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 11),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: phoneController.text.length == 10
                          ? Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading ? const Center(child: CircularProgressIndicator()) : CustomButton(
                      text: "Login",
                      onPressed: () {
                        if (_isLoading) {
                          return;
                        }
                        if (phoneController.text.length == 10) {
                          sendPhoneNumber();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(backgroundColor: Colors.red,
                              content: Text('Enter 10 Digit mobile number'),
                            ),
                          );
                          return;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    setState(() {
      _isLoading = true;
    });
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
