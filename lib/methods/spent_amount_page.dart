import 'package:flutter/material.dart';

class SpentAmountPage extends StatelessWidget {
  final String category; // Category for which the amount is being specified
  final double currentAmount; // Current amount in the budget category
  final Function(double) onSubmit; // Callback to handle the submitted amount

  const SpentAmountPage({
    super.key,
    required this.category,
    required this.currentAmount,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController spendingController = TextEditingController(); // Controller for the text field

    return Scaffold(
      appBar: AppBar(
        title: Text('Specify Amount Spent on $category'), // Title includes the category
        backgroundColor: Colors.purple[300], // Lighter purple for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Amount: \$${currentAmount.toStringAsFixed(2)}', // Display current amount
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[900]), // Dark purple color
            ),
            const SizedBox(height: 20), // Space between elements
            TextField(
              controller: spendingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount Spent',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20), // Space between elements
            ElevatedButton(
              onPressed: () {
                double? spentAmount = double.tryParse(spendingController.text); // Try parsing input to double
                if (spentAmount != null && spentAmount > 0) {
                  onSubmit(spentAmount); // Call the onSubmit function with the amount
                  Navigator.of(context).pop(); // Close the current page
                } else {
                  // Show error message if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]!), // Lighter purple for button
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
    );
  }
}
