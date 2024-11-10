import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationPageStep2 extends StatefulWidget {
  const RegistrationPageStep2({super.key});

  @override
  RegistrationPageStep2State createState() => RegistrationPageStep2State();
}

class RegistrationPageStep2State extends State<RegistrationPageStep2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _bestFriendNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _ownQuestionController = TextEditingController();
  final TextEditingController _ownAnswerController = TextEditingController();

  String? _nameError;
  String? _motherMaidenNameError;
  String? _bestFriendNameError;
  String? _petNameError;
  String? _ownQuestionError;
  String? _ownAnswerError;

  Map<String, dynamic> saveData() {
    return {
      'name': _nameController.text,
      'motherMaidenName': _motherMaidenNameController.text,
      'bestFriendName': _bestFriendNameController.text,
      'petName': _petNameController.text,
      'ownQuestion': _ownQuestionController.text,
      'ownAnswer': _ownAnswerController.text,
    };
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(validateName);
    _motherMaidenNameController.addListener(validateMotherMaidenName);
    _bestFriendNameController.addListener(validateBestFriendName);
    _petNameController.addListener(validatePetName);
    _ownQuestionController.addListener(validateOwnQuestion);
    _ownAnswerController.addListener(validateOwnAnswer);
  }

  void validateName() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required.' : null;
    });
  }

  void validateMotherMaidenName() {
    setState(() {
      _motherMaidenNameError = _motherMaidenNameController.text.isEmpty ? "Mother’s Maiden Name is required." : null;
    });
  }

  void validateBestFriendName() {
    setState(() {
      _bestFriendNameError = _bestFriendNameController.text.isEmpty ? "Best Friend's Name is required." : null;
    });
  }

  void validatePetName() {
    setState(() {
      _petNameError = _petNameController.text.isEmpty ? "Pet Name is required." : null;
    });
  }

  void validateOwnQuestion() {
    setState(() {
      _ownQuestionError = _ownQuestionController.text.isEmpty ? "Own Question is required." : null;
    });
  }

  void validateOwnAnswer() {
    setState(() {
      _ownAnswerError = _ownAnswerController.text.isEmpty ? "Own Answer is required." : null;
    });
  }

  Widget _buildTextField(String labelText, TextEditingController controller, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
            errorText: errorText,
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
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Full Name", _nameController, _nameError),    
        _buildTextField("Mother's Maiden Name", _motherMaidenNameController, _motherMaidenNameError),
        _buildTextField("Childhood Best Friend's Name", _bestFriendNameController, _bestFriendNameError),
        _buildTextField("Childhood Pet's Name", _petNameController, _petNameError),
        _buildTextField("Your Own Question", _ownQuestionController, _ownQuestionError),
        _buildTextField("Your Own Answer", _ownAnswerController, _ownAnswerError),
      ],
    );
  }

  Widget _buildDateField(String labelText, DateTime? selectedDate, Function(BuildContext) onSelect) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GestureDetector(
        onTap: () => onSelect(context),
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
          child: Text(selectedDate != null
              ? DateFormat.yMd().format(selectedDate)
              : 'Select date',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _motherMaidenNameController.dispose();
    _bestFriendNameController.dispose();
    _petNameController.dispose();
    _ownQuestionController.dispose();
    _ownAnswerController.dispose();
    super.dispose();
  }
}
