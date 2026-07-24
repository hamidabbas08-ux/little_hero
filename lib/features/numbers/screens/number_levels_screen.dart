import 'package:flutter/material.dart';

import 'number_lesson_screen.dart';

class NumberLevel {
  final int level;
  final int startNumber;
  final int endNumber;
  final String emoji;
  final Color color;
  final bool unlocked;

  const NumberLevel({
    required this.level,
    required this.startNumber,
    required this.endNumber,
    required this.emoji,
    required this.color,
    required this.unlocked,
  });
}

const List<NumberLevel> numberLevels = [
  NumberLevel(
    level: 1,
    startNumber: 1,
    endNumber: 20,
    emoji: '⭐',
    color: Color(0xFF61D095),
    unlocked: true,
  ),
  NumberLevel(
    level: 2,
    startNumber: 21,
    endNumber: 40,
    emoji: '🚀',
    color: Color(0xFF80C7FF),
    unlocked: false,
  ),
  NumberLevel(
    level: 3,
    startNumber: 41,
    endNumber: 60,
    emoji: '🌈',
    color: Color(0xFFFFA8C3),
    unlocked: false,
  ),
  NumberLevel(
    level: 4,
    startNumber: 61,
    endNumber: 80,
    emoji: '🏆',
    color: Color(0xFFFFCF62),
    unlocked: false,
  ),
  NumberLevel(
    level: 5,
    startNumber: 81,
    endNumber: 100,
    emoji: '👑',
    color: Color(0xFFC7ACFF),
    unlocked: false,
  ),
];

class NumberLevelsScreen extends StatelessWidget {
  const NumberLevelsScreen({super.key});

  void _openLevel(BuildContext context, NumberLevel level) {
    if (!level.unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complete Level ${level.level - 1} first.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => NumberLessonScreen(
          level: level.level,
          startNumber: level.startNumber,
          endNumber: level.endNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF61D095),
        foregroundColor: const Color(0xFF153D29),
        centerTitle: true,
        title: const Text(
          'Number Adventure',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          children: [
            const Text(
              'Choose Your Level',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF264D39),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Listen, learn and count from 1 to 100!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF567464),
              ),
            ),
            const SizedBox(height: 22),
            ...numberLevels.map((level) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _NumberLevelCard(
                  level: level,
                  onTap: () => _openLevel(context, level),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NumberLevelCard extends StatelessWidget {
  final NumberLevel level;
  final VoidCallback onTap;

  const _NumberLevelCard({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: level.unlocked ? level.color : const Color(0xFFE0E4E2),
      elevation: level.unlocked ? 5 : 1,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  level.unlocked ? level.emoji : '🔒',
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${level.level}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: level.unlocked
                            ? const Color(0xFF24352C)
                            : const Color(0xFF777D79),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Numbers ${level.startNumber}–${level.endNumber}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: level.unlocked
                            ? const Color(0xFF314D3E)
                            : const Color(0xFF898E8B),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      level.unlocked
                          ? 'Tap to start with sound'
                          : 'Complete the previous level',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: level.unlocked
                            ? const Color(0xFF3E6450)
                            : const Color(0xFF949895),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                level.unlocked
                    ? Icons.play_circle_fill_rounded
                    : Icons.lock_rounded,
                size: 39,
                color: level.unlocked
                    ? const Color(0xFF24573C)
                    : const Color(0xFF8E9490),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
