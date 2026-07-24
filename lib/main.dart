import 'package:flutter/material.dart';

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
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                  children: [
                    _LearningCard(
                      title: 'Alphabet',
                      subtitle: 'A B C',
                      emoji: '🔤',
                      color: Color(0xFFFFD166),
                    ),
                    _LearningCard(
                      title: 'Numbers',
                      subtitle: '1 2 3',
                      emoji: '🔢',
                      color: Color(0xFF8DE4AF),
                    ),
                    _LearningCard(
                      title: 'Colors',
                      subtitle: 'Learn colors',
                      emoji: '🎨',
                      color: Color(0xFFFF9EB5),
                    ),
                    _LearningCard(
                      title: 'Shapes',
                      subtitle: 'Circle & Square',
                      emoji: '🔺',
                      color: Color(0xFF9ED9FF),
                    ),
                    _LearningCard(
                      title: 'Stories',
                      subtitle: 'Listen & read',
                      emoji: '📚',
                      color: Color(0xFFCDB4FF),
                    ),
                    _LearningCard(
                      title: 'Rewards',
                      subtitle: 'Stars & badges',
                      emoji: '🏆',
                      color: Color(0xFFFFC978),
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

class _LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;

  const _LearningCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(26),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title is coming next!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 54)),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
