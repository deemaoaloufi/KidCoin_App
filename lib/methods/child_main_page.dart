import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget.dart';
import 'reward_selection_screen.dart';
import 'tip.dart';

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
  String? childMood;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch child data by ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: widget.childId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        setState(() {
          childName = doc['name'] ?? 'Unknown';
          double totalBudget = doc['budget']?.toDouble() ?? 0.0;
          childMood = doc['mood'] ?? 'Captain Balanced';

          budget = Budget(widget.childId)
            ..totalRemaining = totalBudget
            ..setMood(childMood!);

          tip = Tip(budget!.mood);
        });
      } else {
        print("No child data found for the given childId.");
      }
    } catch (e) {
      print("Error fetching child data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchGameURL() async {
    const url = 'https://www.kongregate.com/games/BarbarianGames/into-space-2';
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the game. Error: $e')),
      );
    }
  }

  void _showPlayGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You are amazing and you deserve to have fun!'),
          content: const Text('Do you want to play INTO SPACE?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchGameURL();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showTipsDialog() {
    if (tip != null && budget != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tips for Budget Categories'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Food & Snacks: ${tip!.displayTip('Food & Snacks', budget!)}"),
                  const SizedBox(height: 8),
                  Text(
                      "Entertainment: ${tip!.displayTip('Entertainment', budget!)}"),
                  const SizedBox(height: 8),
                  Text("Needs: ${tip!.displayTip('Needs', budget!)}"),
                  const SizedBox(height: 8),
                  Text("Savings: ${tip!.displayTip('Savings', budget!)}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildBudgetCategory(
      String title, double amount, Color color, IconData icon) {
    return GestureDetector(
      onTap: () => _addSpending(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 8,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 28, color: color),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 8,
              child: Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _addSpending(String category) async {
    double? amount = await _showSpendingDialog(category);

    if (amount != null && budget != null) {
      String? error = await budget!.addSpending(category, amount);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 192, 128, 219),
                Color.fromARGB(255, 222, 181, 234),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(6, 4),
              ),
            ],
          ),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLoading ? 'Loading...' : 'Welcome, $childName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                if (childMood != null)
                  Text(
                    'Mood: $childMood',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 244, 251),
      body: _isLoading
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

                final doc = snapshot.data!;
                final budgetData = doc.data() as Map<String, dynamic>;

                budget = Budget(widget.childId)
                  ..foodAndSnacks = budgetData['foodAndSnacks'] ?? 0.0
                  ..entertainment = budgetData['entertainment'] ?? 0.0
                  ..needs = budgetData['needs'] ?? 0.0
                  ..savings = budgetData['savings'] ?? 0.0
                  ..totalRemaining = budgetData['totalRemaining'] ?? 0.0
                  ..mood = budgetData['mood'] ?? 'Captain Balanced';

                tip = Tip(budget!.mood);

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RewardSelectionScreen(
                                        childId: widget.childId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 133, 242),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(Icons.gif, size: 18),
                              label: const Text(
                                'Select Reward',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _showTipsDialog,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 133, 242),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(Icons.lightbulb_outline, size: 18),
                              label: const Text(
                                'Get Tips',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Total Budget:\n     \$${budget?.totalRemaining.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 122, 7, 175),
                                ),
                              ),
                              const SizedBox(height: 40),
                              GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.3,
                                children: [
                                  _buildBudgetCategory(
                                      'Food & Snacks',
                                      budget?.foodAndSnacks ?? 0.0,
                                      Colors.green,
                                      Icons.fastfood),
                                  _buildBudgetCategory(
                                      'Entertainment',
                                      budget?.entertainment ?? 0.0,
                                      Colors.blue,
                                      Icons.movie),
                                  _buildBudgetCategory(
                                      'Needs',
                                      budget?.needs ?? 0.0,
                                      Colors.orange,
                                      Icons.shopping_cart),
                                  _buildBudgetCategory(
                                    'Savings',
                                    budget?.savings ?? 0.0,
                                    const Color.fromARGB(255, 229, 120, 169),
                                    Icons.save,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: _showPlayGameDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[900],
                              foregroundColor: Colors.purple[100],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'Play INTO SPACE!',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}