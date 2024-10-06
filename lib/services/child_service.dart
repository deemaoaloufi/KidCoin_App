import 'package:cloud_firestore/cloud_firestore.dart';

class ChildService {
  final CollectionReference childCollection =
      FirebaseFirestore.instance.collection('children');

  // Add a new child
  Future<void> addChild(String id, Map<String, dynamic> childData) async {
    try {
      await childCollection.doc(id).set(childData);
    } catch (e) {
      print('Error adding child: $e');
      throw Exception('Failed to add child: $e');
    }
  }

  // Get child by ID
  Future<DocumentSnapshot> getChildById(String id) async {
    try {
      return await childCollection.doc(id).get();
    } catch (e) {
      print('Error fetching child: $e');
      throw Exception('Failed to fetch child: $e');
    }
  }

  // Get all children
  Future<List<Map<String, dynamic>>> getAllChildren() async {
    try {
      QuerySnapshot snapshot = await childCollection.get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching children: $e');
      throw Exception('Failed to fetch children: $e');
    }
  }

  // Update child data by ID
  Future<void> updateChild(String id, Map<String, dynamic> childData) async {
    try {
      await childCollection.doc(id).update(childData);
    } catch (e) {
      print('Error updating child: $e');
      throw Exception('Failed to update child: $e');
    }
  }

  // Delete child by ID
  Future<void> deleteChild(String id) async {
    try {
      await childCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting child: $e');
      throw Exception('Failed to delete child: $e');
    }
  }
}
