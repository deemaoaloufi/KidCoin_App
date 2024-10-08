import 'package:cloud_firestore/cloud_firestore.dart';

class ChildService {
  final CollectionReference childCollection = FirebaseFirestore.instance.collection('children');

  Future<void> addChild(Map<String, dynamic> childData) async {
    try {
      DocumentReference docRef = childCollection.doc();
      String childId = docRef.id.substring(0, 6).toUpperCase(); // Change this if necessary

      childData['childId'] = childId;
      await docRef.set(childData);
    } catch (e) {
      throw Exception('Error adding child: $e');
    }
  }

  Future<void> deleteChild(String docId) async {
    try {
      await childCollection.doc(docId).delete();
    } catch (e) {
      throw Exception('Error deleting child: $e');
    }
  }

  Future<void> updateChild(String docId, Map<String, dynamic> updatedData) async {
    try {
      await childCollection.doc(docId).update(updatedData);
    } catch (e) {
      throw Exception('Error updating child: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChildrenByParent(String parentId) async {
    try {
      QuerySnapshot snapshot = await childCollection.where('parentId', isEqualTo: parentId).get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching children: $e');
    }
  }
}
