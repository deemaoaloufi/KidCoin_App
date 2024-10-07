class Budget {
  String childId;
  double foodAndSnacks;
  double entertainment;
  double needs;
  double savings;

  Budget(this.childId, this.foodAndSnacks, this.entertainment, this.needs, this.savings);

  double get totalBudget {
    return foodAndSnacks + entertainment + needs + savings;
  }

  @override
  String toString() {
    return 'Budget for $childId: Food: \$${foodAndSnacks.toStringAsFixed(2)}, '
        'Entertainment: \$${entertainment.toStringAsFixed(2)}, '
        'Needs: \$${needs.toStringAsFixed(2)}, '
        'Savings: \$${savings.toStringAsFixed(2)}';
  }
}

class BudgetManager {
  final List<Budget> _budgets = [];

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

  void addBudget(Budget budget) {
    _budgets.add(budget);
  }
}
