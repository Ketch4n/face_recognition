import 'package:face_recognition/auth/stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widget/logo.dart';
import '../widget/willpopscope.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // backpressed
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return const WillPop();
            });
        return value == true;
      },
      // unfocus
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueGrey, Colors.white])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SizedBox(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/images/face.png',
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Attendance",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "NexaBold",
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: _emailController,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: textdesign.copyWith(hintText: "Email"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          obscureText: _isObscure,
                          enableSuggestions: false,
                          controller: _passController,
                          decoration: textdesign.copyWith(
                            hintText: "Password",
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: signUp,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 40),
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: Colors.blue[600], fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            String email = _emailController.text.trim();
                            String password = _passController.text.trim();

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Enter Email !"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else if (password.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Enter Password !"),
                                  // backgroundColor: Colors.teal,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              // showTopSnackBar(
                              //   context,
                              //   CustomSnackBar.info(
                              //     message: "Enter Password",
                              //   ),
                              // );
                            } else {
                              signIn();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                              child: Text(
                                'LOG IN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "NexaBold",
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: Colors.grey[400]),
                          ),
                          Text(
                            "sign in with",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Logo(imagePath: 'assets/images/google.png'),
                          SizedBox(
                            width: 10,
                          ),
                          Logo(imagePath: 'assets/images/fb.png'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "create new account? ",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: signUp,
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.blue[600], fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sign Up
  Future signUp() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StepperDemo()),
    );
  }

// Firebase Login
  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      (e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email or Password incorrect "),
          duration: Duration(seconds: 2),
        ),
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

// Textfield Decoration
  final textdesign = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.green),
      borderRadius: BorderRadius.circular(12),
    ),
    fillColor: Colors.grey[200],
    filled: true,
  );
}
