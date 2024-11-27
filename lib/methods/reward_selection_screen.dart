import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidcoin_app/methods/Budget.dart';

class RewardSelectionScreen extends StatefulWidget {
  final String childId;

  const RewardSelectionScreen({
    super.key,
    required this.childId,
  });

  @override
  _RewardSelectionScreenState createState() => _RewardSelectionScreenState();
}

class _RewardSelectionScreenState extends State<RewardSelectionScreen> {
  List<String> rewards = [];
  bool isLoading = true;
  Budget? budget;
  String? selectedReward;
  String? moodType;
  String? rewardPeriod; // Fetched reward period
  int remainingTime = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchRewardDetails();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    budget?.listenForUpdates(() {
      setState(() {});
    });
  }

  Future<void> fetchRewardDetails() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;

        setState(() {
          rewards = List<String>.from(doc.data()?['rewards'] ?? []);
          moodType = doc.data()?['mood'] ?? 'Captain Balanced';
          rewardPeriod = doc.data()?['rewardPeriod']; // Firebase value

          // Print mood and reward period for debugging
          print("Fetched mood type: $moodType");
          print("Fetched reward period: $rewardPeriod");

          // Initialize the budget with values from Firebase or set default values
          budget = Budget(widget.childId)
            ..foodAndSnacks = doc.data()?['foodAndSnacks'] ?? 0.0
            ..entertainment = doc.data()?['entertainment'] ?? 0.0
            ..needs = doc.data()?['needs'] ?? 0.0
            ..savings = doc.data()?['savings'] ?? 0.0
            ..setMood(moodType!);

          isLoading = false;

          // Adjust the timer based on the fetched reward period
          _setTimerDuration();
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("No document found for childId: ${widget.childId}");
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer?.cancel();
        _decideReward();
      }
    });
  }

  void _setTimerDuration() {
    int timerDuration = 60; // Default is 60 seconds (1 minute)

    if (rewardPeriod != null) {
      switch (rewardPeriod!.toLowerCase()) {
        case 'daily':
          timerDuration = 60 * 60 * 24; // 1 day in seconds
          break;
        case 'weekly':
          timerDuration = 60 * 60 * 24 * 7; // 1 week in seconds
          break;
        case 'monthly':
          timerDuration = 60 * 60 * 24 * 30; // 1 month in seconds
          break;
        case 'Test, 1m':
          timerDuration = 60; //TEST one min
          break;
        default:
          print(
              "Invalid reward period: $rewardPeriod. Defaulting to 1 minute.");
          timerDuration = 60; // Default to 1 minute for invalid periods
      }
    }

    setState(() {
      remainingTime = timerDuration;
    });
    _startTimer(); // Start the timer after setting duration
  }

  void _decideReward() async {
    if (budget == null) {
      print("Budget not initialized, unable to decide reward.");
      return;
    }

    // Fetch the latest budget amounts for each category
    double foodAndSnacks = budget!.foodAndSnacks;
    double entertainment = budget!.entertainment;
    double needs = budget!.needs;
    double savings = budget!.savings;

    print(
        "Food and Snacks: $foodAndSnacks, Entertainment: $entertainment, Needs: $needs, Savings: $savings"); // Debugging print

    bool isRewardGranted = false;

    // Logic for determining if reward should be granted based on mood and budget
    switch (moodType) {
      case 'Captain Saver':
        if (savings > foodAndSnacks &&
            savings > entertainment &&
            savings > needs) {
          isRewardGranted = true;
        }
        break;
      case 'Captain Balanced':
        if (savings > 0 &&
            savings == foodAndSnacks &&
            savings == entertainment &&
            savings == needs) {
          isRewardGranted = true;
        }
        break;
      case 'Captain Funster':
        if (entertainment > 0) {
          isRewardGranted = true;
        }
        break;
      case 'Captain Essential':
        if (needs > 0) {
          isRewardGranted = true;
        }
        break;
      case 'Captain Foodie':
        if (foodAndSnacks > 0) {
          isRewardGranted = true;
        }
        break;
      default:
        print("Invalid mood type: $moodType");
        break;
    }

    // Show dialog with reward decision message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isRewardGranted ? "Congratulations!" : "Sorry!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            isRewardGranted
                ? "You've won the reward!🎉"
                : "You didn't meet the target for the reward😞",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    // Print the decision for debugging
    if (isRewardGranted) {
      print("Reward Granted.");
    } else {
      print("Reward Denied.");
    }
  }

  void winORlose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a Reward',
          style: TextStyle(
              fontFamily: 'Comic Sans MS', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 222, 181, 234),
        elevation: 6,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/UI_ChildList.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Display the selected reward
                  if (selectedReward != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Selected Reward: $selectedReward",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (moodType != null)
                            Text(
                              '$moodType!',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 143, 20, 147),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Display the countdown timer
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Time Remaining: $remainingTime seconds",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 168, 38, 173),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Rewards list
                  Expanded(
                    child: rewards.isEmpty
                        ? const Center(child: Text("No rewards available"))
                        : ListView.builder(
                            itemCount: rewards.length,
                            itemBuilder: (context, index) {
                              final reward = rewards[index];
                              bool isSelected = reward == selectedReward;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedReward = reward;

                                    // Start the timer only after a reward is selected
                                    _startTimer();
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  padding: const EdgeInsets.all(25.0),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color.fromARGB(
                                            255, 155, 60, 182)
                                        : const Color.fromARGB(
                                            255, 180, 138, 198),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      reward,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
