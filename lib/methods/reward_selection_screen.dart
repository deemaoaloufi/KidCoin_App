import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RewardSelectionScreen extends StatefulWidget {
  final String childId;

  const RewardSelectionScreen({Key? key, required this.childId}) : super(key: key);

  @override
  _RewardSelectionScreenState createState() => _RewardSelectionScreenState();
}

class _RewardSelectionScreenState extends State<RewardSelectionScreen> {
  List<String> rewards = [];
  bool isLoading = true;
  String? selectedReward;

  @override
  void initState() {
    super.initState();
    fetchRewards();
  }

  // Fetch rewards from Firestore based on the childId
  Future<void> fetchRewards() async {
    try {
      // Fetch the child document from Firestore using .where()
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;

        // Check if the document contains the 'rewards' field
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('rewards')) {
          List<dynamic> rewardsData = doc.data()!['rewards'];
          setState(() {
            rewards = rewardsData.cast<String>();  // Convert to list of strings
            // Fetch the previously selected reward from Firestore
            selectedReward = doc.data()!.containsKey('selectedReward')
                ? doc.data()!['selectedReward']
                : null;
            isLoading = false;
          });
        } else {
          print("No 'rewards' field found for this child.");
          setState(() {
            rewards = [];
            isLoading = false;
          });
        }
      } else {
        print("No document found for childId: ${widget.childId}");
        setState(() {
          rewards = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching rewards: $e");
      setState(() {
        rewards = [];
        isLoading = false;
      });
    }
  }

  // Method to select a reward and update Firestore
  Future<void> selectReward(String reward) async {
    try {
      // Update the 'selectedReward' field for the child in Firestore
      await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .limit(1)  // Ensure only one document is updated
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          // Proceed to update the selected reward
          await snapshot.docs.first.reference.update({'selectedReward': reward});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reward '$reward' selected successfully")),
          );

          // Optionally, update the local state (if needed)
          setState(() {
            selectedReward = reward;  // Store the selected reward locally
          });
        }
      });
    } catch (e) {
      print("Error selecting reward: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to select reward")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Reward'),
        backgroundColor: Colors.purple[300], // Set AppBar color to purple
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rewards.isEmpty
              ? const Center(child: Text("No rewards available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    bool isSelected = reward == selectedReward; // Check if the reward is selected

                    return GestureDetector(
                      onTap: () => selectReward(reward),
                      child: Card(
                        elevation: 4, // Add a little shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: isSelected ? Colors.green[200] : Colors.white, // Change color to green if selected
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(reward, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          trailing: isSelected 
                              ? const Icon(Icons.check, color: Colors.white) // Show checkmark in white if selected
                              : const Icon(Icons.check, color: Colors.grey), // Show grey checkmark if not selected
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
