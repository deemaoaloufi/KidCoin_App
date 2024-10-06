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
      } catch (e) {
        print('Failed to add child: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registering a New Child'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Child\'s Name'),
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
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
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
                decoration: const InputDecoration(labelText: 'Gender'),
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
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
                child: const Text('Register Child'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}