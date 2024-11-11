import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:biomark/pages/login_page.dart';

class RecoveryPage extends StatefulWidget {
  final String? id;
  const RecoveryPage({super.key, this.id});

  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _bestFriendNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _customQuestionController = TextEditingController();
  final TextEditingController _customAnswerController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  DateTime? _selectedDOB;

  void _nextStep() {
    setState(() {
      _errorMessage = null;
    });

    if (_currentStep == 0) {
      if (_validateStep1()) {
        _submitRecoveryInfo();
      }
    } else if (_currentStep == 1) {
      if (_validateNewPassword()) {
        _resetPassword();
      }
    }
  }

  bool _validateStep1() {
    if (_nameController.text.isEmpty) {
      _showError('Name is required.');
      return false;
    }

    if (_selectedDOB == null) {
      _showError('Date of Birth is required.');
      return false;
    }

    return true;
  }

  bool _validateNewPassword() {
    if (_newPasswordController.text.isEmpty) {
      _showError('New password is required.');
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match.');
      return false;
    }

    return true;
  }

  void _submitRecoveryInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('recovery')
          .where('name', isEqualTo: _hashData(_nameController.text))
          .where('dob', isEqualTo: _hashData(DateFormat('yyyy-MM-dd').format(_selectedDOB!)))
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _showError('No user found with the provided information.');
        return;
      }

      final recoveryData = query.docs.first;

      final hashedAnswers = {
        'motherMaidenName': _hashData(_motherMaidenNameController.text),
        'bestFriendName': _hashData(_bestFriendNameController.text),
        'petName': _hashData(_petNameController.text),
        'ownAnswer': _hashData(_customAnswerController.text),
      };

      int correctAnswers = 0;
      for (var key in hashedAnswers.keys) {
        if (recoveryData[key] == hashedAnswers[key]) {
          correctAnswers++;
        }
      }

      if (correctAnswers >= 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        _showError('At least two recovery answers must match our records.');
      }
    } catch (e) {
      _showError('An error occurred during recovery. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(widget.id)  // Use widget.id
          .get();

      if (query.exists) {
        print('User found with id: ${widget.id}');
        await query.reference.update({
          'password': _hashData(_newPasswordController.text),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Password reset successfully!',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3)
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _showError('No user found with the provided id.');
      }
    } catch (e) {
      _showError('An error occurred while resetting the password.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDOB) {
      setState(() {
        _selectedDOB = picked;
      });
    }
  }

  Widget _buildDateField(String labelText) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
          child: Text(
            _selectedDOB != null
                ? DateFormat.yMd().format(_selectedDOB!)
                : 'Select date',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Icon
                          const Icon(
                            Icons.restore,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 30),

                          // Title Text
                          const Text(
                            'Account Recovery',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                            
                          if (_currentStep == 0) ...[
                            _buildTextField('Full Name', _nameController),
                            _buildDateField('Date of Birth'),

                            // Instruction Text
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                'Answer at least two of the questions below:',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),

                            _buildTextField('Mother\'s Maiden Name', _motherMaidenNameController),
                            _buildTextField('Best Friend\'s Name', _bestFriendNameController),
                            _buildTextField('Pet\'s Name', _petNameController),
                            _buildTextField('Custom Question', _customQuestionController),
                            _buildTextField('Custom Answer', _customAnswerController),
                          ]else if (_currentStep == 1) ...[
                            _buildTextField('New Password', _newPasswordController, obscureText: true),
                            _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
                          ],
                          
                          const SizedBox(height: 20),
                          
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 106, 245, 233),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 10,
                            ),
                            child: Text(
                              _currentStep == 1 ? 'Reset Password' : 'Next',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Back to Login Link
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Back to Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
}
