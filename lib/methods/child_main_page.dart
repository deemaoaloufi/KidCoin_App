import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget.dart';
import 'reward_selection_screen.dart';
import 'tip.dart';
import 'reward.dart';

class ChildMainPage extends StatefulWidget {
  final String childId;

  const ChildMainPage({super.key, required this.childId});

  @override
  _ChildMainPageState createState() => _ChildMainPageState();
}

class _ChildMainPageState extends State<ChildMainPage> {
  Budget? budget;
  Tip? tip;
  String? childName;
  bool _isLoading = true;
  RewardManager rewardManager = RewardManager();
  bool isRewardLoading = true;
  String? selectedReward;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (doc.exists) {
        setState(() {
          childName = doc['name'];
          double totalBudget = doc['budget']?.toDouble() ?? 0.0;
          String childMood = doc['mood'] ?? 'Captain Balanced';

          budget = Budget(widget.childId)
            ..totalRemaining = totalBudget
            ..setMood(childMood);

          tip = Tip(childMood);

          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching child data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addSpending(String category) async {
    double? amount = await _showSpendingDialog(category);

    if (amount != null && budget != null) {
      String? error = budget!.addSpending(category, amount);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      } else {
        setState(() {});
      }
    }
  }

  Future<double?> _showSpendingDialog(String category) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter spending for $category'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.purple, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? amount = double.tryParse(controller.text);
                Navigator.of(context).pop(amount);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBudgetCategory(
      String title, double amount, Color color, IconData icon) {
    String tipText = tip?.displayTip(title, budget!) ?? '';

    return GestureDetector(
      onTap: () => _addSpending(title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(color: color),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                tipText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text
        (_isLoading ? 'Loading...' : 'Welcome, $childName',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple[300],
        elevation: 6,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Budget: \$${budget?.totalRemaining.toStringAsFixed(2) ?? '0.00'}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85,
                        shrinkWrap: true,
                        children: [
                          _buildBudgetCategory(
                              "Food & Snacks",
                              budget?.foodAndSnacks ?? 0,
                              Colors.pinkAccent,
                              Icons.fastfood),
                          _buildBudgetCategory(
                              "Entertainment",
                              budget?.entertainment ?? 0,
                              Colors.blueAccent,
                              Icons.videogame_asset),
                          _buildBudgetCategory("Needs", budget?.needs ?? 0,
                              Colors.greenAccent, Icons.shopping_basket),
                          _buildBudgetCategory("Savings", budget?.savings ?? 0,
                              Colors.orangeAccent, Icons.savings),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RewardSelectionScreen(childId: widget.childId),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple[100], // Matching the style used in registration form
      foregroundColor: Colors.purple[900],
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Adjusted for oval shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded but not circular
      ),
      elevation: 3,
    ),
    child: const Text(
      'Select Your Reward!',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
)



   
              ],
            ),
    );
  }
}