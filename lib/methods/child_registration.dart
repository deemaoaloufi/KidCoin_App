import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/child_service.dart';
import 'reward.dart';

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
  double? _budget;
  String _mood = '';
  RewardManager rewardManager = RewardManager();
  final TextEditingController _rewardController = TextEditingController();

  final Map<String, String> moodDefinitions = {
    'Captain Saver': 'Savings= 40% \nFocuses on saving and budgeting for future needs.',
    'Captain Balanced': 'Balances spending and saving wisely.',
    'Captain Funster': 'Entertainment= 40% \nEncourages spending on fun and enjoyment.',
    'Captain Essential': 'Needs= 40% \nPrioritizes essential needs and expenses.',
    'Captain Foodie': 'Food & Snack= 40% \nEncourages spending on food and snacks.',
  };

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (rewardManager.rewards.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one reward before submitting.')),
        );
        return;
      }

      Map<String, dynamic> childData = {
        'name': _name,
        'dateOfBirth': _dateOfBirth?.toIso8601String(),
        'gender': _gender,
        'budget': _budget,
        'mood': _mood,
        'parentId': widget.parentId,
        'rewards': rewardManager.rewards,
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
        rewardManager = RewardManager();
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
      _budget = doc['budget'] != null ? doc['budget'].toDouble() : null;
      final data = doc.data() as Map<String, dynamic>?;

      _mood = data != null && data.containsKey('mood') ? data['mood'] : '';
      _editingChildId = doc.id;

      rewardManager = RewardManager();
      if (data != null && data.containsKey('rewards')) {
        for (var reward in data['rewards']) {
          rewardManager.addReward(reward);
        }
      }
    });
  }

  Widget _buildRewardBox(String reward) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade400, blurRadius: 3, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(reward, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                rewardManager.removeReward(reward);
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register and Manage Children',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      validator: (value) => value!.isEmpty ? 'Please enter child name' : null,
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
                      validator: (value) => _dateOfBirth == null
                          ? 'Please select a date of birth'
                          : null,
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
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Budget'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d{0,2})?$')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a budget';
                        }
                        final budget = double.tryParse(value);
                        if (budget == null || budget <= 0) {
                          return 'Please enter a valid budget';
                        }
                        return null;
                      },
                      onSaved: (value) => _budget = double.parse(value!),
                    ),
                    DropdownButtonFormField<String>(
                      value: _mood.isEmpty ? null : _mood,
                      decoration: InputDecoration(labelText: 'Mood'),
                      items: moodDefinitions.keys
                          .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _mood = value;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(value),
                                content: Text(moodDefinitions[value]!),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Please select a mood' : null,
                    ),
                    TextField(
                      controller: _rewardController,
                      decoration: InputDecoration(
                        labelText: 'Add Reward',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add, color: Colors.purple),
                          onPressed: () {
                            if (_rewardController.text.isNotEmpty) {
                              setState(() {
                                rewardManager.addReward(_rewardController.text);
                                _rewardController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...rewardManager.rewards.map(_buildRewardBox).toList(),
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
              StreamBuilder<QuerySnapshot>(
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
                    shrinkWrap: true, // Added this to avoid infinite height
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['name']),
                        subtitle: Text(
                            "Child ID: ${doc['childId']} | DOB: ${doc['dateOfBirth']} | Gender: ${doc['gender']} | Budget: \$${doc['budget'] ?? 'N/A'} | Mood: ${doc['mood'] ?? 'N/A'}"),
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
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
