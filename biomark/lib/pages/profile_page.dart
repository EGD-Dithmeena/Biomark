import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biomark/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String id;

  const ProfilePage({super.key, required this.id});

  Future<Map<String, dynamic>> _getUserData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('models')
        .where('accountId', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> _unsubscribeUser(BuildContext context, String accountId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('models')
          .where('accountId', isEqualTo: accountId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'You have been unsubscribed.',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'User not found.',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3)
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Error: $e',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 193, 6, 6),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3)
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 3, 6, 93), Color.fromARGB(255, 99, 239, 232)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                    ),
                    Row(
                      children: [                        
                        ElevatedButton(
                          onPressed: () => _unsubscribeUser(context, id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 106, 245, 233),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text('Unsubscribe'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data found'));
                        }

                        final model = snapshot.data!;

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Welcome to your profile!',
                                style: TextStyle(fontSize: 24, color: Colors.white),
                              ),
                              const SizedBox(height: 30),

                              Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(150),
                                  1: FlexColumnWidth(),
                                },
                                border: TableBorder.all(color: Colors.white),
                                children: [        
                                  _buildTableRow('Full Name', model['fullName'] ?? 'Not provided'),    
                                  _buildTableRow('Email', model['email'] ?? 'Not provided'),                       
                                  _buildTableRow('Date of Birth', model['dateOfBirth'] ?? 'Not provided'),
                                  _buildTableRow('Time of Birth', model['timeOfBirth'] ?? 'Not provided'),
                                  _buildTableRow('Location of Birth', model['locationOfBirth'] ?? 'Not provided'),
                                  _buildTableRow('Blood Group', model['bloodGroup'] ?? 'Not provided'),
                                  _buildTableRow('Sex', model['sex'] ?? 'Not provided'),
                                  _buildTableRow('Height', model['height'] ?? 'Not provided'),
                                  _buildTableRow('Ethnicity', model['ethnicity'] ?? 'Not provided'),
                                  _buildTableRow('Eye Color', model['eyeColor'] ?? 'Not provided'),    
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
