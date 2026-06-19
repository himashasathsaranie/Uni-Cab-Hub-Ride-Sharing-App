import 'package:bikerzone/widgets/input_field_custom.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.onTap});

  final Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // remove loading after success
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showErrorMesage("There is no user with that email.");
      } else if (e.code == 'wrong-password') {
        showErrorMesage("Incorrect password.");
      } else {
        showErrorMesage("Invalid credentials.");
      }
    }
  }

  void showErrorMesage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "lib/images/1.png",
                      height: 230,
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff4E4E4E),
                          ),
                        ),
                        Text(
                          "UniCabs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4E4E4E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // email field
                    InputFieldCustom(
                      controller: emailController,
                      hintText: "Email",
                      hide: false,
                    ),

                    //password field
                    InputFieldCustom(
                      controller: passwordController,
                      hintText: "Password",
                      hide: true,
                    ),
                    const SizedBox(height: 5),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: Color(0xFF444444),
                                decoration: TextDecoration.underline,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    LargeButtonCustom(
                      onTap: signIn,
                      btnText: "Sign In",
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style:
                              TextStyle(color: Color(0xff4E4E4E), fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Register.",
                            style: TextStyle(
                                color: Color(0xFFA41723),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 100),
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
