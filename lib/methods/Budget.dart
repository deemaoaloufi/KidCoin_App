class Budget {
  String childId; // Identifier for the child
  double foodAndSnacks; // Budget for food and snacks
  double entertainment; // Budget for entertainment
  double needs; // Budget for needs
  double savings; // Budget for savings

  // Constructor for initializing budget values
  Budget(this.childId, this.foodAndSnacks, this.entertainment, this.needs, this.savings);

  // Calculate total budget for the child
  double get totalBudget {
    return foodAndSnacks + entertainment + needs + savings; // Total budget calculation
  }

  // Override toString for easy debugging and display
  @override
  String toString() {
    return 'Budget for $childId: Food: \$${foodAndSnacks.toStringAsFixed(2)}, '
        'Entertainment: \$${entertainment.toStringAsFixed(2)}, '
        'Needs: \$${needs.toStringAsFixed(2)}, '
        'Savings: \$${savings.toStringAsFixed(2)}';
  }
}

class BudgetManager {
  final List<Budget> _budgets = []; // List to hold budget instances

  BudgetManager() {
    // Prepopulate the list with sample data
    _budgets.add(Budget('child1', 100.0, 150.0, 100.0, 50.0));
    _budgets.add(Budget('child2', 120.0, 130.0, 80.0, 70.0));
  }

  // This method returns a default Budget if no matching childId is found
  Budget getBudgetByChildId(String childId) {
    return _budgets.firstWhere(
      (budget) => budget.childId == childId,
      orElse: () => Budget('default', 0.0, 0.0, 0.0, 0.0), // Default budget if not found
    );
  }

  // Method to add a new budget
  void addBudget(Budget budget) {
    _budgets.add(budget); // Add the new budget to the list
  }
}
