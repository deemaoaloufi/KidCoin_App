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
      appBar: AppBar(title: const Text("Your Children")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChildren(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final children = snapshot.data ?? [];
          if (children.isEmpty) {
            return const Center(child: Text("No children registered."));
          }

          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              final child = children[index];
              return ListTile(
                title: Text(child['name'] ?? 'No Name'),
                subtitle: Text("Mood: ${child['mood'] ?? 'No Mood'}"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChildProgressScreen(childId: child['childId']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
