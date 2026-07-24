import 'package:flutter/material.dart';

import 'features/alphabet/screens/alphabet_lesson_screen.dart';
import 'features/numbers/screens/number_levels_screen.dart';
import 'features/colors/screens/color_lesson_screen.dart';
import 'features/shapes/screens/shape_lesson_screen.dart';
import 'features/animals/screens/animal_lesson_screen.dart';
import 'features/things/screens/everyday_things_screen.dart';

void main() {
  runApp(const LittleHeroApp());
}

class LittleHeroApp extends StatelessWidget {
  const LittleHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Little Hero',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCard(BuildContext context, String title) {
    if (title == 'Alphabet') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const AlphabetLessonScreen()),
      );
      return;
    }

    if (title == 'Numbers') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const NumberLevelsScreen()),
      );
      return;
    }

    if (title == 'Colors') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const ColorLessonScreen()),
      );
      return;
    }

    if (title == 'Shapes') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const ShapeLessonScreen()),
      );
      return;
    }

    if (title == 'Animals') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const AnimalLessonScreen()),
      );
      return;
    }

    if (title == 'Everyday Things') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const EverydayThingsScreen()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title is coming next!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBDEBFF), Color(0xFFFFF4C7)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Text('🦸', style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Little Hero',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Play • Learn • Grow',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_rounded, size: 30),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, Little Hero! 👋',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1,
                  children: [
                    LearningCard(
                      title: 'Alphabet',
                      subtitle: 'A B C',
                      emoji: '🔤',
                      color: const Color(0xFFFFD166),
                      onTap: () => _openCard(context, 'Alphabet'),
                    ),
                    LearningCard(
                      title: 'Numbers',
                      subtitle: '1 2 3',
                      emoji: '🔢',
                      color: const Color(0xFF8DE4AF),
                      onTap: () => _openCard(context, 'Numbers'),
                    ),
                    LearningCard(
                      title: 'Colors',
                      subtitle: 'Learn colors',
                      emoji: '🎨',
                      color: const Color(0xFFFF9EB5),
                      onTap: () => _openCard(context, 'Colors'),
                    ),
                    LearningCard(
                      title: 'Shapes',
                      subtitle: 'Circle & Square',
                      emoji: '🔺',
                      color: const Color(0xFF9ED9FF),
                      onTap: () => _openCard(context, 'Shapes'),
                    ),
                    LearningCard(
                      title: 'Animals',
                      subtitle: 'Wild & pet animals',
                      emoji: '🦁',
                      color: const Color(0xFFFFB56B),
                      onTap: () => _openCard(context, 'Animals'),
                    ),
                    LearningCard(
                      title: 'Everyday Things',
                      subtitle: 'Furniture & objects',
                      emoji: '🪑',
                      color: const Color(0xFF82D8EA),
                      onTap: () => _openCard(context, 'Everyday Things'),
                    ),
                    LearningCard(
                      title: 'Stories',
                      subtitle: 'Listen & read',
                      emoji: '📚',
                      color: const Color(0xFFCDB4FF),
                      onTap: () => _openCard(context, 'Stories'),
                    ),
                    LearningCard(
                      title: 'Rewards',
                      subtitle: 'Stars & badges',
                      emoji: '🏆',
                      color: const Color(0xFFFFC978),
                      onTap: () => _openCard(context, 'Rewards'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const LearningCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 4,
      borderRadius: BorderRadius.circular(26),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(emoji, style: const TextStyle(fontSize: 56)),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 18,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
