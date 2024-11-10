import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String userId; // Pass the user ID to identify the user for password update

  const UpdatePasswordPage({super.key, required this.userId});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _passwordError;
  bool _isLoading = false;

  String? _validatePasswords() {
    if (_newPasswordController.text.isEmpty) {
      return 'Password is required';
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _updatePassword() async {
    setState(() {
      _passwordError = _validatePasswords();
    });

    if (_passwordError != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update the password in the Firestore database
      // Assuming you have a "accounts" collection with the user documents
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(widget.userId)
          .update({
        'password': _newPasswordController.text, // Update the password field
      });

      // After updating, navigate back to the login page or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password successfully updated!')),
      );

      Navigator.pop(context); // Go back to the login page
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update password. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 3, 6, 93), Color.fromARGB(255, 99, 239, 232)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Icon
                    const Icon(
                      Icons.lock_reset,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),

                    // Title Text
                    const Text(
                      "Update Your Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // New Password Input Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          errorText: _passwordError,
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
                        ),
                      ),
                    ),

                    // Confirm Password Input Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          errorText: _passwordError,
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
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Update Password Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updatePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 106, 245, 233),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 10,
                            ),
                            child: const Text(
                              "Update Password",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
