import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/child_service.dart';
import '../methods/id_generator.dart';

class ChildRegistrationForm extends StatefulWidget {
  const ChildRegistrationForm({super.key});

  @override
  _ChildRegistrationFormState createState() => _ChildRegistrationFormState();
}

class _ChildRegistrationFormState extends State<ChildRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  DateTime? _dateOfBirth;
  String? _gender;

  final TextEditingController _dobController = TextEditingController();
  final List<String> _genders = ['Male', 'Female'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a unique ID for the child using IdGenerator
      String childId = IdGenerator.generateId();

      // Create a map for child data including the generated ID
      Map<String, dynamic> childData = {
        'name': _name,
        'dateOfBirth': _dateOfBirth,
        'gender': _gender,
        'id': childId,
      };

      try {
        await ChildService().addChild(childId, childData);
        // Show success dialog or message if needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Child registered successfully!')),
        );
      } catch (e) {
        print('Failed to add child: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register child: $e')),
        );
      }
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dobController.text = "${_dateOfBirth!.toLocal()}".split(' ')[0];
      });
    }
  }

  // Registering a New Child

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registering a New Child',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // White bold text
        ),
        backgroundColor: Colors.purple[300], // Lighter purple for the AppBar
      ),
      body: Container( // Set background to white
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Child\'s Name',
                  labelStyle: const TextStyle(color: Color(0xFF4A148C)), // Dark purple
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the child\'s name';
                  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name must contain only alphabets';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: const TextStyle(color: Color(0xFF4A148C)), // Dark purple
                  suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF4A148C)), // Dark purple
                ),
                readOnly: true,
                onTap: () => _pickDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: const TextStyle(color: Color(0xFF4A148C)), // Dark purple
                ),
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender, style: const TextStyle(color: Color(0xFF4A148C))), // Dark purple
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[300]!), // Medium purple
                ),
                child: const Text('Register Child', style: TextStyle(color: Colors.white)), // White text color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
