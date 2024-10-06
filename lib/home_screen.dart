import 'package:flutter/material.dart';
import '../methods/ChildMainPage.dart';
import '../methods/SpentAmountPage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String childId = 'sampleChildId';
    final String category = 'Food and Snacks';
    final double currentAmount = 50.0; // Example value, replace with actual amount as needed

    return Scaffold(
      appBar: AppBar(
        title: Text('KidCoin Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildMainPage(childId: childId),
                  ),
                );
              },
              child: Text('Go to Child Main Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpentAmountPage(
                      category: category,
                      currentAmount: currentAmount,
                      onSubmit: (double spentAmount) {
                        // Handle the submitted amount here
                        print("Amount spent on $category: $spentAmount");
                      },
                    ),
                  ),
                );
              },
              child: Text('Go to Spent Amount Page'),
            ),
          ],
        ),
      ),
    );
  }
}


