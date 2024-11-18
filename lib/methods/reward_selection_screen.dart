import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RewardSelectionScreen extends StatefulWidget {
  final String childId;

  const RewardSelectionScreen({super.key, required this.childId});

  @override
  _RewardSelectionScreenState createState() => _RewardSelectionScreenState();
}

class _RewardSelectionScreenState extends State<RewardSelectionScreen> {
  List<String> rewards = [];
  bool isLoading = true;
  String? selectedReward;

  // Fetch rewards from Firestore based on the childId
  Future<void> fetchRewards() async {
    try {
<<<<<<< HEAD
=======
      // Fetch the child document from Firestore using .where()
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
<<<<<<< HEAD
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('rewards')) {
          List<dynamic> rewardsData = doc.data()!['rewards'];
          setState(() {
            rewards = rewardsData.cast<String>();
=======

        // Check if the document contains the 'rewards' field
        if (doc.exists &&
            doc.data() != null &&
            doc.data()!.containsKey('rewards')) {
          List<dynamic> rewardsData = doc.data()!['rewards'];
          setState(() {
            rewards = rewardsData.cast<String>(); // Convert to list of strings
            // Fetch the previously selected reward from Firestore
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
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
      await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
<<<<<<< HEAD
          .limit(1)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.update({'selectedReward': reward});
=======
          .limit(1) // Ensure only one document is updated
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          // Proceed to update the selected reward
          await snapshot.docs.first.reference
              .update({'selectedReward': reward});

          // Show success message
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Yay! '$reward' has been selected! 🎉")),
          );
          setState(() {
<<<<<<< HEAD
            selectedReward = reward;
=======
            selectedReward = reward; // Store the selected reward locally
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
          });
        }
      });
    } catch (e) {
      print("Error selecting reward: $e");
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        const SnackBar(content: Text("Oops! Something went wrong 😞")),
=======
        const SnackBar(content: Text("Failed to select reward")),
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRewards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a Reward',
          style: TextStyle(fontFamily: 'Comic Sans MS', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 222, 181, 234),
        elevation: 6,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
<<<<<<< HEAD
          : Column(
              children: [
                Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: 150,
                    color: const Color.fromARGB(255, 163, 82, 154),
                  ),
=======
          : rewards.isEmpty
              ? const Center(child: Text("No rewards available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    bool isSelected = reward ==
                        selectedReward; // Check if the reward is selected

                    return GestureDetector(
                      onTap: () => selectReward(reward),
                      child: Card(
                        elevation: 4, // Add a little shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: isSelected
                            ? Colors.green[200]
                            : Colors.white, // Change color to green if selected
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(reward,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          trailing: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors
                                      .white) // Show checkmark in white if selected
                              : const Icon(Icons.check,
                                  color: Colors
                                      .grey), // Show grey checkmark if not selected
                        ),
                      ),
                    );
                  },
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: rewards.isEmpty
                      ? const Center(child: Text("No rewards available"))
                      : ListView.builder(
                          itemCount: rewards.length,
                          itemBuilder: (context, index) {
                            final reward = rewards[index];
                            bool isSelected = reward == selectedReward;

                            return GestureDetector(
                              onTap: () => selectReward(reward),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(25.0),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color.fromRGBO(239, 206, 248, 1) : const Color.fromARGB(255, 224, 249, 255),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected ? const Color.fromARGB(255, 163, 82, 154) : const Color.fromARGB(255, 162, 214, 228),
                                      blurRadius: 8.0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard,
                                      size: 32,
                                      color: isSelected ? const Color.fromARGB(239, 206, 248, 1) : Colors.grey,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      reward,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16), // Space before the button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color.fromARGB(255, 241, 154, 251),
                    padding: const EdgeInsets.symmetric(horizontal:22,vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Return to Main Page',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
              ],
            ),
    );
  }
}
