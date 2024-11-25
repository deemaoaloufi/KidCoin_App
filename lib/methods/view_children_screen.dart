import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'child_progress_screen.dart';

class ViewChildrenScreen extends StatelessWidget {
  final String parentId;

  const ViewChildrenScreen({super.key, required this.parentId});

  Future<List<Map<String, dynamic>>> fetchChildren() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('children')
        .where('parentId', isEqualTo: parentId)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
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
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/UI_ChildList.gif',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          FutureBuilder<List<Map<String, dynamic>>>(
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
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  final isGirl =
                      (child['gender'] ?? '').toLowerCase() == 'female';
                  final backgroundColor =
                      isGirl ? Colors.pink[50] : Colors.blue[50];
                  final iconPath = isGirl
                      ? 'assets/icons/girlIcon.png' // Custom icon for girls
                      : 'assets/icons/boyIcon.png'; // Custom icon for boys

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            iconPath,
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            child['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Mood: ${child['mood'] ?? 'No Mood'}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChildProgressScreen(
                                      childId: child['childId']),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isGirl
                                  ? Colors.pink[200]
                                  : Colors.blue[200],
                            ),
                            child: const Text("View Progress"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
