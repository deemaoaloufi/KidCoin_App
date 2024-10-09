class Budget {
  String childId; // Identifier for the child
  double foodAndSnacks; // Budget for food and snacks
  double entertainment; // Budget for entertainment
  double needs; // Budget for needs
  double savings; // Budget for savings

  static double totalBudget = 100.0; // Constant total budget

  Budget(this.childId)
      : foodAndSnacks = totalBudget * 0.30,
        entertainment = totalBudget * 0.20,
        needs = totalBudget * 0.40,
        savings = totalBudget * 0.10;

  // Getter to calculate the remaining total budget
  double get calculatedTotalBudget {
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
