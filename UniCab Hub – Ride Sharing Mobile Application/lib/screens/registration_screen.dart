// ignore_for_file: use_build_context_synchronously

import 'package:bikerzone/screens/bike_info_screen.dart';
import 'package:bikerzone/widgets/input_date_custom.dart';
import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.onTap});

  final Function()? onTap;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPaswordController = TextEditingController();
  final emailController = TextEditingController();
  DateTime? birthdayController;

  bool? _isChecked = false;

  void register() async {
    showDialog(
      context: context,
      builder: ((context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );

    try {
      if (passwordController.text != confirmPaswordController.text) {
        Navigator.pop(context);
        showErrorMessage("Passwords do not match.");
        return;
      } else if (_isChecked == false) {
        Navigator.pop(context);
        showErrorMessage("Please accept the terms and conditions.");
        return;
      } else {
        // create user (users collection and firebase auth)
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        addUserDetails(
            fullnameController.text, usernameController.text, emailController.text, birthdayController!, userCredential.user!.uid);

        Navigator.pop(context);
        Navigator.push(
          context,
          UnanimatedRoute(builder: (context) => const BikeInfoScreen()),
        );
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == 'user-not-found') {
        showErrorMessage("User with this email does not exist.");
      } else if (error.code == 'wrong-password') {
        showErrorMessage("Incorrect password.");
      } else if (error.code == 'weak-password') {
        showErrorMessage("Password must be at least 6 characters.");
      } else if (error.code == 'email-already-in-use') {
        showErrorMessage("User with this email already exists.");
      } else {
        showErrorMessage(error.code);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _handleDataReceived(DateTime date) {
    setState(() {
      birthdayController = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      "Create a profile and join with us.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff4E4E4E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    InputFieldCustom(
                      labelText: "Full Name:",
                      controller: fullnameController,
                      hintText: "Enter full name...",
                      hide: false,
                    ),
                    InputFieldCustom(
                      labelText: "Username:",
                      controller: usernameController,
                      hintText: "Enter username...",
                      hide: false,
                    ),
                    InputFieldCustom(
                      labelText: "Email:",
                      controller: emailController,
                      hintText: "Enter email...",
                      hide: false,
                    ),
                    InputDateCustom(
                      helpText: "Select Date of Birth:",
                      labelText: "Date of Birth:",
                      onDataReceived: _handleDataReceived,
                      hintText: "Date of Birth",
                      futureDateAllowed: false,
                    ),
                    InputFieldCustom(
                      labelText: "Password:",
                      controller: passwordController,
                      hintText: "Enter password...",
                      hide: true,
                    ),
                    InputFieldCustom(
                      labelText: "Confirm Password:",
                      controller: confirmPaswordController,
                      hintText: "Confirm password...",
                      hide: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: CheckboxListTile(
                        title: const Text(
                          'I accept the terms and conditions.',
                          style: TextStyle(fontSize: 13),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _isChecked,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    LargeButtonCustom(
                      onTap: register,
                      btnText: "Sign Up",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Color(0xFF444444), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Log In.",
                            style: TextStyle(color: Color(0xFFA41723), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
