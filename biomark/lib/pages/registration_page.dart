import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:biomark/pages/registration_step1_page.dart';
import 'package:biomark/pages/registration_step2_page.dart';
import 'package:biomark/pages/registration_step3_page.dart';
import 'package:biomark/pages/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _currentStep = 0;

  Map<String, dynamic> model = {};
  Map<String, dynamic> recovery = {};
  Map<String, dynamic> account = {};

  void _nextStep() {
    if (_currentStep == 0) {
      final step1State = _getStep1State();
      if (step1State != null) {
        setState(() {
          model = step1State;
        });
      }
    } else if (_currentStep == 1) {
      final step2State = _getStep2State();
      if (step2State != null) {
        setState(() {
          recovery = step2State;
        });
      }
    } else if (_currentStep == 2) {
      final step3State = _getStep3State();
      if (step3State != null) {
        setState(() {
          account = step3State;
        });
        _submitForm();
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Map<String, dynamic>? _getStep1State() {
    final step1Form = _step1Key.currentState;
    if (step1Form != null) {
      return step1Form.saveData();
    }
    return null;
  }

  Map<String, dynamic>? _getStep2State() {
    final step2Form = _step2Key.currentState;
    if (step2Form != null) {
      return step2Form.saveData();
    }
    return null;
  }

  Map<String, dynamic>? _getStep3State() {
    final step3Form = _step3Key.currentState;
    if (step3Form != null) {
      return step3Form.saveData();
    }
    return null;
  }

void _submitForm() async {
  print('Submitting form...');

  // Convert DateTime and TimeOfDay fields to Firestore-compatible strings
  model = _convertTimeOfDayToString(model);
  recovery = _convertTimeOfDayToString(recovery);
  account = _convertTimeOfDayToString(account);

  if (_validateForm(model, 'Model') && _validateForm(recovery, 'Recovery') && _validateForm(account, 'Account')) {
    if (account['password'] != null) {
      final hashedPassword = _hashData(account['password']);
      account['password'] = hashedPassword;
    }

    recovery = recovery.map((key, value) {
      if (value != null) {
        return MapEntry(key, _hashData(value));
      }
      return MapEntry(key, value);
    });

    try {
      DocumentReference accountRef = await FirebaseFirestore.instance.collection('accounts').add(account);

      String accountId = accountRef.id;

      await FirebaseFirestore.instance.collection('models').add({
        'accountId': accountId,
        ...model,
      });

      await FirebaseFirestore.instance.collection('recovery').add({
        'accountId': accountId,
        ...recovery,
      });

      print('User registered successfully!');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User Registered Successfully!',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3)
        ),
      );

      setState(() {
        model = {};
        recovery = {};
        account = {};
        _currentStep = 0;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      print('Failed to register user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to register user: $error',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3)
        ),
      );
    }
  } else {
    print("Validation failed.");
  }
}

// Utility function to convert TimeOfDay to string in a map
Map<String, dynamic> _convertTimeOfDayToString(Map<String, dynamic> data) {
  data = data.map((key, value) {
    if (value is TimeOfDay) {
      return MapEntry(key, "${value.hour}:${value.minute}");
    }
    return MapEntry(key, value);
  });
  return data;
}



  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _validateForm(Map<String, dynamic> formData, String formName) {
    for (var entry in formData.entries) {
      if (entry.value == null || (entry.value is String && entry.value.isEmpty)) {
        print('$formName field "${entry.key}" is required.');
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 3, 6, 93),
                  Color.fromARGB(255, 99, 239, 232)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Icon
                    const Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 25),

                    // Title Text
                    const Text(
                      "Create an Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    if (_currentStep == 0) RegistrationPageStep1(key: _step1Key),
                    if (_currentStep == 1) RegistrationPageStep2(key: _step2Key),
                    if (_currentStep == 2) RegistrationPageStep3(key: _step3Key),

                    // Navigation Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentStep > 0)
                            ElevatedButton(
                              onPressed: _previousStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: Colors.black.withOpacity(0.5),
                                elevation: 10,
                              ),
                              child: const Text(
                                "Previous",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 20),

                          // Continue Button
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 106, 245, 233),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 10,
                            ),
                            child: Text(
                              _currentStep == 2 ? "Finish" : "Continue",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey<RegistrationPageStep1State> _step1Key = GlobalKey<RegistrationPageStep1State>();
  final GlobalKey<RegistrationPageStep2State> _step2Key = GlobalKey<RegistrationPageStep2State>();
  final GlobalKey<RegistrationPageStep3State> _step3Key = GlobalKey<RegistrationPageStep3State>();
}
