import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizColorItem {
  final String name;
  final String objectName;
  final String emoji;
  final Color color;
  final Color textColor;

  const QuizColorItem({
    required this.name,
    required this.objectName,
    required this.emoji,
    required this.color,
    required this.textColor,
  });
}

const List<QuizColorItem> quizColors = [
  QuizColorItem(
    name: 'Red',
    objectName: 'Apple',
    emoji: '🍎',
    color: Color(0xFFE53935),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Blue',
    objectName: 'Blue Whale',
    emoji: '🐋',
    color: Color(0xFF1E88E5),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Green',
    objectName: 'Leaf',
    emoji: '🍃',
    color: Color(0xFF43A047),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Yellow',
    objectName: 'Sun',
    emoji: '☀️',
    color: Color(0xFFFFD600),
    textColor: Color(0xFF4A3D00),
  ),
  QuizColorItem(
    name: 'Orange',
    objectName: 'Orange',
    emoji: '🍊',
    color: Color(0xFFFF8A00),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Purple',
    objectName: 'Grapes',
    emoji: '🍇',
    color: Color(0xFF8E44AD),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Pink',
    objectName: 'Flower',
    emoji: '🌸',
    color: Color(0xFFFF70A6),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Brown',
    objectName: 'Bear',
    emoji: '🐻',
    color: Color(0xFF8D5A3B),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Black',
    objectName: 'Black Cat',
    emoji: '🐈‍⬛',
    color: Color(0xFF202124),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'White',
    objectName: 'Cloud',
    emoji: '☁️',
    color: Color(0xFFF8F9FA),
    textColor: Color(0xFF303238),
  ),
  QuizColorItem(
    name: 'Gray',
    objectName: 'Elephant',
    emoji: '🐘',
    color: Color(0xFF858B93),
    textColor: Colors.white,
  ),
  QuizColorItem(
    name: 'Cyan',
    objectName: 'Water Drop',
    emoji: '💧',
    color: Color(0xFF00BCD4),
    textColor: Color(0xFF063E45),
  ),
];

enum ColorQuestionType { identifyColor, identifyObjectColor }

class ColorQuizQuestion {
  final QuizColorItem answer;
  final ColorQuestionType type;
  final List<QuizColorItem> options;

  const ColorQuizQuestion({
    required this.answer,
    required this.type,
    required this.options,
  });
}

class ColorQuizScreen extends StatefulWidget {
  const ColorQuizScreen({super.key});

  @override
  State<ColorQuizScreen> createState() => _ColorQuizScreenState();
}

class _ColorQuizScreenState extends State<ColorQuizScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;

  final Random _random = Random();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  List<ColorQuizQuestion> _questions = [];

  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;

  String? _selectedAnswer;

  bool _answerLocked = false;
  bool _showHint = false;
  bool _quizFinished = false;
  bool _musicEnabled = true;
  bool _soundEnabled = true;

  ColorQuizQuestion get _question => _questions[_questionIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _bounceAnimation = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _createQuestions();
    _configureAudio();
  }

  void _createQuestions() {
    final shuffledColors = List<QuizColorItem>.from(quizColors)
      ..shuffle(_random);

    _questions = List<ColorQuizQuestion>.generate(totalQuestions, (index) {
      final answer = shuffledColors[index % shuffledColors.length];

      final wrongOptions =
          quizColors.where((item) => item.name != answer.name).toList()
            ..shuffle(_random);

      final options = <QuizColorItem>[answer, ...wrongOptions.take(3)]
        ..shuffle(_random);

      return ColorQuizQuestion(
        answer: answer,
        type: index.isEven
            ? ColorQuestionType.identifyColor
            : ColorQuestionType.identifyObjectColor,
        options: options,
      );
    });
  }

  Future<void> _configureAudio() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.39);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.12);

    if (_musicEnabled) {
      await _musicPlayer.play(
        AssetSource('audio/music/alphabet_quiz_music.wav'),
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (mounted) {
      await _speakQuestion();
    }
  }

  Future<void> _speakQuestion() async {
    if (!_soundEnabled || _quizFinished) {
      return;
    }

    if (_musicEnabled) {
      await _musicPlayer.setVolume(0.03);
    }

    await _flutterTts.stop();

    if (_question.type == ColorQuestionType.identifyColor) {
      await _flutterTts.speak(
        'What color is this? Tap the correct color name.',
      );
    } else {
      await _flutterTts.speak(
        'What color is the ${_question.answer.objectName}? '
        'Tap the correct answer.',
      );
    }

    if (_musicEnabled && mounted) {
      await _musicPlayer.setVolume(0.12);
    }
  }

  Future<void> _playEffect(String asset) async {
    if (!_soundEnabled) {
      return;
    }

    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource(asset));
  }

  Future<void> _selectAnswer(QuizColorItem selected) async {
    if (_answerLocked || _quizFinished) {
      return;
    }

    setState(() {
      _selectedAnswer = selected.name;
    });

    if (selected.name == _question.answer.name) {
      setState(() {
        _answerLocked = true;
        _showHint = false;
        _score++;
      });

      _animationController.forward(from: 0);

      await _playEffect('audio/effects/correct.wav');

      if (_soundEnabled) {
        await _flutterTts.speak(
          'Great job! The answer is ${_question.answer.name}.',
        );
      }

      await Future<void>.delayed(const Duration(milliseconds: 850));

      if (!mounted) {
        return;
      }

      if (_questionIndex == totalQuestions - 1) {
        await _finishQuiz();
      } else {
        _nextQuestion();
      }
    } else {
      setState(() {
        _wrongAttempts++;

        if (_wrongAttempts >= 2) {
          _showHint = true;
        }
      });

      await _playEffect('audio/effects/try_again.wav');

      if (_soundEnabled) {
        await _flutterTts.speak(
          _showHint ? 'Look for the glowing color.' : 'Nice try. Try again.',
        );
      }
    }
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      _wrongAttempts = 0;
      _selectedAnswer = null;
      _answerLocked = false;
      _showHint = false;
    });

    _animationController.forward(from: 0);

    Future<void>.delayed(const Duration(milliseconds: 350), _speakQuestion);
  }

  Future<void> _finishQuiz() async {
    await _musicPlayer.stop();

    setState(() {
      _quizFinished = true;
    });

    await _playEffect('audio/effects/quiz_complete.wav');

    if (_soundEnabled) {
      await _flutterTts.speak(
        'Wonderful! You completed the colors quiz. '
        'You got $_score stars.',
      );
    }
  }

  Future<void> _restartQuiz() async {
    await _flutterTts.stop();
    await _effectPlayer.stop();

    setState(() {
      _questionIndex = 0;
      _score = 0;
      _wrongAttempts = 0;
      _selectedAnswer = null;
      _answerLocked = false;
      _showHint = false;
      _quizFinished = false;
      _createQuestions();
    });

    if (_musicEnabled) {
      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.12);
      await _musicPlayer.play(
        AssetSource('audio/music/alphabet_quiz_music.wav'),
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 400));

    await _speakQuestion();
  }

  Future<void> _toggleMusic() async {
    setState(() {
      _musicEnabled = !_musicEnabled;
    });

    if (_musicEnabled && !_quizFinished) {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.12);
      await _musicPlayer.play(
        AssetSource('audio/music/alphabet_quiz_music.wav'),
      );
    } else {
      await _musicPlayer.stop();
    }
  }

  void _toggleSound() {
    setState(() {
      _soundEnabled = !_soundEnabled;
    });

    if (!_soundEnabled) {
      _flutterTts.stop();
      _effectPlayer.stop();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _musicPlayer.dispose();
    _effectPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9EB5),
        foregroundColor: const Color(0xFF4B2431),
        centerTitle: true,
        title: const Text(
          'Colors Quiz',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Music',
            onPressed: _toggleMusic,
            icon: Icon(
              _musicEnabled
                  ? Icons.music_note_rounded
                  : Icons.music_off_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Voice and sounds',
            onPressed: _toggleSound,
            icon: Icon(
              _soundEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _quizFinished ? _buildResultScreen() : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Question ${_questionIndex + 1}/$totalQuestions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 13,
                    value: (_questionIndex + 1) / totalQuestions,
                    backgroundColor: const Color(0xFFFFD9E3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6F9C),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '⭐ $_score',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: _question.answer.color, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x25000000),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _question.type == ColorQuestionType.identifyColor
                      ? 'What color is this?'
                      : 'What color is the ${_question.answer.objectName}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4D3440),
                  ),
                ),
                const SizedBox(height: 18),
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 245,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _question.type == ColorQuestionType.identifyColor
                          ? _question.answer.color
                          : _question.answer.color.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _question.answer.color,
                        width: 3,
                      ),
                    ),
                    child: _question.type == ColorQuestionType.identifyColor
                        ? const Icon(
                            Icons.palette_rounded,
                            size: 120,
                            color: Colors.white,
                          )
                        : Text(
                            _question.answer.emoji,
                            style: const TextStyle(fontSize: 150),
                          ),
                  ),
                ),
                const SizedBox(height: 11),
                TextButton.icon(
                  onPressed: _speakQuestion,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text(
                    'Hear question again',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _question.options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) {
              return _buildAnswerButton(_question.options[index]);
            },
          ),
          const SizedBox(height: 18),
          _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(QuizColorItem option) {
    final isCorrect = option.name == _question.answer.name;
    final isSelected = option.name == _selectedAnswer;

    final revealCorrect = _answerLocked && isCorrect;
    final showWrong = isSelected && !isCorrect;
    final showHint = _showHint && isCorrect;

    Color border = option.color;
    Color background = option.color;
    Color foreground = option.textColor;

    if (revealCorrect || showHint) {
      border = const Color(0xFF2DAF68);
    } else if (showWrong) {
      border = const Color(0xFFFF3D55);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: border,
          width: revealCorrect || showHint || showWrong ? 6 : 3,
        ),
        boxShadow: showHint
            ? const [
                BoxShadow(
                  color: Color(0x6637B66A),
                  blurRadius: 18,
                  spreadRadius: 3,
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 9,
                  offset: Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAnswer(option),
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  revealCorrect || showHint
                      ? Icons.check_circle_rounded
                      : Icons.circle,
                  color: foreground,
                  size: 27,
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    String icon = '🦸';
    String text = 'Choose the correct color.';
    Color background = const Color(0xFFEDE6FF);
    Color border = const Color(0xFFAC91E8);

    if (_answerLocked) {
      icon = '🎉';
      text = 'Great job, Little Hero!';
      background = const Color(0xFFDDF7E8);
      border = const Color(0xFF65C98C);
    } else if (_selectedAnswer != null) {
      icon = _showHint ? '💡' : '💪';
      text = _showHint ? 'Look for the glowing color!' : 'Nice try! Try again.';
      background = const Color(0xFFFFEEC7);
      border = const Color(0xFFFFC857);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 37)),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    String title;
    String trophy;

    if (_score >= 9) {
      title = 'Color Champion!';
      trophy = '🏆';
    } else if (_score >= 7) {
      title = 'Amazing Work!';
      trophy = '🥇';
    } else if (_score >= 5) {
      title = 'Great Effort!';
      trophy = '⭐';
    } else {
      title = 'Keep Practising!';
      trophy = '💪';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFFE0E9)],
            ),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFFFF6F9C), width: 4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 18,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(trophy, style: const TextStyle(fontSize: 100)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF503041),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                '$_score / $totalQuestions',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6C52B3),
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: List<Widget>.generate(
                  totalQuestions,
                  (index) => Text(
                    index < _score ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              FilledButton.icon(
                onPressed: _restartQuiz,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C52B3),
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.replay_rounded),
                label: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: Color(0xFFFF6F9C), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.palette_rounded),
                label: const Text(
                  'Back to Colors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
