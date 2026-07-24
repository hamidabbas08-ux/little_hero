import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizAlphabetItem {
  final String letter;
  final String word;
  final String picture;
  final Color color;

  const QuizAlphabetItem({
    required this.letter,
    required this.word,
    required this.picture,
    required this.color,
  });
}

const List<QuizAlphabetItem> quizAlphabetItems = [
  QuizAlphabetItem(
    letter: 'A',
    word: 'Apple',
    picture: '🍎',
    color: Color(0xFFFF5A5F),
  ),
  QuizAlphabetItem(
    letter: 'B',
    word: 'Ball',
    picture: '⚽',
    color: Color(0xFF4895EF),
  ),
  QuizAlphabetItem(
    letter: 'C',
    word: 'Cat',
    picture: '🐱',
    color: Color(0xFFFF9F43),
  ),
  QuizAlphabetItem(
    letter: 'D',
    word: 'Dog',
    picture: '🐶',
    color: Color(0xFF9B6B43),
  ),
  QuizAlphabetItem(
    letter: 'E',
    word: 'Elephant',
    picture: '🐘',
    color: Color(0xFF718093),
  ),
  QuizAlphabetItem(
    letter: 'F',
    word: 'Fish',
    picture: '🐟',
    color: Color(0xFF00A8CC),
  ),
  QuizAlphabetItem(
    letter: 'G',
    word: 'Grapes',
    picture: '🍇',
    color: Color(0xFF8E44AD),
  ),
  QuizAlphabetItem(
    letter: 'H',
    word: 'House',
    picture: '🏠',
    color: Color(0xFFE67E22),
  ),
  QuizAlphabetItem(
    letter: 'I',
    word: 'Ice Cream',
    picture: '🍦',
    color: Color(0xFFFF77A9),
  ),
  QuizAlphabetItem(
    letter: 'J',
    word: 'Juice',
    picture: '🧃',
    color: Color(0xFFFF8C42),
  ),
  QuizAlphabetItem(
    letter: 'K',
    word: 'Kite',
    picture: '🪁',
    color: Color(0xFF6C63FF),
  ),
  QuizAlphabetItem(
    letter: 'L',
    word: 'Lion',
    picture: '🦁',
    color: Color(0xFFF4B942),
  ),
  QuizAlphabetItem(
    letter: 'M',
    word: 'Mango',
    picture: '🥭',
    color: Color(0xFFFFB000),
  ),
  QuizAlphabetItem(
    letter: 'N',
    word: 'Nest',
    picture: '🪺',
    color: Color(0xFF8B5E3C),
  ),
  QuizAlphabetItem(
    letter: 'O',
    word: 'Orange',
    picture: '🍊',
    color: Color(0xFFFF7A00),
  ),
  QuizAlphabetItem(
    letter: 'P',
    word: 'Parrot',
    picture: '🦜',
    color: Color(0xFF27AE60),
  ),
  QuizAlphabetItem(
    letter: 'Q',
    word: 'Queen',
    picture: '👸',
    color: Color(0xFFC039C7),
  ),
  QuizAlphabetItem(
    letter: 'R',
    word: 'Rabbit',
    picture: '🐰',
    color: Color(0xFFFF8FAB),
  ),
  QuizAlphabetItem(
    letter: 'S',
    word: 'Sun',
    picture: '☀️',
    color: Color(0xFFFFC107),
  ),
  QuizAlphabetItem(
    letter: 'T',
    word: 'Tiger',
    picture: '🐯',
    color: Color(0xFFFF8A00),
  ),
  QuizAlphabetItem(
    letter: 'U',
    word: 'Umbrella',
    picture: '☂️',
    color: Color(0xFF3498DB),
  ),
  QuizAlphabetItem(
    letter: 'V',
    word: 'Van',
    picture: '🚐',
    color: Color(0xFF607D8B),
  ),
  QuizAlphabetItem(
    letter: 'W',
    word: 'Watermelon',
    picture: '🍉',
    color: Color(0xFF2EAD63),
  ),
  QuizAlphabetItem(
    letter: 'X',
    word: 'Xylophone',
    picture: '🎵',
    color: Color(0xFF9C6ADE),
  ),
  QuizAlphabetItem(
    letter: 'Y',
    word: 'Yacht',
    picture: '⛵',
    color: Color(0xFF169ED9),
  ),
  QuizAlphabetItem(
    letter: 'Z',
    word: 'Zebra',
    picture: '🦓',
    color: Color(0xFF444444),
  ),
];

class AlphabetQuizScreen extends StatefulWidget {
  const AlphabetQuizScreen({super.key});

  @override
  State<AlphabetQuizScreen> createState() => _AlphabetQuizScreenState();
}

class _AlphabetQuizScreenState extends State<AlphabetQuizScreen>
    with SingleTickerProviderStateMixin {
  static const int totalQuestions = 10;

  final Random _random = Random();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  late final AnimationController _celebrationController;
  late final Animation<double> _celebrationAnimation;

  List<QuizAlphabetItem> _questions = [];
  List<String> _options = [];

  int _questionIndex = 0;
  int _score = 0;
  int _wrongAttempts = 0;

  String? _selectedLetter;
  bool _answeredCorrectly = false;
  bool _showHint = false;
  bool _quizFinished = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  QuizAlphabetItem get _currentQuestion => _questions[_questionIndex];

  @override
  void initState() {
    super.initState();

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _celebrationAnimation = Tween<double>(begin: 0.75, end: 1.15).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    _prepareQuiz();
    _configureAudio();
  }

  void _prepareQuiz() {
    final shuffled = List<QuizAlphabetItem>.from(quizAlphabetItems)
      ..shuffle(_random);

    _questions = shuffled.take(totalQuestions).toList();
    _prepareOptions();
  }

  void _prepareOptions() {
    final correct = _currentQuestion.letter;

    final incorrect =
        quizAlphabetItems
            .where((item) => item.letter != correct)
            .map((item) => item.letter)
            .toList()
          ..shuffle(_random);

    _options = <String>[correct, ...incorrect.take(3)]..shuffle(_random);
  }

  Future<void> _configureAudio() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.40);
    await _flutterTts.setPitch(1.08);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.13);

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
      await _musicPlayer.setVolume(0.035);
    }

    await _flutterTts.stop();

    await _flutterTts.speak(
      'Which letter is for ${_currentQuestion.word}? '
      'Tap the correct letter.',
    );

    if (_musicEnabled && mounted) {
      await _musicPlayer.setVolume(0.13);
    }
  }

  Future<void> _playEffect(String asset) async {
    if (!_soundEnabled) {
      return;
    }

    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource(asset));
  }

  Future<void> _chooseAnswer(String letter) async {
    if (_answeredCorrectly || _quizFinished) {
      return;
    }

    setState(() {
      _selectedLetter = letter;
    });

    if (letter == _currentQuestion.letter) {
      setState(() {
        _answeredCorrectly = true;
        _score++;
        _showHint = false;
      });

      _celebrationController.forward(from: 0);

      await _playEffect('audio/effects/correct.wav');

      if (_soundEnabled) {
        await _flutterTts.speak(
          'Great job! ${_currentQuestion.letter} is for '
          '${_currentQuestion.word}.',
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
          _wrongAttempts >= 2
              ? 'Almost there. Look for the glowing letter.'
              : 'Nice try. You can do it. Try again.',
        );
      }
    }
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      _wrongAttempts = 0;
      _selectedLetter = null;
      _answeredCorrectly = false;
      _showHint = false;
      _prepareOptions();
    });

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
        'Wonderful! You completed the alphabet quiz. '
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
      _selectedLetter = null;
      _answeredCorrectly = false;
      _showHint = false;
      _quizFinished = false;
      _prepareQuiz();
    });

    if (_musicEnabled) {
      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.13);
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
      await _musicPlayer.setVolume(0.13);
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
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9B7EDE),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Alphabet Quiz',
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
        child: _quizFinished ? _buildResultScreen() : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = _currentQuestion;

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
                    backgroundColor: const Color(0xFFE5DAFF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF7A5CC8),
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: question.color, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Which letter is for this?',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF312A48),
                  ),
                ),
                const SizedBox(height: 12),
                ScaleTransition(
                  scale: _celebrationAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 245,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: question.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: question.color.withValues(alpha: 0.65),
                        width: 3,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        question.picture,
                        style: const TextStyle(fontSize: 160),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  question.word,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: question.color,
                  ),
                ),
                const SizedBox(height: 8),
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
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final letter = _options[index];
              return _buildAnswerButton(letter);
            },
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _answeredCorrectly
                ? const _FeedbackBanner(
                    key: ValueKey('correct'),
                    icon: '🎉',
                    text: 'Great job, Little Hero!',
                    background: Color(0xFFDFF7E8),
                    border: Color(0xFF65C98C),
                    foreground: Color(0xFF245C39),
                  )
                : _selectedLetter != null
                ? _FeedbackBanner(
                    key: const ValueKey('try-again'),
                    icon: _showHint ? '💡' : '💪',
                    text: _showHint
                        ? 'Look for the glowing answer!'
                        : 'Nice try! Try one more time.',
                    background: const Color(0xFFFFEEC7),
                    border: const Color(0xFFFFC857),
                    foreground: const Color(0xFF6E4D00),
                  )
                : const _FeedbackBanner(
                    key: ValueKey('ready'),
                    icon: '🦸',
                    text: 'Choose the correct letter.',
                    background: Color(0xFFE9E4FF),
                    border: Color(0xFF9B7EDE),
                    foreground: Color(0xFF49377C),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String letter) {
    final isCorrect = letter == _currentQuestion.letter;
    final isSelected = letter == _selectedLetter;
    final revealCorrect = _answeredCorrectly && isCorrect;
    final showWrong = isSelected && !isCorrect;
    final showHint = _showHint && isCorrect;

    Color background = Colors.white;
    Color border = const Color(0xFF9B7EDE);
    Color foreground = const Color(0xFF312A48);

    if (revealCorrect || showHint) {
      background = const Color(0xFFD9F8E5);
      border = const Color(0xFF37B66A);
      foreground = const Color(0xFF17683A);
    } else if (showWrong) {
      background = const Color(0xFFFFE2E2);
      border = const Color(0xFFFF7777);
      foreground = const Color(0xFF9C2525);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: border, width: showHint ? 5 : 3),
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
                  color: Color(0x18000000),
                  blurRadius: 8,
                  offset: Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _chooseAnswer(letter),
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 58,
                height: 1,
                fontWeight: FontWeight.w900,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / totalQuestions * 100).round();

    String message;
    String trophy;

    if (_score >= 9) {
      message = 'Alphabet Champion!';
      trophy = '🏆';
    } else if (_score >= 7) {
      message = 'Amazing work!';
      trophy = '🥇';
    } else if (_score >= 5) {
      message = 'Great effort!';
      trophy = '⭐';
    } else {
      message = 'Keep practising!';
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
              colors: [Colors.white, Color(0xFFEAE3FF)],
            ),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF9B7EDE), width: 4),
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
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
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
              Text(
                '$percentage% correct',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF625B71),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: List.generate(
                  totalQuestions,
                  (index) => Text(
                    index < _score ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: _restartQuiz,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C52B3),
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.replay_rounded, size: 28),
                label: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: Color(0xFF6C52B3), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text(
                  'Back to Alphabet',
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

class _FeedbackBanner extends StatelessWidget {
  final String icon;
  final String text;
  final Color background;
  final Color border;
  final Color foreground;

  const _FeedbackBanner({
    required this.icon,
    required this.text,
    required this.background,
    required this.border,
    required this.foreground,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
