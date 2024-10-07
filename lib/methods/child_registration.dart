import 'package:flutter/material.dart';
import '../services/child_service.dart';

class ChildRegistrationForm extends StatefulWidget {
  final String parentId; // Add parentId as a field

  // Update constructor to require parentId
  ChildRegistrationForm({required this.parentId}); 

  @override
  _ChildRegistrationState createState() => _ChildRegistrationState();
}

class _ChildRegistrationState extends State<ChildRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime? _dateOfBirth;
  String _gender = '';
  final TextEditingController _dobController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a map for child data
      Map<String, dynamic> childData = {
        'name': _name,
        'dateOfBirth': _dateOfBirth?.toIso8601String(), // Store date as string
        'gender': _gender,
        'parentId': widget.parentId, // Use the passed parent ID
      };

      try {
        await ChildService().addChild(childData);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register a New Child')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Child Name'),
              validator: (value) => value!.isEmpty ? 'Please enter child name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) => _gender = value!,
              validator: (value) => value == null ? 'Please select a gender' : null,
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Register Child'),
            ),
          ],
        ),
      ),
     backgroundColor: Colors.white, // Set background color to white

    );
  }
}
