// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class StepperDemo extends StatefulWidget {
  const StepperDemo({super.key});

  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  bool _isObscure = true;

  final Key _k1 = GlobalKey();
  final Key _k2 = GlobalKey();

  String selectedValue = "Student";
  int _currentStep = 0;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _studentController = TextEditingController();

  final _nameController = TextEditingController();
  final inputController = StreamController<String>();

  StepperType stepperType = StepperType.vertical;

  String generateId() {
    var random = Random();
    return random.nextInt(999999999).toString();
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      message_sign();
      details(
        _studentController.text.trim(),
        _nameController.text.trim(),
        selectedValue.trim(),
        _emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      (e);
      message_error();
    }
  }

  Future message_sign() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "SUCCESS !",
            style: TextStyle(color: Colors.green, fontFamily: "NexaBold"),
          ),
          content: const Text(
            'new account created',
            style: TextStyle(color: Colors.black, fontFamily: "NexaRegular"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future details(
    String student,
    String name,
    String selectedValue,
    String email,
  ) async {
    await FirebaseFirestore.instance.collection('Users').doc(email).set({
      'card': student,
      'name': name,
      'role': selectedValue,
      'email': email,
    });
  }

  Future message_error() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "INVALID",
            style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
          ),
          content: const Text(
            'Account already taken',
            style: TextStyle(color: Colors.black, fontFamily: "NexaRegular"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                Step(
                  title: const Text('Account'),
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        key: _k1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        decoration:
                            const InputDecoration(labelText: 'Email Address'),
                      ),
                      TextFormField(
                        controller: _passController,
                        key: _k2,
                        obscureText: _isObscure,
                        enableSuggestions: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Minimum of 6 characters'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Details'),
                  content: Column(
                    children: <Widget>[
                      DropdownButtonFormField(
                        value: selectedValue,
                        // ignore: prefer_const_literals_to_create_immutables
                        items: [
                          //add items in the dropdown
                          const DropdownMenuItem(
                            value: "Student",
                            child: Text("Student"),
                          ),
                          const DropdownMenuItem(
                              value: "Admin", child: Text("Admin")),
                          const DropdownMenuItem(
                            value: "Establishment",
                            child: Text("Establishment"),
                          )
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                            inputController.add(newValue);
                            _studentController.clear();
                            _nameController.clear();
                          });
                        },
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: _studentController,
                        decoration: InputDecoration(
                          labelText: selectedValue == 'Establishment'
                              ? 'Location'
                              : 'ID',
                          suffixIcon: selectedValue == 'Establishment'
                              ? IconButton(
                                  icon: const Icon(Icons.location_pin),
                                  onPressed: () {
                                    String id = generateId();
                                    _studentController.text = id;
                                  })
                              : IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () {
                                    String id = generateId();
                                    _studentController.text = id;
                                  }),
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: Text(_currentStep == 2 ? "Confirm" : "Pending"),
                  content: Column(),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchStepsType,
        child: const Icon(Icons.list),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    FocusScope.of(context).unfocus();
    String student = _studentController.text.trim();
    String name = _nameController.text.trim();
    // String role = selectedValue.trim();
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    if (name.isEmpty && _currentStep == 1) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Name !"),
          // backgroundColor: Colors.teal,
          duration: Duration(milliseconds: 500),
        ),
      );
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.info(
      //     message: "Please Enter Name",
      //   ),
      // );
    } else if (student.isEmpty && _currentStep == 1) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Data !"),
          duration: Duration(milliseconds: 500),
        ),
      );
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.info(
      //     message: "Input required data",
      //   ),
      // );
    } else if (email.isEmpty && _currentStep == 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Email !"),
          // backgroundColor: Colors.teal,
          duration: Duration(milliseconds: 500),
        ),
      );
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.info(
      //     message: "Please Enter Email",
      //   ),
      // );
    } else if (password.isEmpty && _currentStep == 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Password !"),
          // backgroundColor: Colors.teal,
          duration: Duration(milliseconds: 500),
        ),
      );
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.info(
      //     message: "Please Enter Password",
      //   ),
      // );
    } else if (_currentStep == 2) {
      signUp();
    } else {
      _currentStep < 2 ? setState(() => _currentStep += 1) : null;
    }
  }

  cancel() {
    _currentStep > 0
        ? setState(() => _currentStep -= 1)
        : _currentStep == 0
            ? Navigator.of(context).pop(false)
            : null;
  }
}
