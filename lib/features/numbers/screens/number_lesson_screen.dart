import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/number_words.dart';
import 'number_quiz_screen.dart';

class NumberLessonScreen extends StatefulWidget {
  final int level;
  final int startNumber;
  final int endNumber;

  const NumberLessonScreen({
    required this.level,
    required this.startNumber,
    required this.endNumber,
    super.key,
  });

  @override
  State<NumberLessonScreen> createState() => _NumberLessonScreenState();
}

class _NumberLessonScreenState extends State<NumberLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _numberAnimation;

  late int _currentNumber;
  bool _isSpeaking = false;

  String get _numberName => numberToWords(_currentNumber);

  int get _lessonPosition {
    return _currentNumber - widget.startNumber + 1;
  }

  int get _lessonCount {
    return widget.endNumber - widget.startNumber + 1;
  }

  @override
  void initState() {
    super.initState();

    _currentNumber = widget.startNumber;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _numberAnimation = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _configureVoice();
    _animationController.forward();
  }

  Future<void> _configureVoice() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    await Future<void>.delayed(const Duration(milliseconds: 500));

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

  Future<void> _speakNumber() async {
    _animationController.forward(from: 0);

    await _speak('$_currentNumber. $_numberName.');
  }

  Future<void> _speakLesson() async {
    _animationController.forward(from: 0);

    if (_currentNumber <= 20) {
      await _speak(
        '$_numberName. This is number $_numberName. '
        'Tap the stars and count $_numberName stars.',
      );
      return;
    }

    final tens = _currentNumber ~/ 10;
    final ones = _currentNumber % 10;

    if (ones == 0) {
      await _speak(
        '$_numberName. This is number $_numberName. '
        'It has $tens groups of ten.',
      );
    } else {
      await _speak(
        '$_numberName. This is number $_numberName. '
        'It has $tens groups of ten and $ones extra.',
      );
    }
  }

  Future<void> _speakCounting() async {
    _animationController.forward(from: 0);

    if (_currentNumber <= 20) {
      final counting = List<String>.generate(
        _currentNumber,
        (index) => '${index + 1}',
      ).join(', ');

      await _speak(
        'Let us count. $counting. '
        'Excellent! There are $_numberName stars.',
      );
      return;
    }

    final tens = _currentNumber ~/ 10;
    final ones = _currentNumber % 10;

    if (ones == 0) {
      await _speak(
        'Let us count by groups. '
        '$tens groups of ten make $_numberName.',
      );
    } else {
      await _speak(
        'Let us count by groups. '
        '$tens groups of ten and $ones extra '
        'make $_numberName.',
      );
    }
  }

  Future<void> _changeNumber(int number) async {
    if (number < widget.startNumber || number > widget.endNumber) {
      return;
    }

    await _flutterTts.stop();

    setState(() {
      _currentNumber = number;
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

  void _showNumberPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFAE8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            child: Column(
              children: [
                Text(
                  'Level ${widget.level}: '
                  '${widget.startNumber}–${widget.endNumber}',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: _lessonCount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 11,
                          mainAxisSpacing: 11,
                        ),
                    itemBuilder: (context, index) {
                      final number = widget.startNumber + index;
                      final selected = number == _currentNumber;

                      return Material(
                        color: selected
                            ? const Color(0xFF35B779)
                            : const Color(0xFFDDF7E8),
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _changeNumber(number);
                          },
                          child: Center(
                            child: Text(
                              '$number',
                              style: TextStyle(
                                fontSize: number >= 100 ? 23 : 27,
                                fontWeight: FontWeight.w900,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF235B3C),
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
    final isFirst = _currentNumber == widget.startNumber;
    final isLast = _currentNumber == widget.endNumber;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF61D095),
        foregroundColor: const Color(0xFF153D29),
        centerTitle: true,
        title: Text(
          'Numbers — Level ${widget.level}',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Choose number',
            onPressed: _showNumberPicker,
            icon: const Icon(Icons.apps_rounded, size: 29),
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
              _buildLessonCard(),
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
          '$_lessonPosition / $_lessonCount',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF315B45),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 13,
              value: _lessonPosition / _lessonCount,
              backgroundColor: const Color(0xFFCFF3DF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF22A668),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('⭐', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  Widget _buildLessonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFDDF7E8)],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFF61D095), width: 3),
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
            'Tap the number to hear it',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF496B59),
            ),
          ),
          const SizedBox(height: 15),
          ScaleTransition(
            scale: _numberAnimation,
            child: Material(
              color: const Color(0xFFFFD166),
              elevation: 5,
              borderRadius: BorderRadius.circular(36),
              child: InkWell(
                onTap: _speakNumber,
                borderRadius: BorderRadius.circular(36),
                child: Container(
                  width: 190,
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: const Color(0xFFFF8A42),
                      width: 5,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        '$_currentNumber',
                        style: const TextStyle(
                          fontSize: 112,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF392F5A),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _numberName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF218C5A),
            ),
          ),
          const SizedBox(height: 18),
          Material(
            color: const Color(0xFFFFF8D9),
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              onTap: _speakCounting,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 190),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFFFD166), width: 3),
                ),
                child: _buildCountingObjects(),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Text(
            _currentNumber <= 20
                ? 'Count $_numberName stars'
                : 'Learn tens and ones',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: Color(0xFF5C4A1E),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _speakLesson,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
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

  Widget _buildCountingObjects() {
    if (_currentNumber <= 20) {
      return Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 7,
        runSpacing: 7,
        children: List<Widget>.generate(_currentNumber, (index) {
          return Container(
            width: 43,
            height: 43,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: index.isEven
                  ? const Color(0xFFFFD166)
                  : const Color(0xFFFFA8BD),
              shape: BoxShape.circle,
            ),
            child: const Text('⭐', style: TextStyle(fontSize: 25)),
          );
        }),
      );
    }

    final tens = _currentNumber ~/ 10;
    final ones = _currentNumber % 10;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(tens, (index) {
            return Container(
              width: 72,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF9DE6BD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF38A96B), width: 2),
              ),
              child: const Text(
                '10 ⭐',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            );
          }),
        ),
        if (ones > 0) ...[
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: List<Widget>.generate(ones, (index) {
              return const Text('⭐', style: TextStyle(fontSize: 30));
            }),
          ),
        ],
        const SizedBox(height: 13),
        Text(
          ones == 0
              ? '$tens groups of ten = $_currentNumber'
              : '$tens groups of ten + $ones = $_currentNumber',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF315B45),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation(bool isFirst, bool isLast) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isFirst
                ? () => Navigator.pop(context)
                : () => _changeNumber(_currentNumber - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              side: const BorderSide(color: Color(0xFF218C5A), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(
              isFirst ? 'Levels' : 'Previous',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: isLast
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (_) => NumberQuizScreen(
                          level: widget.level,
                          startNumber: widget.startNumber,
                          endNumber: widget.endNumber,
                        ),
                      ),
                    );
                  }
                : () => _changeNumber(_currentNumber + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              backgroundColor: isLast
                  ? const Color(0xFF6C63FF)
                  : const Color(0xFFFF7A59),
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
