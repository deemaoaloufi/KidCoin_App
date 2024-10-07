import 'package:cloud_firestore/cloud_firestore.dart';

class ChildService {
  final CollectionReference childCollection = FirebaseFirestore.instance.collection('children ');

  /// Adds a new child document to Firestore.
  Future<void> addChild(Map<String, dynamic> childData) async {
    await childCollection.add(childData);
  }

  /// Retrieves a list of children associated with a specific parent.
  Future<List<Map<String, dynamic>>> getChildrenByParent(String parentId) async {
    QuerySnapshot snapshot = await childCollection.where('parentId', isEqualTo: parentId).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
