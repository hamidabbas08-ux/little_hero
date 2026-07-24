import 'package:flutter/material.dart';

import '../../../core/services/app_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _voiceEnabled = true;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _automaticVoice = true;
  double _voiceSpeed = AppPreferences.defaultVoiceSpeed;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final voiceEnabled = await AppPreferences.getVoiceEnabled();
    final soundEnabled = await AppPreferences.getSoundEnabled();
    final musicEnabled = await AppPreferences.getMusicEnabled();
    final automaticVoice = await AppPreferences.getAutomaticVoice();
    final voiceSpeed = await AppPreferences.getVoiceSpeed();

    if (!mounted) {
      return;
    }

    setState(() {
      _voiceEnabled = voiceEnabled;
      _soundEnabled = soundEnabled;
      _musicEnabled = musicEnabled;
      _automaticVoice = automaticVoice;
      _voiceSpeed = voiceSpeed;
      _isLoading = false;
    });
  }

  String get _voiceSpeedName {
    if (_voiceSpeed <= 0.32) {
      return 'Slow';
    }

    if (_voiceSpeed >= 0.48) {
      return 'Fast';
    }

    return 'Normal';
  }

  Future<void> _confirmResetProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Learning Progress?'),
          content: const Text(
            'All stars, badges, quiz scores and '
            'unlocked number levels will be removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await AppPreferences.resetLearningProgress();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Learning progress was reset successfully.'),
      ),
    );
  }

  Future<void> _resetSettings() async {
    await AppPreferences.resetSettings();
    await _loadSettings();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings were restored to default.')),
    );
  }

  void _showAppInformation() {
    showAboutDialog(
      context: context,
      applicationName: 'Little Hero',
      applicationVersion: '1.0.0',
      applicationIcon: const CircleAvatar(
        radius: 29,
        backgroundColor: Color(0xFFFFD166),
        child: Text('🦸', style: TextStyle(fontSize: 32)),
      ),
      children: const [
        Text(
          'Little Hero is a fun learning app for '
          'children. Learn alphabet, numbers, colors, '
          'shapes, animals, everyday things and stories.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C78E8),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: [
                _buildSectionTitle('Sound and Voice', '🔊'),
                _buildSettingsCard(
                  children: [
                    SwitchListTile(
                      value: _voiceEnabled,
                      secondary: const Icon(Icons.record_voice_over_rounded),
                      title: const Text(
                        'Voice',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        'Spoken names, lessons and questions',
                      ),
                      onChanged: (value) async {
                        setState(() {
                          _voiceEnabled = value;
                        });

                        await AppPreferences.setVoiceEnabled(value);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _soundEnabled,
                      secondary: const Icon(Icons.volume_up_rounded),
                      title: const Text(
                        'Sound Effects',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        'Correct, wrong and completion sounds',
                      ),
                      onChanged: (value) async {
                        setState(() {
                          _soundEnabled = value;
                        });

                        await AppPreferences.setSoundEnabled(value);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _musicEnabled,
                      secondary: const Icon(Icons.music_note_rounded),
                      title: const Text(
                        'Background Music',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        'Music during quizzes and activities',
                      ),
                      onChanged: (value) async {
                        setState(() {
                          _musicEnabled = value;
                        });

                        await AppPreferences.setMusicEnabled(value);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _automaticVoice,
                      secondary: const Icon(Icons.play_circle_outline_rounded),
                      title: const Text(
                        'Automatic Voice',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        'Speak automatically when a screen opens',
                      ),
                      onChanged: (value) async {
                        setState(() {
                          _automaticVoice = value;
                        });

                        await AppPreferences.setAutomaticVoice(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _buildSectionTitle('Voice Speed', '🎙️'),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 17, 18, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFC5B7FF),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed_rounded, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Reading Speed',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            _voiceSpeedName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF6C52B3),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        min: 0.28,
                        max: 0.52,
                        divisions: 2,
                        value: _voiceSpeed,
                        label: _voiceSpeedName,
                        onChanged: (value) {
                          setState(() {
                            _voiceSpeed = value;
                          });
                        },
                        onChangeEnd: (value) {
                          AppPreferences.setVoiceSpeed(value);
                        },
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Slow'), Text('Normal'), Text('Fast')],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _buildSectionTitle('Progress and App', '🛠️'),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.refresh_rounded),
                      title: const Text(
                        'Restore Default Settings',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _resetSettings,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Reset Learning Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: const Text(
                        'Remove stars, badges and unlocked levels',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _confirmResetProgress,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text(
                        'About Little Hero',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showAppInformation,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title, String emoji) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 27)),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF453866),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC5B7FF), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
