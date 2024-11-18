import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'child_progress_screen.dart';

class ViewChildrenScreen extends StatelessWidget {
  final String parentId;

  const ViewChildrenScreen({Key? key, required this.parentId})
      : super(key: key);

  Future<List<Map<String, dynamic>>> fetchChildren() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('children')
        .where('parentId', isEqualTo: parentId)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Children List",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple[300],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChildren(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          final children = snapshot.data ?? [];
          if (children.isEmpty) {
            return const Center(
              child: Text(
                "No children registered.",
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    child['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    "Mood: ${child['mood'] ?? 'No Mood'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChildProgressScreen(childId: child['childId']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
