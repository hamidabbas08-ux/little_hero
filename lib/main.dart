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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
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
                      onPressed: null,
                      icon: Icon(Icons.settings_rounded, size: 30),
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
                  childAspectRatio: 1.0,
                  children: const [
                    LearningCard(
                      title: 'Alphabet',
                      subtitle: 'A B C',
                      emoji: '🔤',
                      color: Color(0xFFFFD166),
                    ),
                    LearningCard(
                      title: 'Numbers',
                      subtitle: '1 2 3',
                      emoji: '🔢',
                      color: Color(0xFF8DE4AF),
                    ),
                    LearningCard(
                      title: 'Colors',
                      subtitle: 'Learn colors',
                      emoji: '🎨',
                      color: Color(0xFFFF9EB5),
                    ),
                    LearningCard(
                      title: 'Shapes',
                      subtitle: 'Circle & Square',
                      emoji: '🔺',
                      color: Color(0xFF9ED9FF),
                    ),
                    LearningCard(
                      title: 'Stories',
                      subtitle: 'Listen & read',
                      emoji: '📚',
                      color: Color(0xFFCDB4FF),
                    ),
                    LearningCard(
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

class LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;

  const LearningCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
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
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title is coming next!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 56),
                        ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
