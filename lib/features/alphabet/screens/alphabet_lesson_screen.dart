import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AlphabetLessonScreen extends StatefulWidget {
  const AlphabetLessonScreen({super.key});

  @override
  State<AlphabetLessonScreen> createState() => _AlphabetLessonScreenState();
}

class _AlphabetLessonScreenState extends State<AlphabetLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  late final AnimationController _animationController;
  late final Animation<double> _bounceAnimation;

  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _bounceAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  Future<void> _speakLesson() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.12);
    await _flutterTts.setVolume(1);
    await _flutterTts.awaitSpeakCompletion(true);

    _animationController.forward(from: 0);

    try {
      await _flutterTts.speak('A. A for Apple. Apple.');
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  Future<void> _speakLetter() async {
    await _flutterTts.stop();
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.35);
    await _flutterTts.setPitch(1.15);
    await _flutterTts.speak('A');
  }

  Future<void> _speakWord() async {
    await _flutterTts.stop();
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.1);
    await _flutterTts.speak('Apple');
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
            tooltip: 'Hear the lesson',
            onPressed: _speakLesson,
            icon: Icon(
              _isSpeaking
                  ? Icons.volume_up_rounded
                  : Icons.record_voice_over_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 42,
                ),
                child: Column(
                  children: [
                    _lessonProgress(),
                    const SizedBox(height: 18),
                    _lessonCard(),
                    const SizedBox(height: 18),
                    _instructionCard(),
                    const SizedBox(height: 20),
                    _navigationButtons(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _lessonProgress() {
    return Row(
      children: [
        const Text(
          'Lesson 1 of 26',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF514A69),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              minHeight: 12,
              value: 1 / 26,
              backgroundColor: Color(0xFFFFE9A8),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7A59)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '⭐ 0',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _lessonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF0B8)],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFFFD166), width: 3),
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
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF625B71),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: _speakLetter,
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD166),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFFF8C42), width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'A',
                style: TextStyle(
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
            scale: _bounceAnimation,
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: _speakWord,
              child: Container(
                width: double.infinity,
                height: 245,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8FF),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF86D9F7), width: 3),
                ),
                child: const CustomPaint(painter: ApplePicturePainter()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'A',
                    style: TextStyle(color: Color(0xFFFF5A5F)),
                  ),
                  TextSpan(text: ' for '),
                  TextSpan(
                    text: 'Apple',
                    style: TextStyle(color: Color(0xFF39A96B)),
                  ),
                ],
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Color(0xFF28233A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _speakLesson,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              minimumSize: const Size(210, 56),
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

  Widget _instructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF7E8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF82D9A6), width: 2),
      ),
      child: const Row(
        children: [
          Text('🦸', style: TextStyle(fontSize: 42)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Great start, Little Hero! Tap A and the apple to hear them.',
              style: TextStyle(
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

  Widget _navigationButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              side: const BorderSide(color: Color(0xFF6C63FF), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text(
              'Home',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('B for Ball will be added in the next step.'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: const Color(0xFFFF7A59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text(
              'Next',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}

class ApplePicturePainter extends CustomPainter {
  const ApplePicturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 14);
    final appleWidth = math.min(size.width * 0.62, 180.0);
    final appleHeight = math.min(size.height * 0.64, 150.0);

    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + appleHeight * 0.53),
        width: appleWidth * 0.92,
        height: 20,
      ),
      shadowPaint,
    );

    final applePath = Path()
      ..moveTo(center.dx, center.dy - appleHeight * 0.38)
      ..cubicTo(
        center.dx - appleWidth * 0.16,
        center.dy - appleHeight * 0.60,
        center.dx - appleWidth * 0.52,
        center.dy - appleHeight * 0.48,
        center.dx - appleWidth * 0.50,
        center.dy - appleHeight * 0.05,
      )
      ..cubicTo(
        center.dx - appleWidth * 0.48,
        center.dy + appleHeight * 0.32,
        center.dx - appleWidth * 0.25,
        center.dy + appleHeight * 0.52,
        center.dx,
        center.dy + appleHeight * 0.45,
      )
      ..cubicTo(
        center.dx + appleWidth * 0.25,
        center.dy + appleHeight * 0.52,
        center.dx + appleWidth * 0.48,
        center.dy + appleHeight * 0.32,
        center.dx + appleWidth * 0.50,
        center.dy - appleHeight * 0.05,
      )
      ..cubicTo(
        center.dx + appleWidth * 0.52,
        center.dy - appleHeight * 0.48,
        center.dx + appleWidth * 0.16,
        center.dy - appleHeight * 0.60,
        center.dx,
        center.dy - appleHeight * 0.38,
      )
      ..close();

    final applePaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B6B), Color(0xFFE9203A), Color(0xFFB90D2B)],
          ).createShader(
            Rect.fromCenter(
              center: center,
              width: appleWidth,
              height: appleHeight,
            ),
          );

    canvas.drawPath(applePath, applePaint);

    final outlinePaint = Paint()
      ..color = const Color(0xFF9E1230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(applePath, outlinePaint);

    final highlightPaint = Paint()..color = const Color(0x88FFFFFF);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - appleWidth * 0.22,
          center.dy - appleHeight * 0.12,
        ),
        width: appleWidth * 0.13,
        height: appleHeight * 0.27,
      ),
      highlightPaint,
    );

    final stemPaint = Paint()
      ..color = const Color(0xFF71452D)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy - appleHeight * 0.40),
      Offset(center.dx + appleWidth * 0.05, center.dy - appleHeight * 0.67),
      stemPaint,
    );

    final leafPath = Path()
      ..moveTo(center.dx + appleWidth * 0.02, center.dy - appleHeight * 0.57)
      ..quadraticBezierTo(
        center.dx + appleWidth * 0.25,
        center.dy - appleHeight * 0.78,
        center.dx + appleWidth * 0.36,
        center.dy - appleHeight * 0.54,
      )
      ..quadraticBezierTo(
        center.dx + appleWidth * 0.18,
        center.dy - appleHeight * 0.42,
        center.dx + appleWidth * 0.02,
        center.dy - appleHeight * 0.57,
      )
      ..close();

    final leafPaint = Paint()
      ..shader =
          const LinearGradient(
            colors: [Color(0xFF7ED957), Color(0xFF218C4A)],
          ).createShader(
            Rect.fromCenter(
              center: Offset(
                center.dx + appleWidth * 0.18,
                center.dy - appleHeight * 0.58,
              ),
              width: appleWidth * 0.4,
              height: appleHeight * 0.35,
            ),
          );

    canvas.drawPath(leafPath, leafPaint);

    final facePaint = Paint()..color = const Color(0xFF3B2633);

    canvas.drawCircle(
      Offset(center.dx - appleWidth * 0.14, center.dy + appleHeight * 0.02),
      5,
      facePaint,
    );

    canvas.drawCircle(
      Offset(center.dx + appleWidth * 0.14, center.dy + appleHeight * 0.02),
      5,
      facePaint,
    );

    final smilePath = Path()
      ..moveTo(center.dx - appleWidth * 0.10, center.dy + appleHeight * 0.13)
      ..quadraticBezierTo(
        center.dx,
        center.dy + appleHeight * 0.22,
        center.dx + appleWidth * 0.10,
        center.dy + appleHeight * 0.13,
      );

    final smilePaint = Paint()
      ..color = const Color(0xFF3B2633)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant ApplePicturePainter oldDelegate) {
    return false;
  }
}
