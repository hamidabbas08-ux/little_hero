import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/vocabulary_item.dart';

class VocabularyQuizScreen extends StatefulWidget {
  final String title;
  final List<VocabularyItem> items;
  final Color primaryColor;
  final Color backgroundColor;

  const VocabularyQuizScreen({
    required this.title,
    required this.items,
    required this.primaryColor,
    required this.backgroundColor,
    super.key,
  });

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _QuizQuestion {
  final VocabularyItem answer;
  final List<VocabularyItem> options;

  const _QuizQuestion({required this.answer, required this.options});
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;

  final Random _random = Random();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  List<_QuizQuestion> _questions = [];

  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;

  String? _selectedAnswer;

  bool _answerLocked = false;
  bool _showHint = false;
  bool _quizFinished = false;
  bool _musicEnabled = true;
  bool _soundEnabled = true;

  _QuizQuestion get _question => _questions[_questionIndex];

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
    _animationController.forward();
    _configureAudio();
  }

  void _createQuestions() {
    final shuffledItems = List<VocabularyItem>.from(widget.items)
      ..shuffle(_random);

    _questions = List<_QuizQuestion>.generate(totalQuestions, (index) {
      final answer = shuffledItems[index % shuffledItems.length];

      final wrongOptions =
          widget.items.where((item) => item.name != answer.name).toList()
            ..shuffle(_random);

      final options = <VocabularyItem>[answer, ...wrongOptions.take(3)]
        ..shuffle(_random);

      return _QuizQuestion(answer: answer, options: options);
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
    await _flutterTts.speak('What is this? Tap the correct name.');

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

  Future<void> _selectAnswer(VocabularyItem selected) async {
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
          'Excellent! This is '
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

    setState(() {
      _quizFinished = true;
    });

    await _playEffect('audio/effects/quiz_complete.wav');

    if (_soundEnabled) {
      await _flutterTts.speak(
        'Wonderful! You completed the '
        '${widget.title} quiz. '
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
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        foregroundColor: const Color(0xFF30261C),
        centerTitle: true,
        title: Text(
          '${widget.title} Quiz',
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
                    backgroundColor: widget.primaryColor.withValues(
                      alpha: 0.20,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.primaryColor,
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
              border: Border.all(color: widget.primaryColor, width: 4),
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
                const Text(
                  'What is this?',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: widget.primaryColor, width: 3),
                    ),
                    child: Text(
                      _question.answer.emoji,
                      style: const TextStyle(fontSize: 155),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
              childAspectRatio: 1.45,
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

  Widget _buildAnswerButton(VocabularyItem option) {
    final correct = option.name == _question.answer.name;
    final selected = option.name == _selectedAnswer;
    final revealCorrect = _answerLocked && correct;
    final showWrong = selected && !correct;
    final hint = _showHint && correct;

    Color background = Colors.white;
    Color border = widget.primaryColor;

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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  option.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3E3346),
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
    String message = 'Choose the correct name.';
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
    String title;
    String trophy;

    if (_score >= 9) {
      title = 'Quiz Champion!';
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: widget.primaryColor, width: 4),
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
              const SizedBox(height: 25),
              FilledButton.icon(
                onPressed: _restartQuiz,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C52B3),
                  minimumSize: const Size.fromHeight(58),
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
                  side: BorderSide(color: widget.primaryColor, width: 2),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Back to Learning',
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
