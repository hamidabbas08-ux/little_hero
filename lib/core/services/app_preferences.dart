import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static const String _voiceEnabledKey = 'settings_voice_enabled';
  static const String _soundEnabledKey = 'settings_sound_enabled';
  static const String _musicEnabledKey = 'settings_music_enabled';
  static const String _automaticVoiceKey = 'settings_automatic_voice';
  static const String _voiceSpeedKey = 'settings_voice_speed';

  static const String _totalStarsKey = 'rewards_total_stars';
  static const String _completedQuizCountKey = 'rewards_completed_quiz_count';

  static const bool defaultVoiceEnabled = true;
  static const bool defaultSoundEnabled = true;
  static const bool defaultMusicEnabled = true;
  static const bool defaultAutomaticVoice = true;
  static const double defaultVoiceSpeed = 0.39;

  static Future<SharedPreferences> get _preferences async {
    return SharedPreferences.getInstance();
  }

  static Future<bool> getVoiceEnabled() async {
    final preferences = await _preferences;
    return preferences.getBool(_voiceEnabledKey) ?? defaultVoiceEnabled;
  }

  static Future<void> setVoiceEnabled(bool value) async {
    final preferences = await _preferences;
    await preferences.setBool(_voiceEnabledKey, value);
  }

  static Future<bool> getSoundEnabled() async {
    final preferences = await _preferences;
    return preferences.getBool(_soundEnabledKey) ?? defaultSoundEnabled;
  }

  static Future<void> setSoundEnabled(bool value) async {
    final preferences = await _preferences;
    await preferences.setBool(_soundEnabledKey, value);
  }

  static Future<bool> getMusicEnabled() async {
    final preferences = await _preferences;
    return preferences.getBool(_musicEnabledKey) ?? defaultMusicEnabled;
  }

  static Future<void> setMusicEnabled(bool value) async {
    final preferences = await _preferences;
    await preferences.setBool(_musicEnabledKey, value);
  }

  static Future<bool> getAutomaticVoice() async {
    final preferences = await _preferences;
    return preferences.getBool(_automaticVoiceKey) ?? defaultAutomaticVoice;
  }

  static Future<void> setAutomaticVoice(bool value) async {
    final preferences = await _preferences;
    await preferences.setBool(_automaticVoiceKey, value);
  }

  static Future<double> getVoiceSpeed() async {
    final preferences = await _preferences;
    return preferences.getDouble(_voiceSpeedKey) ?? defaultVoiceSpeed;
  }

  static Future<void> setVoiceSpeed(double value) async {
    final preferences = await _preferences;
    await preferences.setDouble(_voiceSpeedKey, value);
  }

  static Future<int> getTotalStars() async {
    final preferences = await _preferences;
    return preferences.getInt(_totalStarsKey) ?? 0;
  }

  static Future<int> getCompletedQuizCount() async {
    final preferences = await _preferences;
    return preferences.getInt(_completedQuizCountKey) ?? 0;
  }

  static Future<int> getBestScore(String quizId) async {
    final preferences = await _preferences;
    return preferences.getInt('rewards_best_$quizId') ?? 0;
  }

  static Future<bool> isBadgeUnlocked(String quizId) async {
    final preferences = await _preferences;
    return preferences.getBool('rewards_badge_$quizId') ?? false;
  }

  static Future<void> saveQuizResult({
    required String quizId,
    required int score,
    required int totalQuestions,
  }) async {
    final preferences = await _preferences;

    final bestScoreKey = 'rewards_best_$quizId';
    final badgeKey = 'rewards_badge_$quizId';
    final completionKey = 'rewards_completed_$quizId';

    final previousBest = preferences.getInt(bestScoreKey) ?? 0;
    final previousCompletion = preferences.getBool(completionKey) ?? false;
    final currentTotalStars = preferences.getInt(_totalStarsKey) ?? 0;
    final currentCompletedCount =
        preferences.getInt(_completedQuizCountKey) ?? 0;

    if (score > previousBest) {
      final newStars = currentTotalStars + (score - previousBest);

      await preferences.setInt(_totalStarsKey, newStars);

      await preferences.setInt(bestScoreKey, score);
    }

    if (!previousCompletion) {
      await preferences.setBool(completionKey, true);

      await preferences.setInt(
        _completedQuizCountKey,
        currentCompletedCount + 1,
      );
    }

    final passingScore = (totalQuestions * 0.7).ceil();

    if (score >= passingScore) {
      await preferences.setBool(badgeKey, true);
    }
  }

  static Future<void> resetSettings() async {
    final preferences = await _preferences;

    await preferences.setBool(_voiceEnabledKey, defaultVoiceEnabled);
    await preferences.setBool(_soundEnabledKey, defaultSoundEnabled);
    await preferences.setBool(_musicEnabledKey, defaultMusicEnabled);
    await preferences.setBool(_automaticVoiceKey, defaultAutomaticVoice);
    await preferences.setDouble(_voiceSpeedKey, defaultVoiceSpeed);
  }

  static Future<void> resetLearningProgress() async {
    final preferences = await _preferences;

    final keysToRemove = preferences
        .getKeys()
        .where(
          (key) =>
              key.startsWith('rewards_') ||
              key.startsWith('number_') ||
              key.startsWith('numbers_'),
        )
        .toList();

    for (final key in keysToRemove) {
      await preferences.remove(key);
    }
  }
}
