import 'package:flutter/material.dart';
import 'budget.dart'; // Import the Budget and BudgetManager together
import 'spent_amount_page.dart'; // Import the SpentAmountPage

class ChildMainPage extends StatefulWidget {
  final String childId; // Identifier for the child

  // Constructor to initialize childId
  const ChildMainPage({super.key, required this.childId});

  @override
  _ChildMainPageState createState() => _ChildMainPageState();
}

class _ChildMainPageState extends State<ChildMainPage> {
  late BudgetManager budgetManager; // Budget manager instance
  Budget? budget; // Budget for the child, initially null

  @override
  void initState() {
    super.initState();
    budgetManager = BudgetManager(); // Create an instance of BudgetManager
    _loadBudget(); // Load the child's budget
  }

  // Asynchronously load budget data
  Future<void> _loadBudget() async {
    Budget fetchedBudget = budgetManager.getBudgetByChildId(widget.childId); // Update to synchronous fetch
    setState(() {
      budget = fetchedBudget; // Update state with the fetched budget
    });
  }

  // Method to handle spending input
  void _navigateToSpentAmount(String category, double currentAmount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpentAmountPage(
          category: category,
          currentAmount: currentAmount,
          onSubmit: (double spentAmount) {
            _updateSpentAmount(category, spentAmount); // Update the spent amount
          },
        ),
      ),
    );
  }

  // Method to update the spent amount and recalculate
  void _updateSpentAmount(String category, double spentAmount) {
    setState(() {
      switch (category) {
        case 'Food & Snacks':
          if (budget != null) budget!.foodAndSnacks -= spentAmount;
          break;
        case 'Needs':
          if (budget != null) budget!.needs -= spentAmount;
          break;
        case 'Entertainment':
          if (budget != null) budget!.entertainment -= spentAmount;
          break;
        case 'Savings':
          if (budget != null) budget!.savings -= spentAmount;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (budget == null) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator while budget is being fetched
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${widget.childId}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // Bold and white text
        ),
        backgroundColor: Colors.purple[300], // Light purple color for the app bar
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Total Budget Display
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Your Total Budget',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A148C)), // Purple color
                  ),
                  Text(
                    '\$${budget!.totalBudget.toStringAsFixed(2)}', // Display total budget
                    style: const TextStyle(fontSize: 28, color: Color(0xFF4A148C)), // Purple color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Space between total and categories

            // Budget Categories Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildBudgetCategory('Food & Snacks', budget!.foodAndSnacks),
                buildBudgetCategory('Needs', budget!.needs),
                buildBudgetCategory('Entertainment', budget!.entertainment),
                buildBudgetCategory('Savings', budget!.savings),
              ],
            ),
            const SizedBox(height: 20), // Space for future content
            const Expanded(
              child: Center(
                child: Text(
                  'This area will be used for future features (Games, etc.)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each budget category
  Widget buildBudgetCategory(String title, double amount) {
    return GestureDetector(
      onTap: () => _navigateToSpentAmount(title, amount), // Navigate to the spent amount page
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFE1BEE7), // Light purple background for the icon
            child: const Icon(Icons.category, size: 40, color: Color(0xFF4A148C)), // Purple icon color
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A148C))), // Purple title color
          Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF4A148C))), // Purple amount color
        ],
      ),
    );
  }
}
