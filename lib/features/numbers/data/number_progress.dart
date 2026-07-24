import 'package:shared_preferences/shared_preferences.dart';

class NumberProgress {
  static const String _highestLevelKey = 'highest_unlocked_number_level';

  static Future<int> highestUnlockedLevel() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_highestLevelKey) ?? 1;
  }

  static Future<void> unlockNextLevel(int completedLevel) async {
    if (completedLevel >= 5) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    final currentHighest = preferences.getInt(_highestLevelKey) ?? 1;

    final nextLevel = completedLevel + 1;

    if (nextLevel > currentHighest) {
      await preferences.setInt(_highestLevelKey, nextLevel);
    }
  }
}
