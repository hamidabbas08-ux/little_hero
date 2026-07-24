import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/number_progress.dart';
import '../data/number_words.dart';

class NumberQuizScreen extends StatefulWidget {
  final int level;
  final int startNumber;
  final int endNumber;

  const NumberQuizScreen({
    required this.level,
    required this.startNumber,
    required this.endNumber,
    super.key,
  });

  @override
  State<NumberQuizScreen> createState() => _NumberQuizScreenState();
}

class _NumberQuestion {
  final int answer;
  final bool showObjects;
  final List<int> options;

  const _NumberQuestion({
    required this.answer,
    required this.showObjects,
    required this.options,
  });
}

class _NumberQuizScreenState extends State<NumberQuizScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;
  static const int passingScore = 7;

  final Random _random = Random();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  late final AnimationController _animationController;
  late final Animation<double> _answerAnimation;

  List<_NumberQuestion> _questions = [];

  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;

  int? _selectedAnswer;

  bool _answerLocked = false;
  bool _showHint = false;
  bool _quizFinished = false;
  bool _passed = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  _NumberQuestion get _question => _questions[_questionIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _answerAnimation = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _createQuestions();
    _configureAudio();
  }

  void _createQuestions() {
    final availableNumbers = List<int>.generate(
      widget.endNumber - widget.startNumber + 1,
      (index) => widget.startNumber + index,
    )..shuffle(_random);

    _questions = List<_NumberQuestion>.generate(totalQuestions, (index) {
      final answer = availableNumbers[index % availableNumbers.length];

      final wrongAnswers = <int>{};

      while (wrongAnswers.length < 3) {
        final candidate =
            widget.startNumber +
            _random.nextInt(widget.endNumber - widget.startNumber + 1);

        if (candidate != answer) {
          wrongAnswers.add(candidate);
        }
      }

      final options = <int>[answer, ...wrongAnswers]..shuffle(_random);

      return _NumberQuestion(
        answer: answer,
        showObjects: index.isOdd,
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

    if (_question.showObjects) {
      await _flutterTts.speak(
        'How many are shown? '
        'Tap the correct number.',
      );
    } else {
      await _flutterTts.speak(
        'Find number ${numberToWords(_question.answer)}. '
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

  Future<void> _selectAnswer(int answer) async {
    if (_answerLocked || _quizFinished) {
      return;
    }

    setState(() {
      _selectedAnswer = answer;
    });

    if (answer == _question.answer) {
      setState(() {
        _answerLocked = true;
        _score++;
        _showHint = false;
      });

      _animationController.forward(from: 0);

      await _playEffect('audio/effects/correct.wav');

      if (_soundEnabled) {
        await _flutterTts.speak(
          'Excellent! The answer is '
          '${numberToWords(_question.answer)}.',
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
          _showHint ? 'Look for the glowing answer.' : 'Nice try. Try again.',
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

    final passed = _score >= passingScore;

    if (passed) {
      await NumberProgress.unlockNextLevel(widget.level);
    }

    setState(() {
      _passed = passed;
      _quizFinished = true;
    });

    await _playEffect('audio/effects/quiz_complete.wav');

    if (_soundEnabled) {
      if (passed) {
        await _flutterTts.speak(
          'Wonderful! You passed level '
          '${widget.level}. The next level is unlocked.',
        );
      } else {
        await _flutterTts.speak(
          'Good effort. Practise again and '
          'try the quiz one more time.',
        );
      }
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
      _passed = false;
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
      backgroundColor: const Color(0xFFFFF8D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF61D095),
        foregroundColor: const Color(0xFF153D29),
        centerTitle: true,
        title: Text(
          'Level ${widget.level} Quiz',
          style: const TextStyle(fontWeight: FontWeight.w900),
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
                    backgroundColor: const Color(0xFFCFF3DF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF22A668),
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
              border: Border.all(color: const Color(0xFF61D095), width: 3),
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
                  _question.showObjects
                      ? 'How many are shown?'
                      : 'Find this number',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF294936),
                  ),
                ),
                const SizedBox(height: 18),
                ScaleTransition(
                  scale: _answerAnimation,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 230),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6C9),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFFCF62),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: _question.showObjects
                          ? _buildObjects(_question.answer)
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_question.answer}',
                                style: const TextStyle(
                                  fontSize: 145,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF6C52B3),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
              childAspectRatio: 1.55,
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

  Widget _buildObjects(int number) {
    if (number <= 20) {
      return Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 7,
        runSpacing: 7,
        children: List<Widget>.generate(
          number,
          (index) => const Text('⭐', style: TextStyle(fontSize: 32)),
        ),
      );
    }

    final tens = number ~/ 10;
    final ones = number % 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 7,
          runSpacing: 7,
          children: List<Widget>.generate(
            tens,
            (index) => Container(
              width: 66,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF9DE6BD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF38A96B), width: 2),
              ),
              child: const Text(
                '10 ⭐',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        if (ones > 0) ...[
          const SizedBox(height: 13),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            children: List<Widget>.generate(
              ones,
              (index) => const Text('⭐', style: TextStyle(fontSize: 27)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnswerButton(int answer) {
    final correct = answer == _question.answer;
    final selected = answer == _selectedAnswer;

    final revealCorrect = _answerLocked && correct;
    final showWrong = selected && !correct;
    final hint = _showHint && correct;

    Color background = Colors.white;
    Color border = const Color(0xFF6C63FF);
    Color foreground = const Color(0xFF312A48);

    if (revealCorrect || hint) {
      background = const Color(0xFFDDF7E8);
      border = const Color(0xFF37B66A);
      foreground = const Color(0xFF17683A);
    } else if (showWrong) {
      background = const Color(0xFFFFE1E1);
      border = const Color(0xFFFF7777);
      foreground = const Color(0xFF9C2525);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: hint ? 5 : 3),
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
          onTap: () => _selectAnswer(answer),
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '$answer',
                  style: TextStyle(
                    fontSize: 53,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: foreground,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    String icon = '🦸';
    String message = 'Choose the correct answer.';
    Color background = const Color(0xFFE9E4FF);
    Color border = const Color(0xFF9B7EDE);

    if (_answerLocked) {
      icon = '🎉';
      message = 'Excellent, Little Hero!';
      background = const Color(0xFFDDF7E8);
      border = const Color(0xFF65C98C);
    } else if (_selectedAnswer != null) {
      icon = _showHint ? '💡' : '💪';
      message = _showHint
          ? 'Look for the glowing answer!'
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
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: _passed
                  ? const Color(0xFF61D095)
                  : const Color(0xFFFFB85C),
              width: 4,
            ),
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
              Text(
                _passed ? '🏆' : '💪',
                style: const TextStyle(fontSize: 100),
              ),
              Text(
                _passed ? 'Level ${widget.level} Passed!' : 'Keep Practising!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF392F5A),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '$_score / $totalQuestions',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6C52B3),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _passed
                    ? widget.level < 5
                          ? 'Level ${widget.level + 1} is now unlocked!'
                          : 'All Number Levels completed!'
                    : 'You need $passingScore correct answers.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
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
                onPressed: () {
                  Navigator.pop(context, _passed);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: Color(0xFF6C52B3), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text(
                  'Back to Levels',
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
