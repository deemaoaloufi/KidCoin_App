import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatting
import 'package:kidcoin_app/firebase_options.dart';
import 'dart:math'; // Importing for random number generation
import 'dart:collection'; // For managing the set of unique IDs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChildRegistrationForm(), // Directly show the registration form
    );
  }
}

class ChildRegistrationForm extends StatefulWidget {
  const ChildRegistrationForm({super.key}); // Added Key

  @override
  // ignore: library_private_types_in_public_api
  _ChildRegistrationFormState createState() => _ChildRegistrationFormState();
}

class _ChildRegistrationFormState extends State<ChildRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  DateTime? _dateOfBirth;
  String? _gender;
  TextEditingController _dobController = TextEditingController();
  int? _age;

  final List<String> _genders = ['Male', 'Female'];
  final Set<String> _registeredIds = HashSet(); // Store registered unique IDs

  // Function to generate a unique ID
  String _generateUniqueId(String name) {
    final random = Random().nextInt(1000); // Random number for extra uniqueness
    DateTime.now().millisecondsSinceEpoch.toString();
    // ignore: prefer_typing_uninitialized_variables
    var timestamp_;
    return '${name.toLowerCase().replaceAll(' ', '_')}_$timestamp_$random';
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a unique ID for the child
      String uniqueId = _generateUniqueId(_name!);

      // Check if the ID is already registered
      if (_registeredIds.contains(uniqueId)) {
        _showIdExistsError();
        return;
      }

      // Register the child by adding the unique ID
      _registeredIds.add(uniqueId);

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Child Registered'),
          content: Text(
            'Unique ID: $uniqueId\nName: $_name\nDate of Birth: ${_dobController.text}\nGender: $_gender\nAge: $_age years',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
      final int age = _calculateAge(picked);
      if (age < 9 || age > 14) {
        _showAgeError();
      } else {
        setState(() {
          _dateOfBirth = picked;
          _age = age;
          _dobController.text = "${_dateOfBirth!.toLocal()}".split(' ')[0];
        });
      }
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showAgeError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Age Error'),
        content: const Text('The child must be between 9 and 14 years old.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showIdExistsError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ID Error'),
        content: const Text('The generated ID already exists. Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
