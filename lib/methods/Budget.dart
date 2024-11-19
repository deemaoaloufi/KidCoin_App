import 'package:cloud_firestore/cloud_firestore.dart'; //  this import for Firestore to update the changes!

class Budget {
  String childId; // Identifier for the child
  double foodAndSnacks; // Budget for food and snacks
  double entertainment; // Budget for entertainment
  double needs; // Budget for needs
  double savings; // Budget for savings
  double totalRemaining; // Total remaining budget
  String mood;

  // Constructor initializing budgets
  Budget(this.childId)
      : foodAndSnacks = 0.0,
        entertainment = 0.0,
        needs = 0.0,
        savings = 0.0,
        totalRemaining = 0.0,
        mood = "";

  // Method to add spending in a specified category
  Future<String?> addSpending(String category, double amount) async {
    if (amount < 0) {
      return 'Amount can not be negative'; // Error for zero or negative values
    }

    if (amount == 0) {
      return 'No spending amount entered'; // Error for zero or negative values
    }

    // calling the method to Initialize budget categories
    await _initializeBudgetIfNeeded();

    switch (category) {
      case 'Food & Snacks':
        if (amount > foodAndSnacks) {
          return 'Insufficient funds in Food & Snacks category.'; // Error if amount exceeds category balance
        }
        foodAndSnacks -= amount;
        break;

      case 'Entertainment':
        if (amount > entertainment) {
          return 'Insufficient funds in Entertainment category.'; // Error if amount exceeds category balance
        }
        entertainment -= amount;
        break;

      case 'Needs':
        if (amount > needs) {
          return 'Insufficient funds in Needs category.'; // Error if amount exceeds category balance
        }
        needs -= amount;
        break;

      case 'Savings':
        if (amount > savings) {
          return 'Insufficient funds in Savings category.'; // Error if amount exceeds category balance
        }
        savings -= amount;
        break;

      default:
        return 'Invalid category selected.';
    }

    // Update total remaining budget
    totalRemaining = calculatedTotalBudget;

    // Save the updated budget to Firebase
    FirebaseFirestore.instance.collection('children').doc(childId).update({
      'foodAndSnacks': foodAndSnacks,
      'entertainment': entertainment,
      'needs': needs,
      'savings': savings,
      'totalRemaining': totalRemaining,
    }).then((_) {
      print("Budget updated in Firestore");
    }).catchError((error) {
      print("Failed to update budget: $error");
    });

    return null; // No error
  }

  //  method to initialize the budget fields in Firestore
  Future<void> _initializeBudgetIfNeeded() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('children')
        .doc(childId)
        .get();

    if (!doc.exists) {
      // If the child document doesn't exist, create it with default budget values
      await FirebaseFirestore.instance.collection('children').doc(childId).set({
        'foodAndSnacks': 0.0,
        'entertainment': 0.0,
        'needs': 0.0,
        'savings': 0.0,
        'totalRemaining': 0.0,
      }).then((_) {
        print("New child budget initialized in Firestore");
      }).catchError((error) {
        print("Failed to initialize child budget: $error");
      });
    } else {
      // If the child document exists, load the existing values
      foodAndSnacks = doc.get('foodAndSnacks') ?? 0.0;
      entertainment = doc.get('entertainment') ?? 0.0;
      needs = doc.get('needs') ?? 0.0;
      savings = doc.get('savings') ?? 0.0;
      totalRemaining = doc.get('totalRemaining') ?? 0.0;
    }
  }

  // Getter to calculate the remaining total budget
  double get calculatedTotalBudget {
    return foodAndSnacks + entertainment + needs + savings;
  }

  // Set the mood and distribute the budget according to the chosen mood
  void setMood(String newMood) {
    mood = newMood;
    switch (mood) {
      case 'Captain Foodie':
        foodPercentage();
        break;
      case 'Captain Funster':
        entertainmentPercentage();
        break;
      case 'Captain Essential':
        needsPercentage();
        break;
      case 'Captain Saver':
        savePercentage();
        break;
      case 'Captain Balanced':
        balancePercentage();
        break;
    }
    // Update total remaining budget after distribution
    totalRemaining = calculatedTotalBudget;
  }

  // Assign budget percentages for each category based on "Captain Foodie" mood
  void foodPercentage() {
    foodAndSnacks = totalRemaining * 0.40;
    entertainment = totalRemaining * 0.20;
    needs = totalRemaining * 0.20;
    savings = totalRemaining * 0.20;
  }

  // Assign budget percentages for each category based on "Captain Funster" mood
  void entertainmentPercentage() {
    foodAndSnacks = totalRemaining * 0.20;
    entertainment = totalRemaining * 0.40;
    needs = totalRemaining * 0.20;
    savings = totalRemaining * 0.20;
  }

  // Assign budget percentages for each category based on "Captain Essential" mood
  void needsPercentage() {
    foodAndSnacks = totalRemaining * 0.20;
    entertainment = totalRemaining * 0.20;
    needs = totalRemaining * 0.40;
    savings = totalRemaining * 0.20;
  }

  // Assign budget percentages for each category based on "Captain Saver" mood
  void savePercentage() {
    foodAndSnacks = totalRemaining * 0.20;
    entertainment = totalRemaining * 0.20;
    needs = totalRemaining * 0.20;
    savings = totalRemaining * 0.40;
  }

  // Assign balanced budget percentages for each category based on "Captain Balanced" mood
  void balancePercentage() {
    foodAndSnacks = totalRemaining * 0.25;
    entertainment = totalRemaining * 0.25;
    needs = totalRemaining * 0.25;
    savings = totalRemaining * 0.25;
  }

  @override
  String toString() {
    return 'Budget for $childId: Food: \$${foodAndSnacks.toStringAsFixed(2)}, '
        'Entertainment: \$${entertainment.toStringAsFixed(2)}, '
        'Needs: \$${needs.toStringAsFixed(2)}, '
        'Savings: \$${savings.toStringAsFixed(2)}, '
        'Total Remaining: \$${totalRemaining.toStringAsFixed(2)}';
  }
}
