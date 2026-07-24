import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningColor {
  final String name;
  final String objectName;
  final String emoji;
  final Color color;
  final Color textColor;

  const LearningColor({
    required this.name,
    required this.objectName,
    required this.emoji,
    required this.color,
    required this.textColor,
  });
}

const List<LearningColor> learningColors = [
  LearningColor(
    name: 'Red',
    objectName: 'Apple',
    emoji: '🍎',
    color: Color(0xFFE53935),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Blue',
    objectName: 'Blue Whale',
    emoji: '🐋',
    color: Color(0xFF1E88E5),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Green',
    objectName: 'Leaf',
    emoji: '🍃',
    color: Color(0xFF43A047),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Yellow',
    objectName: 'Sun',
    emoji: '☀️',
    color: Color(0xFFFFD600),
    textColor: Color(0xFF4A3D00),
  ),
  LearningColor(
    name: 'Orange',
    objectName: 'Orange',
    emoji: '🍊',
    color: Color(0xFFFF8A00),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Purple',
    objectName: 'Grapes',
    emoji: '🍇',
    color: Color(0xFF8E44AD),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Pink',
    objectName: 'Flower',
    emoji: '🌸',
    color: Color(0xFFFF70A6),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Brown',
    objectName: 'Bear',
    emoji: '🐻',
    color: Color(0xFF8D5A3B),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Black',
    objectName: 'Black Cat',
    emoji: '🐈‍⬛',
    color: Color(0xFF202124),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'White',
    objectName: 'Cloud',
    emoji: '☁️',
    color: Color(0xFFF8F9FA),
    textColor: Color(0xFF303238),
  ),
  LearningColor(
    name: 'Gray',
    objectName: 'Elephant',
    emoji: '🐘',
    color: Color(0xFF858B93),
    textColor: Colors.white,
  ),
  LearningColor(
    name: 'Cyan',
    objectName: 'Water Drop',
    emoji: '💧',
    color: Color(0xFF00BCD4),
    textColor: Color(0xFF063E45),
  ),
];

class ColorLessonScreen extends StatefulWidget {
  const ColorLessonScreen({super.key});

  @override
  State<ColorLessonScreen> createState() => _ColorLessonScreenState();
}

class _ColorLessonScreenState extends State<ColorLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  int _currentIndex = 0;
  bool _isSpeaking = false;

  LearningColor get _currentColor => learningColors[_currentIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _bounceAnimation = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _configureVoice();
  }

  Future<void> _configureVoice() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.39);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (mounted) {
      await _speakLesson();
    }
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

  Future<void> _speakColor() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentColor.name}. '
      'This is the color ${_currentColor.name}.',
    );
  }

  Future<void> _speakObject() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentColor.objectName}. '
      'The ${_currentColor.objectName.toLowerCase()} '
      'is ${_currentColor.name.toLowerCase()}.',
    );
  }

  Future<void> _speakLesson() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentColor.name}. '
      'This is the color ${_currentColor.name}. '
      '${_currentColor.name} for ${_currentColor.objectName}.',
    );
  }

  Future<void> _changeColor(int index) async {
    if (index < 0 || index >= learningColors.length) {
      return;
    }

    await _flutterTts.stop();

    setState(() {
      _currentIndex = index;
      _isSpeaking = false;
    });

    _animationController.forward(from: 0);

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _speakLesson();
    }
  }

  void _showColorPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFBEB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            child: Column(
              children: [
                const Text(
                  'Choose a Color',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 17),
                Expanded(
                  child: GridView.builder(
                    itemCount: learningColors.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 11,
                          mainAxisSpacing: 11,
                          childAspectRatio: 0.92,
                        ),
                    itemBuilder: (context, index) {
                      final item = learningColors[index];
                      final selected = index == _currentIndex;

                      return Material(
                        color: item.color,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _changeColor(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF6C52B3)
                                    : Colors.black12,
                                width: selected ? 5 : 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(height: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: item.textColor,
                                    ),
                                  ),
                                ),
                              ],
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
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == learningColors.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9EB5),
        foregroundColor: const Color(0xFF4B2431),
        centerTitle: true,
        title: const Text(
          'Colors',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Choose color',
            onPressed: _showColorPicker,
            icon: const Icon(Icons.palette_rounded, size: 29),
          ),
          IconButton(
            tooltip: 'Listen again',
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
              const SizedBox(height: 18),
              _buildColorCard(),
              const SizedBox(height: 18),
              _buildMessage(),
              const SizedBox(height: 20),
              _buildNavigation(isFirst, isLast),
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
          '${_currentIndex + 1} / ${learningColors.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF694052),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 13,
              value: (_currentIndex + 1) / learningColors.length,
              backgroundColor: const Color(0xFFFFD9E3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF6F9C),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('🎨', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  Widget _buildColorCard() {
    final item = _currentColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: item.color, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Tap the color or picture',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66545C),
            ),
          ),
          const SizedBox(height: 16),
          ScaleTransition(
            scale: _bounceAnimation,
            child: Material(
              color: item.color,
              elevation: 5,
              borderRadius: BorderRadius.circular(35),
              child: InkWell(
                onTap: _speakColor,
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: double.infinity,
                  height: 205,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.12),
                      width: 3,
                    ),
                  ),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 59,
                      fontWeight: FontWeight.w900,
                      color: item.textColor,
                      shadows: const [
                        Shadow(
                          color: Color(0x33000000),
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Material(
            color: item.color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              onTap: _speakObject,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: item.color.withValues(alpha: 0.65),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 130)),
                    const SizedBox(height: 8),
                    Text(
                      item.objectName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: item.color == const Color(0xFFF8F9FA)
                            ? const Color(0xFF303238)
                            : item.color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${item.name} ${item.objectName}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5F5157),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          FilledButton.icon(
            onPressed: _speakLesson,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C52B3),
              foregroundColor: Colors.white,
              minimumSize: const Size(230, 58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            icon: Icon(
              _isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              size: 29,
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

  Widget _buildMessage() {
    final completed = _currentIndex == learningColors.length - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE6FF),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFAC91E8), width: 2),
      ),
      child: Row(
        children: [
          Text(completed ? '🏆' : '🦸', style: const TextStyle(fontSize: 43)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              completed
                  ? 'Amazing! You learned all the colors.'
                  : '${_currentColor.name} is a beautiful color!',
              style: const TextStyle(
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w900,
                color: Color(0xFF493A76),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(bool isFirst, bool isLast) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirst
                ? () => Navigator.pop(context)
                : () => _changeColor(_currentIndex - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              side: const BorderSide(color: Color(0xFFFF6F9C), width: 2),
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
                        content: Text('Colors Quiz will be added next!'),
                      ),
                    );
                  }
                : () => _changeColor(_currentIndex + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              backgroundColor: isLast
                  ? const Color(0xFF6C52B3)
                  : const Color(0xFFFF6F9C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: Icon(
              isLast ? Icons.quiz_rounded : Icons.arrow_forward_rounded,
            ),
            label: Text(
              isLast ? 'Start Quiz' : 'Next',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
