import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget.dart';

class ChildProgressScreen extends StatefulWidget {
  final String childId;

  const ChildProgressScreen({super.key, required this.childId});

  @override
  _ChildProgressScreenState createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen> {
  Budget? budget;
  String? childName;
  String? selectedReward;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChildData();
  }

  Future<void> _fetchChildData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          childName = data['name'];
          selectedReward = data['selectedReward'];
        });
        print("Selected reward fetched: $selectedReward"); // Debug print
      } else {
        print("No child data found for ID: ${widget.childId}"); // Debug print
      }
    } catch (e) {
      print("Error fetching child data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBudgetDetail(String category, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text("\$${amount.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          childName != null ? "$childName's Progress" : "Child Progress",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Stack(
        children: [
          // White background
          Container(color: Colors.white),

          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/ChildUI.png',
              fit: BoxFit.cover,
            ),
          ),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('children')
                      .doc(widget.childId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data available'));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    // Update the budget object dynamically
                    budget = Budget(widget.childId)
                      ..foodAndSnacks = data['foodAndSnacks'] ?? 0.0
                      ..entertainment = data['entertainment'] ?? 0.0
                      ..needs = data['needs'] ?? 0.0
                      ..savings = data['savings'] ?? 0.0
                      ..totalRemaining = data['totalRemaining'] ?? 0.0;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedReward != null)
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color.fromARGB(255, 232, 205, 164), const Color.fromARGB(255, 235, 176, 86)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/rewardIcon.png',  // Custom icon for the reward
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Selected Reward: $selectedReward",  // Display the reward name
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Total Remaining Budget Card
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green[400]!, Colors.green[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  "Remaining: \$${budget?.totalRemaining.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Amount Saved Card
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[400]!, Colors.blue[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  "Saved: \$${budget?.savings.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Budget Breakdown Box
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "Budget Breakdown",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[700],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.5,
                                  children: [
                                    _buildBudgetDetail(
                                      "Food & Snacks",
                                      budget?.foodAndSnacks ?? 0,
                                      Colors.pinkAccent,
                                      Icons.fastfood,
                                    ),
                                    _buildBudgetDetail(
                                      "Entertainment",
                                      budget?.entertainment ?? 0,
                                      Colors.blueAccent,
                                      Icons.movie,
                                    ),
                                    _buildBudgetDetail(
                                      "Needs",
                                      budget?.needs ?? 0,
                                      Colors.greenAccent,
                                      Icons.shopping_cart,
                                    ),
                                    _buildBudgetDetail(
                                      "Savings",
                                      budget?.savings ?? 0,
                                      Colors.blueAccent,
                                      Icons.save,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
