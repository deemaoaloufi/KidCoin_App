import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetService {
  final CollectionReference budgetCollection = FirebaseFirestore.instance.collection('budgets');

  Future<void> addBudget(String childId, Map<String, dynamic> budgetData) async {
    await budgetCollection.doc(childId).set(budgetData);
  }

  Future<DocumentSnapshot> getBudgetByChildId(String childId) async {
    return await budgetCollection.doc(childId).get();
  }
}
