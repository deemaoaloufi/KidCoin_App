import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget.dart';

class ChildProgressScreen extends StatefulWidget {
  final String childId;

  const ChildProgressScreen({Key? key, required this.childId})
      : super(key: key);

  @override
  _ChildProgressScreenState createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen> {
  Budget? budget;
  bool _isLoading = true;
  String? childName;

  @override
  void initState() {
    super.initState();
    _fetchChildData();
  }

  Future<void> _fetchChildData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          childName = data['name'];
          budget = Budget(widget.childId)
            ..totalRemaining = data['budget']?.toDouble() ?? 0.0
            ..setMood(data['mood'] ?? 'Captain Balanced');
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching child data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get savedAmount => budget?.savings ?? 0.0;

  Widget _buildBudgetDetail(String category, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text("\$${amount.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            childName != null ? "$childName's Progress" : "Child Progress"),
        backgroundColor: Colors.purple[300],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Remaining Budget: \$${budget?.totalRemaining.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Amount Saved: \$${savedAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Budget Breakdown:",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _buildBudgetDetail("Food & Snacks",
                            budget?.foodAndSnacks ?? 0, Colors.pinkAccent),
                        _buildBudgetDetail("Entertainment",
                            budget?.entertainment ?? 0, Colors.blueAccent),
                        _buildBudgetDetail(
                            "Needs", budget?.needs ?? 0, Colors.greenAccent),
                        _buildBudgetDetail("Savings", budget?.savings ?? 0,
                            Colors.orangeAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
