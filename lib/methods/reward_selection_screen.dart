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
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('rewards')) {
          List<dynamic> rewardsData = doc.data()!['rewards'];
          setState(() {
            rewards = rewardsData.cast<String>();
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
          .limit(1)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.update({'selectedReward': reward});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Yay! '$reward' has been selected! 🎉")),
          );
          setState(() {
            selectedReward = reward;
          });
        }
      });
    } catch (e) {
      print("Error selecting reward: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Oops! Something went wrong. 😞")),
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
          : Column(
              children: [
                Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: 150,
                    color: const Color.fromARGB(255, 163, 82, 154),
                  ),
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