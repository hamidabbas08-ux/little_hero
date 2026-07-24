import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/shape_item.dart';

class ShapeLessonScreen extends StatefulWidget {
  const ShapeLessonScreen({super.key});

  @override
  State<ShapeLessonScreen> createState() => _ShapeLessonScreenState();
}

class _ShapeLessonScreenState extends State<ShapeLessonScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _animationController;
  late final Animation<double> _shapeAnimation;

  int _currentIndex = 0;
  bool _isSpeaking = false;

  LearningShape get _currentShape => learningShapes[_currentIndex];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _shapeAnimation = Tween<double>(begin: 0.82, end: 1).animate(
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

  Future<void> _speakShape() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentShape.name}. '
      'This is a ${_currentShape.name.toLowerCase()}.',
    );
  }

  Future<void> _speakExample() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentShape.exampleName}. '
      'The ${_currentShape.exampleName.toLowerCase()} '
      'looks like a ${_currentShape.name.toLowerCase()}.',
    );
  }

  Future<void> _speakLesson() async {
    _animationController.forward(from: 0);

    await _speak(
      '${_currentShape.name}. '
      'This is a ${_currentShape.name.toLowerCase()}. '
      '${_currentShape.exampleName} is an example.',
    );
  }

  Future<void> _changeShape(int index) async {
    if (index < 0 || index >= learningShapes.length) {
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      await _speakLesson();
    }
  }

  void _showShapePicker() {
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
                const Text(
                  'Choose a Shape',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 17),
                Expanded(
                  child: GridView.builder(
                    itemCount: learningShapes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 11,
                          mainAxisSpacing: 11,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      final shape = learningShapes[index];
                      final selected = index == _currentIndex;

                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(sheetContext);
                            _changeShape(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF6C52B3)
                                    : shape.color,
                                width: selected ? 5 : 3,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 54,
                                  height: 54,
                                  child: CustomPaint(
                                    painter: ShapePainter(
                                      type: shape.type,
                                      color: shape.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    shape.name,
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
    final isLast = _currentIndex == learningShapes.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB59CFF),
        foregroundColor: const Color(0xFF302454),
        centerTitle: true,
        title: const Text(
          'Shapes',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Choose shape',
            onPressed: _showShapePicker,
            icon: const Icon(Icons.category_rounded, size: 29),
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
              _buildShapeCard(),
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
          '${_currentIndex + 1} / ${learningShapes.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4C3F73),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 13,
              value: (_currentIndex + 1) / learningShapes.length,
              backgroundColor: const Color(0xFFE1D8FF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF7C5CE5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('🔷', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  Widget _buildShapeCard() {
    final shape = _currentShape;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: shape.color, width: 4),
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
            'Tap the shape or example',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF655E77),
            ),
          ),
          const SizedBox(height: 18),
          ScaleTransition(
            scale: _shapeAnimation,
            child: Material(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(32),
              child: InkWell(
                onTap: _speakShape,
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: double.infinity,
                  height: 255,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: shape.color, width: 3),
                  ),
                  child: CustomPaint(
                    painter: ShapePainter(type: shape.type, color: shape.color),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            shape.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: shape.color,
            ),
          ),
          const SizedBox(height: 17),
          Material(
            color: const Color(0xFFFFF6D8),
            borderRadius: BorderRadius.circular(27),
            child: InkWell(
              onTap: _speakExample,
              borderRadius: BorderRadius.circular(27),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(color: const Color(0xFFFFCE56), width: 3),
                ),
                child: Column(
                  children: [
                    Text(shape.emoji, style: const TextStyle(fontSize: 105)),
                    const SizedBox(height: 8),
                    Text(
                      shape.exampleName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF59471E),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${shape.name} example',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF74623B),
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
    final completed = _currentIndex == learningShapes.length - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F8EE),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFF72CC98), width: 2),
      ),
      child: Row(
        children: [
          Text(completed ? '🏆' : '🦸', style: const TextStyle(fontSize: 43)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              completed
                  ? 'Amazing! You learned all the shapes.'
                  : 'Great! This is a ${_currentShape.name.toLowerCase()}.',
              style: const TextStyle(
                fontSize: 17,
                height: 1.3,
                fontWeight: FontWeight.w900,
                color: Color(0xFF315940),
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
                : () => _changeShape(_currentIndex - 1),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              side: const BorderSide(color: Color(0xFF7C5CE5), width: 2),
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
                        content: Text('Shapes Quiz will be added next!'),
                      ),
                    );
                  }
                : () => _changeShape(_currentIndex + 1),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(57),
              backgroundColor: isLast
                  ? const Color(0xFF6C52B3)
                  : const Color(0xFF7C5CE5),
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

class ShapePainter extends CustomPainter {
  final LearningShapeType type;
  final Color color;

  const ShapePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final bounds = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);

    final path = _createPath(bounds);

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
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
            const Radius.circular(10),
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
              height: rect.height * 0.65,
            ),
            const Radius.circular(10),
          ),
        );

      case LearningShapeType.oval:
        return Path()..addOval(
          Rect.fromCenter(
            center: rect.center,
            width: rect.width,
            height: rect.height * 0.65,
          ),
        );

      case LearningShapeType.star:
        return _regularStarPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          5,
        );

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
        return _regularPolygonPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          5,
        );

      case LearningShapeType.hexagon:
        return _regularPolygonPath(
          rect.center,
          math.min(rect.width, rect.height) / 2,
          6,
        );

      case LearningShapeType.octagon:
        return _regularPolygonPath(
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

  Path _regularPolygonPath(Offset center, double radius, int sides) {
    final path = Path();

    for (var index = 0; index < sides; index++) {
      final angle = -math.pi / 2 + (2 * math.pi * index / sides);

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

  Path _regularStarPath(Offset center, double radius, int points) {
    final path = Path();
    final innerRadius = radius * 0.45;

    for (var index = 0; index < points * 2; index++) {
      final currentRadius = index.isEven ? radius : innerRadius;

      final angle = -math.pi / 2 + math.pi * index / points;

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
    final path = Path();

    path.moveTo(rect.center.dx, rect.bottom);

    path.cubicTo(
      rect.left - rect.width * 0.05,
      rect.height * 0.65 + rect.top,
      rect.left,
      rect.height * 0.18 + rect.top,
      rect.center.dx,
      rect.height * 0.35 + rect.top,
    );

    path.cubicTo(
      rect.right,
      rect.height * 0.18 + rect.top,
      rect.right + rect.width * 0.05,
      rect.height * 0.65 + rect.top,
      rect.center.dx,
      rect.bottom,
    );

    return path..close();
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
