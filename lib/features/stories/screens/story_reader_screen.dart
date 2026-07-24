import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/story_item.dart';

class StoryReaderScreen extends StatefulWidget {
  final StoryItem story;

  const StoryReaderScreen({required this.story, super.key});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  late final AnimationController _animationController;
  late final Animation<double> _pageAnimation;

  int _pageIndex = 0;
  bool _isSpeaking = false;
  bool _autoPlay = false;

  StoryPageItem get _page => widget.story.pages[_pageIndex];

  bool get _isLastPage => _pageIndex == widget.story.pages.length - 1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pageAnimation = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _configureVoice();
  }

  Future<void> _configureVoice() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.04);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (mounted) {
      await _speakCurrentPage();
    }
  }

  Future<void> _speakText(String text) async {
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

  Future<void> _speakCurrentPage() async {
    await _speakText(_page.text);

    if (_autoPlay && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (_isLastPage) {
        setState(() {
          _autoPlay = false;
        });

        await _speakText(
          'The moral of the story is: '
          '${widget.story.moral}',
        );
      } else {
        await _changePage(_pageIndex + 1);
      }
    }
  }

  Future<void> _changePage(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.story.pages.length) {
      return;
    }

    await _flutterTts.stop();

    if (!mounted) {
      return;
    }

    setState(() {
      _pageIndex = newIndex;
      _isSpeaking = false;
    });

    _animationController.forward(from: 0);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _speakCurrentPage();
    }
  }

  Future<void> _toggleAutoPlay() async {
    if (_autoPlay) {
      setState(() {
        _autoPlay = false;
      });

      await _flutterTts.stop();

      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
      return;
    }

    setState(() {
      _autoPlay = true;
    });

    await _speakCurrentPage();
  }

  Future<void> _speakMoral() async {
    await _speakText(
      'The moral of the story is: '
      '${widget.story.moral}',
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCDB4FF),
        foregroundColor: const Color(0xFF35284F),
        centerTitle: true,
        title: Text(
          widget.story.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: _autoPlay ? 'Stop story' : 'Play full story',
            onPressed: _toggleAutoPlay,
            icon: Icon(
              _autoPlay
                  ? Icons.stop_circle_rounded
                  : Icons.play_circle_fill_rounded,
              size: 31,
            ),
          ),
          IconButton(
            tooltip: 'Listen again',
            onPressed: _speakCurrentPage,
            icon: Icon(
              _isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              size: 29,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            children: [
              _buildProgress(),
              const SizedBox(height: 18),
              _buildStoryPage(),
              const SizedBox(height: 18),
              if (_isLastPage) _buildMoralCard(),
              if (_isLastPage) const SizedBox(height: 18),
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
          'Page ${_pageIndex + 1} / '
          '${widget.story.pages.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 13,
              value: (_pageIndex + 1) / widget.story.pages.length,
              backgroundColor: const Color(0xFFE8DEFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF7B5BC7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('📖', style: TextStyle(fontSize: 23)),
      ],
    );
  }

  Widget _buildStoryPage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFF9B78E3), width: 4),
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
          ScaleTransition(
            scale: _pageAnimation,
            child: Container(
              width: double.infinity,
              height: 285,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF2C9), Color(0xFFEDE4FF)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFBEA5F0), width: 3),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _page.emoji,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 150),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            _page.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              height: 1.45,
              fontWeight: FontWeight.w800,
              color: Color(0xFF463A51),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _speakCurrentPage,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C52B3),
              minimumSize: const Size(230, 58),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            icon: Icon(
              _isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              size: 28,
            ),
            label: Text(
              _isSpeaking ? 'Reading...' : 'Listen again',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoralCard() {
    return Material(
      color: const Color(0xFFE6F8EC),
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: _speakMoral,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFF65C98C), width: 3),
          ),
          child: Column(
            children: [
              const Text(
                '🏆 Story Moral',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF27523A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.story.moral,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF315940),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap to hear the moral',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _pageIndex == 0
                ? () => Navigator.pop(context)
                : () => _changePage(_pageIndex - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              side: const BorderSide(color: Color(0xFF7B5BC7), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(
              _pageIndex == 0 ? 'Stories' : 'Previous',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _isLastPage
                ? () => Navigator.pop(context)
                : () => _changePage(_pageIndex + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              backgroundColor: _isLastPage
                  ? const Color(0xFF39A96B)
                  : const Color(0xFF7B5BC7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: Icon(
              _isLastPage
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              _isLastPage ? 'Finish Story' : 'Next',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
