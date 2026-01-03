import 'package:shared_preferences/shared_preferences.dart';

class SaveGame {
  static const _kUnlockedMaxIndex = 'unlockedMaxLevelIndex';

  /// 0-based index of the highest unlocked level.
  static Future<int> loadUnlockedMaxIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUnlockedMaxIndex) ?? 0;
  }

  static Future<void> saveUnlockedMaxIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUnlockedMaxIndex, index);
  }

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUnlockedMaxIndex);
  }
}
