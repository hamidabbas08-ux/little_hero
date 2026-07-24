import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/shape_item.dart';

enum ShapeQuestionType { identifyShape, identifyExample }

class ShapeQuizQuestion {
  final LearningShape answer;
  final ShapeQuestionType type;
  final List<LearningShape> options;

  const ShapeQuizQuestion({
    required this.answer,
    required this.type,
    required this.options,
  });
}

class ShapeQuizScreen extends StatefulWidget {
  const ShapeQuizScreen({super.key});

  @override
  State<ShapeQuizScreen> createState() => _ShapeQuizScreenState();
}

class _ShapeQuizScreenState extends State<ShapeQuizScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;

  final math.Random _random = math.Random();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  List<ShapeQuizQuestion> _questions = [];

  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;

  String? _selectedAnswer;

  bool _answerLocked = false;
  bool _showHint = false;
  bool _quizFinished = false;
  bool _musicEnabled = true;
  bool _soundEnabled = true;

  ShapeQuizQuestion get _question => _questions[_questionIndex];

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

    _animationController.forward();
    _createQuestions();
    _configureAudio();
  }

  void _createQuestions() {
    final shuffled = List<LearningShape>.from(learningShapes)..shuffle(_random);

    _questions = List<ShapeQuizQuestion>.generate(totalQuestions, (index) {
      final answer = shuffled[index % shuffled.length];

      final wrongOptions =
          learningShapes.where((shape) => shape.name != answer.name).toList()
            ..shuffle(_random);

      final options = <LearningShape>[answer, ...wrongOptions.take(3)]
        ..shuffle(_random);

      return ShapeQuizQuestion(
        answer: answer,
        type: index.isEven
            ? ShapeQuestionType.identifyShape
            : ShapeQuestionType.identifyExample,
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

    if (_question.type == ShapeQuestionType.identifyShape) {
      await _flutterTts.speak(
        'What shape is this? '
        'Tap the correct shape name.',
      );
    } else {
      await _flutterTts.speak(
        'Which shape looks like the '
        '${_question.answer.exampleName}? '
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

  Future<void> _selectAnswer(LearningShape selected) async {
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
          'Excellent! The answer is '
          '${_question.answer.name}.',
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
          _showHint ? 'Look for the glowing shape.' : 'Nice try. Try again.',
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
        'Wonderful! You completed the shapes quiz. '
        'You earned $_score stars.',
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

    _animationController.forward(from: 0);

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
      backgroundColor: const Color(0xFFF5F1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB59CFF),
        foregroundColor: const Color(0xFF302454),
        centerTitle: true,
        title: const Text(
          'Shapes Quiz',
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
                'Question ${_questionIndex + 1}/'
                '$totalQuestions',
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
                    backgroundColor: const Color(0xFFE1D8FF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF7C5CE5),
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
                  _question.type == ShapeQuestionType.identifyShape
                      ? 'What shape is this?'
                      : 'Which shape looks like the '
                            '${_question.answer.exampleName}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF463968),
                  ),
                ),
                const SizedBox(height: 18),
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 245,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8FF),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _question.answer.color,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: _question.type == ShapeQuestionType.identifyShape
                          ? CustomPaint(
                              size: const Size(190, 190),
                              painter: QuizShapePainter(
                                type: _question.answer.type,
                                color: _question.answer.color,
                              ),
                            )
                          : Text(
                              _question.answer.emoji,
                              style: const TextStyle(fontSize: 145),
                            ),
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
              childAspectRatio: 1.38,
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

  Widget _buildAnswerButton(LearningShape option) {
    final correct = option.name == _question.answer.name;

    final selected = option.name == _selectedAnswer;

    final revealCorrect = _answerLocked && correct;

    final showWrong = selected && !correct;

    final hint = _showHint && correct;

    Color background = Colors.white;
    Color border = option.color;

    if (revealCorrect || hint) {
      background = const Color(0xFFDDF7E8);
      border = const Color(0xFF37B66A);
    } else if (showWrong) {
      background = const Color(0xFFFFE1E1);
      border = const Color(0xFFFF5A68);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: border,
          width: revealCorrect || hint || showWrong ? 6 : 3,
        ),
        boxShadow: hint
            ? const [
                BoxShadow(
                  color: Color(0x6637B66A),
                  blurRadius: 18,
                  spreadRadius: 3,
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 8,
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
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CustomPaint(
                    painter: QuizShapePainter(
                      type: option.type,
                      color: option.color,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    option.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF362D4C),
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
    String message = 'Choose the correct shape.';
    Color background = const Color(0xFFEDE6FF);
    Color border = const Color(0xFFAC91E8);

    if (_answerLocked) {
      icon = '🎉';
      message = 'Excellent, Little Hero!';
      background = const Color(0xFFDDF7E8);
      border = const Color(0xFF65C98C);
    } else if (_selectedAnswer != null) {
      icon = _showHint ? '💡' : '💪';
      message = _showHint
          ? 'Look for the glowing shape!'
          : 'Nice try! Try again.';
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
              message,
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
      title = 'Shape Champion!';
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
              colors: [Colors.white, Color(0xFFE9E2FF)],
            ),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF7C5CE5), width: 4),
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
                  color: Color(0xFF44336F),
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
                  side: const BorderSide(color: Color(0xFF7C5CE5), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.category_rounded),
                label: const Text(
                  'Back to Shapes',
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

class QuizShapePainter extends CustomPainter {
  final LearningShapeType type;
  final Color color;

  const QuizShapePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final rect = Rect.fromLTWH(5, 5, size.width - 10, size.height - 10);

    final path = _createPath(rect);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createPath(Rect rect) {
    switch (type) {
      case LearningShapeType.circle:
        return Path()..addOval(
          Rect.fromCircle(
            center: rect.center,
            radius: math.min(rect.width, rect.height) / 2,
          ),
        );

      case LearningShapeType.square:
        final side = math.min(rect.width, rect.height);

        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: rect.center, width: side, height: side),
            const Radius.circular(8),
          ),
        );

      case LearningShapeType.triangle:
        return Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();

      case LearningShapeType.rectangle:
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: rect.center,
              width: rect.width,
              height: rect.height * 0.62,
            ),
            const Radius.circular(8),
          ),
        );

      case LearningShapeType.oval:
        return Path()..addOval(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width,
            height: rect.height * 0.62,
          ),
        );

      case LearningShapeType.star:
        return _starPath(rect.center, math.min(rect.width, rect.height) / 2);

      case LearningShapeType.heart:
        return _heartPath(rect);

      case LearningShapeType.diamond:
        return Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.center.dy)
          ..lineTo(rect.center.dx, rect.bottom)
          ..lineTo(rect.left, rect.center.dy)
          ..close();

      case LearningShapeType.pentagon:
        return _polygonPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          5,
        );

      case LearningShapeType.hexagon:
        return _polygonPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          6,
        );

      case LearningShapeType.octagon:
        return _polygonPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          8,
        );

      case LearningShapeType.crescent:
        final outer = Path()
          ..addOval(
            Rect.fromCircle(
              center: rect.center,
              radius: math.min(rect.width, rect.height) / 2,
            ),
          );

        final inner = Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(
                rect.center.dx + rect.width * 0.18,
                rect.center.dy - rect.height * 0.08,
              ),
              radius: math.min(rect.width, rect.height) * 0.42,
            ),
          );

        return Path.combine(PathOperation.difference, outer, inner);
    }
  }

  Path _polygonPath(Offset center, double radius, int sides) {
    final path = Path();

    for (var index = 0; index < sides; index++) {
      final angle = -math.pi / 2 + 2 * math.pi * index / sides;

      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    return path..close();
  }

  Path _starPath(Offset center, double radius) {
    final path = Path();
    final innerRadius = radius * 0.45;

    for (var index = 0; index < 10; index++) {
      final currentRadius = index.isEven ? radius : innerRadius;

      final angle = -math.pi / 2 + math.pi * index / 5;

      final point = Offset(
        center.dx + currentRadius * math.cos(angle),
        center.dy + currentRadius * math.sin(angle),
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    return path..close();
  }

  Path _heartPath(Rect rect) {
    return Path()
      ..moveTo(rect.center.dx, rect.bottom)
      ..cubicTo(
        rect.left,
        rect.height * 0.65 + rect.top,
        rect.left,
        rect.height * 0.15 + rect.top,
        rect.center.dx,
        rect.height * 0.35 + rect.top,
      )
      ..cubicTo(
        rect.right,
        rect.height * 0.15 + rect.top,
        rect.right,
        rect.height * 0.65 + rect.top,
        rect.center.dx,
        rect.bottom,
      )
      ..close();
  }

  @override
  bool shouldRepaint(covariant QuizShapePainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
