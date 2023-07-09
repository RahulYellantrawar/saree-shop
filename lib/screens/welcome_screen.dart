import 'package:flutter/material.dart';
import 'package:p_sarees/screens/home_screen.dart';
import 'package:p_sarees/screens/register_screen.dart';
import 'package:p_sarees/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image1.png',
                  height: 300,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Never a better time to start.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () {
                      ap.isSignedIn == true
                          ? Navigator.of(context)
                              .pushNamed(HomeScreen.routeName)
                          : Navigator.of(context)
                              .pushNamed(RegisterScreen.routeName);
                    },
                    text: 'Get Started',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
