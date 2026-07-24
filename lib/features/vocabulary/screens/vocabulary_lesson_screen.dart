import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/vocabulary_item.dart';

class VocabularyLessonScreen extends StatefulWidget {
  final String title;
  final String pickerTitle;
  final String completionMessage;
  final String quizMessage;
  final String headerEmoji;
  final Color primaryColor;
  final Color backgroundColor;
  final List<VocabularyItem> items;

  const VocabularyLessonScreen({
    required this.title,
    required this.pickerTitle,
    required this.completionMessage,
    required this.quizMessage,
    required this.headerEmoji,
    required this.primaryColor,
    required this.backgroundColor,
    required this.items,
    super.key,
  });

  @override
  State<VocabularyLessonScreen> createState() => _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState extends State<VocabularyLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  int _currentIndex = 0;
  bool _isSpeaking = false;

  VocabularyItem get _currentItem => widget.items[_currentIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _bounceAnimation = Tween<double>(begin: 0.84, end: 1).animate(
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

  Future<void> _speakName() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentItem.name}. '
      'This is a ${_currentItem.name.toLowerCase()}.',
    );
  }

  Future<void> _speakLesson() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentItem.name}. '
      '${_currentItem.description} '
      '${_currentItem.extraSentence}',
    );
  }

  Future<void> _changeItem(int index) async {
    if (index < 0 || index >= widget.items.length) {
      return;
    }

    await _flutterTts.stop();

    if (!mounted) {
      return;
    }

    setState(() {
      _currentIndex = index;
      _isSpeaking = false;
    });

    _animationController.forward(from: 0);

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 220));

    if (mounted) {
      await _speakLesson();
    }
  }

  void _showPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFAED),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              children: [
                Text(
                  widget.pickerTitle,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: widget.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final selected = index == _currentIndex;

                      return Material(
                        color: widget.primaryColor.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _changeItem(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF6C52B3)
                                    : widget.primaryColor,
                                width: selected ? 5 : 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 44),
                                ),
                                const SizedBox(height: 6),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
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
    final isLast = _currentIndex == widget.items.length - 1;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        foregroundColor: const Color(0xFF30261C),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: widget.pickerTitle,
            onPressed: _showPicker,
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
              _buildItemCard(),
              const SizedBox(height: 18),
              _buildMessage(isLast),
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
          '${_currentIndex + 1} / ${widget.items.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 13,
              value: (_currentIndex + 1) / widget.items.length,
              backgroundColor: widget.primaryColor.withValues(alpha: 0.20),
              valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(widget.headerEmoji, style: const TextStyle(fontSize: 23)),
      ],
    );
  }

  Widget _buildItemCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: widget.primaryColor, width: 4),
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
            'Tap the picture to hear its name',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF62594E),
            ),
          ),
          const SizedBox(height: 17),
          ScaleTransition(
            scale: _bounceAnimation,
            child: Material(
              color: widget.primaryColor.withValues(alpha: 0.16),
              elevation: 4,
              borderRadius: BorderRadius.circular(35),
              child: InkWell(
                onTap: _speakName,
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: double.infinity,
                  height: 270,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: widget.primaryColor, width: 3),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _currentItem.emoji,
                        style: const TextStyle(fontSize: 170),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            _currentItem.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Color(0xFF46362B),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8EE),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFF79CC94), width: 2),
            ),
            child: Column(
              children: [
                Text(
                  _currentItem.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF315940),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentItem.extraSentence,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4C6756),
                  ),
                ),
              ],
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

  Widget _buildMessage(bool isLast) {
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
          Text(isLast ? '🏆' : '🦸', style: const TextStyle(fontSize: 43)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isLast
                  ? widget.completionMessage
                  : 'Great! This is a '
                        '${_currentItem.name.toLowerCase()}.',
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
                : () => _changeItem(_currentIndex - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              side: BorderSide(color: widget.primaryColor, width: 2),
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(widget.quizMessage)));
                  }
                : () => _changeItem(_currentIndex + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              backgroundColor: isLast
                  ? const Color(0xFF6C52B3)
                  : widget.primaryColor,
              foregroundColor: Colors.white,
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
