class RewardManager {
  final List<String> _rewards = [];
  String? selectedReward;

  List<String> get rewards => _rewards;

  // Add a reward to the list
  void addReward(String reward) {
    if (reward.isNotEmpty && !_rewards.contains(reward) && _rewards.length < 5) {
      _rewards.add(reward);
    }
  }

  // Remove a reward from the list
  void removeReward(String reward) {
    _rewards.remove(reward);
    if (selectedReward == reward) {
      selectedReward = null; // Clear selected reward if it's removed
    }
  }

}