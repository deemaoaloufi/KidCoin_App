import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/child_service.dart'; // Assuming the service exists for Firestore interactions

class ChildRegistrationForm extends StatefulWidget {
  final String parentId;

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
  bool _isLoading = false;
  String? _editingChildId;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> childData = {
        'name': _name,
        'dateOfBirth': _dateOfBirth?.toIso8601String(),
        'gender': _gender,
        'parentId': widget.parentId,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        if (_editingChildId == null) {
          await ChildService().addChild(childData);
        } else {
          await ChildService().updateChild(_editingChildId!, childData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Child saved successfully!')),
        );

        _formKey.currentState!.reset();
        _dobController.clear();
        _editingChildId = null;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save child: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
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

  void _populateFormForEdit(DocumentSnapshot doc) {
    setState(() {
      _name = doc['name'];
      _dateOfBirth = DateTime.parse(doc['dateOfBirth']);
      _dobController.text = _dateOfBirth!.toIso8601String().split('T')[0];
      _gender = doc['gender'];
      _editingChildId = doc.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register and Manage Children',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(labelText: 'Child Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter child name' : null,
                    onSaved: (value) => _name = value!,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                    ],
                  ),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    validator: (value) =>
                        _dateOfBirth == null ? 'Please select a date of birth' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _gender.isEmpty ? null : _gender,
                    decoration: InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _gender = value!;
                    }),
                    validator: (value) =>
                        value == null ? 'Please select a gender' : null,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(_editingChildId == null
                              ? 'Register Child'
                              : 'Update Child'),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('children')
                    .where('parentId', isEqualTo: widget.parentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No children registered.'));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['name']),
                        subtitle: Text(
                            "Child ID: ${doc['childId']} | DOB: ${doc['dateOfBirth']} | Gender: ${doc['gender']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _populateFormForEdit(doc);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await ChildService().deleteChild(doc.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Child deleted')),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
