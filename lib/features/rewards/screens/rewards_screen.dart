import 'package:flutter/material.dart';

import '../../../core/services/app_preferences.dart';

class RewardDefinition {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int maximumScore;

  const RewardDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.maximumScore = 10,
  });
}

const List<RewardDefinition> rewardDefinitions = [
  RewardDefinition(
    id: 'alphabet',
    title: 'Alphabet Hero',
    subtitle: 'Complete the Alphabet Quiz',
    emoji: '🔤',
  ),
  RewardDefinition(
    id: 'numbers_level_1',
    title: 'Number Star 1',
    subtitle: 'Pass Numbers Level 1',
    emoji: '1️⃣',
  ),
  RewardDefinition(
    id: 'numbers_level_2',
    title: 'Number Star 2',
    subtitle: 'Pass Numbers Level 2',
    emoji: '2️⃣',
  ),
  RewardDefinition(
    id: 'numbers_level_3',
    title: 'Number Star 3',
    subtitle: 'Pass Numbers Level 3',
    emoji: '3️⃣',
  ),
  RewardDefinition(
    id: 'numbers_level_4',
    title: 'Number Star 4',
    subtitle: 'Pass Numbers Level 4',
    emoji: '4️⃣',
  ),
  RewardDefinition(
    id: 'numbers_level_5',
    title: 'Number Champion',
    subtitle: 'Pass Numbers Level 5',
    emoji: '5️⃣',
  ),
  RewardDefinition(
    id: 'colors',
    title: 'Color Champion',
    subtitle: 'Complete the Colors Quiz',
    emoji: '🎨',
  ),
  RewardDefinition(
    id: 'shapes',
    title: 'Shape Master',
    subtitle: 'Complete the Shapes Quiz',
    emoji: '🔺',
  ),
  RewardDefinition(
    id: 'animals',
    title: 'Animal Explorer',
    subtitle: 'Complete the Animals Quiz',
    emoji: '🦁',
  ),
  RewardDefinition(
    id: 'everyday_things',
    title: 'Everyday Explorer',
    subtitle: 'Complete the Everyday Things Quiz',
    emoji: '🪑',
  ),
  RewardDefinition(
    id: 'stories',
    title: 'Story Listener',
    subtitle: 'Complete a learning story',
    emoji: '📚',
  ),
];

class RewardStatus {
  final RewardDefinition definition;
  final int bestScore;
  final bool unlocked;

  const RewardStatus({
    required this.definition,
    required this.bestScore,
    required this.unlocked,
  });
}

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _isLoading = true;
  int _totalStars = 0;
  int _completedQuizzes = 0;
  List<RewardStatus> _rewards = [];

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final totalStars = await AppPreferences.getTotalStars();
    final completedQuizzes = await AppPreferences.getCompletedQuizCount();

    final rewards = <RewardStatus>[];

    for (final definition in rewardDefinitions) {
      final bestScore = await AppPreferences.getBestScore(definition.id);

      final unlocked = await AppPreferences.isBadgeUnlocked(definition.id);

      rewards.add(
        RewardStatus(
          definition: definition,
          bestScore: bestScore,
          unlocked: unlocked,
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _totalStars = totalStars;
      _completedQuizzes = completedQuizzes;
      _rewards = rewards;
      _isLoading = false;
    });
  }

  int get _unlockedBadges {
    return _rewards.where((reward) => reward.unlocked).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC978),
        foregroundColor: const Color(0xFF4A3212),
        centerTitle: true,
        title: const Text(
          'My Rewards',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRewards,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                children: [
                  _buildHeroCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Badges and Achievements',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4B371C),
                    ),
                  ),
                  const SizedBox(height: 13),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _rewards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          childAspectRatio: 0.83,
                        ),
                    itemBuilder: (context, index) {
                      return _buildRewardCard(_rewards[index]);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD166), Color(0xFFFFB65C)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFFF9A34), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 82)),
          const Text(
            'Little Hero Awards',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color(0xFF573A13),
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: _buildStatistic(
                  emoji: '⭐',
                  value: '$_totalStars',
                  label: 'Total Stars',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _buildStatistic(
                  emoji: '🎖️',
                  value: '$_unlockedBadges/${rewardDefinitions.length}',
                  label: 'Badges',
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _buildStatistic(
                  emoji: '✅',
                  value: '$_completedQuizzes',
                  label: 'Quizzes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 29)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(RewardStatus reward) {
    final unlocked = reward.unlocked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFFFF0B8) : const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: unlocked ? const Color(0xFFFFB52E) : const Color(0xFFB5B5B5),
          width: 3,
        ),
        boxShadow: unlocked
            ? const [
                BoxShadow(
                  color: Color(0x33FFAA00),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                reward.definition.emoji,
                style: TextStyle(
                  fontSize: 61,
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              if (!unlocked)
                const Icon(
                  Icons.lock_rounded,
                  size: 42,
                  color: Color(0xFF696969),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            reward.definition.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 17,
              height: 1.15,
              fontWeight: FontWeight.w900,
              color: unlocked
                  ? const Color(0xFF563B12)
                  : const Color(0xFF696969),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            reward.definition.subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: unlocked
                  ? const Color(0xFFFFD35E)
                  : const Color(0xFFCACACA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              unlocked
                  ? '⭐ ${reward.bestScore}/'
                        '${reward.definition.maximumScore}'
                  : 'Locked',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
