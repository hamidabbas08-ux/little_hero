import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'alphabet_quiz_screen.dart';

class AlphabetItem {
  final String letter;
  final String word;
  final String picture;
  final Color primaryColor;
  final Color secondaryColor;

  const AlphabetItem({
    required this.letter,
    required this.word,
    required this.picture,
    required this.primaryColor,
    required this.secondaryColor,
  });

  String get sentence => '$letter. $letter for $word. $word.';
}

const List<AlphabetItem> alphabetItems = [
  AlphabetItem(
    letter: 'A',
    word: 'Apple',
    picture: '🍎',
    primaryColor: Color(0xFFFF6B6B),
    secondaryColor: Color(0xFFFFE0E0),
  ),
  AlphabetItem(
    letter: 'B',
    word: 'Ball',
    picture: '⚽',
    primaryColor: Color(0xFF4D96FF),
    secondaryColor: Color(0xFFDDEEFF),
  ),
  AlphabetItem(
    letter: 'C',
    word: 'Cat',
    picture: '🐱',
    primaryColor: Color(0xFFFF9F43),
    secondaryColor: Color(0xFFFFE8CE),
  ),
  AlphabetItem(
    letter: 'D',
    word: 'Dog',
    picture: '🐶',
    primaryColor: Color(0xFF9B6B43),
    secondaryColor: Color(0xFFF1E1D2),
  ),
  AlphabetItem(
    letter: 'E',
    word: 'Elephant',
    picture: '🐘',
    primaryColor: Color(0xFF7B8FA1),
    secondaryColor: Color(0xFFE2EBF1),
  ),
  AlphabetItem(
    letter: 'F',
    word: 'Fish',
    picture: '🐟',
    primaryColor: Color(0xFF00A8CC),
    secondaryColor: Color(0xFFD8F7FF),
  ),
  AlphabetItem(
    letter: 'G',
    word: 'Grapes',
    picture: '🍇',
    primaryColor: Color(0xFF8E44AD),
    secondaryColor: Color(0xFFF0DAFA),
  ),
  AlphabetItem(
    letter: 'H',
    word: 'House',
    picture: '🏠',
    primaryColor: Color(0xFFE67E22),
    secondaryColor: Color(0xFFFFE7D3),
  ),
  AlphabetItem(
    letter: 'I',
    word: 'Ice Cream',
    picture: '🍦',
    primaryColor: Color(0xFFFF77A9),
    secondaryColor: Color(0xFFFFE0EC),
  ),
  AlphabetItem(
    letter: 'J',
    word: 'Juice',
    picture: '🧃',
    primaryColor: Color(0xFFFF8C42),
    secondaryColor: Color(0xFFFFE8D4),
  ),
  AlphabetItem(
    letter: 'K',
    word: 'Kite',
    picture: '🪁',
    primaryColor: Color(0xFF6C63FF),
    secondaryColor: Color(0xFFE5E2FF),
  ),
  AlphabetItem(
    letter: 'L',
    word: 'Lion',
    picture: '🦁',
    primaryColor: Color(0xFFF4B942),
    secondaryColor: Color(0xFFFFF0C9),
  ),
  AlphabetItem(
    letter: 'M',
    word: 'Mango',
    picture: '🥭',
    primaryColor: Color(0xFFFFB000),
    secondaryColor: Color(0xFFFFF0BE),
  ),
  AlphabetItem(
    letter: 'N',
    word: 'Nest',
    picture: '🪺',
    primaryColor: Color(0xFF8B5E3C),
    secondaryColor: Color(0xFFF1E1D4),
  ),
  AlphabetItem(
    letter: 'O',
    word: 'Orange',
    picture: '🍊',
    primaryColor: Color(0xFFFF7A00),
    secondaryColor: Color(0xFFFFE0BD),
  ),
  AlphabetItem(
    letter: 'P',
    word: 'Parrot',
    picture: '🦜',
    primaryColor: Color(0xFF27AE60),
    secondaryColor: Color(0xFFDDF5E7),
  ),
  AlphabetItem(
    letter: 'Q',
    word: 'Queen',
    picture: '👸',
    primaryColor: Color(0xFFC039C7),
    secondaryColor: Color(0xFFF5DDF7),
  ),
  AlphabetItem(
    letter: 'R',
    word: 'Rabbit',
    picture: '🐰',
    primaryColor: Color(0xFFFF8FAB),
    secondaryColor: Color(0xFFFFE5EC),
  ),
  AlphabetItem(
    letter: 'S',
    word: 'Sun',
    picture: '☀️',
    primaryColor: Color(0xFFFFC107),
    secondaryColor: Color(0xFFFFF3C4),
  ),
  AlphabetItem(
    letter: 'T',
    word: 'Tiger',
    picture: '🐯',
    primaryColor: Color(0xFFFF8A00),
    secondaryColor: Color(0xFFFFE4C2),
  ),
  AlphabetItem(
    letter: 'U',
    word: 'Umbrella',
    picture: '☂️',
    primaryColor: Color(0xFF3498DB),
    secondaryColor: Color(0xFFDDEFFF),
  ),
  AlphabetItem(
    letter: 'V',
    word: 'Van',
    picture: '🚐',
    primaryColor: Color(0xFF607D8B),
    secondaryColor: Color(0xFFE0E8EC),
  ),
  AlphabetItem(
    letter: 'W',
    word: 'Watermelon',
    picture: '🍉',
    primaryColor: Color(0xFF2EAD63),
    secondaryColor: Color(0xFFDDF6E8),
  ),
  AlphabetItem(
    letter: 'X',
    word: 'Xylophone',
    picture: '🎶',
    primaryColor: Color(0xFF9C6ADE),
    secondaryColor: Color(0xFFEDE2FC),
  ),
  AlphabetItem(
    letter: 'Y',
    word: 'Yacht',
    picture: '⛵',
    primaryColor: Color(0xFF169ED9),
    secondaryColor: Color(0xFFDDF4FF),
  ),
  AlphabetItem(
    letter: 'Z',
    word: 'Zebra',
    picture: '🦓',
    primaryColor: Color(0xFF444444),
    secondaryColor: Color(0xFFE8E8E8),
  ),
];

class AlphabetLessonScreen extends StatefulWidget {
  const AlphabetLessonScreen({super.key});

  @override
  State<AlphabetLessonScreen> createState() => _AlphabetLessonScreenState();
}

class _AlphabetLessonScreenState extends State<AlphabetLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _pictureAnimation;

  int _currentIndex = 0;
  bool _isSpeaking = false;

  AlphabetItem get _item => alphabetItems[_currentIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _pictureAnimation = Tween<double>(begin: 1, end: 1.12).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _configureTts();
  }

  Future<void> _configureTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.stop();

    if (mounted) {
      setState(() {
        _isSpeaking = true;
      });
    }

    try {
      await _flutterTts.speak(text);
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _speakLesson() async {
    _animationController.forward(from: 0);
    await _speak(_item.sentence);
  }

  Future<void> _speakLetter() async {
    await _speak(_item.letter);
  }

  Future<void> _speakWord() async {
    _animationController.forward(from: 0);
    await _speak(_item.word);
  }

  Future<void> _changeLesson(int newIndex) async {
    if (newIndex < 0 || newIndex >= alphabetItems.length) {
      return;
    }

    await _flutterTts.stop();

    setState(() {
      _currentIndex = newIndex;
      _isSpeaking = false;
    });

    _animationController.forward(from: 0);

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _speakLesson();
    }
  }

  void _showAlphabetPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFF9E6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: Column(
              children: [
                const Text(
                  'Choose a Letter',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: alphabetItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final item = alphabetItems[index];
                      final selected = index == _currentIndex;

                      return Material(
                        color: selected
                            ? item.primaryColor
                            : item.secondaryColor,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.pop(context);
                            _changeLesson(index);
                          },
                          child: Center(
                            child: Text(
                              item.letter,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF29243A),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD166),
        foregroundColor: const Color(0xFF28233A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Alphabet Adventure',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Start quiz',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const AlphabetQuizScreen(),
                ),
              );
            },
            icon: const Icon(Icons.quiz_rounded, size: 28),
          ),
          IconButton(
            tooltip: 'Choose letter',
            onPressed: _showAlphabetPicker,
            icon: const Icon(Icons.apps_rounded, size: 29),
          ),
          IconButton(
            tooltip: 'Listen',
            onPressed: _speakLesson,
            icon: Icon(
              _isSpeaking
                  ? Icons.graphic_eq_rounded
                  : Icons.record_voice_over_rounded,
              size: 29,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            children: [
              _buildProgress(),
              const SizedBox(height: 16),
              _buildLessonCard(item),
              const SizedBox(height: 18),
              _buildEncouragement(),
              const SizedBox(height: 20),
              _buildNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Text(
          'Lesson ${_currentIndex + 1} of ${alphabetItems.length}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF514A69),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: (_currentIndex + 1) / alphabetItems.length,
              backgroundColor: const Color(0xFFFFE9A8),
              valueColor: AlwaysStoppedAnimation<Color>(_item.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${_item.letter} ⭐',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildLessonCard(AlphabetItem item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, item.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: item.primaryColor, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Tap the letter or picture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF625B71),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: _speakLetter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD166),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: item.primaryColor, width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                item.letter,
                style: const TextStyle(
                  fontSize: 104,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF392F5A),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ScaleTransition(
            scale: _pictureAnimation,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: _speakWord,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: double.infinity,
                height: 260,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.secondaryColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: item.primaryColor, width: 3),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.picture,
                    style: const TextStyle(fontSize: 170),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.letter,
                    style: TextStyle(color: item.primaryColor),
                  ),
                  const TextSpan(text: ' for '),
                  TextSpan(
                    text: item.word,
                    style: TextStyle(color: item.primaryColor),
                  ),
                ],
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Color(0xFF28233A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _speakLesson,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              minimumSize: const Size(220, 58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            icon: Icon(
              _isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              size: 30,
            ),
            label: Text(
              _isSpeaking ? 'Speaking...' : 'Listen again',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragement() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF7E8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF82D9A6), width: 2),
      ),
      child: Row(
        children: [
          const Text('🦸', style: TextStyle(fontSize: 44)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _currentIndex == alphabetItems.length - 1
                  ? 'Amazing! You reached Z, Little Hero!'
                  : 'Great job! Learn ${_item.letter} and tap Next for the next letter.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w800,
                color: Color(0xFF295A3C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == alphabetItems.length - 1;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirst
                ? () => Navigator.pop(context)
                : () => _changeLesson(_currentIndex - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(
              isFirst ? 'Home' : 'Previous',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: isLast
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Excellent! You completed A to Z!'),
                      ),
                    );
                  }
                : () => _changeLesson(_currentIndex + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: isLast
                  ? const Color(0xFF31A66A)
                  : const Color(0xFFFF7A59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: Icon(
              isLast ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
            ),
            label: Text(
              isLast ? 'Finish' : 'Next',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
