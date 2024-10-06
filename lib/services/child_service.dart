import 'package:cloud_firestore/cloud_firestore.dart';

class ChildService {
  final CollectionReference childCollection =
      FirebaseFirestore.instance.collection('children');

  // Add a new child
  Future<void> addChild(String id, Map<String, dynamic> childData) async {
    await childCollection.doc(id).set(childData);
  }

  // Get child by ID
  Future<DocumentSnapshot> getChildById(String id) async {
    return await childCollection.doc(id).get();
  }

  // Get all children
  Future<List<Map<String, dynamic>>> getAllChildren() async {
    QuerySnapshot snapshot = await childCollection.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}

