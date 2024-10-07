import 'package:cloud_firestore/cloud_firestore.dart';

class ChildService {
  final CollectionReference childCollection = FirebaseFirestore.instance.collection('children');

  Future<void> addChild(String id, Map<String, dynamic> childData) async {
    await childCollection.doc(id).set(childData);
  }

  Future<DocumentSnapshot> getChildById(String id) async {
    return await childCollection.doc(id).get();
  }

  Future<List<Map<String, dynamic>>> getAllChildren() async {
    QuerySnapshot snapshot = await childCollection.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> updateChild(String id, Map<String, dynamic> childData) async {
    await childCollection.doc(id).update(childData);
  }

  Future<void> deleteChild(String id) async {
    await childCollection.doc(id).delete();
  }
}



