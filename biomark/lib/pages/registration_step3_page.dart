import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationPageStep3 extends StatefulWidget {
  const RegistrationPageStep3({super.key});

  @override
  RegistrationPageStep3State createState() => RegistrationPageStep3State();
}

class RegistrationPageStep3State extends State<RegistrationPageStep3> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _eyeColorController = TextEditingController();

  String? _locationError;
  String? _bloodGroupError;
  String? _sexError;
  String? _heightError;
  String? _ethnicityError;
  String? _eyeColorError;

  Map<String, dynamic> saveData() {
    return {
      'dateOfBirth': _selectedDate,
      'timeOfBirth': _selectedTime,
      'locationOfBirth': _locationController.text,
      'bloodGroup': _bloodGroupController.text,
      'sex': _sexController.text,
      'height': _heightController.text,
      'ethnicity': _ethnicityController.text,
      'eyeColor': _eyeColorController.text,
    };
  }

  @override
  void initState() {
    super.initState();

    _locationController.addListener(validateLocation);
    _bloodGroupController.addListener(validateBloodGroup);
    _sexController.addListener(validateSex);
    _heightController.addListener(validateHeight);
    _ethnicityController.addListener(validateEthnicity);
    _eyeColorController.addListener(validateEyeColor);
  }

  void validateLocation() {
    setState(() {
      _locationError = _locationController.text.isEmpty ? "Location of Birth is required." : null;
    });
  }

  void validateBloodGroup() {
    setState(() {
      _bloodGroupError = _bloodGroupController.text.isEmpty ? "Blood Group is required." : null;
    });
  }

  void validateSex() {
    setState(() {
      _sexError = _sexController.text.isEmpty ? "Sex is required." : null;
    });
  }

  void validateHeight() {
    setState(() {
      _heightError = _heightController.text.isEmpty ? "Height is required." : null;
    });
  }

  void validateEthnicity() {
    setState(() {
      _ethnicityError = _ethnicityController.text.isEmpty ? "Ethnicity is required." : null;
    });
  }

  void validateEyeColor() {
    setState(() {
      _eyeColorError = _eyeColorController.text.isEmpty ? "Eye Color is required." : null;
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
        _buildDateField("Date of Birth", _selectedDate, _selectDate),
        _buildTimeField("Time of Birth", _selectedTime, _selectTime),
        _buildTextField("Location of Birth", _locationController, _locationError),
        _buildTextField("Blood Group", _bloodGroupController, _bloodGroupError),
        _buildTextField("Sex", _sexController, _sexError),
        _buildTextField("Height (cm)", _heightController, _heightError),
        _buildTextField("Ethnicity", _ethnicityController, _ethnicityError),
        _buildTextField("Eye Color", _eyeColorController, _eyeColorError),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
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

  Widget _buildTimeField(String labelText, TimeOfDay? selectedTime, Function(BuildContext) onSelect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
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
          child: Text(selectedTime != null
              ? selectedTime.format(context)
              : 'Select time',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _bloodGroupController.dispose();
    _sexController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    _eyeColorController.dispose();
    super.dispose();
  }
}

