import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget.dart'; // Import the Budget class
import 'tip.dart'; // Import the Tip class

class ChildMainPage extends StatefulWidget {
  final String childId; // Identifier for the child

  const ChildMainPage({Key? key, required this.childId}) : super(key: key);

  @override
  _ChildMainPageState createState() => _ChildMainPageState();
}

class _ChildMainPageState extends State<ChildMainPage> {
  Budget? budget;
  Tip? tip; // Instance to handle tips
  String? childName; // To store and display the child's name
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Fetch child data from Firestore and initialize budget
  Future<void> _initializeData() async {
    try {
      // Retrieve the document by childId
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (doc.exists) {
        setState(() {
          // Retrieve child’s name, total budget, and mood
          childName = doc['name'];
          double totalBudget = doc['budget']?.toDouble() ?? 0.0;
          String childMood = doc['mood'] ?? 'Captain Balanced';

          // Initialize the Budget object and set the mood
          budget = Budget(widget.childId)
            ..totalRemaining = totalBudget
            ..setMood(childMood); // This will divide the budget based on mood

          // Initialize the Tip object to generate tips based on mood
          tip = Tip(childMood);

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

  // Method to prompt for spending input and update the budget
  void _addSpending(String category) async {
    double? amount = await _showSpendingDialog(category);

    if (amount != null && budget != null) {
      // Try to add spending and get any error message
      String? error = budget!.addSpending(category, amount);

      if (error != null) {
        // Show error message if there's an issue with the spending amount
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      } else {
        // No error, so update the UI to reflect the new budget values
        setState(() {});
      }
    }
  }

  // Helper to display a dialog to enter spending amount
  Future<double?> _showSpendingDialog(String category) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter spending for $category'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.purple, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? amount = double.tryParse(controller.text);
                Navigator.of(context).pop(amount);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Helper widget to build each budget category with spending entry
  Widget _buildBudgetCategory(String title, double amount, Color color, IconData icon) {
    String tipText = tip?.displayTip(title, budget!) ?? ''; // Get the tip for this category

    return GestureDetector(
      onTap: () => _addSpending(title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(color: color),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                tipText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? 'Loading...' : 'Welcome, $childName'),
        backgroundColor: Colors.purple[300],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display total budget
                  Text(
                    "Total Budget: \$${budget?.totalRemaining.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                      children: [
                        _buildBudgetCategory(
                            "Food & Snacks",
                            budget?.foodAndSnacks ?? 0,
                            Colors.pinkAccent,
                            Icons.fastfood),
                        _buildBudgetCategory(
                            "Entertainment",
                            budget?.entertainment ?? 0,
                            Colors.blueAccent,
                            Icons.videogame_asset),
                        _buildBudgetCategory(
                            "Needs",
                            budget?.needs ?? 0,
                            Colors.greenAccent,
                            Icons.shopping_basket),
                        _buildBudgetCategory(
                            "Savings",
                            budget?.savings ?? 0,
                            Colors.orangeAccent,
                            Icons.savings),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}