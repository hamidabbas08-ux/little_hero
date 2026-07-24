import 'package:flutter/material.dart';

import '../data/story_item.dart';
import 'story_reader_screen.dart';

class StoriesLibraryScreen extends StatelessWidget {
  const StoriesLibraryScreen({super.key});

  void _openStory(BuildContext context, StoryItem story) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => StoryReaderScreen(story: story)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCDB4FF),
        foregroundColor: const Color(0xFF35284F),
        centerTitle: true,
        title: const Text(
          'Story Time',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          children: [
            const Text(
              'Choose a Story 📚',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w900,
                color: Color(0xFF49386B),
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Listen, read and learn a good lesson.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6D6280),
              ),
            ),
            const SizedBox(height: 22),
            ...learningStories.asMap().entries.map((entry) {
              final index = entry.key;
              final story = entry.value;

              final colors = <Color>[
                const Color(0xFFFFD166),
                const Color(0xFFFFA8A8),
                const Color(0xFF8DE4AF),
                const Color(0xFF9ED9FF),
                const Color(0xFFFFB56B),
                const Color(0xFFCDB4FF),
              ];

              final cardColor = colors[index % colors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: cardColor,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openStory(context, story),
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Row(
                        children: [
                          Container(
                            width: 92,
                            height: 92,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.72),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                story.coverEmoji,
                                style: const TextStyle(fontSize: 55),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF392E39),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  story.subtitle,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5D505D),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${story.pages.length} pages • Voice story',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            backgroundColor: Color(0xFF6C52B3),
                            foregroundColor: Colors.white,
                            child: Icon(Icons.play_arrow_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
